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
    <h4>Registrar / Editar segmento</h4>

    <div class="w-50">
      <label class="form-label">Tramo</label>
      <input class="form-control mb-3" placeholder="Ej: Lurín - Arica">

      <label class="form-label">Origen</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Lurín</option>
        <option>Chimbote</option>
        <option>Arica</option>
        <option>Valparaíso</option>
        <option>Las Toninas</option>
      </select>

      <label class="form-label">Destino</label>
      <select class="form-select mb-3">
        <option>Seleccionar</option>
        <option>Lurín</option>
        <option>Chimbote</option>
        <option>Arica</option>
        <option>Valparaíso</option>
        <option>Las Toninas</option>
      </select>

      <label class="form-label">Capacidad total (Gbps)</label>
      <input class="form-control mb-3" placeholder="Ingresar capacidad">

      <label class="form-label">Capacidad disponible</label>
      <input class="form-control mb-3" placeholder="Se calcula sola" disabled>

      <label class="form-label">Estado</label>
      <select class="form-select mb-3">
        <option>Operativo</option>
        <option>Degradado</option>
        <option>Mantenimiento</option>
        <option>Fuera de servicio</option>
      </select>

      <label class="form-label">Descripción</label>
      <textarea class="form-control mb-4" rows="3" placeholder="Opcional"></textarea>

      <a href="admin_segmentos.jsp" class="btn btn-secondary">Cancelar</a>
      <a href="admin_segmentos.jsp" class="btn btn-primary">Guardar</a>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
