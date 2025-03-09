use projectcs2;

SELECT 
    *
FROM
    job_data;
    
/******   Case Study 2: Job Data Analysis   ******/

-- Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.

SELECT 
    date_,
    ROUND(COUNT(*) / (SUM(time_spent) / 3600), 2) job_per_hour
FROM
    job_data
WHERE date_ BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY date_
ORDER BY date_; 

-- Write an SQL query to calculate the 7-day rolling average of throughput. Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.



-- Write an SQL query to calculate the percentage share of each language over the last 30 days.

SELECT 
language, 
ROUND(COUNT(*)*100.0/
(SELECT COUNT(*) FROM job_data 
WHERE date_ BETWEEN '2020-11-01' AND '2020-11-30'), 2) percentage
FROM job_data
GROUP BY language;


--  Write an SQL query to display duplicate rows from the job_data table.

SELECT job_id, actor_id, event, language, time_spent, org, date_ FROM job_data
GROUP BY job_id, actor_id, event, language, time_spent, org, date_ 
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;