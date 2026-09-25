<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OceanLink - Reportes</title>
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

        .report-description {
            min-height: 180px;
            resize: vertical;
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
            <a class="nav-link text-white active" aria-current="page"
               href="${pageContext.request.contextPath}/Supervisor/reportes_supervisor.jsp">
                Reportes
            </a>
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/Supervisor/historial_reportes.jsp">
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
        <h1 class="h3 fw-bold mb-4">Reportes</h1>

        <section class="card shadow-sm" aria-labelledby="tituloCrearReporte">
            <div class="card-body p-3 p-lg-4">
                <h2 class="h5 mb-3" id="tituloCrearReporte">Crear reporte</h2>
                <p class="small text-secondary mb-4" id="notaFormulario">
                    El envío de reportes todavía no está disponible; los datos ingresados no se guardan.
                </p>
                <!-- Maqueta sin envío: los campos no pertenecen a un formulario con acción. -->
                <div role="group" aria-labelledby="tituloCrearReporte" aria-describedby="notaFormulario">
                    <div class="row g-3 align-items-end mb-3">
                        <div class="col-12 col-md-5">
                            <label class="form-label" for="destinatario">Para</label>
                            <input type="text" class="form-control" id="destinatario" placeholder="Nombre del destinatario">
                        </div>
                        <div class="col-12 col-md-5">
                            <label class="form-label" for="asunto">Asunto</label>
                            <input type="text" class="form-control" id="asunto" placeholder="Asunto del reporte">
                        </div>
                        <div class="col-12 col-md-2 d-grid">
                            <button type="button" class="btn btn-outline-secondary" disabled aria-describedby="notaFormulario">Enviar</button>
                        </div>
                    </div>
                    <label class="form-label" for="descripcion">Descripción</label>
                    <textarea class="form-control report-description" id="descripcion" rows="6"
                              placeholder="Escribe el detalle del reporte"></textarea>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
