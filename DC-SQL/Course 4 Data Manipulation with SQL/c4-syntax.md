## CASE statement

- contain WHEN, THEN and ELSE statement.
- a new column is created with the alias_column_name  

overall syntax
```ruby
SELECT id, 
        CASE statement
FROM table
WHERE condition
```

case statement syntax
```ruby
    CASE 
        WHEN condition THEN result
        WHEN condition THEN result
        ELSE result 
    END AS alias_column_name
```
e.g CASE statement with one logical test in WHEN statement, returning outcomes based on whether that test is TRUE or FALSE.
```ruby
    CASE 
        WHEN x > y THEN 'x wins'
        WHEN x < y THEN 'y wins'
        ELSE 'tie' 
    END AS result
```
e.g CASE statement with multiple logical conditions : use AND,OR
```ruby
CASE WHEN team_id = 10 AND x_score > y_socre THEN 'team 10 wins for x'
```

### controlling NULL in CASE
in the following query, we have NULL values for those for tie. 
```ruby
SELECT 
    CASE 
        WHEN x > y THEN 'x wins'
    END AS result
FROM table
```
in the following query, we have 'x wins' values for (x > y rows) and for the others will be filled with NULL.  
how about if you don't want to see null values in your result?  
NOT NULL  
```ruby
SELECT 
    CASE 
        WHEN x > y THEN 'x wins'
        WHEN x < y THEN 'y wins'
    END AS result
FROM table
WHERE 
    CASE 
        WHEN x > y THEN 'x wins'
        WHEN x < y THEN 'y wins'
    END IS NOT NULL
```

### CASE WHEN with aggregate functions
#### COUNTing CASEs
```ruby 
SELECT 
    season,
    COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN id END) AS home_wins,
    COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal THEN 54321 END) AS home_wins,
    COUNT(CASE WHEN hometeam_id = 8650 AND home_goal < away_goal THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season;
```
#### CASE WHEN with SUM
```ruby
SELECT 
    season,
    SUM(CASE WHEN hometeam_id = 8650 THEN home_goal END) AS home_goals,
    SUM(CASE WHEN awayteam_id = 8650 THEN away_goal END) AS away_goals,
FROM match
GROUP BY season;
```

#### CASE WHEN with AVG
```ruby
SELECT 
    season,
    AVG(CASE WHEN hometeam_id = 8650 THEN home_goal END) AS avg_home_goals,
    AVG(CASE WHEN awayteam_id = 8650 THEN away_goal END) AS avg_away_goals,
FROM match
GROUP BY season;
```

#### round the avg
```ruby
SELECT 
    season,
    ROUND(AVG(CASE WHEN hometeam_id = 8650 THEN home_goal END),2) AS avg_home_goals,
FROM match
GROUP BY season;
```

- percentages
question: What percentage of Liverpool's games did they win in each season?
```ruby
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
```

#### round the percentages
```ruby
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
```
