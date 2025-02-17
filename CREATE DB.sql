create database sample_database;
use sample_database;

ALTER DATABASE sample_database
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER DATABASE sample_database 
CHARACTER SET ASCII
COLLATE ASCII_GENERAL_CI ENCRYPTION = "Y" 
READ ONLY = 0;

SHOW DATABASES;

DROP DATABASE sample_database;

SHOW DATABASES;







