<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<%
    boolean esHistorial = "historial".equals(request.getAttribute("modo"));
    String accion = esHistorial ? "historial" : "lista";

    String estadoFiltro = request.getParameter("estado") == null ? "" : request.getParameter("estado");
    String severidadFiltro = request.getParameter("severidad") == null ? "" : request.getParameter("severidad");
    String segmentoFiltro = request.getParameter("idSegmento") == null ? "" : request.getParameter("idSegmento");
    String desdeFiltro = request.getParameter("desde") == null ? "" : request.getParameter("desde");
    String hastaFiltro = request.getParameter("hasta") == null ? "" : request.getParameter("hasta");

    String[] estados = {"Detectada", "En análisis", "Reparación programada", "En reparación", "Servicio restaurado", "Cerrada"};
    String[] severidades = {"Crítica", "Alta", "Media", "Baja"};

    int operativos = 0;
    int afectados = 0;
    for (Segmento s : listaSegmentos) {
        if (s.getEstado().equals("Operativo")) {
            operativos++;
        }
        if (s.getEstado().equals("Degradado") || s.getEstado().equals("Fuera de servicio")) {
            afectados++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Incidencias</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0"><%= esHistorial ? "Historial de incidencias" : "Incidencias activas" %></h3>
      <a class="btn btn-primary shadow-sm" href="<%=request.getContextPath()%>/IncidenciaServlet?action=formCrear">+ Registrar incidencia</a>
    </div>

    <% if ("noBorrable".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger">Solo se puede borrar una incidencia en estado Detectada y sin mantenimientos.</div>
    <% } %>

    <div class="row g-2 mb-3">
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Segmentos operativos</small>
          <div class="fs-4 fw-semibold"><%= operativos %> de <%= listaSegmentos.size() %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Segmentos afectados</small>
          <div class="fs-4 fw-semibold"><%= afectados %></div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted"><%= esHistorial ? "Incidencias encontradas" : "Incidencias activas" %></small>
          <div class="fs-4 fw-semibold"><%= lista.size() %></div>
        </div>
      </div>
    </div>

    <form method="GET" action="<%=request.getContextPath()%>/IncidenciaServlet" class="card shadow-sm border-0 p-3 mb-3">
      <input type="hidden" name="action" value="<%= accion %>">
      <div class="row g-2 align-items-end">
        <div class="col-md-2">
          <label class="form-label small fw-semibold">Estado</label>
          <select class="form-select form-select-sm" name="estado">
            <option value="">Todos</option>
            <% for (String e : estados) {
                 if (!esHistorial && e.equals("Cerrada")) {
                     continue;
                 }
            %>
            <option value="<%= e %>" <%= e.equals(estadoFiltro) ? "selected" : "" %>><%= e %></option>
            <% } %>
          </select>
        </div>
        <div class="col-md-2">
          <label class="form-label small fw-semibold">Severidad</label>
          <select class="form-select form-select-sm" name="severidad">
            <option value="">Todas</option>
            <% for (String sev : severidades) { %>
            <option value="<%= sev %>" <%= sev.equals(severidadFiltro) ? "selected" : "" %>><%= sev %></option>
            <% } %>
          </select>
        </div>
        <div class="col-md-2">
          <label class="form-label small fw-semibold">Segmento</label>
          <select class="form-select form-select-sm" name="idSegmento">
            <option value="0">Todos</option>
            <% for (Segmento s : listaSegmentos) { %>
            <option value="<%= s.getIdSegmento() %>" <%= String.valueOf(s.getIdSegmento()).equals(segmentoFiltro) ? "selected" : "" %>>
              SEG-<%= String.format("%03d", s.getIdSegmento()) %> (<%= s.getNombreOrigen() %> - <%= s.getNombreDestino() %>)
            </option>
            <% } %>
          </select>
        </div>
        <div class="col-md-2">
          <label class="form-label small fw-semibold">Detectada desde</label>
          <input type="date" class="form-control form-control-sm" name="desde" value="<%= desdeFiltro %>">
        </div>
        <div class="col-md-2">
          <label class="form-label small fw-semibold">Hasta</label>
          <input type="date" class="form-control form-control-sm" name="hasta" value="<%= hastaFiltro %>">
        </div>
        <div class="col-md-2 d-flex gap-1">
          <button type="submit" class="btn btn-sm btn-dark">Filtrar</button>
          <a class="btn btn-sm btn-outline-secondary" href="<%=request.getContextPath()%>/IncidenciaServlet?action=<%= accion %>">Limpiar</a>
        </div>
      </div>
    </form>

    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">Incidencia</th>
                <th scope="col">Segmentos afectados</th>
                <th scope="col">Severidad</th>
                <th scope="col">Estado</th>
                <th scope="col">Servicios afectados</th>
                <th scope="col">Detectada</th>
                <% if (esHistorial) { %>
                <th scope="col">Cerrada</th>
                <% } %>
                <th scope="col" class="text-end pe-4">Acción</th>
              </tr>
            </thead>
            <tbody>
              <% if (lista.isEmpty()) { %>
              <tr>
                <td colspan="8" class="text-center text-muted py-4">No hay incidencias con esos filtros.</td>
              </tr>
              <% } %>
              <% for (Incidencia inc : lista) {
                   String segmentosTexto = "";
                   for (Integer idSeg : inc.getIdsSegmentos()) {
                       if (!segmentosTexto.isEmpty()) {
                           segmentosTexto = segmentosTexto + ", ";
                       }
                       segmentosTexto = segmentosTexto + "SEG-" + String.format("%03d", idSeg);
                   }

                   String colorEstado = "bg-secondary";
                   if (inc.getEstado().equals("Detectada")) {
                       colorEstado = "bg-danger";
                   } else if (inc.getEstado().equals("En análisis")) {
                       colorEstado = "bg-warning text-dark";
                   } else if (inc.getEstado().equals("Reparación programada")) {
                       colorEstado = "bg-info text-dark";
                   } else if (inc.getEstado().equals("En reparación")) {
                       colorEstado = "bg-primary";
                   } else if (inc.getEstado().equals("Servicio restaurado")) {
                       colorEstado = "bg-success";
                   }

                   String colorSeveridad = "text-success fw-bold";
                   if (inc.getSeveridad().equals("Crítica") || inc.getSeveridad().equals("Alta")) {
                       colorSeveridad = "text-danger fw-bold";
                   } else if (inc.getSeveridad().equals("Media")) {
                       colorSeveridad = "text-warning fw-bold";
                   }
              %>
              <tr>
                <td class="ps-4">
                  <a class="fw-bold text-decoration-none" href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%= inc.getIdIncidencia() %>"><%= inc.getIdentificador() %></a>
                </td>
                <td><%= segmentosTexto %></td>
                <td><span class="<%= colorSeveridad %>"><%= inc.getSeveridad() %></span></td>
                <td><span class="badge rounded-pill px-3 py-2 <%= colorEstado %>"><%= inc.getEstado() %></span></td>
                <td><%= inc.getIdsServicios().size() %></td>
                <td><%= inc.getFechaRegistro() %></td>
                <% if (esHistorial) { %>
                <td><%= inc.getFechaCierre() == null ? "-" : inc.getFechaCierre().toString() %></td>
                <% } %>
                <td class="text-end pe-4">
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=ver&id=<%= inc.getIdIncidencia() %>" class="btn btn-sm btn-outline-secondary">Ver</a>
                  <% if (!inc.getEstado().equals("Cerrada")) { %>
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=editar&id=<%= inc.getIdIncidencia() %>" class="btn btn-sm btn-outline-primary">Editar</a>
                  <% } %>
                  <% if (inc.getEstado().equals("Detectada")) { %>
                  <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#borrar<%= inc.getIdIncidencia() %>">Borrar</button>
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

<% for (Incidencia inc : lista) {
     if (inc.getEstado().equals("Detectada")) {
%>
<div class="modal fade" id="borrar<%= inc.getIdIncidencia() %>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fw-bold">Borrar incidencia</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        ¿Estás seguro de que quieres borrar la incidencia <b><%= inc.getIdentificador() %></b>? También se borran sus segmentos y servicios afectados.
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/IncidenciaServlet?action=borrar&id=<%= inc.getIdIncidencia() %>" class="btn btn-outline-danger">Sí, borrar</a>
      </div>
    </div>
  </div>
</div>
<%   }
   } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>