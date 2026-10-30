<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="incidencia" type="com.oceanlink.beans.Incidencia" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="estadosPermitidos" type="java.util.ArrayList<java.lang.String>" scope="request" />
<jsp:useBean id="puedeCambiarSegmentos" type="java.lang.Boolean" scope="request" />
<%
    String[] severidades = {"Baja", "Media", "Alta", "Crítica"};
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Editar incidencia</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%= incidencia.getIdIncidencia() %>" class="btn btn-outline-secondary btn-sm me-3">Volver</a>
      <h3 class="fw-bold m-0">Editar <%= incidencia.getIdentificador() %></h3>
      <span class="badge bg-secondary ms-3"><%= incidencia.getEstado() %></span>
    </div>

    <% if ("severidad".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Elige la severidad de la incidencia.</div>
    <% } %>
    <% if ("segmentos".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Marca al menos un segmento afectado.</div>
    <% } %>
    <% if ("estado".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Ese cambio de estado no está permitido desde <%= incidencia.getEstado() %>.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-4">
      <form method="POST" action="<%=request.getContextPath()%>/IncidenciaServlet">
        <input type="hidden" name="action" value="actualizar">
        <input type="hidden" name="id" value="<%= incidencia.getIdIncidencia() %>">

        <div class="row g-4">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label fw-semibold">Severidad</label>
              <select class="form-select" name="severidad" required>
                <% for (String sev : severidades) { %>
                <option value="<%= sev %>" <%= sev.equals(incidencia.getSeveridad()) ? "selected" : "" %>><%= sev %></option>
                <% } %>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold">Estado</label>
              <% if (estadosPermitidos.isEmpty()) { %>
              <input type="hidden" name="estado" value="">
              <div class="form-control bg-light"><%= incidencia.getEstado() %></div>
              <% } else { %>
              <select class="form-select" name="estado">
                <option value="">Mantener: <%= incidencia.getEstado() %></option>
                <% for (String est : estadosPermitidos) { %>
                <option value="<%= est %>"><%= est %></option>
                <% } %>
              </select>
              <% } %>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold">Nueva observación</label>
              <textarea class="form-control" name="observacion" rows="3"></textarea>
            </div>
          </div>

          <div class="col-md-6">
            <label class="form-label fw-semibold">Segmentos afectados</label>
            <div class="border rounded p-3 bg-white mb-3">
              <% for (Segmento s : listaSegmentos) {
                   boolean marcado = incidencia.getIdsSegmentos().contains(s.getIdSegmento());
                   if (puedeCambiarSegmentos) {
              %>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" name="idSegmento" value="<%= s.getIdSegmento() %>" id="seg<%= s.getIdSegmento() %>" <%= marcado ? "checked" : "" %>>
                <label class="form-check-label" for="seg<%= s.getIdSegmento() %>">
                  SEG-<%= String.format("%03d", s.getIdSegmento()) %> · <%= s.getNombreOrigen() %> - <%= s.getNombreDestino() %>
                  <span class="text-muted small">(<%= s.getEstado() %>)</span>
                </label>
              </div>
              <%   } else if (marcado) { %>
              <div>SEG-<%= String.format("%03d", s.getIdSegmento()) %> · <%= s.getNombreOrigen() %> - <%= s.getNombreDestino() %></div>
              <%   }
                 } %>
            </div>

            <label class="form-label fw-semibold">Observaciones anteriores</label>
            <div class="border rounded px-3 py-2 bg-light" style="white-space: pre-line; min-height: 80px;"><%= incidencia.getObservaciones() == null ? "Sin observaciones." : incidencia.getObservaciones() %></div>
          </div>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4">
          <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%= incidencia.getIdIncidencia() %>" class="btn btn-outline-secondary">Cancelar</a>
          <button type="submit" class="btn btn-primary">Guardar cambios</button>
        </div>
      </form>
    </div>
  </main>
</div>
</body>
</html>