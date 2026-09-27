<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Historial de segmentos</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4 p-lg-5">
    <div class="container-fluid" style="max-width: 1000px;">

      <div class="mb-4">
        <h2 class="h3 fw-bold text-dark m-0">Historial de segmentos</h2>
      </div>

      <div class="card shadow-sm border-0 p-4 bg-white rounded-3">

        <div class="row mb-4">
          <div class="col-md-5">
            <input type="text" class="form-control" placeholder="Buscar por segmento o ruta...">
          </div>
        </div>

        <div class="table-responsive">
          <table class="table table-hover align-middle mb-4">
            <thead class="table-light">
            <tr>
              <th class="py-3">Segmento</th>
              <th class="py-3">Ruta</th>
              <th class="py-3 text-end">Servicios caducados</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td class="fw-semibold">Segmento 1</td>
              <td>Perú - EEUU</td>
              <td class="text-end">
                <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSegmento1">
                  <i class="bi bi-eye me-1"></i> Ver detalles
                </button>
              </td>
            </tr>
            <tr>
              <td class="fw-semibold">Segmento 2</td>
              <td>Perú - EEUU</td>
              <td class="text-end">
                <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSegmento2">
                  <i class="bi bi-eye me-1"></i> Ver detalles
                </button>
              </td>
            </tr>
            <tr>
              <td class="fw-semibold">Segmento 3</td>
              <td>Perú - EEUU</td>
              <td class="text-end">
                <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSegmento3">
                  <i class="bi bi-eye me-1"></i> Ver detalles
                </button>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

        <div class="d-flex justify-content-end gap-2 pt-2 border-top">
          <button class="btn btn-outline-secondary btn-sm px-3" disabled>Anterior</button>
          <button class="btn btn-outline-secondary btn-sm px-3">Siguiente</button>
        </div>

      </div>
    </div>
  </main>
</div>

<!-- Modal: Clientes de baja (Segmento 1) - Versión Compacta -->
<div class="modal fade" id="modalSegmento1" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width: 360px;">
    <div class="modal-content border-0 shadow-sm rounded-3">

      <div class="modal-header border-bottom py-2 px-3">
        <h6 class="modal-title fw-bold m-0">Clientes de baja</h6>
        <button type="button" class="btn-close btn-close-sm" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-3">
        <table class="table table-sm table-bordered align-middle text-center mb-0">
          <thead class="table-light">
            <tr>
              <th class="py-2">Cliente</th>
              <th class="py-2">Capacidad</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="fw-medium py-2">SIES S.A.C.</td>
              <td class="fw-bold text-secondary py-2">70 Gbps</td>
            </tr>
            <tr>
              <td class="fw-medium py-2">SIES S.A.C.</td>
              <td class="fw-bold text-secondary py-2">60 Gbps</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="modal-footer border-top-0 pt-0 pb-3 px-3 d-flex justify-content-center">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>

    </div>
  </div>
</div>
<!-- Modal: Sin registros (Segmento 2 y 3) -->
<div class="modal fade" id="modalSegmento2" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow text-center p-3">
      <div class="modal-body">
        <h6 class="fw-bold mb-2">Clientes de baja</h6>
        <p class="text-muted small mb-3">Sin servicios caducados en este segmento.</p>
        <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="modalSegmento3" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow text-center p-3">
      <div class="modal-body">
        <h6 class="fw-bold mb-2">Clientes de baja</h6>
        <p class="text-muted small mb-3">Sin servicios caducados en este segmento.</p>
        <button type="button" class="btn btn-secondary btn-sm px-3" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>