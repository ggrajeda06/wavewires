<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaIncidencias" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<jsp:useBean id="listaServicios" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<%
  String error = (String) request.getAttribute("error");
  String nombreVal = request.getParameter("nombreId") == null ? "" : request.getParameter("nombreId");
  String descripcionVal = request.getParameter("descripcion") == null ? "" : request.getParameter("descripcion");
  String fechaVal = request.getParameter("fecha") == null ? "" : request.getParameter("fecha");
  String duracionVal = request.getParameter("duracion") == null ? "" : request.getParameter("duracion");
  String tipoVal = request.getParameter("tipoMantenimiento") == null ? "" : request.getParameter("tipoMantenimiento");
  String landingVal = request.getParameter("idLandingStation") == null ? "0" : request.getParameter("idLandingStation");
  String segmentoVal = request.getParameter("idSegmento") == null ? "0" : request.getParameter("idSegmento");
  String incidenciaVal = request.getParameter("idIncidencia") == null ? "0" : request.getParameter("idIncidencia");
  boolean infraElegida = !landingVal.equals("0") || !segmentoVal.equals("0");
%>
<html lang="es">
<head>
  <title>OceanLink - Registrar Mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>

  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/MantenimientoServlet" class="btn btn-outline-secondary me-3 btn-sm">
        Volver
      </a>
      <h3 class="fw-bold m-0">Registrar mantenimiento</h3>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger"><%=error%></div>
    <% } %>

    <div class="card shadow-sm p-4">
      <form action="<%=request.getContextPath()%>/MantenimientoServlet?action=crear" method="POST">
        <div class="row g-4">

          <div class="col-md-6">
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" maxlength="45" placeholder="Escribir nombre" value="<%=nombreVal%>" required>
            </div>

            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <textarea class="form-control" id="descripcion" name="descripcion" rows="4" placeholder="Describe el mantenimiento" required><%=descripcionVal%></textarea>
            </div>

            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha programada</label>
              <input type="date" class="form-control" id="fecha" name="fecha" value="<%=fechaVal%>" required>
            </div>

            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada (horas)</label>
              <input type="number" class="form-control" id="duracion" name="duracion" min="1" placeholder="Escribir duración en horas" value="<%=duracionVal%>" required>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label for="tipoMantenimiento" class="form-label fw-semibold">Tipo de mantenimiento</label>
              <select class="form-select" id="tipoMantenimiento" name="tipoMantenimiento" required>
                <option value="">Seleccionar tipo de mantenimiento</option>
                <option value="Preventivo" <%=tipoVal.equals("Preventivo") ? "selected" : ""%>>Preventivo</option>
                <option value="Correctivo" <%=tipoVal.equals("Correctivo") ? "selected" : ""%>>Correctivo</option>
              </select>
            </div>

            <p class="fw-semibold mb-1">Infraestructura (elige solo una)</p>
            <div class="mb-2">
              <label for="idLandingStation" class="form-label small">Landing</label>
              <select class="form-select" id="idLandingStation" name="idLandingStation">
                <option value="0">-- Ninguna --</option>
                <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>" <%=landingVal.equals(String.valueOf(ls.getIdLandingStation())) ? "selected" : ""%>>
                  <%=ls.getIdLandingStation()%> - <%=ls.getNombre()%> (<%=ls.getCiudad()%>, <%=ls.getPais()%>)
                </option>
                <% } %>
              </select>
            </div>
            <div class="mb-2">
              <label for="idSegmento" class="form-label small">Segmento</label>
              <select class="form-select" id="idSegmento" name="idSegmento">
                <option value="0">-- Ninguno --</option>
                <% for (Segmento s : listaSegmentos) { %>
                <option value="<%=s.getIdSegmento()%>" <%=segmentoVal.equals(String.valueOf(s.getIdSegmento())) ? "selected" : ""%>>
                  SEG-<%=String.format("%03d", s.getIdSegmento())%> (<%=s.getNombreOrigen()%> - <%=s.getNombreDestino()%>)
                </option>
                <% } %>
              </select>
            </div>
            <button type="submit" class="btn btn-sm btn-outline-secondary mb-3"
                    formaction="<%=request.getContextPath()%>/MantenimientoServlet" formmethod="get" formnovalidate
                    name="action" value="formCrear">
              Consultar servicios que podrían resultar afectados
            </button>

            <div class="mb-3">
              <label for="idIncidencia" class="form-label fw-semibold">Incidencia relacionada (solo correctivo)</label>
              <select class="form-select" id="idIncidencia" name="idIncidencia">
                <option value="0">-- Ninguna --</option>
                <% for (Incidencia inc : listaIncidencias) {
                     String segmentosTexto = "";
                     for (Integer idSeg : inc.getIdsSegmentos()) {
                         segmentosTexto = segmentosTexto + " SEG-" + String.format("%03d", idSeg);
                     }
                %>
                <option value="<%=inc.getIdIncidencia()%>" <%=incidenciaVal.equals(String.valueOf(inc.getIdIncidencia())) ? "selected" : ""%>>
                  <%=inc.getIdentificador()%> - <%=inc.getSeveridad()%> - <%=inc.getEstado()%> -<%=segmentosTexto%>
                </option>
                <% } %>
              </select>
            </div>
          </div>

        </div>

        <% if (infraElegida && error == null) { %>
        <div class="border rounded p-3 bg-light mt-2">
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
        <% } %>

        <div class="d-flex justify-content-end mt-4">
          <button type="submit" class="btn btn-outline-dark px-4 py-2">Guardar registro</button>
        </div>
      </form>
    </div>
  </main>
</div>
</body>
</html>