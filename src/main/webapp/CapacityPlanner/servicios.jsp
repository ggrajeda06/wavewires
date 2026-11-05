<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<%
  // segmentos que ahora estan en mantenimiento: sus servicios se muestran "En mantenimiento"
  ArrayList<Integer> segmentosEnMantenimiento = new ArrayList<>();
  for (Segmento s : listaSegmentos) {
    if (s.getEstado().equals("En mantenimiento")) {
      segmentosEnMantenimiento.add(s.getIdSegmento());
    }
  }
  SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Servicios</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">
    <div class="mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Servicios</h2>
      <small class="text-muted">Enlaces contratados, su vigencia y su estado en la red</small>
    </div>

    <% if ("enUso".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">No se puede eliminar el servicio porque está registrado en una incidencia.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th>Servicio</th>
            <th>Cliente</th>
            <th>Segmento</th>
            <th>Capacidad</th>
            <th>Caducidad</th>
            <th>Vigencia</th>
            <th>Estado</th>
            <th class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaServicios.isEmpty()) { %>
          <tr>
            <td colspan="8" class="text-center text-muted py-4">No se encontraron servicios registrados.</td>
          </tr>
          <% } %>
          <% for (Servicio sv : listaServicios) {
               // la vigencia sale solo de la fecha de caducidad (no se guarda ni se edita)
               boolean vigente = sv.isVigente();

               // el estado mostrado: En mantenimiento si su segmento lo esta, si no el guardado (Funcionando / Caído)
               String estadoMostrar = sv.getEstado();
               if (segmentosEnMantenimiento.contains(sv.getIdSegmento())) {
                 estadoMostrar = "En mantenimiento";
               }
               String colorEstado = "bg-success-subtle text-success border border-success-subtle";
               if (estadoMostrar.equals("Caído")) {
                 colorEstado = "bg-danger-subtle text-danger border border-danger-subtle";
               } else if (estadoMostrar.equals("En mantenimiento")) {
                 colorEstado = "bg-info-subtle text-info-emphasis border border-info-subtle";
               }
          %>
          <tr>
            <td class="fw-medium"><%=sv.getIdentificador()%></td>
            <td><%=sv.getRazonSocial()%></td>
            <td>SEG-<%=String.format("%03d", sv.getIdSegmento())%></td>
            <td><%=sv.getCapacidad().stripTrailingZeros().toPlainString()%> Gbps</td>
            <td><%=sdf.format(sv.getFechaCaducidad())%></td>
            <td>
              <% if (vigente) { %>
              <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Vigente</span>
              <% } else { %>
              <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Vencido</span>
              <% } %>
            </td>
            <td>
              <% if (vigente) { %>
              <span class="badge <%=colorEstado%>"><%=estadoMostrar%></span>
              <% } else { %>
              <span class="text-muted">-</span>
              <% } %>
            </td>
            <td class="text-center">
              <button type="button" class="btn btn-outline-danger btn-sm px-3" data-bs-toggle="modal" data-bs-target="#borrar<%=sv.getIdServicio()%>">
                <i class="bi bi-trash"></i> Eliminar
              </button>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<% for (Servicio sv : listaServicios) { %>
<div class="modal fade" id="borrar<%=sv.getIdServicio()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar servicio</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar <b><%=sv.getIdentificador()%></b> de <%=sv.getRazonSocial()%>?
        Su capacidad vuelve a quedar libre en el segmento.
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-primary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/ServicioServlet?action=borrar&id=<%=sv.getIdServicio()%>" class="btn btn-outline-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>