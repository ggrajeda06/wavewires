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

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Encabezado de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>
      <button class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <!-- Tarjeta principal con la Tabla -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar solicitud o cliente...">
        </div>
      </div>

      <!-- Tabla con estados coloreados y segmentos en texto estándar -->
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
          <!-- 1. Estado: Registrado -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 1', 'OAC S.A.C.', 30, 'España', 'Perú', 'Registrado', 'No asignado', 5, 'Sin observaciones preliminares')">
                Editar
              </button>
            </td>
          </tr>

          <!-- 2. Estado: En evaluación -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 2', 'HYDRA S.A.C.', 100, 'China', 'Perú', 'En evaluacion', 'Segmento 2', 6, 'Requiere validación de latencia')">
                Editar
              </button>
            </td>
          </tr>

          <!-- 3. Estado: Aprobado -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 3', 'SIES S.A.C.', 50, 'Perú', 'EEUU', 'Aprobado', 'Segmento 1', 12, 'Factibilidad aprobada por ingeniería')">
                Editar
              </button>
            </td>
          </tr>

          <!-- 4. Estado: Pendiente por capacidad -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 4', 'AMÉRICA MÓVIL', 200, 'Perú', 'Japón', 'Pendiente por Capacidad', 'Segmento 3', 8, 'En espera de liberación de capacidad reservada')">
                Editar
              </button>
            </td>
          </tr>

          <!-- 5. Estado: Provisionado -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 5', 'TELEFÓNICA DEL PERÚ', 80, 'Perú', 'España', 'Provisionado', 'Segmento 2', 4, 'Equipos configurados y listos para pase a producción')">
                Editar
              </button>
            </td>
          </tr>

          <!-- 6. Estado: Rechazado -->
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
              <button class="btn btn-outline-dark btn-sm px-3"
                      onclick="abrirModalEditar('Solicitud 6', 'ENTEL S.A.', 150, 'Perú', 'EEUU', 'Rechazado', 'Segmento 1', 3, 'Rechazado por saturación no mitigable en tramo submarino')">
                Editar
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

<!-- ======================================================= -->
<!-- MODAL 1: REGISTRAR SOLICITUD                           -->
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
        <button type="button" class="btn btn-dark px-3" onclick="confirmarGuardadoNuevo()">Guardar solicitud</button>
      </div>

    </div>
  </div>
</div>

<!-- ======================================================= -->
<!-- MODAL 2: EDITAR SOLICITUD DE CAPACIDAD                 -->
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

          <!-- Selector de Estado dinámico -->
          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select class="form-select border-primary" id="editEstado" onchange="controlarSegmentoPorEstado()">
            </select>
            <small class="text-muted" id="estadoHelpText"></small>
          </div>

          <!-- Selector de Segmento -->
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
        <button type="button" class="btn btn-outline-danger px-3" onclick="confirmarEliminacion()">
          <i class="bi bi-trash me-1"></i> Eliminar Solicitud
        </button>
        <div class="d-flex gap-2">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" class="btn btn-primary px-4" onclick="validarYGuardarEdicion()">Guardar</button>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- ======================================================= -->
<!-- MODAL DE CONFIRMACIÓN / ALERTAS DE REGLA DE NEGOCIO     -->
<!-- ======================================================= -->
<div class="modal fade" id="modalConfirmacion" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow text-center p-3">
      <div class="modal-body">
        <i class="bi bi-question-circle text-primary fs-1 mb-2 d-block" id="iconoAlerta"></i>
        <h6 class="fw-bold mb-2" id="alertaTitulo">Confirmación</h6>
        <p class="text-muted small mb-3" id="alertaMensaje">¿Está seguro de guardar los cambios?</p>
        <div class="d-flex justify-content-center gap-2" id="alertaBotones">
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- ======================================================= -->
<!-- JAVASCRIPT: REGLAS Y COMPORTAMIENTO PARA CADA ESTADO    -->
<!-- ======================================================= -->
<script>
  let modalEditarInstance = null;
  let modalConfirmacionInstance = null;
  let estadoOriginal = '';

  document.addEventListener("DOMContentLoaded", () => {
    modalEditarInstance = new bootstrap.Modal(document.getElementById('modalEditarSolicitud'));
    modalConfirmacionInstance = new bootstrap.Modal(document.getElementById('modalConfirmacion'));
  });

  function abrirModalEditar(id, cliente, capacidad, origen, destino, estado, segmento, duracion, obs) {
    estadoOriginal = estado;
    document.getElementById('modalEditarTitulo').textContent = 'Editar ' + id;
    document.getElementById('editSolicitudId').value = id;
    document.getElementById('editCliente').value = cliente;
    document.getElementById('editCapacidad').value = capacidad;
    document.getElementById('editOrigen').value = origen;
    document.getElementById('editDestino').value = destino;
    document.getElementById('editSegmento').value = segmento;
    document.getElementById('editDuracion').value = duracion;
    document.getElementById('editObservaciones').value = obs;

    const selectEstado = document.getElementById('editEstado');
    selectEstado.innerHTML = '';

    // Regla 2: 'Registrado' -> solo permite 'En evaluacion'
    if (estado === 'Registrado') {
      agregarOpcion(selectEstado, 'Registrado', 'Registrado', true);
      agregarOpcion(selectEstado, 'En evaluacion', 'En evaluación', false);
      document.getElementById('editSegmento').disabled = true;
      document.getElementById('estadoHelpText').textContent = "Desde 'Registrado' solo puede cambiar a 'En evaluación'.";
    }
    // Regla 3: 'En evaluacion' -> permite 'Aprobado' o 'Rechazado'
    else if (estado === 'En evaluacion') {
      agregarOpcion(selectEstado, 'En evaluacion', 'En evaluación', true);
      agregarOpcion(selectEstado, 'Aprobado', 'Aprobado', false);
      agregarOpcion(selectEstado, 'Rechazado', 'Rechazado', false);
      document.getElementById('editSegmento').disabled = false;
      document.getElementById('estadoHelpText').textContent = "Debe asignar un segmento para poder Aprobar.";
    }
    // Regla 6: 'Aprobado' -> permite 'Provisionado' o 'Pendiente por Capacidad'
    else if (estado === 'Aprobado') {
      agregarOpcion(selectEstado, 'Aprobado', 'Aprobado', true);
      agregarOpcion(selectEstado, 'Provisionado', 'Provisionado', false);
      agregarOpcion(selectEstado, 'Pendiente por Capacidad', 'Pendiente por Capacidad', false);
      document.getElementById('editSegmento').disabled = false;
      document.getElementById('estadoHelpText').textContent = "Seleccione Provisionado o pase a Standby de Capacidad.";
    }
    // Regla 8: 'Pendiente por Capacidad' -> permite 'Provisionado' o 'Rechazado'
    else if (estado === 'Pendiente por Capacidad') {
      agregarOpcion(selectEstado, 'Pendiente por Capacidad', 'Pendiente por Capacidad', true);
      agregarOpcion(selectEstado, 'Provisionado', 'Provisionado', false);
      agregarOpcion(selectEstado, 'Rechazado', 'Rechazado', false);
      document.getElementById('editSegmento').disabled = false;
      document.getElementById('estadoHelpText').textContent = "Estado standby: evalúe provisionar si hay espacio o rechazar.";
    }
    // Regla 7: 'Provisionado' -> permite pasar a 'Activo'
    else if (estado === 'Provisionado') {
      agregarOpcion(selectEstado, 'Provisionado', 'Provisionado', true);
      agregarOpcion(selectEstado, 'Activo', 'Activo (Convertir en Servicio)', false);
      document.getElementById('editSegmento').disabled = true;
      document.getElementById('estadoHelpText').textContent = "Al cambiar a Activo se creará el servicio y caducidad.";
    }
    // Estado Terminal: 'Rechazado'
    else if (estado === 'Rechazado') {
      agregarOpcion(selectEstado, 'Rechazado', 'Rechazado', true);
      document.getElementById('editSegmento').disabled = true;
      document.getElementById('estadoHelpText').textContent = "Solicitud rechazada en auditoría (Solo lectura).";
    }

    modalEditarInstance.show();
  }

  function agregarOpcion(select, valor, texto, selected) {
    const opt = document.createElement('option');
    opt.value = valor;
    opt.textContent = texto;
    opt.selected = selected;
    select.appendChild(opt);
  }

  function controlarSegmentoPorEstado() {
    const nuevoEstado = document.getElementById('editEstado').value;
    if (nuevoEstado === 'En evaluacion' || nuevoEstado === 'Aprobado') {
      document.getElementById('editSegmento').disabled = false;
    }
  }

  function validarYGuardarEdicion() {
    const nuevoEstado = document.getElementById('editEstado').value;
    const segmento = document.getElementById('editSegmento').value;

    // Regla 3: OBLIGATORIO PONER SEGMENTO PARA APROBAR
    if (nuevoEstado === 'Aprobado' && (segmento === 'No asignado' || segmento === '')) {
      alert("⚠️ Error: Es OBLIGATORIO asignar un segmento válido antes de Aprobar la solicitud.");
      return;
    }

    // Regla 4: Alerta al Rechazar ("Rechazar" en color Azul)
    if (nuevoEstado === 'Rechazado') {
      mostrarAlerta(
        "¿Estás seguro que quieres Rechazar la Solicitud?",
        "Esta acción cancelará el requerimiento del cliente.",
        `<button class="btn btn-outline-secondary btn-sm" onclick="modalConfirmacionInstance.hide()">Confirmar</button>
         <button class="btn btn-primary btn-sm px-3" onclick="ejecutarGuardado()">Rechazar</button>`
      );
      return;
    }

    // Regla 5: Alerta al Aprobar ("Confirmar" en color Azul)
    if (nuevoEstado === 'Aprobado') {
      mostrarAlerta(
        "¿Estás seguro que quieres Aprobar la Solicitud?",
        "Se confirmará la viabilidad técnica para este segmento.",
        `<button class="btn btn-outline-secondary btn-sm" onclick="modalConfirmacionInstance.hide()">Rechazar</button>
         <button class="btn btn-primary btn-sm px-3" onclick="ejecutarGuardado()">Confirmar</button>`
      );
      return;
    }

    // Alerta estándar
    mostrarAlerta(
      "¿Está seguro de guardar cambios?",
      "Se actualizarán los datos de la solicitud.",
      `<button class="btn btn-outline-secondary btn-sm" onclick="modalConfirmacionInstance.hide()">Cancelar</button>
       <button class="btn btn-primary btn-sm px-3" onclick="ejecutarGuardado()">Confirmar</button>`
    );
  }

  function mostrarAlerta(titulo, mensaje, botonesHtml) {
    document.getElementById('alertaTitulo').textContent = titulo;
    document.getElementById('alertaMensaje').textContent = mensaje;
    document.getElementById('alertaBotones').innerHTML = botonesHtml;
    modalConfirmacionInstance.show();
  }

  function ejecutarGuardado() {
    modalConfirmacionInstance.hide();
    modalEditarInstance.hide();
    alert("Solicitud actualizada con éxito (Simulación en vista).");
  }

  function confirmarGuardadoNuevo() {
    if (confirm("¿Está seguro de guardar esta nueva solicitud de capacidad?")) {
      const modal = bootstrap.Modal.getInstance(document.getElementById('modalRegistrarSolicitud'));
      modal.hide();
      alert("Solicitud registrada con éxito en estado 'Registrado'.");
    }
  }

  function confirmarEliminacion() {
    if (confirm("¿Está completamente seguro de eliminar esta solicitud del registro?")) {
      modalEditarInstance.hide();
      alert("Solicitud eliminada correctamente.");
    }
  }
</script>
</body>
</html>
    // Regla 5: Alerta al Aprobar ("Confirmar" en color Azul)
    if (nuevoEstado === 'Aprobado') {
      mostrarAlerta(
        "¿Estás seguro que quieres Aprobar la Solicitud?",
        "Se confirmará la viabilidad técnica para este segmento.",
        `<button class="btn btn-outline-secondary btn-sm" onclick="modalConfirmacionInstance.hide()">Rechazar</button>
         <button class="btn btn-primary btn-sm px-3" onclick="ejecutarGuardado()">Confirmar</button>`
      );
      return;
    }

    // Alerta estándar
    mostrarAlerta(
      "¿Está seguro de guardar cambios?",
      "Se actualizarán los datos de la solicitud.",
      `<button class="btn btn-outline-secondary btn-sm" onclick="modalConfirmacionInstance.hide()">Cancelar</button>
       <button class="btn btn-primary btn-sm px-3" onclick="ejecutarGuardado()">Confirmar</button>`
    );
  }

  function mostrarAlerta(titulo, mensaje, botonesHtml) {
    document.getElementById('alertaTitulo').textContent = titulo;
    document.getElementById('alertaMensaje').textContent = mensaje;
    document.getElementById('alertaBotones').innerHTML = botonesHtml;
    modalConfirmacionInstance.show();
  }

  function ejecutarGuardado() {
    modalConfirmacionInstance.hide();
    modalEditarInstance.hide();
    alert("Solicitud actualizada con éxito (Simulación en vista).");
  }

  function confirmarGuardadoNuevo() {
    if (confirm("¿Está seguro de guardar esta nueva solicitud de capacidad?")) {
      const modal = bootstrap.Modal.getInstance(document.getElementById('modalRegistrarSolicitud'));
      modal.hide();
      alert("Solicitud registrada con éxito en estado 'Registrado'.");
    }
  }

  function confirmarEliminacion() {
    if (confirm("¿Está completamente seguro de eliminar esta solicitud del registro?")) {
      modalEditarInstance.hide();
      alert("Solicitud eliminada correctamente.");
    }
  }
</script>
</body>
</html></html>