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
import java.sql.SQLException;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import com.oceanlink.util.Seguridad;
import com.oceanlink.daos.UsuarioDao;
import com.oceanlink.services.CorreoService;
import jakarta.mail.MessagingException;

@WebServlet(name = "MantenimientoServlet", value = "/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN,
                Seguridad.MANTENIMIENTO)) {
            return;
        }

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        LandingStationDao landingStationDao = new LandingStationDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                // incidencias que esperan un correctivo + historial de mantenimientos (RF31)
                request.setAttribute("listaPendientes", incidenciaDao.listarIncidenciasPendientes());
                request.setAttribute("lista", mantenimientoDao.listarMantenimientos());
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                view = request.getRequestDispatcher("/WEB-INF/views/Maintenance/Mantenimiento.jsp");
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
                view = request.getRequestDispatcher("/WEB-INF/views/Maintenance/serviciosAfectados.jsp");
                view.forward(request, response);
                break;

            case "formCrear":
                if (!Seguridad.exigirGestion(request, response, Seguridad.MANTENIMIENTO)) return;
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
                    view = request.getRequestDispatcher("/WEB-INF/views/Maintenance/verMantenimiento.jsp");
                    view.forward(request, response);
                }
                break;

            case "editar":
                if (!Seguridad.exigirGestion(request, response, Seguridad.MANTENIMIENTO)) return;
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
                if (!Seguridad.exigirGestion(request, response, Seguridad.MANTENIMIENTO)) return;
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

        // guardar cambios: solo el Maintenance Coordinator (el Administrador solo consulta)
        if (!Seguridad.permitir(request, response, Seguridad.MANTENIMIENTO)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        IncidenciaDao incidenciaDao = new IncidenciaDao();

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

                try {
                    int idMantenimiento = mantenimientoDao.crearMantenimiento(nuevo);

                    nuevo.setIdMantenimiento(idMantenimiento);
                    nuevo.setEstado("Pendiente");

                } catch (SQLException e) {
                    getServletContext().log("Error al registrar el mantenimiento", e);

                    mostrarFormCrear(
                            request,
                            response,
                            "No se pudo registrar el mantenimiento. Revisa los datos."
                    );
                    break;
                }

                programarIncidencia(nuevo.getIdIncidencia());

                request.getSession().setAttribute(
                        "avisoNoc", "Mantenimiento registrado como pendiente.");

                response.sendRedirect(request.getContextPath()
                        + "/MantenimientoServlet?action=ver&id=" + nuevo.getIdMantenimiento());
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

                boolean agregarFila = request.getParameter("agregarActividad") != null;
                String filaParaQuitar = request.getParameter("quitarActividad");

                if (agregarFila || filaParaQuitar != null) {
                    // Recupera todo lo que el usuario ha escrito hasta este momento.
                    String[] recibidas = request.getParameterValues("actividades");
                    ArrayList<String> filas = new ArrayList<>();

                    if (recibidas != null) {
                        java.util.Collections.addAll(filas, recibidas);
                    }

                    if (agregarFila) {
                        filas.add("");
                    } else {
                        int posicion = numero(filaParaQuitar);
                        if (posicion >= 1 && posicion <= filas.size()) {
                            filas.remove(posicion - 1);
                        }
                    }

                    request.setAttribute("filasTemporales", filas.toArray(new String[0]));
                    mostrarFormEditar(request, response, actual, null);
                    return;
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

                if ("Finalizado".equals(estadoEdit)
                        && "Correctivo".equals(actual.getTipo())
                        && actual.getIdIncidencia() > 0) {

                    String aviso;
                    try {
                        boolean restaurada = mantenimientoDao.finalizarCorrectivo(actual);
                        aviso = enviarAvisoMantenimientoAlNoc(actual, restaurada);
                    } catch (SQLException e) {
                        getServletContext().log(
                                "Error al finalizar el correctivo #" + actual.getIdMantenimiento(), e);
                        aviso = "No se pudo confirmar la finalización. Revisa el estado del correctivo.";
                    }

                    request.getSession().setAttribute("avisoNoc", aviso);
                    response.sendRedirect(request.getContextPath()
                            + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                    break;
                }

                try {
                    boolean guardado = mantenimientoDao.actualizarMantenimiento(
                            actual, estadoAnterior);

                    if (!guardado) {
                        request.getSession().setAttribute("avisoNoc",
                                "El mantenimiento cambió. Revisa su estado actual.");
                        response.sendRedirect(request.getContextPath()
                                + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                        break;
                    }
                } catch (SQLException e) {
                    getServletContext().log("Error al actualizar el mantenimiento", e);
                    request.getSession().setAttribute("avisoNoc",
                            "No se pudo guardar el cambio de mantenimiento.");
                    response.sendRedirect(request.getContextPath()
                            + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                    break;
                }

                // si cambio la incidencia ligada, la anterior se suelta y la nueva pasa a Reparacion programada
                if (incidenciaAnterior != actual.getIdIncidencia()) {
                    soltarIncidencia(incidenciaAnterior);
                    programarIncidencia(actual.getIdIncidencia());
                }

                // el estado del segmento no se toca aqui: SegmentoDao.recalcularEstados() lo calcula al leer
                if (!estadoEdit.equals(estadoAnterior) && actual.getIdIncidencia() > 0) {
                    actualizarIncidencia(actual, mantenimientoDao, incidenciaDao);
                }
                if ("Pendiente".equals(estadoAnterior)
                        && "Activo".equals(estadoEdit)
                        && "Correctivo".equals(actual.getTipo())
                        && actual.getIdIncidencia() > 0) {

                    String avisoInicio = enviarAvisoMantenimientoAlNoc(actual, false);
                    request.getSession().setAttribute("avisoNoc", avisoInicio);
                }
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet?action=ver&id=" + actual.getIdMantenimiento());
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
        }
    }

    private String enviarAvisoMantenimientoAlNoc(
            Mantenimiento m, boolean restaurada) {

        boolean finalizado = "Finalizado".equals(m.getEstado());
        String evento = finalizado ? "Mantenimiento finalizado" : "Mantenimiento iniciado";
        String resultadoOperacion = evento + ".";

        Incidencia incidencia =
                new IncidenciaDao().obtenerIncidencia(m.getIdIncidencia());

        if (incidencia == null) {
            return resultadoOperacion
                    + " No se pudo obtener la incidencia para preparar el correo.";
        }

        String introduccion;
        String accion;

        if (restaurada) {
            introduccion = "Finalizó el último correctivo y la incidencia pasó a Servicio restaurado.";
            accion = "Verifica los servicios afectados y, si corresponde, cierra la incidencia.";
        } else if (finalizado) {
            introduccion = "Finalizó este correctivo. La incidencia continúa en seguimiento.";
            accion = "Revisa los demás correctivos asociados a la incidencia.";
        } else {
            introduccion = "El correctivo pasó a Activo y el equipo de Mantenimiento inició la atención.";
            accion = "Puedes consultar el avance en OceanLink.";
        }

        String actividades = m.getActividadesRealizadas();

        if (actividades == null || actividades.isBlank()) {
            actividades = "Todavía no se registran actividades realizadas.";
        }

        String observaciones = incidencia.getObservaciones();

        if (observaciones == null || observaciones.isBlank()) {
            observaciones = "Sin observaciones registradas.";
        }

        String asunto = "OceanLink | " + evento
                + " | " + incidencia.getIdentificador()
                + " | Mantenimiento #" + m.getIdMantenimiento();

        String cuerpo = """
            Equipo NOC:

            %s

            INFORMACIÓN DE LA INCIDENCIA
            Identificador: %s
            Severidad: %s
            Estado actual: %s
            Fecha de registro: %s

            OBSERVACIONES DE LA INCIDENCIA
            %s

            INFORMACIÓN DEL MANTENIMIENTO
            ID: %d
            Nombre: %s
            Tipo: %s
            Estado: %s
            Infraestructura: %s
            Fecha programada: %s
            Duración estimada: %d horas

            DESCRIPCIÓN DEL TRABAJO
            %s

            ACTIVIDADES REALIZADAS
            %s

            ACCIÓN SOLICITADA AL NOC
            %s

            OceanLink
            Notificación automática
            """.formatted(
                introduccion,
                incidencia.getIdentificador(),
                incidencia.getSeveridad(),
                incidencia.getEstado(),
                incidencia.getFechaRegistro(),
                observaciones,
                m.getIdMantenimiento(),
                m.getNombre(),
                m.getTipo(),
                m.getEstado(),
                textoInfraestructura(m),
                m.getFechaRegistrada(),
                m.getDuracionHoras(),
                m.getDescripcion(),
                actividades,
                accion
        );

        try {
            var destinos = new UsuarioDao().listarCorreosNoc();

            if (destinos.isEmpty()) {
                return resultadoOperacion
                        + " No hay operadores NOC activos con correo.";
            }

            CorreoService correo = new CorreoService();
            int enviados = 0;

            for (String destino : destinos) {
                try {
                    correo.enviar(destino, asunto, cuerpo);
                    enviados++;
                } catch (MessagingException | IllegalStateException e) {
                    getServletContext().log(
                            "Falló el aviso al NOC del mantenimiento #"
                                    + m.getIdMantenimiento(), e);
                }
            }

            return resultadoOperacion + " Alertas enviadas al NOC: "
                    + enviados + " de " + destinos.size() + ".";

        } catch (SQLException e) {
            getServletContext().log(
                    "Error al consultar los destinatarios del NOC", e);

            return resultadoOperacion
                    + " No se pudo consultar el correo del NOC.";
        }
    }

    private String avisarRestauracionAlNoc(Mantenimiento m) {
        return enviarAvisoMantenimientoAlNoc(m, true);
    }


    private void actualizarIncidencia(Mantenimiento m, MantenimientoDao mantenimientoDao, IncidenciaDao incidenciaDao) {
        Incidencia inc = incidenciaDao.obtenerIncidencia(m.getIdIncidencia());
        String estadoInc = inc.getEstado();

        if (m.getEstado().equals("Activo")) {
            if (estadoInc.equals("Detectada") || estadoInc.equals("En análisis") || estadoInc.equals("Reparación programada")) {
                incidenciaDao.cambiarEstado(inc.getIdIncidencia(), "En reparación");
            }
        } else if (m.getEstado().equals("Finalizado")) {
            if (mantenimientoDao.contarPendientesDeIncidencia(inc.getIdIncidencia()) == 0
                    && !estadoInc.equals("Servicio restaurado") && !estadoInc.equals("Cerrada")) {
                incidenciaDao.cambiarEstado(inc.getIdIncidencia(), "Servicio restaurado");
                incidenciaDao.restaurarServicios(inc.getIdIncidencia());
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
        if (revisarFechaPasada && dia.isAfter(LocalDate.now().plusYears(1))) {
            return "La fecha del mantenimiento no puede ser más de un año después de hoy.";
        }
        if (m.getDuracionHoras() < 1 || m.getDuracionHoras() > 720) {
            return "La duración debe estar entre 1 y 720 horas (30 días).";
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
        // todo correctivo va ligado a una incidencia (se revisa al registrar y mientras esta Pendiente, que es cuando se elige)
        if (m.getTipo().equals("Correctivo") && m.getIdIncidencia() == 0
                && (m.getEstado() == null || m.getEstado().equals("Pendiente"))) {
            return "Un mantenimiento correctivo debe estar ligado a una incidencia.";
        }
        if (m.getTipo().equals("Preventivo") && m.getIdIncidencia() > 0) {
            return "Un mantenimiento preventivo no se liga a una incidencia. Solo los correctivos.";
        }
        if (m.getIdIncidencia() > 0) {
            return validarIncidencia(m.getIdIncidencia(), m.getIdLandingStation(), m.getIdSegmento());
        }
        return null;
    }

    // AUTOMATIZACIÓN: al ligar un correctivo, la incidencia pasa a Reparación programada
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

    // AUTOMATIZACIÓN: si la incidencia se queda sin correctivos, vuelve a En análisis
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
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/Maintenance/registrarMantenimiento.jsp");
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
        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/Maintenance/editarMantenimiento.jsp");
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