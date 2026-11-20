<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Mantenimiento" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.util.Html" %>
<%
  // si se entra directo al JSP no hay datos: se manda al servlet que los trae
  if (request.getAttribute("totalUsuarios") == null) {
      response.sendRedirect(request.getContextPath() + "/ResumenServlet");
      return;
  }
%>
<jsp:useBean id="cuentasPorRol" type="java.util.ArrayList<java.lang.String[]>" scope="request" />
<jsp:useBean id="segmentosNoOperativos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="ultimasIncidencias" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<jsp:useBean id="proximosMantenimientos" type="java.util.ArrayList<com.oceanlink.beans.Mantenimiento>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OceanLink - Resumen</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/WEB-INF/views/Administrador/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="mb-4">
      <h3 class="fw-bold m-0">Resumen</h3>
      <small class="text-muted">Vista general de usuarios, infraestructura y operación de la red</small>
    </div>

    <%-- Tarjetas: cada una lleva a su modulo --%>
    <div class="row g-3 mb-4">
      <div class="col-sm-6 col-xl-3">
        <a href="<%=ctx%>/UsuarioServlet" class="card shadow-sm border-0 p-3 h-100 text-decoration-none text-dark">
          <small class="text-muted"><i class="bi bi-people me-1"></i>Usuarios</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("usuariosActivos") %> <span class="fs-6 text-muted">de <%= request.getAttribute("totalUsuarios") %></span></div>
          <div class="small text-muted">con cuenta activa</div>
          <span class="small text-primary mt-2">Ver usuarios <i class="bi bi-arrow-right"></i></span>
        </a>
      </div>
      <div class="col-sm-6 col-xl-3">
        <a href="<%=ctx%>/LandingStationServlet" class="card shadow-sm border-0 p-3 h-100 text-decoration-none text-dark">
          <small class="text-muted"><i class="bi bi-geo-alt me-1"></i>Landing Stations</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("totalLandings") %></div>
          <div class="small text-muted">registradas</div>
          <span class="small text-primary mt-2">Ver landings <i class="bi bi-arrow-right"></i></span>
        </a>
      </div>
      <div class="col-sm-6 col-xl-3">
        <a href="<%=ctx%>/SegmentoServlet" class="card shadow-sm border-0 p-3 h-100 text-decoration-none text-dark">
          <small class="text-muted"><i class="bi bi-diagram-3 me-1"></i>Segmentos operativos</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("segmentosOperativos") %> <span class="fs-6 text-muted">de <%= request.getAttribute("totalSegmentos") %></span></div>
          <div class="small text-muted">en servicio normal</div>
          <span class="small text-primary mt-2">Ver segmentos <i class="bi bi-arrow-right"></i></span>
        </a>
      </div>
      <div class="col-sm-6 col-xl-3">
        <a href="<%=ctx%>/IncidenciaServlet" class="card shadow-sm border-0 p-3 h-100 text-decoration-none text-dark">
          <small class="text-muted"><i class="bi bi-exclamation-triangle me-1"></i>Incidencias abiertas</small>
          <div class="fs-3 fw-semibold <%= ((Integer) request.getAttribute("incidenciasAbiertas")) > 0 ? "text-danger" : "" %>"><%= request.getAttribute("incidenciasAbiertas") %></div>
          <div class="small text-muted">sin restaurar ni cerrar</div>
          <span class="small text-primary mt-2">Ver incidencias <i class="bi bi-arrow-right"></i></span>
        </a>
      </div>
    </div>

    <div class="row g-3 mb-4">

      <%-- Cuentas activas por rol --%>
      <div class="col-lg-5">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-header bg-white fw-semibold">Cuentas activas por rol</div>
          <table class="table table-sm align-middle mb-0">
            <thead class="table-light">
            <tr><th class="ps-3">Rol</th><th class="text-end pe-3">Activas</th></tr>
            </thead>
            <tbody>
            <% for (String[] fila : cuentasPorRol) { %>
            <tr>
              <td class="ps-3"><%= Html.esc(fila[0]) %></td>
              <td class="text-end pe-3"><%= fila[1] %></td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <%-- Segmentos no operativos --%>
      <div class="col-lg-7">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-header bg-white fw-semibold d-flex justify-content-between align-items-center">
            Segmentos no operativos
            <a href="<%=ctx%>/SegmentoServlet" class="small fw-normal text-decoration-none">Ver segmentos <i class="bi bi-arrow-right"></i></a>
          </div>
          <% if (segmentosNoOperativos.isEmpty()) { %>
          <div class="card-body text-center text-muted">
            <i class="bi bi-check-circle text-success fs-3 d-block mb-1"></i>
            Todos los segmentos están operativos.
          </div>
          <% } else { %>
          <table class="table table-sm align-middle mb-0">
            <thead class="table-light">
            <tr><th class="ps-3">Segmento</th><th>Ruta</th><th class="pe-3">Estado</th></tr>
            </thead>
            <tbody>
            <% for (Segmento s : segmentosNoOperativos) {
                 String colorEstado = "bg-warning-subtle text-warning-emphasis";
                 if (s.getEstado().equals("Fuera de servicio")) {
                   colorEstado = "bg-danger-subtle text-danger";
                 } else if (s.getEstado().equals("En mantenimiento")) {
                   colorEstado = "bg-info-subtle text-info-emphasis";
                 }
            %>
            <tr>
              <td class="ps-3">SEG-<%= String.format("%03d", s.getIdSegmento()) %></td>
              <td><%= Html.esc(s.getNombreOrigen()) %> - <%= Html.esc(s.getNombreDestino()) %></td>
              <td class="pe-3"><span class="badge <%=colorEstado%>"><%= Html.esc(s.getEstado()) %></span></td>
            </tr>
            <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>
    </div>

    <div class="row g-3">

      <%-- Ultimas incidencias abiertas (solo consulta: las gestiona el Network Operator) --%>
      <div class="col-lg-6">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-header bg-white fw-semibold d-flex justify-content-between align-items-center">
            Últimas incidencias abiertas
            <a href="<%=ctx%>/IncidenciaServlet" class="small fw-normal text-decoration-none">Ver todas <i class="bi bi-arrow-right"></i></a>
          </div>
          <% if (ultimasIncidencias.isEmpty()) { %>
          <div class="card-body text-center text-muted">
            <i class="bi bi-check-circle text-success fs-3 d-block mb-1"></i>
            No hay incidencias abiertas.
          </div>
          <% } else { %>
          <table class="table table-sm align-middle mb-0">
            <thead class="table-light">
            <tr><th class="ps-3">Incidencia</th><th>Severidad</th><th>Estado</th><th class="pe-3">Detectada</th></tr>
            </thead>
            <tbody>
            <% for (Incidencia inc : ultimasIncidencias) {
                 String segmentosTexto = "";
                 for (Integer idSeg : inc.getIdsSegmentos()) {
                   if (!segmentosTexto.isEmpty()) {
                     segmentosTexto = segmentosTexto + ", ";
                   }
                   segmentosTexto = segmentosTexto + "SEG-" + String.format("%03d", idSeg);
                 }
                 String colorSeveridad = "bg-secondary-subtle text-secondary";
                 if (inc.getSeveridad().equals("Alta") || inc.getSeveridad().equals("Crítica")) {
                   colorSeveridad = "bg-danger-subtle text-danger";
                 } else if (inc.getSeveridad().equals("Media")) {
                   colorSeveridad = "bg-warning-subtle text-warning-emphasis";
                 }
            %>
            <tr>
              <td class="ps-3">
                <a href="<%=ctx%>/IncidenciaServlet?action=ver&id=<%=inc.getIdIncidencia()%>" class="text-decoration-none fw-semibold"><%= Html.esc(inc.getIdentificador()) %></a>
                <div class="small text-muted"><%= segmentosTexto %></div>
              </td>
              <td><span class="badge <%=colorSeveridad%>"><%= Html.esc(inc.getSeveridad()) %></span></td>
              <td class="small"><%= Html.esc(inc.getEstado()) %></td>
              <td class="pe-3 small text-muted"><%= inc.getFechaRegistro() %></td>
            </tr>
            <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>

      <%-- Proximos mantenimientos (solo consulta: los gestiona el Maintenance Coordinator) --%>
      <div class="col-lg-6">
        <div class="card shadow-sm border-0 h-100">
          <div class="card-header bg-white fw-semibold d-flex justify-content-between align-items-center">
            Próximos mantenimientos
            <a href="<%=ctx%>/MantenimientoServlet" class="small fw-normal text-decoration-none">Ver todos <i class="bi bi-arrow-right"></i></a>
          </div>
          <% if (proximosMantenimientos.isEmpty()) { %>
          <div class="card-body text-center text-muted">
            <i class="bi bi-check-circle text-success fs-3 d-block mb-1"></i>
            No hay mantenimientos pendientes.
          </div>
          <% } else { %>
          <table class="table table-sm align-middle mb-0">
            <thead class="table-light">
            <tr><th class="ps-3">Mantenimiento</th><th>Tipo</th><th>Estado</th><th class="pe-3">Fecha</th></tr>
            </thead>
            <tbody>
            <% for (Mantenimiento m : proximosMantenimientos) {
                 // infraestructura: el segmento, o el nombre de la landing si es sobre una landing
                 String infraestructura = "SEG-" + String.format("%03d", m.getIdSegmento());
                 if (m.getIdSegmento() == 0) {
                   infraestructura = "-";
                   for (LandingStation ls : listaLandings) {
                     if (ls.getIdLandingStation() == m.getIdLandingStation()) {
                       infraestructura = ls.getNombre();
                     }
                   }
                 }
                 String colorEstado = m.getEstado().equals("Activo") ? "bg-primary-subtle text-primary" : "bg-secondary-subtle text-secondary";
            %>
            <tr>
              <td class="ps-3">
                <a href="<%=ctx%>/MantenimientoServlet?action=ver&id=<%=m.getIdMantenimiento()%>" class="text-decoration-none fw-semibold"><%= Html.esc(m.getNombre()) %></a>
                <div class="small text-muted"><%= Html.esc(infraestructura) %></div>
              </td>
              <td class="small"><%= Html.esc(m.getTipo()) %></td>
              <td><span class="badge <%=colorEstado%>"><%= Html.esc(m.getEstado()) %></span></td>
              <td class="pe-3 small"><%= m.getFechaRegistrada() %></td>
            </tr>
            <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>