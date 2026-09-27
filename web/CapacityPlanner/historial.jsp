<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>WaveWires - Historial de segmentos</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Menú lateral -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Encabezado de la vista -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Historial de segmentos</h2>
        <small class="text-muted">Consulta de tramos y registro histórico de enlaces finalizados</small>
      </div>
    </div>

    <!-- Tarjeta principal simétrica -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador principal -->
      <div class="row mb-3">
        <div class="col-md-4">
          <input type="text" class="form-control" placeholder="Buscar segmento o ruta...">
        </div>
      </div>

      <!-- Tabla: Historial de segmentos -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 30%;">Segmento</th>
            <th style="width: 45%;">Ruta</th>
            <th style="width: 25%;" class="text-center">Servicios caducados</th>
          </tr>
          </thead>
          <tbody>
          <!-- Segmento 1 -->
          <tr>
            <td class="fw-medium">Segmento 1</td>
            <td>Perú - EEUU</td>
            <td class="text-center">
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalServiciosCaducados">
                Ver más
              </button>
            </td>
          </tr>

          <!-- Segmento 2 -->
          <tr>
            <td class="fw-medium">Segmento 2</td>
            <td>Perú - España</td>
            <td class="text-center">
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSinCaducados">
                Ver más
              </button>
            </td>
          </tr>

          <!-- Segmento 3 -->
          <tr>
            <td class="fw-medium">Segmento 3</td>
            <td>Perú - Japón</td>
            <td class="text-center">
              <button class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#modalSinCaducados">
                Ver más
              </button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <!-- Paginación principal -->
      <div class="d-flex justify-content-end gap-2">
        <button class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<!-- ======================================================= -->
<!-- MODAL: SERVICIOS CADUCADOS (Versión Simétrica y Limpia) -->
<!-- ======================================================= -->
<div class="modal fade" id="modalServiciosCaducados" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0 shadow">

      <!-- 1. Encabezado limpio -->
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0 text-dark">Servicios Caducados</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <!-- 2. Cuerpo del modal -->
      <div class="modal-body p-4">

        <!-- Buscador alineado -->
        <div class="row mb-3">
          <div class="col-md-5">
            <input type="text" class="form-control" placeholder="Buscar servicio o cliente...">
          </div>
        </div>

        <!-- Tabla con anchos equilibrados y texto en una sola línea -->
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
              <th style="width: 20%;">Servicios</th>
              <th style="width: 25%;">Cliente</th>
              <th style="width: 20%;">Segmento</th>
              <th style="width: 17%;">Capacidad</th>
              <th style="width: 18%;" class="text-center">Acción</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td class="fw-medium">Servicio 1</td>
              <td>OAC S.A.C.</td>
              <td>Segmento 1</td>
              <td class="text-secondary fw-semibold">30 Gbps</td>
              <td class="text-center">
                <button class="btn btn-outline-danger btn-sm px-3 text-nowrap" onclick="return confirm('¿Está seguro de eliminar este registro?')">
                  <i class="bi bi-trash me-1"></i> Eliminar
                </button>
              </td>
            </tr>
            <tr>
              <td class="fw-medium">Servicio 2</td>
              <td>HYDRA S.A.C.</td>
              <td>Segmento 1</td>
              <td class="text-secondary fw-semibold">100 Gbps</td>
              <td class="text-center">
                <button class="btn btn-outline-danger btn-sm px-3 text-nowrap" onclick="return confirm('¿Está seguro de eliminar este registro?')">
                  <i class="bi bi-trash me-1"></i> Eliminar
                </button>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

      </div>

      <!-- 3. Pie del Modal equilibrado en una sola fila -->
      <div class="modal-footer d-flex justify-content-between align-items-center border-top py-3 px-4 bg-light-subtle">
        <!-- Botón de Cerrar a la izquierda -->
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">
          Cerrar
        </button>
        <!-- Paginación a la derecha en la misma línea -->
        <div class="d-flex gap-2">
          <button class="btn btn-outline-secondary btn-sm px-3" disabled>Anterior</button>
          <button class="btn btn-outline-secondary btn-sm px-3">Siguiente</button>
        </div>
      </div>

    </div>
  </div>
</div>


<div class="modal fade" id="modalSinCaducados" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow text-center p-4">
      <div class="modal-body">
        <i class="bi bi-check-circle text-success fs-1 mb-2 d-block"></i>
        <h6 class="fw-bold mb-2">Servicios Caducados</h6>
        <p class="text-muted small mb-3">No existen servicios caducados ni de baja registrados en este segmento.</p>
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle (Solo necesario para abrir/cerrar modales) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>