<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<jsp:useBean id="segmento" type="com.oceanlink.beans.Segmento" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
    boolean segmentoEnMantenimiento = segmento.getEstado().equals("En mantenimiento");

    String colorSegmento = "bg-success";
    if (segmento.getEstado().equals("Degradado")) {
        colorSegmento = "bg-warning text-dark";
    } else if (segmento.getEstado().equals("Fuera de servicio")) {
        colorSegmento = "bg-danger";
    } else if (segmentoEnMantenimiento) {
        colorSegmento = "bg-info text-dark";
    }

    int caidos = 0;
    for (Servicio sv : listaServicios) {
        if (sv.getEstado().equals("Caído")) {
            caidos++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Servicios del segmento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div class="d-flex align-items-center">
        <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=estadoRed" class="btn btn-outline-secondary btn-sm me-3">Volver</a>
        <h3 class="fw-bold m-0">Servicios de SEG-<%= String.format("%03d", segmento.getIdSegmento()) %></h3>
        <span class="badge ms-3 <%= colorSegmento %>"><%= segmento.getEstado() %></span>
      </div>
            <div class="d-flex gap-2">
              <!-- recarga la misma vista para ver las fallas nuevas -->
              <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=serviciosSegmento&id=<%= segmento.getIdSegmento() %>" class="btn btn-outline-secondary">Actualizar</a>
              <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=formCrear&idSegmento=<%= segmento.getIdSegmento() %>" class="btn btn-primary shadow-sm">+ Registrar incidencia</a>
            </div>
    </div>

    <div class="row g-2 mb-3">
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Ruta</small>
          <div class="fs-5 fw-semibold"><%= segmento.getNombreOrigen() %> - <%= segmento.getNombreDestino() %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Servicios vigentes</small>
          <div class="fs-5 fw-semibold"><%= listaServicios.size() %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Servicios caídos</small>
          <div class="fs-5 fw-semibold <%= caidos > 0 ? "text-danger" : "" %>"><%= caidos %></div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th class="ps-4">Servicio</th>
                <th>Cliente</th>
                <th>Capacidad</th>
                <th>Caducidad</th>
                <th>Estado</th>
              </tr>
            </thead>
            <tbody>
              <% if (listaServicios.isEmpty()) { %>
              <tr>
                <td colspan="5" class="text-center text-muted py-4">Ningún servicio vigente usa este segmento.</td>
              </tr>
              <% } %>
              <% for (Servicio sv : listaServicios) {
                   // si el segmento esta en mantenimiento, todos sus servicios se muestran En mantenimiento
                   String estadoMostrar = segmentoEnMantenimiento ? "En mantenimiento" : sv.getEstado();
                   String colorEstado = "bg-success";
                   if (estadoMostrar.equals("Caído")) {
                       colorEstado = "bg-danger";
                   } else if (estadoMostrar.equals("En mantenimiento")) {
                       colorEstado = "bg-info text-dark";
                   }
              %>
              <tr>
                <td class="ps-4 fw-bold"><%= sv.getIdentificador() %></td>
                <td><%= sv.getRazonSocial() %></td>
                <td><%= sv.getCapacidad().stripTrailingZeros().toPlainString() %> Gbps</td>
                <td><%= sv.getFechaCaducidad() %></td>
                <td><span class="badge <%= colorEstado %>"><%= estadoMostrar %></span></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>
</body>
</html>