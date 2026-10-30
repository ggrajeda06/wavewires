<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<jsp:useBean id="mantenimiento" type="com.oceanlink.beans.Mantenimiento" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
  String infraestructura = (String) request.getAttribute("infraestructura");
  Incidencia incidencia = (Incidencia) request.getAttribute("incidencia");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Detalle de mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/MantenimientoServlet" class="btn btn-outline-secondary btn-sm me-3">Volver</a>
      <h3 class="fw-bold m-0">ID<%=mantenimiento.getIdMantenimiento()%> - <%=mantenimiento.getNombre()%></h3>
    </div>

    <div class="card shadow-sm p-4 mb-3">
      <div class="row g-4">
        <div class="col-md-7">
          <div class="row g-3">
            <div class="col-6">
              <small class="text-muted d-block">Estado</small>
              <span class="fw-semibold"><%=mantenimiento.getEstado()%></span>
            </div>
            <div class="col-6">
              <small class="text-muted d-block">Tipo de mantenimiento</small>
              <span class="fw-semibold"><%=mantenimiento.getTipo()%></span>
            </div>
            <div class="col-6">
              <small class="text-muted d-block">Fecha programada</small>
              <span class="fw-semibold"><%=mantenimiento.getFechaRegistrada()%></span>
            </div>
            <div class="col-6">
              <small class="text-muted d-block">Duración estimada</small>
              <span class="fw-semibold"><%=mantenimiento.getDuracionHoras()%> horas</span>
            </div>
            <div class="col-12">
              <small class="text-muted d-block">Infraestructura</small>
              <span class="fw-semibold"><%=infraestructura%></span>
            </div>
            <div class="col-12">
              <small class="text-muted d-block">Incidencia relacionada</small>
              <% if (incidencia == null) { %>
              <span class="fw-semibold">-</span>
              <% } else { %>
              <a class="fw-semibold" href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%=incidencia.getIdIncidencia()%>"><%=incidencia.getIdentificador()%></a>
              <span class="text-muted">(<%=incidencia.getEstado()%>)</span>
              <% } %>
            </div>
            <div class="col-12">
              <small class="text-muted d-block">Descripción</small>
              <div class="border rounded px-3 py-2 bg-light" style="white-space: pre-line;"><%=mantenimiento.getDescripcion()%></div>
            </div>
          </div>
        </div>
        <div class="col-md-5">
          <small class="text-muted d-block text-uppercase">Actividades realizadas</small>
          <div class="border rounded px-3 py-2 bg-light" style="min-height: 150px; white-space: pre-line;"><%=mantenimiento.getActividadesRealizadas() == null ? "Aún no se registran actividades." : mantenimiento.getActividadesRealizadas()%></div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm p-3 mb-3">
      <h6 class="fw-bold">Servicios que podrían resultar afectados</h6>
      <% if (listaServicios.isEmpty()) { %>
      <p class="text-muted mb-0">Ningún servicio activo usa esta infraestructura.</p>
      <% } else { %>
      <table class="table table-sm mb-0">
        <thead>
          <tr>
            <th>Servicio</th>
            <th>Segmento</th>
            <th>Capacidad</th>
            <th>Cliente</th>
          </tr>
        </thead>
        <tbody>
          <% for (Servicio sv : listaServicios) { %>
          <tr>
            <td><%=sv.getIdentificador()%></td>
            <td>SEG-<%=String.format("%03d", sv.getIdSegmento())%></td>
            <td><%=sv.getCapacidad().stripTrailingZeros().toPlainString()%> Gbps</td>
            <td><%=sv.getRazonSocial()%></td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <% if (!mantenimiento.getEstado().equals("Finalizado")) { %>
    <a href="<%=request.getContextPath()%>/MantenimientoServlet?action=editar&id=<%=mantenimiento.getIdMantenimiento()%>" class="btn btn-outline-dark">Editar</a>
    <% } %>
  </main>
</div>
</body>
</html>