-- Introduction to SQL

Important Notes:
* = represents all field

-- DISTINCT // get the unique data
SELECT DISTINCT field_name
FROM table_name;

-- Alias the filed name in the result
SELECT DISTINCT field_name AS alias_of_field_name
FROM table_name;

-- View table
-- Save the results of this query as a view called library_authors
CREATE VIEW [view_table_name] AS
SELECT [query];

-- Select all columns from library_authors
SELECT * 
FROM table_name;

-- LIMIT
SELECT field_name
FROM table_name
LIMIT 10;

-- Advanced SQL

-- COUNT() // number of records
-- COUNT(field name) = count values in a field
SELECT COUNT(field_name) AS alias_of_field_name
FROM table_name;

SELECT COUNT(field_name) AS alias_of_field_name, COUNT(field_name) AS alias_of_field_name
FROM table_name;

-- COUNT(*) = count records in a table
SELECT COUNT(*) AS alias_of_field_name
FROM table_name;

-- COUNT() with DISTINCT // to count unique values
SELECT COUNT(DISTINCT field_name) AS alias_of_field_name
FROM table_name;

--Filtering using WHERE

-- basic syntax
SELECT field_name
FROM table
WHERE condition
LIMIT number;

-- where with comparison operators
SELECT field_name
FROM table
WHERE field_name > number;

-- < ~ less than or before, 
-- > ~ greather than or after, 
-- = ~ exactly the same or equal to, 
-- <= ~ less than and equal to, 
-- <> ~ except this number, not equal to

SELECT field_name
FROM table
WHERE field_name = 'string value';

-- Filtering using multiple criteria
Operator >> AND, OR, BETWEEN

SELECT * 
FROM table_name
WHERE condition1 OPERATOR condition2;

SELECT * 
FROM table_name
WHERE (condition1 OR condition2) AND (condition3 OR condition4);

SELECT * 
FROM table_name
WHERE field_name BETWEEN creteria 1 AND creteria 2;

-- Filtering Text with WHERE
-- Filtering a pattern using LIKE, NOT LIKE, IN
-- LIKE >> % match zero,one or many characters , _ match a single character

SELECT field_name
FROM table_name
WHERE field_name LIKE 'Ade%' 
-- to get Adele, Adelaide Kane

SELECT field_name
FROM table_name
WHERE field_name LIKE 'Ev_' 
--return Eve, Eva

SELECT field_name
FROM table_name
WHERE field_name NOT LIKE 'A.%'

-- return the name with the last character is 'r'
WHERE name LIKE '%r' 
-- return the name with the third character is 'r'
WHERE name LIKE '__r%' 
-- return the movie release in 1920,1930,1940
WHERE release_year IN (1920,1930,1940);

WHERE country IN ('Germany','French');

-- Find the title, certification, and language all films certified NC-17 or R that are in English, Italian, or Greek
SELECT title, certification, language
FROM films
WHERE certification IN('NC-17', 'R') 
    AND language IN('English','Italian','Greek') ;

-- Null values
COUNT(field_name) includes only non-missing values 
COUNT(*) includes missing values 

-- get the records wher field_name 2 is null
SELECT field_name
FROM table_name
WHERE field_name2 IS NULL;

-- get the records wher field_name 2 is null
SELECT COUNT(*)
FROM table_name
WHERE field_name IS NOT NULL;

-- Chapter 3 - summarizing data
    -- aggregate functions: 
        -- numerical field >> AVG(), SUM(), 
        -- non numerical field >> MIN(), MAX(), COUNT()
SELECT aggregateFunction(field_name)
FROM table_name;

-- ROUND() : round a number to a specified decimal
-- ROUND(number_to_round,decimal_places)
SELECT ROUND(AVG(budget),2) AS avg_budget
FROM films
WHERE condition;

-- round to a whole number >> ROUND(number_to_round)
-- round to a negative number >> ROUND(number_to_round, -5)      

-- Arithmetic
    -- +, -, *, /, %
        -- 4/5 = 1 and 4.0 / 5.0 = 1.333

    -- Aggregate and Arithmetic
        -- Aggregate >> horizontally (field)

    -- Arithmetic >> vertically (per records, rows)

-- Chapter 4 - Sorting and Grouping
ORDER BY field_name
-- default >> asdending order >> special char, 0-1000, A-Z, null 

-- ascending
ORDER BY field_name ASC;
-- descending
ORDER BY field_name DESC;

SELECT field_name1, field_name2
FROM table_name
WHERE condition
ORDER BY field_name;

SELECT field_name1, field_name2
FROM table_name
WHERE condition
ORDER BY field_name DESC, field_name2 ASC
LIMIT number;

-- Grouping
GROUP BY field_name
WHERE filters individual records
HAVING filters grouped records

-- syntax
SELECT field_name
FROM table_name
GROUP BY field_name
ORDER BY field_name
LIMIT number;

-- filtering with grouping
-- syntax
SELECT field_name AS alias_of_field_name
FROM table_name
WHERE condition
GROUP BY field_name
HAVING condition
ORDER BY field_name
LIMIT number;

-- Select the country and distinct count of certification as certification_count
SELECT country, COUNT(DISTINCT(certification)) AS certification_count
FROM films
-- Group by country
GROUP BY country
-- Filter results to countries with more than 10 different certifications
HAVING COUNT(DISTINCT(certification)) > 10;

