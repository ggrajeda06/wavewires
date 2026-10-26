<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Registro de reservas</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4 p-lg-5">
    <div class="container-fluid" style="max-width: 1000px;">

      <div class="mb-4">
        <h2 class="h3 fw-bold text-dark m-0">Registro de reservas</h2>
      </div>

      <% if ("excede".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
          La capacidad reservada no puede superar la capacidad disponible del segmento.
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      <% } %>

      <div class="card shadow-sm border-0 p-4 bg-white rounded-3">

        <!-- Buscador -->
        <form method="GET" action="<%=request.getContextPath()%>/ReservaServlet" class="row mb-4">
          <div class="col-md-5">
            <input type="text" name="buscar" class="form-control" placeholder="Buscar por segmento o ruta..."
                   value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
          </div>
        </form>

        <!-- Tabla de reservas -->
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-4">
            <thead class="table-light">
            <tr>
              <th class="py-3" style="width: 25%;">Segmentos</th>
              <th class="py-3" style="width: 28%;">Ruta</th>
              <th class="py-3" style="width: 25%;">Cantidad reservada</th>
              <th class="py-3 text-end" style="width: 22%;">Modificar cantidad</th>
            </tr>
            </thead>
            <tbody>
            <% if (listaSegmentos.isEmpty()) { %>
            <tr>
              <td colspan="4" class="text-center text-muted py-4">No se encontraron segmentos registrados.</td>
            </tr>
            <% } else { %>
              <% for (Segmento s : listaSegmentos) {
                   int total = s.getCapacidadTotal() != null ? s.getCapacidadTotal().intValue() : 0;
                   int reservada = s.getCapacidadReservada() != null ? s.getCapacidadReservada().intValue() : 0;
                   String ruta = s.getNombreOrigen() + " - " + s.getNombreDestino();
              %>
              <tr>
                <td class="fw-semibold">Segmento <%=s.getIdSegmento()%></td>
                <td><%=ruta%></td>
                <td><span class="badge bg-light text-dark border"><%=reservada%> / <%=total%> Gbps</span></td>
                <td class="text-end">
                  <button type="button" class="btn btn-outline-primary btn-sm px-3"
                          onclick="abrirModalModificar('<%=s.getIdSegmento()%>', '<%=total%>', '<%=reservada%>')">
                    <i class="bi bi-pencil-square me-1"></i> Modificar
                  </button>
                </td>
              </tr>
              <% } %>
            <% } %>
            </tbody>
          </table>
        </div>

        <!-- Paginación -->
        <div class="d-flex justify-content-end gap-2 pt-2 border-top">
          <button type="button" class="btn btn-outline-secondary btn-sm px-3" disabled>Anterior</button>
          <button type="button" class="btn btn-outline-secondary btn-sm px-3">Siguiente</button>
        </div>

      </div>
    </div>
  </main>
</div>

<!-- Modal para modificar reserva -->
<div class="modal fade" id="modalModificarReserva" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width: 380px;">
    <div class="modal-content border-0 shadow rounded-3">

      <div class="modal-header border-bottom py-2 px-3">
        <h6 class="modal-title fw-bold m-0">Modificar cantidad reservada</h6>
        <button type="button" class="btn-close btn-close-sm" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/ReservaServlet?action=actualizar">
        <input type="hidden" name="idSegmento" id="modificarIdSegmento">

        <div class="modal-body p-3">
          <div class="mb-3">
            <label class="form-label small text-muted mb-1">Límite del segmento</label>
            <input type="text" id="modificarLimite" class="form-control form-control-sm bg-light text-center fw-medium" readonly>
          </div>

          <div class="mb-2">
            <label class="form-label small fw-semibold mb-1">Capacidad reservada (Gbps)</label>
            <div class="input-group input-group-sm">
              <button class="btn btn-outline-secondary" type="button" onclick="cambiarCantidad(-10)"><i class="bi bi-dash-lg"></i></button>
              <input type="number" name="capacidadReservada" id="modificarCantidad" class="form-control text-center fw-bold" min="0" required>
              <button class="btn btn-outline-secondary" type="button" onclick="cambiarCantidad(10)"><i class="bi bi-plus-lg"></i></button>
            </div>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 pb-3 px-3 d-flex justify-content-end gap-2">
          <button type="button" class="btn btn-outline-secondary btn-sm px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary btn-sm px-3">Guardar</button>
        </div>
      </form>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function abrirModalModificar(id, limite, actual) {
  document.getElementById('modificarIdSegmento').value = id;
  document.getElementById('modificarLimite').value = limite + ' Gbps';
  document.getElementById('modificarCantidad').value = actual;

  let modal = new bootstrap.Modal(document.getElementById('modalModificarReserva'));
  modal.show();
}

function cambiarCantidad(delta) {
  let input = document.getElementById('modificarCantidad');
  let val = parseInt(input.value) || 0;
  val = Math.max(0, val + delta);
  input.value = val;
}
</script>
</body>
</html>