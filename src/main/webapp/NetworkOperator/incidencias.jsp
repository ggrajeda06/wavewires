<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
    int landingsOperativas = 0;
    int landingsEnMantenimiento = 0;
    for (LandingStation ls : listaLandings) {
        if ("Operativa".equals(ls.getEstado())) {
            landingsOperativas++;
        }
        if ("Mantenimiento".equals(ls.getEstado())) {
            landingsEnMantenimiento++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Incidencias</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0">Incidencias</h3>
      <a class="btn btn-primary shadow-sm" href="<%=request.getContextPath()%>/IncidenciaServlet?action=formCrear">+ Registrar incidencia</a>
    </div>

    <div class="row g-2 mb-3">
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Landings Operativas</small>
          <div class="fs-4 fw-semibold"><%= landingsOperativas %> de <%= listaLandings.size() %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Landings en Mantenimiento</small>
          <div class="fs-4 fw-semibold"><%= landingsEnMantenimiento %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Incidencias Registradas</small>
          <div class="fs-4 fw-semibold"><%= lista.size() %></div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">Incidencia</th>
                <th scope="col">Landing afectada</th>
                <th scope="col">Observaciones</th>
                <th scope="col">Segmentos afectados</th>
                <th scope="col">Estado</th>
                <th scope="col">Severidad</th>
                <th scope="col">Clientes afectados</th>
                <th scope="col" class="text-end pe-4">Acción</th>
              </tr>
            </thead>
            <tbody>
              <% for (Incidencia inc : lista) {
                   String nombreLanding = "Desconocida";
                   for (LandingStation ls : listaLandings) {
                       if (ls.getIdLandingStation() == inc.getIdLandingStation()) {
                           nombreLanding = ls.getNombre();
                       }
                   }

                   String colorEstado = "bg-secondary";
                   if ("Abierta".equalsIgnoreCase(inc.getEstado())) {
                       colorEstado = "bg-danger";
                   } else if ("En proceso".equalsIgnoreCase(inc.getEstado())) {
                       colorEstado = "bg-warning text-dark";
                   } else if ("Resuelta".equalsIgnoreCase(inc.getEstado())) {
                       colorEstado = "bg-success";
                   }

                   String colorSeveridad = "text-secondary";
                   if ("Crítica".equalsIgnoreCase(inc.getSeveridad()) || "Alta".equalsIgnoreCase(inc.getSeveridad())) {
                       colorSeveridad = "text-danger fw-bold";
                   } else if ("Media".equalsIgnoreCase(inc.getSeveridad())) {
                       colorSeveridad = "text-warning fw-bold";
                   } else if ("Baja".equalsIgnoreCase(inc.getSeveridad())) {
                       colorSeveridad = "text-success fw-bold";
                   }
              %>
              <tr>
                <td class="ps-4 fw-bold text-dark"><%= inc.getIdentificador() %></td>
                <td><%= nombreLanding %></td>
                <td>
                  <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#obsModal<%= inc.getIdIncidencia() %>">Detalle</button>
                </td>
                <td>
                  <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#segModal<%= inc.getIdIncidencia() %>">Detalle</button>
                </td>
                <td><span class="badge rounded-pill px-3 py-2 <%= colorEstado %>"><%= inc.getEstado() %></span></td>
                <td><span class="<%= colorSeveridad %>"><%= inc.getSeveridad() %></span></td>
                <td>
                  <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#cliModal<%= inc.getIdIncidencia() %>">Detalle</button>
                </td>
                <td class="text-end pe-4">
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=editar&id=<%= inc.getIdIncidencia() %>" class="btn btn-sm btn-outline-primary me-1">Editar</a>
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=borrar&id=<%= inc.getIdIncidencia() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Estás seguro de eliminar esta incidencia?')">Borrar</a>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <% for (Incidencia inc : lista) {
         ArrayList<Servicio> serviciosAfectados = new ArrayList<>();
         ArrayList<String> clientesAfectados = new ArrayList<>();
         for (Servicio sv : listaServicios) {
             if (inc.getIdsServicios() != null && inc.getIdsServicios().contains(sv.getIdServicio())) {
                 serviciosAfectados.add(sv);
                 if (!clientesAfectados.contains(sv.getRazonSocial())) {
                     clientesAfectados.add(sv.getRazonSocial());
                 }
             }
         }
    %>
      <div class="modal fade" id="obsModal<%= inc.getIdIncidencia() %>" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title fw-bold">Observaciones — <%= inc.getIdentificador() %></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <p class="mb-0"><%= inc.getObservaciones() != null ? inc.getObservaciones() : "Sin observaciones registradas." %></p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cerrar</button>
            </div>
          </div>
        </div>
      </div>

      <div class="modal fade" id="segModal<%= inc.getIdIncidencia() %>" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title fw-bold">Segmentos afectados — <%= inc.getIdentificador() %></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <ul class="mb-0">
                <% if (serviciosAfectados.isEmpty()) { %>
                <li>Ningún servicio asociado</li>
                <% } %>
                <% for (Servicio sv : serviciosAfectados) { %>
                <li>SEG-<%= String.format("%03d", sv.getIdSegmento()) %> (<%= sv.getIdentificador() %>)</li>
                <% } %>
              </ul>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cerrar</button>
            </div>
          </div>
        </div>
      </div>

      <div class="modal fade" id="cliModal<%= inc.getIdIncidencia() %>" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title fw-bold">Clientes afectados — <%= inc.getIdentificador() %></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <ul class="mb-0">
                <% if (clientesAfectados.isEmpty()) { %>
                <li>Ningún cliente afectado</li>
                <% } %>
                <% for (String cliente : clientesAfectados) { %>
                <li><%= cliente %></li>
                <% } %>
              </ul>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cerrar</button>
            </div>
          </div>
        </div>
      </div>
    <% } %>

  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>