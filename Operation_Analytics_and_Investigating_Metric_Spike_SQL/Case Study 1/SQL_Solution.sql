use projectcs1;

/******   Case Study 1: Investigating Metric Spike   ******/

-- Write an SQL query to calculate the weekly user engagement.
 
SELECT 
    WEEKOFYEAR(occurred_at) week_num,
    COUNT(DISTINCT user_id) active_users
FROM
    events
GROUP BY week_num
ORDER BY week_num;

-- Write an SQL query to calculate the user growth for the product.

SELECT 
	DATE_FORMAT(created_at, '%Y-%m') month,
    COUNT(*) users_count,
    SUM(COUNT(*)) OVER(ORDER BY DATE_FORMAT(created_at, '%Y-%m')) AS user_growth
FROM users
GROUP BY month;

-- Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.

SELECT 
    WEEKOFYEAR(occurred_at) week,
    device,
    COUNT(DISTINCT user_id) active_users
FROM
    events
GROUP BY week , device
ORDER BY week , device;


-- Write an SQL query to calculate the email engagement metrics.

SELECT 
    action,
    COUNT(*) action_occurred_count,
    COUNT(DISTINCT (user_id)) unique_users
FROM
    email_events
GROUP BY action
ORDER BY action_occurred_count DESC;

