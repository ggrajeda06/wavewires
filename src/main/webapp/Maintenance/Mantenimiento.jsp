<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Mantenimiento" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Mantenimiento>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0">Historial de Mantenimiento</h3>
      <a class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/MantenimientoServlet?action=formCrear">Registrar mantenimiento</a>
    </div>

    <% if ("noBorrable".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Solo se puede eliminar un mantenimiento en estado Pendiente.</div>
    <% } %>

    <div class="card shadow-sm">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">Mantenimiento (ID)</th>
                <th scope="col">Tipo</th>
                <th scope="col">Estado</th>
                <th scope="col">Fecha</th>
                <th scope="col">Infraestructura</th>
                <th scope="col">Incidencia</th>
                <th scope="col" class="text-end pe-4">Acción</th>
              </tr>
            </thead>
            <tbody>
              <% for (Mantenimiento m : lista) {
                   String infraestructura = "";
                   if (m.getIdSegmento() > 0) {
                       for (Segmento s : listaSegmentos) {
                           if (s.getIdSegmento() == m.getIdSegmento()) {
                               infraestructura = "SEG-" + String.format("%03d", s.getIdSegmento()) + " (" + s.getNombreOrigen() + " - " + s.getNombreDestino() + ")";
                           }
                       }
                   } else {
                       for (LandingStation ls : listaLandings) {
                           if (ls.getIdLandingStation() == m.getIdLandingStation()) {
                               infraestructura = ls.getNombre() + " (" + ls.getCiudad() + ", " + ls.getPais() + ")";
                           }
                       }
                   }

                   String colorEstado = "bg-secondary";
                   if (m.getEstado().equals("Activo")) {
                       colorEstado = "bg-success";
                   } else if (m.getEstado().equals("Pendiente")) {
                       colorEstado = "bg-danger";
                   }
              %>
              <tr>
                <td class="ps-4">
                  <a href="<%=request.getContextPath()%>/MantenimientoServlet?action=ver&id=<%=m.getIdMantenimiento()%>" class="text-decoration-none fw-bold">
                    ID<%=m.getIdMantenimiento()%> - <%=m.getNombre()%>
                  </a>
                </td>
                <td><%=m.getTipo()%></td>
                <td><span class="badge <%=colorEstado%>"><%=m.getEstado()%></span></td>
                <td><%=m.getFechaRegistrada()%></td>
                <td><%=infraestructura%></td>
                <td>
                  <% if (m.getIdIncidencia() > 0) { %>
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%=m.getIdIncidencia()%>">Ver incidencia</a>
                  <% } else { %>
                  -
                  <% } %>
                </td>
                <td class="text-end pe-4">
                  <a class="btn btn-sm btn-outline-secondary" href="<%=request.getContextPath()%>/MantenimientoServlet?action=ver&id=<%=m.getIdMantenimiento()%>">Ver</a>
                  <% if (!m.getEstado().equals("Finalizado")) { %>
                  <a class="btn btn-sm btn-outline-primary" href="<%=request.getContextPath()%>/MantenimientoServlet?action=editar&id=<%=m.getIdMantenimiento()%>">Editar</a>
                  <% } %>
                  <% if (m.getEstado().equals("Pendiente")) { %>
                  <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#borrar<%=m.getIdMantenimiento()%>">Eliminar</button>
                  <% } %>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<% for (Mantenimiento m : lista) {
     if (m.getEstado().equals("Pendiente")) {
%>
<div class="modal fade" id="borrar<%=m.getIdMantenimiento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fw-bold">Eliminar mantenimiento</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        ¿Estás seguro de que quieres eliminar <b>ID<%=m.getIdMantenimiento()%> - <%=m.getNombre()%></b>?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/MantenimientoServlet?action=borrar&id=<%=m.getIdMantenimiento()%>" class="btn btn-outline-danger">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<%   }
   } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>