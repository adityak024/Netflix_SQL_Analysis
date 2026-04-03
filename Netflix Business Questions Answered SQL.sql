-- Netflix Project

create database netflix_db;
drop table if exists netflix;
create table netflix
(
	show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE 'D:/Analytics Projects/netflix_dataset.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- Changed from \r\n to \n
IGNORE 1 ROWS
(show_id, @type, @title, @director, @casts, @country, @date_added, @release_year, @rating, @duration, @listed_in, @description)
SET 
    type = NULLIF(@type, ''),
    title = NULLIF(@title, ''),
    director = NULLIF(@director, ''),
    casts = NULLIF(@casts, ''),
    country = NULLIF(@country, ''),
    date_added = NULLIF(@date_added, ''),
    release_year = NULLIF(@release_year, ''),
    rating = NULLIF(@rating, ''),
    duration = NULLIF(@duration, ''),
    listed_in = NULLIF(@listed_in, ''),
    description = NULLIF(@description, '');
    
select * from netflix;

-- 15 Business Questions on Netflix

-- 1. Count the number of Movies vs TV Shows
select type, count(*) as total_content
from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows
with RatingCounts as (
	select type, rating, count(*) as rating_count
    from netflix
    group by type, rating
),
RankedRating as (
	select type, rating, rating_count,
    RANK() over (partition by type order by rating_count desc) as ranks
    from RatingCounts
)
select type, rating as most_common_rating
from RankedRating
where ranks=1;


-- 3. List all movies released in a specific year (e.g., 2020)
select title from netflix
where 
	type = 'Movie'
    and
    release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS single_country,
    COUNT(*) AS total_content
FROM netflix
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 
    UNION SELECT 4 UNION SELECT 5
) AS n
ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= n.n - 1
WHERE country IS NOT NULL
GROUP BY single_country
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the longest movie
select type, title, duration
from netflix
where type = 'Movie'
order by cast(substring_index(duration,' ',1) as unsigned) desc
limit 1;


-- 6. Find content released in the last 5 years
select release_year, count(*) as content_added
from netflix
group by release_year
order by release_year desc
limit 5;


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix
where director = 'Rajiv Chilaka';


-- 8. List all TV shows with more than 5 seasons
select *
from netflix
where type = 'TV Show'
and cast(substring_index(duration,' ', 1) as unsigned) > 5;


-- 9. Count the number of content items in each genre
select * from netflix;
-- to check the number of genres in one row
SELECT 
    MAX(CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) + 1) AS max_genres
FROM netflix;

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre,
    COUNT(*) AS total_content
FROM netflix
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3
) AS n
ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY total_content DESC;


-- 10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release!
select * from netflix;
select 
	country,
	release_year,
    count(show_id) as total_release,
    round(
		  count(show_id)/(select count(show_id) from netflix where country = 'India')*100
		, 2) as avg_release
from netflix
where country = 'India'
group by country, release_year
order by avg_release desc
limit 5;


-- 11. List all movies that are documentaries
select * 
from netflix
where type = 'Movie'
and
listed_in like '%Documentaries%';


-- 12. Find all content without a director
select * 
from netflix
where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where casts like '%Salman Khan%'
and
type = 'Movie'
and
release_year >= year(curdate()) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	trim(substring_index(substring_index(casts, ',', n.n), ',', -1)) as actor,
    count(*) as total_movies
from netflix
join (
		select 1 as n union select 2 union select 3 union SELECT 4 UNION SELECT 5
        UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
	) as n
on char_length(casts) - char_length(replace(casts, ',', ' ')) >= n.n -1
where country like '%India%'
and type = 'Movie'
and casts is not null
group by actor
order by total_movies desc
limit 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
select category, count(*) as Total_content
from (
		select
			case
				when description like '%kill%'
                or description like '%violence%'
                then 'Bad'
                else 'Good'
			end as category
		from netflix
	) as categorized_content
group by category;