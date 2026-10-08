<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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
