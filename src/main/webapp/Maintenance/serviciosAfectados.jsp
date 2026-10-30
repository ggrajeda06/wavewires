<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
  String error = (String) request.getAttribute("error");
  String landingVal = request.getParameter("idLandingStation") == null ? "0" : request.getParameter("idLandingStation");
  String segmentoVal = request.getParameter("idSegmento") == null ? "0" : request.getParameter("idSegmento");
  boolean consultado = error == null && (!landingVal.equals("0") || !segmentoVal.equals("0"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Servicios afectados</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>
  <main class="col p-4 bg-light">
    <h3 class="fw-bold mb-1">Servicios afectados</h3>
    <p class="text-muted mb-4">Antes de programar un mantenimiento, consulta qué servicios usan la infraestructura.</p>

    <% if (error != null) { %>
    <div class="alert alert-danger"><%=error%></div>
    <% } %>

    <form method="GET" action="<%=request.getContextPath()%>/MantenimientoServlet" class="card shadow-sm p-3 mb-3">
      <input type="hidden" name="action" value="servicios">
      <div class="row g-2 align-items-end">
        <div class="col-md-5">
          <label class="form-label small fw-semibold">Landing</label>
          <select class="form-select" name="idLandingStation">
            <option value="0">-- Ninguna --</option>
            <% for (LandingStation ls : listaLandings) { %>
            <option value="<%=ls.getIdLandingStation()%>" <%=landingVal.equals(String.valueOf(ls.getIdLandingStation())) ? "selected" : ""%>>
              <%=ls.getNombre()%> (<%=ls.getCiudad()%>, <%=ls.getPais()%>)
            </option>
            <% } %>
          </select>
        </div>
        <div class="col-md-5">
          <label class="form-label small fw-semibold">o Segmento</label>
          <select class="form-select" name="idSegmento">
            <option value="0">-- Ninguno --</option>
            <% for (Segmento s : listaSegmentos) { %>
            <option value="<%=s.getIdSegmento()%>" <%=segmentoVal.equals(String.valueOf(s.getIdSegmento())) ? "selected" : ""%>>
              SEG-<%=String.format("%03d", s.getIdSegmento())%> (<%=s.getNombreOrigen()%> - <%=s.getNombreDestino()%>)
            </option>
            <% } %>
          </select>
        </div>
        <div class="col-md-2">
          <button type="submit" class="btn btn-dark w-100">Consultar</button>
        </div>
      </div>
    </form>

    <% if (consultado) { %>
    <div class="card shadow-sm">
      <div class="card-body p-0">
        <table class="table table-hover align-middle mb-0">
          <thead class="table-light border-bottom">
            <tr>
              <th class="ps-4">Servicio</th>
              <th>Segmento</th>
              <th>Capacidad</th>
              <th>Cliente</th>
              <th>Caduca</th>
            </tr>
          </thead>
          <tbody>
            <% if (listaServicios.isEmpty()) { %>
            <tr>
              <td colspan="5" class="text-center text-muted py-4">Ningún servicio activo usa esta infraestructura.</td>
            </tr>
            <% } %>
            <% for (Servicio sv : listaServicios) { %>
            <tr>
              <td class="ps-4 fw-bold"><%=sv.getIdentificador()%></td>
              <td>SEG-<%=String.format("%03d", sv.getIdSegmento())%></td>
              <td><%=sv.getCapacidad().stripTrailingZeros().toPlainString()%> Gbps</td>
              <td><%=sv.getRazonSocial()%></td>
              <td><%=sv.getFechaCaducidad()%></td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
    <a class="btn btn-outline-dark mt-3" href="<%=request.getContextPath()%>/MantenimientoServlet?action=formCrear&idLandingStation=<%=landingVal%>&idSegmento=<%=segmentoVal%>">
      Programar mantenimiento sobre esta infraestructura
    </a>
    <% } %>
  </main>
</div>
</body>
</html>
