SET NAMES utf8mb4;
USE db_ocealink;

-- SOLICITUDES: las que ya generaron un servicio quedan en Activo, como en el flujo normal.
-- Asi salen de la lista de solicitudes y no dan error al editarlas o borrarlas.
UPDATE solicitudcapacidad SET estado = 'Activo'
WHERE estado <> 'Activo'
  AND idSolicitudCapacidad IN (SELECT idSolicitudCapacidad FROM servicio);
