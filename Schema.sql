-- -----------------------------------------------------
-- MySQL Workbench Forward Engineering
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema imdb_new
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `imdb_new` DEFAULT CHARACTER SET utf8 ;
USE `imdb_new` ;

-- -----------------------------------------------------
-- Table `imdb_new`.`castCrew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`castCrew` (
  `nconst` VARCHAR(10) NOT NULL,
  `primaryName` VARCHAR(255) NULL DEFAULT NULL,
  `birthYear` VARCHAR(6) NULL DEFAULT NULL,
  `deathYear` VARCHAR(6) NULL DEFAULT NULL,
  PRIMARY KEY (`nconst`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `imdb_new`.`genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`genres` (
  `genres` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`genres`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `imdb_new`.`titleBasics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`titleBasics` (
  `tconst` VARCHAR(10) NOT NULL,
  `titleType` VARCHAR(12) NULL DEFAULT NULL,
  `primaryTitle` VARCHAR(255) NULL DEFAULT NULL,
  `originalTitle` VARCHAR(255) NULL DEFAULT NULL,
  `isAdult` BIT(1) NULL DEFAULT NULL,
  `startYear` VARCHAR(4) NULL DEFAULT NULL,
  `endYear` VARCHAR(4) NULL DEFAULT NULL,
  `runtimeMinutes` VARCHAR(5) NULL DEFAULT NULL,
  `averageRating` VARCHAR(3) NULL DEFAULT NULL,
  `numVotes` VARCHAR(7) NULL DEFAULT NULL,
  PRIMARY KEY (`tconst`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `imdb_new`.`knownForTitles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`knownForTitles` (
  `CastCrew_nconst` VARCHAR(10) NOT NULL,
  `TitleBasics_tconst` VARCHAR(10) NOT NULL,
  INDEX `fk_castCrew_has_titleBasics_castCrew1_idx` (`CastCrew_nconst` ASC),
  INDEX `fk_tconst_idx` (`TitleBasics_tconst` ASC),
  PRIMARY KEY (`CastCrew_nconst`, `TitleBasics_tconst`),
  CONSTRAINT `fk_nconst`
    FOREIGN KEY (`CastCrew_nconst`)
    REFERENCES `imdb_new`.`castCrew` (`nconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tconst`
    FOREIGN KEY (`TitleBasics_tconst`)
    REFERENCES `imdb_new`.`titleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `imdb_new`.`titleCastCrew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`titleCastCrew` (
  `titleBasics_tconst` VARCHAR(10) NOT NULL,
  `castCrew_nconst` VARCHAR(10) NOT NULL,
  `jobTitle` VARCHAR(30) NULL DEFAULT NULL,
  `jobCategory` VARCHAR(20) NULL DEFAULT NULL,
  `character` VARCHAR(255) NULL DEFAULT NULL,
  INDEX `fk_titleBasics_has_castCrew_titleBasics1_idx` (`titleBasics_tconst` ASC),
  INDEX `fk_titleBasics_has_castCrew_castCrew1_idx` (`castCrew_nconst` ASC),
  PRIMARY KEY (`titleBasics_tconst`, `castCrew_nconst`),
  CONSTRAINT `fk_titleBasics_has_castCrew_castCrew1`
    FOREIGN KEY (`castCrew_nconst`)
    REFERENCES `imdb_new`.`castCrew` (`nconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_titleBasics_has_castCrew_titleBasics1`
    FOREIGN KEY (`titleBasics_tconst`)
    REFERENCES `imdb_new`.`titleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `imdb_new`.`titleGenres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb_new`.`titleGenres` (
  `genres_genres` VARCHAR(20) NOT NULL,
  `titleBasics_tconst` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`genres_genres`, `titleBasics_tconst`),
  INDEX `fk_genres_has_titleBasics_titleBasics1_idx` (`titleBasics_tconst` ASC),
  INDEX `fk_genres_has_titleBasics_genres1_idx` (`genres_genres` ASC),
  CONSTRAINT `fk_genres_has_titleBasics_genres1`
    FOREIGN KEY (`genres_genres`)
    REFERENCES `imdb_new`.`genres` (`genres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_genres_has_titleBasics_titleBasics1`
    FOREIGN KEY (`titleBasics_tconst`)
    REFERENCES `imdb_new`.`titleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- importing the data
-- -----------------------------------------------------

-- -----------------------------------------------------
-- genre bridge
-- -----------------------------------------------------
USE imdb_new;
SET AUTOCOMMIT=0;
INSERT INTO genres VALUES ("Documentary"),
("Animation"),
("Comedy"),
("Short"),
("Romance"),
("News"),
("Drama"),
("Fantasy"),
("Horror"),
("Biography"),
("Music"),
("Crime"),
("Family"),
("Adventure"),
("History"),
("Action"),
("Mystery"),
("Musical"),
("War"),
("Sci-Fi"),
("Western"),
("Thriller"),
("Sport"),
("Game-Show"),
("Film-Noir"),
("Talk-Show"),
("Adult"),
("Reality-TV"),
("NA");
COMMIT;

-- -----------------------------------------------------
-- castCrew bridge
-- -----------------------------------------------------
INSERT INTO imdb_new.castCrew (
	nconst,
	primaryName,
	birthYear,
	deathYear)
(SELECT
	nconst,
    primaryName,
    birthYear,
    deathYear
FROM
	imdb.names);