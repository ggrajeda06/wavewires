<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
    Incidencia inc = (Incidencia) request.getAttribute("incidencia");
    boolean esEdicion = (inc != null);

    int idIncidenciaVal = esEdicion ? inc.getIdIncidencia() : 0;
    String identificadorVal = esEdicion && inc.getIdentificador() != null ? inc.getIdentificador() : "";
    int idLandingVal = esEdicion ? inc.getIdLandingStation() : 0;
    String severidadVal = esEdicion && inc.getSeveridad() != null ? inc.getSeveridad() : "";
    String estadoVal = esEdicion && inc.getEstado() != null ? inc.getEstado() : "Abierta";
    String observacionesVal = esEdicion && inc.getObservaciones() != null ? inc.getObservaciones() : "";
    List<Integer> idsServiciosSeleccionados = esEdicion && inc.getIdsServicios() != null ? inc.getIdsServicios() : new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - <%= esEdicion ? "Editar Incidencia" : "Registrar Incidencia" %></title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <h4 class="fw-bold mb-4"><%= esEdicion ? "Editar Incidencia: " + identificadorVal : "Registrar Nueva Incidencia" %></h4>

    <div class="card p-4 shadow-sm w-75">
      <form action="<%=request.getContextPath()%>/IncidenciaServlet" method="POST">

        <input type="hidden" name="action" value="<%= esEdicion ? "actualizar" : "crear" %>">
        <% if (esEdicion) { %>
          <input type="hidden" name="id" value="<%= idIncidenciaVal %>">
        <% } %>

        <h6 class="mb-3 text-secondary fw-semibold">Datos de la Incidencia</h6>

        <div class="mb-3">
          <label class="form-label fw-semibold">Identificador de Incidencia</label>
          <input type="text" class="form-control" name="identificador" maxlength="45" value="<%= identificadorVal %>" placeholder="Ej: INC-2026-015" required>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Landing afectada</label>
          <select class="form-select" name="idLandingStation" required>
            <option value="">Seleccionar landing...</option>
            <% for (LandingStation ls : listaLandings) { %>
              <option value="<%= ls.getIdLandingStation() %>" <%= (ls.getIdLandingStation() == idLandingVal) ? "selected" : "" %>>
                <%= ls.getNombre() %> (<%= ls.getCiudad() %>, <%= ls.getPais() %>)
              </option>
            <% } %>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Servicios afectados</label>
          <div class="border rounded p-3 bg-white">
            <% if (esEdicion) { %>
              <% if (idsServiciosSeleccionados.isEmpty()) { %>
                <span class="text-muted">Esta incidencia no tiene servicios afectados.</span>
              <% } %>
              <ul class="mb-2">
                <% for (Servicio sv : listaServicios) {
                     if (idsServiciosSeleccionados.contains(sv.getIdServicio())) { %>
                <li><%= sv.getIdentificador() %> — SEG-<%= String.format("%03d", sv.getIdSegmento()) %> — <%= sv.getRazonSocial() %></li>
                <%   }
                   } %>
              </ul>
            <% } %>
            <small class="text-muted">Al guardar se registran automáticamente todos los servicios activos de los segmentos que salen o llegan a la landing elegida.</small>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Severidad</label>
          <select class="form-select" name="severidad" required>
            <option value="">Seleccionar severidad...</option>
            <option value="Baja" <%= "Baja".equalsIgnoreCase(severidadVal) ? "selected" : "" %>>Baja</option>
            <option value="Media" <%= "Media".equalsIgnoreCase(severidadVal) ? "selected" : "" %>>Media</option>
            <option value="Alta" <%= "Alta".equalsIgnoreCase(severidadVal) ? "selected" : "" %>>Alta</option>
            <option value="Crítica" <%= "Crítica".equalsIgnoreCase(severidadVal) ? "selected" : "" %>>Crítica</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Estado</label>
          <select class="form-select" name="estado" required>
            <option value="Abierta" <%= "Abierta".equalsIgnoreCase(estadoVal) ? "selected" : "" %>>Abierta</option>
            <option value="En proceso" <%= "En proceso".equalsIgnoreCase(estadoVal) ? "selected" : "" %>>En proceso</option>
            <option value="Resuelta" <%= "Resuelta".equalsIgnoreCase(estadoVal) ? "selected" : "" %>>Resuelta</option>
          </select>
        </div>

        <div class="mb-4">
          <label class="form-label fw-semibold">Observaciones</label>
          <textarea class="form-control" name="observaciones" rows="3" maxlength="255" placeholder="Opcional"><%= observacionesVal %></textarea>
        </div>

        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary px-4">Guardar</button>
          <a href="<%=request.getContextPath()%>/IncidenciaServlet" class="btn btn-secondary px-4">Cancelar</a>

          <% if (esEdicion) { %>
            <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=borrar&id=<%= idIncidenciaVal %>" class="btn btn-danger ms-auto" onclick="return confirm('¿Seguro que quieres eliminar esta incidencia?')">Eliminar</a>
          <% } %>
        </div>

      </form>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>