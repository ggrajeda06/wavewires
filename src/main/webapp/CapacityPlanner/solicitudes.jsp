<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>
  <main class="col p-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>

      <button class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <div class="card shadow-sm border-0 p-3">

      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar solicitud o cliente...">
        </div>
      </div>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

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
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalEditarSolicitud">
                Editar
              </button>
            </td>
          </tr>

          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<!-- ======================================================= -->
<!--           REGISTRAR SOLICITUD                           -->
<!-- ======================================================= -->
<div class="modal fade" id="modalRegistrarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Nueva solicitud de capacidad</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-4">
        <form id="formRegistrar">
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select class="form-select" required>
              <option selected disabled value="">Seleccionar cliente</option>
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
            <input type="number" class="form-control" placeholder="Ejm: 120" required>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" class="form-control" placeholder="Ejm: España" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" class="form-control" placeholder="Ejm: Perú" required>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" class="form-control" placeholder="Ejm: 5" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea class="form-control" rows="2" placeholder="(Opcional)"></textarea>
          </div>
        </form>
      </div>

      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-dark px-3" data-bs-dismiss="modal">Guardar solicitud</button>
      </div>

    </div>
  </div>
</div>

<!-- ======================================================= -->
<!--           EDITAR SOLICITUD DE CAPACIDAD                 -->
<!-- ======================================================= -->
<div class="modal fade" id="modalEditarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0" id="modalEditarTitulo">Editar solicitud de capacidad</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body p-4">
        <form id="formEditar">
          <input type="hidden" id="editSolicitudId">

          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select class="form-select" id="editCliente">
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
            <input type="number" class="form-control" id="editCapacidad">
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" class="form-control" id="editOrigen">
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" class="form-control" id="editDestino">
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select class="form-select border-primary" id="editEstado">
              <option value="Registrado">Registrado</option>
              <option value="En evaluacion">En evaluación</option>
              <option value="Aprobado">Aprobado</option>
              <option value="Pendiente por Capacidad">Pendiente por Capacidad</option>
              <option value="Provisionado">Provisionado</option>
              <option value="Rechazado">Rechazado</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Segmento</label>
            <select class="form-select" id="editSegmento">
              <option value="No asignado">No asignado</option>
              <option value="Segmento 1">Segmento 1 (Perú - EEUU)</option>
              <option value="Segmento 2">Segmento 2 (Perú - España)</option>
              <option value="Segmento 3">Segmento 3 (Perú - Japón)</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" class="form-control" id="editDuracion">
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea class="form-control" id="editObservaciones" rows="2"></textarea>
          </div>
        </form>
      </div>

      <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-danger px-3" data-bs-toggle="modal" data-bs-target="#modalConfirmacion">
          <i class="bi bi-trash me-1"></i> Eliminar Solicitud
        </button>
        <div class="d-flex gap-2">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" class="btn btn-primary px-4" data-bs-toggle="modal" data-bs-target="#modalConfirmacion">
            Guardar
          </button>
        </div>
      </div>

    </div>
  </div>
</div>

<div class="modal fade" id="modalConfirmacion" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow text-center p-3">
      <div class="modal-body">
        <i class="bi bi-question-circle text-primary fs-1 mb-2 d-block" id="iconoAlerta"></i>
        <h6 class="fw-bold mb-2" id="alertaTitulo">Confirmación</h6>
        <p class="text-muted small mb-3" id="alertaMensaje">¿Está seguro de guardar los cambios?</p>


        <div class="d-flex justify-content-center gap-2" id="alertaBotones">
          <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" class="btn btn-primary btn-sm px-3" data-bs-dismiss="modal">Sí, guardar</button>
        </div>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>