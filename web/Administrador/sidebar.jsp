<%@ page contentType="text/html;charset=UTF-8" %>
<%-- Para agregar una vista: copia una línea <a> y cambia el href y el texto --%>
<nav class="nav flex-column col-2 bg-dark vh-100 sticky-top">
  <h5 class="text-white p-3">WaveWires</h5>

  <a class="nav-link text-white" href="admin_resumen.jsp">Resumen</a>
  <a class="nav-link text-white" href="admin_usuarios.jsp">Usuarios</a>

  <details name="menu">
    <summary class="text-white px-3 py-2">Infraestructura</summary>
    <a class="nav-link text-white ps-5" href="admin_landings.jsp">Landing Stations</a>
    <a class="nav-link text-white ps-5" href="admin_segmentos.jsp">Segmentos</a>
  </details>

  <a class="nav-link text-white" href="capacidad.jsp">Capacidad</a>
  <a class="nav-link text-white" href="solicitudes.jsp">Solicitudes</a>
  <a class="nav-link text-white" href="clientes.jsp">Clientes</a>
  <a class="nav-link text-white" href="historial-segmentos.jsp">Historial de segmentos</a>
  <a class="nav-link text-white" href="restauracion.jsp">Restauración</a>

  <details name="menu">
    <summary class="text-white px-3 py-2">Incidencias</summary>
    <a class="nav-link text-white ps-5" href="incidencias.jsp">Principal</a>
    <a class="nav-link text-white ps-5" href="historial-incidencias.jsp">Historial</a>
  </details>

  <a class="nav-link text-white" href="mantenimiento.jsp">Mantenimiento</a>
  <a class="nav-link text-white" href="login.jsp">Cerrar sesión</a>
</nav>

<%-- Deja abierto el desplegable de la página actual. Si lo borras, todo sigue funcionando. --%>
<script>
  document.querySelectorAll('details a').forEach(a => {
    if (a.pathname === location.pathname) a.parentElement.open = true;
  });
</script>
