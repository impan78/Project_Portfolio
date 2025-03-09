-- create a database
CREATE database projectcs2;

-- use database 
USE projectcs2;

-- create users table
CREATE TABLE job_data(
ds VARCHAR(100),
job_id INT,
actor_id INT,
event VARCHAR(50),
language VARCHAR(50),
time_spent INT,
org VARCHAR(50)
);

-- load the data from file to server

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploadate_/job_data.csv'
INTO TABLE job_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM job_data;

ALTER TABLE job_data ADD COLUMN date_ DATE;

UPDATE job_data SET date_ = STR_TO_DATE(ds, '%m/%d/%Y');

ALTER TABLE job_data DROP COLUMN ds;



