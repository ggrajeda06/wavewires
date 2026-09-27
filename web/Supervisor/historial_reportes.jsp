<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink - Historial de reportes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <style>
        .supervisor-layout {
            display: flex;
            min-height: 100vh;
        }

        .supervisor-sidebar {
            width: 240px;
            flex-shrink: 0;
            height: 100vh;
            position: sticky;
            top: 0;
        }

        .supervisor-sidebar .nav-link {
            border-radius: .375rem;
            padding: .75rem 1rem;
        }

        .supervisor-sidebar .nav-link:hover,
        .supervisor-sidebar .nav-link:focus-visible {
            background-color: var(--bs-secondary);
        }

        .supervisor-sidebar .nav-link.active {
            background-color: var(--bs-secondary);
            font-weight: 600;
        }

        .supervisor-main {
            flex: 1;
            min-width: 0;
        }

        .reports-table {
            min-width: 600px;
        }

        .reports-table th,
        .reports-table td {
            padding: 1rem 1.5rem;
        }

        @media (max-width: 767.98px) {
            .supervisor-layout {
                flex-direction: column;
            }

            .supervisor-sidebar {
                width: 100%;
                height: auto;
                position: static;
            }
        }
    </style>
</head>
<body class="bg-light">
<div class="supervisor-layout">
    <nav class="supervisor-sidebar d-flex flex-column bg-dark p-3" aria-label="Navegación del supervisor">
        <div class="h5 text-white px-3 py-2 mb-3">OceanLink</div>
        <div class="nav flex-column gap-2 mb-4">
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/Supervisor/supervisor_home.jsp">
                Estado general de la red
            </a>
            <a class="nav-link text-white"
               href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">
                Reportes
            </a>
            <a class="nav-link text-white active" aria-current="page" href="${pageContext.request.contextPath}/Supervisor/historial_reportes.jsp">
                Historial de reportes
            </a>
        </div>
        <a class="nav-link text-white mt-auto" href="${pageContext.request.contextPath}/login.jsp?logout=1">
            Cerrar sesión
        </a>
    </nav>

    <main class="supervisor-main p-3 p-lg-4">
        <a class="btn btn-outline-secondary btn-sm mb-3"
           href="${pageContext.request.contextPath}/Supervisor/supervisor_home.jsp">&larr; Volver al inicio</a>
        <h1 class="h3 fw-bold mb-4">Historial de reportes</h1>

        <section class="card shadow-sm mb-4" aria-labelledby="tituloHistorial">
            <div class="card-body p-3 p-lg-4">
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
</body>
</html>
