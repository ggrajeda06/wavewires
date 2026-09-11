<%--
  Created by IntelliJ IDEA.
  User: John
  Date: 11/09/2026
  Time: 07:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="es">
<head>
  <title>WaveWires - Registrar Mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="MC_sidebar.jsp"/>

  <main class="col p-4 bg-light">
    <!-- Botón Volver / Encabezado -->
    <div class="d-flex align-items-center mb-4">
      <a href="MC_template.jsp" class="btn btn-outline-secondary me-3 btn-sm">
        Volver
      </a>
      <h3 class="fw-bold m-0">Registrar mantenimiento</h3>
    </div>

    <!-- Contenedor del Formulario -->
    <div class="card shadow-sm p-4">
      <form action="GuardarMantenimientoServlet" method="POST">
        <div class="row g-4">

          <!-- Columna Izquierda -->
          <div class="col-md-6">
            <!-- Name(ID) -->
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" placeholder="Escribir nombre" required>
            </div>

            <!-- Descripción -->
            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <textarea class="form-control" id="descripcion" name="descripcion" rows="4" placeholder="Describe el mantenimiento"></textarea>
            </div>

            <!-- Fecha -->
            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha</label>
              <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>

            <!-- Duración estimada -->
            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada</label>
              <input type="text" class="form-control" id="duracion" name="duracion" placeholder="Escribir duración estimada">
            </div>
          </div>

          <!-- Columna Derecha -->
          <div class="col-md-6">
            <!-- Estado -->
            <div class="mb-3">
              <label for="estado" class="form-label fw-semibold">Estado</label>
              <select class="form-select" id="estado" name="estado" required>
                <option value="" selected disabled>Seleccionar estado</option>
                <option value="Activo">Activo</option>
                <option value="Pendiente">Pendiente</option>
              </select>
            </div>

            <!-- ID - Landing -->
            <div class="mb-3">
              <label for="infraestructura" class="form-label fw-semibold">ID - Landing</label>
              <select class="form-select" id="infraestructura" name="infraestructura" required>
                <option value="" selected disabled>Seleccionar Infraestructura</option>
                <option value="Landing 1">Landing 1</option>
                <option value="Landing 2">Landing 2</option>
                <option value="Landing 3">Landing 3</option>
              </select>
            </div>

            <!-- Ubicación -->
            <div class="mb-3">
              <label for="ubicacion" class="form-label fw-semibold">Ubicación</label>
              <input type="text" class="form-control" id="ubicacion" name="ubicacion" placeholder="De la infraestructura">
            </div>

            <!-- Tipo de mantenimiento -->
            <div class="mb-3">
              <label for="tipoMantenimiento" class="form-label fw-semibold">Tipo de mantenimiento</label>
              <select class="form-select" id="tipoMantenimiento" name="tipoMantenimiento" required>
                <option value="" selected disabled>Seleccionar tipo de mantenimiento</option>
                <option value="Preventivo">Preventivo</option>
                <option value="Correctivo">Correctivo</option>
              </select>
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
</body>
</html>
