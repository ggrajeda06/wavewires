<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.Servicio" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaServiciosCaducados" type="java.util.ArrayList<com.oceanlink.beans.Servicio>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Historial de segmentos</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <jsp:include page="sidebar.jsp"/>

  <main class="col p-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Historial de segmentos</h2>
        <small class="text-muted">Consulta de tramos y registro histórico de enlaces finalizados</small>
      </div>
    </div>

    <div class="card shadow-sm border-0 p-3">

      <!-- Buscador -->
      <form method="GET" action="<%=request.getContextPath()%>/HistorialServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar segmento o ruta..."
                 value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
        </div>
      </form>

      <!-- Tabla de segmentos -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 30%;">Segmento</th>
            <th style="width: 45%;">Ruta</th>
            <th style="width: 25%;" class="text-center">Servicios caducados</th>
          </tr>
          </thead>
          <tbody>
          <% if (listaSegmentos.isEmpty()) { %>
          <tr>
            <td colspan="3" class="text-center text-muted py-4">No se encontraron segmentos registrados.</td>
          </tr>
          <% } else { %>
            <% for (Segmento s : listaSegmentos) {
                 String ruta = s.getNombreOrigen() + " - " + s.getNombreDestino();
                 int cantCaducados = 0;
                 if (listaServiciosCaducados != null) {
                   for (Servicio sv : listaServiciosCaducados) {
                     if (sv.getIdSegmento() == s.getIdSegmento()) {
                       cantCaducados++;
                     }
                   }
                 }
                 String targetModal = (cantCaducados > 0) ? "#modalCaducados" + s.getIdSegmento() : "#modalSinCaducados";
            %>
            <tr>
              <td class="fw-medium">Segmento <%=s.getIdSegmento()%></td>
              <td><%=ruta%></td>
              <td class="text-center">
                <button type="button" class="btn btn-outline-dark btn-sm px-3" data-bs-toggle="modal" data-bs-target="<%=targetModal%>">
                  Ver más
                </button>
              </td>
            </tr>
            <% } %>
          <% } %>
          </tbody>
        </table>
      </div>

      <!-- Paginacion -->
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button type="button" class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<!-- Modales con el detalle de servicios caducados por cada segmento -->
<%
   if (listaSegmentos != null && listaServiciosCaducados != null) {
     for (Segmento s : listaSegmentos) {
       ArrayList<Servicio> caducadosDelSegmento = new ArrayList<>();
       for (Servicio sv : listaServiciosCaducados) {
         if (sv.getIdSegmento() == s.getIdSegmento()) {
           caducadosDelSegmento.add(sv);
         }
       }
       if (!caducadosDelSegmento.isEmpty()) {
%>
<div class="modal fade" id="modalCaducados<%=s.getIdSegmento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0 text-dark">Servicios Caducados - Segmento <%=s.getIdSegmento()%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body p-4">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
              <th style="width: 20%;">Servicios</th>
              <th style="width: 25%;">Cliente</th>
              <th style="width: 20%;">Segmento</th>
              <th style="width: 17%;">Capacidad</th>
              <th style="width: 18%;" class="text-center">Acción</th>
            </tr>
            </thead>
            <tbody>
            <% for (Servicio sv : caducadosDelSegmento) {
                 String nombreServicio = (sv.getIdentificador() != null && !sv.getIdentificador().trim().isEmpty())
                                         ? sv.getIdentificador() : "Servicio " + sv.getIdServicio();
                 int cap = sv.getCapacidad() != null ? sv.getCapacidad().intValue() : 0;
            %>
            <tr>
              <td class="fw-medium"><%=nombreServicio%></td>
              <td><%=sv.getRazonSocial() != null ? sv.getRazonSocial() : "-"%></td>
              <td>Segmento <%=sv.getIdSegmento()%></td>
              <td class="text-secondary fw-semibold"><%=cap%> Gbps</td>
              <td class="text-center">
                <a href="<%=request.getContextPath()%>/HistorialServlet?action=borrar&id=<%=sv.getIdServicio()%>"
                   class="btn btn-outline-danger btn-sm px-3 text-nowrap"
                   onclick="return confirm('¿Estás seguro de que deseas eliminar este servicio del historial?');">
                  <i class="bi bi-trash me-1"></i> Eliminar
                </a>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <div class="modal-footer d-flex justify-content-end border-top py-3 px-4 bg-light-subtle">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">
          Cerrar
        </button>
      </div>

    </div>
  </div>
</div>
<%
       }
     }
   }
%>

<!-- Modal para cuando no hay registros finalizados -->
<div class="modal fade" id="modalSinCaducados" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow text-center p-4">
      <div class="modal-body">
        <i class="bi bi-check-circle text-success fs-1 mb-2 d-block"></i>
        <h6 class="fw-bold mb-2">Servicios Caducados</h6>
        <p class="text-muted small mb-3">No existen servicios caducados ni de baja registrados en este segmento.</p>
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>