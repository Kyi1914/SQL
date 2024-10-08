-- acknowledgement: this exercises are from DATACAMP SQL TRACK

-- check the schema in readme.

-- Return the unique countries from the films table
SELECT DISTINCT country
FROM films;

-- Count the distinct countries from the films table
SELECT COUNT(DISTINCT country) AS count_distinct_countries
FROM films;

-- Filtering with Where

-- Select film_ids and imdb_score with an imdb_score over 7.0
SELECT film_id, imdb_score
FROM reviews
WHERE imdb_score > 7

-- Select film_ids and facebook_likes for ten records with less than 1000 likes 
SELECT film_id, facebook_likes
FROM reviews
WHERE facebook_likes < 1000
LIMIT 10;

-- Count the records with at least 100,000 votes
SELECT Count(*) AS films_over_100K_votes
FROM reviews
WHERE num_votes >= 100000;

-- Count the Spanish-language films
SELECT Count(language) AS count_spanish
FROM films
WHERE language = 'Spanish';

-- Filtering Number using multiple criteria

-- AND

-- Select the title and release_year for all German-language films released before 2000
SELECT title, release_year
FROM films
WHERE language='German' AND release_year<2000;

-- Update the query to see all German-language films released after 2000
SELECT title, release_year
FROM films
WHERE release_year > 2000
	AND language = 'German';

-- Select all records for German-language films released after 2000 and before 2010
SELECT *
FROM films
WHERE release_year < 2010 
    AND release_year > 2000
	AND language = 'German';

--OR
-- This time you'll write a query to get the title and release_year of films released in 1990 or 1999, 
-- which were in English or Spanish and took in more than $2,000,000 gross.
-- Find the title and year of films IN the 1990 or 1999

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
-- Filter films with Language
	AND (language = 'English' OR language = 'Spanish')
-- Filter films with more than $2,000,000 gross
	AND(gross > 2000000);

--Between
-- Select the title and release_year for films released between 1990 and 2000
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
-- Narrow down your query to films with budgets > $100 million
	AND budget > 100000000;
-- Restrict the query to only Spanish-language films
	AND language = 'Spanish';

SELECT title, release_year
FROM films
WHERE (release_year BETWEEN 1990 AND 2000
	AND budget > 100000000)
-- Amend the query to include Spanish or French-language films
	AND (language = 'Spanish' OR language = 'French');

-- Filtering Text with WHERE

-- Select the names that start with B
SELECT name
FROM people
WHERE name LIKE 'B%'  

-- Select the names that have r as the second letter
WHERE name LIKE '_r%';

-- Select names that don't start with A
WHERE name NOT LIKE 'A%';

-- Find the title and release_year for all films over two hours in length released in 1990 and 2000
SELECT title, release_year
FROM films
WHERE release_year IN(1990,2000) AND duration > 120 ;

-- Find the title and language of all films in English, Spanish, and French
SELECT title, language
FROM films
WHERE language IN('English','Spanish','French');

-- Count the unique titles
SELECT COUNT(DISTINCT title) AS nineties_english_films_for_teens
FROM films
-- Filter to release_years to between 1990 and 1999
WHERE release_year between 1990 AND 1999
-- Filter to English-language films
	AND language = 'English'
-- Narrow it down to G, PG, and PG-13 certifications
	AND certification IN('G','PG','PG-13');

-- List all film titles with missing budgets
SELECT title AS no_budget_info
FROM films
WHERE budget IS NULL;

-- Count the number of films we have language data for
SELECT COUNT(*) AS count_language_known
FROM films
WHERE language IS NOT NULL;

-- Chapter 3 - Aggregate Functions
-- Query the sum of film durations
SELECT SUM(duration) AS total_duration
FROM films;

-- Find the latest release_year
SELECT MAX(release_year) AS latest_year
FROM films;

-- Find the duration of the shortest film
SELECT Min(duration) AS shortest_film
FROM films;


-- Calculate the sum of gross from the year 2000 or later
SELECT SUM(gross) AS total_gross
FROM films 
WHERE release_year >= 2000

-- Calculate the average gross of films that start with A
SELECT AVG(gross) AS avg_gross_A
FROM films 
WHERE title LIKE 'A%';

-- Calculate the lowest gross film in 1994
SELECT MIN(gross) AS lowest_gross
FROM films 
WHERE release_year = 1994;

-- Calculate the highest gross film released between 2000-2012
SELECT MAX(gross) AS highest_gross
FROM films 
WHERE release_year BETWEEN 2000 AND 2012;

-- Round the average number of facebook_likes to one decimal place
SELECT ROUND(AVG(facebook_likes),1) AS avg_facebook_likes
FROM reviews ;

-- Calculate the average budget rounded to the thousands
SELECT ROUND(AVG(budget),-3) AS avg_budget_thousands
FROM films;

-- Arithmetic Operations
-- Calculate the title and duration_hours from films
SELECT title, duration/60.0 AS duration_hours
FROM films;

-- Calculate the percentage of people who are no longer alive
SELECT COUNT(deathdate) * 100.0 / COUNT(*) AS percentage_dead
FROM people;

-- Find the number of decades in the films table
SELECT (MAX(release_year) - MIN(release_year)) / 10.0 AS number_of_decades
FROM films;

-- Round duration_hours to two decimal places
SELECT title, ROUND((duration / 60.0),2) AS duration_hours
FROM films;

-- Chapter 4 Sorting
-- Select name from people and sort alphabetically
SELECT name
FROM people
ORDER BY name;

-- Select the title and duration from longest to shortest film
SELECT title, duration
FROM films
ORDER BY duration;

-- Select the release year, duration, and title sorted by release year and duration
SELECT release_year, duration, title
FROM films
ORDER BY release_year, duration;

-- Select the certification, release year, and title sorted by certification and release year
SELECT certification, release_year, title
FROM films
ORDER BY certification, release_year;

-- GROUP BY
-- Find the release_year and film_count of each year
SELECT release_year, COUNT(id) AS film_count
FROM films
GROUP BY release_year;

-- Find the release_year and average duration of films for each year
SELECT release_year, AVG(duration) AS avg_duration
FROM films
GROUP BY release_year;

-- Find the release_year, country, and max_budget, then group and order by release_year and country

SELECT release_year, country, MAX(budget) AS max_budget
FROM films
GROUP BY release_year, country
ORDER BY release_year, country;

-- language diversity count
SELECT release_year, COUNT(DISTINCT language) AS language_diversity_count
FROM films
GROUP BY release_year
ORDER BY language_diversity_count DESC;

-- filtering with grouping
-- Select the country and distinct count of certification as certification_count
SELECT country, COUNT(DISTINCT(certification)) AS certification_count
FROM films
-- Group by country
GROUP BY country
-- Filter results to countries with more than 10 different certifications
HAVING COUNT(DISTINCT(certification)) > 10;

-- Select the country and average_budget from films
SELECT country, AVG(budget) AS average_budget
FROM films
-- Group by country
GROUP BY country
-- Filter to countries with an average_budget of more than one billion
HAVING AVG(budget) > 1000000000
-- Order by descending order of the aggregated budget
ORDER BY average_budget DESC

-- In this exercise, you'll write a query that returns 
-- the average budget and gross earnings for films each year after 1990 if the average budget is greater than 60 million.
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
-- Order the results from highest to lowest average gross and limit to one
ORDER BY avg_gross DESC
LIMIT 1;
