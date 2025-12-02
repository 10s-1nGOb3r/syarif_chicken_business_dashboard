-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`store_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`store_table` (
  `store_id` INT NOT NULL,
  `franchise_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `rent_utility_per_month` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`store_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employee_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`employee_table` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `employee_name` VARCHAR(45) NOT NULL,
  `employee_address` VARCHAR(45) NOT NULL,
  `payroll` DECIMAL(10,2) NOT NULL,
  `position` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `fk_employee_table_store_table1_idx` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_employee_table_store_table1`
    FOREIGN KEY (`store_id`)
    REFERENCES `mydb`.`store_table` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sales_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sales_table` (
  `sales_id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  PRIMARY KEY (`sales_id`),
  INDEX `fk_sales_table_stores1_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `fk_sales_table_stores1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `mydb`.`employee_table` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`menu_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`menu_table` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `menu_name` VARCHAR(45) NOT NULL,
  `sold_price` DECIMAL(10,2) NOT NULL,
  `cost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`menu_id`),
  UNIQUE INDEX `menu_name_UNIQUE` (`menu_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sales_item_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sales_item_table` (
  `sales_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  `sales_item_id` INT NOT NULL AUTO_INCREMENT,
  `quantity` INT NOT NULL,
  `date_transaction` DATETIME NOT NULL,
  PRIMARY KEY (`sales_item_id`),
  INDEX `fk_sales_table_has_menu_table_menu_table1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_sales_table_has_menu_table_sales_table_idx` (`sales_id` ASC) VISIBLE,
  CONSTRAINT `fk_sales_table_has_menu_table_sales_table`
    FOREIGN KEY (`sales_id`)
    REFERENCES `mydb`.`sales_table` (`sales_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sales_table_has_menu_table_menu_table1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `mydb`.`menu_table` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`item_menu_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`item_menu_table` (
  `item_menu_id` INT NOT NULL AUTO_INCREMENT,
  `item_name` VARCHAR(45) NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`item_menu_id`),
  INDEX `fk_item_menu_table_menu_table1_idx` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_menu_table_menu_table1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `mydb`.`menu_table` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`spending_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`spending_table` (
  `spending_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NULL,
  `employee_id` INT NULL,
  `sales_id` INT NULL,
  PRIMARY KEY (`spending_id`),
  INDEX `fk_spending_table_store_table1_idx` (`store_id` ASC) VISIBLE,
  INDEX `fk_spending_table_employee_table1_idx` (`employee_id` ASC) VISIBLE,
  INDEX `fk_spending_table_sales_table1_idx` (`sales_id` ASC) VISIBLE,
  CONSTRAINT `fk_spending_table_store_table1`
    FOREIGN KEY (`store_id`)
    REFERENCES `mydb`.`store_table` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_spending_table_employee_table1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `mydb`.`employee_table` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_spending_table_sales_table1`
    FOREIGN KEY (`sales_id`)
    REFERENCES `mydb`.`sales_table` (`sales_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`inventory_ingredient_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`inventory_ingredient_table` (
  `inventory_ingredient_id` INT NOT NULL AUTO_INCREMENT,
  `item_menu_id` INT NOT NULL,
  `stock` INT NOT NULL,
  PRIMARY KEY (`inventory_ingredient_id`),
  INDEX `fk_inventory_table_item_menu_table1_idx` (`item_menu_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_table_item_menu_table1`
    FOREIGN KEY (`item_menu_id`)
    REFERENCES `mydb`.`item_menu_table` (`item_menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
