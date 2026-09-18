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
    <h4>Segmentos</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <select class="form-select w-auto">
        <option>Ordenar</option>
        <option>A - Z</option>
        <option>Más capacidad total</option>
        <option>Más capacidad disponible</option>
      </select>
      <a href="admin_segmento_form.jsp" class="btn btn-primary">+ Nuevo</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Tramo</th>
          <th>Cap. usada</th>
          <th>Cap. total</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Lurín CLS ➔ Chimbote CLS</td>
          <td>150 Tbps</td>
          <td>400 Tbps</td>
          <td>Operativo</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-001" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Lurín CLS ➔ Arica CLS</td>
          <td>50 Tbps</td>
          <td>100 Tbps</td>
          <td>Degradado</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-002" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Lurín CLS ➔ Valparaíso CLS</td>
          <td>0 Tbps</td>
          <td>500 Tbps</td>
          <td>Mantenimiento</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-003" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Arica CLS ➔ Valparaíso CLS</td>
          <td>120 Tbps</td>
          <td>300 Tbps</td>
          <td>Operativo</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-004" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Valparaíso CLS ➔ Las Toninas CLS</td>
          <td>0 Tbps</td>
          <td>200 Tbps</td>
          <td>Fuera de servicio</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-005" class="btn btn-sm btn-outline-secondary">Editar</a></td>
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