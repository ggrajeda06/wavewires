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
  <jsp:include page="/Administrador/sidebar.jsp"/>
  <main class="col p-4">
    <h4>Landing Station</h4>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert alert-danger">No se puede eliminar la landing station porque tiene segmentos, mantenimientos, incidencias o solicitudes asociadas.</div>
    <% } %>

    <div class="d-flex justify-content-end mb-3">
      <a href="<%=request.getContextPath()%>/LandingStationServlet?action=formCrear" class="btn btn-primary">+ Nuevo</a>
    </div>

    <table class="table">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Ubicación</th>
          <th>Estado</th>
          <th>Segmentos</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <% for (LandingStation ls : lista) {
             String colorEstado = "bg-secondary";
             if ("Operativa".equals(ls.getEstado())) {
                 colorEstado = "bg-success";
             } else if ("Degradada".equals(ls.getEstado()) || "Mantenimiento".equals(ls.getEstado())) {
                 colorEstado = "bg-danger";
             }
        %>
        <tr>
          <td><%=ls.getNombre()%></td>
          <td><%=ls.getCiudad()%>, <%=ls.getPais()%></td>
          <td><span class="d-inline-block rounded-circle <%=colorEstado%>" style="width:8px;height:8px;"></span> <%=ls.getEstado()%></td>
          <td><a href="<%=request.getContextPath()%>/LandingStationServlet?action=verSegmentos&id=<%=ls.getIdLandingStation()%>" class="btn btn-sm btn-outline-secondary">Ver</a></td>
          <td>
            <a href="<%=request.getContextPath()%>/LandingStationServlet?action=editar&id=<%=ls.getIdLandingStation()%>" class="btn btn-sm btn-outline-secondary">Editar</a>
            <a href="<%=request.getContextPath()%>/LandingStationServlet?action=borrar&id=<%=ls.getIdLandingStation()%>" class="btn btn-sm btn-outline-danger">Eliminar</a>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>