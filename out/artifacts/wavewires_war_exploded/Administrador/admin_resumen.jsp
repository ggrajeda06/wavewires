<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/Administrador/sidebar.jsp"/>
  <main class="col p-4">
    <p class="text-muted mb-1">Buenos días, señor Administrador</p>
    <h4 class="mb-3">Resumen</h4>

    <div class="row g-2 mb-3">
      <div class="col-md-3">
        <div class="card p-3">
          <small class="text-muted">Usuarios activos</small>
          <div class="fs-4">38 / 47</div>
          <a href="admin_usuarios.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ir</a>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3">
          <small class="text-muted">Landing Stations activas</small>
          <div class="fs-4">8 / 10</div>
          <a href="admin_landings.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ir</a>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3">
          <small class="text-muted">Segmentos activos</small>
          <div class="fs-4">47 / 105</div>
          <a href="admin_segmentos.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ir</a>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3">
          <small class="text-muted">Incidencias críticas</small>
          <div class="fs-4">5 / 9</div>
          <a href="admin_incidencias.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ir</a>
        </div>
      </div>
    </div>

    <div class="card p-3">
      <h6>Acciones rápidas</h6>
      <a href="admin_usuario_form.jsp" class="btn btn-primary d-block mb-2">Nuevo usuario</a>
      <div class="row g-2">
        <div class="col-md-6">
          <a href="admin_landing_form.jsp" class="btn btn-outline-primary w-100">Nueva landing</a>
        </div>
        <div class="col-md-6">
          <a href="admin_segmento_form.jsp" class="btn btn-outline-primary w-100">Nuevo segmento</a>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>