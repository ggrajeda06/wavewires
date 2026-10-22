<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="landing" type="com.oceanlink.beans.LandingStation" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
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
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="mb-0">Información: <%=landing.getNombre()%></h4>
      <a href="<%=request.getContextPath()%>/LandingStationServlet" class="btn btn-sm btn-outline-secondary">×</a>
    </div>

    <% if (listaSegmentos.isEmpty()) { %>
    <p class="text-secondary">Esta landing station no tiene segmentos.</p>
    <% } else { %>
    <table class="table">
      <thead>
        <tr>
          <th>Tramo</th>
          <th>Destino</th>
          <th>Capacidad</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        <% for (Segmento s : listaSegmentos) {
             int idOtroExtremo = s.getIdDestino();
             if (s.getIdDestino() == landing.getIdLandingStation()) {
                 idOtroExtremo = s.getIdOrigen();
             }
             String nombreDestino = "";
             for (LandingStation ls : listaLandings) {
                 if (ls.getIdLandingStation() == idOtroExtremo) {
                     nombreDestino = ls.getNombre();
                 }
             }
             String colorEstado = "bg-danger";
             if ("Operativo".equals(s.getEstado())) {
                 colorEstado = "bg-success";
             } else if ("Fuera de servicio".equals(s.getEstado())) {
                 colorEstado = "bg-secondary";
             }
        %>
        <tr>
          <td>SEG-<%=String.format("%03d", s.getIdSegmento())%></td>
          <td><%=nombreDestino%></td>
          <td><%=s.getCapacidadTotal()%> Gbps</td>
          <td><span class="d-inline-block rounded-circle <%=colorEstado%>" style="width:8px;height:8px;"></span> <%=s.getEstado()%></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <% } %>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>