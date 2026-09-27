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
    <h4>Landing Station</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <select class="form-select w-auto">
        <option>Filtrar</option>
        <option>Estado</option>
        <option>País</option>
      </select>
      <a href="admin_landing_form.jsp" class="btn btn-primary">+ Nuevo</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Ubicación</th>
          <th>Estado</th>
          <th>Segmentos</th>
          <th>Incidencias activas</th>
          <th>Mantenimientos</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Lurín</td>
          <td>Lima, Perú</td>
          <td><span class="d-inline-block rounded-circle bg-success" style="width:8px;height:8px;"></span> Operativa</td>
          <td>3 <a href="admin_landing_segmentos.jsp?nombre=Lurín" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>1 <a href="/NetworkOperator/incidencias.jsp" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>0</td>
          <td><a href="admin_landing_form.jsp?id=LS-001" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Chimbote</td>
          <td>Áncash, Perú</td>
          <td><span class="d-inline-block rounded-circle bg-success" style="width:8px;height:8px;"></span> Operativa</td>
          <td>1 <a href="admin_landing_segmentos.jsp?nombre=Chimbote" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>0</td>
          <td>0</td>
          <td><a href="admin_landing_form.jsp?id=LS-002" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Arica</td>
          <td>Arica, Chile</td>
          <td><span class="d-inline-block rounded-circle bg-danger" style="width:8px;height:8px;"></span> Degradada</td>
          <td>2 <a href="admin_landing_segmentos.jsp?nombre=Arica" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>1 <a href="/NetworkOperator/incidencias.jsp" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>0</td>
          <td><a href="admin_landing_form.jsp?id=LS-003" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Valparaíso</td>
          <td>Valparaíso, Chile</td>
          <td><span class="d-inline-block rounded-circle bg-success" style="width:8px;height:8px;"></span> Operativa</td>
          <td>3 <a href="admin_landing_segmentos.jsp?nombre=Valparaíso" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>0</td>
          <td>1 <a href="/Maintence/Mantenimiento.jsp" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td><a href="admin_landing_form.jsp?id=LS-004" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Las Toninas</td>
          <td>Buenos Aires, Argentina</td>
          <td><span class="d-inline-block rounded-circle bg-danger" style="width:8px;height:8px;"></span> Mantenimiento</td>
          <td>1 <a href="admin_landing_segmentos.jsp?nombre=Las Toninas" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>1 <a href="/NetworkOperator/incidencias.jsp" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td>1 <a href="/Maintence/Mantenimiento.jsp" class="btn btn-sm btn-outline-secondary ms-1">Ver</a></td>
          <td><a href="admin_landing_form.jsp?id=LS-005" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
      </tbody>
    </table>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>