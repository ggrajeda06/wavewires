<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="mantenimiento" type="com.oceanlink.beans.Mantenimiento" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<%
  String nombreLanding = "";
  String ubicacion = "";
  for (LandingStation ls : listaLandings) {
      if (ls.getIdLandingStation() == mantenimiento.getIdLandingStation()) {
          nombreLanding = ls.getNombre();
          ubicacion = ls.getCiudad() + ", " + ls.getPais();
      }
  }
%>
<html lang="es">
<head>
  <title>OceanLink - Editar Mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>

  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/MantenimientoServlet" class="btn btn-outline-secondary me-3 btn-sm">
        Volver
      </a>
      <h3 class="fw-bold m-0">Editar mantenimiento</h3>
    </div>

    <div class="card shadow-sm p-4">
      <form id="formEditarMantenimiento" action="<%=request.getContextPath()%>/MantenimientoServlet?action=actualizar" method="POST" onsubmit="confirmarGuardado(event)">
        <input type="hidden" name="id" value="<%=mantenimiento.getIdMantenimiento()%>">
        <div class="row g-4">

          <div class="col-md-6">
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" placeholder="Escribir nombre" value="<%=mantenimiento.getNombre()%>" required>
            </div>

            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoDescripcion" style="max-height: 120px; overflow-y: auto;"><%=mantenimiento.getDescripcion()%></div>
            </div>

            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha</label>
              <input type="date" class="form-control bg-light" id="fecha" name="fecha" value="<%=mantenimiento.getFechaRegistrada()%>" readonly>
            </div>

            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada</label>
              <input type="text" class="form-control bg-light" id="duracion" name="duracion" value="<%=mantenimiento.getDuracionHoras()%> horas" readonly>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label for="estado" class="form-label fw-semibold">Estado</label>
              <select class="form-select" id="estado" name="estado" required>
                <option value="" disabled>Seleccionar estado</option>
                <option value="Activo" <%=mantenimiento.getEstado().equals("Activo") ? "selected" : ""%>>Activo</option>
                <option value="Pendiente" <%=mantenimiento.getEstado().equals("Pendiente") ? "selected" : ""%>>Pendiente</option>
                <option value="Finalizado" id="opcionFinalizado" <%=mantenimiento.getEstado().equals("Finalizado") ? "selected" : ""%> disabled>Finalizado</option>
              </select>
            </div>

            <div class="mb-3">
              <label for="infraestructura" class="form-label fw-semibold">ID - Landing</label>
              <select class="form-select bg-light" id="infraestructura" name="infraestructura" disabled>
                <option selected><%=mantenimiento.getIdLandingStation()%> - <%=nombreLanding%></option>
              </select>
            </div>

            <div class="mb-3">
              <label for="ubicacion" class="form-label fw-semibold">Ubicación</label>
              <input type="text" class="form-control bg-light" id="ubicacion" name="ubicacion" value="<%=ubicacion%>" readonly>
            </div>

            <div class="mb-3">
              <label for="tipoMantenimiento" class="form-label fw-semibold">Tipo de mantenimiento</label>
              <select class="form-select bg-light" id="tipoMantenimiento" name="tipoMantenimiento" disabled>
                <option selected><%=mantenimiento.getTipo()%></option>
              </select>
            </div>
          </div>

          <div class="col-12">
            <div class="mb-3">
              <label for="actividades" class="form-label fw-semibold">Actividades realizadas</label>
              <textarea class="form-control" id="actividades" name="actividades" rows="4" placeholder="Describa las actividades realizadas durante el mantenimiento..." oninput="validarActividades()"><%=mantenimiento.getActividadesRealizadas() == null ? "" : mantenimiento.getActividadesRealizadas()%></textarea>
            </div>
          </div>

        </div>

        <div class="d-flex justify-content-end mt-4">
          <button type="submit" class="btn btn-outline-dark px-4 py-2">Guardar registro</button>
        </div>
      </form>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
function validarActividades() {
  const campoActividades = document.getElementById('actividades');
  const opcionFinalizado = document.getElementById('opcionFinalizado');
  const selectEstado = document.getElementById('estado');

  if (campoActividades.value.trim() !== "") {
    opcionFinalizado.disabled = false;
  } else {
    opcionFinalizado.disabled = true;
    if (selectEstado.value === "Finalizado") {
      selectEstado.value = "Activo";
    }
  }
}

function confirmarGuardado(event) {
  event.preventDefault();
  const estadoSeleccionado = document.getElementById('estado').value;

  const confirmacion = confirm('¿Está seguro de guardar el mantenimiento como "' + estadoSeleccionado + '"?');

  if (confirmacion) {
    document.getElementById('formEditarMantenimiento').submit();
  }
}

validarActividades();
</script>
</body>
</html>
