<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">

<div class="d-flex flex-column flex-md-row min-vh-100">
    <jsp:include page="sidebarSupervisor.jsp"/>
    <main class="flex-grow-1 p-3 p-lg-4 w-100" style="min-width: 0;">
        <div>
            <a class="btn btn-outline-secondary btn-sm mb-3"
               href="${pageContext.request.contextPath}/Supervisor/supervisor_home.jsp">&larr; Volver al inicio</a>
        </div>

        <h1 class="h3 fw-bold mb-4">Historial de reportes</h1>

        <section class="card shadow-sm mb-4" aria-labelledby="tituloHistorial">
            <div class="card-body p-3 p-lg-4 border-bottom">
                <h2 class="h5 mb-0" id="tituloHistorial">Historial de reportes</h2>
            </div>
            <div class="table-responsive" tabindex="0" role="region" aria-label="Historial de reportes">
                <table class="table table-hover align-middle mb-0 reports-table">
                    <caption class="visually-hidden">Reportes con su rol, encargado y fecha del reporte.</caption>
                    <thead class="table-light">
                    <tr>
                        <th scope="col">Reporte</th>
                        <th scope="col">Rol</th>
                        <th scope="col">Encargado</th>
                        <th scope="col">Fecha del reporte</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row" class="fw-medium">Reporte - 001</th>
                        <td>Administrador</td>
                        <td>Ana Pérez</td>
                        <td><time datetime="2026-09-11">11/09/2026</time></td>
                    </tr>
                    <tr>
                        <th scope="row" class="fw-medium">Reporte - 002</th>
                        <td>Operador de red</td>
                        <td>Luis García</td>
                        <td><time datetime="2026-09-12">12/09/2026</time></td>
                    </tr>
                    <tr>
                        <th scope="row" class="fw-medium">Reporte - 003</th>
                        <td>Técnico de mantenimiento</td>
                        <td>María Torres</td>
                        <td><time datetime="2026-09-13">13/09/2026</time></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>