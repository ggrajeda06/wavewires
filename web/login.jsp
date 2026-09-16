<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#031a2b">
  <title>WaveWires — Iniciar sesión</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/login/mark.svg">
  <link rel="preload" as="image" href="${pageContext.request.contextPath}/assets/login/underwater.png">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <script src="${pageContext.request.contextPath}/js/login.js" defer></script>
  <script src="${pageContext.request.contextPath}/js/ocean.js" defer></script>
</head>
<body data-context-path="${pageContext.request.contextPath}">
  <div class="ocean" aria-hidden="true">
    <canvas id="ocean-canvas" data-underwater="${pageContext.request.contextPath}/assets/login/underwater.png" data-surface="${pageContext.request.contextPath}/assets/login/surface.png"></canvas>
    <div class="ocean-shade"></div>
  </div>
  <div class="scene-controls">
    <button class="scene-button" id="skip-intro" type="button" hidden>Omitir intro <span aria-hidden="true">↗</span></button>
    <button class="scene-button" id="toggle-motion" type="button" aria-pressed="false" hidden>Pausar ambiente <span aria-hidden="true">Ⅱ</span></button>
  </div>
  <p id="intro-hint" class="intro-hint" hidden>Clic o Enter para omitir</p>
  <div class="login-shell">
    <header class="site-header">
      <a class="brand" href="${pageContext.request.contextPath}/login.jsp" aria-label="WaveWires, inicio">
        <img src="${pageContext.request.contextPath}/assets/login/mark.svg" width="51" height="39" alt="">
        <span>Wave<span class="brand-light">Wires</span><span class="brand-dot">.</span></span>
      </a>
      <span class="header-caption"><span class="status-dot"></span> REDES QUE NOS CONECTAN</span>
    </header>
    <main class="login-main">
      <section class="login-panel" aria-labelledby="login-title">
        <p class="eyebrow"><span></span> ACCESO A LA PLATAFORMA</p>
        <h1 id="login-title">Bienvenido<br>a bordo<span class="title-dot">.</span></h1>
        <p class="introduction">Tu red, bajo control. Conéctate para continuar.</p>
        <form id="login-form" novalidate>
          <div class="form-field">
            <label for="username">Usuario</label>
            <div class="input-wrap">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><circle cx="12" cy="8" r="3.5"/><path d="M5 21v-2a7 7 0 0 1 14 0v2"/></svg>
              <input id="username" name="username" type="text" placeholder="Ingresa tu usuario" autocomplete="username" autocapitalize="none" spellcheck="false" required aria-describedby="login-error">
            </div>
          </div>
          <div class="form-field">
            <label for="password">Contraseña</label>
            <div class="input-wrap">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><rect x="5" y="10" width="14" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/><path d="M12 14v3"/></svg>
              <input id="password" name="password" type="password" placeholder="Ingresa tu contraseña" autocomplete="current-password" required aria-describedby="login-error">
              <button id="toggle-password" class="password-toggle" type="button" aria-label="Mostrar contraseña" aria-pressed="false" aria-controls="password">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"/><circle cx="12" cy="12" r="2.5"/><path class="eye-slash" d="m4 3 16 18"/></svg>
              </button>
            </div>
          </div>
          <div class="verification">
            <label class="checkbox-label"><input type="checkbox" id="human-check"><span class="custom-check" aria-hidden="true"></span><span>No soy un robot</span></label>
            <svg class="verification-mark" viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><path d="m16 3 10 4v8c0 6-10 12-10 12S6 21 6 15V7l10-4Z"/><path d="m11 15 3 3 7-7"/></svg>
          </div>
          <p id="login-error" class="form-error" role="alert" aria-live="polite"></p>
          <button class="submit-button" type="submit"><span>Ingresar</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="M4 12h16m-6-6 6 6-6 6"/></svg></button>
        </form>
        <noscript><p class="no-script">Activa JavaScript para ingresar a las vistas de WaveWires.</p></noscript>
        <p class="panel-caption"><span class="caption-line"></span> CONECTAMOS LO QUE NO VES</p>
      </section>
      <aside class="ocean-caption" aria-label="WaveWires">
        <span class="ocean-coordinate">01 / BAJO LA SUPERFICIE</span>
        <p>Un océano de<br><em>conexiones.</em></p>
        <span class="ocean-caption-line"></span>
      </aside>
    </main>
    <footer class="site-footer"><span>© 2026 WaveWires</span><span>Infraestructura que conecta el mundo.</span></footer>
  </div>
</body>
</html>
