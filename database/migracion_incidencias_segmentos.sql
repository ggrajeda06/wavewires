SET NAMES utf8mb4;
USE db_ocealink;
-- Workbench trae activado el "safe update mode"; los UPDATE sin llave primaria lo necesitan apagado
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE cliente
  ADD COLUMN ruc VARCHAR(11) NOT NULL AFTER estado,
  ADD COLUMN correo VARCHAR(100) NOT NULL AFTER ruc;

UPDATE cliente SET ruc = '20100000001', correo = 'andes@cliente.pe' WHERE idCliente = 1;
UPDATE cliente SET ruc = '20100000002', correo = 'pacifico@cliente.pe' WHERE idCliente = 2;
UPDATE cliente SET ruc = '20100000003', correo = 'surconecta@cliente.pe' WHERE idCliente = 3;
-- si hay mas clientes, se les pone un RUC y correo temporal distinto a cada uno (luego se editan en la app)
UPDATE cliente SET ruc = CONCAT('2099', LPAD(idCliente, 7, '0')), correo = CONCAT('cliente', idCliente, '@pendiente.pe') WHERE ruc = '';

ALTER TABLE cliente ADD UNIQUE (ruc);

ALTER TABLE usuario ADD UNIQUE (correo);

ALTER TABLE landingstation
  MODIFY estado ENUM('Operativa', 'Degradada', 'Mantenimiento', 'En mantenimiento', 'Fuera de servicio') NOT NULL DEFAULT 'Operativa';
UPDATE landingstation SET estado = 'En mantenimiento' WHERE estado = 'Mantenimiento';
ALTER TABLE landingstation
  MODIFY estado ENUM('Operativa', 'Degradada', 'En mantenimiento', 'Fuera de servicio') NOT NULL DEFAULT 'Operativa';

ALTER TABLE segmento
  MODIFY estado ENUM('Operativo', 'Degradado', 'Mantenimiento', 'En mantenimiento', 'Fuera de servicio') NOT NULL DEFAULT 'Operativo';
UPDATE segmento SET estado = 'En mantenimiento' WHERE estado = 'Mantenimiento';
ALTER TABLE segmento
  MODIFY estado ENUM('Operativo', 'Degradado', 'En mantenimiento', 'Fuera de servicio') NOT NULL DEFAULT 'Operativo';

-- SOLICITUDES: el estado pasa a ENUM con los 7 estados del flujo.
-- Primero se deja como texto y se corrigen los estados escritos de otra forma.
ALTER TABLE solicitudcapacidad MODIFY estado VARCHAR(45) NULL;

-- lo que habia antes (sale como resultado, solo para revisar)
SELECT estado AS estado_antes, COUNT(*) AS solicitudes FROM solicitudcapacidad GROUP BY estado;

-- la comparacion no distingue mayusculas ni tildes: 'aprobada' o 'En evaluacion' tambien entran
UPDATE solicitudcapacidad SET estado = 'Registrado' WHERE TRIM(estado) IN ('Registrado', 'Registrada', 'Pendiente', 'Nueva', 'Nuevo');
UPDATE solicitudcapacidad SET estado = 'En evaluación' WHERE TRIM(estado) IN ('En evaluación', 'Evaluación', 'En revisión', 'Revisión');
UPDATE solicitudcapacidad SET estado = 'Aprobado' WHERE TRIM(estado) IN ('Aprobado', 'Aprobada');
UPDATE solicitudcapacidad SET estado = 'Rechazado' WHERE TRIM(estado) IN ('Rechazado', 'Rechazada');
UPDATE solicitudcapacidad SET estado = 'Pendiente por Capacidad' WHERE TRIM(estado) IN ('Pendiente por Capacidad', 'Sin capacidad');
UPDATE solicitudcapacidad SET estado = 'Provisionado' WHERE TRIM(estado) IN ('Provisionado', 'Provisionada');
UPDATE solicitudcapacidad SET estado = 'Activo' WHERE TRIM(estado) IN ('Activo', 'Activa');

-- lo que siga sin ser uno de los 7: si ya tiene servicio queda Activo, si no vuelve a Registrado
UPDATE solicitudcapacidad SET estado = 'Activo'
WHERE (estado IS NULL OR estado NOT IN ('Registrado', 'En evaluación', 'Aprobado', 'Rechazado', 'Pendiente por Capacidad', 'Provisionado', 'Activo'))
  AND idSolicitudCapacidad IN (SELECT idSolicitudCapacidad FROM servicio);
UPDATE solicitudcapacidad SET estado = 'Registrado'
WHERE estado IS NULL OR estado NOT IN ('Registrado', 'En evaluación', 'Aprobado', 'Rechazado', 'Pendiente por Capacidad', 'Provisionado', 'Activo');

SELECT estado AS estado_despues, COUNT(*) AS solicitudes FROM solicitudcapacidad GROUP BY estado;

ALTER TABLE solicitudcapacidad
  MODIFY estado ENUM('Registrado', 'En evaluación', 'Aprobado', 'Rechazado', 'Pendiente por Capacidad', 'Provisionado', 'Activo') NOT NULL DEFAULT 'Registrado';

ALTER TABLE servicio
  ADD COLUMN fechaActivacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER estado;

UPDATE servicio sv
JOIN solicitudcapacidad sc ON sc.idSolicitudCapacidad = sv.idSolicitudCapacidad
SET sv.fechaActivacion = DATE_SUB(sv.fechaCaducidad, INTERVAL sc.duracionMeses MONTH);

DROP TABLE IF EXISTS restauracion;

-- INCIDENCIAS: mismo arreglo, de los estados viejos a los 6 del PDF
ALTER TABLE incidencia MODIFY estado VARCHAR(45) NULL;

UPDATE incidencia SET estado = 'Detectada' WHERE TRIM(estado) IN ('Abierta', 'Abierto', 'Detectada', 'Nueva', 'Pendiente');
UPDATE incidencia SET estado = 'En análisis' WHERE TRIM(estado) IN ('En proceso', 'En análisis', 'En revisión');
UPDATE incidencia SET estado = 'Cerrada' WHERE TRIM(estado) IN ('Resuelta', 'Resuelto', 'Cerrada', 'Cerrado');
UPDATE incidencia SET estado = 'Detectada'
WHERE estado IS NULL OR estado NOT IN ('Detectada', 'En análisis', 'Reparación programada', 'En reparación', 'Servicio restaurado', 'Cerrada');

-- el identificador se arma igual que en IncidenciaDao, asi ninguno se repite
UPDATE incidencia SET identificador = CONCAT('INC-', YEAR(fechaRegistro), '-', LPAD(idIncidencia, 3, '0'));

ALTER TABLE incidencia
  MODIFY estado ENUM('Detectada', 'En análisis', 'Reparación programada', 'En reparación', 'Servicio restaurado', 'Cerrada') NOT NULL DEFAULT 'Detectada',
  MODIFY identificador VARCHAR(45) NULL UNIQUE,
  MODIFY observaciones TEXT NULL,
  ADD COLUMN fechaCierre DATETIME NULL AFTER fechaRegistro;

UPDATE incidencia SET fechaCierre = NOW() WHERE estado = 'Cerrada';

CREATE TABLE incidencia_has_segmento (
  idIncidencia INT NOT NULL,
  idSegmento INT NOT NULL,
  PRIMARY KEY (idIncidencia, idSegmento),
  FOREIGN KEY (idIncidencia) REFERENCES incidencia (idIncidencia),
  FOREIGN KEY (idSegmento) REFERENCES segmento (idSegmento)
);

INSERT INTO incidencia_has_segmento (idIncidencia, idSegmento)
SELECT i.idIncidencia, s.idSegmento
FROM incidencia i
JOIN segmento s ON s.idOrigen = i.idLandingStation OR s.idDestino = i.idLandingStation;

-- la llave foranea puede tener otro nombre segun como se creo la BD: se busca su nombre y se borra
SET @fk = (SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
           WHERE TABLE_SCHEMA = 'db_ocealink' AND TABLE_NAME = 'incidencia'
             AND COLUMN_NAME = 'idLandingStation' AND REFERENCED_TABLE_NAME IS NOT NULL);
SET @sql = CONCAT('ALTER TABLE incidencia DROP FOREIGN KEY ', @fk);
PREPARE borrarFk FROM @sql;
EXECUTE borrarFk;
DEALLOCATE PREPARE borrarFk;
ALTER TABLE incidencia DROP COLUMN idLandingStation;

ALTER TABLE incidencia_has_servicio
  ADD COLUMN fechaRestauracion DATETIME NULL;

ALTER TABLE mantenimiento
  MODIFY idLandingStation INT NULL,
  ADD COLUMN idSegmento INT NULL AFTER idLandingStation,
  ADD COLUMN idIncidencia INT NULL AFTER idSegmento,
  ADD FOREIGN KEY (idSegmento) REFERENCES segmento (idSegmento),
  ADD FOREIGN KEY (idIncidencia) REFERENCES incidencia (idIncidencia);

-- estados iniciales calculados igual que SegmentoDao.recalcularEstado y LandingStationDao.recalcularEstado
UPDATE segmento SET estado = 'Operativo';

UPDATE segmento SET estado = 'Degradado'
WHERE idSegmento IN (SELECT ihs.idSegmento FROM incidencia_has_segmento ihs
                     JOIN incidencia i ON i.idIncidencia = ihs.idIncidencia
                     WHERE i.estado NOT IN ('Servicio restaurado', 'Cerrada'));

UPDATE segmento SET estado = 'En mantenimiento'
WHERE idSegmento IN (SELECT idSegmento FROM mantenimiento WHERE estado = 'Activo' AND idSegmento IS NOT NULL);

UPDATE segmento SET estado = 'Fuera de servicio'
WHERE idSegmento IN (SELECT ihs.idSegmento FROM incidencia_has_segmento ihs
                     JOIN incidencia i ON i.idIncidencia = ihs.idIncidencia
                     WHERE i.estado NOT IN ('Servicio restaurado', 'Cerrada') AND i.severidad = 'Crítica');

UPDATE landingstation SET estado = 'Operativa'
WHERE estado = 'En mantenimiento'
  AND idLandingStation NOT IN (SELECT idLandingStation FROM mantenimiento WHERE estado = 'Activo' AND idLandingStation IS NOT NULL);

UPDATE landingstation SET estado = 'En mantenimiento'
WHERE idLandingStation IN (SELECT idLandingStation FROM mantenimiento WHERE estado = 'Activo' AND idLandingStation IS NOT NULL);

-- una solicitud genera un solo servicio (va al final: si falla por servicios repetidos, lo demas ya quedo hecho)
ALTER TABLE servicio ADD UNIQUE (idSolicitudCapacidad);

SET SQL_SAFE_UPDATES = 1;
