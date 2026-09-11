<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Estado de Red</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons (Para la campana de notificaciones) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Importación del Sidebar -->
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">

    <!-- Encabezado con Notificaciones -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h3 fw-bold m-0">Estado de red</h2>

      <!-- Dropdown de Notificaciones -->
      <div class="dropdown">
        <button class="btn btn-outline-secondary position-relative dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="bi bi-bell-fill"></i>
          <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        4
                    </span>
        </button>
        <ul class="dropdown-menu dropdown-menu-end shadow p-2" style="min-width: 250px;">
          <li class="dropdown-header fw-bold border-bottom mb-2">Notificaciones</li>
          <li class="dropdown-item-text text-danger small"><i class="bi bi-exclamation-triangle-fill me-1"></i> Segmento 1: 1 incidencias </li>
          <li class="dropdown-item-text text-danger small"><i class="bi bi-exclamation-triangle-fill me-1"></i> Segmento 2: 1 incidencias </li>
          <li class="dropdown-item-text text-danger small"><i class="bi bi-exclamation-triangle-fill me-1"></i> Segmento 3: 3 incidencias </li>
        </ul>
      </div>
    </div>

    <!-- Tarjetas de Métricas / Contadores -->
    <div class="row row-cols-1 row-cols-md-4 g-3 mb-4">
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white">
          <div class="card-body">
            <small class="text-muted d-block mb-1">Segmentos Operativos</small>
            <span class="fs-4 fw-bold">10 de 20</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white">
          <div class="card-body">
            <small class="text-muted d-block mb-1">Segmentos con estado normal</small>
            <span class="fs-4 fw-bold text-success">8</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white">
          <div class="card-body">
            <small class="text-muted d-block mb-1">Segmentos con alta utilización</small>
            <span class="fs-4 fw-bold text-warning">4</span>
          </div>
        </div>
      </div>
      <div class="col">
        <div class="card h-100 text-center shadow-sm border-0 bg-white">
          <div class="card-body">
            <small class="text-muted d-block mb-1">Segmentos con uso crítico</small>
            <span class="fs-4 fw-bold text-danger">4</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Seccion de Tabla con Buscador -->
    <div class="card shadow-sm border-0 p-3">
      <!-- Input de Búsqueda -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar segmento...">
        </div>
      </div>

      <!-- Tabla con Rutas y Anchos de Banda Variados -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th>Segmento</th>
            <th>Ruta</th>
            <th>Usándose</th>
            <th>Incidencias</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td class="fw-medium">Segmento 1</td>
            <td>Perú - EEUU</td>
            <td>240/300 Gbps</td>
            <td><span class="badge bg-warning text-dark">1 activa</span></td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 2</td>
            <td>Perú - Chile</td>
            <td>85/100 Gbps</td>
            <td><span class="badge bg-warning text-dark">1 activa</span></td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 3</td>
            <td>Perú - Brasil</td>
            <td>485/500 Gbps</td>
            <td><span class="badge bg-danger">3 activas</span></td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 4</td>
            <td>Perú - Colombia</td>
            <td>120/200 Gbps</td>
            <td><span class="badge bg-success">Sin incidencias</span></td>
          </tr>
          <tr>
            <td class="fw-medium">Segmento 5</td>
            <td>Lima - Arequipa</td>
            <td>42/50 Gbps</td>
            <td><span class="badge bg-success">Sin incidencias</span></td>
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