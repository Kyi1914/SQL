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
### 2.2 Ranking
### 2.3 Paging

## Chapter 3: Aggregate window functions and frames
### 3.1 Aggregate window functions
### 3.2 Frames
### 3.3 Moving averages and totals

## Chapter 4: Beyond window functions
### 4.1 Pivoting
### 4.2 ROLLUP and CUBE
### 4.3 A survey of useful functions
