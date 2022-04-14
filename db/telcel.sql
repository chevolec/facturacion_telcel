-- MySQL dump 10.13  Distrib 5.7.22, for Linux (x86_64)
--
-- Host: localhost    Database: telcel
-- ------------------------------------------------------
-- Server version	5.7.22-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


--
-- Table structure for table `cecos`
--

DROP TABLE IF EXISTS `cecos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cecos` (
  `region` char(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cuenta` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cuentamaster` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ceco` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `responsable` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `cuenta` (`cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facturasTelcel`
--

DROP TABLE IF EXISTS `facturasTelcel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facturasTelcel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `folio` varchar(50) DEFAULT NULL,
  `cuenta` varchar(50) DEFAULT NULL,
  `cargo` float DEFAULT NULL,
  `otrosCargos` float DEFAULT NULL,
  `fechacobro` date DEFAULT NULL,
  `nombreArchivo` varchar(50) DEFAULT NULL,
  `periodo` char(10) DEFAULT NULL,
  `cargosAmex_id` int(11) DEFAULT NULL,
  `region` varchar(3) DEFAULT NULL,
  `NumeroDeFactura` varchar(15) DEFAULT NULL,
  `base` float DEFAULT NULL,
  `impuesto` float DEFAULT NULL,
  `total` float DEFAULT NULL,
  UNIQUE KEY `folio` (`folio`),
  KEY `Index 1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7926 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `lineas`
--

DROP TABLE IF EXISTS `lineas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lineas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Region` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CuentaPadre` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Cuenta` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Ciclo` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RazonSocial` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Telefono` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ICCID` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IMEI` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EstatusCuenta` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ProductoCC` varchar(11) COLLATE utf8_unicode_ci DEFAULT NULL,
  `NombredelPlan` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MontoRenta` float DEFAULT NULL,
  `Equipo` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Modelo` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DuracionPlan` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FechaInicio` datetime DEFAULT NULL,
  `FechaTermino` datetime DEFAULT NULL,
  `EstatusAdendum` varchar(11) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MesesRestantesPlazosForzoso` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CuentaPrincipal` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Cuenta` (`Cuenta`)
) ENGINE=InnoDB AUTO_INCREMENT=4549 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
