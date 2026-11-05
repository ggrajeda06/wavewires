<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Solicitudes" %>
<%@ page import="com.oceanlink.beans.Cliente" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="listaSolicitudes" type="java.util.ArrayList<com.oceanlink.beans.Solicitudes>" scope="request" />
<jsp:useBean id="listaClientes" type="java.util.ArrayList<com.oceanlink.beans.Cliente>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Solicitudes de capacidad</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Solicitudes de capacidad</h2>
        <small class="text-muted">Evalúa la viabilidad de la capacidad</small>
      </div>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
    </div>

    <% if ("sinReserva".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        No hay suficiente capacidad reservada en el segmento para provisionar la solicitud.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% } %>

    <% if ("datos".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3">Revisa los datos: cliente válido, origen y destino (máximo 100 caracteres), capacidad mayor que 0, duración de 1 a 120 meses y observaciones de máximo 255 caracteres.</div>
    <% } %>
    <% if ("estado".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3">Ese cambio de estado no está permitido. El orden es Registrado, En evaluación, Aprobado, Provisionado y Activo.</div>
    <% } %>
    <% if ("segmento".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3">Asigna un segmento válido para aprobar, provisionar o activar la solicitud.</div>
    <% } %>
    <% if ("capacidad".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3">La capacidad de la solicitud supera la capacidad libre del segmento.</div>
    <% } %>

    <% if ("fueraServicio".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        No se puede activar: el segmento asignado está Fuera de servicio (RN3).
      </div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">

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

                 // Estilos de badge segun el estado
                 String badgeClass = "bg-secondary-subtle text-secondary border border-secondary-subtle";
                 if ("En evaluación".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-warning-subtle text-warning border border-warning-subtle";
                 } else if ("Aprobado".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-info-subtle text-info border border-info-subtle";
                 } else if ("Provisionado".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-primary-subtle text-primary border border-primary-subtle";
                 } else if ("Pendiente por Capacidad".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-dark-subtle text-dark border border-dark-subtle";
                 } else if ("Activo".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-success-subtle text-success border border-success-subtle";
                 } else if ("Rechazado".equalsIgnoreCase(s.getEstado()) || "Rechazada".equalsIgnoreCase(s.getEstado())) {
                     badgeClass = "bg-danger-subtle text-danger border border-danger-subtle";
                 }

                 // Texto del segmento
                 String textoSegmento = (s.getIdSegmento() == null || s.getIdSegmento() == 0) ? "No asignado" : "Segmento " + s.getIdSegmento();
                 for (Segmento seg : listaSegmentos) {
                     if (s.getIdSegmento() != null && seg.getIdSegmento() == s.getIdSegmento()) {
                         textoSegmento = "SEG-" + String.format("%03d", seg.getIdSegmento());
                         break;
                     }
                 }
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
                <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="#editar<%=s.getIdSolicitudCapacidad()%>">
                  Editar
                </button>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

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
              <input type="text" name="origen" class="form-control" maxlength="100" placeholder="Ejm: España" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" name="destino" class="form-control" maxlength="100" placeholder="Ejm: Perú" required>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" name="duracionMeses" class="form-control" placeholder="Ejm: 5" min="1" max="120" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea name="observaciones" class="form-control" rows="2" maxlength="255" placeholder="(Opcional)"></textarea>
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

<!-- un modal de editar y uno de eliminar por solicitud, ya con sus datos (sin JavaScript) -->
<% for (Solicitudes s : listaSolicitudes) {
     String estado = s.getEstado();
     int idSegmentoActual = s.getIdSegmento() == null ? 0 : s.getIdSegmento();

     // estados a los que puede pasar (el mismo flujo que valida SolicitudesServlet, RN7)
     String[] estadosSiguientes = {estado};
     if (estado.equals("Registrado")) {
         estadosSiguientes = new String[]{"Registrado", "En evaluación"};
     } else if (estado.equals("En evaluación")) {
         estadosSiguientes = new String[]{"En evaluación", "Aprobado", "Rechazado"};
     } else if (estado.equals("Aprobado")) {
         estadosSiguientes = new String[]{"Aprobado", "Provisionado", "Pendiente por Capacidad"};
     } else if (estado.equals("Pendiente por Capacidad")) {
         estadosSiguientes = new String[]{"Pendiente por Capacidad", "Provisionado", "Rechazado"};
     } else if (estado.equals("Provisionado")) {
         estadosSiguientes = new String[]{"Provisionado", "Activo"};
     }

     // el segmento se elige recien en evaluacion; Registrado y Rechazado lo dejan como esta
     boolean eligeSegmento = !estado.equals("Registrado") && !estado.equals("Rechazado");
%>
<div class="modal fade" id="editar<%=s.getIdSolicitudCapacidad()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Solicitud <%=s.getIdSolicitudCapacidad()%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SolicitudesServlet?action=actualizar">
        <input type="hidden" name="idSolicitudCapacidad" value="<%=s.getIdSolicitudCapacidad()%>">

        <div class="modal-body p-4">
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select name="idCliente" class="form-select" required>
              <% for (Cliente c : listaClientes) { %>
                <option value="<%=c.getIdCliente()%>" <%=c.getIdCliente() == s.getIdCliente() ? "selected" : ""%>><%=c.getRazonSocial()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
            <input type="number" name="capacidad" class="form-control" min="1" value="<%= (int) s.getCapacidad() %>" required>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" name="origen" class="form-control" maxlength="100" value="<%=s.getOrigen()%>" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" name="destino" class="form-control" maxlength="100" value="<%=s.getDestino()%>" required>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select">
              <% for (String e : estadosSiguientes) { %>
                <option value="<%=e%>" <%=e.equals(estado) ? "selected" : ""%>><%=e%></option>
              <% } %>
            </select>
            <small class="text-muted">Solo aparecen los estados a los que puede pasar.</small>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Segmento</label>
            <% if (eligeSegmento) { %>
            <select name="idSegmento" class="form-select">
              <option value="0">No asignado</option>
              <% for (Segmento seg : listaSegmentos) { %>
                <option value="<%=seg.getIdSegmento()%>" <%=seg.getIdSegmento() == idSegmentoActual ? "selected" : ""%>>SEG-<%=String.format("%03d", seg.getIdSegmento())%> (<%=seg.getNombreOrigen()%> - <%=seg.getNombreDestino()%>)</option>
              <% } %>
            </select>
            <% } else { %>
            <input type="hidden" name="idSegmento" value="<%=idSegmentoActual%>">
            <input type="text" class="form-control bg-light" value="<%=idSegmentoActual == 0 ? "No asignado" : "SEG-" + String.format("%03d", idSegmentoActual)%>" readonly>
            <% } %>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" name="duracionMeses" class="form-control" min="1" max="120" value="<%=s.getDuracionMeses()%>" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea name="observaciones" class="form-control" rows="2" maxlength="255"><%=s.getObservaciones() == null ? "" : s.getObservaciones()%></textarea>
          </div>
        </div>

        <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-danger px-3" data-bs-toggle="modal" data-bs-target="#borrar<%=s.getIdSolicitudCapacidad()%>">
            <i class="bi bi-trash me-1"></i> Eliminar Solicitud
          </button>
          <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-primary px-4">Guardar</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</div>

<div class="modal fade" id="borrar<%=s.getIdSolicitudCapacidad()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar solicitud</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar la <b>Solicitud <%=s.getIdSolicitudCapacidad()%></b>?
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-primary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/SolicitudesServlet?action=borrar&id=<%=s.getIdSolicitudCapacidad()%>" class="btn btn-outline-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>