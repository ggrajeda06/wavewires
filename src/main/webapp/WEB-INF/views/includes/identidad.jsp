<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanlink.beans.Usuario" %>
<%@ page import="com.oceanlink.util.Seguridad" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<%
  Usuario usuarioIdentidad = Seguridad.obtenerUsuario(request);
%>

<% if (usuarioIdentidad != null) { %>
<div class="px-2 py-3">
  <div class="bi bi-person fw-semibold" style="color: #ffffff;">
    <%= Seguridad.escaparHtml(usuarioIdentidad.getNombre()) %>
  </div>
</div>
<% } %>
