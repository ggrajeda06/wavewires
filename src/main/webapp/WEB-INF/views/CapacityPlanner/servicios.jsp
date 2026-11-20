<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.util.Html" %>
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
%>
<%@ page import="com.oceanlink.util.Seguridad" %>
<%
  // solo el rol duenio ve los botones de crear, editar y borrar; el Administrador solo consulta
  boolean gestiona = Seguridad.puedeGestionar(request, Seguridad.PLANIFICADOR);
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Servicios Activos</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">
    <div class="mb-4">
      <h2 class="h3 fw-bold text-dark m-0">Servicios Activos</h2>
      <small class="text-muted">Monitoreo de enlaces y capacidad en producción</small>
    </div>

    <% if ("enUso".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">No se puede eliminar el servicio porque está registrado en una incidencia.</div>
    <% } %>

    <div class="card shadow-sm border-0 p-3">

      <%-- Buscador de servicios --%>
      <form method="GET" action="<%=request.getContextPath()%>/ServicioServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar servicio, cliente o segmento..."
                 value="<%=Html.esc(request.getParameter("buscar"))%>">
        </div>
      </form>

      <%-- Tabla de servicios --%>
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 16%;">Servicios</th>
            <th style="width: 22%;">Cliente</th>
            <th style="width: 14%;">Segmento</th>
            <th style="width: 12%;">Capacidad</th>
            <th style="width: 15%;">Caducidad del Servicio</th>
            <th style="width: 13%;">Estado</th>
            <th style="width: 8%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaServicios.isEmpty()) { %>
          <tr>
            <td colspan="7" class="text-center text-muted py-4">No se encontraron servicios activos registrados.</td>
          </tr>
          <% } else { %>
            <%
               SimpleDateFormat sdf = new SimpleDateFormat("dd / MM / yyyy");
               for (Servicio sv : listaServicios) {
                 String nombreServicio = (sv.getIdentificador() != null && !sv.getIdentificador().trim().isEmpty())
                                         ? sv.getIdentificador() : "Servicio " + sv.getIdServicio();
                 String nombreSegmento = sv.getIdSegmento() > 0 ? "Segmento " + sv.getIdSegmento() : "No asignado";
                 String fechaCaducidadStr = sv.getFechaCaducidad() != null ? sdf.format(sv.getFechaCaducidad()) : "-";
                 // capacidad sin decimales de sobra: 120 en vez de 120.00, pero 12.5 se mantiene
                 String capGbps = sv.getCapacidad() != null ? sv.getCapacidad().stripTrailingZeros().toPlainString() : "0";

                 // estado en la red: En mantenimiento si su segmento lo esta, si no el guardado (Funcionando / Caído)
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
              <td class="fw-medium"><%=nombreServicio%></td>
              <td><%=sv.getRazonSocial() != null ? sv.getRazonSocial() : "-"%></td>
              <td><%=nombreSegmento%></td>
              <td><%=capGbps%> Gbps</td>
              <td><%=fechaCaducidadStr%></td>
              <td><span class="badge <%=colorEstado%>"><%=estadoMostrar%></span></td>
              <td class="text-center">
                <% if (gestiona) { %>
                <button type="button" class="btn btn-outline-danger btn-sm px-3"
                        data-bs-toggle="modal" data-bs-target="#borrarServicio<%=sv.getIdServicio()%>">
                  <i class="bi bi-trash"></i> Eliminar
                </button>
                <% } else { %>
                <span class="text-muted small">Solo consulta</span>
                <% } %>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>

      <%-- Paginacion --%>
      <jsp:include page="paginacion.jsp"><jsp:param name="servlet" value="ServicioServlet"/></jsp:include>

    </div>
  </main>
</div>

<%-- Un modal de confirmacion por servicio (sin JavaScript propio) --%>
<% if (gestiona) {
     for (Servicio sv : listaServicios) {
       String nombreServicio = (sv.getIdentificador() != null && !sv.getIdentificador().trim().isEmpty())
                               ? sv.getIdentificador() : "Servicio " + sv.getIdServicio();
%>
<div class="modal fade" id="borrarServicio<%=sv.getIdServicio()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar servicio</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar <b><%=Html.esc(nombreServicio)%></b>? Su capacidad se liberará del segmento.
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/ServicioServlet?action=borrar&id=<%=sv.getIdServicio()%>" class="btn btn-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<%   }
   } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>