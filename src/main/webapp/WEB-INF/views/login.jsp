<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanLink - Login</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body>

    <div class="bg-login px-4 px-md-5 py-4">

        <!-- Header / Logo -->
        <header class="d-flex justify-content-between align-items-center">
            <div class="fw-bold fs-4 d-flex align-items-center gap-1">
                <span>OceanLink</span>
            </div>
        </header>

        <!-- Contenido Central -->
        <main class="row align-items-center my-auto">


            <!-- Columna Formulario -->
            <div class="col-12 col-md-6 col-lg-4 offset-lg-1 my-4">
                <span class="text-uppercase text-white-50 text-tracking d-block mb-2">— ACCESO A LA PLATAFORMA</span>
                <h1 class="display-4 font-weight-normal mb-1">Bienvenido<br>a bordo!</h1>
                <p class="text-white-50 small mb-4">Tu red, bajo control.</p>


                <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                    <!-- Campo Correo -->
                    <div class="mb-3">
                        <label for="correo" class="form-label small fw-semibold">Correo</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom border-end-0"><i class="bi bi-person"></i></span>
                            <input type="email" class="form-control form-control-custom border-start-0" id="correo" name="correo" placeholder="Ingresa tu correo" required>
                        </div>
                    </div>

                    <!-- Campo Contraseña -->
                    <div class="mb-4">
                        <label for="contrasenia" class="form-label small fw-semibold">Contraseña</label>
                        <div class="input-group">
                            <span class="input-group-text input-group-text-custom border-end-0"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control form-control-custom border-start-0" id="contrasenia" name="contrasenia" placeholder="Ingresa tu contraseña" required>
                        </div>
                    </div>

                    <!-- Botón submit -->
                    <button type="submit" class="btn btn-submit w-100 py-2.5 d-flex justify-content-between align-items-center">
                        <span>Ingresar</span>
                        <i class="bi bi-arrow-right"></i>
                    </button>
                </form>

                <span class="text-uppercase text-white-50 text-tracking d-block mt-4" style="font-size: 0.65rem;">— CONECTAMOS LO QUE NO VES</span>
                <div class="login-mensajes">

                    <% if (request.getAttribute("error") != null) { %>
                    <p class="login-mensaje login-mensaje-error" role="alert">
                        <i  aria-hidden="true"></i>
                        ${requestScope.error}
                    </p>
                    <% } %>

                    <% if (request.getAttribute("mensajeFlash") != null) { %>
                    <p class="login-mensaje login-mensaje-exito" role="status">
                        <i  aria-hidden="true"></i>
                        ${requestScope.mensajeFlash}
                    </p>
                    <% } %>

                </div>
            </div>


        </main>

        <footer class="d-flex justify-content-between text-white-50 small" style="font-size: 0.75rem;">
            <span>© 2026 OceanLink</span>
            <span>Infraestructura que conecta el mundo.</span>
        </footer>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>