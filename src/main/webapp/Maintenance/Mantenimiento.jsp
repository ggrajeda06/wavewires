<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Mantenimiento" %>
<%@ page import="com.oceanlink.beans.LandingStation" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Mantenimiento>" scope="request" />
<jsp:useBean id="listaLandings" type="java.util.ArrayList<com.oceanlink.beans.LandingStation>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0">Historial de Mantenimiento</h3>
      <a class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/MantenimientoServlet?action=formCrear">Registrar mantenimiento</a>
    </div>

    <div class="card shadow-sm">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">Nombre del servicio (ID)</th>
                <th scope="col">Estado</th>
                <th scope="col">Fecha</th>
                <th scope="col">Infraestructura</th>
                <th scope="col">Ubicación</th>
                <th scope="col" class="text-end pe-4"></th>
              </tr>
            </thead>
            <tbody>
              <% for (Mantenimiento m : lista) {
                   String nombreLanding = "";
                   String ubicacion = "";
                   for (LandingStation ls : listaLandings) {
                       if (ls.getIdLandingStation() == m.getIdLandingStation()) {
                           nombreLanding = ls.getNombre();
                           ubicacion = ls.getCiudad() + ", " + ls.getPais();
                       }
                   }
                   String colorEstado = "bg-secondary";
                   if (m.getEstado().equals("Activo")) {
                       colorEstado = "bg-success";
                   } else if (m.getEstado().equals("Pendiente")) {
                       colorEstado = "bg-danger";
                   }
              %>
              <tr>
                <td class="ps-4">
                  <a href="#" class="text-decoration-none fw-bold" data-bs-toggle="modal" data-bs-target="#detalle<%=m.getIdMantenimiento()%>">
                    ID<%=m.getIdMantenimiento()%> - <%=m.getNombre()%>
                  </a>
                </td>
                <td><span class="badge <%=colorEstado%>"><%=m.getEstado()%></span></td>
                <td><%=m.getFechaRegistrada()%></td>
                <td><%=nombreLanding%></td>
                <td><%=ubicacion%></td>
                <td class="text-end pe-4">
                  <div class="dropdown">
                    <button class="btn btn-link text-dark text-decoration-none fw-bold p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                      •••
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                      <li>
                        <a class="dropdown-item d-flex align-items-center gap-2" href="<%=request.getContextPath()%>/MantenimientoServlet?action=editar&id=<%=m.getIdMantenimiento()%>">
                          <i class="bi bi-pencil"></i> Editar
                        </a>
                      </li>
                      <li>
                        <a class="dropdown-item text-danger d-flex align-items-center gap-2" href="<%=request.getContextPath()%>/MantenimientoServlet?action=borrar&id=<%=m.getIdMantenimiento()%>">
                          <i class="bi bi-trash"></i> Eliminar
                        </a>
                      </li>
                    </ul>
                  </div>
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

<% for (Mantenimiento m : lista) {
     String nombreLanding = "";
     for (LandingStation ls : listaLandings) {
         if (ls.getIdLandingStation() == m.getIdLandingStation()) {
             nombreLanding = ls.getNombre();
         }
     }
%>
<div class="modal fade" id="detalle<%=m.getIdMantenimiento()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-bottom-0 pb-0">
        <h4 class="modal-title w-100 text-center fw-bold">INFORMACIÓN</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4">
        <div class="row g-3">
          <div class="col-md-7">
            <div class="row g-3">
              <div class="col-6">
                <label class="form-label small fw-semibold">Nombre</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break">ID<%=m.getIdMantenimiento()%> - <%=m.getNombre()%></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Estado</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break"><%=m.getEstado()%></div>
              </div>
              <div class="col-12">
                <label class="form-label small fw-semibold">Descripción</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" style="max-height: 120px; overflow-y: auto; white-space: pre-line;"><%=m.getDescripcion()%></div>
              </div>
              <div class="col-12">
                <label class="form-label small fw-semibold">Tipo de mantenimiento</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break"><%=m.getTipo()%></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Fecha</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break"><%=m.getFechaRegistrada()%></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Infraestructura</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break"><%=nombreLanding%></div>
              </div>
            </div>
          </div>

          <div class="col-md-5 d-flex flex-column">
            <label class="form-label small fw-semibold text-uppercase" style="font-size: 0.75rem;">
              ACTIVIDADES REALIZADAS DURANTE EL MANTENIMIENTO:
            </label>
            <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break flex-grow-1" style="max-height: 250px; overflow-y: auto; white-space: pre-line;"><%=m.getActividadesRealizadas() == null ? "" : m.getActividadesRealizadas()%></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>