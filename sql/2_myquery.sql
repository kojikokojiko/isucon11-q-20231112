ALTER TABLE isu_condition ADD condition_level VARCHAR(15) NOT NULL DEFAULT 'info';

UPDATE isu_condition SET condition_level = 'warning' WHERE (
    TRUNCATE((LENGTH(`condition`) - LENGTH(REPLACE(`condition`, "=true", ''))) / LENGTH("=true"), 0) = 1
);

UPDATE isu_condition SET condition_level = 'warning' WHERE (
    TRUNCATE((LENGTH(`condition`) - LENGTH(REPLACE(`condition`, "=true", ''))) / LENGTH("=true"), 0) = 2
);

UPDATE isu_condition SET condition_level = 'critical' WHERE (
    TRUNCATE((LENGTH(`condition`) - LENGTH(REPLACE(`condition`, "=true", ''))) / LENGTH("=true"), 0) = 3
);

CREATE INDEX idx_jia_isu_uuid_timestamp ON isu_condition (jia_isu_uuid, timestamp DESC);
