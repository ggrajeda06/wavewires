<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="nav flex-column col-12 col-md-2 bg-dark vh-100 sticky-top p-3">
  <h5 class="text-white mb-4 fw-bold">WaveWires</h5>
  <span class="text-white-50 small mb-3 text-uppercase">Capacity Planner</span>

  <a class="nav-link text-white-50" href="index.jsp">Capacidad de red</a>
  <a class="nav-link text-white-50" href="solicitudes.jsp">Solicitudes</a>
  <a class="nav-link text-white-50" href="reservas.jsp">Registro de reservas</a>
  <a class="nav-link text-white-50" href="servicios.jsp">Servicios</a>
  <a class="nav-link text-white-50" href="clientes.jsp">Clientes</a>
  <a class="nav-link text-white-50" href="historial.jsp">Historial de segmentos</a>

  <div class="mt-auto">
    <a class="nav-link text-danger" href="${pageContext.request.contextPath}/login.jsp?logout=1">Cerrar sesión</a>
  </div>
</nav>