<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Usuario" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Usuario>" scope="request" />
<%@ page import="com.oceanlink.beans.Rol" %>
<jsp:useBean id="listaRoles" type="java.util.ArrayList<com.oceanlink.beans.Rol>" scope="request" />
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="/Administrador/sidebar.jsp"/>
  <main class="col p-4">
    <h4>Usuarios</h4>

    <div class="d-flex gap-2 mb-3">
      <input class="form-control" placeholder="Buscar">
      <select class="form-select w-auto">
        <option>Ordenar</option>
        <option>A - Z</option>
        <option>Rol</option>
        <option>Estado</option>
      </select>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistrarUsuario">+ Nuevo</button>
    </div>
    <% if ("clave".equals(request.getParameter("error"))) { %>
       <div class="alert alert-danger">Las contraseñas no coinciden. Inténtalo de nuevo.</div>
    <% } %>
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Correo</th>
          <th>Rol</th>
          <th>Estado</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
          <% for (Usuario u : lista) { %>
          <tr>
            <td>U-<%=String.format("%03d", u.getIdUsuario())%></td>
            <td><%=u.getNombre()%></td>
            <td><%=u.getCorreo()%></td>
            <td><%=u.getNombreRol()%></td>
            <td>
              <span class="badge <%= "Activo".equals(u.getEstado()) ? "bg-success" : "bg-secondary" %>">
                <%=u.getEstado()%>
              </span>
            </td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-secondary"
                      onclick="abrirEditar('<%=u.getIdUsuario()%>', '<%=u.getNombre().replace("'", "\\'")%>', '<%=u.getCorreo()%>', '<%=u.getIdRol()%>', '<%=u.getEstado()%>')">
                Editar
              </button>
            </td>
          </tr>
          <% } %>
      </tbody>
    </table>
  </main>
</div>
<!-- Modal para nuevo usuario -->
<div class="modal fade" id="modalRegistrarUsuario" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Registrar Usuario</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/UsuarioServlet?action=crear">
        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Nombre</label>
            <input type="text" name="nombre" class="form-control" placeholder="Ingresar nombre" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Correo</label>
            <input type="email" name="correo" class="form-control" placeholder="Ingresar correo" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Rol</label>
            <select name="idRol" class="form-select" required>
              <option value="" selected disabled>Seleccionar rol</option>
              <% for (Rol r : listaRoles) { %>
                <option value="<%=r.getIdRoles()%>"><%=r.getRol()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select" required>
              <option value="Activo">Activo</option>
              <option value="Inactivo">Inactivo</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Contraseña</label>
            <input type="password" name="contrasenia" class="form-control" placeholder="Ingresar contraseña" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Confirmar contraseña</label>
            <input type="password" name="confirmar" class="form-control" placeholder="Repetir contraseña" required>
          </div>
        </div>

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary px-3">Guardar usuario</button>
        </div>
      </form>

    </div>
  </div>
</div>
<div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Usuario</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/UsuarioServlet?action=actualizar">
        <input type="hidden" name="idUsuario" id="editId">

        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Nombre</label>
            <input type="text" name="nombre" id="editNombre" class="form-control" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Correo</label>
            <input type="email" name="correo" id="editCorreo" class="form-control" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Rol</label>
            <select name="idRol" id="editRol" class="form-select" required>
              <% for (Rol r : listaRoles) { %>
                <option value="<%=r.getIdRoles()%>"><%=r.getRol()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" id="editEstado" class="form-select" required>
              <option value="Activo">Activo</option>
              <option value="Inactivo">Inactivo</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Nueva contraseña</label>
            <input type="password" name="contrasenia" class="form-control" placeholder="Dejar vacío para no cambiarla">
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Confirmar nueva contraseña</label>
            <input type="password" name="confirmar" class="form-control" placeholder="Repetir contraseña">
          </div>
        </div>

        <div class="modal-footer border-top-0 d-flex justify-content-between pt-0 px-4 pb-4">
          <a id="btnEliminarModal" href="#" class="btn btn-outline-danger px-3"
             onclick="return confirm('¿Estás seguro de que deseas eliminar este usuario?');">
            Eliminar
          </a>
          <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-primary px-3">Guardar cambios</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function abrirEditar(id, nombre, correo, idRol, estado) {
  document.getElementById('editId').value = id;
  document.getElementById('editNombre').value = nombre;
  document.getElementById('editCorreo').value = correo;
  document.getElementById('editRol').value = idRol;
  document.getElementById('editEstado').value = estado;
  document.getElementById('btnEliminarModal').href = '<%=request.getContextPath()%>/UsuarioServlet?action=borrar&id=' + id;

  let modal = new bootstrap.Modal(document.getElementById('modalEditarUsuario'));
  modal.show();
}
</script>
</body>
</html>