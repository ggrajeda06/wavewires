package com.oceanlink.servlets;

import com.oceanlink.beans.Incidencia;
import com.oceanlink.beans.LandingStation;
import com.oceanlink.beans.Mantenimiento;
import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.IncidenciaDao;
import com.oceanlink.daos.LandingStationDao;
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
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;

@WebServlet(name = "MantenimientoServlet", value = "/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        LandingStationDao landingStationDao = new LandingStationDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("lista", mantenimientoDao.listarMantenimientos());
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                view = request.getRequestDispatcher("Maintenance/Mantenimiento.jsp");
                view.forward(request, response);
                break;

            case "servicios":
                int idLandingConsulta = numero(request.getParameter("idLandingStation"));
                int idSegmentoConsulta = numero(request.getParameter("idSegmento"));
                if (idLandingConsulta > 0 && idSegmentoConsulta > 0) {
                    request.setAttribute("error", "Elige una landing o un segmento, no los dos.");
                    idLandingConsulta = 0;
                    idSegmentoConsulta = 0;
                }
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("listaServicios", serviciosDeInfraestructura(idLandingConsulta, idSegmentoConsulta));
                view = request.getRequestDispatcher("Maintenance/serviciosAfectados.jsp");
                view.forward(request, response);
                break;

            case "formCrear":
                mostrarFormCrear(request, response, null);
                break;

            case "ver":
                Mantenimiento mVer = mantenimientoDao.obtenerMantenimiento(numero(request.getParameter("id")));
                if (mVer == null) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                } else {
                    request.setAttribute("mantenimiento", mVer);
                    request.setAttribute("infraestructura", textoInfraestructura(mVer));
                    request.setAttribute("listaServicios", serviciosDeInfraestructura(mVer.getIdLandingStation(), mVer.getIdSegmento()));
                    if (mVer.getIdIncidencia() > 0) {
                        request.setAttribute("incidencia", incidenciaDao.obtenerIncidencia(mVer.getIdIncidencia()));
                    }
                    view = request.getRequestDispatcher("Maintenance/verMantenimiento.jsp");
                    view.forward(request, response);
                }
                break;

            case "editar":
                Mantenimiento mEditar = mantenimientoDao.obtenerMantenimiento(numero(request.getParameter("id")));
                if (mEditar == null) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                } else if (mEditar.getEstado().equals("Finalizado")) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet?action=ver&id=" + mEditar.getIdMantenimiento());
                } else {
                    mostrarFormEditar(request, response, mEditar, null);
                }
                break;

            case "borrar":
                Mantenimiento mBorrar = mantenimientoDao.obtenerMantenimiento(numero(request.getParameter("id")));
                if (mBorrar == null) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                } else if (!mBorrar.getEstado().equals("Pendiente")) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet?error=noBorrable");
                } else {
                    mantenimientoDao.borrarMantenimiento(mBorrar.getIdMantenimiento());

                    soltarIncidencia(mBorrar.getIdIncidencia());
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        SegmentoDao segmentoDao = new SegmentoDao();

        switch (action) {
            case "crear":
                Mantenimiento nuevo = new Mantenimiento();
                nuevo.setNombre(texto(request.getParameter("nombreId")));
                nuevo.setDescripcion(texto(request.getParameter("descripcion")));
                nuevo.setTipo(texto(request.getParameter("tipoMantenimiento")));
                nuevo.setDuracionHoras(numero(request.getParameter("duracion")));
                nuevo.setIdLandingStation(numero(request.getParameter("idLandingStation")));
                nuevo.setIdSegmento(numero(request.getParameter("idSegmento")));
                nuevo.setIdIncidencia(numero(request.getParameter("idIncidencia")));
                String fecha = texto(request.getParameter("fecha"));

                String error = validarDatos(nuevo, fecha, true);
                if (error != null) {
                    mostrarFormCrear(request, response, error);
                    break;
                }

                nuevo.setFechaRegistrada(Date.valueOf(fecha));
                mantenimientoDao.crearMantenimiento(nuevo);
                programarIncidencia(nuevo.getIdIncidencia());
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;

            case "actualizar":
                Mantenimiento actual = mantenimientoDao.obtenerMantenimiento(numero(request.getParameter("id")));
                if (actual == null) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                    break;
                }
                // un mantenimiento finalizado ya no se modifica
                if (actual.getEstado().equals("Finalizado")) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                    break;
                }

                String estadoAnterior = actual.getEstado();
                int incidenciaAnterior = actual.getIdIncidencia();
                String fechaEdit = actual.getFechaRegistrada().toString();

                actual.setNombre(texto(request.getParameter("nombreId")));
                actual.setDescripcion(texto(request.getParameter("descripcion")));
                String estadoEdit = texto(request.getParameter("estado"));
                String actividades = texto(request.getParameter("actividades"));

                // mientras esta Pendiente se puede cambiar todo; despues solo nombre, descripcion, estado y actividades
                if (estadoAnterior.equals("Pendiente")) {
                    fechaEdit = texto(request.getParameter("fecha"));
                    actual.setTipo(texto(request.getParameter("tipoMantenimiento")));
                    actual.setDuracionHoras(numero(request.getParameter("duracion")));
                    actual.setIdLandingStation(numero(request.getParameter("idLandingStation")));
                    actual.setIdSegmento(numero(request.getParameter("idSegmento")));
                    actual.setIdIncidencia(numero(request.getParameter("idIncidencia")));
                }

                boolean fechaCambiada = !fechaEdit.equals(actual.getFechaRegistrada().toString());
                String errorEdit = validarDatos(actual, fechaEdit, fechaCambiada);
                if (errorEdit == null && !estadosPermitidos(estadoAnterior).contains(estadoEdit)) {
                    errorEdit = "Ese cambio de estado no está permitido. El orden es Pendiente, Activo y Finalizado.";
                } else if (errorEdit == null && estadoEdit.equals("Finalizado") && actividades.isEmpty()) {
                    errorEdit = "Para finalizar el mantenimiento registra las actividades realizadas.";
                }

                if (errorEdit != null) {
                    mostrarFormEditar(request, response, mantenimientoDao.obtenerMantenimiento(actual.getIdMantenimiento()), errorEdit);
                    break;
                }

                actual.setFechaRegistrada(Date.valueOf(fechaEdit));
                actual.setEstado(estadoEdit);
                actual.setActividadesRealizadas(actividades.isEmpty() ? null : actividades);
                mantenimientoDao.actualizarMantenimiento(actual);

                // si cambio la incidencia ligada, la anterior se suelta y la nueva pasa a Reparacion programada
                if (incidenciaAnterior != actual.getIdIncidencia()) {
                    soltarIncidencia(incidenciaAnterior);
                    programarIncidencia(actual.getIdIncidencia());
                }

                if (!estadoEdit.equals(estadoAnterior)) {
                    if (actual.getIdIncidencia() > 0) {
                        actualizarIncidencia(actual, mantenimientoDao, incidenciaDao, segmentoDao);
                    }
                    recalcularInfraestructura(actual);
                }
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
        }
    }

    // automatizacion con la incidencia del correctivo
    private void actualizarIncidencia(Mantenimiento m, MantenimientoDao mantenimientoDao,
                                      IncidenciaDao incidenciaDao, SegmentoDao segmentoDao) {
        Incidencia inc = incidenciaDao.obtenerIncidencia(m.getIdIncidencia());
        String estadoInc = inc.getEstado();

        if (m.getEstado().equals("Activo")) {
            if (estadoInc.equals("Detectada") || estadoInc.equals("En análisis") || estadoInc.equals("Reparación programada")) {
                incidenciaDao.cambiarEstado(inc.getIdIncidencia(), "En reparación");
            }
        } else if (m.getEstado().equals("Finalizado")) {
            // si ya no quedan correctivos sin terminar, se restaura la incidencia y sus servicios
            if (mantenimientoDao.contarPendientesDeIncidencia(inc.getIdIncidencia()) == 0
                    && !estadoInc.equals("Servicio restaurado") && !estadoInc.equals("Cerrada")) {
                incidenciaDao.cambiarEstado(inc.getIdIncidencia(), "Servicio restaurado");
                incidenciaDao.restaurarServicios(inc.getIdIncidencia());
                for (Integer idSeg : inc.getIdsSegmentos()) {
                    segmentoDao.recalcularEstado(idSeg);
                }
            }
        }
    }

    // reglas comunes de registrar y editar; devuelve el mensaje de error o null si todo esta bien
    private String validarDatos(Mantenimiento m, String fecha, boolean revisarFechaPasada) {
        if (m.getNombre().isEmpty() || m.getNombre().length() > 45) {
            return "Escribe el nombre del mantenimiento (máximo 45 caracteres).";
        }
        if (m.getDescripcion().isEmpty()) {
            return "Escribe la descripción del mantenimiento.";
        }
        if (!m.getTipo().equals("Preventivo") && !m.getTipo().equals("Correctivo")) {
            return "Elige el tipo de mantenimiento.";
        }
        LocalDate dia = leerFecha(fecha);
        if (dia == null) {
            return "Elige una fecha válida.";
        }
        if (revisarFechaPasada && dia.isBefore(LocalDate.now())) {
            return "La fecha del mantenimiento no puede ser anterior a hoy.";
        }
        if (m.getDuracionHoras() < 1) {
            return "La duración debe ser de al menos 1 hora.";
        }
        if ((m.getIdLandingStation() > 0 && m.getIdSegmento() > 0) || (m.getIdLandingStation() == 0 && m.getIdSegmento() == 0)) {
            return "Elige la infraestructura: una landing o un segmento, solo uno.";
        }
        if (m.getIdLandingStation() > 0 && new LandingStationDao().obtenerLandingStation(m.getIdLandingStation()) == null) {
            return "Esa landing no existe.";
        }
        if (m.getIdSegmento() > 0 && new SegmentoDao().obtenerSegmento(m.getIdSegmento()) == null) {
            return "Ese segmento no existe.";
        }
        if (m.getTipo().equals("Preventivo") && m.getIdIncidencia() > 0) {
            return "Un mantenimiento preventivo no se liga a una incidencia. Solo los correctivos.";
        }
        if (m.getIdIncidencia() > 0) {
            return validarIncidencia(m.getIdIncidencia(), m.getIdLandingStation(), m.getIdSegmento());
        }
        return null;
    }

    // al ligar un correctivo, la incidencia pasa a Reparacion programada
    private void programarIncidencia(int idIncidencia) {
        if (idIncidencia == 0) {
            return;
        }
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        Incidencia inc = incidenciaDao.obtenerIncidencia(idIncidencia);
        if (inc.getEstado().equals("Detectada") || inc.getEstado().equals("En análisis")) {
            incidenciaDao.cambiarEstado(idIncidencia, "Reparación programada");
        }
    }

    // si la incidencia se queda sin correctivos, vuelve a En analisis
    private void soltarIncidencia(int idIncidencia) {
        if (idIncidencia == 0) {
            return;
        }
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        Incidencia inc = incidenciaDao.obtenerIncidencia(idIncidencia);
        if (inc.getEstado().equals("Reparación programada")
                && new MantenimientoDao().listarPorIncidencia(idIncidencia).isEmpty()) {
            incidenciaDao.cambiarEstado(idIncidencia, "En análisis");
        }
    }

    private LocalDate leerFecha(String fecha) {
        try {
            return LocalDate.parse(fecha);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    // un correctivo solo se liga a una incidencia abierta y sobre su misma infraestructura
    private String validarIncidencia(int idIncidencia, int idLanding, int idSegmento) {
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        Incidencia inc = incidenciaDao.obtenerIncidencia(idIncidencia);

        if (inc == null) {
            return "Esa incidencia no existe.";
        }
        if (inc.getEstado().equals("Servicio restaurado") || inc.getEstado().equals("Cerrada")) {
            return "Esa incidencia ya fue restaurada o cerrada.";
        }

        boolean coincide = false;
        for (Segmento s : segmentoDao.listarSegmentosPorIncidencia(idIncidencia)) {
            if (s.getIdSegmento() == idSegmento || s.getIdOrigen() == idLanding || s.getIdDestino() == idLanding) {
                coincide = true;
            }
        }
        if (!coincide) {
            return "La infraestructura elegida no está afectada por " + inc.getIdentificador()
                    + ". Elige uno de sus segmentos o una landing de esos segmentos.";
        }
        return null;
    }

    private void mostrarFormCrear(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        LandingStationDao landingStationDao = new LandingStationDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        IncidenciaDao incidenciaDao = new IncidenciaDao();

        int idLanding = numero(request.getParameter("idLandingStation"));
        int idSegmento = numero(request.getParameter("idSegmento"));
        if (error == null && idLanding > 0 && idSegmento > 0) {
            error = "Elige una landing o un segmento, no los dos.";
        }

        request.setAttribute("error", error);
        request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
        request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
        request.setAttribute("listaIncidencias", incidenciaDao.listarIncidenciasAbiertas());
        if (idLanding > 0 && idSegmento > 0) {
            request.setAttribute("listaServicios", new ArrayList<Servicio>());
        } else {
            request.setAttribute("listaServicios", serviciosDeInfraestructura(idLanding, idSegmento));
        }
        RequestDispatcher view = request.getRequestDispatcher("Maintenance/registrarMantenimiento.jsp");
        view.forward(request, response);
    }

    private void mostrarFormEditar(HttpServletRequest request, HttpServletResponse response, Mantenimiento m, String error)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("mantenimiento", m);
        request.setAttribute("infraestructura", textoInfraestructura(m));
        request.setAttribute("estadosPermitidos", estadosPermitidos(m.getEstado()));
        request.setAttribute("listaLandings", new LandingStationDao().listarLandingStations());
        request.setAttribute("listaSegmentos", new SegmentoDao().listarSegmentos());
        request.setAttribute("listaIncidencias", new IncidenciaDao().listarIncidenciasAbiertas());
        RequestDispatcher view = request.getRequestDispatcher("Maintenance/editarMantenimiento.jsp");
        view.forward(request, response);
    }

    // orden del flujo: Pendiente -> Activo -> Finalizado
    private ArrayList<String> estadosPermitidos(String estado) {
        ArrayList<String> estados = new ArrayList<>();
        estados.add(estado);
        if (estado.equals("Pendiente")) {
            estados.add("Activo");
        } else if (estado.equals("Activo")) {
            estados.add("Finalizado");
        }
        return estados;
    }

    private ArrayList<Servicio> serviciosDeInfraestructura(int idLanding, int idSegmento) {
        ServicioDao servicioDao = new ServicioDao();
        if (idSegmento > 0) {
            return servicioDao.listarServiciosPorSegmento(idSegmento);
        } else if (idLanding > 0) {
            return servicioDao.listarServiciosPorLanding(idLanding);
        }
        return new ArrayList<>();
    }

    private String textoInfraestructura(Mantenimiento m) {
        if (m.getIdSegmento() > 0) {
            Segmento s = new SegmentoDao().obtenerSegmento(m.getIdSegmento());
            return "Segmento SEG-" + String.format("%03d", s.getIdSegmento()) + " (" + s.getNombreOrigen() + " - " + s.getNombreDestino() + ")";
        }
        LandingStation ls = new LandingStationDao().obtenerLandingStation(m.getIdLandingStation());
        return "Landing " + ls.getNombre() + " (" + ls.getCiudad() + ", " + ls.getPais() + ")";
    }

    private void recalcularInfraestructura(Mantenimiento m) {
        if (m.getIdSegmento() > 0) {
            new SegmentoDao().recalcularEstado(m.getIdSegmento());
        }
        if (m.getIdLandingStation() > 0) {
            new LandingStationDao().recalcularEstado(m.getIdLandingStation());
        }
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