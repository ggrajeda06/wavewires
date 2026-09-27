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
    <div class="d-flex justify-content-between align-items-center mb-3" style="max-width: 50%;">
      <h4 class="mb-0">Registrar / Editar Landing Station</h4>
      <a href="admin_landings.jsp" class="btn btn-sm btn-outline-secondary">×</a>
    </div>

    <div class="card p-4 w-50">
      <h6 class="mb-3">Datos</h6>

      <label class="form-label">ID</label>
      <input class="form-control mb-3" placeholder="Autocompletado / como posible identificador interno" disabled>

      <label class="form-label">Nombre</label>
      <input class="form-control mb-3" placeholder="Ingresar nombre">

      <label class="form-label">País</label>
      <input class="form-control mb-3" placeholder="Ingresar país">

      <label class="form-label">Ciudad / localidad</label>
      <input class="form-control mb-3" placeholder="Ingresar ciudad">

      <label class="form-label">Estado</label>
      <select class="form-select mb-4">
        <option>Operativa</option>
        <option>Degradada</option>
        <option>Mantenimiento</option>
        <option>Fuera de servicio</option>
      </select>

      <a href="admin_landings.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="admin_landings.jsp" class="btn btn-primary">Guardar / actualizar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>