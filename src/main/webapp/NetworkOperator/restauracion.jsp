<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.ServicioAfectado" %>
<jsp:useBean id="listaRestauraciones" type="java.util.ArrayList<com.oceanlink.beans.ServicioAfectado>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Restauraciones</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <h3 class="fw-bold mb-1">Restauraciones</h3>
    <p class="text-muted mb-4">Un servicio se restaura solo cuando su incidencia pasa a Servicio restaurado.</p>

    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th class="ps-4">Incidencia</th>
                <th>Servicio</th>
                <th>Segmento</th>
                <th>Cliente</th>
                <th>Capacidad</th>
                <th>Fecha de restauración</th>
              </tr>
            </thead>
            <tbody>
              <% if (listaRestauraciones.isEmpty()) { %>
              <tr>
                <td colspan="6" class="text-center text-muted py-4">Todavía no hay servicios restaurados.</td>
              </tr>
              <% } %>
              <% for (ServicioAfectado sa : listaRestauraciones) { %>
              <tr>
                <td class="ps-4">
                  <a class="fw-bold text-decoration-none" href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%= sa.getIdIncidencia() %>"><%= sa.getIdentificadorIncidencia() %></a>
                </td>
                <td><%= sa.getIdentificadorServicio() %></td>
                <td>SEG-<%= String.format("%03d", sa.getIdSegmento()) %></td>
                <td><%= sa.getRazonSocial() %></td>
                <td><%= sa.getCapacidad().stripTrailingZeros().toPlainString() %> Gbps</td>
                <td><%= sa.getFechaRestauracion() %></td>
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
