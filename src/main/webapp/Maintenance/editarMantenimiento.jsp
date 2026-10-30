<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<jsp:useBean id="mantenimiento" type="com.oceanlink.beans.Mantenimiento" scope="request" />
<jsp:useBean id="estadosPermitidos" type="java.util.ArrayList<java.lang.String>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaIncidencias" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<%
  String error = (String) request.getAttribute("error");
  String infraestructura = (String) request.getAttribute("infraestructura");
  boolean pendiente = mantenimiento.getEstado().equals("Pendiente");

  String nombreVal = request.getParameter("nombreId") != null ? request.getParameter("nombreId") : mantenimiento.getNombre();
  String descripcionVal = request.getParameter("descripcion") != null ? request.getParameter("descripcion") : mantenimiento.getDescripcion();
  String fechaVal = request.getParameter("fecha") != null ? request.getParameter("fecha") : mantenimiento.getFechaRegistrada().toString();
  String duracionVal = request.getParameter("duracion") != null ? request.getParameter("duracion") : String.valueOf(mantenimiento.getDuracionHoras());
  String estadoVal = request.getParameter("estado") != null ? request.getParameter("estado") : mantenimiento.getEstado();
  String actividadesVal = request.getParameter("actividades") != null ? request.getParameter("actividades")
          : (mantenimiento.getActividadesRealizadas() == null ? "" : mantenimiento.getActividadesRealizadas());
  String tipoVal = request.getParameter("tipoMantenimiento") != null ? request.getParameter("tipoMantenimiento") : mantenimiento.getTipo();
  String landingVal = request.getParameter("idLandingStation") != null ? request.getParameter("idLandingStation") : String.valueOf(mantenimiento.getIdLandingStation());
  String segmentoVal = request.getParameter("idSegmento") != null ? request.getParameter("idSegmento") : String.valueOf(mantenimiento.getIdSegmento());
  String incidenciaVal = request.getParameter("idIncidencia") != null ? request.getParameter("idIncidencia") : String.valueOf(mantenimiento.getIdIncidencia());
%>
<html lang="es">
<head>
  <title>OceanLink - Editar Mantenimiento</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>

  <main class="col p-4 bg-light">
    <div class="d-flex align-items-center mb-4">
      <a href="<%=request.getContextPath()%>/MantenimientoServlet?action=ver&id=<%=mantenimiento.getIdMantenimiento()%>" class="btn btn-outline-secondary me-3 btn-sm">
        Volver
      </a>
      <h3 class="fw-bold m-0">Editar mantenimiento</h3>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger"><%=error%></div>
    <% } %>

    <div class="card shadow-sm p-4">
      <form action="<%=request.getContextPath()%>/MantenimientoServlet?action=actualizar" method="POST">
        <input type="hidden" name="id" value="<%=mantenimiento.getIdMantenimiento()%>">
        <div class="row g-4">

          <div class="col-md-6">
            <div class="mb-3">
              <label for="nombreId" class="form-label fw-semibold">Name(ID)</label>
              <input type="text" class="form-control" id="nombreId" name="nombreId" maxlength="45" value="<%=nombreVal%>" required>
            </div>

            <div class="mb-3">
              <label for="descripcion" class="form-label fw-semibold">Descripción</label>
              <textarea class="form-control" id="descripcion" name="descripcion" rows="4" required><%=descripcionVal%></textarea>
            </div>

            <div class="mb-3">
              <label for="fecha" class="form-label fw-semibold">Fecha programada</label>
              <% if (pendiente) { %>
              <input type="date" class="form-control" id="fecha" name="fecha" value="<%=fechaVal%>" required>
              <% } else { %>
              <div class="form-control bg-light"><%=mantenimiento.getFechaRegistrada()%></div>
              <% } %>
            </div>

            <div class="mb-3">
              <label for="duracion" class="form-label fw-semibold">Duración estimada (horas)</label>
              <% if (pendiente) { %>
              <input type="number" class="form-control" id="duracion" name="duracion" min="1" value="<%=duracionVal%>" required>
              <% } else { %>
              <div class="form-control bg-light"><%=mantenimiento.getDuracionHoras()%> horas</div>
              <% } %>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label for="estado" class="form-label fw-semibold">Estado</label>
              <select class="form-select" id="estado" name="estado" required>
                <% for (String est : estadosPermitidos) { %>
                <option value="<%=est%>" <%=est.equals(estadoVal) ? "selected" : ""%>><%=est%></option>
                <% } %>
              </select>
            </div>

            <% if (pendiente) { %>
            <div class="mb-3">
              <label for="tipoMantenimiento" class="form-label fw-semibold">Tipo de mantenimiento</label>
              <select class="form-select" id="tipoMantenimiento" name="tipoMantenimiento" required>
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
            <div class="mb-3">
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
            <% } else { %>
            <div class="mb-3">
              <label class="form-label fw-semibold">Tipo de mantenimiento</label>
              <div class="form-control bg-light"><%=mantenimiento.getTipo()%></div>
            </div>

            <div class="mb-3">
              <label class="form-label fw-semibold">Infraestructura</label>
              <div class="form-control bg-light"><%=infraestructura%></div>
            </div>

            <% if (mantenimiento.getIdIncidencia() > 0) { %>
            <div class="mb-3">
              <label class="form-label fw-semibold">Incidencia relacionada</label>
              <div class="form-control bg-light">
                <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%=mantenimiento.getIdIncidencia()%>">Ver incidencia</a>
              </div>
            </div>
            <% } %>
            <% } %>
          </div>

          <div class="col-12">
            <div class="mb-3">
              <label for="actividades" class="form-label fw-semibold">Actividades realizadas (resultado)</label>
              <textarea class="form-control" id="actividades" name="actividades" rows="4" placeholder="Describa las actividades realizadas durante el mantenimiento..."><%=actividadesVal%></textarea>
            </div>
          </div>

        </div>

        <div class="d-flex justify-content-end mt-4">
          <button type="submit" class="btn btn-outline-dark px-4 py-2">Guardar registro</button>
        </div>
      </form>
    </div>
  </main>
</div>
</body>
</html>