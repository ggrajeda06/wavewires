<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Usuario" %>
<%@ page import="com.oceanlink.beans.Rol" %>
<jsp:useBean id="lista" type="java.util.ArrayList<com.oceanlink.beans.Usuario>" scope="request" />
<jsp:useBean id="listaRoles" type="java.util.ArrayList<com.oceanlink.beans.Rol>" scope="request" />
<%
  String error = request.getParameter("error");
%>
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

    <div class="d-flex justify-content-end mb-3">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistrarUsuario">+ Nuevo</button>
    </div>

    <% if ("vacio".equals(error)) { %>
    <div class="alert alert-danger">Completa el nombre, el correo y la contraseña.</div>
    <% } else if ("largo".equals(error)) { %>
    <div class="alert alert-danger">El nombre y el correo pueden tener como máximo 100 caracteres.</div>
    <% } else if ("correo".equals(error)) { %>
    <div class="alert alert-danger">El correo no es válido.</div>
    <% } else if ("rol".equals(error)) { %>
    <div class="alert alert-danger">Elige un rol y un estado válidos.</div>
    <% } else if ("clave".equals(error)) { %>
    <div class="alert alert-danger">Las contraseñas no coinciden. Inténtalo de nuevo.</div>
    <% } else if ("correoRepetido".equals(error)) { %>
    <div class="alert alert-danger">Ya existe un usuario con ese correo.</div>
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
              <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#editar<%=u.getIdUsuario()%>">Editar</button>
              <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#borrar<%=u.getIdUsuario()%>">Eliminar</button>
            </td>
          </tr>
          <% } %>
      </tbody>
    </table>
  </main>
</div>

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
            <input type="text" name="nombre" class="form-control" maxlength="100" placeholder="Ingresar nombre" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Correo</label>
            <input type="email" name="correo" class="form-control" maxlength="100" placeholder="Ingresar correo" required>
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

<% for (Usuario u : lista) { %>
<div class="modal fade" id="editar<%=u.getIdUsuario()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">

      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Editar Usuario U-<%=String.format("%03d", u.getIdUsuario())%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <form method="POST" action="<%=request.getContextPath()%>/UsuarioServlet?action=actualizar">
        <input type="hidden" name="idUsuario" value="<%=u.getIdUsuario()%>">

        <div class="modal-body p-4">
          <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Datos</h6>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Nombre</label>
            <input type="text" name="nombre" class="form-control" maxlength="100" value="<%=u.getNombre()%>" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Correo</label>
            <input type="email" name="correo" class="form-control" maxlength="100" value="<%=u.getCorreo()%>" required>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Rol</label>
            <select name="idRol" class="form-select" required>
              <% for (Rol r : listaRoles) { %>
                <option value="<%=r.getIdRoles()%>" <%=r.getIdRoles() == u.getIdRol() ? "selected" : ""%>><%=r.getRol()%></option>
              <% } %>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-semibold">Estado</label>
            <select name="estado" class="form-select" required>
              <option value="Activo" <%="Activo".equals(u.getEstado()) ? "selected" : ""%>>Activo</option>
              <option value="Inactivo" <%="Inactivo".equals(u.getEstado()) ? "selected" : ""%>>Inactivo</option>
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

        <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
          <button type="button" class="btn btn-outline-secondary px-3" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn btn-primary px-3">Guardar cambios</button>
        </div>
      </form>

    </div>
  </div>
</div>

<div class="modal fade" id="borrar<%=u.getIdUsuario()%>" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header border-bottom py-3 px-4">
        <h5 class="modal-title fw-bold m-0">Eliminar usuario</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body p-4">
        ¿Estás seguro de que deseas eliminar a <b><%=u.getNombre()%></b>?
      </div>
      <div class="modal-footer border-top-0 pt-0 px-4 pb-4">
        <button type="button" class="btn btn-primary px-3" data-bs-dismiss="modal">Cancelar</button>
        <a href="<%=request.getContextPath()%>/UsuarioServlet?action=borrar&id=<%=u.getIdUsuario()%>" class="btn btn-outline-danger px-3">Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>