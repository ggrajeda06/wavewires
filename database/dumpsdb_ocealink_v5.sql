CREATE DATABASE  IF NOT EXISTS `db_ocealink` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_ocealink`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: db_ocealink
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `identificador` varchar(45) NOT NULL,
  `fechaRegistro` date NOT NULL,
  `razonSocial` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo','Suspendido') NOT NULL DEFAULT 'Activo',
  `ruc` varchar(11) NOT NULL,
  `correo` varchar(100) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `ruc` (`ruc`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Cliente 1','2026-08-01','Andes Telecom S.A.C.','Activo','20100000001','andes@cliente.pe'),(2,'Cliente 2','2026-08-15','Pacífico Data S.A.','Activo','20100000002','pacifico@cliente.pe'),(3,'Cliente 3','2026-09-10','Sur Conecta E.I.R.L.','Inactivo','20100000003','surconecta@cliente.pe'),(4,'Cliente 4','2026-10-23','INFIELES SAC','Inactivo','','');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencia`
--

DROP TABLE IF EXISTS `incidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencia` (
  `idIncidencia` int NOT NULL AUTO_INCREMENT,
  `identificador` varchar(45) DEFAULT NULL,
  `severidad` enum('Crítica','Alta','Media','Baja') NOT NULL,
  `estado` enum('Detectada','En análisis','Reparación programada','En reparación','Servicio restaurado','Cerrada') NOT NULL DEFAULT 'Detectada',
  `observaciones` text,
  `fechaRegistro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaCierre` datetime DEFAULT NULL,
  PRIMARY KEY (`idIncidencia`),
  UNIQUE KEY `identificador` (`identificador`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencia`
--

LOCK TABLES `incidencia` WRITE;
/*!40000 ALTER TABLE `incidencia` DISABLE KEYS */;
INSERT INTO `incidencia` VALUES (2,'INC-2026-002','Media','En análisis','Pérdida de potencia en el enlace','2026-10-21 14:10:00',NULL),(8,'INC-2026-008','Media','Servicio restaurado',NULL,'2026-11-05 13:06:12',NULL);
/*!40000 ALTER TABLE `incidencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencia_has_segmento`
--

DROP TABLE IF EXISTS `incidencia_has_segmento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencia_has_segmento` (
  `idIncidencia` int NOT NULL,
  `idSegmento` int NOT NULL,
  PRIMARY KEY (`idIncidencia`,`idSegmento`),
  KEY `idSegmento` (`idSegmento`),
  CONSTRAINT `incidencia_has_segmento_ibfk_1` FOREIGN KEY (`idIncidencia`) REFERENCES `incidencia` (`idIncidencia`),
  CONSTRAINT `incidencia_has_segmento_ibfk_2` FOREIGN KEY (`idSegmento`) REFERENCES `segmento` (`idSegmento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencia_has_segmento`
--

LOCK TABLES `incidencia_has_segmento` WRITE;
/*!40000 ALTER TABLE `incidencia_has_segmento` DISABLE KEYS */;
INSERT INTO `incidencia_has_segmento` VALUES (2,1),(2,2),(8,2),(2,4),(2,5);
/*!40000 ALTER TABLE `incidencia_has_segmento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencia_has_servicio`
--

DROP TABLE IF EXISTS `incidencia_has_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencia_has_servicio` (
  `idIncidencia` int NOT NULL,
  `idServicio` int NOT NULL,
  `fechaRestauracion` datetime DEFAULT NULL,
  PRIMARY KEY (`idIncidencia`,`idServicio`),
  KEY `idServicio` (`idServicio`),
  CONSTRAINT `incidencia_has_servicio_ibfk_1` FOREIGN KEY (`idIncidencia`) REFERENCES `incidencia` (`idIncidencia`),
  CONSTRAINT `incidencia_has_servicio_ibfk_2` FOREIGN KEY (`idServicio`) REFERENCES `servicio` (`idServicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencia_has_servicio`
--

LOCK TABLES `incidencia_has_servicio` WRITE;
/*!40000 ALTER TABLE `incidencia_has_servicio` DISABLE KEYS */;
INSERT INTO `incidencia_has_servicio` VALUES (2,2,NULL),(8,2,'2026-11-05 13:13:12'),(8,4,NULL),(8,5,NULL),(8,6,NULL),(8,7,NULL);
/*!40000 ALTER TABLE `incidencia_has_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `landingstation`
--

DROP TABLE IF EXISTS `landingstation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `landingstation` (
  `idLandingStation` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `pais` varchar(100) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  PRIMARY KEY (`idLandingStation`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `landingstation`
--

LOCK TABLES `landingstation` WRITE;
/*!40000 ALTER TABLE `landingstation` DISABLE KEYS */;
INSERT INTO `landingstation` VALUES (1,'Lurín CLS','Perú','Lima'),(2,'Chimbote CLS 2','Perú 2','Chimbote 2'),(3,'Arica CLS','Chile','Arica'),(4,'Valparaíso CLS','Chile','Valparaíso'),(5,'Las Toninas CLS','Argentina','Las Toninas');
/*!40000 ALTER TABLE `landingstation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento` (
  `idMantenimiento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` enum('Preventivo','Correctivo') NOT NULL,
  `estado` enum('Pendiente','Activo','Finalizado') NOT NULL DEFAULT 'Pendiente',
  `fechaRegistrada` date NOT NULL,
  `duracionHoras` int NOT NULL,
  `actividadesRealizadas` text,
  `idLandingStation` int DEFAULT NULL,
  `idSegmento` int DEFAULT NULL,
  `idIncidencia` int DEFAULT NULL,
  PRIMARY KEY (`idMantenimiento`),
  KEY `idLandingStation` (`idLandingStation`),
  KEY `idSegmento` (`idSegmento`),
  KEY `idIncidencia` (`idIncidencia`),
  CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`idLandingStation`) REFERENCES `landingstation` (`idLandingStation`),
  CONSTRAINT `mantenimiento_ibfk_2` FOREIGN KEY (`idSegmento`) REFERENCES `segmento` (`idSegmento`),
  CONSTRAINT `mantenimiento_ibfk_3` FOREIGN KEY (`idIncidencia`) REFERENCES `incidencia` (`idIncidencia`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento`
--

LOCK TABLES `mantenimiento` WRITE;
/*!40000 ALTER TABLE `mantenimiento` DISABLE KEYS */;
INSERT INTO `mantenimiento` VALUES (1,'Inspección de cámara','Revisión de la cámara de playa y empalmes','Preventivo','Finalizado','2026-11-05',4,'Hola',1,NULL,NULL),(3,'Limpieza de equipos','Limpieza general de la sala de equipos','Preventivo','Finalizado','2026-10-10',2,'Limpieza completa',2,NULL,NULL),(6,'MANTENIMIENTO PRUEBA','ASSA','Correctivo','Finalizado','2026-11-13',15,'inicia\r\nFINALIZADO',NULL,2,8),(7,'mante 2','asda','Preventivo','Pendiente','2026-11-07',12,NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `idRoles` int NOT NULL AUTO_INCREMENT,
  `rol` varchar(45) NOT NULL,
  PRIMARY KEY (`idRoles`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Administrador'),(2,'Capacity Planner'),(3,'Network Operator'),(4,'Maintenance Coordinator'),(5,'Supervisor');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `segmento`
--

DROP TABLE IF EXISTS `segmento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `segmento` (
  `idSegmento` int NOT NULL AUTO_INCREMENT,
  `idOrigen` int NOT NULL,
  `idDestino` int NOT NULL,
  `capacidadTotal` decimal(10,2) NOT NULL,
  `capacidadUsada` decimal(10,2) NOT NULL DEFAULT '0.00',
  `capacidadReservada` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estado` enum('Operativo','Degradado','En mantenimiento','Fuera de servicio') NOT NULL DEFAULT 'Operativo',
  PRIMARY KEY (`idSegmento`),
  KEY `idOrigen` (`idOrigen`),
  KEY `idDestino` (`idDestino`),
  CONSTRAINT `segmento_ibfk_1` FOREIGN KEY (`idOrigen`) REFERENCES `landingstation` (`idLandingStation`),
  CONSTRAINT `segmento_ibfk_2` FOREIGN KEY (`idDestino`) REFERENCES `landingstation` (`idLandingStation`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `segmento`
--

LOCK TABLES `segmento` WRITE;
/*!40000 ALTER TABLE `segmento` DISABLE KEYS */;
INSERT INTO `segmento` VALUES (1,1,3,400.00,130.00,50.00,'Operativo'),(2,1,4,600.00,243.00,76.00,'Operativo'),(3,3,5,300.00,80.00,0.00,'Operativo'),(4,2,1,200.00,0.00,0.00,'Operativo'),(5,1,2,12.00,0.00,0.00,'Operativo'),(6,1,5,1000.00,0.00,0.00,'Operativo');
/*!40000 ALTER TABLE `segmento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `idServicio` int NOT NULL AUTO_INCREMENT,
  `identificador` varchar(45) NOT NULL,
  `capacidad` decimal(10,2) NOT NULL,
  `estado` enum('Funcionando','Caído') NOT NULL DEFAULT 'Funcionando',
  `fechaActivacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaCaducidad` date NOT NULL,
  `idSegmento` int NOT NULL,
  `idSolicitudCapacidad` int NOT NULL,
  PRIMARY KEY (`idServicio`),
  UNIQUE KEY `idSolicitudCapacidad` (`idSolicitudCapacidad`),
  KEY `idSegmento` (`idSegmento`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`idSegmento`) REFERENCES `segmento` (`idSegmento`),
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`idSolicitudCapacidad`) REFERENCES `solicitudcapacidad` (`idSolicitudCapacidad`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (1,'SRV-0001',100.00,'Funcionando','2026-09-01 00:00:00','2027-09-01',1,1),(2,'SRV-0002',200.00,'Funcionando','2026-09-05 00:00:00','2027-03-05',2,2),(3,'SRV-0003',80.00,'Funcionando','2026-09-20 00:00:00','2027-09-20',3,3),(4,'SRV-6',23.00,'Funcionando','2026-10-30 17:31:17','2027-02-28',2,6),(5,'SRV-D7',10.00,'Funcionando','2026-11-05 00:37:37','2027-11-05',2,7),(6,'SRV-D8',10.00,'Funcionando','2026-11-05 00:37:37','2027-11-05',2,8),(7,'SRV-D9',10.00,'Funcionando','2026-11-05 00:37:37','2027-11-05',2,9);
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitudcapacidad`
--

DROP TABLE IF EXISTS `solicitudcapacidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudcapacidad` (
  `idSolicitudCapacidad` int NOT NULL AUTO_INCREMENT,
  `capacidad` decimal(10,2) NOT NULL,
  `origen` varchar(100) NOT NULL,
  `destino` varchar(100) NOT NULL,
  `estado` enum('Registrado','En evaluación','Aprobado','Rechazado','Pendiente por Capacidad','Provisionado','Activo') NOT NULL DEFAULT 'Registrado',
  `observaciones` varchar(255) DEFAULT NULL,
  `fechaRegistroSolicitud` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `duracionMeses` int NOT NULL,
  `idSegmento` int DEFAULT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`idSolicitudCapacidad`),
  KEY `idSegmento` (`idSegmento`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `solicitudcapacidad_ibfk_1` FOREIGN KEY (`idSegmento`) REFERENCES `segmento` (`idSegmento`),
  CONSTRAINT `solicitudcapacidad_ibfk_2` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudcapacidad`
--

LOCK TABLES `solicitudcapacidad` WRITE;
/*!40000 ALTER TABLE `solicitudcapacidad` DISABLE KEYS */;
INSERT INTO `solicitudcapacidad` VALUES (1,1.00,'Perú','Chile','Provisionado','Enlace principal','2026-09-01 10:00:00',12,1,1),(2,200.00,'Perú','Chile','Aprobado',NULL,'2026-09-05 11:30:00',6,2,2),(3,80.00,'Chile','Argentina','Aprobado','Respaldo','2026-09-20 09:15:00',12,3,1),(6,23.00,'Mipe','Tupo','Activo','GAAAAAAAAA','2026-10-30 17:25:52',4,2,3),(7,10.00,'Lima','Valparaíso','Activo','Demo','2026-11-05 00:37:37',12,2,1),(8,10.00,'Lima','Valparaíso','Activo','Demo','2026-11-05 00:37:37',12,2,1),(9,10.00,'Lima','Valparaíso','Activo','Demo','2026-11-05 00:37:37',12,2,1),(11,111.00,'PUNTOA','PUNTOC','Aprobado','','2026-11-05 12:29:27',12,2,4);
/*!40000 ALTER TABLE `solicitudcapacidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  `contrasenia` varchar(255) NOT NULL,
  `Roles_idRoles` int NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correo` (`correo`),
  KEY `Roles_idRoles` (`Roles_idRoles`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`Roles_idRoles`) REFERENCES `roles` (`idRoles`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Carlos Mendoza','cmendoza@oceanlink.pe','Activo','admin123',1),(2,'Lucía Torres','ltorres@oceanlink.pe','Activo','planner123',2),(3,'Jorge Ramírez','jramirez@oceanlink.pe','Activo','noc123',3),(4,'María Quispe','mquispe@oceanlink.pe','Activo','mante123',4),(5,'Ana Pérez rojas','aperez@oceanlink.pe','Inactivo','456',5);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'db_ocealink'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-05 14:14:26
