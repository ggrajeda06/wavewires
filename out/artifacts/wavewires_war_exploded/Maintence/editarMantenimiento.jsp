<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">
<head>
  <title>OceanLink - Editar Mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>

  <main class="col p-4 bg-light">
    <!-- Botón Volver / Encabezado -->
    <div class="d-flex align-items-center mb-4">
      <a href="Mantenimiento.jsp" class="btn btn-outline-secondary me-3 btn-sm">
        Volver
      </a>
      <h3 class="fw-bold m-0">Editar mantenimiento</h3>
    </div>

    <!-- Contenedor del Formulario -->
    <div class="card shadow-sm p-4">
      <form id="formEditarMantenimiento" action="Mantenimiento.jsp" method="POST" onsubmit="confirmarGuardado(event)">
        <div class="row g-4">

          <!-- Columna Izquierda -->
          <div class="col-md-6">
            <!-- Name(ID) -> EDITABLE -->
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" placeholder="Escribir nombre" value="ID1 - Landing-A" required>
            </div>

            <!-- Descripción -> BLOQUEADO -->
            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoDescripcion" style="max-height: 120px; overflow-y: auto;">Mantenimiento preventivo programado para revisión de conectores.</div>
            </div>

            <!-- Fecha -> BLOQUEADO -->
            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha</label>
              <input type="date" class="form-control bg-light" id="fecha" name="fecha" value="2026-05-10" readonly>
            </div>

            <!-- Duración estimada -> BLOQUEADO -->
            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada</label>
              <input type="text" class="form-control bg-light" id="duracion" name="duracion" value="2 horas" readonly>
            </div>
          </div>

          <!-- Columna Derecha -->
          <div class="col-md-6">
            <!-- Estado -> EDITABLE (Opción Finalizado condicionada) -->
            <div class="mb-3">
              <label for="estado" class="form-label fw-semibold">Estado</label>
              <select class="form-select" id="estado" name="estado" required>
                <option value="" disabled>Seleccionar estado</option>
                <option value="Activo" selected>Activo</option>
                <option value="Pendiente">Pendiente</option>
                <!-- Deshabilitado por defecto hasta escribir actividades -->
                <option value="Finalizado" id="opcionFinalizado" disabled>Finalizado</option>
              </select>
            </div>

            <!-- ID - Landing -> BLOQUEADO -->
            <div class="mb-3">
              <label for="infraestructura" class="form-label fw-semibold">ID - Landing</label>
              <select class="form-select bg-light" id="infraestructura" name="infraestructura" disabled>
                <option value="Landing 1" selected>Landing 1</option>
                <option value="Landing 2">Landing 2</option>
                <option value="Landing 3">Landing 3</option>
              </select>
            </div>

            <!-- Ubicación -> BLOQUEADO -->
            <div class="mb-3">
              <label for="ubicacion" class="form-label fw-semibold">Ubicación</label>
              <input type="text" class="form-control bg-light" id="ubicacion" name="ubicacion" value="Lima, PE" readonly>
            </div>

            <!-- Tipo de mantenimiento -> BLOQUEADO -->
            <div class="mb-3">
              <label for="tipoMantenimiento" class="form-label fw-semibold">Tipo de mantenimiento</label>
              <select class="form-select bg-light" id="tipoMantenimiento" name="tipoMantenimiento" disabled>
                <option value="Preventivo" selected>Preventivo</option>
                <option value="Correctivo">Correctivo</option>
              </select>
            </div>
          </div>

          <!-- Nuevo Apartado: Actividades realizadas -> EDITABLE -->
          <div class="col-12">
            <div class="mb-3">
              <label for="actividades" class="form-label fw-semibold">Actividades realizadas</label>
              <textarea class="form-control" id="actividades" name="actividades" rows="4" placeholder="Describa las actividades realizadas durante el mantenimiento..." oninput="validarActividades()"></textarea>
            </div>
          </div>

        </div>

        <!-- Botón de Envío -->
        <div class="d-flex justify-content-end mt-4">
          <button type="submit" class="btn btn-outline-dark px-4 py-2">Guardar registro</button>
        </div>
      </form>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Desbloquea la opción "Finalizado" si hay texto en "Actividades realizadas"
function validarActividades() {
  const campoActividades = document.getElementById('actividades');
  const opcionFinalizado = document.getElementById('opcionFinalizado');
  const selectEstado = document.getElementById('estado');

  if (campoActividades.value.trim() !== "") {
    opcionFinalizado.disabled = false;
  } else {
    opcionFinalizado.disabled = true;
    // Si borra el texto estando seleccionado "Finalizado", se regresa a Activo
    if (selectEstado.value === "Finalizado") {
      selectEstado.value = "Activo";
    }
  }
}

// Confirmación antes de enviar el formulario
function confirmarGuardado(event) {
  event.preventDefault(); // Detiene el envío automático
  const estadoSeleccionado = document.getElementById('estado').value;

  const confirmacion = confirm(`¿Está seguro de guardar el mantenimiento como "${estadoSeleccionado}"?`);

  if (confirmacion) {
    document.getElementById('formEditarMantenimiento').submit();
  }
}
</script>
</body>
</html>