-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ong_gatitos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ong_gatitos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ong_gatitos` ;

-- -----------------------------------------------------
-- Table `ong_gatitos`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `apellido` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `contrasena` VARCHAR(255) NOT NULL,
  `rol` ENUM('padrino', 'adoptante', 'voluntario') NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`albergues`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`albergues` (
  `id_albergue` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(200) NULL DEFAULT NULL,
  `comuna` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_albergue`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`gatos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`gatos` (
  `id_gato` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `edad` INT NULL DEFAULT NULL,
  `foto_url` VARCHAR(255) NULL DEFAULT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `estado` ENUM('disponible', 'adoptado', 'apadrinado') NULL DEFAULT 'disponible',
  `id_albergue` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_gato`),
  INDEX `id_albergue` (`id_albergue` ASC) VISIBLE,
  CONSTRAINT `gatos_ibfk_1`
    FOREIGN KEY (`id_albergue`)
    REFERENCES `ong_gatitos`.`albergues` (`id_albergue`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`adopciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`adopciones` (
  `id_adopcion` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `id_gato` INT NOT NULL,
  `fecha_adopcion` DATE NOT NULL,
  `estado` ENUM('activa', 'finalizada') NULL DEFAULT 'activa',
  PRIMARY KEY (`id_adopcion`),
  INDEX `id_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `id_gato` (`id_gato` ASC) VISIBLE,
  CONSTRAINT `adopciones_ibfk_1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `ong_gatitos`.`usuarios` (`id_usuario`),
  CONSTRAINT `adopciones_ibfk_2`
    FOREIGN KEY (`id_gato`)
    REFERENCES `ong_gatitos`.`gatos` (`id_gato`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`evidencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`evidencias` (
  `id_evidencia` INT NOT NULL AUTO_INCREMENT,
  `id_adopcion` INT NOT NULL,
  `fecha_envio` DATE NOT NULL,
  `foto_url` VARCHAR(255) NOT NULL,
  `resultado_ia` ENUM('saludable', 'leve_estres', 'negligencia') NULL DEFAULT NULL,
  `estado` ENUM('aprobada', 'alerta', 'pendiente') NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id_evidencia`),
  INDEX `id_adopcion` (`id_adopcion` ASC) VISIBLE,
  CONSTRAINT `evidencias_ibfk_1`
    FOREIGN KEY (`id_adopcion`)
    REFERENCES `ong_gatitos`.`adopciones` (`id_adopcion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`alertas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`alertas` (
  `id_alerta` INT NOT NULL AUTO_INCREMENT,
  `id_evidencia` INT NOT NULL,
  `id_voluntario` INT NOT NULL,
  `fecha_alerta` DATE NOT NULL,
  `estado` ENUM('abierta', 'en_revision', 'cerrada') NULL DEFAULT 'abierta',
  PRIMARY KEY (`id_alerta`),
  INDEX `id_evidencia` (`id_evidencia` ASC) VISIBLE,
  INDEX `id_voluntario` (`id_voluntario` ASC) VISIBLE,
  CONSTRAINT `alertas_ibfk_1`
    FOREIGN KEY (`id_evidencia`)
    REFERENCES `ong_gatitos`.`evidencias` (`id_evidencia`),
  CONSTRAINT `alertas_ibfk_2`
    FOREIGN KEY (`id_voluntario`)
    REFERENCES `ong_gatitos`.`usuarios` (`id_usuario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`apadrinamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`apadrinamientos` (
  `id_apadrinamiento` INT NOT NULL AUTO_INCREMENT,
  `id_usuario` INT NOT NULL,
  `id_gato` INT NOT NULL,
  `monto_mensual` DECIMAL(10,2) NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `estado` ENUM('activo', 'inactivo') NULL DEFAULT 'activo',
  PRIMARY KEY (`id_apadrinamiento`),
  INDEX `id_usuario` (`id_usuario` ASC) VISIBLE,
  INDEX `id_gato` (`id_gato` ASC) VISIBLE,
  CONSTRAINT `apadrinamientos_ibfk_1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `ong_gatitos`.`usuarios` (`id_usuario`),
  CONSTRAINT `apadrinamientos_ibfk_2`
    FOREIGN KEY (`id_gato`)
    REFERENCES `ong_gatitos`.`gatos` (`id_gato`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ong_gatitos`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ong_gatitos`.`pagos` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `id_apadrinamiento` INT NOT NULL,
  `fecha_pago` DATE NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `estado` ENUM('exitoso', 'fallido', 'pendiente') NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id_pago`),
  INDEX `id_apadrinamiento` (`id_apadrinamiento` ASC) VISIBLE,
  CONSTRAINT `pagos_ibfk_1`
    FOREIGN KEY (`id_apadrinamiento`)
    REFERENCES `ong_gatitos`.`apadrinamientos` (`id_apadrinamiento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
