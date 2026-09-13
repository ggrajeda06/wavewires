(() => {
  'use strict';
  // Demo navigation only. These credentials do not protect the JSP views.
  const destinations = Object.freeze({
    administrador: '/Administrador/admin_resumen.jsp',
    networkoperator: '/NetworkOperator/index.jsp',
    supervisor: '/Supervisor/supervisor_home.jsp',
    maintence: '/Maintence/MC_template.jsp'
  });
  const form = document.getElementById('login-form');
  const username = document.getElementById('username');
  const password = document.getElementById('password');
  const error = document.getElementById('login-error');
  const toggle = document.getElementById('toggle-password');
  const submit = form.querySelector('[type="submit"]');
  const contextPath = document.body.dataset.contextPath;
  toggle.addEventListener('click', () => {
    const visible = password.type === 'password';
    password.type = visible ? 'text' : 'password';
    toggle.setAttribute('aria-pressed', String(visible));
    toggle.setAttribute('aria-label', visible ? 'Ocultar contraseña' : 'Mostrar contraseña');
  });
  function clearError() {
    error.textContent = '';
    username.removeAttribute('aria-invalid');
    password.removeAttribute('aria-invalid');
  }
  form.addEventListener('input', clearError);
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    clearError();
    const user = username.value.trim().toLowerCase();
    if (!user || !password.value) {
      error.textContent = 'Ingresa tu usuario y contraseña para continuar.';
      const missing = !user ? username : password;
      missing.setAttribute('aria-invalid', 'true');
      missing.focus();
      return;
    }
    if (!Object.hasOwn(destinations, user) || password.value !== '123') {
      error.textContent = 'Usuario o contraseña incorrectos. Inténtalo de nuevo.';
      username.setAttribute('aria-invalid', 'true');
      password.setAttribute('aria-invalid', 'true');
      password.focus();
      return;
    }
    submit.disabled = true;
    submit.querySelector('span').textContent = 'Ingresando…';
    window.location.assign(contextPath + destinations[user]);
  });
  // Restore the form when returning through the browser's back/forward cache.
  window.addEventListener('pageshow', () => {
    submit.disabled = false;
    submit.querySelector('span').textContent = 'Ingresar';
    password.value = '';
    password.type = 'password';
    toggle.setAttribute('aria-pressed', 'false');
    toggle.setAttribute('aria-label', 'Mostrar contraseña');
    clearError();
  });
})();
