<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
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
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="mb-0">Landing Stations</h4>
      <a href="<%=request.getContextPath()%>/LandingStationServlet?action=formCrear" class="btn btn-primary">+ Nuevo</a>
    </div>

    <% if ("noBorrado".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">No se puede eliminar la landing station porque tiene segmentos o mantenimientos asociados.</div>
    <% } %>

    <div class="card shadow-sm border-0">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>Nombre</th>
            <th>Ubicación</th>
            <th>Segmentos</th>
            <th class="text-center">Acción</th>
          </tr>
        </thead>
        <tbody>
          <% for (LandingStation ls : lista) { %>
          <tr>
            <td class="fw-bold"><%=ls.getNombre()%></td>
            <td><%=ls.getCiudad()%>, <%=ls.getPais()%></td>
            <td><a href="<%=request.getContextPath()%>/LandingStationServlet?action=verSegmentos&id=<%=ls.getIdLandingStation()%>" class="btn btn-sm btn-outline-secondary">Ver</a></td>
            <td class="text-center">
              <a href="<%=request.getContextPath()%>/LandingStationServlet?action=editar&id=<%=ls.getIdLandingStation()%>" class="btn btn-sm btn-outline-secondary">Editar</a>
              <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#borrar<%=ls.getIdLandingStation()%>">Eliminar</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </main>
</div>

<% for (LandingStation ls : lista) { %>
<div class="modal fade" id="borrar<%=ls.getIdLandingStation()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar landing station</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar <b><%=ls.getNombre()%></b>?
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-primary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/LandingStationServlet?action=borrar&id=<%=ls.getIdLandingStation()%>" class="btn btn-outline-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>