<%@ page contentType="text/html;charset=UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<div class="col-auto sidebar-custom p-3 d-flex flex-column">

  <div class="d-flex align-items-center mb-4 px-2">
    <i class="bi bi-broadcast-pin me-2 fs-4 text-primary"></i>
    <h5 class="sidebar-title mb-0">OceanLink</h5>
  </div>


  <div class="sidebar-section-label text-uppercase mb-2 px-2">Supervisor</div>
  <nav class="nav flex-column mb-auto">
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="${pageContext.request.contextPath}/Supervisor/supervisor_home.jsp">
      Estado general de la red
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">
      Reportes
    </a>
    <a class="nav-link sidebar-link  mb-1 d-flex align-items-center" href="${pageContext.request.contextPath}/Supervisor/historial_reportes.jsp">
      Historial de reportes
    </a>
  </nav>

  <div class="border-top border-secondary opacity-25 my-3"></div>
  <nav class="nav flex-column">
    <a class="nav-link sidebar-link sidebar-link-danger d-flex align-items-center" href="../login.jsp">
      <i class="bi bi-box-arrow-right me-2"></i> Cerrar sesión
    </a>
  </nav>
</div>
