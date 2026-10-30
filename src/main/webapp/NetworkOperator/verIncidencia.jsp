<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.ServicioAfectado" %>
<%@ page import="com.oceanlink.beans.Mantenimiento" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="incidencia" type="com.oceanlink.beans.Incidencia" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaAfectados" type="java.util.ArrayList<com.oceanlink.beans.ServicioAfectado>" scope="request" />
<jsp:useBean id="listaCorrectivos" type="java.util.ArrayList<com.oceanlink.beans.Mantenimiento>" scope="request" />
<%
    ArrayList<String> clientesAfectados = new ArrayList<>();
    for (ServicioAfectado sa : listaAfectados) {
        if (!clientesAfectados.contains(sa.getRazonSocial())) {
            clientesAfectados.add(sa.getRazonSocial());
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Detalle de incidencia</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/IncidenciaServlet" class="btn btn-outline-secondary btn-sm me-3">Volver</a>
      <h3 class="fw-bold m-0">Incidencia <%= incidencia.getIdentificador() %></h3>
    </div>

    <div class="card shadow-sm border-0 p-4 mb-3">
      <div class="row g-3">
        <div class="col-md-3">
          <small class="text-muted d-block">Estado</small>
          <span class="fw-semibold"><%= incidencia.getEstado() %></span>
        </div>
        <div class="col-md-3">
          <small class="text-muted d-block">Severidad</small>
          <span class="fw-semibold"><%= incidencia.getSeveridad() %></span>
        </div>
        <div class="col-md-3">
          <small class="text-muted d-block">Detectada</small>
          <span class="fw-semibold"><%= incidencia.getFechaRegistro() %></span>
        </div>
        <div class="col-md-3">
          <small class="text-muted d-block">Cerrada</small>
          <span class="fw-semibold"><%= incidencia.getFechaCierre() == null ? "-" : incidencia.getFechaCierre().toString() %></span>
        </div>
        <div class="col-12">
          <small class="text-muted d-block">Observaciones</small>
          <div style="white-space: pre-line;"><%= incidencia.getObservaciones() == null ? "Sin observaciones." : incidencia.getObservaciones() %></div>
        </div>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-md-6">
        <div class="card shadow-sm border-0 p-3 h-100">
          <h6 class="fw-bold">Infraestructura afectada</h6>
          <table class="table table-sm mb-0">
            <thead>
              <tr>
                <th>Segmento</th>
                <th>Origen</th>
                <th>Destino</th>
                <th>Estado actual</th>
              </tr>
            </thead>
            <tbody>
              <% for (Segmento s : listaSegmentos) { %>
              <tr>
                <td>SEG-<%= String.format("%03d", s.getIdSegmento()) %></td>
                <td><%= s.getNombreOrigen() %></td>
                <td><%= s.getNombreDestino() %></td>
                <td><%= s.getEstado() %></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <div class="col-md-6">
        <div class="card shadow-sm border-0 p-3 h-100">
          <h6 class="fw-bold">Clientes afectados</h6>
          <% if (clientesAfectados.isEmpty()) { %>
          <p class="text-muted mb-0">Ningún cliente afectado.</p>
          <% } else { %>
          <ul class="mb-0">
            <% for (String cliente : clientesAfectados) { %>
            <li><%= cliente %></li>
            <% } %>
          </ul>
          <% } %>
        </div>
      </div>
    </div>

    <div class="card shadow-sm border-0 p-3 mb-3">
      <h6 class="fw-bold">Servicios afectados</h6>
      <% if (listaAfectados.isEmpty()) { %>
      <p class="text-muted mb-0">Ningún servicio activo pasa por estos segmentos.</p>
      <% } else { %>
      <table class="table table-sm mb-0">
        <thead>
          <tr>
            <th>Servicio</th>
            <th>Segmento</th>
            <th>Capacidad</th>
            <th>Cliente</th>
            <th>Restauración</th>
          </tr>
        </thead>
        <tbody>
          <% for (ServicioAfectado sa : listaAfectados) { %>
          <tr>
            <td><%= sa.getIdentificadorServicio() %></td>
            <td>SEG-<%= String.format("%03d", sa.getIdSegmento()) %></td>
            <td><%= sa.getCapacidad().stripTrailingZeros().toPlainString() %> Gbps</td>
            <td><%= sa.getRazonSocial() %></td>
            <td>
              <% if (sa.getFechaRestauracion() == null) { %>
              <span class="badge bg-danger">Afectado</span>
              <% } else { %>
              <span class="badge bg-success">Restaurado el <%= sa.getFechaRestauracion() %></span>
              <% } %>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <div class="card shadow-sm border-0 p-3 mb-3">
      <h6 class="fw-bold">Mantenimientos correctivos</h6>
      <% if (listaCorrectivos.isEmpty()) { %>
      <p class="text-muted mb-0">Sin mantenimientos correctivos.</p>
      <% } else { %>
      <table class="table table-sm mb-0">
        <thead>
          <tr>
            <th>Mantenimiento</th>
            <th>Estado</th>
            <th>Fecha</th>
          </tr>
        </thead>
        <tbody>
          <% for (Mantenimiento m : listaCorrectivos) { %>
          <tr>
            <td><a href="<%=request.getContextPath()%>/MantenimientoServlet?action=ver&id=<%= m.getIdMantenimiento() %>">ID<%= m.getIdMantenimiento() %> - <%= m.getNombre() %></a></td>
            <td><%= m.getEstado() %></td>
            <td><%= m.getFechaRegistrada() %></td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <% if (!incidencia.getEstado().equals("Cerrada")) { %>
    <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=editar&id=<%= incidencia.getIdIncidencia() %>" class="btn btn-primary">Editar</a>
    <% } %>
  </main>
</div>
</body>
</html>