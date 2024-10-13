-- Chapter 1
-- 4.1 CASE
-- 4.1.1 CASE statement
    -- contain WHEN, THEN and ELSE statement.
    CASE WHEN condition THEN result
    CASE WHEN condition THEN result
    ELSE result END AS alias_column_name

    -- e.g
    CASE WHEN x > y THEN 'x wins'
    CASE WHEN x < y THEN 'y wins'
    ELSE 'tie' END AS result

    -- query with CASE
    -- get the outcome of the matches of season 2013/2014
    SELECT 
        id, 
        home_goal, 
        away_goal,
        CASE WHEN home_goal > away_goal THEN 'home team win'
             WHEN home_goal < away_goal THEN 'away team win'
             ELSE 'tie' END AS outcome
    FROM match
    WHERE season = '2013/2014'

-- ### NULL in CASE ###

-- this query includes null in result
SELECT 
    date, season,
    CASE 
        WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 'Chelsea home win'
        WHEN awayteam_id = 8455 AND home_goal < away_goal THEN 'Chelsea away win'
    END AS outcome 

-- to filter NULL

FROM match
SELECT 
    date, season,
    CASE 
        WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 'Chelsea home win'
        WHEN awayteam_id = 8455 AND home_goal < away_goal THEN 'Chelsea away win'
    END AS outcome 
FROM match
WHERE 
    CASE 
        WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 'Chelsea home win'
        WHEN awayteam_id = 8455 AND home_goal < away_goal THEN 'Chelsea away win'
    END IS NOT NULL

-- ### CASE with aggregate functions ###
-- prepare a summary table counting the number of home and away games that Liverpool won in each season.
-- CASE WHEN with COUNT
SELECT 
    season,
    COUNT(CASE WHEN hometeam_id = 8650
          AND home_goal > away_goal
          THEN id END) AS home_wins
FROM match
GROUP BY season;

SELECT 
    season,
    COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 54321 END) AS home_wins,
    COUNT(CASE WHEN hometeam_id = 8650 AND home_goal < away_goal THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season;

-- CASE WHEN with SUM
SELECT 
    season,
    SUM(CASE WHEN hometeam_id = 8650 THEN home_goal END) AS home_goals,
    SUM(CASE WHEN awayteam_id = 8650 THEN away_goal END) AS away_goals,
FROM match
GROUP BY season;

-- CASE WHEN with AVG
SELECT 
    season,
    AVG(CASE WHEN hometeam_id = 8650 THEN home_goal END) AS avg_home_goals,
    AVG(CASE WHEN awayteam_id = 8650 THEN away_goal END) AS avg_away_goals,
FROM match
GROUP BY season;

-- round the avg
SELECT 
    season,
    ROUND(AVG(CASE WHEN hometeam_id = 8650 THEN home_goal END),2) AS avg_home_goals,
FROM match
GROUP BY season;

-- percentages
-- What percentage of Liverpool's games did they win in each season?
SELECT 
    season,
    AVG(CASE 
            WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 1 
            WHEN hometeam_id = 8650 AND home_goal < away_goal THEN 0
        END) AS percentages_homewins
    AVG(CASE 
            WHEN awayteam_id = 8650 AND home_goal < away_goal THEN 1
            WHEN awayteam_id = 8650 AND home_goal > away_goal THEN 0
        END) AS percentages_awaywins
FROM match
GROUP BY season;

-- round the percentages
SELECT 
    season,
    ROUND(AVG(CASE 
            WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 1 
            WHEN hometeam_id = 8650 AND home_goal < away_goal THEN 0
        END),2) AS percentages_homewins
    ROUND(AVG(CASE 
            WHEN awayteam_id = 8650 AND home_goal < away_goal THEN 1
            WHEN awayteam_id = 8650 AND home_goal > away_goal THEN 0
        END),2) AS percentages_awaywins
FROM match
GROUP BY season;

-- # Chapter 2 #
-- 2.1 WHERE are the subquery?
-- subquery can be placed in any part of a query.
-- > SELECT, FROM, WHERE , GROUP BY

-- (1) simple subqueries: can be evaluated indepently from the outer query
SELECT home_goal
FROM match
WHERE home_goal > (
    SELECT AVG(home_goal)
    FROM match
);

-- subqueries in the WHERE clause
-- which matches in the 2012/2013 season scored home goals higher than overall average?
SELECT AVG(home_goal) 
FROM match;

SELECT *
FROM match
WHERE season = '2012/2013' 
    AND home_goal > (SELECT AVG(home_goal)
                    FROM match);

-- (2) useful for filtering list 
-- Which teams are part of Poland's league?
SELECT 
    team_long_name,
    team_short_name AS abbr
FROM team
WHERE team_api_id IN 
    (SELECT home_team_id
    FROM match
    WHERE country_id = 15722);
 




-- 4.1.2 simple subqueries
-- 4.1.3 Correlated subqueries
-- 4.1.4 Window functions