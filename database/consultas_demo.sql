-- Ejecutar después de oceanlink_demo.sql. Solo consulta datos.
USE oceanlink_demo;
SET NAMES utf8mb4;

-- 1. Resumen compartido: Administrador y Supervisor.
SELECT * FROM v_resumen_red;

-- 2. Usuarios y roles: admin_usuarios.jsp.
SELECT u.id_usuario,u.username,u.nombre,u.correo,r.nombre AS rol,
       IF(u.estado=1,'Activo','Inactivo') AS estado
FROM usuarios u JOIN roles r ON r.id_rol=u.id_rol ORDER BY u.id_usuario;

-- 3. Landings y cantidad de segmentos: admin_landings.jsp.
SELECT l.codigo,l.nombre,l.pais,l.ciudad,l.estado,COUNT(s.id_segmento) AS segmentos
FROM landings l LEFT JOIN segmentos s ON l.id_landing IN (s.id_origen,s.id_destino)
GROUP BY l.id_landing ORDER BY l.id_landing;

-- 4. Segmentos de un landing: admin_landing_segmentos.jsp.
SET @landing = 1;
SELECT v.* FROM v_capacidad_segmentos v JOIN segmentos s USING(id_segmento)
WHERE @landing IN (s.id_origen,s.id_destino);

-- 5. Capacidad, reservas y nivel de uso. En Administración: Gbps / 1000 = Tbps.
SELECT *,ROUND(capacidad_total_gbps/1000,3) AS capacidad_total_tbps,
       CASE WHEN utilizacion_pct >= 90 THEN 'Crítico'
            WHEN utilizacion_pct >= 80 THEN 'Alto' ELSE 'Bajo' END AS nivel_utilizacion
FROM v_capacidad_segmentos ORDER BY utilizacion_pct DESC;

-- 6. Clientes y segmentos contratados: clientes.jsp.
SELECT c.codigo,c.razon_social,c.fecha_registro,c.estado,
       COALESCE(GROUP_CONCAT(DISTINCT v.segmento ORDER BY v.segmento SEPARATOR ', '),'Sin servicios activos') AS segmentos_contratados
FROM clientes c LEFT JOIN v_servicios_clientes v ON v.id_cliente=c.id_cliente AND v.estado='Activo'
GROUP BY c.id_cliente ORDER BY c.id_cliente;

-- 7. Solicitudes con disponibilidad actual: solicitudes.jsp.
-- Es una evaluación informativa; no descuenta otra vez contratos ya activados.
SELECT q.codigo,c.razon_social,q.estado,v.codigo AS segmento,v.ruta,q.capacidad_gbps,
       v.capacidad_disponible_gbps,
       CASE WHEN q.estado IN ('Activa','Provisionada') THEN 'Ya provisionada'
            WHEN q.estado='Rechazada' THEN 'Rechazada'
            WHEN v.estado <> 'Operativo' THEN 'Revisar estado del segmento'
            WHEN q.capacidad_gbps <= v.capacidad_disponible_gbps THEN 'Hay capacidad'
            ELSE 'Capacidad insuficiente' END AS evaluacion
FROM solicitudes q JOIN clientes c ON c.id_cliente=q.id_cliente
JOIN v_capacidad_segmentos v ON v.id_segmento=q.id_segmento ORDER BY q.id_solicitud;

-- 8. Historial de servicios caducados y detalle por cliente.
SELECT s.codigo,s.nombre,COUNT(v.id_servicio) AS servicios_caducados
FROM segmentos s LEFT JOIN v_servicios_clientes v ON v.id_segmento=s.id_segmento AND v.estado='Caducado'
GROUP BY s.id_segmento;
SELECT * FROM v_servicios_clientes WHERE estado='Caducado' ORDER BY fecha_fin DESC;

-- 9. Incidencias activas con sus segmentos (se evita multiplicar filas por cliente).
SELECT i.codigo,l.nombre AS landing,i.estado,i.severidad,i.observaciones,i.fecha_deteccion,
       (SELECT GROUP_CONCAT(s.codigo ORDER BY s.codigo SEPARATOR ', ')
        FROM incidencia_segmentos x JOIN segmentos s ON s.id_segmento=x.id_segmento
        WHERE x.id_incidencia=i.id_incidencia) AS segmentos_afectados,
       (SELECT GROUP_CONCAT(c.razon_social ORDER BY c.razon_social SEPARATOR ', ')
        FROM v_clientes_afectados c WHERE c.id_incidencia=i.id_incidencia) AS clientes_afectados
FROM incidencias i JOIN landings l ON l.id_landing=i.id_landing
WHERE i.estado <> 'Cerrada' ORDER BY i.fecha_deteccion DESC;

-- 10. Historial del operador: se conservan las incidencias cerradas.
SELECT i.codigo,l.nombre AS landing,i.observaciones,i.fecha_deteccion,i.fecha_cierre
FROM incidencias i JOIN landings l ON l.id_landing=i.id_landing WHERE i.estado='Cerrada';

-- 11. Restauraciones. El formulario actual introduce la fecha programada.
SELECT r.codigo,i.codigo AS incidencia,r.fecha_programada,r.fecha_real,r.estado,u.nombre AS operador
FROM restauraciones r JOIN incidencias i ON i.id_incidencia=r.id_incidencia
JOIN usuarios u ON u.id_usuario=r.id_operador;

-- 12. Mantenimientos, ubicación y actividades: coordinador y supervisor.
SELECT m.codigo,m.nombre,m.descripcion,l.nombre AS infraestructura,
       CONCAT(l.ciudad,', ',l.pais) AS ubicacion,m.tipo,m.estado,m.fecha_programada,
       m.duracion_estimada_min,m.actividades_realizadas,u.nombre AS coordinador,
       (SELECT GROUP_CONCAT(v.codigo ORDER BY v.codigo SEPARATOR ', ')
        FROM mantenimiento_servicios x JOIN servicios v ON v.id_servicio=x.id_servicio
        WHERE x.id_mantenimiento=m.id_mantenimiento) AS servicios_afectados
FROM mantenimientos m JOIN landings l ON l.id_landing=m.id_landing
JOIN usuarios u ON u.id_usuario=m.id_coordinador ORDER BY m.fecha_programada;

-- 13. Historial de reportes: reportes_supervisor.jsp.
SELECT p.codigo,r.nombre AS rol,u.nombre AS encargado,d.nombre AS destinatario,
       p.fecha_reporte,p.asunto,p.descripcion
FROM reportes p JOIN usuarios u ON u.id_usuario=p.id_autor
JOIN roles r ON r.id_rol=p.id_rol_autor
JOIN usuarios d ON d.id_usuario=p.id_destinatario ORDER BY p.fecha_reporte DESC;

-- 14. Controles: estas cuatro consultas deben devolver CERO filas.
SELECT * FROM v_capacidad_segmentos WHERE capacidad_disponible_gbps < 0;
SELECT i.codigo,s.codigo AS segmento_incorrecto
FROM incidencia_segmentos x JOIN incidencias i ON i.id_incidencia=x.id_incidencia
JOIN segmentos s ON s.id_segmento=x.id_segmento
WHERE i.id_landing NOT IN (s.id_origen,s.id_destino);
SELECT m.codigo,v.servicio AS servicio_incorrecto
FROM mantenimiento_servicios x JOIN mantenimientos m ON m.id_mantenimiento=x.id_mantenimiento
JOIN v_servicios_clientes v ON v.id_servicio=x.id_servicio
JOIN segmentos s ON s.id_segmento=v.id_segmento
WHERE m.id_landing NOT IN (s.id_origen,s.id_destino);
SELECT r.codigo FROM restauraciones r JOIN incidencias i ON i.id_incidencia=r.id_incidencia
WHERE r.fecha_programada < i.fecha_deteccion
   OR (r.estado='Completada' AND (i.estado <> 'Cerrada' OR r.fecha_real <> i.fecha_cierre));
