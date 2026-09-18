<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Solicitudes de capacidad</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Menú lateral -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal con el mismo ancho que Capacidad de red -->
  <main class="col p-4">

    <!-- Encabezado de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>
      <button class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalNuevaSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <!-- Tarjeta principal idéntica a index.jsp -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar solicitud o cliente...">
        </div>
      </div>

      <!-- Tabla simétrica con anchos distribuidos al 100% -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 16%;">Solicitud</th>
            <th style="width: 20%;">Cliente</th>
            <th style="width: 22%;">Estado</th>
            <th style="width: 18%;">Segmento</th>
            <th style="width: 12%;">Capacidad</th>
            <th style="width: 12%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <!-- Fila 1 -->
          <tr>
            <td class="fw-medium">Solicitud 1</td>
            <td>OAC S.A.C.</td>
            <td>
              <select class="form-select form-select-sm text-truncate border-secondary-subtle"
                      style="max-width: 195px; cursor: pointer;">
                <option>Registrada</option>
                <option>En evaluación</option>
                <option>Aprobada</option>
                <option>Provisionada</option>
                <option>Activa</option>
                <option>Rechazada</option>
                <option selected>Pendiente por capacidad</option>
              </select>
            </td>
            <td>Segmento 1</td>
            <td class="text-secondary">30 Gbps</td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Fila 2 -->
          <tr>
            <td class="fw-medium">Solicitud 2</td>
            <td>HYDRA S.A.C.</td>
            <td>
              <select class="form-select form-select-sm text-truncate border-secondary-subtle"
                      style="max-width: 195px; cursor: pointer;">
                <option>Registrada</option>
                <option selected>En evaluación</option>
                <option>Aprobada</option>
                <option>Provisionada</option>
                <option>Activa</option>
                <option>Rechazada</option>
                <option>Pendiente por capacidad</option>
              </select>
            </td>
            <td>Segmento 2</td>
            <td class="text-secondary">100 Gbps</td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3">
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

<!-- Modal: Nueva solicitud de capacidad -->
<div class="modal fade" id="modalNuevaSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Nueva solicitud de capacidad</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-4">
        <form>
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select class="form-select">
              <option selected disabled>Seleccionar cliente</option>
              <option>OAC S.A.C.</option>
              <option>HYDRA S.A.C.</option>
              <option>SIES S.A.C.</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
            <input type="number" class="form-control" placeholder="Ejm: 120">
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Segmento</label>
            <select class="form-select">
              <option selected disabled>Seleccionar Segmento</option>
              <option>Segmento 1</option>
              <option>Segmento 2</option>
              <option>Segmento 3</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Origen - Destino</label>
            <input type="text" class="form-control bg-light" value="Perú - EEUU (Autocompletado)" readonly>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select class="form-select">
              <option selected>Registrada</option>
              <option>En evaluación</option>
              <option>Aprobada</option>
              <option>Provisionada</option>
              <option>Activa</option>
              <option>Rechazada</option>
              <option>Pendiente por capacidad</option>
            </select>
          </div>
        </form>
      </div>

      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary px-3">Guardar solicitud</button>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>