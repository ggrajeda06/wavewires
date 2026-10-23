<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanlink.beans.Cliente" %>
<jsp:useBean id="listaClientes" type="java.util.ArrayList<com.oceanlink.beans.Cliente>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WaveWires - Clientes Empresariales</title>
  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="row g-0">
  <!-- Sidebar compartido del Capacity Planner -->
  <jsp:include page="sidebar.jsp"/>

  <!-- Contenido de la vista -->
  <main class="col p-4">

    <!-- Titulo y boton para abrir el modal de registro -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="h3 fw-bold text-dark m-0">Clientes Empresariales</h2>
        <small class="text-muted">Gestiona nuestros clientes</small>
      </div>
      <button type="button" class="btn btn-dark btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#modalRegistrarCliente">
        <i class="bi bi-plus-lg me-1"></i> Registrar cliente
      </button>
    </div>

    <!-- Contenedor con buscador y tabla -->
    <div class="card shadow-sm border-0 p-3">

      <!-- Filtro de busqueda -->
      <form method="GET" action="<%=request.getContextPath()%>/ClienteServlet" class="row mb-3">
        <div class="col-md-4">
          <input type="text" name="buscar" class="form-control" placeholder="Buscar cliente o razón social..."
                 value="<%=request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
        </div>
      </form>

      <!-- Tabla de clientes -->
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-3">
          <thead class="table-light">
          <tr>
            <th style="width: 14%;">Identificador</th>
            <th style="width: 20%;">Razón Social</th>
            <th style="width: 22%;">Servicios Contratados</th>
            <th style="width: 20%;">Fecha de cliente registrado</th>
            <th style="width: 12%;">Estado</th>
            <th style="width: 12%;" class="text-center">Acción</th>
          </tr>
          </thead>
          <tbody>
          <% for (Cliente c : listaClientes) {
               String colorBadge = "bg-success-subtle text-success border border-success-subtle";
               if (c.getEstado() != null && c.getEstado().equalsIgnoreCase("Inactivo")) {
                   colorBadge = "bg-secondary-subtle text-secondary border border-secondary-subtle";
               }
          %>
          <tr>
            <td class="fw-medium"><%=c.getIdentificador()%></td>
            <td><%=c.getRazonSocial()%></td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-secondary px-3" data-bs-toggle="modal" data-bs-target="#modalServicios">
                Detalles
              </button>
            </td>
            <td class="text-secondary"><%=c.getFechaRegistro()%></td>
            <td>
              <span class="badge <%=colorBadge%>"><%=c.getEstado()%></span>
            </td>
            <td class="text-center">
              <a href="<%=request.getContextPath()%>/ClienteServlet?action=borrar&id=<%=c.getIdCliente()%>"
                 class="btn btn-outline-danger btn-sm px-3"
                 onclick="return confirm('¿Estás seguro de que deseas eliminar este cliente?');">
                <i class="bi bi-trash"></i> Eliminar
              </a>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>

      <!-- Paginacion estatica -->
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button>
        <button type="button" class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>

    </div>
  </main>
</div>

<!-- Modal para ver los servicios contratados -->
<div class="modal fade" id="modalServicios" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-0 pb-0">
        <h6 class="modal-title fw-bold text-dark">Servicios contratados</h6>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body px-3 pt-3 pb-3">
        <div class="p-3 bg-light text-center rounded border text-muted small">
          Sin servicios contratados actualmente.
        </div>
      </div>

      <div class="modal-footer border-0 justify-content-center pt-0 pb-3">
        <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Cerrar</button>
      </div>

    </div>
  </div>
</div>

<!-- Modal para nuevo cliente -->
<div class="modal fade" id="modalRegistrarCliente" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Registrar Cliente</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/ClienteServlet?action=crear">
        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Razón social</label>
            <input type="text" name="razonSocial" class="form-control" placeholder="Escribe el nombre de la empresa" required>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-dark px-3">Guardar cliente</button>
        </div>
      </form>

    </div>
  </div>
</div>

<!-- Scripts de Bootstrap para que abran los modales -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>