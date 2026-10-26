<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Servicios Activos</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">
    <div class="mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Servicios Activos</h2>
      <small class="text-muted">Monitoreo de enlaces y capacidad en producción</small>
    </div>

    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador de servicios -->
      <form method="GET" action="<%=request.getContextPath()%>/ServicioServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar servicio, cliente o segmento..."
                 value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
        </div>
      </form>

      <!-- Tabla de servicios -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 20%;">Servicios</th>
            <th style="width: 25%;">Cliente</th>
            <th style="width: 20%;">Segmento</th>
            <th style="width: 15%;">Capacidad</th>
            <th style="width: 15%;">Caducidad del Servicio</th>
            <th style="width: 5%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaServicios.isEmpty()) { %>
          <tr>
            <td colspan="6" class="text-center text-muted py-4">No se encontraron servicios activos registrados.</td>
          </tr>
          <% } else { %>
            <%
               SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
               for (Servicio sv : listaServicios) {
                 String nombreServicio = (sv.getIdentificador() != null && !sv.getIdentificador().trim().isEmpty())
                                         ? sv.getIdentificador() : "Servicio " + sv.getIdServicio();
                 String nombreSegmento = sv.getIdSegmento() > 0 ? "Segmento " + sv.getIdSegmento() : "No asignado";
                 String fechaCaducidadStr = sv.getFechaCaducidad() != null ? sdf.format(sv.getFechaCaducidad()) : "-";
                 int capGbps = sv.getCapacidad() != null ? sv.getCapacidad().intValue() : 0;
            %>
            <tr>
              <td class="fw-medium"><%=nombreServicio%></td>
              <td><%=sv.getRazonSocial() != null ? sv.getRazonSocial() : "-"%></td>
              <td><%=nombreSegmento%></td>
              <td><%=capGbps%> Gbps</td>
              <td><%=fechaCaducidadStr%></td>
              <td class="text-center">
                <a href="<%=request.getContextPath()%>/ServicioServlet?action=borrar&id=<%=sv.getIdServicio()%>"
                   class="btn btn-outline-danger btn-sm px-3"
                   onclick="return confirm('¿Estás seguro de que deseas eliminar este servicio?');">
                  <i class="bi bi-trash"></i> Eliminar
                </a>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>

      <!-- Paginacion -->
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button type="button" class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>