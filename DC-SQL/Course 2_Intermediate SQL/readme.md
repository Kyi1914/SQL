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