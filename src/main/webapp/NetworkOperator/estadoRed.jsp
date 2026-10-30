<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Segmento" %>
<%@ page import="com.oceanlink.beans.Incidencia" %>
<jsp:useBean id="listaSegmentos" type="java.util.ArrayList<com.oceanlink.beans.Segmento>" scope="request" />
<jsp:useBean id="listaActivas" type="java.util.ArrayList<com.oceanlink.beans.Incidencia>" scope="request" />
<%
    int operativos = 0;
    int degradados = 0;
    int fueraDeServicio = 0;
    int enMantenimiento = 0;
    for (Segmento s : listaSegmentos) {
        if (s.getEstado().equals("Operativo")) {
            operativos++;
        } else if (s.getEstado().equals("Degradado")) {
            degradados++;
        } else if (s.getEstado().equals("Fuera de servicio")) {
            fueraDeServicio++;
        } else {
            enMantenimiento++;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink - Estado de la red</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/NetworkOperator/sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <h3 class="fw-bold mb-4">Estado de la red</h3>

    <div class="row g-2 mb-3">
      <div class="col-md-3">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Operativos</small>
          <div class="fs-4 fw-semibold text-success"><%= operativos %></div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Degradados</small>
          <div class="fs-4 fw-semibold text-warning"><%= degradados %></div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">Fuera de servicio</small>
          <div class="fs-4 fw-semibold text-danger"><%= fueraDeServicio %></div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card p-3 shadow-sm border-0">
          <small class="text-muted">En mantenimiento</small>
          <div class="fs-4 fw-semibold text-primary"><%= enMantenimiento %></div>
        </div>
      </div>
    </div>

    <div class="card shadow-sm border-0">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th class="ps-4">Segmento</th>
                <th>Ruta</th>
                <th>Estado</th>
                <th>Total</th>
                <th>Usada</th>
                <th>Reservada</th>
                <th>Disponible</th>
                <th>Ocupación</th>
                <th>Incidencias activas</th>
              </tr>
            </thead>
            <tbody>
              <% for (Segmento s : listaSegmentos) {
                   double total = s.getCapacidadTotal().doubleValue();
                   double usada = s.getCapacidadUsada().doubleValue();
                   double reservada = s.getCapacidadReservada().doubleValue();
                   double disponible = total - usada - reservada;
                   double porcentaje = total > 0 ? (usada + reservada) * 100 / total : 0;

                   String nivel = "Normal";
                   String colorNivel = "bg-success";
                   if (porcentaje > 95) {
                       nivel = "Crítica";
                       colorNivel = "bg-danger";
                   } else if (porcentaje >= 80) {
                       nivel = "Alta";
                       colorNivel = "bg-warning text-dark";
                   }

                   String colorEstado = "bg-success";
                   if (s.getEstado().equals("Degradado")) {
                       colorEstado = "bg-warning text-dark";
                   } else if (s.getEstado().equals("Fuera de servicio")) {
                       colorEstado = "bg-danger";
                   } else if (s.getEstado().equals("En mantenimiento")) {
                       colorEstado = "bg-primary";
                   }

                   int incidenciasSegmento = 0;
                   for (Incidencia inc : listaActivas) {
                       if (inc.getIdsSegmentos().contains(s.getIdSegmento())) {
                           incidenciasSegmento++;
                       }
                   }
              %>
              <tr>
                <td class="ps-4 fw-bold">SEG-<%= String.format("%03d", s.getIdSegmento()) %></td>
                <td><%= s.getNombreOrigen() %> - <%= s.getNombreDestino() %></td>
                <td><span class="badge <%= colorEstado %>"><%= s.getEstado() %></span></td>
                <td><%= Math.round(total) %> Gbps</td>
                <td><%= Math.round(usada) %> Gbps</td>
                <td><%= Math.round(reservada) %> Gbps</td>
                <td><%= Math.round(disponible) %> Gbps</td>
                <td><span class="badge <%= colorNivel %>"><%= Math.round(porcentaje) %>% · <%= nivel %></span></td>
                <td>
                  <% if (incidenciasSegmento == 0) { %>
                  0
                  <% } else { %>
                  <a href="<%=request.getContextPath()%>/IncidenciaServlet?idSegmento=<%= s.getIdSegmento() %>"><%= incidenciasSegmento %></a>
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
</body>
</html>