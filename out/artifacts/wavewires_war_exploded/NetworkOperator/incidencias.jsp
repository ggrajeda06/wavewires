<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/Operador/sidebar.jsp"/>
  <main class="col p-4">
    <h4>Incidencias Activas</h4>

    <div class="row g-2 mb-3">
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Landings Operativas</small>
          <div class="fs-4">10 de 20</div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Landings en Reparación</small>
          <div class="fs-4">6</div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Incidencias Detectadas</small>
          <div class="fs-4">1</div>
        </div>
      </div>
    </div>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <a href="operador_incidencia_form.jsp" class="btn btn-primary">+ Registrar incidencia</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Incidencia</th>
          <th>Landing afectada</th>
          <th>Segmentos afectados</th>
          <th>Clientes afectados</th>
          <th>Severidad</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>INC-001</td>
          <td>Lurín CLS</td>
          <td>SEG-001, SEG-002</td>
          <td>Hola S.A.C</td>
          <td>Alta</td>
          <td>En reparación</td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
        </tr>
        <tr>
          <td>INC-002</td>
          <td>Arica CLS</td>
          <td>SEG-002</td>
          <td>Hola S.A.C, Redes S.A</td>
          <td>Alta</td>
          <td>En reparación</td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
        </tr>
        <tr>
          <td>INC-003</td>
          <td>Valparaíso CLS</td>
          <td>SEG-003</td>
          <td>Andes Telecom</td>
          <td>Media</td>
          <td>Cerrada</td>
          <td><a href="#" class="btn btn-sm btn-outline-secondary">Eliminar</a></td>
        </tr>
        <tr>
          <td>INC-004</td>
          <td>Las Toninas CLS</td>
          <td>SEG-005</td>
          <td>Hola S.A.C</td>
          <td>Baja</td>
          <td>Detectada</td>
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