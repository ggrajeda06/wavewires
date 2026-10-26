<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Capacidad de la red</title>

  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Menú lateral reutilizable -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Título de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Capacidad de la red</h2>
    </div>

    <!-- Tarjetas de Métricas principales -->
    <div class="row row-cols-1 row-cols-md-4 g-3 mb-4">
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad total</small>
            <span class="fs-4 fw-bold text-dark"><%=request.getAttribute("totalRed") != null ? request.getAttribute("totalRed") : 0%> Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad usándose</small>
            <span class="fs-4 fw-bold text-dark"><%=request.getAttribute("usadaRed") != null ? request.getAttribute("usadaRed") : 0%> Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad reservada</small>
            <span class="fs-4 fw-bold text-dark"><%=request.getAttribute("reservadaRed") != null ? request.getAttribute("reservadaRed") : 0%> Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad disponible</small>
            <span class="fs-4 fw-bold text-dark"><%=request.getAttribute("disponibleRed") != null ? request.getAttribute("disponibleRed") : 0%> Gbps</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Contenedor de la Tabla -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Barra de búsqueda -->
      <form method="GET" action="<%=request.getContextPath()%>/CapacidadServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar segmento, ruta o estado..."
                 value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
        </div>
      </form>

      <!-- Tabla de Capacidad -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 18%;">Nombre</th>
            <th style="width: 22%;">Ruta</th>
            <th style="width: 15%;">Total</th>
            <th style="width: 15%;">Usándose</th>
            <th style="width: 15%;">Disponible</th>
            <th style="width: 15%;">Estado</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaSegmentos.isEmpty()) { %>
          <tr>
            <td colspan="6" class="text-center text-muted py-4">No se encontraron segmentos registrados.</td>
          </tr>
          <% } else { %>
            <% for (Segmento s : listaSegmentos) {
                 int total = s.getCapacidadTotal() != null ? s.getCapacidadTotal().intValue() : 0;
                 int usada = s.getCapacidadUsada() != null ? s.getCapacidadUsada().intValue() : 0;
                 int reservada = s.getCapacidadReservada() != null ? s.getCapacidadReservada().intValue() : 0;
                 int disponible = Math.max(0, total - usada - reservada);
                 int ocupada = usada + reservada;
                 double pct = (total > 0) ? ((double) ocupada / total) * 100.0 : 0.0;
                 String ruta = s.getNombreOrigen() + " - " + s.getNombreDestino();
            %>
            <tr>
              <td class="fw-medium">Segmento <%=s.getIdSegmento()%></td>
              <td><%=ruta%></td>
              <td><%=total%> Gbps</td>
              <td><%=usada%> Gbps</td>
              <td><%=disponible%> Gbps</td>
              <td>
                <% if (pct < 80.0) { %>
                  <span class="badge bg-success-subtle text-success border border-success-subtle">
                    <i class="bi bi-circle-fill me-1 small"></i> &lt; 80% (Normal)
                  </span>
                <% } else if (pct <= 95.0) { %>
                  <span class="badge bg-warning-subtle text-warning border border-warning-subtle">
                    <i class="bi bi-circle-fill me-1 small"></i> 80% - 95% (Alto uso)
                  </span>
                <% } else { %>
                  <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                    <i class="bi bi-circle-fill me-1 small"></i> &gt; 95% (Uso crítico)
                  </span>
                <% } %>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>

    </div>

  </main>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>