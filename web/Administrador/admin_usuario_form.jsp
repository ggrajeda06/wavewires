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
    <h4>Registrar / Editar usuario</h4>

    <div class="w-50">
      <label class="form-label">ID</label>
      <input class="form-control mb-3" placeholder="Autocompletado" disabled>

      <label class="form-label">Nombre</label>
      <input class="form-control mb-3" placeholder="Ingresar nombre">

      <label class="form-label">Correo</label>
      <input class="form-control mb-3" placeholder="Ingresar correo">

      <label class="form-label">Rol</label>
      <select class="form-select mb-4">
        <option>Seleccionar</option>
        <option>Administrador</option>
        <option>Supervisor</option>
        <option>Capacity Planner</option>
        <option>Network Operator</option>
        <option>Maintenance Coordinator</option>
      </select>

      <a href="admin_usuarios.jsp" class="btn btn-danger" onclick="return confirm('¿Seguro que quieres eliminar este usuario?')">Eliminar</a>
      <a href="admin_usuarios.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="admin_usuarios.jsp" class="btn btn-primary">Guardar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
