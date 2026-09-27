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
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="mb-0">Información: Lurín</h4>
      <a href="admin_landings.jsp" class="btn btn-sm btn-outline-secondary">×</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Tramo</th>
          <th>Destino</th>
          <th>Capacidad</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>SEG-001</td>
          <td>Chimbote</td>
          <td>400 Gbps</td>
          <td><span class="d-inline-block rounded-circle bg-success" style="width:8px;height:8px;"></span> Operativo</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-001" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>SEG-002</td>
          <td>Arica</td>
          <td>500 Gbps</td>
          <td><span class="d-inline-block rounded-circle bg-danger" style="width:8px;height:8px;"></span> Degradado</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-002" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
        <tr>
          <td>SEG-003</td>
          <td>Valparaíso</td>
          <td>500 Gbps</td>
          <td><span class="d-inline-block rounded-circle bg-danger" style="width:8px;height:8px;"></span> Mantenimiento</td>
          <td><a href="admin_segmento_form.jsp?id=SEG-003" class="btn btn-sm btn-outline-secondary">Editar</a></td>
        </tr>
      </tbody>
    </table>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>