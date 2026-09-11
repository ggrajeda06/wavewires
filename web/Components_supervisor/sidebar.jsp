<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="nav flex-column col-2 bg-dark vh-100 sticky-top">
  <h5 class="text-white p-3">WaveWires</h5>

  <a class="nav-link text-white" href="supervisor_home  .jsp">Estado General de la Red</a>
  <a class="nav-link text-white" href="reportes_supervisor.jsp">Reportes</a>




  <a class="nav-link text-white mt-auto mb-3"
     href="${pageContext.request.contextPath}/login.jsp">
     Cerrar sesión
  </a>
</nav>

<script>
  document.querySelectorAll('details a').forEach(a => {
    if (a.pathname === location.pathname) a.parentElement.open = true;
  });
</script>
