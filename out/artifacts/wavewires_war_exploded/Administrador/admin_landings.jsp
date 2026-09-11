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
    <h4>Landing Stations</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <select class="form-select w-auto">
        <option>Ordenar</option>
        <option>A - Z</option>
        <option>Más segmentos</option>
        <option>Fecha de registro</option>
      </select>
      <a href="admin_landing_form.jsp" class="btn btn-primary">Registrar</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Ubicación</th>
          <th>Estado</th>
          <th>Segmentos</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Lurín</td>
          <td>Lima, Perú</td>
          <td>Operativa</td>
          <td>3</td>
          <td>
            <a href="admin_landing_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
            <a href="admin_landing_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a>
          </td>
        </tr>
        <tr>
          <td>Chimbote</td>
          <td>Áncash, Perú</td>
          <td>Operativa</td>
          <td>1</td>
          <td>
            <a href="admin_landing_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
            <a href="admin_landing_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a>
          </td>
        </tr>
        <tr>
          <td>Arica</td>
          <td>Arica, Chile</td>
          <td>Degradada</td>
          <td>2</td>
          <td>
            <a href="admin_landing_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
            <a href="admin_landing_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a>
          </td>
        </tr>
        <tr>
          <td>Valparaíso</td>
          <td>Valparaíso, Chile</td>
          <td>Operativa</td>
          <td>3</td>
          <td>
            <a href="admin_landing_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
            <a href="admin_landing_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a>
          </td>
        </tr>
        <tr>
          <td>Las Toninas</td>
          <td>Buenos Aires, Argentina</td>
          <td>Mantenimiento</td>
          <td>1</td>
          <td>
            <a href="admin_landing_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
            <a href="admin_landing_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a>
          </td>
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
