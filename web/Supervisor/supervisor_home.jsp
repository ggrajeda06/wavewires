<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink - Estado general de la red</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <style>
        .supervisor-sidebar { width: 240px; flex-shrink: 0; height: 100vh; position: sticky; top: 0; }
        .supervisor-sidebar .nav-link { border-radius: .375rem; padding: .75rem 1rem; }
        .supervisor-sidebar .nav-link:hover,
        .supervisor-sidebar .nav-link:focus-visible,
        .supervisor-sidebar .nav-link.active { background-color: var(--bs-secondary); }
        .supervisor-main { min-width: 0; }
        .modal th { white-space: nowrap; }
        .detail-content { min-width: 180px; }
        @media (max-width: 767.98px) {
            .supervisor-sidebar { width: 100%; height: auto; position: static; }
        }
    </style>
</head>
<body class="bg-light">
<div class="d-flex flex-column flex-md-row min-vh-100">
    <nav class="supervisor-sidebar d-flex flex-column bg-dark p-3" aria-label="Navegación del supervisor">
        <div class="h5 text-white px-3 py-2 mb-3">OceanLink</div>
        <div class="nav flex-column gap-2 mb-4">
            <a class="nav-link text-white active fw-semibold" aria-current="page" href="${pageContext.request.contextPath}/Supervisor/supervisor_home.jsp">Estado general de la red</a>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">Reportes</a>
        </div>
        <a class="nav-link text-white mt-auto" href="${pageContext.request.contextPath}/login.jsp?logout=1">Cerrar sesión</a>
    </nav>
    <main class="supervisor-main flex-grow-1 p-3 p-lg-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
            <h1 class="h3 fw-bold mb-0">Estado general de la red</h1>
        </div>
        <section class="card shadow-sm mb-4" aria-labelledby="tituloCapacidad">
            <div class="card-body p-3 p-lg-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                    <h2 class="h5 mb-0" id="tituloCapacidad">Capacidad de la red</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalCapacidad">Más detalles</button>
                </div>
                <div class="row g-3 mb-4"><div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad total</span><p class="fs-5 fw-semibold mb-0 mt-2">3300 Gbps</p></div></div>
<div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad en uso</span><p class="fs-5 fw-semibold mb-0 mt-2">2000 Gbps</p></div></div>
<div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad reservada</span><p class="fs-5 fw-semibold mb-0 mt-2">200 Gbps</p></div></div>
<div class="col-12 col-sm-6 col-xl-3"><div class="border rounded p-3 h-100"><span class="text-secondary small">Capacidad disponible</span><p class="fs-5 fw-semibold mb-0 mt-2">1100 Gbps</p></div></div></div>
                <div class="border rounded p-3">
                    <h3 class="h6 mb-3">Más utilizados</h3>
                    <div class="row g-3"><div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 1</span><span>97%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 1" aria-valuenow="97" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 97%"></div></div></div>
<div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 2</span><span>96%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 2" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 96%"></div></div></div>
<div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 3</span><span>93%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 3" aria-valuenow="93" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 93%"></div></div></div>
<div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 4</span><span>85%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 4" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 85%"></div></div></div>
<div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 5</span><span>82%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 5" aria-valuenow="82" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 82%"></div></div></div>
<div class="col-12 col-lg-6"><div class="d-flex justify-content-between small mb-1"><span>Segmento 6</span><span>75%</span></div><div class="progress" role="progressbar" aria-label="Utilización del segmento 6" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar bg-secondary" style="width: 75%"></div></div></div></div>
                </div>
            </div>
        </section>
        <div class="row g-4">
            <div class="col-12 col-xl-6">
                <section class="card shadow-sm h-100" aria-labelledby="tituloIncidencias">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3"><h2 class="h5 mb-0" id="tituloIncidencias">Incidencias activas</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalIncidencias">Más detalles</button></div>
                        <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de incidencias">
<table class="table table-hover align-middle mb-0"><thead class="table-light"><tr><th scope="col">ID de incidencia</th><th scope="col">Infraestructura</th><th scope="col">Estado</th><th scope="col">Severidad</th></tr></thead><tbody>
<tr><th scope="row" class="fw-normal">INC-001</th><td>Landing-A</td><td>En análisis</td><td><span class="badge text-bg-danger">Crítica</span></td></tr>
<tr><th scope="row" class="fw-normal">INC-002</th><td>Landing-B</td><td>En atención</td><td><span class="badge text-bg-warning">Alta</span></td></tr>
<tr><th scope="row" class="fw-normal">INC-003</th><td>Landing-C</td><td>Detectada</td><td><span class="badge text-bg-info">Media</span></td></tr>
</tbody></table></div>
                    </div>
                </section>
            </div>
            <div class="col-12 col-xl-6">
                <section class="card shadow-sm h-100" aria-labelledby="tituloMantenimientos">
                    <div class="card-body">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3"><h2 class="h5 mb-0" id="tituloMantenimientos">Mantenimientos pendientes</h2><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalMantenimientos">Más detalles</button></div>
                        <div class="table-responsive" tabindex="0" role="region" aria-label="Listado de mantenimientos">
<table class="table table-hover align-middle mb-0"><thead class="table-light"><tr><th scope="col">ID de mantenimiento</th><th scope="col">Infraestructura</th><th scope="col">Tipo</th><th scope="col">Fecha</th></tr></thead><tbody>
<tr><th scope="row" class="fw-normal">MANT-001</th><td>Landing Station A</td><td>Correctivo</td><td>10/10/2026</td></tr>
<tr><th scope="row" class="fw-normal">MANT-002</th><td>Landing Station B</td><td>Preventivo</td><td>15/10/2026</td></tr>
</tbody></table></div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</div>

<!-- Los modales pertenecen a esta vista; no se incluyen archivos externos JSP. -->
<div class="modal fade" id="modalCapacidad" tabindex="-1" aria-labelledby="modalCapacidadTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalCapacidadTitulo">Capacidad por segmento</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body">
                <p class="small text-secondary">La capacidad disponible descuenta el uso y la reserva de cada segmento.</p><p class="small text-secondary" id="buscarCapacidadNota">La búsqueda y los filtros aún no se aplican.</p><div class="row g-3 mb-4"><div class="col-12 col-lg"><label class="form-label small" for="buscarCapacidad">Buscar</label><input class="form-control" type="search" id="buscarCapacidad" placeholder="Buscar segmento o ruta" aria-describedby="buscarCapacidadNota"></div>
                <div class="col-12 col-lg-4">
                    <label class="form-label small" for="nivelUtilizacion">Nivel de utilización</label>
                    <select class="form-select" id="nivelUtilizacion" aria-describedby="buscarCapacidadNota">
                        <option value="todos">Todos</option>
                        <option value="bajo">Menos del 80 %</option>
                        <option value="alto">Del 80 % al 89 %</option>
                        <option value="critico">Desde el 90 %</option>
                    </select>
                </div>
            </div><div class="table-responsive" tabindex="0" role="region" aria-label="Capacidad por segmento">
<table class="table table-hover align-middle mb-0"><thead class="table-light"><tr><th scope="col">Segmento</th><th scope="col">Ruta</th><th scope="col">Total</th><th scope="col">En uso</th><th scope="col">Reservada</th><th scope="col">Disponible</th><th scope="col">Utilización</th></tr></thead><tbody>
<tr><th scope="row" class="fw-normal">Segmento 1</th><td>Perú - EE. UU.</td><td>300 Gbps</td><td>291 Gbps</td><td>0 Gbps</td><td>9 Gbps</td><td>
    <span class="small text-nowrap">97 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 1" aria-valuenow="97" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-danger" style="width: 97%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 2</th><td>Perú - España</td><td>300 Gbps</td><td>288 Gbps</td><td>0 Gbps</td><td>12 Gbps</td><td>
    <span class="small text-nowrap">96 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 2" aria-valuenow="96" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-danger" style="width: 96%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 3</th><td>Perú - Japón</td><td>300 Gbps</td><td>279 Gbps</td><td>0 Gbps</td><td>21 Gbps</td><td>
    <span class="small text-nowrap">93 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 3" aria-valuenow="93" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-danger" style="width: 93%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 4</th><td>Perú - Chile</td><td>200 Gbps</td><td>170 Gbps</td><td>0 Gbps</td><td>30 Gbps</td><td>
    <span class="small text-nowrap">85 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 4" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-warning" style="width: 85%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 5</th><td>Perú - Brasil</td><td>200 Gbps</td><td>164 Gbps</td><td>0 Gbps</td><td>36 Gbps</td><td>
    <span class="small text-nowrap">82 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 5" aria-valuenow="82" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-warning" style="width: 82%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 6</th><td>Perú - Ecuador</td><td>200 Gbps</td><td>150 Gbps</td><td>0 Gbps</td><td>50 Gbps</td><td>
    <span class="small text-nowrap">75 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 6" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-secondary" style="width: 75%"></div>
    </div>
</td></tr>
<tr><th scope="row" class="fw-normal">Segmento 7</th><td>Perú - Colombia</td><td>1800 Gbps</td><td>658 Gbps</td><td>200 Gbps</td><td>942 Gbps</td><td>
    <span class="small text-nowrap">36,6 %</span>
    <div class="progress" role="progressbar" aria-label="Utilización del segmento 7" aria-valuenow="36.6" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-secondary" style="width: 36.6%"></div>
    </div>
</td></tr>
</tbody></table></div></div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">Reportar</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalIncidencias" tabindex="-1" aria-labelledby="modalIncidenciasTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalIncidenciasTitulo">Incidencias activas</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body"><p class="small text-secondary" id="buscarIncidenciaNota">La búsqueda y los filtros aún no se aplican.</p><div class="row g-3 mb-4"><div class="col-12 col-lg"><label class="form-label small" for="buscarIncidencia">Buscar</label><input class="form-control" type="search" id="buscarIncidencia" placeholder="Buscar por ID o infraestructura" aria-describedby="buscarIncidenciaNota"></div><div class="col-12 col-sm-6 col-lg-3"><label class="form-label small" for="estadoIncidencia">Estado</label><select class="form-select" id="estadoIncidencia"><option>Todos los estados</option><option>Detectada</option><option>En análisis</option><option>En atención</option></select></div><div class="col-12 col-sm-6 col-lg-3"><label class="form-label small" for="severidadIncidencia">Severidad</label><select class="form-select" id="severidadIncidencia"><option>Todas las severidades</option><option>Crítica</option><option>Alta</option><option>Media</option><option>Baja</option></select></div></div><div class="table-responsive" tabindex="0" role="region" aria-label="Listado de incidencias">
<table class="table table-hover align-middle mb-0"><thead class="table-light"><tr><th scope="col">ID de incidencia</th><th scope="col">Infraestructura</th><th scope="col">Observaciones</th><th scope="col">Segmentos afectados</th><th scope="col">Estado</th><th scope="col">Severidad</th><th scope="col">Clientes afectados</th><th scope="col">Detectado</th></tr></thead><tbody>
<tr><th scope="row" class="fw-normal">INC-001</th><td>Landing-A</td><td><details><summary class="text-decoration-underline">Descripción</summary><div class="bg-light border rounded p-2 mt-2 detail-content">Pérdida intermitente de conectividad en el enlace internacional.</div></details></td><td><details><summary class="text-decoration-underline">Segmentos</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>SEG-001</li><li>SEG-003</li></ul></div></details></td><td><span class="badge text-bg-secondary">En análisis</span></td><td><span class="badge text-bg-danger">Crítica</span></td><td><details><summary class="text-decoration-underline">Clientes</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>Empresa Andina</li><li>Red Pacífico</li></ul></div></details></td><td>17/09/2026</td></tr>
<tr><th scope="row" class="fw-normal">INC-002</th><td>Landing-B</td><td><details><summary class="text-decoration-underline">Descripción</summary><div class="bg-light border rounded p-2 mt-2 detail-content">Incremento de latencia durante las horas de mayor tráfico.</div></details></td><td><details><summary class="text-decoration-underline">Segmentos</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>SEG-002</li></ul></div></details></td><td><span class="badge text-bg-secondary">En atención</span></td><td><span class="badge text-bg-warning">Alta</span></td><td><details><summary class="text-decoration-underline">Clientes</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>Conecta Perú</li></ul></div></details></td><td>16/09/2026</td></tr>
<tr><th scope="row" class="fw-normal">INC-003</th><td>Landing-C</td><td><details><summary class="text-decoration-underline">Descripción</summary><div class="bg-light border rounded p-2 mt-2 detail-content">Degradación de señal pendiente de evaluación técnica.</div></details></td><td><details><summary class="text-decoration-underline">Segmentos</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>SEG-005</li></ul></div></details></td><td><span class="badge text-bg-secondary">Detectada</span></td><td><span class="badge text-bg-info">Media</span></td><td><details><summary class="text-decoration-underline">Clientes</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><ul class="mb-0 ps-3"><li>Servicios del Sur</li></ul></div></details></td><td>17/09/2026</td></tr>
</tbody></table></div><div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3"><span class="small text-secondary">Página 1 de 1</span><div class="d-flex gap-2" aria-label="Paginación"><button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button><button type="button" class="btn btn-outline-secondary btn-sm" disabled>Siguiente</button></div></div></div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">Reportar</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalMantenimientos" tabindex="-1" aria-labelledby="modalMantenimientosTitulo" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable modal-fullscreen-sm-down">
        <div class="modal-content">
            <div class="modal-header"><h2 class="modal-title fs-5" id="modalMantenimientosTitulo">Historial de mantenimiento</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button></div>
            <div class="modal-body"><p class="small text-secondary" id="buscarMantenimientoNota">La búsqueda y los filtros aún no se aplican.</p><div class="row g-3 mb-4"><div class="col-12 col-lg"><label class="form-label small" for="buscarMantenimiento">Buscar</label><input class="form-control" type="search" id="buscarMantenimiento" placeholder="Buscar por ID o infraestructura" aria-describedby="buscarMantenimientoNota"></div><div class="col-12 col-sm-6 col-lg-3"><label class="form-label small" for="estadoMantenimiento">Estado</label><select class="form-select" id="estadoMantenimiento"><option>Todos los estados</option><option>Pendiente</option><option>Activo</option><option>Finalizado</option></select></div><div class="col-12 col-sm-6 col-lg-3"><label class="form-label small" for="tipoMantenimiento">Tipo</label><select class="form-select" id="tipoMantenimiento"><option>Todos los tipos</option><option>Preventivo</option><option>Correctivo</option></select></div></div><div class="table-responsive" tabindex="0" role="region" aria-label="Listado de mantenimientos">
<table class="table table-hover align-middle mb-0"><thead class="table-light"><tr><th scope="col">ID de mantenimiento</th><th scope="col">Infraestructura</th><th scope="col">Servicios afectados</th><th scope="col">Tipo</th><th scope="col">Estado</th><th scope="col">Fecha</th><th scope="col">Ubicación</th><th scope="col">Información</th></tr></thead><tbody>
<tr><th scope="row" class="fw-normal">MANT-001</th><td>Landing Station A</td><td><ul class="mb-0 ps-3"><li>Internet empresarial</li><li>Transporte de datos</li></ul></td><td>Correctivo</td><td><span class="badge text-bg-secondary">Pendiente</span></td><td>10/10/2026</td><td>Lima, PE</td><td><details><summary class="text-decoration-underline">Ver detalle</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><dl class="mb-0"><dt>ID</dt><dd>MANT-001</dd><dt>Descripción</dt><dd>Revisión de conectores y recuperación del enlace.</dd><dt>Duración estimada</dt><dd>3 horas</dd><dt>Actividades realizadas</dt><dd class="mb-0">Sin actividades realizadas; mantenimiento pendiente.</dd></dl></div></details></td></tr>
<tr><th scope="row" class="fw-normal">MANT-002</th><td>Landing Station B</td><td><ul class="mb-0 ps-3"><li>Enlace internacional</li></ul></td><td>Preventivo</td><td><span class="badge text-bg-secondary">Pendiente</span></td><td>15/10/2026</td><td>Lima, PE</td><td><details><summary class="text-decoration-underline">Ver detalle</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><dl class="mb-0"><dt>ID</dt><dd>MANT-002</dd><dt>Descripción</dt><dd>Inspección y limpieza de equipos de transmisión.</dd><dt>Duración estimada</dt><dd>2 horas</dd><dt>Actividades realizadas</dt><dd class="mb-0">Sin actividades realizadas; mantenimiento pendiente.</dd></dl></div></details></td></tr>
<tr><th scope="row" class="fw-normal">MANT-003</th><td>Landing Station C</td><td><ul class="mb-0 ps-3"><li>Transporte de datos</li></ul></td><td>Correctivo</td><td><span class="badge text-bg-primary">Activo</span></td><td>17/09/2026</td><td>Lima, PE</td><td><details><summary class="text-decoration-underline">Ver detalle</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><dl class="mb-0"><dt>ID</dt><dd>MANT-003</dd><dt>Descripción</dt><dd>Sustitución de un módulo de transmisión.</dd><dt>Duración estimada</dt><dd>4 horas</dd><dt>Actividades realizadas</dt><dd class="mb-0">Diagnóstico completado. Sustitución del módulo en curso.</dd></dl></div></details></td></tr>
<tr><th scope="row" class="fw-normal">MANT-004</th><td>Landing Station A</td><td><ul class="mb-0 ps-3"><li>Internet empresarial</li></ul></td><td>Preventivo</td><td><span class="badge text-bg-success">Finalizado</span></td><td>11/09/2026</td><td>Lima, PE</td><td><details><summary class="text-decoration-underline">Ver detalle</summary><div class="bg-light border rounded p-2 mt-2 detail-content"><dl class="mb-0"><dt>ID</dt><dd>MANT-004</dd><dt>Descripción</dt><dd>Verificación periódica del sistema de respaldo.</dd><dt>Duración estimada</dt><dd>2 horas</dd><dt>Actividades realizadas</dt><dd class="mb-0">Inspección y pruebas de respaldo completadas.</dd></dl></div></details></td></tr>
</tbody></table></div><div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3"><span class="small text-secondary">Página 1 de 1</span><div class="d-flex gap-2" aria-label="Paginación"><button type="button" class="btn btn-outline-secondary btn-sm" disabled>Anterior</button><button type="button" class="btn btn-outline-secondary btn-sm" disabled>Siguiente</button></div></div></div>
            <div class="modal-footer"><a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">Reportar</a></div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
