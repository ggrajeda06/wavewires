# Verificación del login

Estas herramientas son solo para desarrollo. La aplicación continúa ejecutándose en Tomcat sin Node ni dependencias npm.

## Trayectoria de cámara

Con Node.js 22 o posterior:

```powershell
node --test tests/ocean-motion.test.mjs
```

Verifica aceleración, continuidad de velocidad al entrar al agua, frenado, ausencia de giros completos y posición final estable al terminar u omitir.

## Navegador

Con Tomcat ejecutándose, Chrome instalado y el paquete `playwright` disponible para Node:

```powershell
node tests/login-intro.cjs
```

Si Playwright está instalado fuera del proyecto, establecer `PLAYWRIGHT_MODULE` con la ruta absoluta a su carpeta dentro de `node_modules`. No es necesario instalarlo en este repositorio.

Variables opcionales:

- `LOGIN_BASE_URL`: origen y contexto de la aplicación, por defecto `http://localhost:8080`.
- `LOGIN_BROWSER`: canal de navegador de Playwright, por defecto `chrome`.
- `LOGIN_QA_OUTPUT`: carpeta para las capturas; por defecto `wavewires-login-3d-qa` dentro del directorio temporal del sistema.

Las pruebas recorren caída, impacto y estabilización con un reloj de fotogramas controlado; verifican Enter sostenido, clic, doble clic, botón y toque; comprueban los cuatro roles y la salida; simulan movimiento reducido, carga lenta, recursos fallidos y pérdida de contexto gráfico. También guardan capturas de escritorio y móvil para revisar el agua y el encuadre final.
