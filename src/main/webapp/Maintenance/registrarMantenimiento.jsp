<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<html lang="es">
<head>
  <title>OceanLink - Registrar Mantenimiento</title>
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
      <h3 class="fw-bold m-0">Registrar mantenimiento</h3>
    </div>

    <div class="card shadow-sm p-4">
      <form action="<%=request.getContextPath()%>/MantenimientoServlet?action=crear" method="POST">
        <div class="row g-4">

          <div class="col-md-6">
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" placeholder="Escribir nombre" required>
            </div>

            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <textarea class="form-control" id="descripcion" name="descripcion" rows="4" placeholder="Describe el mantenimiento"></textarea>
            </div>

            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha</label>
              <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>

            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada (horas)</label>
              <input type="number" class="form-control" id="duracion" name="duracion" min="1" placeholder="Escribir duración en horas" required>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label for="estado" class="form-label fw-semibold">Estado</label>
              <select class="form-select" id="estado" name="estado" required>
                <option value="" selected disabled>Seleccionar estado</option>
                <option value="Activo">Activo</option>
                <option value="Pendiente">Pendiente</option>
              </select>
            </div>

            <div class="mb-3">
              <label for="infraestructura" class="form-label fw-semibold">ID - Landing</label>
              <select class="form-select" id="infraestructura" name="idLandingStation" required>
                <option value="" selected disabled>Seleccionar Infraestructura</option>
                <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>"><%=ls.getIdLandingStation()%> - <%=ls.getNombre()%> (<%=ls.getCiudad()%>, <%=ls.getPais()%>)</option>
                <% } %>
              </select>
            </div>

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
