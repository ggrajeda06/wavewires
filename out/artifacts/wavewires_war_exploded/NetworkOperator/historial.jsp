<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4">
    <h4>Historial de incidencias</h4>

    <div class="mb-3">
      <input class="form-control" placeholder="Buscar">
    </div>

    <table class="table align-middle">
      <thead>
        <tr>
          <th>Incidencia</th>
          <th>Landing afectada</th>
          <th>Segmentos afectados</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Incidencia 5</td>
          <td>Landing 4</td>
          <td><select class="form-select form-select-sm w-auto"><option>Detalle</option></select></td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
        </tr>
        <tr>
          <td>Incidencia 6</td>
          <td>Landing 8</td>
          <td><select class="form-select form-select-sm w-auto"><option>Detalle</option></select></td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
        </tr>
        <tr>
          <td>Incidencia 7</td>
          <td>Landing 6</td>
          <td><select class="form-select form-select-sm w-auto"><option>Detalle</option></select></td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
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