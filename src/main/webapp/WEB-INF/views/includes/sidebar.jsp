<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Usuario" %>
<%@ page import="com.oceanlink.util.Seguridad" %>
<%--
  Menu lateral unico para todos los roles. Cada seccion se escribe UNA sola vez:
  cada rol ve su seccion y el Administrador ve todas (en las ajenas solo consulta).
--%>
<%
  Usuario usuarioMenu = Seguridad.obtenerUsuario(request);
  boolean menuAdmin = Seguridad.tieneRol(usuarioMenu, Seguridad.ADMIN);
  boolean menuPlanner = menuAdmin || Seguridad.tieneRol(usuarioMenu, Seguridad.PLANIFICADOR);
  boolean menuNoc = menuAdmin || Seguridad.tieneRol(usuarioMenu, Seguridad.OPERADOR);
  boolean menuMant = menuAdmin || Seguridad.tieneRol(usuarioMenu, Seguridad.MANTENIMIENTO);
  boolean menuSupervisor = menuAdmin || Seguridad.tieneRol(usuarioMenu, Seguridad.SUPERVISOR);
  String ctx = request.getContextPath();
  String claseLink = "nav-link sidebar-link mb-1 d-flex align-items-center";
%>
<link rel="stylesheet" href="<%= ctx %>/css/sidebar.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<div class="col-auto sidebar-custom p-3 d-flex flex-column">

  <div class="d-flex align-items-center mb-4 px-2">
    <i class="bi bi-broadcast-pin me-2 fs-4 text-primary"></i>
    <h5 class="sidebar-title mb-0">OceanLink</h5>
  </div>
  <jsp:include page="/WEB-INF/views/includes/identidad.jsp" />

  <nav class="nav flex-column mb-auto">
    <% if (menuAdmin) { %>
    <div class="sidebar-section-label text-uppercase mb-2 px-2">Administrador</div>
    <a class="<%= claseLink %>" href="<%= ctx %>/ResumenServlet">Resumen</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/UsuarioServlet">Usuarios</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/LandingStationServlet">Landing Stations</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/SegmentoServlet">Segmentos de Fibra</a>
    <% } %>

    <% if (menuPlanner) { %>
    <div class="sidebar-section-label text-uppercase mt-3 mb-2 px-2">Capacity Planner</div>
    <a class="<%= claseLink %>" href="<%= ctx %>/CapacidadServlet">Capacidad de red</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/SolicitudesServlet">Solicitudes</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/ReservaServlet">Registro de reservas</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/ServicioServlet">Servicios</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/ClienteServlet">Clientes</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/HistorialServlet">Historial de segmentos</a>
    <% } %>

    <% if (menuNoc) { %>
    <div class="sidebar-section-label text-uppercase mt-3 mb-2 px-2">Network Operator</div>
    <a class="<%= claseLink %>" href="<%= ctx %>/IncidenciaServlet">Incidencias activas</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/IncidenciaServlet?action=estadoRed">Estado de la red</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/IncidenciaServlet?action=restauraciones">Restauraciones</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/IncidenciaServlet?action=historial">Historial de incidencias</a>
    <% } %>

    <% if (menuMant) { %>
    <div class="sidebar-section-label text-uppercase mt-3 mb-2 px-2">Maintenance Coordinator</div>
    <a class="<%= claseLink %>" href="<%= ctx %>/MantenimientoServlet">Mantenimiento</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/MantenimientoServlet?action=servicios">Servicios afectados</a>
    <% } %>

    <% if (menuSupervisor) { %>
    <div class="sidebar-section-label text-uppercase mt-3 mb-2 px-2">Supervisor</div>
    <a class="<%= claseLink %>" href="<%= ctx %>/SupervisorServlet">Estado general de la red</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/SupervisorServlet?action=reportes">Reportes</a>
    <a class="<%= claseLink %>" href="<%= ctx %>/SupervisorServlet?action=indicadores">Indicadores históricos</a>
    <% } %>
  </nav>

  <div class="border-top border-secondary opacity-25 my-3"></div>
  <form action="<%= ctx %>/LogoutServlet" method="post">
    <button type="submit" class="nav-link sidebar-link sidebar-link-danger border-0 bg-transparent text-start w-100">
      <i class="bi bi-box-arrow-right me-2"></i>
      Cerrar sesión
    </button>
  </form>
</div>