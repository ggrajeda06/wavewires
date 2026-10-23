<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Solicitudes" %>
<%@ page import="com.oceanlink.beans.Cliente" %>
<jsp:useBean id="listaSolicitudes" type="java.util.ArrayList<com.oceanlink.beans.Solicitudes>" scope="request" />
<jsp:useBean id="listaClientes" type="java.util.ArrayList<com.oceanlink.beans.Cliente>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Solicitudes de capacidad</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Sidebar compartido del Capacity Planner -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido principal -->
  <main class="col p-4">

    <!-- Encabezado con boton para registrar solicitud -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <!-- Tarjeta con la tabla de datos -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador funcional -->
      <form method="GET" action="<%=request.getContextPath()%>/SolicitudesServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar solicitud o cliente..."
                 value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
        </div>
      </form>

      <!-- Tabla dinamica con las solicitudes -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 12%;">Solicitud</th>
            <th style="width: 15%;">Cliente</th>
            <th style="width: 16%;">Estado</th>
            <th style="width: 14%;">Segmento</th>
            <th style="width: 10%;">Capacidad</th>
            <th style="width: 14%;">Ruta</th>
            <th style="width: 10%;">Duración</th>
            <th style="width: 9%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaSolicitudes.isEmpty()) { %>
          <tr>
            <td colspan="8" class="text-center text-muted py-4">No se encontraron solicitudes registradas.</td>
          </tr>
          <% } else { %>
            <% for (Solicitudes s : listaSolicitudes) {
                 // Cruzamos el idCliente para obtener su Razon Social
                 String nombreCliente = "Cliente " + s.getIdCliente();
                 for (Cliente c : listaClientes) {
                     if (c.getIdCliente() == s.getIdCliente()) {
                         nombreCliente = c.getRazonSocial();
                         break;
                     }
                 }

                 // Ruta directa desde los String origen y destino
                 String ruta = s.getOrigen() + " - " + s.getDestino();

                 // Estilos de badge segun los 7 estados de Miro
                 String badgeClass = "bg-secondary-subtle text-secondary border border-secondary-subtle";
                 if ("En evaluación".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-warning-subtle text-warning border border-warning-subtle";
                 } else if ("Aprobado".equalsIgnoreCase(s.getEstado()) || "Provisionado".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-info-subtle text-info border border-info-subtle";
                 } else if ("Activo".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-success-subtle text-success border border-success-subtle";
                 } else if ("Rechazado".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-danger-subtle text-danger border border-danger-subtle";
                 }

                 // Texto del segmento
                 String textoSegmento = (s.getIdSegmento() == null || s.getIdSegmento() == 0) ? "No asignado" : "Segmento " + s.getIdSegmento();
                 String obsLimpias = s.getObservaciones() == null ? "" : s.getObservaciones().replace("'", "\\'");
                 String origenLimpio = s.getOrigen() == null ? "" : s.getOrigen().replace("'", "\\'");
                 String destinoLimpio = s.getDestino() == null ? "" : s.getDestino().replace("'", "\\'");
            %>
            <tr>
              <td class="fw-medium">Solicitud <%=s.getIdSolicitudCapacidad()%></td>
              <td><%=nombreCliente%></td>
              <td>
                <span class="badge <%=badgeClass%>"><%=s.getEstado()%></span>
              </td>
              <td class="<%= (s.getIdSegmento() == null || s.getIdSegmento() == 0) ? "text-muted" : "" %>">
                <%=textoSegmento%>
              </td>
              <td><%= (int) s.getCapacidad() %> Gbps</td>
              <td><%=ruta%></td>
              <td><%=s.getDuracionMeses()%> meses</td>
              <td class="text-center">
                <button type="button" class="btn btn-outline-dark btn-sm px-3"
                        onclick="abrirEditar('<%=s.getIdSolicitudCapacidad()%>', '<%=s.getIdCliente()%>', '<%= (int) s.getCapacidad() %>', '<%=origenLimpio%>', '<%=destinoLimpio%>', '<%=s.getEstado()%>', '<%=s.getIdSegmento() == null ? 0 : s.getIdSegmento()%>', '<%=s.getDuracionMeses()%>', '<%=obsLimpias%>')">
                  Editar
                </button>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>

      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button type="button" class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<!-- modal para registrar nueva solicitud -->
<div class="modal fade" id="modalRegistrarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Nueva solicitud de capacidad</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SolicitudesServlet?action=crear">
        <div class="modal-body p-4">
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select name="idCliente" class="form-select" required>
              <option value="" selected disabled>Seleccionar cliente</option>
              <% for (Cliente c : listaClientes) { %>
                <option value="<%=c.getIdCliente()%>"><%=c.getRazonSocial()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
            <input type="number" name="capacidad" class="form-control" placeholder="Ejm: 120" min="1" required>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" name="origen" class="form-control" placeholder="Ejm: España" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" name="destino" class="form-control" placeholder="Ejm: Perú" required>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" name="duracionMeses" class="form-control" placeholder="Ejm: 5" min="1" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea name="observaciones" class="form-control" rows="2" placeholder="(Opcional)"></textarea>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-dark px-3">Guardar solicitud</button>
        </div>
      </form>

    </div>
  </div>
</div>

<!-- Modal para editar solicitud de capacidad  -->
<div class="modal fade" id="modalEditarSolicitud" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Solicitud</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SolicitudesServlet?action=actualizar">
        <!-- Input oculto para enviar el ID de la solicitud a editar -->
        <input type="hidden" name="idSolicitudCapacidad" id="editId">

        <div class="modal-body p-4">
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select name="idCliente" id="editCliente" class="form-select" required>
              <% for (Cliente c : listaClientes) { %>
                <option value="<%=c.getIdCliente()%>"><%=c.getRazonSocial()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
            <input type="number" name="capacidad" id="editCapacidad" class="form-control" min="1" required>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" name="origen" id="editOrigen" class="form-control" placeholder="Ejm: España" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" name="destino" id="editDestino" class="form-control" placeholder="Ejm: Perú" required>
            </div>
          </div>

          <!-- Los 7 estados del flujo de Miro -->
          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" id="editEstado" class="form-select">
              <option value="Registrado">Registrado</option>
              <option value="En evaluación">En evaluación</option>
              <option value="Aprobado">Aprobado</option>
              <option value="Rechazado">Rechazado</option>
              <option value="Pendiente por Capacidad">Pendiente por Capacidad</option>
              <option value="Provisionado">Provisionado</option>
              <option value="Activo">Activo</option>
            </select>
            <small class="text-muted">Las reglas de transición se gestionarán en el Servlet.</small>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Segmento</label>
            <select name="idSegmento" id="editSegmento" class="form-select">
              <option value="0">No asignado</option>
              <option value="1">Segmento 1</option>
              <option value="2">Segmento 2</option>
              <option value="3">Segmento 3</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" name="duracionMeses" id="editDuracion" class="form-control" min="1" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea name="observaciones" id="editObservaciones" class="form-control" rows="2"></textarea>
          </div>
        </div>

        <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
          <a id="btnEliminarModal" href="#" class="btn btn-outline-danger px-3"
             onclick="return confirm('¿Estás seguro de que deseas eliminar esta solicitud?');">
            <i class="bi bi-trash me-1"></i> Eliminar Solicitud
          </a>
          <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-primary px-4">Guardar</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle y Script para precargar datos en el modal de Edicion -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function abrirEditar(id, idCliente, capacidad, origen, destino, estado, idSegmento, duracion, observaciones) {
  document.getElementById('editId').value = id;
  document.getElementById('editCliente').value = idCliente;
  document.getElementById('editCapacidad').value = capacidad;
  document.getElementById('editOrigen').value = origen;
  document.getElementById('editDestino').value = destino;
  document.getElementById('editEstado').value = estado;
  document.getElementById('editSegmento').value = (idSegmento && idSegmento !== 'null') ? idSegmento : "0";
  document.getElementById('editDuracion').value = duracion;
  document.getElementById('editObservaciones').value = observaciones;

  // Enlace dinamico para el boton de eliminar en el modal
  document.getElementById('btnEliminarModal').href = '<%=request.getContextPath()%>/SolicitudesServlet?action=borrar&id=' + id;

  let modal = new bootstrap.Modal(document.getElementById('modalEditarSolicitud'));
  modal.show();
}
</script>
</body>
</html>