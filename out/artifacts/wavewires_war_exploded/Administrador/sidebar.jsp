<%@ page contentType="text/html;charset=UTF-8" %>
<div class="col-auto bg-dark text-white p-3" style="min-height: 100vh; width: 260px;">
  <h5 class="mb-4">WaveWires</h5>

  <div class="text-uppercase small text-muted mt-2 mb-1">General</div>
  <nav class="nav flex-column mb-3">
    <a class="nav-link text-light" href="admin_resumen.jsp">Resumen</a>
  </nav>

  <div class="text-uppercase small text-muted mt-2 mb-1">Administración</div>
  <nav class="nav flex-column mb-3">
    <a class="nav-link text-light" href="admin_usuarios.jsp">Usuarios</a>
    <a class="nav-link text-light" data-bs-toggle="collapse" href="#menuInfraestructura" role="button">Infraestructura ▾</a>
    <div class="collapse ps-3" id="menuInfraestructura">
      <a class="nav-link text-light" href="admin_landings.jsp">Landing Stations</a>
      <a class="nav-link text-light" href="admin_segmentos.jsp">Segmentos de Fibra</a>
    </div>
  </nav>

  <div class="text-uppercase small text-muted mt-2 mb-1">Comercial &amp; Capacidad</div>
  <nav class="nav flex-column mb-3">
    <a class="nav-link text-light" href="admin_clientes.jsp">Clientes</a>
    <a class="nav-link text-light" href="admin_solicitudes.jsp">Solicitudes de Tráfico</a>
    <a class="nav-link text-light" href="admin_capacidad.jsp">Monitoreo de Capacidad</a>
  </nav>

  <div class="text-uppercase small text-muted mt-2 mb-1">Operaciones &amp; NOC</div>
  <nav class="nav flex-column mb-3">
    <a class="nav-link text-light" href="admin_incidencias.jsp">Incidencias</a>
    <a class="nav-link text-light" href="admin_mantenimiento.jsp">Mantenimiento</a>
  </nav>

  <div class="text-uppercase small text-muted mt-2 mb-1">Cuenta</div>
  <nav class="nav flex-column">
    <a class="nav-link text-light" href="logout.jsp">Cerrar sesión</a>
  </nav>
</div>