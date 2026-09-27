<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Servicios Activos</title>
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

    <!-- Encabezado de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Servicios Activos</h2>
        <small class="text-muted">Monitoreo de enlaces y capacidad en producción</small>
      </div>
    </div>

    <!-- Tarjeta principal simétrica -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar servicio, cliente o segmento...">
        </div>
      </div>

      <!-- Tabla de Servicios Activos -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 18%;">Servicios</th>
            <th style="width: 22%;">Cliente</th>
            <th style="width: 20%;">Segmento</th>
            <th style="width: 15%;">Capacidad</th>
            <th style="width: 15%;">Caducidad del Servicio</th>
            <th style="width: 10%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <!-- Fila 1 -->
          <tr>
            <td class="fw-medium">Servicio 1</td>
            <td>OAC S.A.C.</td>
            <td>Segmento 1</td>
            <td class="text-secondary fw-semibold">30 Gbps</td>
            <td class="text-secondary">10 / 11 / 2026</td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3"
                      onclick="return confirm('¿Está seguro de dar de baja el Servicio 1? La capacidad liberada retornará automáticamente a capacidad disponible.')">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Fila 2 -->
          <tr>
            <td class="fw-medium">Servicio 2</td>
            <td>HYDRA S.A.C.</td>
            <td>Segmento 2</td>
            <td class="text-secondary fw-semibold">100 Gbps</td>
            <td class="text-secondary">10 / 11 / 2026</td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3"
                      onclick="return confirm('¿Está seguro de dar de baja el Servicio 2? La capacidad liberada retornará automáticamente a capacidad disponible.')">
                <i class="bi bi-trash"></i> Eliminar
              </button>
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