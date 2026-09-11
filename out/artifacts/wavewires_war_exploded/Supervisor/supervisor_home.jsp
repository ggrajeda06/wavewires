<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Estado general de la red</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>

<body>

<div class="row g-0 min-vh-100">

    <jsp:include page="/Supervisor/Components_supervisor/sidebar.jsp"/>

    <main class="col p-4">

        <h2 class="mb-4">Estado general de la red</h2>

        <!-- Ocupa todo el ancho -->
        <jsp:include page="/Supervisor/Components_supervisor/capacidad_red.jsp"/>
        <jsp:include page="/Supervisor/Components_supervisor/modal_capacidad.jsp"/>

        <!-- Los otros dos aparecen en la misma fila -->
        <div class="row g-4">

            <div class="col-12 col-lg-6">
                <jsp:include page="/Supervisor/Components_supervisor/incidencias.jsp"/>
            </div>

            <div class="col-12 col-lg-6">
                <jsp:include page="/Supervisor/Components_supervisor/mantenimientos.jsp"/>
            </div>

        </div>

    </main>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
