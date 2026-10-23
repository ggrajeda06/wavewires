<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
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
      <h4 class="mb-0">Segmentos</h4>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistrarSegmento">+ Nuevo</button>
    </div>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar por estación o código...">
      <select class="form-select w-auto">
        <option selected>Ordenar</option>
        <option>Origen (A - Z)</option>
        <option>Destino (A - Z)</option>
        <option>Más capacidad total</option>
        <option>Más capacidad disponible</option>
      </select>
    </div>

    <% if ("ruta".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger">El origen y el destino no pueden ser la misma landing station.</div>
    <% } %>
    <% if ("enUso".equals(request.getParameter("error"))) { %>
      <div class="alert alert-danger">No se puede eliminar el segmento porque tiene solicitudes o servicios asociados.</div>
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
               String colorBadge = "bg-secondary";
               if ("Operativo".equals(s.getEstado())) {
                   colorBadge = "bg-success";
               } else if ("Degradado".equals(s.getEstado())) {
                   colorBadge = "bg-warning text-dark";
               } else if ("Mantenimiento".equals(s.getEstado())) {
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
              <button type="button" class="btn btn-sm btn-outline-secondary"
                      onclick="abrirEditar('<%=s.getIdSegmento()%>', '<%=s.getIdOrigen()%>', '<%=s.getIdDestino()%>', '<%=s.getCapacidadTotal().toPlainString()%>', '<%=s.getEstado()%>')">
                Editar
              </button>
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
              <option value="Operativo">Operativo</option>
              <option value="Degradado">Degradado</option>
              <option value="Mantenimiento">Mantenimiento</option>
              <option value="Fuera de servicio">Fuera de servicio</option>
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

<div class="modal fade" id="modalEditarSegmento" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Segmento</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/SegmentoServlet?action=actualizar">
        <input type="hidden" name="idSegmento" id="editId">

        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Origen</label>
            <select name="idOrigen" id="editOrigen" class="form-select" required>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>"><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Destino</label>
            <select name="idDestino" id="editDestino" class="form-select" required>
              <% for (LandingStation ls : listaLandings) { %>
                <option value="<%=ls.getIdLandingStation()%>"><%=ls.getNombre()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Capacidad total (Gbps)</label>
            <input type="number" name="capacidadTotal" id="editCapacidad" class="form-control" min="1" step="0.01" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" id="editEstado" class="form-select" required>
              <option value="Operativo">Operativo</option>
              <option value="Degradado">Degradado</option>
              <option value="Mantenimiento">Mantenimiento</option>
              <option value="Fuera de servicio">Fuera de servicio</option>
            </select>
          </div>
        </div>

        <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
          <a id="btnEliminarModal" href="#" class="btn btn-outline-danger px-3"
             onclick="return confirm('¿Estás seguro de que deseas eliminar este segmento?');">
            Eliminar
          </a>
          <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-primary px-3">Guardar cambios</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function abrirEditar(id, idOrigen, idDestino, capacidad, estado) {
  document.getElementById('editId').value = id;
  document.getElementById('editOrigen').value = idOrigen;
  document.getElementById('editDestino').value = idDestino;
  document.getElementById('editCapacidad').value = capacidad;
  document.getElementById('editEstado').value = estado;
  document.getElementById('btnEliminarModal').href = '<%=request.getContextPath()%>/SegmentoServlet?action=borrar&id=' + id;

  let modal = new bootstrap.Modal(document.getElementById('modalEditarSegmento'));
  modal.show();
}
</script>
</body>
</html>
