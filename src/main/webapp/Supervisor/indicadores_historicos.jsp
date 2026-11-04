<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oceanlink.beans.IndicadorMensual, java.math.BigDecimal, java.util.ArrayList" %>
<%
    // Se llenan en SupervisorServlet?action=indicadores
    ArrayList<IndicadorMensual> indicadores = (ArrayList<IndicadorMensual>) request.getAttribute("indicadores");
    ArrayList<Integer> anios = (ArrayList<Integer>) request.getAttribute("anios");
    if (indicadores == null) {
        response.sendRedirect(request.getContextPath() + "/SupervisorServlet?action=indicadores");
        return;
    }
    int anio = (Integer) request.getAttribute("anio");
    String[] nombresMes = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",
            "Septiembre", "Octubre", "Noviembre", "Diciembre"};

    int totalDetectadas = 0;
    int totalCerradas = 0;
    int totalMantenimientos = 0;
    int totalSolicitudes = 0;
    int totalServicios = 0;
    BigDecimal totalCapacidad = BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="sidebarSupervisor.jsp"/>
    <main class="flex-grow-1 p-3 p-lg-4 w-100" style="min-width: 0;">
        <a class="btn btn-outline-secondary btn-sm mb-3"
           href="${pageContext.request.contextPath}/SupervisorServlet">&larr; Volver al inicio</a>
        <h1 class="h3 fw-bold mb-1">Indicadores históricos</h1>
        <p class="text-secondary mb-4">Evolución mensual de la operación de la red.</p>

        <section class="card shadow-sm mb-4" aria-labelledby="tituloHistoricos">
            <div class="card-body p-3 p-lg-4 border-bottom">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <h2 class="h5 mb-0" id="tituloHistoricos">Operación de <%=anio%></h2>
                    <form class="d-flex align-items-center gap-2" method="get" action="<%=request.getContextPath()%>/SupervisorServlet">
                        <input type="hidden" name="action" value="indicadores">
                        <label class="form-label mb-0" for="anio">Año</label>
                        <select class="form-select form-select-sm w-auto" id="anio" name="anio" onchange="this.form.submit()">
                            <% for (Integer a : anios) { %>
                            <option value="<%=a%>" <%=a == anio ? "selected" : ""%>><%=a%></option>
                            <% } %>
                        </select>
                    </form>
                </div>
            </div>
            <div class="table-responsive" style="overflow-y: hidden;" tabindex="0" role="region" aria-label="Indicadores históricos por mes">
                <table class="table table-hover table-sm small align-middle mb-0">
                    <caption class="visually-hidden">Incidencias, mantenimientos, solicitudes y servicios de cada mes.</caption>
                    <thead class="table-light">
                    <tr>
                        <th scope="col">Mes</th>
                        <th scope="col">Incidencias detectadas</th>
                        <th scope="col">Incidencias cerradas</th>
                        <th scope="col">Mantenimientos programados</th>
                        <th scope="col">Solicitudes registradas</th>
                        <th scope="col">Servicios activados</th>
                        <th scope="col">Capacidad activada</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (IndicadorMensual i : indicadores) {
                           totalDetectadas += i.getIncidenciasDetectadas();
                           totalCerradas += i.getIncidenciasCerradas();
                           totalMantenimientos += i.getMantenimientosProgramados();
                           totalSolicitudes += i.getSolicitudesRegistradas();
                           totalServicios += i.getServiciosActivados();
                           totalCapacidad = totalCapacidad.add(i.getCapacidadActivada()); %>
                    <tr>
                        <th scope="row" class="fw-normal"><%=nombresMes[i.getMes() - 1]%></th>
                        <td><%=i.getIncidenciasDetectadas()%></td>
                        <td><%=i.getIncidenciasCerradas()%></td>
                        <td><%=i.getMantenimientosProgramados()%></td>
                        <td><%=i.getSolicitudesRegistradas()%></td>
                        <td><%=i.getServiciosActivados()%></td>
                        <td><%=i.getCapacidadActivada().stripTrailingZeros().toPlainString()%> Gbps</td>
                    </tr>
                    <% } %>
                    </tbody>
                    <tfoot class="table-light fw-semibold">
                    <tr>
                        <th scope="row">Total</th>
                        <td><%=totalDetectadas%></td>
                        <td><%=totalCerradas%></td>
                        <td><%=totalMantenimientos%></td>
                        <td><%=totalSolicitudes%></td>
                        <td><%=totalServicios%></td>
                        <td><%=totalCapacidad.stripTrailingZeros().toPlainString()%> Gbps</td>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </section>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
