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
      <a href="admin_segmento_form.jsp" class="btn btn-primary">Registrar</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Tramo</th>
          <th>Origen</th>
          <th>Destino</th>
          <th>Cap. total</th>
          <th>Cap. disponible</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Lurín - Chimbote</td>
          <td>Lurín</td>
          <td>Chimbote</td>
          <td>400 Gbps</td>
          <td>150 Gbps</td>
          <td>Operativo</td>
          <td><a href="admin_segmento_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Lurín - Arica</td>
          <td>Lurín</td>
          <td>Arica</td>
          <td>500 Gbps</td>
          <td>80 Gbps</td>
          <td>Degradado</td>
          <td><a href="admin_segmento_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Lurín - Valparaíso</td>
          <td>Lurín</td>
          <td>Valparaíso</td>
          <td>500 Gbps</td>
          <td>0 Gbps</td>
          <td>Mantenimiento</td>
          <td><a href="admin_segmento_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Arica - Valparaíso</td>
          <td>Arica</td>
          <td>Valparaíso</td>
          <td>300 Gbps</td>
          <td>120 Gbps</td>
          <td>Operativo</td>
          <td><a href="admin_segmento_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>Valparaíso - Las Toninas</td>
          <td>Valparaíso</td>
          <td>Las Toninas</td>
          <td>200 Gbps</td>
          <td>0 Gbps</td>
          <td>Fuera de servicio</td>
          <td><a href="admin_segmento_form.jsp" class="btn btn-sm btn-outline-secondary">Editar</a></td>
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
