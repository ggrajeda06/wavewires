<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<%
  String error = request.getParameter("error");
  String[] estados = {"Operativo", "Degradado", "En mantenimiento", "Fuera de servicio"};
%>
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
      <h4 class="mb-0">Segmentos</h4>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistrarSegmento">+ Nuevo</button>
    </div>

    <% if ("ruta".equals(error)) { %>
      <div class="alert alert-danger">El origen y el destino no pueden ser la misma landing station.</div>
    <% } else if ("landing".equals(error)) { %>
      <div class="alert alert-danger">Elige una landing de origen y una de destino.</div>
    <% } else if ("capacidad".equals(error)) { %>
      <div class="alert alert-danger">La capacidad total debe ser un número mayor que 0.</div>
    <% } else if ("capacidadMenor".equals(error)) { %>
      <div class="alert alert-danger">La capacidad total no puede ser menor que la capacidad usada más la reservada.</div>
    <% } else if ("estado".equals(error)) { %>
      <div class="alert alert-danger">Elige un estado válido.</div>
    <% } else if ("enUso".equals(error)) { %>
      <div class="alert alert-danger">No se puede eliminar el segmento porque tiene solicitudes, servicios, incidencias o mantenimientos asociados.</div>
    <% } %>

    <div class="card shadow-sm border-0">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Origen</th>
            <th>Destino</th>
            <th>Cap. usada</th>
            <th>Cap. reservada</th>
            <th>Cap. total</th>
            <th>Estado</th>
            <th class="text-center">Acción</th>
          </tr>
        </thead>
        <tbody>
          <% for (Segmento s : listaSegmentos) {
               String colorBadge = "bg-danger";
               if ("Operativo".equals(s.getEstado())) {
                   colorBadge = "bg-success";
               } else if ("Degradado".equals(s.getEstado())) {
                   colorBadge = "bg-warning text-dark";
               } else if ("En mantenimiento".equals(s.getEstado())) {
                   colorBadge = "bg-info text-dark";
               }
          %>
          <tr>
            <td class="fw-bold">SEG-<%=String.format("%03d", s.getIdSegmento())%></td>
            <td><%=s.getNombreOrigen()%></td>
            <td><%=s.getNombreDestino()%></td>
            <td><%=s.getCapacidadUsada().stripTrailingZeros().toPlainString()%> Gbps</td>
            <td><%=s.getCapacidadReservada().stripTrailingZeros().toPlainString()%> Gbps</td>
            <td><%=s.getCapacidadTotal().stripTrailingZeros().toPlainString()%> Gbps</td>
            <td><span class="badge <%=colorBadge%>"><%=s.getEstado()%></span></td>
            <td class="text-center">
              <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#editar<%=s.getIdSegmento()%>">Editar</button>
              <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#borrar<%=s.getIdSegmento()%>">Eliminar</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </main>
</div>

<div class="modal fade" id="modalRegistrarSegmento" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Registrar Segmento</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SegmentoServlet?action=crear">
        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Origen</label>
            <select name="idOrigen" class="form-select" required>
              <option value="" selected disabled>Seleccionar origen</option>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>"><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Destino</label>
            <select name="idDestino" class="form-select" required>
              <option value="" selected disabled>Seleccionar destino</option>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>"><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad total (Gbps)</label>
            <input type="number" name="capacidadTotal" class="form-control" min="1" step="0.01" placeholder="Ingresar capacidad" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select" required>
              <% for (String e : estados) { %>
              <option value="<%=e%>"><%=e%></option>
              <% } %>
            </select>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary px-3">Guardar segmento</button>
        </div>
      </form>

    </div>
  </div>
</div>

<% for (Segmento s : listaSegmentos) { %>
<div class="modal fade" id="editar<%=s.getIdSegmento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Segmento SEG-<%=String.format("%03d", s.getIdSegmento())%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SegmentoServlet?action=actualizar">
        <input type="hidden" name="idSegmento" value="<%=s.getIdSegmento()%>">

        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Origen</label>
            <select name="idOrigen" class="form-select" required>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>" <%=ls.getIdLandingStation() == s.getIdOrigen() ? "selected" : ""%>><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Destino</label>
            <select name="idDestino" class="form-select" required>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>" <%=ls.getIdLandingStation() == s.getIdDestino() ? "selected" : ""%>><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad total (Gbps)</label>
            <input type="number" name="capacidadTotal" class="form-control" min="1" step="0.01" value="<%=s.getCapacidadTotal().toPlainString()%>" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select" required>
              <% for (String e : estados) { %>
              <option value="<%=e%>" <%=e.equals(s.getEstado()) ? "selected" : ""%>><%=e%></option>
              <% } %>
            </select>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary px-3">Guardar cambios</button>
        </div>
      </form>

    </div>
  </div>
</div>

<div class="modal fade" id="borrar<%=s.getIdSegmento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar segmento</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar el segmento <b>SEG-<%=String.format("%03d", s.getIdSegmento())%></b>
        (<%=s.getNombreOrigen()%> - <%=s.getNombreDestino()%>)?
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-primary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/SegmentoServlet?action=borrar&id=<%=s.getIdSegmento()%>" class="btn btn-outline-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>