<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Solicitudes de capacidad</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Sidebar compartido del Capacity Planner -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Encabezado con boton para registrar solicitud -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <!-- Tarjeta con la tabla de datos -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador visual de la maqueta -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar solicitud o cliente...">
        </div>
      </div>

      <!-- Tabla estatica con las solicitudes de ejemplo -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 12%;">Solicitud</th>
            <th style="width: 15%;">Cliente</th>
            <th style="width: 16%;">Estado</th>
            <th style="width: 14%;">Segmento</th>
            <th style="width: 10%;">Capacidad</th>
            <th style="width: 14%;">Ruta</th>
            <th style="width: 10%;">Duración</th>
            <th style="width: 9%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <!-- Solicitud 1: Registrado -->
          <tr>
            <td class="fw-medium">Solicitud 1</td>
            <td>OAC S.A.C.</td>
            <td>
              <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Registrado</span>
            </td>
            <td class="text-muted">No asignado</td>
            <td>30 Gbps</td>
            <td>España - Perú</td>
            <td>5 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          <!-- Solicitud 2: En evaluacion -->
          <tr>
            <td class="fw-medium">Solicitud 2</td>
            <td>HYDRA S.A.C.</td>
            <td>
              <span class="badge bg-warning-subtle text-warning border border-warning-subtle">En evaluacion</span>
            </td>
            <td>Segmento 2</td>
            <td>100 Gbps</td>
            <td>China - Perú</td>
            <td>6 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          <!-- Solicitud 3: Aprobado -->
          <tr>
            <td class="fw-medium">Solicitud 3</td>
            <td>SIES S.A.C.</td>
            <td>
              <span class="badge bg-info-subtle text-info border border-info-subtle">Aprobado</span>
            </td>
            <td>Segmento 1</td>
            <td>50 Gbps</td>
            <td>Perú - EEUU</td>
            <td>12 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          <!-- Solicitud 4: Pendiente por capacidad -->
          <tr>
            <td class="fw-medium">Solicitud 4</td>
            <td>AMÉRICA MÓVIL</td>
            <td>
              <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Pendiente por capacidad</span>
            </td>
            <td>Segmento 3</td>
            <td>200 Gbps</td>
            <td>Perú - Japón</td>
            <td>8 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          <!-- Solicitud 5: Provisionado -->
          <tr>
            <td class="fw-medium">Solicitud 5</td>
            <td>TELEFÓNICA DEL PERÚ</td>
            <td>
              <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Provisionado</span>
            </td>
            <td>Segmento 2</td>
            <td>80 Gbps</td>
            <td>Perú - España</td>
            <td>4 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          <!-- Solicitud 6: Rechazado -->
          <tr>
            <td class="fw-medium">Solicitud 6</td>
            <td>ENTEL S.A.</td>
            <td>
              <span class="badge bg-dark-subtle text-dark border border-dark-subtle">Rechazado</span>
            </td>
            <td>Segmento 1</td>
            <td>150 Gbps</td>
            <td>Perú - EEUU</td>
            <td>3 meses</td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
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


<!-- Modal: Regisrar nueva solicitud -->
<div class="modal fade" id="modalRegistrarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Nueva solicitud de capacidad</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body p-4">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Cliente empresarial</label>
          <select class="form-select">
            <option selected disabled>Seleccionar cliente</option>
            <option>OAC S.A.C.</option>
            <option>HYDRA S.A.C.</option>
            <option>SIES S.A.C.</option>
            <option>AMÉRICA MÓVIL</option>
            <option>TELEFÓNICA DEL PERÚ</option>
            <option>ENTEL S.A.</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
          <input type="number" class="form-control" placeholder="Ejm: 120">
        </div>

        <div class="row g-2 mb-3">
          <div class="col-6">
            <label class="form-label small fw-semibold">Origen</label>
            <input type="text" class="form-control" placeholder="Ejm: España">
          </div>
          <div class="col-6">
            <label class="form-label small fw-semibold">Destino</label>
            <input type="text" class="form-control" placeholder="Ejm: Perú">
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Duración (meses)</label>
          <input type="number" class="form-control" placeholder="Ejm: 5">
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Observaciones</label>
          <textarea class="form-control" rows="2" placeholder="(Opcional)"></textarea>
        </div>
      </div>

      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-dark px-3" data-bs-dismiss="modal">Guardar solicitud</button>
      </div>

    </div>
  </div>
</div>

<!-- Modal: Editar Solicitud de Capacidad -->
<div class="modal fade" id="modalEditarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Solicitud</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body p-4">
        <div class="mb-3">
          <label class="form-label small fw-semibold">Cliente empresarial</label>
          <select class="form-select">
            <option>OAC S.A.C.</option>
            <option>HYDRA S.A.C.</option>
            <option>SIES S.A.C.</option>
            <option>AMÉRICA MÓVIL</option>
            <option>TELEFÓNICA DEL PERÚ</option>
            <option>ENTEL S.A.</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
          <input type="number" class="form-control" placeholder="Ejm: 30">
        </div>

        <div class="row g-2 mb-3">
          <div class="col-6">
            <label class="form-label small fw-semibold">Origen</label>
            <input type="text" class="form-control" placeholder="Ejm: España">
          </div>
          <div class="col-6">
            <label class="form-label small fw-semibold">Destino</label>
            <input type="text" class="form-control" placeholder="Ejm: Perú">
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Estado</label>
          <select class="form-select">
            <option>Registrado</option>
            <option>En evaluación</option>
            <option>Aprobado</option>
            <option>Pendiente por Capacidad</option>
            <option>Provisionado</option>
            <option>Rechazado</option>
          </select>
          <small class="text-muted">Las reglas de transición se gestionarán en el Servlet.</small>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Segmento</label>
          <select class="form-select">
            <option>No asignado</option>
            <option>Segmento 1 (Perú - EEUU)</option>
            <option>Segmento 2 (Perú - España)</option>
            <option>Segmento 3 (Perú - Japón)</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Duración (meses)</label>
          <input type="number" class="form-control" placeholder="Ejm: 5">
        </div>

        <div class="mb-3">
          <label class="form-label small fw-semibold">Observaciones</label>
          <textarea class="form-control" rows="2" placeholder="Sin observaciones preliminares"></textarea>
        </div>
      </div>

      <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-danger px-3" data-bs-dismiss="modal">
          <i class="bi bi-trash me-1"></i> Eliminar Solicitud
        </button>
        <div class="d-flex gap-2">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" class="btn btn-primary px-4" data-bs-dismiss="modal">Guardar</button>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>