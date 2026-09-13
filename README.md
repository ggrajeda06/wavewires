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

La inmersión dura aproximadamente dos segundos, se puede omitir y termina en un ambiente submarino que se puede pausar. El fondo estático se utiliza cuando el usuario prefiere movimiento reducido o WebGL no está disponible. El formulario sigue funcionando si falla la animación.

Fuentes: `web/login.jsp`, `web/css/login.css`, `web/js/login.js` y `web/js/ocean.js`. Los cambios se realizan en `web/`; IntelliJ genera el despliegue en `out/artifacts/`. No hace falta Node ni instalar paquetes para ejecutar la aplicación.

Las imágenes originales, el logo SVG y sus instrucciones de generación están en [web/assets/login](web/assets/login/README.md).
