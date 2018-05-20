-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql10.freesqldatabase.com
-- Generation Time: May 20, 2018 at 08:42 PM
-- Server version: 5.5.58-0ubuntu0.14.04.1
-- PHP Version: 7.0.30-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql10239032`
--

DELIMITER $$
--
-- Procedures
--

CREATE DEFINER=`sql10239032`@`%` PROCEDURE `sp_insertRecord` (IN `m_fecha` DATE, IN `m_oficina` VARCHAR(45), IN `m_descripcion` TEXT, IN `m_nro_documento` VARCHAR(45), IN `m_cargo` BIGINT, IN `m_abono` BIGINT, IN `m_saldo` BIGINT)  NO SQL
BEGIN
    DECLARE id_movimiento_count BIGINT DEFAULT 0;
    DECLARE movimiento_count INT DEFAULT 0;
    DECLARE fecha_buscar DATE;

    IF DAYOFWEEK(m_fecha) = 2 THEN
        SET fecha_buscar = DATE_SUB(m_fecha, INTERVAL 3 DAY);
    ELSE
        SET fecha_buscar =  DATE_SUB(m_fecha, INTERVAL 1 DAY);
    END IF;

    SELECT id,COUNT(id) INTO id_movimiento_count, movimiento_count
    FROM cartola c
    WHERE 
    (
        c.fecha = fecha_buscar
        OR c.fecha = m_fecha
    )
    AND c.oficina = m_oficina
    AND c.descripcion = m_descripcion
    AND c.nro_documento = m_nro_documento
    AND c.cargo = m_cargo
    AND c.abono = m_abono
    LIMIT 1;

    IF movimiento_count = 0 THEN
        -- Si no hay lo creo 
        INSERT INTO cartola VALUES(
            NULL
            , m_fecha
            , m_oficina
            , m_descripcion
            , m_nro_documento
            , m_cargo
            , m_abono
            , m_saldo
        );
    ELSE
        -- Si existe se hace update del dia
        UPDATE cartola SET fecha = m_fecha, saldo = m_saldo WHERE id = id_movimiento_count;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cartola`
--

CREATE TABLE `cartola` (
  `id` bigint(20) NOT NULL,
  `fecha` date DEFAULT NULL,
  `oficina` varchar(45) DEFAULT NULL,
  `descripcion` text,
  `nro_documento` varchar(45) DEFAULT NULL,
  `cargo` bigint(20) DEFAULT NULL,
  `abono` bigint(20) DEFAULT NULL,
  `saldo` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cartola`
--
ALTER TABLE `cartola`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cartola`
--
ALTER TABLE `cartola`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
