# SQL Query Syntax

> [!NOTE]  
> Note for terminology  

table_name
|field_name|field_name2|field_name3|
|---|---|---|
|data|data|data|

## Course 1: Introduction to SQL 
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

Aliasing: to rename columns in result
```ruby
SELECT field_name AS alias_for_field_name
FROM table_name;
```

Selecting distinct records
```ruby
SELECT DISTINCT field_name
FROM table_name;
```

Creating a VIEW table
```ruby
CREATE VIEW view_table_name AS
SELECT field_name
FROM table_name;
```
> [!IMPORTANT]  
> VIEW table is created using the SELECT statement. You can apply any SELECT statement.

## Course 2: Intermediate SQL

### 2.1 SELECTING DATA

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
SELECT COUNT(field_name) AS alias_field_name, COUNT(filed_name1)
FROM table_name;
```

Count distinct records
```ruby
SELECT COUNT(DISTINCT field_name) AS alias_field_name
FROM table_name;
```

LIMIT the number of records to show in the result
```ruby
SELECT COUNT(field_name), COUNT(filed_name1)
FROM table_name
LIMIT number;
```

### 2.2 Filtering

WHERE statement
```ruby
SELECT field_name
FROM table_name
WHERE criteria;
```

> [!NOTE]  
> Criteria is the condition that we want to get from the database tables.   
> example of criteria in WHERE statement >> WHERE age>20;  
> example of criteria in WHERE statement >> WHERE name = 'Ave'  
> syntax of criteria in WHERE statement >> field_name **comparison_operators** match_criteria

> [!IMPORTANT]   
> Comparison Operators:
> - \>
> - \<
> - \=
> - \>=
> - \<=
> - \<> : Not equal

WHERE with comparison operators
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

Multiple Creteria

> [!IMPORTANT]   
> Logical Operators:
> - OR
> - AND
> - BETWEEN AND  
> Use Logical Operators in WHERE clause.

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