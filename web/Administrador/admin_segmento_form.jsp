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
    <h4>Registrar / Editar segmento</h4>

    <div class="card p-4 w-50">
      <h6 class="mb-3">Datos</h6>

      <label class="form-label">Origen</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Lurín CLS</option>
        <option>Chimbote CLS</option>
        <option>Arica CLS</option>
        <option>Valparaíso CLS</option>
        <option>Las Toninas CLS</option>
      </select>

      <label class="form-label">Destino</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Lurín CLS</option>
        <option>Chimbote CLS</option>
        <option>Arica CLS</option>
        <option>Valparaíso CLS</option>
        <option>Las Toninas CLS</option>
      </select>

      <label class="form-label">Capacidad total (Tbps)</label>
      <input class="form-control mb-3" type="number" placeholder="Ingresar capacidad">

      <label class="form-label">Estado</label>
      <select class="form-select mb-4">
        <option>Operativo</option>
        <option>Degradado</option>
        <option>Mantenimiento</option>
        <option>Fuera de servicio</option>
      </select>

      <a href="admin_segmentos.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="admin_segmentos.jsp" class="btn btn-primary">Guardar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>