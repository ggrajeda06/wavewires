package com.oceanlink.servlets;

import com.oceanlink.beans.*;
import com.oceanlink.daos.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import com.oceanlink.util.ReportePdf;
import com.oceanlink.util.Reportes;
import com.oceanlink.util.Seguridad;

@WebServlet(name = "SupervisorServlet", value = "/SupervisorServlet")
public class SupervisorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN,
                Seguridad.SUPERVISOR)) {
            return;
        }

        String action = request.getParameter("action") == null ? "inicio" : request.getParameter("action");
        RequestDispatcher view;

        switch (action) {
            case "inicio":
                cargarInicio(request);
                view = request.getRequestDispatcher("/WEB-INF/views/Supervisor/supervisor_home.jsp");
                view.forward(request, response);
                break;

            case "reportes":
                cargarFiltros(request);
                view = request.getRequestDispatcher("/WEB-INF/views/Supervisor/reportes_supervisor.jsp");
                view.forward(request, response);
                break;

            case "indicadores":
                cargarIndicadores(request);
                view = request.getRequestDispatcher("/WEB-INF/views/Supervisor/indicadores_historicos.jsp");
                view.forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SupervisorServlet");
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
                Seguridad.SUPERVISOR)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "inicio" : request.getParameter("action");

        switch (action) {
            case "pdf":
                generarPdf(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SupervisorServlet");
                break;
        }
    }

    private void cargarInicio(HttpServletRequest request) {
        ArrayList<Segmento> segmentos = new SegmentoDao().listarSegmentos();
        ArrayList<LandingStation> landings = new LandingStationDao().listarLandingStations();
        ArrayList<Servicio> servicios = new ServicioDao().listarServicios();
        ArrayList<Mantenimiento> mantenimientos = new MantenimientoDao().listarMantenimientos();
        ArrayList<Incidencia> incidencias = Reportes.incidenciasActivas();

        BigDecimal total = BigDecimal.ZERO;
        BigDecimal usada = BigDecimal.ZERO;
        BigDecimal reservada = BigDecimal.ZERO;
        for (Segmento s : segmentos) {
            total = total.add(Reportes.numero(s.getCapacidadTotal()));
            usada = usada.add(Reportes.numero(s.getCapacidadUsada()));
            reservada = reservada.add(Reportes.numero(s.getCapacidadReservada()));
        }

        ArrayList<LinkedHashMap<String, String>> filasSegmentos = Reportes.filasSegmentos(segmentos);
        filasSegmentos.sort(Comparator.comparingDouble(
                (LinkedHashMap<String, String> f) -> Double.parseDouble(f.get("UtilizacionValor"))).reversed());

        HashMap<Integer, Servicio> mapaServicios = Reportes.mapaServicios(servicios);

        request.setAttribute("capTotal", Reportes.gbps(total));
        request.setAttribute("capUsada", Reportes.gbps(usada));
        request.setAttribute("capReservada", Reportes.gbps(reservada));
        request.setAttribute("capDisponible", Reportes.gbps(total.subtract(usada).subtract(reservada)));
        request.setAttribute("filasSegmentos", filasSegmentos);
        request.setAttribute("filasIncidencias",
                Reportes.filasIncidencias(incidencias, Reportes.mapaSegmentos(segmentos), mapaServicios));
        request.setAttribute("filasMantenimientos",
                Reportes.filasMantenimientos(mantenimientos, landings, segmentos, servicios));

        int operativos = 0;
        for (Segmento s : segmentos) {
            if ("Operativo".equals(s.getEstado())) {
                operativos++;
            }
        }

        int altaUtilizacion = 0;
        for (LinkedHashMap<String, String> f : filasSegmentos) {
            if (!"Normal".equals(f.get("Nivel"))) {
                altaUtilizacion++;
            }
        }

        HashSet<Integer> serviciosAfectados = new HashSet<>();
        HashSet<Integer> clientesAfectados = new HashSet<>();
        for (Incidencia i : incidencias) {
            for (Integer idServicio : Reportes.ids(i.getIdsServicios())) {
                Servicio sv = mapaServicios.get(idServicio);
                if (sv != null) {
                    serviciosAfectados.add(idServicio);
                    clientesAfectados.add(sv.getIdCliente());
                }
            }
        }

        int programados = 0;
        for (Mantenimiento m : mantenimientos) {
            if ("Pendiente".equals(m.getEstado())) {
                programados++;
            }
        }

        ArrayList<LinkedHashMap<String, String>> filasClientes =
                Reportes.filasClientes(new ClienteDao().listarClientes(), servicios);
        filasClientes.sort(Comparator.comparingDouble(
                (LinkedHashMap<String, String> f) -> Double.parseDouble(f.get("CapacidadValor"))).reversed());

        request.setAttribute("utilizacionRed", Reportes.porcentaje(usada, total));
        request.setAttribute("segmentosOperativos", operativos);
        request.setAttribute("segmentosNoOperativos", segmentos.size() - operativos);
        request.setAttribute("segmentosAltaUtilizacion", altaUtilizacion);
        request.setAttribute("incidenciasActivas", incidencias.size());
        request.setAttribute("serviciosAfectados", serviciosAfectados.size());
        request.setAttribute("clientesAfectados", clientesAfectados.size());
        request.setAttribute("mantenimientosProgramados", programados);
        request.setAttribute("filasCapacidadClientes", filasClientes);
    }

    // RF38: opciones de los desplegables de filtros
    private void cargarFiltros(HttpServletRequest request) {
        TreeSet<String> paises = new TreeSet<>();
        for (LandingStation l : new LandingStationDao().listarLandingStations()) {
            paises.add(l.getPais());
        }
        request.setAttribute("segmentos", new SegmentoDao().listarSegmentos());
        request.setAttribute("clientes", new ClienteDao().listarClientes());
        request.setAttribute("paises", paises);
    }

    // RF39: indicadores historicos por mes del anio elegido
    private void cargarIndicadores(HttpServletRequest request) {
        IndicadorDao indicadorDao = new IndicadorDao();
        ArrayList<Integer> anios = indicadorDao.listarAnios();

        int anio = LocalDate.now().getYear();
        if (!anios.isEmpty() && !anios.contains(anio)) {
            anio = anios.get(0);
        }
        int elegido = Reportes.entero(request.getParameter("anio"));
        if (anios.contains(elegido)) {
            anio = elegido;
        }

        request.setAttribute("anios", anios);
        request.setAttribute("anio", anio);
        request.setAttribute("indicadores", indicadorDao.listarPorMes(anio));
    }

    private void generarPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tipo = Reportes.texto(request.getParameter("tipo"));
        String estado = Reportes.texto(request.getParameter("estado"));
        String[] columnas = request.getParameterValues("columnas");

        if (columnas == null || columnas.length == 0) {
            volverAReportes(request, response, "columnas");
            return;
        }

        LocalDate desde;
        LocalDate hasta;
        try {
            desde = fechaFiltro(request.getParameter("desde"));
            hasta = fechaFiltro(request.getParameter("hasta"));
        } catch (DateTimeParseException e) {
            volverAReportes(request, response, "fechas");
            return;
        }
        if (desde != null && hasta != null && desde.isAfter(hasta)) {
            volverAReportes(request, response, "fechas");
            return;
        }

        ArrayList<String> filtros = new ArrayList<>();
        if (!estado.isEmpty()) {
            filtros.add("Estado: " + estado);
        }
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        if (desde != null) {
            filtros.add("Desde: " + desde.format(formato));
        }
        if (hasta != null) {
            filtros.add("Hasta: " + hasta.format(formato));
        }

        int idSegmento = Reportes.entero(request.getParameter("idSegmento"));
        if (idSegmento != 0) {
            filtros.add("Segmento: " + Reportes.codigoSegmento(idSegmento));
        }

        ArrayList<LinkedHashMap<String, String>> filas =
                Reportes.filasReporte(tipo, request, desde, hasta, idSegmento, filtros);
        if (filas == null) {
            response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes");
            return;
        }

        if (!estado.isEmpty()) {
            filas.removeIf(f -> !estado.equals(f.get("Estado")));
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=reporte_" + tipo + ".pdf");

        ReportePdf.escribir(response.getOutputStream(), Reportes.titulo(tipo), filtros, columnas, filas);
    }

    private void volverAReportes(HttpServletRequest request, HttpServletResponse response, String error)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes&error=" + error);
    }

    private LocalDate fechaFiltro(String valor) {
        return Reportes.texto(valor).isEmpty() ? null : LocalDate.parse(valor.trim());
    }
}
