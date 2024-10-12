## About Database
Our Films Database  
<!-- <img src="..\images\our films database schema.png" /> -->

## Lessons
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

## Structure
Chapter 1: COUNT(), LIMIT
Chpater 2: WHERE, BETWEEN, AND, OR, LIKE, NOT LIKE, IN, %, _, IS NULL, IS NOT NULL
Chapter 3: ROUND() and aggregate functions
Chapter 4: ORDER BY, DESC, GROUP BY, HAVING
COMPARISON OPERATOR, ARITHMETIC OPERATIONS

SKILLS >> SELECTING DATA, QUERYING DATA, FILTERING AND SUMMARIZING DATA, SORTING AND GROUPING