<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Capacidad de la red</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Menú lateral -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Título de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Capacidad de la red</h2>
    </div>

    <!-- 4 Tarjetas de Métricas (Todas en texto negro) -->
    <div class="row row-cols-1 row-cols-md-4 g-3 mb-4">
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad total</small>
            <span class="fs-4 fw-bold text-dark">3300 Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad usándose</small>
            <span class="fs-4 fw-bold text-dark">2000 Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad reservada</small>
            <span class="fs-4 fw-bold text-dark">200 Gbps</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white p-2">
          <div class="card-body">
            <small class="text-muted d-block mb-1 fw-semibold">Capacidad disponible</small>
            <span class="fs-4 fw-bold text-dark">1100 Gbps</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Contenedor de la Tabla -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar segmento o ruta...">
        </div>
      </div>

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
          <tr>
            <td class="fw-medium">Segmento 1</td>
            <td>Perú - EEUU</td>
            <td>500 Gbps</td>
            <td>100 Gbps</td>
            <td>400 Gbps</td>
            <td>
              <span class="badge bg-success-subtle text-success border border-success-subtle">
                <i class="bi bi-circle-fill me-1 small"></i> &lt; 80% (Óptimo)
              </span>
            </td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 2</td>
            <td>Perú - España</td>
            <td>500 Gbps</td>
            <td>400 Gbps</td>
            <td>100 Gbps</td>
            <td>
              <span class="badge bg-warning-subtle text-warning border border-warning-subtle">
                <i class="bi bi-circle-fill me-1 small"></i> 80% - 95% (Alerta)
              </span>
            </td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 3</td>
            <td>Perú - Japón</td>
            <td>500 Gbps</td>
            <td>465 Gbps</td>
            <td>35 Gbps</td>
            <td>
              <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                <i class="bi bi-circle-fill me-1 small"></i> &gt; 95% (Crítico)
              </span>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <!-- Paginación -->
      <div class="d-flex justify-content-end gap-2">
        <button class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>

  </main>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>