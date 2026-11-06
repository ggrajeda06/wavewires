<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%
  int pagina = (Integer) request.getAttribute("pagina");
  int totalPaginas = (Integer) request.getAttribute("totalPaginas");
  String buscar = request.getParameter("buscar");
  String filtro = (buscar == null || buscar.isEmpty()) ? "" : "&buscar=" + URLEncoder.encode(buscar, "UTF-8");
  String enlace = request.getContextPath() + "/" + request.getParameter("servlet") + "?pagina=";
%>
<div class="d-flex justify-content-end align-items-center gap-2">
  <small class="text-muted">Página <%=pagina%> de <%=totalPaginas%></small>
  <a class="btn btn-outline-secondary btn-sm <%=pagina <= 1 ? "disabled" : ""%>" href="<%=enlace + (pagina - 1) + filtro%>">Anterior</a>
  <a class="btn btn-outline-secondary btn-sm <%=pagina >= totalPaginas ? "disabled" : ""%>" href="<%=enlace + (pagina + 1) + filtro%>">Siguiente</a>
</div>
