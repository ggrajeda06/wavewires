<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Registro de reservas</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Menú lateral -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal centrado -->
  <main class="col p-4 p-lg-5">
    <div class="container-fluid" style="max-width: 1000px;">

      <!-- Encabezado -->
      <div class="mb-4">
        <h2 class="h3 fw-bold text-dark m-0">Registro de reservas</h2>
      </div>

      <!-- Tarjeta compacta idéntica a Historial -->
      <div class="card shadow-sm border-0 p-4 bg-white rounded-3">

        <!-- Buscador -->
        <div class="row mb-4">
          <div class="col-md-5">
            <input type="text" class="form-control" placeholder="Buscar por segmento o ruta...">
          </div>
        </div>

        <!-- Tabla simétrica -->
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-4">
            <thead class="table-light">
            <tr>
              <th class="py-3" style="width: 25%;">Segmentos</th>
              <th class="py-3" style="width: 28%;">Ruta</th>
              <th class="py-3" style="width: 25%;">Cantidad reservada</th>
              <th class="py-3 text-end" style="width: 22%;">Modificar cantidad</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td class="fw-semibold">Segmento 1</td>
              <td>Perú - EEUU</td>
              <td><span class="badge bg-light text-dark border">20 / 500 Gbps</span></td>
              <td class="text-end">
                <button class="btn btn-outline-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalModificarReserva">
                  <i class="bi bi-pencil-square me-1"></i> Modificar
                </button>
              </td>
            </tr>
            <tr>
              <td class="fw-semibold">Segmento 2</td>
              <td>Perú - España</td>
              <td><span class="badge bg-light text-dark border">30 / 500 Gbps</span></td>
              <td class="text-end">
                <button class="btn btn-outline-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalModificarReserva">
                  <i class="bi bi-pencil-square me-1"></i> Modificar
                </button>
              </td>
            </tr>
            <tr>
              <td class="fw-semibold">Segmento 3</td>
              <td>Perú - Japón</td>
              <td><span class="badge bg-light text-dark border">50 / 500 Gbps</span></td>
              <td class="text-end">
                <button class="btn btn-outline-primary btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalModificarReserva">
                  <i class="bi bi-pencil-square me-1"></i> Modificar
                </button>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

        <!-- Paginación -->
        <div class="d-flex justify-content-end gap-2 pt-2 border-top">
          <button class="btn btn-outline-secondary btn-sm px-3" disabled>Anterior</button>
          <button class="btn btn-outline-secondary btn-sm px-3">Siguiente</button>
        </div>

      </div>
    </div>
  </main>
</div>

<!-- Modal compacto para modificar reserva -->
<div class="modal fade" id="modalModificarReserva" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width: 380px;">
    <div class="modal-content border-0 shadow rounded-3">

      <div class="modal-header border-bottom py-2 px-3">
        <h6 class="modal-title fw-bold m-0">Modificar cantidad reservada</h6>
        <button type="button" class="btn-close btn-close-sm" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-3">
        <div class="mb-3">
          <label class="form-label small text-muted mb-1">Límite del segmento</label>
          <input type="text" class="form-control form-control-sm bg-light text-center fw-medium" value="500 Gbps" readonly>
        </div>

        <div class="mb-2">
          <label class="form-label small fw-semibold mb-1">Capacidad reservada</label>
          <div class="input-group input-group-sm">
            <button class="btn btn-outline-secondary" type="button"><i class="bi bi-dash-lg"></i></button>
            <input type="text" class="form-control text-center fw-bold" value="20 Gbps">
            <button class="btn btn-outline-secondary" type="button"><i class="bi bi-plus-lg"></i></button>
          </div>
        </div>
      </div>

      <div class="modal-footer border-top-0 pt-0 pb-3 px-3 d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btn-sm px-3" data-bs-dismiss="modal">Guardar</button>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>