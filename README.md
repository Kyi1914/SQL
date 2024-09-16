# SQL Query Syntax

> [!NOTE]  
> Note for terminology  

table_name
|field_name|field_name2|field_name3|
|---|---|---|
|data|data|data|

## 1. Querying Basic

Selecting a single field
```ruby
SELECT field_name  
FROM table_name;  
```

Selecting multiple fields
```ruby
SELECT field_name1, field_name2  
FROM table_name;
```

Selecting all fields
```ruby
SELECT *   
FROM table_name;
```

## 1.2 Aliasing: to rename columns in result

```ruby
SELECT field_name AS alias_for_field_name
FROM table_name;
```
## 1.3 Selecting distinct records

```ruby
SELECT DISTINCT field_name
FROM table_name;
```

## 1.4 Creating a VIEW table
```ruby
CREATE VIEW view_table_name AS
SELECT field_name
FROM table_name;
```
> [!IMPORTANT]  
> VIEW table is created using the SELECT statement. You can apply any SELECT statement.

Intermediate SQL
## 2.1 COUNT()

Count the number of records from a single field
```ruby
SELECT COUNT(field_name)
FROM table_name;
```

Count multiple fields with Alias
```ruby
SELECT COUNT(field_name) AS alias_field_name, COUNT(filed_name1)
FROM table_name;
```

Count records in table
```ruby
SELECT COUNT(*)
FROM table_name;
```

Count distinct records
```ruby
SELECT COUNT(DISTINCT field_name) AS alias_field_name
FROM table_name;
```

## 2.2 LIMIT
LIMIT the number of records to show in the result
```ruby
SELECT COUNT(field_name), COUNT(filed_name1)
FROM table_name
LIMIT number;
```

## 2.3 Filtering

WHERE statement
```ruby
SELECT field_name
FROM table_name
WHERE criteria;
```
#### 2.3.1 WHERE with COMPARISON OPERATORS
> [!NOTE]  
> Criteria is the condition that we want to get from the database tables.   
> In the following examples, **age>20** and **name='Ave'** are creteria.   
> example in WHERE statement >> WHERE age>20;  
> example in WHERE statement >> WHERE name = 'Ave'  
> syntax  >> ```WHERE field_name comparison_operators required_case```

> [!IMPORTANT]   
> Comparison Operators:
> - \>
> - \<
> - \=
> - \>=
> - \<=
> - \<> : Not equal  

WHERE with number
```ruby
SELECT field_name
FROM table_name
WHERE field_name > 1000;
```

WHERE with string
```ruby
SELECT field_name
FROM table_name
WHERE field_name = 'string';
```

#### 2.3.2 Multiple Creteria | WHERE with Logical Operators

> [!IMPORTANT]   
> Logical Operators:
> - OR
> - AND
> - BETWEEN __ AND __

> [!NOTE]  
> Use Logical Operators in WHERE clause together with the creteria.
> example in WHERE statement >> WHERE name='Apple' AND age = 30;  
> example in WHERE statement >> WHERE age BETWEEN 20 AND 30;  
> syntax  >> ```WHERE creteria_A logical_operators creteria_B```

```ruby
SELECT *
FROM table_name
WHERE creteria_1 OR creteria_2;
```

```ruby
SELECT *
FROM t_shirt
WHERE color = 'red' AND  size = 'M';
```

```ruby
SELECT *
FROM table_name
WHERE field_name BETWEEN number AND number;
```
> [!NOTE]   
> syntax : WHERE field_name BETWEEN **number** AND **number**;  
> example : WHERE pockets BETWEEN **1** AND **5**;

AND, OR basic syntax
```ruby
SELECT *
FROM table_name
WHERE (creteria 1) 
    AND (creteria 2);
```
AND, OR : get the records who born 1980 or 2000 and blood type A or B
```ruby
SELECT *
FROM table_name
WHERE (year = 1980 OR year = 2000) 
    AND (blood_type = 'A' OR blood_type = 'B');
```

BETWEEN, AND, AND
```ruby
SELECT *
FROM patient
WHERE age BETWEEN 25 AND 40 AND blood_type = 'AB';
```

#### 2.3.3 Filtering a pattern | WHERE with Pattern

syntax
```ruby
SELECT field_name
FROM table_name
WHERE field_name LIKE pattern;
```

> [!IMPORTANT]   
> KEYWORDS : **LIKE, NOT LIKE, IN**;  
> syntax : ```WHERE field_name LIKE 'pattern'```  
> syntax : ```WHERE field_name NOT LIKE 'pattern'```  
> syntax : ```WHERE field_name IN (number,number,number)```  
> syntax : ```WHERE field_name IN ('string','string','string')```

> [!IMPORTANT]   
> pattern : **%, _**;  
> % : match zero or more
> _ : match a single character  
> example : to get the all names starts with An, pattern should be >> **'An%'**  
> example : to get the all names starts with An and ends with p, pattern should be >> **'An%p'**   
> example : to get the all names with the third character is o, pattern should be >> **'__o%'** 

selecting the name starts with A and ends with o followed by a character.
```ruby
SELECT name
FROM people
WHERE name LIKE 'A%o_';
```

selecting all the records of people who live in Japan or Thailand
```ruby
SELECT *
FROM people
WHERE country IN ('Japan', 'Thailand');
```

selecting all the records of people who were born in 2000, 2020 or 2010
```ruby
SELECT *
FROM people
WHERE country IN (2000,2020, 2010);
```

## 2.4 NULL values
> [!IMPORTANT]   
> KEYWORDS : **IS NULL, IS NOT NULL**;  
> syntax : ```WHERE field_name IS NULL```  
> syntax : ```WHERE field_name IS NOT NULL```  

return all the null records
```ruby
SELECT field_name
FROM table_name
WHERE field_name IS NULL;
```

return the count of not null records
```ruby
SELECT COUNT(*)
FROM table_name
WHERE field_name IS NOT NULL;
```

> [!NOTE]    
> COUNT(field_name) includes only not null values
> COUNT(*) includes null values

## 2.5 Aggregate Function

> [!IMPORTANT]   
> Aggregate functions : **AVG(), SUM(), MIN(), MAX(), COUNT()**;
> Use aggregate functions in SELECT statement.
> example: ```SELECT AVG(sales)```
> AVG() and SUM() can work with numerical fields only.
> MIN(), MAX(), COUNT() work with various data types.

syntax
```
SELECT Aggregate_Function(field_name)
FROM table_name
WHERE creteria;
```

example
```
SELECT SUM(sales) AS total_sales, AVG(budget) as avg_budget
FROM planning
WHERE year = 2010;
```

## 2.6 ROUND()
syntax
```
SELECT ROUND(Aggregate_Function(field_name),round_instruction)
FROM table_name
WHERE creteria;
```

example
```
SELECT ROUND(SUM(sales),2) AS total_sales
FROM planning;
```

> [!IMPORTANT]   
> ROUND to a whole number : **ROUND(AVG()), ROUND(AVG(),0)**;  
> ROUND to a * decimal places : **ROUND(AVG(),2), ROUND(AVG(),3)**;  
> ROUND using a negative number : **ROUND(AVG(),-1), ROUND(AVG(),-3)**;  

## 2.7 Arithmetic Function
> [!IMPORTANT]   
> arithmetic : **+, -, *, /**;  
> 3/2 and 3.0/2.0 will get different result and different data type.  

syntax
```
SELECT (field_name - field_name) AS alias_field_name
FROM table_name;
```

> [!NOTE]   
> Arithmetic function for records / row.  
> Aggregate function for field / column.  

## 4.1 Sorting

> [!IMPORTANT]   
> KEYWORDS : **ORDER BY**;    
> Syntax: ```ORDER BY field_name DESC; ```   
> Syntax: ```ORDER BY field_name ASC;```   
> by default, order by is ascending order.  

syntax
```
SELECT *
FROM table_name
WHERE creteria
ORDER BY field_name;
```

syntax
```
SELECT *
FROM table_name
WHERE creteria
ORDER BY field_name, field_name2 DESC;
```

syntax
```
SELECT *
FROM table_name
WHERE creteria
ORDER BY field_name DESC
LIMIT number;
```

## 4.2 Grouping
> [!IMPORTANT]   
> KEYWORDS : **GROUP BY**;    
> Syntax: ```GROUP BY field_name; ```   
> Syntax: ```ORDER BY field_name, field_name2;```   

syntax
```
SELECT *
FROM table_name
WHERE creteria
GROUP BY field_name
ORDER BY field_name DESC
LIMIT number;
```

## 4.3 Filtering Group Data
> [!IMPORTANT]   
> KEYWORDS : **HAVING**;    
> Syntax: ```GROUP BY field_name Having creteria```     

syntax
```
SELECT *
FROM table_name
WHERE creteria
GROUP BY field_name
HAVING creteria from group by
ORDER BY field_name DESC
LIMIT number;
```