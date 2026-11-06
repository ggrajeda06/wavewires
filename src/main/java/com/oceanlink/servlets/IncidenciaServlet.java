package com.oceanlink.servlets;

import com.oceanlink.beans.Incidencia;
import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.IncidenciaDao;
import com.oceanlink.daos.MantenimientoDao;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.ServicioDao;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.oceanlink.util.Seguridad;

@WebServlet(name = "IncidenciaServlet", value = "/IncidenciaServlet")
public class IncidenciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN,
                Seguridad.OPERADOR)) {
            return;
        }

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
            case "historial":
                // lista = incidencias activas, historial = todas (RF23)
                request.setAttribute("lista", incidenciaDao.listarIncidencias(action.equals("lista")));
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("modo", action);
                view = request.getRequestDispatcher("/WEB-INF/views/NetworkOperator/incidencias.jsp");
                view.forward(request, response);
                break;

            case "formCrear":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                view = request.getRequestDispatcher("/WEB-INF/views/NetworkOperator/incidencias_form.jsp");
                view.forward(request, response);
                break;

            case "ver":
                Incidencia incidenciaVer = incidenciaDao.obtenerIncidencia(numero(request.getParameter("id")));
                if (incidenciaVer == null) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                } else {
                    request.setAttribute("incidencia", incidenciaVer);
                    request.setAttribute("listaSegmentos", segmentoDao.listarSegmentosPorIncidencia(incidenciaVer.getIdIncidencia()));
                    request.setAttribute("listaAfectados", incidenciaDao.listarServiciosAfectados(incidenciaVer.getIdIncidencia()));
                    request.setAttribute("listaCorrectivos", mantenimientoDao.listarPorIncidencia(incidenciaVer.getIdIncidencia()));
                    view = request.getRequestDispatcher("NetworkOperator/verIncidencia.jsp");
                    view.forward(request, response);
                }
                break;

            case "editar":
                Incidencia incidenciaEditar = incidenciaDao.obtenerIncidencia(numero(request.getParameter("id")));
                if (incidenciaEditar == null) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                } else if (incidenciaEditar.getEstado().equals("Cerrada")) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=ver&id=" + incidenciaEditar.getIdIncidencia());
                } else {
                    request.setAttribute("incidencia", incidenciaEditar);
                    request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                    request.setAttribute("estadosPermitidos", estadosManuales(incidenciaEditar));
                    request.setAttribute("puedeCambiarSegmentos", puedeCambiarSegmentos(incidenciaEditar));
                    view = request.getRequestDispatcher("NetworkOperator/editarIncidencia.jsp");
                    view.forward(request, response);
                }
                break;

            case "estadoRed":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("listaActivas", incidenciaDao.listarIncidencias(true));
                request.setAttribute("listaServicios", new ServicioDao().listarServicios());
                view = request.getRequestDispatcher("NetworkOperator/estadoRed.jsp");
                view.forward(request, response);
                break;

            case "serviciosSegmento":
                // servicios vigentes de un segmento: aqui el NOC ve cuales se cayeron
                Segmento segmentoVer = segmentoDao.obtenerSegmento(numero(request.getParameter("id")));
                if (segmentoVer == null) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=estadoRed");
                } else {
                    request.setAttribute("segmento", segmentoVer);
                    request.setAttribute("listaServicios", new ServicioDao().listarServiciosPorSegmento(segmentoVer.getIdSegmento()));
                    view = request.getRequestDispatcher("NetworkOperator/serviciosSegmento.jsp");
                    view.forward(request, response);
                }
                break;

            case "restauraciones":
                request.setAttribute("listaRestauraciones", incidenciaDao.listarRestauraciones());
                view = request.getRequestDispatcher("NetworkOperator/restauracion.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                Incidencia incidenciaBorrar = incidenciaDao.obtenerIncidencia(numero(request.getParameter("id")));
                if (incidenciaBorrar == null) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                } else if (!incidenciaBorrar.getEstado().equals("Detectada")
                        || !mantenimientoDao.listarPorIncidencia(incidenciaBorrar.getIdIncidencia()).isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?error=noBorrable");
                } else {
                    incidenciaDao.eliminarIncidencia(incidenciaBorrar.getIdIncidencia());
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN,
                Seguridad.OPERADOR)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();

        switch (action) {
            case "crear":
                String severidad = texto(request.getParameter("severidad"));
                String observacion = texto(request.getParameter("observaciones"));
                String[] segmentosMarcados = request.getParameterValues("idSegmento");

                if (!severidadValida(severidad)) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=formCrear&error=severidad");
                } else if (observacion.length() > 1000) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=formCrear&error=observacion");
                } else if (segmentosMarcados == null || convertirIds(segmentosMarcados).isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=formCrear&error=segmentos");
                } else {
                    List<Integer> idsSegmentos = convertirIds(segmentosMarcados);

                    Incidencia nueva = new Incidencia();
                    nueva.setSeveridad(severidad);
                    nueva.setIdsSegmentos(idsSegmentos);
                    nueva.setIdsServicios(serviciosDeSegmentos(idsSegmentos));

                    int idNueva = incidenciaDao.crearIncidencia(nueva);
                    if (idNueva == 0) {
                        response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=formCrear&error=guardar");
                        break;
                    }
                    if (!observacion.isEmpty()) {
                        incidenciaDao.agregarObservacion(idNueva, observacion);
                    }
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=ver&id=" + idNueva);
                }
                break;

            case "actualizar":
                int idIncidencia = numero(request.getParameter("id"));
                Incidencia actual = incidenciaDao.obtenerIncidencia(idIncidencia);
                if (actual == null) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    break;
                }
                // una incidencia cerrada ya no se modifica
                if (actual.getEstado().equals("Cerrada")) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=ver&id=" + idIncidencia);
                    break;
                }

                String severidadEdit = texto(request.getParameter("severidad"));
                String nuevaObservacion = texto(request.getParameter("observacion"));
                String nuevoEstado = texto(request.getParameter("estado"));
                String[] segmentosEdit = request.getParameterValues("idSegmento");
                boolean cambiaSegmentos = puedeCambiarSegmentos(actual);
                String volver = request.getContextPath() + "/IncidenciaServlet?action=editar&id=" + idIncidencia;

                if (!severidadValida(severidadEdit)) {
                    response.sendRedirect(volver + "&error=severidad");
                } else if (nuevaObservacion.length() > 1000) {
                    response.sendRedirect(volver + "&error=observacion");
                } else if (cambiaSegmentos && (segmentosEdit == null || convertirIds(segmentosEdit).isEmpty())) {
                    response.sendRedirect(volver + "&error=segmentos");
                } else if (!nuevoEstado.isEmpty() && !estadosManuales(actual).contains(nuevoEstado)) {
                    response.sendRedirect(volver + "&error=estado");
                } else {
                    if (!severidadEdit.equals(actual.getSeveridad())) {
                        incidenciaDao.actualizarSeveridad(idIncidencia, severidadEdit);
                    }

                    if (cambiaSegmentos) {
                        List<Integer> nuevosSegmentos = convertirIds(segmentosEdit);
                        incidenciaDao.cambiarSegmentos(idIncidencia, nuevosSegmentos, serviciosDeSegmentos(nuevosSegmentos));
                    }

                    if (!nuevaObservacion.isEmpty()) {
                        incidenciaDao.agregarObservacion(idIncidencia, nuevaObservacion);
                    }

                    if (!nuevoEstado.isEmpty()) {
                        incidenciaDao.cambiarEstado(idIncidencia, nuevoEstado);
                    }
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=ver&id=" + idIncidencia);
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                break;
        }
    }

    // estados que el Network Operator puede poner a mano:
    //   Detectada -> En análisis   y   Servicio restaurado -> Cerrada
    // Reparación programada, En reparación y Servicio restaurado los pone el correctivo (MantenimientoServlet)
    private ArrayList<String> estadosManuales(Incidencia incidencia) {
        ArrayList<String> estados = new ArrayList<>();
        String estado = incidencia.getEstado();

        if (estado.equals("Detectada")) {
            estados.add("En análisis");
        } else if (estado.equals("Servicio restaurado")) {
            estados.add("Cerrada");
        }
        return estados;
    }

    private boolean severidadValida(String severidad) {
        return severidad.equals("Baja") || severidad.equals("Media") || severidad.equals("Alta") || severidad.equals("Crítica");
    }

    // los segmentos solo se cambian antes de programar la reparacion
    private boolean puedeCambiarSegmentos(Incidencia incidencia) {
        return incidencia.getEstado().equals("Detectada") || incidencia.getEstado().equals("En análisis");
    }

    // RN4: servicios vigentes que pasan por alguno de los segmentos de la incidencia
    private List<Integer> serviciosDeSegmentos(List<Integer> idsSegmentos) {
        ServicioDao servicioDao = new ServicioDao();
        List<Integer> idsServicios = new ArrayList<>();
        for (Integer idSeg : idsSegmentos) {
            for (Servicio sv : servicioDao.listarServiciosPorSegmento(idSeg)) {
                if (!idsServicios.contains(sv.getIdServicio())) {
                    idsServicios.add(sv.getIdServicio());
                }
            }
        }
        return idsServicios;
    }

    // convierte los checkboxes marcados en ids; si llega algo que no es numero, se ignora
    private List<Integer> convertirIds(String[] valores) {
        List<Integer> ids = new ArrayList<>();
        for (String valor : valores) {
            int id = numero(valor);
            if (id > 0 && !ids.contains(id)) {
                ids.add(id);
            }
        }
        return ids;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private int numero(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}