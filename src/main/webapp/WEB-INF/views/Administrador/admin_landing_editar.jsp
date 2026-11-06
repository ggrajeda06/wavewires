<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.util.Html" %>
<jsp:useBean id="landing" type="com.oceanlink.beans.LandingStation" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/WEB-INF/views/Administrador/sidebar.jsp"/>
  <main class="col p-4">
    <div class="d-flex justify-content-between align-items-center mb-3" style="max-width: 50%;">
      <h4 class="mb-0">Editar Landing Station</h4>
      <a href="<%=request.getContextPath()%>/LandingStationServlet" class="btn btn-sm btn-outline-secondary">×</a>
    </div>

    <% if ("vacio".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger w-50">Completa el nombre, el país y la ciudad.</div>
    <% } else if ("largo".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger w-50">Cada campo puede tener como máximo 100 caracteres.</div>
    <% } else if ("nombreRepetido".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger w-50">Ya existe una landing station con ese nombre.</div>
    <% } %>

    <form class="card p-4 w-50" method="POST" action="<%=request.getContextPath()%>/LandingStationServlet?action=actualizar">
      <input type="hidden" name="id" value="<%=landing.getIdLandingStation()%>">
      <h6 class="mb-3">Datos</h6>

      <label class="form-label">ID</label>
      <input class="form-control mb-3 bg-light" value="<%=landing.getIdLandingStation()%>" readonly>

      <label class="form-label" for="nombre">Nombre</label>
      <input class="form-control mb-3" id="nombre" name="nombre" maxlength="100" value="<%=Html.esc(landing.getNombre())%>" required>

      <label class="form-label" for="pais">País</label>
      <input class="form-control mb-3" id="pais" name="pais" maxlength="100" value="<%=Html.esc(landing.getPais())%>" required>

      <label class="form-label" for="ciudad">Ciudad / localidad</label>
      <input class="form-control mb-4" id="ciudad" name="ciudad" maxlength="100" value="<%=Html.esc(landing.getCiudad())%>" required>

      <div>
        <a href="<%=request.getContextPath()%>/LandingStationServlet" class="btn btn-secondary">Cancelar</a>
        <button type="submit" class="btn btn-primary">Actualizar</button>
      </div>
    </form>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>