# wavewires
WAVEWIRES - GRUPO 5

## Login de demostración

Ejecutar la configuración **Tomcat 10.1.59** de IntelliJ IDEA y abrir la raíz de la aplicación o `login.jsp`. En la configuración local actual: http://localhost:8080/login.jsp.

| Usuario | Contraseña | Vista |
| --- | --- | --- |
| administrador | 123 | Resumen del administrador |
| networkoperator | 123 | Estado de red |
| supervisor | 123 | Estado general de la red |
| maintence | 123 | Historial de mantenimiento |

El login conserva JSP como página de entrada. La validación y navegación son de demostración en JavaScript: no crean una sesión de servidor ni restringen el acceso directo a las vistas. La casilla «No soy un robot» es decorativa y no bloquea el ingreso.

La intro utiliza una cámara 3D con Three.js y dura aproximadamente **5,5 segundos**: caída acelerada, impacto contra la superficie, descenso con burbujas y estabilización en el fondo submarino original. Se puede omitir con **Enter, clic, toque o el botón «Omitir intro»**. El gesto de omisión no activa el formulario; después de soltar Enter, esa tecla vuelve a permitir ingresar normalmente.

El ambiente final se puede pausar y deja de animarse mientras la pestaña está oculta. Se utiliza el fondo estático si el usuario prefiere movimiento reducido, WebGL 2 no está disponible o falla la carga del renderizador. Una carga lenta tampoco bloquea el formulario ni vuelve a iniciar una intro ya omitida.

El formulario y sus accesos están en `web/login.jsp` y `web/js/login.js`. La intro se organiza en `web/js/ocean.js` (controles y carga), `web/js/ocean-motion.js` (trayectoria) y `web/js/ocean-renderer.js` (escena y efectos). Los estilos están en `web/css/login.css`.

Three.js **0.186.0** se sirve localmente desde `web/vendor/three/`, con su licencia MIT. No hace falta Node, React, un CDN ni instalar paquetes para ejecutar la aplicación. Los cambios se realizan en `web/`; IntelliJ genera el despliegue en `out/artifacts/`. Después de editar, actualizar el artefacto desplegado antes de revisar Tomcat.

Las imágenes originales, el logo SVG y sus instrucciones de generación están en [web/assets/login](web/assets/login/README.md).

Las pruebas de trayectoria y navegador están documentadas en [tests/README.md](tests/README.md).
