<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oceanlink.beans.Cliente, com.oceanlink.beans.Segmento, com.oceanlink.util.Html, java.util.ArrayList, java.util.Collection" %>
<%
    // Se llenan en SupervisorServlet?action=reportes
    ArrayList<Segmento> segmentos = (ArrayList<Segmento>) request.getAttribute("segmentos");
    ArrayList<Cliente> clientes = (ArrayList<Cliente>) request.getAttribute("clientes");
    Collection<String> paises = (Collection<String>) request.getAttribute("paises");
    if (segmentos == null) {
        segmentos = new ArrayList<>();
        clientes = new ArrayList<>();
        paises = new ArrayList<>();
    }
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
    <main class="flex-grow-1 p-3 p-lg-4 w-100">
        <a class="btn btn-outline-secondary btn-sm mb-3"
           href="${pageContext.request.contextPath}/SupervisorServlet">&larr; Volver al inicio</a>
        <h1 class="h3 fw-bold mb-1">Reportes</h1>
        <p class="text-secondary mb-4">Elige las columnas y los filtros de cada reporte, y genera un archivo PDF. Los filtros que dejes en blanco no se aplican.</p>
        <% if ("columnas".equals(request.getParameter("error"))) { %>
          <div class="alert alert-danger">Marca al menos una columna para generar el reporte.</div>
        <% } else if ("fechas".equals(request.getParameter("error"))) { %>
          <div class="alert alert-danger">Revisa las fechas: la fecha inicial no puede ser posterior a la final.</div>
        <% } %>

        <!-- Mantenimientos -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="mantenimientos">
                    <h2 class="h5 mb-3">Mantenimientos</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="ID" id="mant1" checked><label class="form-check-label" for="mant1">ID</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Nombre" id="mant2" checked><label class="form-check-label" for="mant2">Nombre</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Estado" id="mant3" checked><label class="form-check-label" for="mant3">Estado</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Fecha" id="mant4" checked><label class="form-check-label" for="mant4">Fecha</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Infraestructura" id="mant5" checked><label class="form-check-label" for="mant5">Infraestructura</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Ubicación" id="mant6" checked><label class="form-check-label" for="mant6">Ubicación</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Tipo" id="mant7" checked><label class="form-check-label" for="mant7">Tipo</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Descripción" id="mant8" checked><label class="form-check-label" for="mant8">Descripción</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Duración (horas)" id="mant9" checked><label class="form-check-label" for="mant9">Duración (horas)</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Actividades realizadas" id="mant10" checked><label class="form-check-label" for="mant10">Actividades realizadas</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Servicios afectados" id="mant11" checked><label class="form-check-label" for="mant11">Servicios afectados</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="estadoMant">Estado</label>
                            <select class="form-select" id="estadoMant" name="estado">
                                <option value="" selected>Todos</option>
                                <option>Pendiente</option>
                                <option>Activo</option>
                                <option>Finalizado</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="tipoMant">Tipo</label>
                            <select class="form-select" id="tipoMant" name="tipoMantenimiento">
                                <option value="" selected>Todos</option>
                                <option>Preventivo</option>
                                <option>Correctivo</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="desdeMant">Programado desde</label>
                            <input class="form-control" type="date" id="desdeMant" name="desde">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="hastaMant">Programado hasta</label>
                            <input class="form-control" type="date" id="hastaMant" name="hasta">
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- Incidencias -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="incidencias">
                    <h2 class="h5 mb-3">Incidencias</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Incidencia" id="inc1" checked><label class="form-check-label" for="inc1">Incidencia</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Landings afectadas" id="inc2" checked><label class="form-check-label" for="inc2">Landings afectadas</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Observaciones" id="inc3" checked><label class="form-check-label" for="inc3">Observaciones</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Segmentos afectados" id="inc4" checked><label class="form-check-label" for="inc4">Segmentos afectados</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Estado" id="inc5" checked><label class="form-check-label" for="inc5">Estado</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Severidad" id="inc6" checked><label class="form-check-label" for="inc6">Severidad</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Servicios afectados" id="inc9" checked><label class="form-check-label" for="inc9">Servicios afectados</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Clientes afectados" id="inc7" checked><label class="form-check-label" for="inc7">Clientes afectados</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Detectado" id="inc8" checked><label class="form-check-label" for="inc8">Detectado</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="estadoInc">Estado</label>
                            <select class="form-select" id="estadoInc" name="estado">
                                <option value="" selected>Todos</option>
                                <option>Detectada</option>
                                <option>En análisis</option>
                                <option>Reparación programada</option>
                                <option>En reparación</option>
                                <option>Servicio restaurado</option>
                                <option>Cerrada</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="severidadInc">Severidad</label>
                            <select class="form-select" id="severidadInc" name="severidad">
                                <option value="" selected>Todos</option>
                                <option>Crítica</option>
                                <option>Alta</option>
                                <option>Media</option>
                                <option>Baja</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="segmentoInc">Segmento afectado</label>
                            <select class="form-select" id="segmentoInc" name="idSegmento">
                                <option value="" selected>Todos</option>
                                <% for (Segmento s : segmentos) { %>
                                <option value="<%=s.getIdSegmento()%>"><%=String.format("SEG-%03d", s.getIdSegmento())%> · <%=Html.esc(s.getNombreOrigen())%> - <%=Html.esc(s.getNombreDestino())%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="desdeInc">Detectada desde</label>
                            <input class="form-control" type="date" id="desdeInc" name="desde">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="hastaInc">Detectada hasta</label>
                            <input class="form-control" type="date" id="hastaInc" name="hasta">
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- Segmentos -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="segmentos">
                    <h2 class="h5 mb-3">Segmentos</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="ID" id="seg1" checked><label class="form-check-label" for="seg1">ID</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Origen" id="seg2" checked><label class="form-check-label" for="seg2">Origen</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Destino" id="seg3" checked><label class="form-check-label" for="seg3">Destino</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Ruta" id="seg4" checked><label class="form-check-label" for="seg4">Ruta</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Total" id="seg5" checked><label class="form-check-label" for="seg5">Total</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="En uso" id="seg6" checked><label class="form-check-label" for="seg6">En uso</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Reservada" id="seg7" checked><label class="form-check-label" for="seg7">Reservada</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Disponible" id="seg8" checked><label class="form-check-label" for="seg8">Disponible</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Utilización" id="seg9" checked><label class="form-check-label" for="seg9">Utilización (%)</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Nivel" id="seg11" checked><label class="form-check-label" for="seg11">Nivel de utilización</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Estado" id="seg10" checked><label class="form-check-label" for="seg10">Estado</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="estadoSeg">Estado</label>
                            <select class="form-select" id="estadoSeg" name="estado">
                                <option value="" selected>Todos</option>
                                <option>Operativo</option>
                                <option>Degradado</option>
                                <option>En mantenimiento</option>
                                <option>Fuera de servicio</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="nivelSeg">Nivel de utilización</label>
                            <select class="form-select" id="nivelSeg" name="nivel">
                                <option value="" selected>Todos</option>
                                <option>Normal</option>
                                <option>Alta utilización</option>
                                <option>Utilización crítica</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- Landing Stations -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="landings">
                    <h2 class="h5 mb-3">Landing Stations</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="ID" id="land1" checked><label class="form-check-label" for="land1">ID</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Nombre" id="land2" checked><label class="form-check-label" for="land2">Nombre</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Ubicación" id="land3" checked><label class="form-check-label" for="land3">Ubicación</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Segmentos" id="land5" checked><label class="form-check-label" for="land5">Segmentos</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Incidencias activas" id="land6" checked><label class="form-check-label" for="land6">Incidencias activas</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Mantenimientos" id="land7" checked><label class="form-check-label" for="land7">Mantenimientos</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                            <div class="col-6 col-md-3">
                            <label class="form-label" for="paisLand">País</label>
                            <select class="form-select" id="paisLand" name="pais">
                                <option value="" selected>Todos</option>
                                <% for (String p : paises) { %>
                                <option value="<%=Html.esc(p)%>"><%=Html.esc(p)%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- Servicios -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="servicios">
                    <h2 class="h5 mb-3">Servicios</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Servicio" id="serv1" checked><label class="form-check-label" for="serv1">Servicio</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Cliente" id="serv2" checked><label class="form-check-label" for="serv2">Cliente</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Segmento" id="serv3" checked><label class="form-check-label" for="serv3">Segmento</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Capacidad" id="serv4" checked><label class="form-check-label" for="serv4">Capacidad</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Activación" id="serv7" checked><label class="form-check-label" for="serv7">Activación</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Caducidad del Servicio" id="serv5" checked><label class="form-check-label" for="serv5">Caducidad del Servicio</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Estado" id="serv6" checked><label class="form-check-label" for="serv6">Estado</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="estadoServ">Estado</label>
                            <select class="form-select" id="estadoServ" name="estado">
                                <option value="" selected>Todos</option>
                                                                <option>Funcionando</option>
                                                                <option>Caído</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="clienteServ">Cliente</label>
                            <select class="form-select" id="clienteServ" name="idCliente">
                                <option value="" selected>Todos</option>
                                <% for (Cliente c : clientes) { %>
                                <option value="<%=c.getIdCliente()%>"><%=Html.esc(c.getRazonSocial())%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="segmentoServ">Segmento</label>
                            <select class="form-select" id="segmentoServ" name="idSegmento">
                                <option value="" selected>Todos</option>
                                <% for (Segmento s : segmentos) { %>
                                <option value="<%=s.getIdSegmento()%>"><%=String.format("SEG-%03d", s.getIdSegmento())%> · <%=Html.esc(s.getNombreOrigen())%> - <%=Html.esc(s.getNombreDestino())%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="desdeServ">Activado desde</label>
                            <input class="form-control" type="date" id="desdeServ" name="desde">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="hastaServ">Activado hasta</label>
                            <input class="form-control" type="date" id="hastaServ" name="hasta">
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!-- Clientes -->
        <section class="card shadow-sm mb-4">
            <div class="card-body p-3 p-lg-4">
                <form method="post" action="<%=request.getContextPath()%>/SupervisorServlet?action=pdf">
                    <input type="hidden" name="tipo" value="clientes">
                    <h2 class="h5 mb-3">Clientes</h2>
                    <div class="row g-2 mb-3">
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Identificador" id="cli1" checked><label class="form-check-label" for="cli1">Identificador</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Razón Social" id="cli2" checked><label class="form-check-label" for="cli2">Razón Social</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Servicios Contratados" id="cli3" checked><label class="form-check-label" for="cli3">Servicios Contratados</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Capacidad contratada" id="cli6" checked><label class="form-check-label" for="cli6">Capacidad contratada</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Fecha de cliente registrado" id="cli4" checked><label class="form-check-label" for="cli4">Fecha de registro</label></div></div>
                        <div class="col-6 col-md-3"><div class="form-check"><input class="form-check-input" type="checkbox" name="columnas" value="Estado" id="cli5" checked><label class="form-check-label" for="cli5">Estado</label></div></div>
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="estadoCli">Estado</label>
                            <select class="form-select" id="estadoCli" name="estado">
                                <option value="" selected>Todos</option>
                                <option>Activo</option>
                                <option>Inactivo</option>
                            </select>
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="desdeCli">Registrado desde</label>
                            <input class="form-control" type="date" id="desdeCli" name="desde">
                        </div>
                        <div class="col-6 col-md-3">
                            <label class="form-label" for="hastaCli">Registrado hasta</label>
                            <input class="form-control" type="date" id="hastaCli" name="hasta">
                        </div>
                        <div class="col-12 col-md-3 ms-md-auto d-grid">
                            <button type="submit" class="btn btn-primary">Generar PDF</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

    </main>
</div>
</body>
</html>
