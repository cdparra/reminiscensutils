ALTER TABLE `reminiscensdb`.`Contributed_Memento` CHANGE COLUMN `contributed_memento_id` `contributed_memento_id` BIGINT NOT NULL AUTO_INCREMENT  ;


CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Contributed_Memento` (
  `contributed_memento_id` BIGINT NOT NULL ,
  `contex_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL COMMENT 'PICTURES,SONG,PEOPLE,STORY,FILM,TV,ARTWORK,BOOK,OBJECT' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  PRIMARY KEY (`contributed_memento_id`, `contex_id`) ,
  INDEX `fk_Context_has_Contributed_Memento_Contributed_Memento1_idx` (`contributed_memento_id` ASC) ,
  INDEX `fk_Context_has_Contributed_Memento_Context1_idx` (`contex_id` ASC) ,
  CONSTRAINT `fk_Context_has_Contributed_Memento_Context1`
    FOREIGN KEY (`contex_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Context_has_Contributed_Memento_Contributed_Memento1`
    FOREIGN KEY (`contributed_memento_id` )
    REFERENCES `reminiscensdb`.`Contributed_Memento` (`contributed_memento_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Famous` (
  `famous_id` BIGINT NOT NULL ,
  `context_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL DEFAULT 'PEOPLE' COMMENT 'PEOPLE' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  PRIMARY KEY (`famous_id`, `context_id`) ,
  INDEX `fk_Famous_Person_has_Context_Context1_idx` (`context_id` ASC) ,
  INDEX `fk_Famous_Person_has_Context_Famous_Person1_idx` (`famous_id` ASC) ,
  CONSTRAINT `fk_Famous_Person_has_Context_Famous_Person1`
    FOREIGN KEY (`famous_id` )
    REFERENCES `reminiscensdb`.`Famous_Person` (`famous_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Famous_Person_has_Context_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Media` (
  `media_id` BIGINT NOT NULL ,
  `context_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL DEFAULT 'PICTURES' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  PRIMARY KEY (`media_id`, `context_id`) ,
  INDEX `fk_Context_has_Media_Media1_idx` (`media_id` ASC) ,
  INDEX `fk_Context_has_Media_Context1_idx` (`context_id` ASC) ,
  CONSTRAINT `fk_Context_has_Media_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Context_has_Media_Media1`
    FOREIGN KEY (`media_id` )
    REFERENCES `reminiscensdb`.`Media` (`media_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Works` (
  `work_id` BIGINT NOT NULL ,
  `context_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL DEFAULT 'SONG' COMMENT 'SONG,FILM,TV,ARTWORK,BOOK,OBJECT' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  PRIMARY KEY (`work_id`, `context_id`) ,
  INDEX `fk_Works_has_Context_Context1_idx` (`context_id` ASC) ,
  INDEX `fk_Works_has_Context_Works1_idx` (`work_id` ASC) ,
  CONSTRAINT `fk_Works_has_Context_Works1`
    FOREIGN KEY (`work_id` )
    REFERENCES `reminiscensdb`.`Works` (`work_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Works_has_Context_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Event` (
  `event_id` BIGINT NOT NULL ,
  `context_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL DEFAULT 'STORY' COMMENT 'PICTURES' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  PRIMARY KEY (`event_id`, `context_id`) ,
  INDEX `fk_Event_has_Context_Context1_idx` (`context_id` ASC) ,
  INDEX `fk_Event_has_Context_Event1_idx` (`event_id` ASC) ,
  CONSTRAINT `fk_Event_has_Context_Event1`
    FOREIGN KEY (`event_id` )
    REFERENCES `reminiscensdb`.`Event` (`event_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Event_has_Context_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Life_Event_Context_Item` (
  `connection_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` TEXT NULL DEFAULT 'PICTURES' ,
  `life_event_id` INT NULL ,
  `context_id` INT NULL ,
  PRIMARY KEY (`connection_id`) ,
  INDEX `fk_Life_Event_Context_Item_Context1_idx` (`context_id` ASC) ,
  INDEX `fk_Life_Event_Context_Item_Life_Event1_idx` (`life_event_id` ASC) ,
  CONSTRAINT `fk_Life_Event_Context_Item_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Life_Event_Context_Item_Life_Event1`
    FOREIGN KEY (`life_event_id` )
    REFERENCES `reminiscensdb`.`Life_Event` (`life_event_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;