<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires - Segmentos</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/Administrador/sidebar.jsp"/>
  <main class="col p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="mb-0">Segmentos</h4>
      <a href="admin_segmento_form.jsp" class="btn btn-primary">+ Nuevo</a>
    </div>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar por estación o código...">
      <select class="form-select w-auto">
        <option selected>Ordenar</option>
        <option>Origen (A - Z)</option>
        <option>Destino (A - Z)</option>
        <option>Más capacidad total</option>
        <option>Más capacidad disponible</option>
      </select>
    </div>

    <div class="card shadow-sm border-0">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Origen</th>
            <th>Destino</th>
            <th>Cap. usada</th>
            <th>Cap. reservada</th>
            <th>Cap. total</th>
            <th>Estado</th>
            <th class="text-center">Acción</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="fw-bold">SEG-001</td>
            <td>Lurín CLS</td>
            <td>Chimbote CLS</td>
            <td>150 Tbps</td>
            <td>50 Tbps</td>
            <td>400 Tbps</td>
            <td>Operativo</td>
            <td class="text-center">
              <a href="admin_segmento_form.jsp?id=SEG-001" class="btn btn-sm btn-outline-secondary">Editar</a>
            </td>
          </tr>
          <tr>
            <td class="fw-bold">SEG-002</td>
            <td>Lurín CLS</td>
            <td>Arica CLS</td>
            <td>50 Tbps</td>
            <td>20 Tbps</td>
            <td>100 Tbps</td>
            <td>Degradado</td>
            <td class="text-center">
              <a href="admin_segmento_form.jsp?id=SEG-002" class="btn btn-sm btn-outline-secondary">Editar</a>
            </td>
          </tr>
          <tr>
            <td class="fw-bold">SEG-003</td>
            <td>Lurín CLS</td>
            <td>Valparaíso CLS</td>
            <td>0 Tbps</td>
            <td>0 Tbps</td>
            <td>500 Tbps</td>
            <td>Mantenimiento</td>
            <td class="text-center">
              <a href="admin_segmento_form.jsp?id=SEG-003" class="btn btn-sm btn-outline-secondary">Editar</a>
            </td>
          </tr>
          <tr>
            <td class="fw-bold">SEG-004</td>
            <td>Arica CLS</td>
            <td>Valparaíso CLS</td>
            <td>120 Tbps</td>
            <td>30 Tbps</td>
            <td>300 Tbps</td>
            <td>Operativo</td>
            <td class="text-center">
              <a href="admin_segmento_form.jsp?id=SEG-004" class="btn btn-sm btn-outline-secondary">Editar</a>
            </td>
          </tr>
          <tr>
            <td class="fw-bold">SEG-005</td>
            <td>Valparaíso CLS</td>
            <td>Las Toninas CLS</td>
            <td>0 Tbps</td>
            <td>0 Tbps</td>
            <td>200 Tbps</td>
            <td>Fuera de servicio</td>
            <td class="text-center">
              <a href="admin_segmento_form.jsp?id=SEG-005" class="btn btn-sm btn-outline-secondary">Editar</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>