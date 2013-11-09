delimiter $$

CREATE TABLE `Public_Memento` (
  `public_memento_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `headline` varchar(254) DEFAULT NULL COMMENT 'title of the story, title of the song, fullname of the person, caption of the picture, etc.',
  `text` text COMMENT 'extended desctiption of the story, description of the song, short bio of the person, extended description of the picture, etc.',
  `type` varchar(32) DEFAULT NULL COMMENT 'the type related to entity we are referring too (e.g. sport event if an even, singer if person, postcartd if picture, etc.',
  `resource_type` varchar(45) DEFAULT NULL COMMENT 'content type of the linked resource: VIDEO, IMAGE, AUDIO, TEXT',
  `category` varchar(45) DEFAULT NULL COMMENT 'content category for display purposes PICTURE, SONG, PEOPLE, STORY, FILM, TV',
  `source` varchar(45) DEFAULT NULL COMMENT 'name of the source where the content was found',
  `source_url` text COMMENT 'url to the source of the content, if content is not available, this becomes the content',
  `resource_url` text COMMENT 'url to the content itself',
  `resource_thumbnail_url` text COMMENT 'url to an compressed version of the content (mostly for pictures, but might be used to compressed audio or video',
  `author` text COMMENT 'name of the creator of the entity, e.g. the singer',
  `collection` text COMMENT 'if it is part of a collection of entities, the name of the collection (i.e. a musical album)',
  `collection_type` varchar(45) COMMENT 'MUSIC ALBUM, TV SERIES, MOVIE SAGA, DATASET, HISTORICAL EVENTS',
  `is_collection` smallint COMMENT 'this entity is a collection of others',
  `nationality` text COMMENT 'Nationality of Author',
  `locale` varchar(10) DEFAULT NULL comment 'localed code to indicate language of the linked content and metadata',
  `haschcode` text comment 'unique UUID of the entity',
  `file_hashcode` text comment 'if the content is hosted locally, unique UUID of the content',
  `file_name` text comment 'if the content is hosted locally, unique UUID of the content',
  `contributor_type` varchar(45) DEFAULT NULL COMMENT 'MEMBER, ADMIN, CURATOR, FRIEND, EXTERNAL, SYSTEM',
  `contributor` int default null, 
  `creation_date` DATETIME,
  `last_update` DATETIME,
  `fuzzy_startdate` bigint(20) DEFAULT NULL, 
  `location_start_id` bigint(20) DEFAULT NULL,
  `fuzzy_enddate` bigint(20) DEFAULT NULL,
  `location_end_id` bigint(20) DEFAULT NULL,
  `indexed` smallint default 0 COMMENT 'has it been indexed around the closest geocoded city and decade?',
  `tags` TEXT,
  `migration_id` BIGINT NULL,
  PRIMARY KEY (`public_memento_id`),
  KEY `k_public_memento_start_location` (`location_start_id`),
  KEY `k_public_memento_start_date` (`fuzzy_startdate`),
  KEY `k_public_memento_end_date` (`fuzzy_enddate`),
  KEY `k_public_memento_end_location` (`location_end_id`),
  CONSTRAINT `fk_public_memento_end_location` FOREIGN KEY (`location_end_id`) REFERENCES `Location` (`location_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_public_memento_start_date` FOREIGN KEY (`fuzzy_startdate`) REFERENCES `Fuzzy_Date` (`fuzzy_date_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_public_memento_end_date` FOREIGN KEY (`fuzzy_enddate`) REFERENCES `Fuzzy_Date` (`fuzzy_date_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_public_memento_start_location` FOREIGN KEY (`location_start_id`) REFERENCES `Location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1$$;


CREATE  TABLE IF NOT EXISTS `reminiscensdb`.`Context_Public_Memento` (
  `context_public_memento_id` BIGINT NOT NULL AUTO_INCREMENT ,
  `public_memento_id` BIGINT(20) NOT NULL ,
  `context_id` INT NOT NULL ,
  `level` VARCHAR(45) NULL COMMENT 'WORLD, COUNTRY, REGION' ,
  `decade` INT NULL ,
  `type` VARCHAR(45) NULL COMMENT 'VIDEO,IMAGE,AUDIO,TEXT' ,
  `category` VARCHAR(45) NULL DEFAULT 'STORY' COMMENT 'PICTURES' ,
  `views` INT NULL ,
  `detail_views` INT NULL ,
  `ranking` INT NULL,
  INDEX `fk_Public_Memento_has_Context_Context1_idx` (`context_id` ASC) ,
  INDEX `fk_Public_Memento_has_Context_Public_Memento1_idx` (`public_memento_id` ASC) ,
  PRIMARY KEY (`context_public_memento_id`) ,
  CONSTRAINT `fk_Public_Memento_has_Context_Public_Memento1`
    FOREIGN KEY (`public_memento_id` )
    REFERENCES `reminiscensdb`.`Public_Memento` (`public_memento_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Public_Memento_has_Context_Context1`
    FOREIGN KEY (`context_id` )
    REFERENCES `reminiscensdb`.`Context` (`context_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


