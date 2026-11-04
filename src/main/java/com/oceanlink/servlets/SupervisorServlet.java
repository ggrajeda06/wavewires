package com.oceanlink.servlets;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import com.oceanlink.beans.*;
import com.oceanlink.daos.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.List;
import java.util.function.Function;

@WebServlet(name = "SupervisorServlet", value = "/SupervisorServlet")
public class SupervisorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "inicio" : request.getParameter("action");
        RequestDispatcher view;

        switch (action) {
            case "inicio":
                cargarInicio(request);
                view = request.getRequestDispatcher("Supervisor/supervisor_home.jsp");
                view.forward(request, response);
                break;

            case "reportes":
                cargarFiltros(request);
                view = request.getRequestDispatcher("Supervisor/reportes_supervisor.jsp");
                view.forward(request, response);
                break;

            case "indicadores":
                cargarIndicadores(request);
                view = request.getRequestDispatcher("Supervisor/indicadores_historicos.jsp");
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
        ArrayList<Incidencia> incidencias = incidenciasActivas();

        BigDecimal total = BigDecimal.ZERO;
        BigDecimal usada = BigDecimal.ZERO;
        BigDecimal reservada = BigDecimal.ZERO;
        for (Segmento s : segmentos) {
            total = total.add(numero(s.getCapacidadTotal()));
            usada = usada.add(numero(s.getCapacidadUsada()));
            reservada = reservada.add(numero(s.getCapacidadReservada()));
        }

        ArrayList<LinkedHashMap<String, String>> filasSegmentos = filasSegmentos(segmentos);
        filasSegmentos.sort(Comparator.comparingDouble(
                (LinkedHashMap<String, String> f) -> Double.parseDouble(f.get("UtilizacionValor"))).reversed());

        request.setAttribute("capTotal", gbps(total));
        request.setAttribute("capUsada", gbps(usada));
        request.setAttribute("capReservada", gbps(reservada));
        request.setAttribute("capDisponible", gbps(total.subtract(usada).subtract(reservada)));
        request.setAttribute("filasSegmentos", filasSegmentos);
        request.setAttribute("filasIncidencias", filasIncidencias(incidencias, mapaSegmentos(segmentos), mapaServicios(servicios)));
        request.setAttribute("filasMantenimientos", filasMantenimientos(mantenimientos, landings, segmentos, servicios));

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

        HashMap<Integer, Servicio> mapaServicios = mapaServicios(servicios);
        HashSet<Integer> serviciosAfectados = new HashSet<>();
        HashSet<Integer> clientesAfectados = new HashSet<>();
        for (Incidencia i : incidencias) {
            for (Integer idServicio : ids(i.getIdsServicios())) {
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

        ArrayList<LinkedHashMap<String, String>> filasClientes = filasClientes(new ClienteDao().listarClientes(), servicios);
        filasClientes.sort(Comparator.comparingDouble(
                (LinkedHashMap<String, String> f) -> Double.parseDouble(f.get("CapacidadValor"))).reversed());

        request.setAttribute("utilizacionRed", porcentaje(usada, total));
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
        int elegido = entero(request.getParameter("anio"));
        if (anios.contains(elegido)) {
            anio = elegido;
        }

        request.setAttribute("anios", anios);
        request.setAttribute("anio", anio);
        request.setAttribute("indicadores", indicadorDao.listarPorMes(anio));
    }

    private void generarPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tipo = texto(request.getParameter("tipo"));
        String estado = texto(request.getParameter("estado"));
        String[] columnas = request.getParameterValues("columnas");

        if (columnas == null || columnas.length == 0) {
            response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes&error=columnas");
            return;
        }

        LocalDate desde;
        LocalDate hasta;
        try {
            desde = fechaFiltro(request.getParameter("desde"));
            hasta = fechaFiltro(request.getParameter("hasta"));
        } catch (DateTimeParseException e) {
            response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes&error=fechas");
            return;
        }
        if (desde != null && hasta != null && desde.isAfter(hasta)) {
            response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes&error=fechas");
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

        int idSegmento = entero(request.getParameter("idSegmento"));
        if (idSegmento != 0) {
            filtros.add("Segmento: " + codigoSegmento(idSegmento));
        }

        ArrayList<LinkedHashMap<String, String>> filas;
        String titulo;

        switch (tipo) {
            case "mantenimientos":
                ArrayList<Mantenimiento> mantenimientos = new MantenimientoDao().listarMantenimientos();
                String tipoMantenimiento = texto(request.getParameter("tipoMantenimiento"));
                if (!tipoMantenimiento.isEmpty()) {
                    mantenimientos.removeIf(m -> !tipoMantenimiento.equals(m.getTipo()));
                    filtros.add("Tipo: " + tipoMantenimiento);
                }
                filtrarPorFecha(mantenimientos, Mantenimiento::getFechaRegistrada, desde, hasta);
                filas = filasMantenimientos(mantenimientos,
                        new LandingStationDao().listarLandingStations(),
                        new SegmentoDao().listarSegmentos(),
                        new ServicioDao().listarServicios());
                titulo = "Mantenimientos";
                break;

            case "incidencias":
                ArrayList<Segmento> segmentosInc = new SegmentoDao().listarSegmentos();
                ArrayList<Incidencia> incidencias = new IncidenciaDao().listarIncidencias(false);
                String severidad = texto(request.getParameter("severidad"));
                if (!severidad.isEmpty()) {
                    incidencias.removeIf(i -> !severidad.equals(i.getSeveridad()));
                    filtros.add("Severidad: " + severidad);
                }
                if (idSegmento != 0) {
                    incidencias.removeIf(i -> !ids(i.getIdsSegmentos()).contains(idSegmento));
                }
                filtrarPorFecha(incidencias, Incidencia::getFechaRegistro, desde, hasta);
                filas = filasIncidencias(incidencias,
                        mapaSegmentos(segmentosInc), mapaServicios(new ServicioDao().listarServicios()));
                titulo = "Incidencias";
                break;

            case "segmentos":
                filas = filasSegmentos(new SegmentoDao().listarSegmentos());
                String nivel = texto(request.getParameter("nivel"));
                if (!nivel.isEmpty()) {
                    filas.removeIf(f -> !nivel.equals(f.get("Nivel")));
                    filtros.add("Nivel: " + nivel);
                }
                titulo = "Segmentos";
                break;

            case "landings":
                ArrayList<LandingStation> landings = new LandingStationDao().listarLandingStations();
                String pais = texto(request.getParameter("pais"));
                if (!pais.isEmpty()) {
                    landings.removeIf(l -> !pais.equals(l.getPais()));
                    filtros.add("País: " + pais);
                }
                filas = filasLandings(landings,
                        new SegmentoDao().listarSegmentos(),
                        incidenciasActivas(),
                        new MantenimientoDao().listarMantenimientos());
                titulo = "Landing Stations";
                break;

            case "servicios":
                ArrayList<Servicio> servicios = new ServicioDao().listarServicios();
                int idCliente = entero(request.getParameter("idCliente"));
                if (idCliente != 0) {
                    servicios.removeIf(sv -> sv.getIdCliente() != idCliente);
                    filtros.add("Cliente: " + nombreCliente(idCliente));
                }
                if (idSegmento != 0) {
                    servicios.removeIf(sv -> sv.getIdSegmento() != idSegmento);
                }
                filtrarPorFecha(servicios, Servicio::getFechaActivacion, desde, hasta);
                filas = filasServicios(servicios);
                titulo = "Servicios";
                break;

            case "clientes":
                ArrayList<Cliente> clientes = new ClienteDao().listarClientes();
                filtrarPorFecha(clientes, Cliente::getFechaRegistro, desde, hasta);
                filas = filasClientes(clientes, new ServicioDao().listarServicios());
                titulo = "Clientes";
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes");
                return;
        }

        if (!estado.isEmpty()) {
            filas.removeIf(f -> !estado.equals(f.get("Estado")));
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=reporte_" + tipo + ".pdf");

        Document documento = new Document(PageSize.A4.rotate(), 30, 30, 30, 30);
        try {
            PdfWriter.getInstance(documento, response.getOutputStream());
            documento.open();

            documento.add(new Paragraph("Reporte de " + titulo, new Font(Font.HELVETICA, 16, Font.BOLD)));
            documento.add(new Paragraph("Generado el " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date())
                    + "   |   Registros: " + filas.size(), new Font(Font.HELVETICA, 10)));
            documento.add(new Paragraph("Filtros: " + (filtros.isEmpty() ? "Ninguno" : String.join("   |   ", filtros)),
                    new Font(Font.HELVETICA, 10)));
            documento.add(new Paragraph(" "));

            Font fuenteCabecera = new Font(Font.HELVETICA, 9, Font.BOLD);
            Font fuenteNormal = new Font(Font.HELVETICA, 9);

            PdfPTable tabla = new PdfPTable(columnas.length);
            tabla.setWidthPercentage(100);
            tabla.setHeaderRows(1);

            for (String columna : columnas) {
                PdfPCell celda = new PdfPCell(new Phrase(columna, fuenteCabecera));
                celda.setGrayFill(0.9f);
                celda.setPadding(4);
                tabla.addCell(celda);
            }

            for (LinkedHashMap<String, String> fila : filas) {
                for (String columna : columnas) {
                    PdfPCell celda = new PdfPCell(new Phrase(valor(fila.get(columna)), fuenteNormal));
                    celda.setPadding(4);
                    tabla.addCell(celda);
                }
            }

            if (filas.isEmpty()) {
                PdfPCell vacia = new PdfPCell(new Phrase("No hay registros para este filtro.", fuenteNormal));
                vacia.setColspan(columnas.length);
                vacia.setPadding(4);
                tabla.addCell(vacia);
            }

            documento.add(tabla);
            documento.close();
        } catch (DocumentException e) {
            throw new IOException(e);
        }
    }

    private <T> void filtrarPorFecha(ArrayList<T> lista, Function<T, Date> fecha, LocalDate desde, LocalDate hasta) {
        if (desde == null && hasta == null) {
            return;
        }
        lista.removeIf(elemento -> {
            Date valor = fecha.apply(elemento);
            if (valor == null) {
                return true;
            }
            LocalDate dia = new java.sql.Date(valor.getTime()).toLocalDate();
            return (desde != null && dia.isBefore(desde)) || (hasta != null && dia.isAfter(hasta));
        });
    }

    private LocalDate fechaFiltro(String valor) {
        return texto(valor).isEmpty() ? null : LocalDate.parse(valor.trim());
    }

    private int entero(String valor) {
        try {
            return Integer.parseInt(texto(valor));
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String nombreCliente(int idCliente) {
        for (Cliente c : new ClienteDao().listarClientes()) {
            if (c.getIdCliente() == idCliente) {
                return valor(c.getRazonSocial());
            }
        }
        return String.valueOf(idCliente);
    }

    // Niveles de alerta del documento: menor a 80 normal, de 80 a 95 alta, mayor a 95 critica
    private String nivelUtilizacion(double utilizacion) {
        if (utilizacion > 95) {
            return "Utilización crítica";
        } else if (utilizacion >= 80) {
            return "Alta utilización";
        }
        return "Normal";
    }

    private String porcentaje(BigDecimal parte, BigDecimal total) {
        double valor = total.signum() > 0
                ? parte.multiply(BigDecimal.valueOf(100)).divide(total, 1, RoundingMode.HALF_UP).doubleValue()
                : 0;
        return String.format(Locale.US, "%.1f %%", valor);
    }

    private ArrayList<Incidencia> incidenciasActivas() {
        ArrayList<Incidencia> activas = new ArrayList<>();
        for (Incidencia i : new IncidenciaDao().listarIncidencias(true)) {
            if (!"Servicio restaurado".equals(i.getEstado()) && !"Cerrada".equals(i.getEstado())) {
                activas.add(i);
            }
        }
        return activas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasSegmentos(ArrayList<Segmento> segmentos) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Segmento s : segmentos) {
            BigDecimal total = numero(s.getCapacidadTotal());
            BigDecimal usada = numero(s.getCapacidadUsada());
            BigDecimal reservada = numero(s.getCapacidadReservada());
            double utilizacion = total.signum() > 0
                    ? usada.multiply(BigDecimal.valueOf(100)).divide(total, 1, RoundingMode.HALF_UP).doubleValue()
                    : 0;

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("ID", codigoSegmento(s.getIdSegmento()));
            f.put("Origen", valor(s.getNombreOrigen()));
            f.put("Destino", valor(s.getNombreDestino()));
            f.put("Ruta", valor(s.getNombreOrigen()) + " - " + valor(s.getNombreDestino()));
            f.put("Total", gbps(total));
            f.put("En uso", gbps(usada));
            f.put("Reservada", gbps(reservada));
            f.put("Disponible", gbps(total.subtract(usada).subtract(reservada)));
            f.put("Utilización", String.format(Locale.US, "%.1f %%", utilizacion));
            f.put("UtilizacionValor", String.format(Locale.US, "%.1f", utilizacion));
            f.put("Nivel", nivelUtilizacion(utilizacion));
            f.put("Estado", valor(s.getEstado()));
            filas.add(f);
        }
        return filas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasIncidencias(ArrayList<Incidencia> incidencias,
                                                                      HashMap<Integer, Segmento> segmentos,
                                                                      HashMap<Integer, Servicio> servicios) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Incidencia i : incidencias) {
            ArrayList<String> codigos = new ArrayList<>();
            TreeSet<String> landings = new TreeSet<>();
            for (Integer idSegmento : ids(i.getIdsSegmentos())) {
                codigos.add(codigoSegmento(idSegmento));
                Segmento s = segmentos.get(idSegmento);
                if (s != null) {
                    landings.add(valor(s.getNombreOrigen()));
                    landings.add(valor(s.getNombreDestino()));
                }
            }

            TreeSet<String> clientes = new TreeSet<>();
            ArrayList<String> serviciosAfectados = new ArrayList<>();
            for (Integer idServicio : ids(i.getIdsServicios())) {
                Servicio sv = servicios.get(idServicio);
                if (sv != null) {
                    clientes.add(valor(sv.getRazonSocial()));
                    serviciosAfectados.add(valor(sv.getIdentificador()));
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("Incidencia", valor(i.getIdentificador()));
            f.put("Landings afectadas", unir(landings));
            f.put("Observaciones", valor(i.getObservaciones()));
            f.put("Segmentos afectados", unir(codigos));
            f.put("Estado", valor(i.getEstado()));
            f.put("Severidad", valor(i.getSeveridad()));
            f.put("Servicios afectados", unir(serviciosAfectados));
            f.put("Clientes afectados", unir(clientes));
            f.put("Detectado", fecha(i.getFechaRegistro()));
            filas.add(f);
        }
        return filas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasMantenimientos(ArrayList<Mantenimiento> mantenimientos,
                                                                         ArrayList<LandingStation> landings,
                                                                         ArrayList<Segmento> segmentos,
                                                                         ArrayList<Servicio> servicios) {
        HashMap<Integer, LandingStation> mapaLandings = mapaLandings(landings);
        HashMap<Integer, Segmento> mapaSegmentos = mapaSegmentos(segmentos);

        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Mantenimiento m : mantenimientos) {
            String infraestructura = "-";
            String ubicacion = "-";
            HashSet<Integer> segmentosAfectados = new HashSet<>();

            if (m.getIdSegmento() != 0) {
                Segmento s = mapaSegmentos.get(m.getIdSegmento());
                infraestructura = codigoSegmento(m.getIdSegmento());
                if (s != null) {
                    ubicacion = valor(s.getNombreOrigen()) + " - " + valor(s.getNombreDestino());
                }
                segmentosAfectados.add(m.getIdSegmento());
            } else if (m.getIdLandingStation() != 0) {
                LandingStation l = mapaLandings.get(m.getIdLandingStation());
                if (l != null) {
                    infraestructura = valor(l.getNombre());
                    ubicacion = valor(l.getCiudad()) + ", " + valor(l.getPais());
                }
                for (Segmento s : segmentos) {
                    if (s.getIdOrigen() == m.getIdLandingStation() || s.getIdDestino() == m.getIdLandingStation()) {
                        segmentosAfectados.add(s.getIdSegmento());
                    }
                }
            }

            ArrayList<String> serviciosAfectados = new ArrayList<>();
            for (Servicio sv : servicios) {
                if (segmentosAfectados.contains(sv.getIdSegmento())) {
                    serviciosAfectados.add(valor(sv.getIdentificador()));
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("ID", "MANT-" + String.format("%03d", m.getIdMantenimiento()));
            f.put("Nombre", valor(m.getNombre()));
            f.put("Estado", valor(m.getEstado()));
            f.put("Fecha", fecha(m.getFechaRegistrada()));
            f.put("Infraestructura", infraestructura);
            f.put("Ubicación", ubicacion);
            f.put("Tipo", valor(m.getTipo()));
            f.put("Descripción", valor(m.getDescripcion()));
            f.put("Duración (horas)", String.valueOf(m.getDuracionHoras()));
            f.put("Actividades realizadas", valor(m.getActividadesRealizadas()));
            f.put("Servicios afectados", unir(serviciosAfectados));
            filas.add(f);
        }
        return filas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasLandings(ArrayList<LandingStation> landings,
                                                                   ArrayList<Segmento> segmentos,
                                                                   ArrayList<Incidencia> incidenciasActivas,
                                                                   ArrayList<Mantenimiento> mantenimientos) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (LandingStation l : landings) {
            HashSet<Integer> segmentosLanding = new HashSet<>();
            for (Segmento s : segmentos) {
                if (s.getIdOrigen() == l.getIdLandingStation() || s.getIdDestino() == l.getIdLandingStation()) {
                    segmentosLanding.add(s.getIdSegmento());
                }
            }

            int incidencias = 0;
            for (Incidencia i : incidenciasActivas) {
                for (Integer idSegmento : ids(i.getIdsSegmentos())) {
                    if (segmentosLanding.contains(idSegmento)) {
                        incidencias++;
                        break;
                    }
                }
            }

            int cantidadMantenimientos = 0;
            for (Mantenimiento m : mantenimientos) {
                if (m.getIdLandingStation() == l.getIdLandingStation()) {
                    cantidadMantenimientos++;
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("ID", "LS-" + String.format("%03d", l.getIdLandingStation()));
            f.put("Nombre", valor(l.getNombre()));
            f.put("Ubicación", valor(l.getCiudad()) + ", " + valor(l.getPais()));
            f.put("Estado", valor(l.getEstado()));
            f.put("Segmentos", String.valueOf(segmentosLanding.size()));
            f.put("Incidencias activas", String.valueOf(incidencias));
            f.put("Mantenimientos", String.valueOf(cantidadMantenimientos));
            filas.add(f);
        }
        return filas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasServicios(ArrayList<Servicio> servicios) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Servicio sv : servicios) {
            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("Servicio", valor(sv.getIdentificador()));
            f.put("Cliente", valor(sv.getRazonSocial()));
            f.put("Segmento", codigoSegmento(sv.getIdSegmento()));
            f.put("Capacidad", gbps(sv.getCapacidad()));
            f.put("Activación", fecha(sv.getFechaActivacion()));
            f.put("Caducidad del Servicio", fecha(sv.getFechaCaducidad()));
            f.put("Estado", valor(sv.getEstado()));
            filas.add(f);
        }
        return filas;
    }

    private ArrayList<LinkedHashMap<String, String>> filasClientes(ArrayList<Cliente> clientes, ArrayList<Servicio> servicios) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Cliente c : clientes) {
            ArrayList<String> contratados = new ArrayList<>();
            int vigentes = 0;
            BigDecimal capacidad = BigDecimal.ZERO;
            for (Servicio sv : servicios) {
                if (sv.getIdCliente() == c.getIdCliente()) {
                    contratados.add(valor(sv.getIdentificador()));
                    if (ServicioDao.esVigente(sv)) {
                        vigentes++;
                        capacidad = capacidad.add(numero(sv.getCapacidad()));
                    }
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("Identificador", valor(c.getIdentificador()));
            f.put("Razón Social", valor(c.getRazonSocial()));
            f.put("Servicios Contratados", unir(contratados));
            f.put("Servicios vigentes", String.valueOf(vigentes));
            f.put("Capacidad contratada", gbps(capacidad));
            f.put("CapacidadValor", capacidad.toPlainString());
            f.put("Fecha de cliente registrado", fecha(c.getFechaRegistro()));
            f.put("Estado", valor(c.getEstado()));
            filas.add(f);
        }
        return filas;
    }

    private HashMap<Integer, Segmento> mapaSegmentos(ArrayList<Segmento> segmentos) {
        HashMap<Integer, Segmento> mapa = new HashMap<>();
        for (Segmento s : segmentos) {
            mapa.put(s.getIdSegmento(), s);
        }
        return mapa;
    }

    private HashMap<Integer, LandingStation> mapaLandings(ArrayList<LandingStation> landings) {
        HashMap<Integer, LandingStation> mapa = new HashMap<>();
        for (LandingStation l : landings) {
            mapa.put(l.getIdLandingStation(), l);
        }
        return mapa;
    }

    private HashMap<Integer, Servicio> mapaServicios(ArrayList<Servicio> servicios) {
        HashMap<Integer, Servicio> mapa = new HashMap<>();
        for (Servicio sv : servicios) {
            mapa.put(sv.getIdServicio(), sv);
        }
        return mapa;
    }

    private List<Integer> ids(List<Integer> lista) {
        return lista == null ? new ArrayList<>() : lista;
    }

    private String codigoSegmento(int idSegmento) {
        return "SEG-" + String.format("%03d", idSegmento);
    }

    private BigDecimal numero(BigDecimal valor) {
        return valor == null ? BigDecimal.ZERO : valor;
    }

    private String gbps(BigDecimal valor) {
        return numero(valor).stripTrailingZeros().toPlainString() + " Gbps";
    }

    private String fecha(Date fecha) {
        return fecha == null ? "-" : new SimpleDateFormat("dd/MM/yyyy").format(fecha);
    }

    private String unir(Collection<String> valores) {
        return valores.isEmpty() ? "-" : String.join(", ", valores);
    }

    private String valor(String texto) {
        return texto == null || texto.isBlank() ? "-" : texto;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
