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
    <h4>Segmentos de Lurín</h4>

    <table class="table">
      <thead>
        <tr>
          <th>Destino</th>
          <th>Capacidad</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Chimbote</td>
          <td>400 Gbps</td>
          <td>Operativo</td>
        </tr>
        <tr>
          <td>Arica</td>
          <td>500 Gbps</td>
          <td>Degradado</td>
        </tr>
        <tr>
          <td>Valparaíso</td>
          <td>500 Gbps</td>
          <td>Mantenimiento</td>
        </tr>
      </tbody>
    </table>

    <a href="admin_landings.jsp" class="btn btn-secondary">Volver</a>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
