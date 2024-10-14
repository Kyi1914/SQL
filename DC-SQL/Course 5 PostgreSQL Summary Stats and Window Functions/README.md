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
### 3.2 Frames
### 3.3 Moving averages and totals

## Chapter 4: Beyond window functions
### 4.1 Pivoting
### 4.2 ROLLUP and CUBE
### 4.3 A survey of useful functions
