<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Clientes Empresariales</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Sidebar compartido del Capacity Planner -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido de la vista -->
  <main class="col p-4">

    <!-- Titulo y boton para abrir el modal de registro -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Clientes Empresariales</h2>
        <small class="text-muted">Gestiona nuestros clientes</small>
      </div>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarCliente">
        <i class="bi bi-plus-lg me-1"></i> Registrar cliente
      </button>
    </div>

    <!-- Contenedor con buscador y tabla -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Filtro de busqueda -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar cliente o razón social...">
        </div>
      </div>

      <!-- Tabla de clientes -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 14%;">Identificador</th>
            <th style="width: 20%;">Razón Social</th>
            <th style="width: 22%;">Servicios Contratados</th>
            <th style="width: 20%;">Fecha de cliente registrado</th>
            <th style="width: 12%;">Estado</th>
            <th style="width: 12%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <!-- Cliente 1 -->
          <tr>
            <td class="fw-medium">Cliente 1</td>
            <td>OAC S.A.C.</td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#modalServiciosCliente1">
                Detalles
              </button>
            </td>
            <td class="text-secondary">14 / 11 / 2026</td>
            <td>
              <span class="badge bg-success-subtle text-success border border-success-subtle">Activo</span>
            </td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Cliente 2 -->
          <tr>
            <td class="fw-medium">Cliente 2</td>
            <td>HYDRA S.A.C.</td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#modalServiciosCliente2">
                Detalles
              </button>
            </td>
            <td class="text-secondary">13 / 10 / 2022</td>
            <td>
              <span class="badge bg-success-subtle text-success border border-success-subtle">Activo</span>
            </td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>

          <!-- Cliente 3 -->
          <tr>
            <td class="fw-medium">Cliente 3</td>
            <td>SIES S.A.C.</td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#modalServiciosCliente3">
                Detalles
              </button>
            </td>
            <td class="text-secondary">01 / 06 / 2024</td>
            <td>
              <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Inactivo</span>
            </td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <!-- Paginacion estatica -->
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button type="button" class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<!-- Modal para ver los servicios contratados de OAC -->
<div class="modal fade" id="modalServiciosCliente1" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold text-dark">Servicios contratados</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body px-3 pt-3 pb-3">
        <table class="table table-bordered text-center align-middle mb-0">
          <thead>
            <tr class="fw-bold">
              <th style="width: 50%;">Servicio</th>
              <th style="width: 50%;">Capacidad</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Servicio 1</td>
              <td class="fw-semibold text-secondary">30 Gbps</td>
            </tr>
            <tr>
              <td>Servicio 4</td>
              <td class="fw-semibold text-secondary">50 Gbps</td>
            </tr>
            <tr>
              <td>Servicio 5</td>
              <td class="fw-semibold text-secondary">20 Gbps</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="modal-footer border-0 justify-content-center pt-0 pb-3">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>

    </div>
  </div>
</div>

<!-- Modal para ver los servicios de HYDRA -->
<div class="modal fade" id="modalServiciosCliente2" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold text-dark">Servicios contratados</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body px-3 pt-3 pb-3">
        <table class="table table-bordered text-center align-middle mb-0">
          <thead>
            <tr class="fw-bold">
              <th style="width: 50%;">Servicio</th>
              <th style="width: 50%;">Capacidad</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Servicio 2</td>
              <td class="fw-semibold text-secondary">100 Gbps</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="modal-footer border-0 justify-content-center pt-0 pb-3">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>

    </div>
  </div>
</div>

<!-- Modal para SIES (sin servicios) -->
<div class="modal fade" id="modalServiciosCliente3" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold text-dark">Servicios contratados</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body px-3 pt-3 pb-3">
        <div class="p-3 bg-light text-center rounded border text-muted small">
          Sin servicios contratados actualmente.
        </div>
      </div>

      <div class="modal-footer border-0 justify-content-center pt-0 pb-3">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>

    </div>
  </div>
</div>

<!-- Modal para nuevo cliente -->
<div class="modal fade" id="modalRegistrarCliente" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Registrar Cliente</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body p-4">
        <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Razón social</label>
          <input type="text" class="form-control" placeholder="Escribe el nombre de la empresa">
        </div>
      </div>

      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-dark px-3" data-bs-dismiss="modal">Guardar cliente</button>
      </div>

    </div>
  </div>
</div>

<!-- Scripts de Bootstrap para que abran los modales -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>