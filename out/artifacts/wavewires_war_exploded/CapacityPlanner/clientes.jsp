<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Clientes Empresariales</title>
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

    <!-- Encabezado -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Clientes Empresariales</h2>
        <small class="text-muted">Gestiona nuestros clientes</small>
      </div>
      <button class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarCliente">
        <i class="bi bi-plus-lg me-1"></i> Registrar cliente
      </button>
    </div>

    <!-- Tarjeta principal simétrica -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar cliente o razón social...">
        </div>
      </div>

      <!-- Tabla distribuida al 100% -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 14%;">Identificador</th>
            <th style="width: 22%;">Razón Social</th>
            <th style="width: 20%;">Segmentos contratados</th>
            <th style="width: 18%;">Fecha de registro</th>
            <th style="width: 12%;">Estado</th>
            <th style="width: 14%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <!-- Fila 1 -->
          <tr>
            <td class="fw-medium">Cliente 1</td>
            <td>OAC S.A.C.</td>
            <td>
              <div class="dropdown">
                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                  Detalles
                </button>
                <ul class="dropdown-menu shadow-sm">
                  <li class="dropdown-item-text small">Segmento 1 - <strong>200 Gbps</strong></li>
                  <li class="dropdown-item-text small">Segmento 2 - <strong>50 Gbps</strong></li>
                  <li class="dropdown-item-text small">Segmento 3 - <strong>20 Gbps</strong></li>
                </ul>
              </div>
            </td>
            <td class="text-secondary">14 / 11 / 2026</td>
            <td>
              <span class="badge bg-success-subtle text-success border border-success-subtle">Activo</span>
            </td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Fila 2 -->
          <tr>
            <td class="fw-medium">Cliente 2</td>
            <td>HYDRA S.A.C.</td>
            <td>
              <div class="dropdown">
                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                  Detalles
                </button>
                <ul class="dropdown-menu shadow-sm">
                  <li class="dropdown-item-text small">Segmento 2 - <strong>80 Gbps</strong></li>
                </ul>
              </div>
            </td>
            <td class="text-secondary">13 / 10 / 2022</td>
            <td>
              <span class="badge bg-success-subtle text-success border border-success-subtle">Activo</span>
            </td>
            <td class="text-center">
              <button class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Fila 3 -->
          <tr>
            <td class="fw-medium">Cliente 3</td>
            <td>SIES S.A.C.</td>
            <td>
              <div class="dropdown">
                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                  Detalles
                </button>
                <ul class="dropdown-menu shadow-sm">
                  <li class="dropdown-item-text small text-muted">Sin servicios activos</li>
                </ul>
              </div>
            </td>
            <td class="text-secondary">01 / 06 / 2024</td>
            <td>
              <span class="badge bg-secondary-subtle text-secondary border">Inactivo</span>
            </td>
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

<!-- Modal: Registrar Cliente -->
<div class="modal fade" id="modalRegistrarCliente" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Registrar Cliente</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-4">
        <form>
          <div class="mb-3">
            <label class="form-label small fw-semibold">Razón social</label>
            <input type="text" class="form-control" placeholder="Escribe el nombre de la empresa">
          </div>
          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado inicial</label>
            <select class="form-select">
              <option selected>Activo</option>
              <option>Inactivo</option>
            </select>
          </div>
        </form>
      </div>

      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary px-3">Guardar cliente</button>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>