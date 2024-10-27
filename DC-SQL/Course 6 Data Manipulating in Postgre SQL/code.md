
- [Title](#title)
  - [Subtitle](#subtitle)
  - [sdklj;sdf](#sdkljsdf)
  - 

# Course 6 - Functions for Manipulating Data in PostgreSQL

## Chapter 1

### 1.1

PostgreSQL has a system database called INFORMATION_SCHEMA that allows us to extract information about objects, including tables, in our database.

to query the tables table of the INFORMATION_SCHEMA database:

Select all columns from the INFORMATION_SCHEMA.COLUMNS system database. Limit by table_name to actor
```SQL
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';
 ```

to extract information about the data types of columns in a table.
```sql
-- Get the column name and data type
SELECT
    column_name, 
    data_type
-- From the system database information schema
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';
```
### 1.2 Date and time data types
- TIMESTAMP data type.   
  - TIMESTAMPs contain both a date value and a time value with microsecond precision.
  - ISO 8601 format: yyyy-mm-dd hr-min-s
- DATE and TIME data types
- INTERVAL data types
  - e.g '4 days'

Calculate the expected_return_date for a given DVD rental by adding an INTERVAL of 3 days to the rental_date from the rental table. We can then compare this result to the actual return_date to determine if the DVD was returned late.
```sql
SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;

```
### 1.3 Working with arrays

- Create Table example
  ```sql
  CREATE TABLE my_first_table(
    first_column text,
    second_column integer
  );
  ```
- INSERT example
    ```sql
    INSERT INTO my_first_table
        (first_column, second_column) VALUES ('text values', 12);
    ```
- CREATE A table with two ARRAY columns
    ```sql
    CREATE TABLE grades(
        student_id int,
        -- an email column which will be a nested array of text data to store the email type and the address for a given student_id.  --
        email text[][], 
        -- array of integer values representing the numeric test score.--
        test_scores int[]
    );
    ```
- INSERT statements with ARRAYS
    ```sql
    INSERT INTO grades
        VALUES (
            1,
            '{{"work","work1@dp.com"},{"other","other1@dp.com"}}',
            '{92,85,96,88}'
        );
    ```
- Accessing ARRAYs
    ```sql
    SELECT 
        email[1][1] AS type,
        email[1][2] AS address,
        test_scores[1],
    FROM grades;
    ```
    - index starts with 1 not 0.
- Searching ARRAYS
    ```sql
    SELECT
        email[1][1] AS type,
        email[1][2] AS address,
        test_scores[1],
    FROM grades
    WHERE email[1][1] = 'work';
    ```
- ARRAYS Functions and Operators >> ANY
  - ANY function allows you to search an array for a value and return a record if it finds a match. 
    - we want to query all records where the email address contains 'other' in any value of the array. 
        ```sql
        SELECT
            email[1][1] AS type,
            email[1][2] AS address,
            test_scores[1],
        FROM grades
        WHERE 'other' = ANY(email);
        ```
  - contains operators (alternative of ANY)
    ```sql
        SELECT
            email[1][1] AS type,
            email[1][2] AS address,
            test_scores[1],
        FROM grades
        WHERE email @> ARRAY['other'];
        ```

## Chapter 2: Working with DATE/TIME Functions and Operators

- arithmetic operations for date and time
- CURRENT_DATE, CURRENT_TIMESTAMP, NOW()
- AGE()
- EXTRACT(), DATE_PART(), DATE_TRUNC()

### 2.1 Overview of basic arithmetic operators
- Adding and subtracting date/time data
  - 1.
    ```sql
    SELECT date '2005-09-11' - date '2005-09-10'
    ```
    - result >> 1 (integer data type)
  - 2.
  ```sql
    SELECT date '2005-09-11' + integer '3';
    ```
    - result >> '2005-09-14' (date)
  - 3. 
  ```sql
    SELECT date '2005-09-11 00:00:00' - date '2005-09-09 00:00:00';
    ```
    - result >> 1 day 12:00:00 (interval)
- AGE function : to caluclate difference between two timestamp
  ```sql
    SELECT AGE(timestamp '2005-09-11 00:00:00' - timestamp '2005-09-09 00:00:00');
    ```
    - result >> 1 day 12:00:00 (interval) [note: similar with No.3]
### 2.2 retrieving current date and value
### 2.3 Extracting and transforming date/time data
- EXTRACT()
```sql
SELECT EXTRACT(quarter FROM timestamp '2005-01-24 05:12:00') AS quarter;
```
- DATE_PART()
```sql
SELECT DATE_PART('quarter', timestamp '2005-01-24 05:12:00') AS quarter;
```
- DATE_TRUNC()
  - trancate timestamp or interval data types
```sql
SELECT DATE_TRUNC('year', timestamp '2005-05-24 05:12:00');
```
result>> 2005-01-01 00:00:00
```sql
SELECT DATE_TRUNC('month', timestamp '2005-05-24 05:12:00');
```
result>> 2005-05-01 00:00:00
- Extracting sub-fields from timestamp data
  - GROUP BY quarter, year
```sql
SELECT 
    EXTRACT(quarter FROM payment_date) AS quarter,
    EXTRACT(year FROM payment_date) AS year,
    SUM(amount) AS total_payments
FROM pyament
GROUP BY 1,2;
```
## Chapter 3 - Parsing and Manipulating Text 
### 3.1 Reformatting string and character data
- String concatenation operator
```sql
SELECT
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name
FROM customer
```
- String concatenation functions
```sql
SELECT
    CONCAT(first_name,' ',last_name) AS full_name
    FROM customer
```
- String Concatenation with a non-string input
```sql
SELECT
    customer_id || ':' 
    || first_name || '' 
    || last_name AS full_name
FROM customer
```
- Changing the case of string
```sql
SELECT
    UPPER(email)
FROM customer;
```
```sql
SELECT
    LOWER(email)
FROM customer;
```
```sql
SELECT
    INITCAP(name)
FROM customer;
```
- Replacing characters in a string
```sql
SELECT
    REPLACE(description, 'A Astouding','An Astounding') as description
FROM film;
```
- REVERSE
```sql
SELECT
    title,
    REVERSE(title)
FROM film;
```

### 3.2 Parsing string and character data
- the length of a string
```sql
SELECT 
    title,
    CHAR_LENGTH(title)
FROM film;
```
```sql
SELECT 
    title,
    LENGTH(title)
FROM film;
```
- finding the position of a character (left > right)
```sql
SELECT 
    email,
    POSITION('@' IN email)
FROM customer;
```
```sql
SELECT 
    email,
    STRPOS('@' IN email)
FROM customer;
```
- Parsing string
```sql
SELECT 
    LEFT(description,50)
FROM film;
```
```sql
SELECT 
    RIGHT(description,50)
FROM film;
```
- substrings
```sql
SELECT 
    SUBSTRING(description,10,50)
FROM film AS f;
```
```sql
SELECT 
    SUBSTRING(email FROM 0 FOR POSITION('@' IN email))
FROM customer;
```
```sql
SELECT 
    SUBSTRING(email FROM POSITION('@' IN email)+1 FOR CHAR_LENGTH(email) )
FROM customer;
```
```sql
SELECT 
    SUBSTR(description,10,50)
FROM film AS f;
```
### 3.3 Truncating and padding string data
- removing whitespace from string
```sql
SELECT 
    TRIM([leading | trailing | both][characters] from string)
FROM film AS f;
```
```sql
SELECT TRIM(' padded ')
```
- LTRIM: trim at the beginning
- RTRIM: trim at the end
- Padding strings with character data
  - LPAD
    ```sql
    SELECT LPAD(' padded', 10, '#')
    ```
    Result >> ####padded
    ```sql
    SELECT LPAD(' padded', 10)
    ```
    Result >>     padded

## Chapter 4 - full-text search and postgreSQL extensions
### 4.1 Introduction to full text search
- to_tsvector(title) @@ to_tsquery('elf');
```sql
SELECT title, description
FROM film
WHERE to_tsvector(title) @@ to_tsquery('elf');
```
### 4.2 Extending PostgreSQL
- User Define data types
  - enumerated data types
  ```sql
  CREATE TYPE dayofweek AS ENUM(
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  );
  ```
  - getting information about user-defined data types
  ```sql
  SELECT typname, typcategory
  FROM pg_type
  WHERE typname = 'dayofweek';
  ```
  ```sql
  SELECT column_name, data_type, udt_name
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_name = 'film';
  ```
- User defined functions
```sql
CREATE FUNCTION squared(i integer) RETURNS integer AS $$
    BEGIN
        RETURN i * i;
    END;
$$ LANGUAGE plpgsql;
```
```sql
SELECT squared(10);
```
- 
### 4.3 Intro to PostreSQL extensions
- commonly used extensions
  - PostGIS
  - PostPic
  - fuzzzystrmatch
  - pg_trgm
  
- available extensions
```sql
SELECT name
FROM pg_available_extensions;
```
- installed extensions
```sql
SELECT extname
FROM pg_extensions;
```
- fuzzystrmatch or fuzzy searching
```sql
-- Enable the fuzzystrmatch extension
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
-- confirm that fuzzstrmatch has been enabled
SELECT extname FROM pg_extension;
```

- compare two strings with pg_trgm
```sql
SELECT similarity ('GUMBO', 'GAMBOL');
```
return 0 >> no matching
return 1 >> perfect match

- Calculate the levenshtein distance
```sql
SELECT 
    levenshtein(title, 'JET NEIGHBOR')
FROM table;
```

