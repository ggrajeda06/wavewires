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
    <p class="text-muted mb-1">Buenos días, señor Administrador</p>
    <h4 class="mb-4">Resumen</h4>

    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <div class="card p-3 border-danger">
          <small class="text-danger">Incidencias críticas</small>
          <div class="fs-4">5 / 9</div>
          <a href="/NetworkOperator/incidencias.jsp" class="btn btn-sm btn-outline-danger mt-2">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 border-warning">
          <small class="text-warning">Solicitudes pendientes</small>
          <div class="fs-4">4</div>
          <a href="/CapacityPlanner/solicitudes.jsp" class="btn btn-sm btn-outline-warning mt-2">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Mantenimientos próximos (48h)</small>
          <div class="fs-4">3</div>
          <a href="/Maintence/Mantenimiento.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ver</a>
        </div>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Landing Stations operativas</small>
          <div class="fs-4">8 / 10</div>
          <div class="progress mt-2 mb-2" style="height: 6px;">
            <div class="progress-bar bg-success" style="width: 80%"></div>
          </div>
          <a href="admin_landings.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Segmentos operativos</small>
          <div class="fs-4">47 / 105</div>
          <div class="progress mt-2 mb-2" style="height: 6px;">
            <div class="progress-bar bg-danger" style="width: 45%"></div>
          </div>
          <a href="admin_segmentos.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Capacidad de red utilizada</small>
          <div class="fs-4">74% (118 / 160 Tbps)</div>
          <div class="progress mt-2 mb-2" style="height: 6px;">
            <div class="progress-bar bg-success" style="width: 74%"></div>
          </div>
          <a href="/CapacityPlanner/index.jsp" class="btn btn-sm btn-outline-secondary">Ver</a>
        </div>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Servicios activos</small>
          <div class="fs-4">22</div>
          <a href="/CapacityPlanner/reservas.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Clientes activos</small>
          <div class="fs-4">12 / 15</div>
          <a href="/CapacityPlanner/clientes.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ver</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <small class="text-muted">Usuarios activos</small>
          <div class="fs-4">38 / 47</div>
          <a href="admin_usuarios.jsp" class="btn btn-sm btn-outline-secondary mt-2">Ver</a>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-md-8">
        <div class="card p-3">
          <h6>Incidencias críticas</h6>
          <table class="table table-sm mb-0">
            <thead>
              <tr>
                <th>Ticket</th>
                <th>Afectación</th>
                <th>Severidad</th>
                <th>Tiempo abierto</th>
                <th>Acción</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>INC-001</td>
                <td>Lurín CLS — falla de energía auxiliar</td>
                <td>Crítica</td>
                <td>25 min</td>
                <td><a href="/NetworkOperator/incidencias.jsp?id=1" class="btn btn-sm btn-outline-secondary">Detalle</a></td>
              </tr>
              <tr>
                <td>INC-002</td>
                <td>Valparaíso CLS ➔ Arica CLS — atenuación alta</td>
                <td>Crítica</td>
                <td>1 h</td>
                <td><a href="/NetworkOperator/incidencias.jsp?id=2" class="btn btn-sm btn-outline-secondary">Detalle</a></td>
              </tr>
              <tr>
                <td>INC-003</td>
                <td>Lurín CLS ➔ Valparaíso CLS — corte de fibra</td>
                <td>Crítica</td>
                <td>3 h</td>
                <td><a href="/NetworkOperator/incidencias.jsp?id=3" class="btn btn-sm btn-outline-secondary">Detalle</a></td>
              </tr>
              <tr>
                <td>INC-004</td>
                <td>Las Toninas CLS — pérdida de señal</td>
                <td>Crítica</td>
                <td>5 h</td>
                <td><a href="/NetworkOperator/incidencias.jsp?id=4" class="btn btn-sm btn-outline-secondary">Detalle</a></td>
              </tr>
              <tr>
                <td>INC-005</td>
                <td>Arica CLS — sobrecalentamiento equipo</td>
                <td>Crítica</td>
                <td>6 h</td>
                <td><a href="/NetworkOperator/incidencias.jsp?id=5" class="btn btn-sm btn-outline-secondary">Detalle</a></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3">
          <h6>Solicitudes pendientes</h6>
          <div class="d-flex justify-content-between mb-2">
            <span>TelcoSur</span>
            <span class="text-muted">10 Gbps</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Andes Telecom</span>
            <span class="text-muted">25 Gbps</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Redes S.A</span>
            <span class="text-muted">5 Gbps</span>
          </div>
          <div class="d-flex justify-content-between mb-3">
            <span>Hola S.A.C</span>
            <span class="text-muted">15 Gbps</span>
          </div>
          <a href="/CapacityPlanner/solicitudes.jsp" class="btn btn-sm btn-outline-secondary w-100">Ver todas</a>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>