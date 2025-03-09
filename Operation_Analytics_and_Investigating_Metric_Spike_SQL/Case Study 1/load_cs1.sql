-- create a database
CREATE database projectcs1;

-- use database 
use projectcs1;

-- create users table
create table users(
user_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50));

-- load the data from file to server

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


select * from users;

/* To change created_at and activated_at to datetime from varchar*/

--  add a new column to copy created_at to temp_create_at to convert it into datetime datatype

alter table users add column temp_create_at datetime;

update users set temp_create_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');

--  add a new column to copy activated_at to temp_activated_at to convert it into datetime datatype
alter table users add column temp_activated_at datetime;

update users set temp_activated_at = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');

-- drop old varchar created_at and activated at 
alter table users drop column created_at;

alter table users change column temp_create_at created_at datetime; 

alter table users drop column activated_at;

alter table users change column temp_activated_at activated_at datetime; 

-- create events table
create table events(
user_id int,
occurred_at varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(50),
user_type int
);

-- load the data from file to server

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv'
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


select * from events;

--  add a new column to copy occurred_at to temp_occurred_at to convert it into datetime datatype

alter table events add column temp_occurred_at datetime;

update events set temp_occurred_at = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

-- drop old varchar occurred_at
alter table events drop column occurred_at;

alter table events change column temp_occurred_at occurred_at datetime;


create table email_events(
user_id int,
occurred_at varchar(100),
action varchar(100),
user_type int
);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv'
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;

--  add a new column to copy occurred_at to temp_datetime to convert it into datetime datatype

alter table email_events add column temp_datetime datetime;

update email_events set temp_datetime = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

-- drop old varchar occurred_at
alter table email_events drop column occurred_at;

alter table email_events change column temp_datetime occurred_at datetime;