-- OceanLink / WaveWires: base sencilla para presentar las vistas del proyecto.
-- MySQL 8.0.16 o superior. Archivo UTF-8. Todos los datos son ficticios.
-- Ejecutar UNA VEZ sobre una base nueva. No borra ni migra oceanlink_db.
-- No usar --force: si ya existe oceanlink_demo, detener la ejecución.
CREATE DATABASE oceanlink_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE oceanlink_demo;
SET NAMES utf8mb4;
-- Fechas de demostración expresadas en hora de Lima (DATETIME, sin conversión).

-- 1. Acceso: los mismos cinco roles del borrador bd.txt.
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL COMMENT 'NULL = sin credencial, no permite iniciar sesión',
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    id_rol INT NOT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol),
    CHECK (estado IN (0,1))
) ENGINE=InnoDB;

-- 2. Infraestructura. Cada segmento conecta exactamente dos landings.
CREATE TABLE landings (
    id_landing INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(80) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    estado ENUM('Operativa','Degradada','Mantenimiento','Fuera de servicio') NOT NULL DEFAULT 'Operativa'
) ENGINE=InnoDB;

CREATE TABLE segmentos (
    id_segmento INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    id_origen INT NOT NULL,
    id_destino INT NOT NULL,
    capacidad_total_gbps DECIMAL(12,3) NOT NULL,
    capacidad_reservada_gbps DECIMAL(12,3) NOT NULL DEFAULT 0,
    estado ENUM('Operativo','Degradado','Mantenimiento','Fuera de servicio') NOT NULL DEFAULT 'Operativo',
    FOREIGN KEY (id_origen) REFERENCES landings(id_landing),
    FOREIGN KEY (id_destino) REFERENCES landings(id_landing),
    CHECK (id_origen <> id_destino),
    CHECK (capacidad_total_gbps > 0),
    CHECK (capacidad_reservada_gbps >= 0 AND capacidad_reservada_gbps <= capacidad_total_gbps)
) ENGINE=InnoDB;

-- 3. Clientes y solicitudes. Una solicitud pide capacidad en un segmento.
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    razon_social VARCHAR(150) NOT NULL,
    fecha_registro DATE NOT NULL,
    estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB;

CREATE TABLE solicitudes (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    id_cliente INT NOT NULL,
    id_segmento INT NOT NULL,
    capacidad_gbps DECIMAL(12,3) NOT NULL,
    estado ENUM('Registrada','En evaluación','Aprobada','Provisionada','Activa','Rechazada','Pendiente por capacidad') NOT NULL DEFAULT 'Registrada',
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_responsable INT NOT NULL,
    observaciones TEXT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_segmento) REFERENCES segmentos(id_segmento),
    FOREIGN KEY (id_responsable) REFERENCES usuarios(id_usuario),
    CHECK (capacidad_gbps > 0)
) ENGINE=InnoDB;

-- Un servicio representa una solicitud contratada. No duplicar cliente/capacidad.
-- Una solicitud como máximo genera un servicio. El historial conserva los caducados.
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    id_solicitud INT NOT NULL UNIQUE,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL COMMENT 'Fin efectivo; NULL mientras está activo',
    estado ENUM('Activo','Caducado','Cancelado') NOT NULL DEFAULT 'Activo',
    FOREIGN KEY (id_solicitud) REFERENCES solicitudes(id_solicitud),
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CHECK ((estado = 'Activo' AND fecha_fin IS NULL)
        OR (estado IN ('Caducado','Cancelado') AND fecha_fin IS NOT NULL))
) ENGINE=InnoDB;

-- 4. Operación de red. Una incidencia puede afectar varios segmentos.
CREATE TABLE incidencias (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    id_landing INT NOT NULL,
    severidad ENUM('Crítica','Alta','Media','Baja') NOT NULL,
    estado ENUM('Detectada','En análisis','En reparación','Cerrada') NOT NULL DEFAULT 'Detectada',
    observaciones TEXT NOT NULL,
    fecha_deteccion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre DATETIME NULL,
    id_operador INT NOT NULL,
    FOREIGN KEY (id_landing) REFERENCES landings(id_landing),
    FOREIGN KEY (id_operador) REFERENCES usuarios(id_usuario),
    CHECK (fecha_cierre IS NULL OR fecha_cierre >= fecha_deteccion),
    CHECK ((estado = 'Cerrada' AND fecha_cierre IS NOT NULL)
        OR (estado <> 'Cerrada' AND fecha_cierre IS NULL))
) ENGINE=InnoDB;

CREATE TABLE incidencia_segmentos (
    id_incidencia INT NOT NULL,
    id_segmento INT NOT NULL,
    PRIMARY KEY (id_incidencia, id_segmento),
    FOREIGN KEY (id_incidencia) REFERENCES incidencias(id_incidencia),
    FOREIGN KEY (id_segmento) REFERENCES segmentos(id_segmento)
) ENGINE=InnoDB;

CREATE TABLE restauraciones (
    id_restauracion INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    id_incidencia INT NOT NULL UNIQUE,
    fecha_programada DATETIME NOT NULL,
    fecha_real DATETIME NULL,
    estado ENUM('Programada','Completada','Cancelada') NOT NULL DEFAULT 'Programada',
    id_operador INT NOT NULL,
    observaciones TEXT NULL,
    FOREIGN KEY (id_incidencia) REFERENCES incidencias(id_incidencia),
    FOREIGN KEY (id_operador) REFERENCES usuarios(id_usuario),
    CHECK ((estado = 'Completada' AND fecha_real IS NOT NULL)
        OR (estado <> 'Completada' AND fecha_real IS NULL))
) ENGINE=InnoDB;

-- 5. Mantenimiento. La ubicación se obtiene del landing, no se repite.
CREATE TABLE mantenimientos (
    id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    id_landing INT NOT NULL,
    descripcion TEXT NOT NULL,
    tipo ENUM('Preventivo','Correctivo') NOT NULL,
    estado ENUM('Pendiente','Activo','Finalizado') NOT NULL DEFAULT 'Pendiente',
    fecha_programada DATETIME NOT NULL,
    duracion_estimada_min INT NOT NULL,
    fecha_fin DATETIME NULL,
    actividades_realizadas TEXT NULL,
    id_coordinador INT NOT NULL,
    FOREIGN KEY (id_landing) REFERENCES landings(id_landing),
    FOREIGN KEY (id_coordinador) REFERENCES usuarios(id_usuario),
    CHECK (duracion_estimada_min > 0),
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_programada),
    CHECK ((estado = 'Finalizado' AND fecha_fin IS NOT NULL
            AND actividades_realizadas IS NOT NULL AND CHAR_LENGTH(TRIM(actividades_realizadas)) > 0)
        OR (estado <> 'Finalizado' AND fecha_fin IS NULL))
) ENGINE=InnoDB;

CREATE TABLE mantenimiento_servicios (
    id_mantenimiento INT NOT NULL,
    id_servicio INT NOT NULL,
    PRIMARY KEY (id_mantenimiento, id_servicio),
    FOREIGN KEY (id_mantenimiento) REFERENCES mantenimientos(id_mantenimiento),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
) ENGINE=InnoDB;

-- 6. Reportes internos: autor, destinatario y rol al momento de emitir.
CREATE TABLE reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    id_autor INT NOT NULL,
    id_rol_autor INT NOT NULL,
    id_destinatario INT NOT NULL,
    asunto VARCHAR(180) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_reporte DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_autor) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_rol_autor) REFERENCES roles(id_rol),
    FOREIGN KEY (id_destinatario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;

-- DATOS DE DEMOSTRACIÓN. Se carga un conjunto consistente, no todos los mocks.
START TRANSACTION;
INSERT INTO roles VALUES
(1,'Administrador'),(2,'Capacity Planner'),(3,'Network Operator'),
(4,'Maintenance Coordinator'),(5,'Supervisor');

INSERT INTO usuarios (id_usuario,username,nombre,correo,id_rol) VALUES
(1,'admin','Ana Pérez','ana@example.com',1),
(2,'planner','Carlos Ruiz','carlos@example.com',2),
(3,'operador','Luis García','luis@example.com',3),
(4,'mantenimiento','María Torres','maria@example.com',4),
(5,'supervisor','Diego López','diego@example.com',5);

INSERT INTO landings VALUES
(1,'LS-001','Lurín CLS','Perú','Lima','Operativa'),
(2,'LS-002','Chimbote CLS','Perú','Áncash','Operativa'),
(3,'LS-003','Arica CLS','Chile','Arica','Degradada'),
(4,'LS-004','Valparaíso CLS','Chile','Valparaíso','Operativa'),
(5,'LS-005','Las Toninas CLS','Argentina','Buenos Aires','Mantenimiento'),
(6,'LS-006','Miami CLS','Estados Unidos','Miami','Operativa'),
(7,'LS-007','Bilbao CLS','España','Bilbao','Operativa'),
(8,'LS-008','Chikura CLS','Japón','Chikura','Operativa');

INSERT INTO segmentos VALUES
(1,'SEG-001','Segmento 1',1,6,500,20,'Operativo'),
(2,'SEG-002','Segmento 2',1,7,500,30,'Operativo'),
(3,'SEG-003','Segmento 3',1,8,500,20,'Operativo'),
(4,'SEG-004','Segmento 4',2,3,200,10,'Degradado'),
(5,'SEG-005','Segmento 5',4,5,200,0,'Mantenimiento');

INSERT INTO clientes VALUES
(1,'CLI-001','OAC S.A.C.','2026-08-14','Activo'),
(2,'CLI-002','HYDRA S.A.C.','2022-10-13','Activo'),
(3,'CLI-003','SIES S.A.C.','2024-06-01','Inactivo');

INSERT INTO solicitudes VALUES
(1,'SOL-001',1,1,100,'Activa','2026-08-15 09:00:00',2,'Contrato vigente'),
(2,'SOL-002',2,2,400,'Activa','2026-08-15 10:00:00',2,'Contrato vigente'),
(3,'SOL-003',2,3,465,'Activa','2026-08-16 09:00:00',2,'Contrato vigente'),
(4,'SOL-004',1,4,80,'Activa','2026-08-16 10:00:00',2,'Contrato vigente'),
(5,'SOL-005',1,5,60,'Activa','2026-08-17 09:00:00',2,'Contrato afectado por mantenimiento'),
(6,'SOL-006',3,1,70,'Provisionada','2026-06-01 09:00:00',2,'Servicio posteriormente caducado'),
(7,'SOL-007',3,2,60,'Provisionada','2026-06-01 10:00:00',2,'Servicio posteriormente caducado'),
(8,'SOL-008',1,1,30,'Registrada','2026-09-17 09:00:00',2,NULL),
(9,'SOL-009',2,2,100,'Pendiente por capacidad','2026-09-17 10:00:00',2,'Solo quedan 70 Gbps libres'),
(10,'SOL-010',1,4,20,'En evaluación','2026-09-18 09:00:00',2,NULL),
(11,'SOL-011',1,5,500,'Rechazada','2026-09-18 10:00:00',2,'Supera el total del segmento');

INSERT INTO servicios VALUES
(1,'SRV-001',1,'2026-08-16 09:00:00',NULL,'Activo'),
(2,'SRV-002',2,'2026-08-16 10:00:00',NULL,'Activo'),
(3,'SRV-003',3,'2026-08-17 09:00:00',NULL,'Activo'),
(4,'SRV-004',4,'2026-08-17 10:00:00',NULL,'Activo'),
(5,'SRV-005',5,'2026-08-18 09:00:00',NULL,'Activo'),
(6,'SRV-006',6,'2026-06-02 09:00:00','2026-08-01 18:00:00','Caducado'),
(7,'SRV-007',7,'2026-06-02 10:00:00','2026-08-01 18:00:00','Caducado');

INSERT INTO incidencias VALUES
(1,'INC-001',1,'Crítica','En análisis','Pérdida intermitente de conectividad.','2026-09-17 08:00:00',NULL,3),
(2,'INC-002',3,'Alta','En reparación','Degradación de señal en Arica.','2026-09-16 10:00:00',NULL,3),
(3,'INC-003',5,'Media','Detectada','Conectores pendientes de revisión.','2026-09-17 11:00:00',NULL,3),
(4,'INC-004',1,'Baja','Cerrada','Interrupción resuelta tras revisión.','2026-09-10 08:00:00','2026-09-11 12:00:00',3);
INSERT INTO incidencia_segmentos VALUES (1,1),(1,3),(2,4),(3,5),(4,2);
INSERT INTO restauraciones VALUES
(1,'RES-001',2,'2026-09-19 12:00:00',NULL,'Programada',3,'Revisión del enlace degradado'),
(2,'RES-002',4,'2026-09-11 12:00:00','2026-09-11 12:00:00','Completada',3,'Conectividad recuperada');

INSERT INTO mantenimientos VALUES
(1,'MANT-001','Revisión de conectores',1,'Inspección de conectores del landing.','Preventivo','Pendiente','2026-10-10 09:00:00',120,NULL,NULL,4),
(2,'MANT-002','Reparación en Arica',3,'Revisión de la señal degradada.','Correctivo','Pendiente','2026-10-15 08:00:00',180,NULL,NULL,4),
(3,'MANT-003','Cambio de módulo',5,'Sustitución programada del módulo.','Correctivo','Activo','2026-09-18 08:00:00',240,NULL,'Diagnóstico inicial realizado.',4),
(4,'MANT-004','Inspección de Lurín',1,'Inspección preventiva completada.','Preventivo','Finalizado','2026-09-05 09:00:00',60,'2026-09-05 10:00:00','Limpieza y verificación de conectores.',4);
INSERT INTO mantenimiento_servicios VALUES (1,1),(1,2),(1,3),(2,4),(3,5),(4,1);
INSERT INTO reportes VALUES
(1,'REP-001',1,1,5,'Inventario de infraestructura','Se revisaron los cinco segmentos registrados.','2026-09-11 15:00:00'),
(2,'REP-002',3,3,5,'Seguimiento de incidencias','Se reportan tres incidencias abiertas para seguimiento.','2026-09-18 12:00:00'),
(3,'REP-003',4,4,5,'Plan de mantenimiento','Dos intervenciones pendientes y una intervención activa.','2026-09-18 13:00:00');
COMMIT;

-- VISTAS: valores compartidos por Administrador, Capacity Planner y Supervisor.
-- Uso = capacidad contratada de servicios activos, no tráfico medido en equipos.
CREATE VIEW v_capacidad_segmentos AS
SELECT s.id_segmento, s.codigo, s.nombre,
       CONCAT(o.pais,' - ',d.pais) AS ruta,
       o.nombre AS origen, d.nombre AS destino, s.estado,
       s.capacidad_total_gbps,
       COALESCE(u.en_uso_gbps,0) AS capacidad_usada_gbps,
       s.capacidad_reservada_gbps,
       s.capacidad_total_gbps - COALESCE(u.en_uso_gbps,0) - s.capacidad_reservada_gbps AS capacidad_disponible_gbps,
       ROUND(100 * COALESCE(u.en_uso_gbps,0) / s.capacidad_total_gbps,2) AS utilizacion_pct
FROM segmentos s
JOIN landings o ON o.id_landing=s.id_origen
JOIN landings d ON d.id_landing=s.id_destino
LEFT JOIN (
    SELECT q.id_segmento, SUM(q.capacidad_gbps) AS en_uso_gbps
    FROM servicios v JOIN solicitudes q ON q.id_solicitud=v.id_solicitud
    WHERE v.estado='Activo' GROUP BY q.id_segmento
) u ON u.id_segmento=s.id_segmento;

CREATE VIEW v_servicios_clientes AS
SELECT v.id_servicio, v.codigo AS servicio, c.id_cliente, c.razon_social,
       s.id_segmento, s.codigo AS segmento, q.capacidad_gbps,
       v.estado, v.fecha_inicio, v.fecha_fin
FROM servicios v
JOIN solicitudes q ON q.id_solicitud=v.id_solicitud
JOIN clientes c ON c.id_cliente=q.id_cliente
JOIN segmentos s ON s.id_segmento=q.id_segmento;

-- Afectación inferida por segmento y vigencia temporal del servicio.
-- En incidencias cerradas se conserva la afectación de servicios que coincidieron
-- con el intervalo del incidente, aunque hoy estén caducados.
CREATE VIEW v_clientes_afectados AS
SELECT DISTINCT i.id_incidencia, i.codigo AS incidencia, c.id_cliente, c.razon_social
FROM incidencias i
JOIN incidencia_segmentos x ON x.id_incidencia=i.id_incidencia
JOIN solicitudes q ON q.id_segmento=x.id_segmento
JOIN servicios v ON v.id_solicitud=q.id_solicitud
JOIN clientes c ON c.id_cliente=q.id_cliente
WHERE v.fecha_inicio <= COALESCE(i.fecha_cierre,CURRENT_TIMESTAMP)
  AND (v.fecha_fin IS NULL OR v.fecha_fin >= i.fecha_deteccion);

CREATE VIEW v_resumen_red AS
SELECT COUNT(*) AS total_segmentos,
       SUM(capacidad_total_gbps) AS total_gbps,
       SUM(capacidad_usada_gbps) AS en_uso_gbps,
       SUM(capacidad_reservada_gbps) AS reservada_gbps,
       SUM(capacidad_disponible_gbps) AS disponible_gbps,
       ROUND(100 * SUM(capacidad_usada_gbps) / NULLIF(SUM(capacidad_total_gbps),0),2) AS utilizacion_pct,
       (SELECT COUNT(*) FROM incidencias WHERE estado <> 'Cerrada') AS incidencias_activas,
       (SELECT COUNT(*) FROM mantenimientos WHERE estado='Pendiente') AS mantenimientos_pendientes
FROM v_capacidad_segmentos;

-- Primera comprobación visual: 1900 total, 1105 uso, 80 reserva, 715 disponibles.
SELECT * FROM v_resumen_red;
