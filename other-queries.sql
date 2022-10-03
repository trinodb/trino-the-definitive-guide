SHOW CATALOGS;

SHOW SCHEMAS FROM tpch LIKE '%3%';

SHOW TABLES FROM tpch.sf1;

SHOW FUNCTIONS;

SHOW FUNCTIONS LIKE 'approx%';

SHOW SCHEMAS IN system;

DESCRIBE system.runtime.queries;

DESCRIBE system.runtime.tasks;

SELECT * FROM system.runtime.nodes;

SELECT length(cast('hello world' AS char(100)));

SELECT cast('hello world' AS char(15)) || '~';

SELECT cast('hello world' AS char(5));

SELECT length(cast('hello world' AS varchar(15)));

SELECT cast('hello world' AS varchar(15)) || '~';

SELECT cast('hello world' as char(15)) = cast('hello world' as char(14));

SELECT cast('hello world' as varchar(15)) = cast('hello world' as varchar(14));

USE brain.default;
CREATE TABLE varchars(col varchar(5));
INSERT INTO varchars values('1234');
INSERT INTO varchars values('123456');