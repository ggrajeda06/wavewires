<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Solicitudes" %>
<%@ page import="com.oceanlink.beans.Cliente" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.util.Html" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.oceanlink.servlets.SolicitudesServlet" %>
<jsp:useBean id="listaSolicitudes" type="java.util.ArrayList<com.oceanlink.beans.Solicitudes>" scope="request" />
<jsp:useBean id="listaClientes" type="java.util.ArrayList<com.oceanlink.beans.Cliente>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<%@ page import="com.oceanlink.util.Seguridad" %>
<%
  // solo el rol duenio ve los botones de crear, editar y borrar; el Administrador solo consulta
  boolean gestiona = Seguridad.puedeGestionar(request, Seguridad.PLANIFICADOR);
%>
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
      <% if (gestiona) { %>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarSolicitud">
        <i class="bi bi-plus-lg me-1"></i> Registrar Solicitud
      </button>
      <% } %>
    </div>

    <% if ("datos".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        Revisa los datos: cliente, capacidad mayor que 0, origen y destino (máximo 100 caracteres), duración de 1 a 120 meses y observaciones (máximo 255 caracteres).
      </div>
    <% } %>

    <% if ("estado".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        Ese cambio de estado no está permitido desde el estado actual de la solicitud.
      </div>
    <% } %>

    <% if ("segmento".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        Asigna un segmento para poder aprobar, provisionar o activar la solicitud.
      </div>
    <% } %>

    <% if ("capacidad".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        No se puede activar: la capacidad usada superaría la capacidad total del segmento.
      </div>
    <% } %>

    <% if ("enUso".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        No se puede eliminar la solicitud porque ya tiene un servicio asociado.
      </div>
    <% } %>

    <% if ("noGuardado".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        No se pudo guardar la solicitud. Si ya tiene un servicio asociado, no se puede volver a activar.
      </div>
    <% } %>

    <% if ("sinReserva".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
        No se puede provisionar: la capacidad solicitada supera la capacidad reservada del segmento.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% } %>

    <% if ("fueraServicio".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger mb-3" role="alert">
        No se puede activar: el segmento asignado está Fuera de servicio por una incidencia.
      </div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">

      <form method="GET" action="<%=request.getContextPath()%>/SolicitudesServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar solicitud o cliente..."
                 value="<%=Html.esc(request.getParameter("buscar"))%>">
        </div>
      </form>

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
                 String capacidadTexto = BigDecimal.valueOf(s.getCapacidad()).stripTrailingZeros().toPlainString();
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
              <td><%=capacidadTexto%> Gbps</td>
              <td><%=ruta%></td>
              <td><%=s.getDuracionMeses()%> meses</td>
              <td class="text-center">
                <% if (gestiona) { %>
                <button type="button" class="btn btn-outline-dark btn-sm px-3"
                        data-bs-toggle="modal" data-bs-target="#editarSolicitud<%=s.getIdSolicitudCapacidad()%>">
                  Editar
                </button>
                <% } else { %>
                <span class="text-muted small">Solo consulta</span>
                <% } %>
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
            <input type="number" name="capacidad" class="form-control" placeholder="Ejm: 120" min="1" step="0.01" required>
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

<%-- Un modal de edicion y uno de borrado por solicitud (sin JavaScript propio).
     Los estados del combo salen de SolicitudesServlet.estadosPermitidos: la misma regla que valida el servlet --%>
<% if (gestiona) {
     for (Solicitudes s : listaSolicitudes) {
       int id = s.getIdSolicitudCapacidad();
       int idSegmentoActual = s.getIdSegmento() == null ? 0 : s.getIdSegmento();
       String capacidadTexto = BigDecimal.valueOf(s.getCapacidad()).stripTrailingZeros().toPlainString();
       // en Registrado todavia no se asigna segmento y en Rechazado ya no se cambia
       boolean segmentoBloqueado = s.getEstado().equals("Registrado") || s.getEstado().equals("Rechazado");
%>
<div class="modal fade" id="editarSolicitud<%=id%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Solicitud <%=id%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SolicitudesServlet?action=actualizar">
        <input type="hidden" name="idSolicitudCapacidad" value="<%=id%>">

        <div class="modal-body p-4">
          <div class="mb-3">
            <label class="form-label small fw-semibold">Cliente empresarial</label>
            <select name="idCliente" class="form-select" required>
              <% for (Cliente c : listaClientes) { %>
                <option value="<%=c.getIdCliente()%>" <%= c.getIdCliente() == s.getIdCliente() ? "selected" : "" %>><%=c.getRazonSocial()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad solicitada (Gbps)</label>
            <input type="number" name="capacidad" class="form-control" min="1" step="0.01" value="<%=capacidadTexto%>" required>
          </div>

          <div class="row g-2 mb-3">
            <div class="col-6">
              <label class="form-label small fw-semibold">Origen</label>
              <input type="text" name="origen" class="form-control" maxlength="100" value="<%=Html.esc(s.getOrigen())%>" required>
            </div>
            <div class="col-6">
              <label class="form-label small fw-semibold">Destino</label>
              <input type="text" name="destino" class="form-control" maxlength="100" value="<%=Html.esc(s.getDestino())%>" required>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select">
              <% for (String estado : SolicitudesServlet.estadosPermitidos(s.getEstado())) { %>
                <option value="<%=estado%>" <%= estado.equals(s.getEstado()) ? "selected" : "" %>><%=estado%></option>
              <% } %>
            </select>
            <small class="text-muted">Solo aparecen los estados a los que puede pasar desde el actual.</small>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Segmento</label>
            <% if (segmentoBloqueado) { %>
              <%-- un select deshabilitado no se envia, por eso va el valor en un campo oculto --%>
              <input type="hidden" name="idSegmento" value="<%=idSegmentoActual%>">
            <% } %>
            <select <%= segmentoBloqueado ? "" : "name=\"idSegmento\"" %> class="form-select" <%= segmentoBloqueado ? "disabled" : "" %>>
              <option value="0">No asignado</option>
              <% for (Segmento seg : listaSegmentos) { %>
                <option value="<%=seg.getIdSegmento()%>" <%= seg.getIdSegmento() == idSegmentoActual ? "selected" : "" %>>
                  SEG-<%=String.format("%03d", seg.getIdSegmento())%> (<%=seg.getNombreOrigen()%> - <%=seg.getNombreDestino()%>) - reservado: <%=seg.getCapacidadReservada().stripTrailingZeros().toPlainString()%> Gbps
                </option>
              <% } %>
            </select>
            <% if (s.getEstado().equals("Registrado")) { %>
              <small class="text-muted">El segmento se asigna a partir de "En evaluación".</small>
            <% } %>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Duración (meses)</label>
            <input type="number" name="duracionMeses" class="form-control" min="1" max="120" value="<%=s.getDuracionMeses()%>" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Observaciones</label>
            <textarea name="observaciones" class="form-control" rows="2" maxlength="255"><%=Html.esc(s.getObservaciones())%></textarea>
          </div>
        </div>

        <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-danger px-3"
                  data-bs-toggle="modal" data-bs-target="#borrarSolicitud<%=id%>">
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

<div class="modal fade" id="borrarSolicitud<%=id%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar solicitud</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar la <b>Solicitud <%=id%></b>?
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#editarSolicitud<%=id%>">Volver</button>
        <a href="<%=request.getContextPath()%>/SolicitudesServlet?action=borrar&id=<%=id%>" class="btn btn-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<%   }
   } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>