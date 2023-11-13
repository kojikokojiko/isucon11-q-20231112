DROP TABLE IF EXISTS `isu_association_config`;
DROP TABLE IF EXISTS `isu_condition`;
DROP TABLE IF EXISTS `isu`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `isu` (
  `id` bigint AUTO_INCREMENT,
  `jia_isu_uuid` CHAR(36) NOT NULL UNIQUE,
  `name` VARCHAR(255) NOT NULL,
  `image` LONGBLOB,
  `character` VARCHAR(255),
  `jia_user_id` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
   PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

CREATE TABLE `isu_condition` (
  `id` bigint AUTO_INCREMENT,
  `jia_isu_uuid` CHAR(36) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `is_sitting` TINYINT(1) NOT NULL,
  `condition` VARCHAR(255) NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;



CREATE INDEX idx_jia_isu_uuid_timestamp ON isu_condition (jia_isu_uuid, timestamp DESC);

ALTER TABLE isu_condition
ADD COLUMN condition_level VARCHAR(10);

UPDATE isu_condition
SET condition_level = CASE
    WHEN LENGTH(condition) - LENGTH(REPLACE(condition, 'true', '')) = LENGTH('true') * 0 THEN 'info'
    WHEN LENGTH(condition) - LENGTH(REPLACE(condition, 'true', '')) BETWEEN LENGTH('true') * 1 AND LENGTH('true') * 2 THEN 'warning'
    WHEN LENGTH(condition) - LENGTH(REPLACE(condition, 'true', '')) = LENGTH('true') * 3 THEN 'critical'
    ELSE 'unknown'
END;


CREATE TRIGGER before_isu_condition_insert
BEFORE INSERT ON isu_condition
FOR EACH ROW
SET NEW.condition_level = CASE
    WHEN LENGTH(NEW.condition) - LENGTH(REPLACE(NEW.condition, 'true', '')) = LENGTH('true') * 0 THEN 'info'
    WHEN LENGTH(NEW.condition) - LENGTH(REPLACE(NEW.condition, 'true', '')) BETWEEN LENGTH('true') * 1 AND LENGTH('true') * 2 THEN 'warning'
    WHEN LENGTH(NEW.condition) - LENGTH(REPLACE(NEW.condition, 'true', '')) = LENGTH('true') * 3 THEN 'critical'
    ELSE 'unknown'
END;



CREATE TABLE `user` (
  `jia_user_id` VARCHAR(255) PRIMARY KEY,
  `created_at` DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;

CREATE TABLE `isu_association_config` (
  `name` VARCHAR(255) PRIMARY KEY,
  `url` VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8mb4;
