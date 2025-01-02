/************** Marketing Analysis **************/

-- Identify the five oldest users on Instagram from the provided database.
SELECT username FROM users
ORDER BY created_at 
LIMIT 5;

-- Identify users who have never posted a single photo on Instagram.
SELECT U.username FROM users U
LEFT JOIN photos P
ON P.user_id = U.id
WHERE P.id IS NULL;

-- Determine the winner of the contest and provide their details to the team.
SELECT 
	U.id user_id, 
	U.username, 
	P.id photo_id 
FROM likes L
INNER JOIN photos P
ON P.id = L.photo_id
INNER JOIN users U
ON U.id = P.user_id
GROUP BY P.id, U.id, U.username
ORDER BY COUNT(*) DESC
LIMIT 1;

--  Identify and suggest the top five most commonly used hashtags on the platform.
SELECT tag_name FROM tags T
INNER JOIN photo_tags PT
ON T.id = PT.tag_id
GROUP BY T.id
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

SELECT 
    DAYNAME(created_at) AS week_day, COUNT(*) user_registered
FROM
    users
GROUP BY DAYNAME(created_at)
ORDER BY user_registered DESC; 


/************** Investor Metrics **************/

-- Calculate the average number of posts per user on Instagram. Also, provide the total number of photos on Instagram divided by the total number of users.

SELECT ROUND(AVG(post_count), 2) Avg_posts_per_user,
(SELECT (SELECT COUNT(*) FROM photos)/ (SELECT COUNT(*) FROM users) ) photos_per_user
FROM
	(
		SELECT U.id, COUNT(*) AS post_count FROM users U
		INNER JOIN photos P
		ON P.user_id = U.id
		GROUP BY U.id
	) sub_querie;

-- Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user. 

SELECT 
    user_id, U.username
FROM
    likes l
        INNER JOIN
    users U ON U.id = l.user_id
GROUP BY user_id , U.username
HAVING COUNT(*) = (SELECT 
        COUNT(DISTINCT id)
    FROM
        photos);
