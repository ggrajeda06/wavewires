package com.oceanlink.util;

import com.oceanlink.beans.*;
import com.oceanlink.daos.*;
import jakarta.servlet.http.HttpServletRequest;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.List;
import java.util.function.Function;

// Ayudas para armar las filas de los reportes del Supervisor (inicio, reportes y PDF)
public class Reportes {

    // RF38: filas del reporte elegido, aplicando los filtros propios de cada tipo.
    // Devuelve null si el tipo no existe.
    public static ArrayList<LinkedHashMap<String, String>> filasReporte(String tipo, HttpServletRequest request,
                                                                 LocalDate desde, LocalDate hasta,
                                                                 int idSegmento, ArrayList<String> filtros) {
        switch (tipo) {
            case "mantenimientos":
                ArrayList<Mantenimiento> mantenimientos = new MantenimientoDao().listarMantenimientos();
                String tipoMantenimiento = texto(request.getParameter("tipoMantenimiento"));
                if (!tipoMantenimiento.isEmpty()) {
                    mantenimientos.removeIf(m -> !tipoMantenimiento.equals(m.getTipo()));
                    filtros.add("Tipo: " + tipoMantenimiento);
                }
                filtrarPorFecha(mantenimientos, Mantenimiento::getFechaRegistrada, desde, hasta);
                return filasMantenimientos(mantenimientos,
                        new LandingStationDao().listarLandingStations(),
                        new SegmentoDao().listarSegmentos(),
                        new ServicioDao().listarServicios());

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
                return filasIncidencias(incidencias,
                        mapaSegmentos(segmentosInc), mapaServicios(new ServicioDao().listarServicios()));

            case "segmentos":
                ArrayList<LinkedHashMap<String, String>> filas = filasSegmentos(new SegmentoDao().listarSegmentos());
                String nivel = texto(request.getParameter("nivel"));
                if (!nivel.isEmpty()) {
                    filas.removeIf(f -> !nivel.equals(f.get("Nivel")));
                    filtros.add("Nivel: " + nivel);
                }
                return filas;

            case "landings":
                ArrayList<LandingStation> landings = new LandingStationDao().listarLandingStations();
                String pais = texto(request.getParameter("pais"));
                if (!pais.isEmpty()) {
                    landings.removeIf(l -> !pais.equals(l.getPais()));
                    filtros.add("País: " + pais);
                }
                return filasLandings(landings,
                        new SegmentoDao().listarSegmentos(),
                        incidenciasActivas(),
                        new MantenimientoDao().listarMantenimientos());

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
                return filasServicios(servicios);

            case "clientes":
                ArrayList<Cliente> clientes = new ClienteDao().listarClientes();
                filtrarPorFecha(clientes, Cliente::getFechaRegistro, desde, hasta);
                return filasClientes(clientes, new ServicioDao().listarServicios());

            default:
                return null;
        }
    }

    public static String titulo(String tipo) {
        switch (tipo) {
            case "mantenimientos":
                return "Mantenimientos";
            case "incidencias":
                return "Incidencias";
            case "segmentos":
                return "Segmentos";
            case "landings":
                return "Landing Stations";
            case "servicios":
                return "Servicios";
            case "clientes":
                return "Clientes";
            default:
                return "";
        }
    }

    public static ArrayList<Incidencia> incidenciasActivas() {
        ArrayList<Incidencia> activas = new ArrayList<>();
        for (Incidencia i : new IncidenciaDao().listarIncidencias(true)) {
            if (!"Servicio restaurado".equals(i.getEstado()) && !"Cerrada".equals(i.getEstado())) {
                activas.add(i);
            }
        }
        return activas;
    }

    public static ArrayList<LinkedHashMap<String, String>> filasSegmentos(ArrayList<Segmento> segmentos) {
        ArrayList<LinkedHashMap<String, String>> filas = new ArrayList<>();
        for (Segmento s : segmentos) {
            BigDecimal total = numero(s.getCapacidadTotal());
            BigDecimal usada = numero(s.getCapacidadUsada());
            BigDecimal reservada = numero(s.getCapacidadReservada());
            double utilizacion = utilizacion(usada, total);

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

    public static ArrayList<LinkedHashMap<String, String>> filasIncidencias(ArrayList<Incidencia> incidencias,
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

    public static ArrayList<LinkedHashMap<String, String>> filasMantenimientos(ArrayList<Mantenimiento> mantenimientos,
                                                                        ArrayList<LandingStation> landings,
                                                                        ArrayList<Segmento> segmentos,
                                                                        ArrayList<Servicio> servicios) {
        HashMap<Integer, LandingStation> mapaLandings = mapa(landings, LandingStation::getIdLandingStation);
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

    public static ArrayList<LinkedHashMap<String, String>> filasLandings(ArrayList<LandingStation> landings,
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
            f.put("Segmentos", String.valueOf(segmentosLanding.size()));
            f.put("Incidencias activas", String.valueOf(incidencias));
            f.put("Mantenimientos", String.valueOf(cantidadMantenimientos));
            filas.add(f);
        }
        return filas;
    }

    public static ArrayList<LinkedHashMap<String, String>> filasServicios(ArrayList<Servicio> servicios) {
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

    public static ArrayList<LinkedHashMap<String, String>> filasClientes(ArrayList<Cliente> clientes, ArrayList<Servicio> servicios) {
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

    public static HashMap<Integer, Segmento> mapaSegmentos(ArrayList<Segmento> segmentos) {
        return mapa(segmentos, Segmento::getIdSegmento);
    }

    public static HashMap<Integer, Servicio> mapaServicios(ArrayList<Servicio> servicios) {
        return mapa(servicios, Servicio::getIdServicio);
    }

    // Convierte una lista en un mapa por su id
    private static <T> HashMap<Integer, T> mapa(List<T> lista, Function<T, Integer> id) {
        HashMap<Integer, T> mapa = new HashMap<>();
        for (T elemento : lista) {
            mapa.put(id.apply(elemento), elemento);
        }
        return mapa;
    }

    private static <T> void filtrarPorFecha(ArrayList<T> lista, Function<T, Date> fecha, LocalDate desde, LocalDate hasta) {
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

    private static String nombreCliente(int idCliente) {
        for (Cliente c : new ClienteDao().listarClientes()) {
            if (c.getIdCliente() == idCliente) {
                return valor(c.getRazonSocial());
            }
        }
        return String.valueOf(idCliente);
    }

    // Niveles de alerta del documento: menor a 80 normal, de 80 a 95 alta, mayor a 95 critica
    private static String nivelUtilizacion(double utilizacion) {
        if (utilizacion > 95) {
            return "Utilización crítica";
        } else if (utilizacion >= 80) {
            return "Alta utilización";
        }
        return "Normal";
    }

    private static double utilizacion(BigDecimal parte, BigDecimal total) {
        return total.signum() > 0
                ? parte.multiply(BigDecimal.valueOf(100)).divide(total, 1, RoundingMode.HALF_UP).doubleValue()
                : 0;
    }

    public static String porcentaje(BigDecimal parte, BigDecimal total) {
        return String.format(Locale.US, "%.1f %%", utilizacion(parte, total));
    }

    public static List<Integer> ids(List<Integer> lista) {
        return lista == null ? new ArrayList<>() : lista;
    }

    public static String codigoSegmento(int idSegmento) {
        return "SEG-" + String.format("%03d", idSegmento);
    }

    public static BigDecimal numero(BigDecimal valor) {
        return valor == null ? BigDecimal.ZERO : valor;
    }

    public static String gbps(BigDecimal valor) {
        return numero(valor).stripTrailingZeros().toPlainString() + " Gbps";
    }

    private static String fecha(Date fecha) {
        return fecha == null ? "-" : new SimpleDateFormat("dd/MM/yyyy").format(fecha);
    }

    private static String unir(Collection<String> valores) {
        return valores.isEmpty() ? "-" : String.join(", ", valores);
    }

    public static String valor(String texto) {
        return texto == null || texto.isBlank() ? "-" : texto;
    }

    public static String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }

    public static int entero(String valor) {
        try {
            return Integer.parseInt(texto(valor));
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
