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
    <h4>Registrar / Editar restauración</h4>

    <div class="card p-4 w-50">
      <h6 class="mb-3">Datos</h6>

      <label class="form-label">Seleccionar incidencia</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Incidencia 4 — Detectada</option>
        <option>Incidencia 8 — En análisis</option>
        <option>Incidencia 9 — En análisis</option>
      </select>

      <label class="form-label">Fecha de restauración</label>
      <input type="date" class="form-control mb-4">

      <a href="restauracion.jsp" class="btn btn-danger" onclick="return confirm('¿Seguro que quieres eliminar esta restauración?')">Eliminar</a>
      <a href="restauracion.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="restauracion.jsp" class="btn btn-primary">Guardar solicitud</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>