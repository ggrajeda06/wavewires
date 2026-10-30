<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.LinkedHashMap" %>
<jsp:useBean id="filasSegmentos" type="java.util.ArrayList<java.util.LinkedHashMap<java.lang.String, java.lang.String>>" scope="request" />
<jsp:useBean id="filasIncidencias" type="java.util.ArrayList<java.util.LinkedHashMap<java.lang.String, java.lang.String>>" scope="request" />
<jsp:useBean id="filasMantenimientos" type="java.util.ArrayList<java.util.LinkedHashMap<java.lang.String, java.lang.String>>" scope="request" />
<%!
    private String esc(String texto) {
        if (texto == null) {
            return "";
        }
        return texto.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    private String colorBarra(String utilizacion) {
        double valor = Double.parseDouble(utilizacion);
        if (valor >= 90) {
            return "bg-danger";
        } else if (valor >= 80) {
            return "bg-warning";
        }
        return "bg-secondary";
    }

    private String colorSeveridad(String severidad) {
        switch (severidad) {
            case "Crítica":
                return "text-bg-danger";
            case "Alta":
                return "text-bg-warning";
            case "Media":
                return "text-bg-info";
            default:
                return "text-bg-secondary";
        }
    }

    private String colorMantenimiento(String estado) {
        switch (estado) {
            case "Activo":
                return "text-bg-primary";
            case "Finalizado":
                return "text-bg-success";
            default:
                return "text-bg-secondary";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="sidebarSupervisor.jsp"/>
    <main class="supervisor-main flex-grow-1 p-3 p-lg-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
            <h1 class="h3 fw-bold mb-0">Estado general de la red</h1>
        </div>
        <section class="card shadow-sm mb-4" aria-labelledby="tituloCapacidad">
            <div class="card-body p-3 p-lg-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                    <h2 class="h5 mb-0" id="tituloCapacidad">Capacidad de la red</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalCapacidad">Más detalles</button>
                </div>
                <div class="row g-3 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad total</span><p class="fs-5 fw-semibold mb-0 mt-2"><%=request.getAttribute("capTotal")%></p></div></div>
                    <div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad en uso</span><p class="fs-5 fw-semibold mb-0 mt-2"><%=request.getAttribute("capUsada")%></p></div></div>
                    <div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad reservada</span><p class="fs-5 fw-semibold mb-0 mt-2"><%=request.getAttribute("capReservada")%></p></div></div>
                    <div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad disponible</span><p class="fs-5 fw-semibold mb-0 mt-2"><%=request.getAttribute("capDisponible")%></p></div></div>
                </div>
                <div class="border rounded p-3">
                    <h3 class="h6 mb-3">Más utilizados</h3>
                    <div class="row g-3">
                        <% for (int i = 0; i < filasSegmentos.size() && i < 6; i++) {
                               LinkedHashMap<String, String> s = filasSegmentos.get(i); %>
                        <div class="col-12 col-lg-6">
                            <div class="d-flex justify-content-between small mb-1"><span><%=esc(s.get("ID"))%> · <%=esc(s.get("Ruta"))%></span><span><%=esc(s.get("Utilización"))%></span></div>
                            <div class="progress" role="progressbar" aria-label="Utilización de <%=esc(s.get("ID"))%>" aria-valuenow="<%=s.get("UtilizacionValor")%>" aria-valuemin="0" aria-valuemax="100">
                                <div class="progress-bar <%=colorBarra(s.get("UtilizacionValor"))%>" style="width: <%=s.get("UtilizacionValor")%>%"></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </section>
        <div class="row g-4">
            <div class="col-12 col-xl-6">
                <section class="card shadow-sm h-100" aria-labelledby="tituloIncidencias">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3"><h2 class="h5 mb-0" id="tituloIncidencias">Incidencias activas</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalIncidencias">Más detalles</button></div>
                        <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de incidencias">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light"><tr><th scope="col">ID de incidencia</th><th scope="col">Segmentos</th><th scope="col">Estado</th><th scope="col">Severidad</th></tr></thead>
                                <tbody>
                                <% for (LinkedHashMap<String, String> inc : filasIncidencias) { %>
                                <tr>
                                    <th scope="row" class="fw-normal"><%=esc(inc.get("Incidencia"))%></th>
                                    <td><%=esc(inc.get("Segmentos afectados"))%></td>
                                    <td><%=esc(inc.get("Estado"))%></td>
                                    <td><span class="badge <%=colorSeveridad(inc.get("Severidad"))%>"><%=esc(inc.get("Severidad"))%></span></td>
                                </tr>
                                <% } %>
                                <% if (filasIncidencias.isEmpty()) { %>
                                <tr><td colspan="4" class="text-secondary">No hay incidencias activas.</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </div>
            <div class="col-12 col-xl-6">
                <section class="card shadow-sm h-100" aria-labelledby="tituloMantenimientos">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3"><h2 class="h5 mb-0" id="tituloMantenimientos">Mantenimientos pendientes</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalMantenimientos">Más detalles</button></div>
                        <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de mantenimientos">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light"><tr><th scope="col">ID de mantenimiento</th><th scope="col">Infraestructura</th><th scope="col">Tipo</th><th scope="col">Fecha</th></tr></thead>
                                <tbody>
                                <% int pendientes = 0;
                                   for (LinkedHashMap<String, String> m : filasMantenimientos) {
                                       if (!"Pendiente".equals(m.get("Estado"))) {
                                           continue;
                                       }
                                       pendientes++; %>
                                <tr>
                                    <th scope="row" class="fw-normal"><%=esc(m.get("ID"))%></th>
                                    <td><%=esc(m.get("Infraestructura"))%></td>
                                    <td><%=esc(m.get("Tipo"))%></td>
                                    <td><%=esc(m.get("Fecha"))%></td>
                                </tr>
                                <% } %>
                                <% if (pendientes == 0) { %>
                                <tr><td colspan="4" class="text-secondary">No hay mantenimientos pendientes.</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</div>

<div class="modal fade" id="modalCapacidad" tabindex="-1" aria-labelledby="modalCapacidadTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalCapacidadTitulo">Capacidad por segmento</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body">
                <p class="small text-secondary">La capacidad disponible descuenta el uso y la reserva de cada segmento.</p>
                <div class="table-responsive" tabindex="0" role="region" aria-label="Capacidad por segmento">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th scope="col">Segmento</th><th scope="col">Ruta</th><th scope="col">Total</th><th scope="col">En uso</th><th scope="col">Reservada</th><th scope="col">Disponible</th><th scope="col">Estado</th><th scope="col">Utilización</th></tr></thead>
                        <tbody>
                        <% for (LinkedHashMap<String, String> s : filasSegmentos) { %>
                        <tr>
                            <th scope="row" class="fw-normal"><%=esc(s.get("ID"))%></th>
                            <td><%=esc(s.get("Ruta"))%></td>
                            <td><%=esc(s.get("Total"))%></td>
                            <td><%=esc(s.get("En uso"))%></td>
                            <td><%=esc(s.get("Reservada"))%></td>
                            <td><%=esc(s.get("Disponible"))%></td>
                            <td><%=esc(s.get("Estado"))%></td>
                            <td>
                                <span class="small text-nowrap"><%=esc(s.get("Utilización"))%></span>
                                <div class="progress" role="progressbar" aria-label="Utilización de <%=esc(s.get("ID"))%>" aria-valuenow="<%=s.get("UtilizacionValor")%>" aria-valuemin="0" aria-valuemax="100">
                                    <div class="progress-bar <%=colorBarra(s.get("UtilizacionValor"))%>" style="width: <%=s.get("UtilizacionValor")%>%"></div>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/SupervisorServlet?action=reportes">Reportar</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalIncidencias" tabindex="-1" aria-labelledby="modalIncidenciasTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalIncidenciasTitulo">Incidencias activas</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body">
                <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de incidencias">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th scope="col">ID de incidencia</th><th scope="col">Landings afectadas</th><th scope="col">Observaciones</th><th scope="col">Segmentos afectados</th><th scope="col">Estado</th><th scope="col">Severidad</th><th scope="col">Clientes afectados</th><th scope="col">Detectado</th></tr></thead>
                        <tbody>
                        <% for (LinkedHashMap<String, String> inc : filasIncidencias) { %>
                        <tr>
                            <th scope="row" class="fw-normal"><%=esc(inc.get("Incidencia"))%></th>
                            <td><%=esc(inc.get("Landings afectadas"))%></td>
                            <td><details><summary class="text-decoration-underline">Descripción</summary><div class="bg-light border rounded p-2 mt-2"><%=esc(inc.get("Observaciones"))%></div></details></td>
                            <td><%=esc(inc.get("Segmentos afectados"))%></td>
                            <td><span class="badge text-bg-secondary"><%=esc(inc.get("Estado"))%></span></td>
                            <td><span class="badge <%=colorSeveridad(inc.get("Severidad"))%>"><%=esc(inc.get("Severidad"))%></span></td>
                            <td><details><summary class="text-decoration-underline">Clientes</summary><div class="bg-light border rounded p-2 mt-2"><%=esc(inc.get("Clientes afectados"))%></div></details></td>
                            <td><%=esc(inc.get("Detectado"))%></td>
                        </tr>
                        <% } %>
                        <% if (filasIncidencias.isEmpty()) { %>
                        <tr><td colspan="8" class="text-secondary">No hay incidencias activas.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/SupervisorServlet?action=reportes">Reportar</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalMantenimientos" tabindex="-1" aria-labelledby="modalMantenimientosTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalMantenimientosTitulo">Historial de mantenimiento</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body">
                <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de mantenimientos">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light"><tr><th scope="col">ID de mantenimiento</th><th scope="col">Infraestructura</th><th scope="col">Servicios afectados</th><th scope="col">Tipo</th><th scope="col">Estado</th><th scope="col">Fecha</th><th scope="col">Ubicación</th><th scope="col">Información</th></tr></thead>
                        <tbody>
                        <% for (LinkedHashMap<String, String> m : filasMantenimientos) { %>
                        <tr>
                            <th scope="row" class="fw-normal"><%=esc(m.get("ID"))%></th>
                            <td><%=esc(m.get("Infraestructura"))%></td>
                            <td><%=esc(m.get("Servicios afectados"))%></td>
                            <td><%=esc(m.get("Tipo"))%></td>
                            <td><span class="badge <%=colorMantenimiento(m.get("Estado"))%>"><%=esc(m.get("Estado"))%></span></td>
                            <td><%=esc(m.get("Fecha"))%></td>
                            <td><%=esc(m.get("Ubicación"))%></td>
                            <td>
                                <button type="button" class="btn btn-link btn-sm text-nowrap"
                                        data-id="<%=esc(m.get("ID"))%>"
                                        data-descripcion="<%=esc(m.get("Descripción"))%>"
                                        data-duracion="<%=esc(m.get("Duración (horas)"))%>"
                                        data-actividades="<%=esc(m.get("Actividades realizadas"))%>"
                                        onclick="verDetalle(this)">Ver detalle</button>
                            </td>
                        </tr>
                        <% } %>
                        <% if (filasMantenimientos.isEmpty()) { %>
                        <tr><td colspan="8" class="text-secondary">No hay mantenimientos registrados.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/SupervisorServlet?action=reportes">Reportar</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDetalleMantenimiento" tabindex="-1" aria-labelledby="modalDetalleTitulo" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title fs-5" id="modalDetalleTitulo">Detalle de mantenimiento</h2>
                <button type="button" class="btn-close" data-bs-toggle="modal" data-bs-target="#modalMantenimientos" aria-label="Cerrar detalle y volver al listado"></button>
            </div>
            <div class="modal-body">
                <dl class="mb-0">
                    <dt>ID</dt><dd id="detalleId"></dd>
                    <dt>Descripción</dt><dd id="detalleDescripcion"></dd>
                    <dt>Duración estimada</dt><dd id="detalleDuracion"></dd>
                    <dt>Actividades realizadas</dt><dd class="mb-0" id="detalleActividades"></dd>
                </dl>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#modalMantenimientos">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function verDetalle(boton) {
  document.getElementById('modalDetalleTitulo').textContent = 'Detalle de mantenimiento ' + boton.dataset.id;
  document.getElementById('detalleId').textContent = boton.dataset.id;
  document.getElementById('detalleDescripcion').textContent = boton.dataset.descripcion;
  document.getElementById('detalleDuracion').textContent = boton.dataset.duracion + ' horas';
  document.getElementById('detalleActividades').textContent = boton.dataset.actividades;

  bootstrap.Modal.getOrCreateInstance(document.getElementById('modalMantenimientos')).hide();
  bootstrap.Modal.getOrCreateInstance(document.getElementById('modalDetalleMantenimiento')).show();
}
</script>
</body>
</html>
