<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Registro de reservas</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">
    <div class="mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Registro de reservas</h2>
      <small class="text-muted">Capacidad separada en cada segmento antes de provisionar una solicitud</small>
    </div>

    <% if ("excede".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3">La capacidad reservada no puede superar la capacidad disponible del segmento.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 20%;">Segmento</th>
            <th style="width: 35%;">Ruta</th>
            <th style="width: 25%;">Cantidad reservada</th>
            <th style="width: 20%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaSegmentos.isEmpty()) { %>
          <tr>
            <td colspan="4" class="text-center text-muted py-4">No se encontraron segmentos registrados.</td>
          </tr>
          <% } %>
          <% for (Segmento s : listaSegmentos) {
               int total = s.getCapacidadTotal().intValue();
               int reservada = s.getCapacidadReservada().intValue();
          %>
          <tr>
            <td class="fw-semibold">SEG-<%=String.format("%03d", s.getIdSegmento())%></td>
            <td><%=s.getNombreOrigen()%> - <%=s.getNombreDestino()%></td>
            <td><span class="badge bg-light text-dark border"><%=reservada%> / <%=total%> Gbps</span></td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#reserva<%=s.getIdSegmento()%>">
                <i class="bi bi-pencil-square me-1"></i> Modificar
              </button>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<!-- un modal por segmento, ya con sus datos (sin JavaScript) -->
<% for (Segmento s : listaSegmentos) {
     int total = s.getCapacidadTotal().intValue();
     int usada = s.getCapacidadUsada().intValue();
     int reservada = s.getCapacidadReservada().intValue();
%>
<div class="modal fade" id="reserva<%=s.getIdSegmento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Reserva de SEG-<%=String.format("%03d", s.getIdSegmento())%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/ReservaServlet?action=actualizar">
        <input type="hidden" name="idSegmento" value="<%=s.getIdSegmento()%>">

        <div class="modal-body p-4">
          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small text-muted mb-1">Capacidad total</label>
              <input type="text" class="form-control bg-light" value="<%=total%> Gbps" readonly>
            </div>
            <div class="col-6">
              <label class="form-label small text-muted mb-1">Usada por servicios</label>
              <input type="text" class="form-control bg-light" value="<%=usada%> Gbps" readonly>
            </div>
          </div>

          <label class="form-label small fw-semibold">Capacidad reservada (Gbps)</label>
          <input type="number" name="capacidadReservada" class="form-control" min="0" max="<%=total - usada%>" value="<%=reservada%>" required>
          <small class="text-muted">Máximo <%=total - usada%> Gbps (total menos usada).</small>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary px-3">Guardar</button>
        </div>
      </form>

    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>