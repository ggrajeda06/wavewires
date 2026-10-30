package com.oceanlink.servlets;

import com.oceanlink.beans.Incidencia;
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

@WebServlet(name = "IncidenciaServlet", value = "/IncidenciaServlet")
public class IncidenciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
            case "historial":
                String estado = texto(request.getParameter("estado"));
                String severidad = texto(request.getParameter("severidad"));
                int idSegmento = numero(request.getParameter("idSegmento"));
                String desde = texto(request.getParameter("desde"));
                String hasta = texto(request.getParameter("hasta"));
                if (desde.isEmpty()) {
                    desde = "1000-01-01";
                }
                if (hasta.isEmpty()) {
                    hasta = "9999-12-31";
                }

                boolean soloActivas = action.equals("lista");
                request.setAttribute("lista", incidenciaDao.listarIncidencias(soloActivas, estado, severidad, idSegmento, desde, hasta));
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("modo", action);
                view = request.getRequestDispatcher("NetworkOperator/incidencias.jsp");
                view.forward(request, response);
                break;

            case "formCrear":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                view = request.getRequestDispatcher("NetworkOperator/incidencias_form.jsp");
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
                    request.setAttribute("estadosPermitidos", estadosManuales(incidenciaEditar, mantenimientoDao));
                    request.setAttribute("puedeCambiarSegmentos", puedeCambiarSegmentos(incidenciaEditar));
                    view = request.getRequestDispatcher("NetworkOperator/editarIncidencia.jsp");
                    view.forward(request, response);
                }
                break;

            case "estadoRed":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("listaActivas", incidenciaDao.listarIncidencias(true, "", "", 0, "1000-01-01", "9999-12-31"));
                view = request.getRequestDispatcher("NetworkOperator/estadoRed.jsp");
                view.forward(request, response);
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
                    for (Integer idSeg : incidenciaBorrar.getIdsSegmentos()) {
                        segmentoDao.recalcularEstado(idSeg);
                    }
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

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        MantenimientoDao mantenimientoDao = new MantenimientoDao();

        switch (action) {
            case "crear":
                String severidad = texto(request.getParameter("severidad"));
                String observacion = texto(request.getParameter("observaciones"));
                String[] segmentosMarcados = request.getParameterValues("idSegmento");

                if (severidad.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=formCrear&error=severidad");
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
                    for (Integer idSeg : idsSegmentos) {
                        segmentoDao.recalcularEstado(idSeg);
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

                if (severidadEdit.isEmpty()) {
                    response.sendRedirect(volver + "&error=severidad");
                } else if (cambiaSegmentos && (segmentosEdit == null || convertirIds(segmentosEdit).isEmpty())) {
                    response.sendRedirect(volver + "&error=segmentos");
                } else if (!nuevoEstado.isEmpty() && !estadosManuales(actual, mantenimientoDao).contains(nuevoEstado)) {
                    response.sendRedirect(volver + "&error=estado");
                } else {
                    List<Integer> segmentosTocados = new ArrayList<>(actual.getIdsSegmentos());

                    if (!severidadEdit.equals(actual.getSeveridad())) {
                        incidenciaDao.actualizarSeveridad(idIncidencia, severidadEdit);
                    }

                    if (cambiaSegmentos) {
                        List<Integer> nuevosSegmentos = convertirIds(segmentosEdit);
                        incidenciaDao.cambiarSegmentos(idIncidencia, nuevosSegmentos, serviciosDeSegmentos(nuevosSegmentos));
                        for (Integer idSeg : nuevosSegmentos) {
                            if (!segmentosTocados.contains(idSeg)) {
                                segmentosTocados.add(idSeg);
                            }
                        }
                    }

                    if (!nuevaObservacion.isEmpty()) {
                        incidenciaDao.agregarObservacion(idIncidencia, nuevaObservacion);
                    }

                    if (!nuevoEstado.isEmpty()) {
                        incidenciaDao.cambiarEstado(idIncidencia, nuevoEstado);
                        if (nuevoEstado.equals("Servicio restaurado")) {
                            incidenciaDao.restaurarServicios(idIncidencia);
                        }
                    }

                    for (Integer idSeg : segmentosTocados) {
                        segmentoDao.recalcularEstado(idSeg);
                    }
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet?action=ver&id=" + idIncidencia);
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                break;
        }
    }

    // estados que el Network Operator puede poner a mano; los demas los pone el mantenimiento correctivo
    private ArrayList<String> estadosManuales(Incidencia incidencia, MantenimientoDao mantenimientoDao) {
        ArrayList<String> estados = new ArrayList<>();
        String estado = incidencia.getEstado();

        if (estado.equals("Detectada")) {
            estados.add("En análisis");
        } else if (estado.equals("En análisis")
                && mantenimientoDao.listarPorIncidencia(incidencia.getIdIncidencia()).isEmpty()) {
            estados.add("Servicio restaurado");
        } else if (estado.equals("Servicio restaurado")) {
            estados.add("Cerrada");
        }
        return estados;
    }

    // los segmentos solo se cambian antes de programar la reparacion
    private boolean puedeCambiarSegmentos(Incidencia incidencia) {
        return incidencia.getEstado().equals("Detectada") || incidencia.getEstado().equals("En análisis");
    }

    // servicios activos que pasan por alguno de los segmentos
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