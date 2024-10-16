# Course 5: PostgreSQL Summary Stats and Window Functions

## Table of Contents
1. [Chapter 1: Introduction to window functions](#chapter-1-introduction-to-window-functions)
- [1.1 Introduction](#11-introduction)
- [1.2 ORDER BY](#12-order-by)
- [1.3 PARTITION BY](#13-partition-by)

2. [Chapter 2: Fetching, ranking and paying](#chapter-2-fetching-ranking-and-paying)
- [2.1 Fetching](#21-fetching)
- [2.2 Ranking](#22-ranking)
- [2.3 Paging](#23-paging)

3. [Aggregate window functions and frames](#chapter-3-aggregate-window-functions-and-frames)
- [3.1 Aggregate window functions](#31-aggregate-window-functions)
- [3.2 Frames](#32-frames)
- [3.3 Moving averages and totals](#33-moving-averages-and-totals)

4. [Chapter 4: Beyond window functions](#chapter-4-beyond-window-functions)
- [4.1 Pivoting](#41-pivoting)
- [4.2 ROLLUP and CUBE](#42-rollup-and-cube)
- [4.3 A survey of useful functions](#43-a-survey-of-useful-functions)

## Chapter 1: Introduction to window functions
### 1.1 Introduction
> [!NOTE]  
> adding row number to assign to each row  : ```ROW_NUMBER()  OVER() AS row_number```  
> Anatomy:
> - OVER() indicades that a function is a window function.
> - parentheses after OVER can be 
>   - empty, 
>   - contain subclasses : ORDER BY, PARTITION BY, ROWS or RANGE PRECEDING, FOLLOWING or UNBOUNDED   
>
> these subclauses change the window function's output

Query: 
```ruby
SELECT 
    Year, Event, Country,
    ROW_NUMBER() OVER() AS Row_N
FROM Summer_Medals
WHERE Medal = 'Gold'
```
<img src = '.\image\l1.png'>

### 1.2 ORDER BY
> [!NOTE]  
> ORDER BY(): 
> - a subclause of OVER.
> - ```ROW_NUMBER()  OVER(ORDER BY year DESC) AS row_number```
> - ```ROW_NUMBER()  OVER(ORDER BY year DESC, Event ASC) AS row_number```
>
> LAG(column, n):
> - window function that takes a column and a number n and returns the column's value n rows before the current row. 
> - ```LAG(column, 1)``` >> returns the previous row's value.

Query: 
```ruby
SELECT 
    Year, Event, Country,
    ROW_NUMBER() OVER(ORDER BY Year DESC) AS Row_N
FROM Summer_Medals
WHERE Medal = 'Gold'
```
<img src = '.\image\l2.png'>

Query: 
```ruby
SELECT 
    Year, Event, Country,
    ROW_NUMBER() OVER(ORDER BY Year DESC,  Event ASC) AS Row_N
FROM Summer_Medals
WHERE Medal = 'Gold'
```
<img src = '.\image\l3.png'>

Query: ordering in- and outside OVER
```ruby
SELECT 
    Year, Event, Country,
    ROW_NUMBER() OVER(ORDER BY Year DESC,  Event ASC) AS Row_N
FROM Summer_Medals
WHERE Medal = 'Gold'
ORDER BY Country ASC, Row_N ASC;
```
<img src = '.\image\l4.png'>

Query:
```ruby
# get the gold medal country in discus throw during 1996, 2000 and 2012
WITH Discus_Gold AS (
    SELECT 
        Year, Country AS Champion
    FROM Summer_Medals
    WHERE 
        Year IN (1996, 2000, 2012)
        AND Gender = 'Men' 
        AND Medal = 'Gold' 
        AND Event = 'Discus Throw'
)

SELECT 
    Year, Champion,
    LAG(Champion, 1) OVER (ORDER BY Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Year ASC;
```
<img src = '.\image\l5.png'>

### 1.3 PARTITION BY
> [!NOTE]  
> PARTITION BY(): 
> - SPLITS the table into partitions based on a column's unique values.
>    - the results aren't rolled into one column.
>    - ROW_NUMBER() will reset for each partition.
>    - LAG(column, n) will only fetch a row's previous n values in the same partition.
>
> syntax : ```OVER(PARTIONTION BY column ORDER BY column ASC/DESC)```  
>
> Partition by multiple columns:  
> syntax: ```ROW_NUMBER() OVER(PARTITION BY year, country)```  
> - Each combination of the unique values of Year and Country will be a partition. 
>   - 2008 - China is one partition; 
>   - 2008 - Japan is another, 2012 
>   - China is yet another.  

Query:
```ruby
WITH Discus_Gold AS (
    ---
)
SELECT 
    year, event, champion,
    LAG(champion) OVER (PARTITION BY event ORDER BY event ASC) AS last_champion
FROM Discus_Gold
ORDER BY event ASC, year ASD;
```
<img src = '.\image\l6.png'>


## Chapter 2: Fetching, ranking and paying
### 2.1 Fetching
> [!NOTE]  
> LEAD(column,n): 
> - returns the value at n rows AFTER the current row.
>
> Relative Fetching Functions: LEAD(column,n) and LAG(column,n)
> Absolute Fetching Functions: FIRST_VALUE(column), LAST_VALUE(column)
> - FIRST_VALUE(column) returns the first value in the table or partition
> - LAST_VALUE(column) eturns the last value in the table or partition. 
>
> RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING: 
>- a window starts at the beginning of the table or partition and ends at the current row.

Query: returns the cities in which each set of Olympic Games was held, as well as the next two cities.
```ruby
WITH hosts AS (
    SELECT DISTINCT year, city
    FROM summer_medals
)
SELECT 
    year, city, 
    LEAD(city, 1) OVER (ORDER BY year ASC) AS next_city,
    LEAD(city, 2) OVER (ORDER BY year ASC) AS after_next_city
FROM hosts
ORDER BY year ASC;
```
<img src = '.\image\l7.png'>

Query: 
```ruby
SELECT
    year, city,
    FIRST_VALUE(city) OVER(ORDER BY year ASC) AS first_city,
    LAST_VALUE(city) OVER(
                            ORDER BY year ASC
                            RANGE BETWEEN 
                                UNBOUNDED PRECEDING AND 
                                UNBOUNDED FOLLOWING
                        ) AS last_city
FROM Hosts
ORDER BY year ASC;
```
<img src = '.\image\l8.png'>

### 2.2 Ranking
> [!NOTE]  
> 3 ranking functions: 
> - ```ROW_NUMBER()```: always assigns unique numbers, even if two rows' values are the same;
> - ```RANK()```: assigns the same number to rows with identical values, skipping over the next numbers in such cases.
> - ```DENSE_RANK()```: assigns the same number to rows with identical values, but doesn't skip over the next numbers. 
>

Query: returns the number of Olympic games in which each of these countries has participated.
```ruby
SELECT 
    country, COUNT(DISTINCT year) AS games
FROM summer_medals
WHERE 
    country IN ('GBR','DEN','FRA','ITA')
GROUP BY country
ORDER BY games DESC;
```
<img src = '.\image\l9.png'>

Query > Different Ranking functions
```ruby
WITH country_games AS (---)

SELECT 
    country, games,
    ROW_NUMBER() 
        OVER(ORDER BY games DESC) AS Row_N,
    RANK() 
        OVER(ORDER BY games DESC) AS Rank_N,
    DENSE_RANK()
        OVER(ORDER BY games DESC) AS Dense_Rank_N,
FROM country_games
ORDER BY games DESC, country ASC;
```
<img src = '.\image\l12.png'>

Query > Ranking without partitioning - data source
``` ruby
SELECT 
    country, athlete, count(*) AS medals
FROM summer_medals
WHERE
    country IN ('CHN', 'RUS')
    AND Year = 2012
GROUP BY country, athlete
HAVING count(*) > 1
ORDER BY country ASC, medals DESC;
```
<img src = '.\image\l13.png'>

Query > Ranking with partitioning
``` ruby
WITH country_medals AS (
    --
)

SELECT 
    country, athlete,
    DENSE_RANK()
    OVER (
        PARTITION BY country
        ORDER BY medals DESC) AS Rank_N
FROM country_medals
ORDER BY country ASC, medals DESC;
```
<img src = '.\image\l14.png'>


### 2.3 Paging
> [!NOTE]  
> Paging is splitting data into (approximately) equal chunks. 
> - ```NTILE(n)```: splits the data into n approximately equal pages;
> - ```NTILE(15)```: want to split the total of 67 rows, into a group of 15 rows >> 16/15 = 4 or 5  
> 
> Another use for NTILE is to split the data into thirds or quartiles. 
>

Query > Ranking without partitioning - data source
``` ruby
WITH disciplines AS(
    SELECT DISTINCT discipline
    FROM summer_medals
)
SELECT 
    discipline, NTILE(15) OVER() AS page
FROM disciplines
ORDER BY page ASC;
```
<img src = '.\image\l15.png'>

Query > thirds or quartiles : Top, middle and bottom thirds     
the Country_Medals CTE counts the number of medals each country has been awarded overall in each set of Olympic Games.

```ruby
WITH country_medals AS (
    SELECT
        country, COUNT(*) AS medals
    FROM summer_medals
    GROUP BY country
),

SELECT 
    country, medals,
    NTILE(3) OVER (ORDER BY medals DESC) AS third
FROM country_medals;
```
<img src = '.\image\l16.png'>

Query > Thirds averages
```ruby
WITH country_medals AS (
    SELECT
        country, COUNT(*) AS medals
    FROM summer_medals
    GROUP BY country
),

thirds AS (
    SELECT 
        country, medals,
        NTILE(3) OVER (ORDER BY medals DESC) AS third
    FROM country_medals
)

SELECT 
    third,
    ROUND(AVG(medals),2) AS avg_medals
FROM thirds
GROUP BY third
ORDER BY third ASC;
```
<img src = '.\image\l17.png'>

## Chapter 3: Aggregate window functions and frames
### 3.1 Aggregate window functions
Query: Source Table
```ruby
SELECT 
    year, COUNT(*) AS medals
FROM summer_medals
WHERE
    country = 'BRA' AND
    medal = 'gold' AND
    year >= 1992
GROUP BY year
ORDER BY year ASC;
```
<img src = '.\image\l18.png'>

standard aggregate function > max query: 
```ruby
WITH brazil_medatls AS (--)
SELECT MAX(medals) FROM brazil_medals
```
standard aggregate function > Result > 18

```ruby
WITH brazil_medatls AS (--)
SELECT SUM(medals) FROM brazil_medals
```
Result > 64

> [!NOTE]  
> MAX, SUM, MIN, COUNT, AVG as window functions.  
>

#### MAX window function  
Query  
```ruby
WITH brazil_medatls AS (--)
SELECT 
    year, medals,
    MAX(medals) OVER (ORDER BY year ASC) AS max_medals
FROM brazil_medals
```
<img src = '.\image\l19.png'>    

in 1992, Brazil earned 13 medals. Since it's the first row, that's the max so far of medals earned. In the next set of games, those of 1996, only 5 medals were earned, so the max is still 13. In 2004, the games after the 1996 games, 18 medals were earned, which is higher than the previous max of 13, so the max becomes 18.  

#### SUM window function  
Query 
```ruby
WITH brazil_medatls AS (--)
SELECT 
    year, medals,
    SUM(medals) OVER (ORDER BY year ASC) AS medals_rt
FROM brazil_medals
```
<img src = '.\image\l20.png'>    

#### Partitioning with aggregate window function 
Query 
```ruby
WITH medatls AS (--)
SELECT 
    year, medals,
    SUM(medals) OVER (PARTITION BY country ORDER BY year ASC) AS medals_rt
FROM medals
```

### 3.2 Frames
> [!NOTE]  
> Another way to change the window function behaviour
> By default, a frame starts at the beginning of a table or partition and ends at the current row
> Frame: 
>- ```UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING```
>- ```ROWS BETWEEN``` : ROWS BETWEEN [start] AND [FINISH]
>   - Start and finish can be one of 3 clauses: ```PRECEDING, CURRENT ROW, and FOLLOWING. ```
>   - CURRENT ROW is to set the start or finish at the current row, 
>   - n FOLLOWING is to set it at n rows after the current row. 
>   - e.g 
>       - ```ROWS BETWEEN 3 PRECEDING AND CURRENT ROW```: starts 3 rows before the current row and ends at the current row
>       - ```ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING```: one row before the current row and ends one row after the current row, so the frame is 3 rows.
>       - ```ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING```:  five rows before the current row and ends one row before the current row, so the frame is 5 rows.
>

#### MAX with a frame
```ruby
WIHT russia_medals AS (
    SELECT 
        year, COUNT(*) AS medals
    FROM summer_medals
    WHERE 
        country = 'RUS'
        AND medal = 'gold'
    GROUP BY year
    ORDER BY year ASC;
)

SELECT 
    year, medals, 
    MAX(medals) OVER (ORDER BY year ASC) AS max_medals,
    MAX(medals) 
                OVER (ORDER BY year ASC
                      ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS max_medals_last
FROM russia_medals
ORDER BY year ASC;
```
<img src = '.\image\l21.png'> 

### 3.3 Moving averages and totals
> [!NOTE]  
> Moving average(MA): Average of last n periods
> - used to indicate momentum / trends
> - useful in eliminating seasonality
> Moving average : AVG() OVER (frames syntax)
> Moving total : SUM() OVER (frames syntax)
> ```RANGE BETWEEN [start] AND [finish]```
> - RANGE treats duplicates in the columns in the ORDER BY subclause as single entities, whereas ROWS does not.

#### 3 Years Moving Average
```ruby
WIHT us_medals AS (
    SELECT 
        year, COUNT(*) AS medals
    FROM summer_medals
    WHERE 
        country = 'USA'
        AND medal = 'gold'
        AND year >= 1980
    GROUP BY year
    ORDER BY year ASC;
)

SELECT 
    year, medals, 
    AVG(medals) 
                OVER (ORDER BY year ASC
                      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS medal_MA
FROM us_medals
ORDER BY year ASC;
```
<img src = '.\image\l22.png'> 

## Chapter 4: Beyond window functions
### 4.1 Pivoting
> [!NOTE]  
> - to transform ranking data from a vertical to a horizontal structure,
> KEYWORDS: ```CROSSTAB```
> ```CREATE EXTENSION IF NOT EXISTS tablefunc;```
> - CREATE EXTENSION: makes extra functions in an extension available for use.
> - tablefunc: contains the CROSSTAB function
> ```SELECT * FROM CROSSTAB ($ sourceSQL $) S ct (columnName DataType)```

Queries  
Before
```ruby
SELECT 
    country, year, COUNT(*) AS Awards
FROM summer_medals
WHERE 
    country IN ('CHN','RUS','USA')
    AND year in (2008, 2012)
    AND medal = 'gold'
GROUP BY country, year
ORDER BY country ASC, year ASC;
```
After
```ruby
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB ($$
    SELECT 
        country, year, COUNT(*)::INTEGER AS Awards
    FROM summer_medals
    WHERE 
        country IN ('CHN','RUS','USA')
        AND year in (2008, 2012)
        AND medal = 'gold'
    GROUP BY country, year
    ORDER BY country ASC, year ASC;
$$) AS ct (country VARCHAR, "2008" INTEGER, '2012' INTEGER)
ORDER BY country ASC;
```

### 4.2 ROLLUP and CUBE

#### ROLLUP
> [!NOTE]  
> - to calculate group-level and grand totals
> KEYWORDS: ```ROLLUP```
>  - GROUP BY subclause that includes extra rows for group level aggregations.

Query  

The old way
```ruby
SELECT 
    country, medal, COUNT(*) AS Awards
FROM summer_medals
WHERE 
    year = 2008 AND country IN ('CHN','RUS')
GROUP BY country, medal
ORDER BY country ASC, medal ASC

UNION ALL

SELECT 
    country, 'total', COUNT(*) AS Awards
FROM summer_medals
WHERE 
    year = 2008 AND country IN ('CHN','RUS')
GROUP BY country, 2
ORDER BY country ASC;

```
ROLLUP Query
```ruby
SELECT
    country, medal, COUNT(*) AS Awards
FROM summer_medals
WHERE
    year = 2008 AND country IN ('CHN', 'RUS')
GROUP BY ROLLUP(country, medal)
ORDER BY country ASC, medal ASC;
```
<img src = '.\image\l23.png'>   

The rows for which Country is filled but Medal is null represent the Country-level totals; for example, 184 medals in total were awarded to China in 2008.   
he row with nulls in both columns is the grand total.  
Notice that there are no Medal-level totals, since you're ROLL-ing UP by Country then Medal, and not vice-versa.   

#### CUBE
> [!NOTE]  
> - to calculate group-level and grand totals, much like its cousin ROLLUP, except that it's not hierarchical. It generates all possible group-level aggregations.
> KEYWORDS: ```ROLLUP```
>  - GROUP BY subclause that includes extra rows for group level aggregations.

CUBE Query
```ruby
SELECT
    country, medal, COUNT(*) AS Awards
FROM summer_medals
WHERE
    year = 2008 AND country IN ('CHN', 'RUS')
GROUP BY CUBE(country, medal)
ORDER BY country ASC, medal ASC;
```
<img src = '.\image\l24.png'>  

Notice that Medal-level totals are included as well as Country-level totals.   
The Medal-level totals are those whose Country is null but whose Medal is not.   
For example, China and Russia were awarded a total of 117 gold medals in 2008. The grand total is also included.

### 4.3 A survey of useful functions
> [!NOTE]  
> Nulls ahoy : ```COALESCE```

Query
```ruby
SELECT
    COALESCE(country, 'Both countries') AS country,
    COALESCE(medal, 'All medals') AS medal,
    COUNT(*) AS Awards
FROM summer_medals
WHERE
    year = 2008 AND country IN ('CHN', 'RUS')
GROUP BY CUBE(country, medal)
ORDER BY country ASC, medal ASC;
```
<img src = '.\image\l25.png'> 

> [!NOTE]  
> Compressing data : ```STRING_AGG (column, separator)```
> ```STRING_AGG(Letter,', ')``` >> A, B, C

```ruby
SELECT STRING_AGG(country, ', ')
FROM country_medals
```


