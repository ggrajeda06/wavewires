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
    <h4>Registrar / Editar incidencia</h4>

    <div class="card p-4 w-50">
      <h6 class="mb-3">Datos</h6>

      <label class="form-label">Landing afectada</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Lurín CLS</option>
        <option>Chimbote CLS</option>
        <option>Arica CLS</option>
        <option>Valparaíso CLS</option>
        <option>Las Toninas CLS</option>
      </select>

      <label class="form-label">Segmentos afectados</label>
      <div class="border rounded p-2 mb-3">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="seg1" checked>
          <label class="form-check-label" for="seg1">SEG-001</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="seg2" checked>
          <label class="form-check-label" for="seg2">SEG-002</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="seg3">
          <label class="form-check-label" for="seg3">SEG-003</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="seg4">
          <label class="form-check-label" for="seg4">SEG-004</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="seg5">
          <label class="form-check-label" for="seg5">SEG-005</label>
        </div>
      </div>

      <label class="form-label">Severidad</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Alta</option>
        <option>Media</option>
        <option>Baja</option>
      </select>

      <label class="form-label">Estado</label>
      <select class="form-select mb-3">
        <option>Detectada</option>
        <option>En análisis</option>
        <option>En reparación</option>
        <option>Cerrada</option>
      </select>

      <label class="form-label">Observaciones</label>
      <textarea class="form-control mb-4" rows="3" placeholder="Opcional"></textarea>

      <a href="incidencias.jsp" class="btn btn-danger" onclick="return confirm('¿Seguro que quieres eliminar esta incidencia?')">Eliminar</a>
      <a href="incidencias.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="incidencias.jsp" class="btn btn-primary">Guardar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>