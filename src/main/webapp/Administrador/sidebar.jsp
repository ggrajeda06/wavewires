<%@ page contentType="text/html;charset=UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<div class="col-auto sidebar-custom p-3 d-flex flex-column">

  <div class="d-flex align-items-center mb-4 px-2">
    <i class="bi bi-broadcast-pin me-2 fs-4 text-primary"></i>
    <h5 class="sidebar-title mb-0">OceanLink</h5>
  </div>


  <div class="sidebar-section-label text-uppercase mb-2 px-2">Administrator</div>
  <nav class="nav flex-column mb-auto">
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="admin_resumen.jsp">
      Resumen
      </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="admin_usuarios.jsp">
      Usuarios
    </a>
    <a class="nav-link sidebar-link" data-bs-toggle="collapse" href="#menuInfraestructura" role="button">Infraestructura ▾</a>
    <div class="collapse ps-3" id="menuInfraestructura">
          <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="admin_landings.jsp">
                Landing Stations
              </a>
          <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="admin_segmentos.jsp">
                Segmentos de Fibra
              </a>
        </div>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="/CapacityPlanner/clientes.jsp">
      Clientes
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="/CapacityPlanner/solicitudes.jsp">
      Solicitudes de Tráfico
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="/CapacityPlanner/capacidad.jsp">
      Monitoreo de Capacidad
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="/NetworkOperator/incidencias.jsp">
      Incidencias
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="<%=request.getContextPath()%>/MantenimientoServlet">
       Mantenimiento
    </a>
  </nav>

  <div class="border-top border-secondary opacity-25 my-3"></div>
  <nav class="nav flex-column">
    <a class="nav-link sidebar-link sidebar-link-danger d-flex align-items-center" href="../login.jsp">
      <i class="bi bi-box-arrow-right me-2"></i> Cerrar sesión
    </a>
  </nav>
</div>