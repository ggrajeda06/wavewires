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
import java.util.*;
import java.util.List;

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
                view = request.getRequestDispatcher("Supervisor/reportes_supervisor.jsp");
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
    }

    private void generarPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tipo = texto(request.getParameter("tipo"));
        String estado = texto(request.getParameter("estado"));
        String[] columnas = request.getParameterValues("columnas");

        if (columnas == null || columnas.length == 0) {
            response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=reportes&error=columnas");
            return;
        }

        ArrayList<LinkedHashMap<String, String>> filas;
        String titulo;

        switch (tipo) {
            case "mantenimientos":
                filas = filasMantenimientos(new MantenimientoDao().listarMantenimientos(),
                        new LandingStationDao().listarLandingStations(),
                        new SegmentoDao().listarSegmentos(),
                        new ServicioDao().listarServicios());
                titulo = "Mantenimientos";
                break;

            case "incidencias":
                ArrayList<Segmento> segmentosInc = new SegmentoDao().listarSegmentos();
                filas = filasIncidencias(new IncidenciaDao().listarIncidencias(false),
                        mapaSegmentos(segmentosInc), mapaServicios(new ServicioDao().listarServicios()));
                titulo = "Incidencias";
                break;

            case "segmentos":
                filas = filasSegmentos(new SegmentoDao().listarSegmentos());
                titulo = "Segmentos";
                break;

            case "landings":
                filas = filasLandings(new LandingStationDao().listarLandingStations(),
                        new SegmentoDao().listarSegmentos(),
                        incidenciasActivas(),
                        new MantenimientoDao().listarMantenimientos());
                titulo = "Landing Stations";
                break;

            case "servicios":
                filas = filasServicios(new ServicioDao().listarServicios());
                titulo = "Servicios";
                break;

            case "clientes":
                filas = filasClientes(new ClienteDao().listarClientes(), new ServicioDao().listarServicios());
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
                    + "   |   Estado: " + (estado.isEmpty() ? "Todos" : estado)
                    + "   |   Registros: " + filas.size(), new Font(Font.HELVETICA, 10)));
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
            for (Integer idServicio : ids(i.getIdsServicios())) {
                Servicio sv = servicios.get(idServicio);
                if (sv != null) {
                    clientes.add(valor(sv.getRazonSocial()));
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("Incidencia", valor(i.getIdentificador()));
            f.put("Landings afectadas", unir(landings));
            f.put("Observaciones", valor(i.getObservaciones()));
            f.put("Segmentos afectados", unir(codigos));
            f.put("Estado", valor(i.getEstado()));
            f.put("Severidad", valor(i.getSeveridad()));
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
            for (Servicio sv : servicios) {
                if (sv.getIdCliente() == c.getIdCliente()) {
                    contratados.add(valor(sv.getIdentificador()));
                }
            }

            LinkedHashMap<String, String> f = new LinkedHashMap<>();
            f.put("Identificador", valor(c.getIdentificador()));
            f.put("Razón Social", valor(c.getRazonSocial()));
            f.put("Servicios Contratados", unir(contratados));
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
