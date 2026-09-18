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
    <h4>Restauración</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <a href="restauracion_form.jsp" class="btn btn-primary">+ Registrar restauración</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Restauración</th>
          <th>Incidencia</th>
          <th>Fecha de restauración</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Restauración 1</td>
          <td>Incidencia 1</td>
          <td>01/11/2020</td>
          <td><a href="restauracion_form.jsp?id=1" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Restauración 2</td>
          <td>Incidencia 2</td>
          <td>01/11/2020</td>
          <td><a href="restauracion_form.jsp?id=2" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Restauración 3</td>
          <td>Incidencia 3</td>
          <td>01/11/2020</td>
          <td><a href="restauracion_form.jsp?id=3" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Restauración 4</td>
          <td>Incidencia 4</td>
          <td>01/11/2020</td>
          <td><a href="restauracion_form.jsp?id=4" class="btn btn-sm btn-outline-secondary">Editar</a></td>
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