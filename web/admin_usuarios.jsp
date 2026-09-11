<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>
  <main class="col p-4">
    <h4>Usuarios</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <select class="form-select w-auto">
        <option>Ordenar</option>
        <option>A - Z</option>
        <option>Rol</option>
        <option>Estado</option>
      </select>
      <a href="admin_usuario_form.jsp" class="btn btn-primary">Registrar</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Correo</th>
          <th>Rol</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>U-001</td>
          <td>Ana Torres</td>
          <td>atorres@wavewires.pe</td>
          <td>Administrador</td>
          <td>Activo</td>
          <td><a href="admin_usuario_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>U-002</td>
          <td>Luis Ramos</td>
          <td>lramos@wavewires.pe</td>
          <td>Capacity Planner</td>
          <td>Activo</td>
          <td><a href="admin_usuario_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>U-003</td>
          <td>María Quispe</td>
          <td>mquispe@wavewires.pe</td>
          <td>Supervisor</td>
          <td>Activo</td>
          <td><a href="admin_usuario_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>U-004</td>
          <td>Carlos Díaz</td>
          <td>cdiaz@wavewires.pe</td>
          <td>Network Operator</td>
          <td>Activo</td>
          <td><a href="admin_usuario_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>U-005</td>
          <td>Rosa Huamán</td>
          <td>rhuaman@wavewires.pe</td>
          <td>Maintenance Coordinator</td>
          <td>Inactivo</td>
          <td><a href="admin_usuario_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
      </tbody>
    </table>

    <div class="text-end">
      <a href="#" class="btn btn-sm btn-outline-secondary">Anterior</a>
      <a href="#" class="btn btn-sm btn-outline-secondary">Siguiente</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
