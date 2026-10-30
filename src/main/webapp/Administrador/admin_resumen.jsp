<%@ page contentType="text/html;charset=UTF-8" %>
<%
  // si se entra directo al JSP no hay datos: se manda al servlet que los trae
  if (request.getAttribute("totalUsuarios") == null) {
      response.sendRedirect(request.getContextPath() + "/ResumenServlet");
      return;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Resumen</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/Administrador/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <h3 class="fw-bold mb-4">Resumen</h3>

    <div class="row g-3">
      <div class="col-md-4">
        <div class="card shadow-sm border-0 p-3">
          <small class="text-muted">Usuarios activos</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("usuariosActivos") %> de <%= request.getAttribute("totalUsuarios") %></div>
          <a href="<%=request.getContextPath()%>/UsuarioServlet" class="btn btn-sm btn-outline-secondary mt-2">Ver usuarios</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card shadow-sm border-0 p-3">
          <small class="text-muted">Landing Stations operativas</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("landingsOperativas") %> de <%= request.getAttribute("totalLandings") %></div>
          <a href="<%=request.getContextPath()%>/LandingStationServlet" class="btn btn-sm btn-outline-secondary mt-2">Ver landings</a>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card shadow-sm border-0 p-3">
          <small class="text-muted">Segmentos operativos</small>
          <div class="fs-3 fw-semibold"><%= request.getAttribute("segmentosOperativos") %> de <%= request.getAttribute("totalSegmentos") %></div>
          <a href="<%=request.getContextPath()%>/SegmentoServlet" class="btn btn-sm btn-outline-secondary mt-2">Ver segmentos</a>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>