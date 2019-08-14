#imdb database forward engineered

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema imdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `imdb` DEFAULT CHARACTER SET utf8 ;
USE `imdb` ;


-- -----------------------------------------------------
-- Table `imdb`.`TitleBasics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`TitleBasics` (
  `tconst` VARCHAR(10) NOT NULL,
  `TitleType` VARCHAR(10) NULL,
  `PrimaryTItle` VARCHAR(100) NULL,
  `OriginalTitle` VARCHAR(100) NULL,
  `IsAdult` BIT(1) NULL,
  `StartYear` YEAR(4) NULL,
  `endYear` YEAR(4) NULL,
  `RunTimeMinutes` DECIMAL(5) NULL,
  `AverageRating` DECIMAL(3,1) NULL,
  `NumVotes` DECIMAL(12) NULL,
  PRIMARY KEY (`tconst`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`Episodes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`Episodes` (
  `EpisodeID` VARCHAR(10) NOT NULL,
  `Episodescol` VARCHAR(45) NULL,
  `SeasonNumber` INT NULL,
  `EpisodeNumber` INT NULL,
  `tconst` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`EpisodeID`, `tconst`),
  INDEX `fk_Episodes_TitleBasics1_idx` (`tconst` ASC) VISIBLE,
  CONSTRAINT `fk_Episodes_TitleBasics1`
    FOREIGN KEY (`tconst`)
    REFERENCES `imdb`.`TitleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`Genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`Genres` (
  `Genres` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Genres`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`TitleGenres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`TitleGenres` (
  `Genres_Genres` VARCHAR(20) NOT NULL,
  `TitleBasics_tconst` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Genres_Genres`, `TitleBasics_tconst`),
  INDEX `fk_Genres_has_TitleBasics_TitleBasics1_idx` (`TitleBasics_tconst` ASC) VISIBLE,
  INDEX `fk_Genres_has_TitleBasics_Genres1_idx` (`Genres_Genres` ASC) VISIBLE,
  CONSTRAINT `fk_Genres_has_TitleBasics_Genres1`
    FOREIGN KEY (`Genres_Genres`)
    REFERENCES `imdb`.`Genres` (`Genres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Genres_has_TitleBasics_TitleBasics1`
    FOREIGN KEY (`TitleBasics_tconst`)
    REFERENCES `imdb`.`TitleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`CastCrew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`CastCrew` (
  `nconst` VARCHAR(10) NOT NULL,
  `primaryName` VARCHAR(45) NULL,
  `birthYear` YEAR(4) NULL,
  `deathYear` YEAR(4) NULL,
  `knownForTitles` VARCHAR(45) NULL,
  PRIMARY KEY (`nconst`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`TItleCastCrew`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`TItleCastCrew` (
  `TitleBasics_tconst` VARCHAR(10) NOT NULL,
  `CastCrew_nconst` VARCHAR(10) NOT NULL,
  `jobTitle` VARCHAR(45) NULL,
  `jobCategory` VARCHAR(45) NULL,
  `character` VARCHAR(45) NULL,
  PRIMARY KEY (`TitleBasics_tconst`, `CastCrew_nconst`),
  INDEX `fk_TitleBasics_has_CastCrew_CastCrew1_idx` (`CastCrew_nconst` ASC) VISIBLE,
  INDEX `fk_TitleBasics_has_CastCrew_TitleBasics1_idx` (`TitleBasics_tconst` ASC) VISIBLE,
  CONSTRAINT `fk_TitleBasics_has_CastCrew_TitleBasics1`
    FOREIGN KEY (`TitleBasics_tconst`)
    REFERENCES `imdb`.`TitleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TitleBasics_has_CastCrew_CastCrew1`
    FOREIGN KEY (`CastCrew_nconst`)
    REFERENCES `imdb`.`CastCrew` (`nconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`Profession`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`Profession` (
  `professionName` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`professionName`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`PrimaryProfession`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`PrimaryProfession` (
  `CastCrew_nconst` VARCHAR(10) NOT NULL,
  `Profession_professionName` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`CastCrew_nconst`, `Profession_professionName`),
  INDEX `fk_CastCrew_has_Profession_Profession1_idx` (`Profession_professionName` ASC) VISIBLE,
  INDEX `fk_CastCrew_has_Profession_CastCrew1_idx` (`CastCrew_nconst` ASC) VISIBLE,
  CONSTRAINT `fk_CastCrew_has_Profession_CastCrew1`
    FOREIGN KEY (`CastCrew_nconst`)
    REFERENCES `imdb`.`CastCrew` (`nconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CastCrew_has_Profession_Profession1`
    FOREIGN KEY (`Profession_professionName`)
    REFERENCES `imdb`.`Profession` (`professionName`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `imdb`.`KnownForTitles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`KnownForTitles` (
  `CastCrew_nconst` VARCHAR(10) NOT NULL,
  `TitleBasics_tconst` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CastCrew_nconst`, `TitleBasics_tconst`),
  INDEX `fk_CastCrew_has_TitleBasics_TitleBasics1_idx` (`TitleBasics_tconst` ASC) VISIBLE,
  INDEX `fk_CastCrew_has_TitleBasics_CastCrew1_idx` (`CastCrew_nconst` ASC) VISIBLE,
  CONSTRAINT `fk_CastCrew_has_TitleBasics_CastCrew1`
    FOREIGN KEY (`CastCrew_nconst`)
    REFERENCES `imdb`.`CastCrew` (`nconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CastCrew_has_TitleBasics_TitleBasics1`
    FOREIGN KEY (`TitleBasics_tconst`)
    REFERENCES `imdb`.`TitleBasics` (`tconst`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
