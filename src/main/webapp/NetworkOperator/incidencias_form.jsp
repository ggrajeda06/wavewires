<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Registrar incidencia</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/IncidenciaServlet" class="btn btn-outline-secondary btn-sm me-3">Volver</a>
      <h3 class="fw-bold m-0">Registrar incidencia</h3>
    </div>

    <% if ("severidad".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Elige la severidad de la incidencia.</div>
    <% } %>
    <% if ("segmentos".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Marca al menos un segmento afectado.</div>
    <% } %>
    <% if ("guardar".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">No se pudo registrar la incidencia. Revisa los segmentos marcados.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-4">
      <form method="POST" action="<%=request.getContextPath()%>/IncidenciaServlet">
        <input type="hidden" name="action" value="crear">

        <div class="mb-3">
          <label class="form-label fw-semibold">Segmentos afectados</label>
          <div class="border rounded p-3 bg-white">
            <% for (Segmento s : listaSegmentos) { %>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="idSegmento" value="<%= s.getIdSegmento() %>" id="seg<%= s.getIdSegmento() %>">
              <label class="form-check-label" for="seg<%= s.getIdSegmento() %>">
                SEG-<%= String.format("%03d", s.getIdSegmento()) %> · <%= s.getNombreOrigen() %> - <%= s.getNombreDestino() %>
                <span class="text-muted small">(<%= s.getEstado() %>)</span>
              </label>
            </div>
            <% } %>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Severidad</label>
          <select class="form-select" name="severidad" required>
            <option value="">Seleccionar severidad...</option>
            <option value="Baja">Baja</option>
            <option value="Media">Media</option>
            <option value="Alta">Alta</option>
            <option value="Crítica">Crítica</option>
          </select>
        </div>

        <div class="mb-4">
          <label class="form-label fw-semibold">Observación inicial</label>
          <textarea class="form-control" name="observaciones" rows="3" placeholder="Opcional"></textarea>
        </div>

        <div class="d-flex justify-content-end gap-2">
          <a href="<%=request.getContextPath()%>/IncidenciaServlet" class="btn btn-outline-secondary">Cancelar</a>
          <button type="submit" class="btn btn-primary">Registrar incidencia</button>
        </div>
      </form>
    </div>
  </main>
</div>
</body>
</html>