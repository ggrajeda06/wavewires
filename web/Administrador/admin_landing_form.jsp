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
    <h4>Registrar / Editar Landing Station</h4>

    <div class="w-50">
      <label class="form-label">Nombre</label>
      <input class="form-control mb-3" placeholder="Ingresar nombre">

      <label class="form-label">País</label>
      <input class="form-control mb-3" placeholder="Ingresar país">

      <label class="form-label">Ciudad / localidad</label>
      <input class="form-control mb-3" placeholder="Ingresar ciudad">

      <label class="form-label">Coordenadas</label>
      <input class="form-control mb-3" placeholder="Ej: -12.2754, -76.8716">

      <label class="form-label">Estado</label>
      <select class="form-select mb-3">
        <option>Operativa</option>
        <option>Degradada</option>
        <option>Mantenimiento</option>
        <option>Fuera de servicio</option>
      </select>

      <label class="form-label">Descripción</label>
      <textarea class="form-control mb-4" rows="3" placeholder="Opcional"></textarea>

      <a href="admin_landings.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="admin_landings.jsp" class="btn btn-primary">Guardar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
