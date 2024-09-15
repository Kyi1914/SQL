# SQL Query

> [!NOTE]  
> Note for terminology  

table_name
|field_name|field_name2|field_name3|
|---|---|---|
|data|data|data|

## Course 1: Introduction to SQL 
**Selecting a single field**
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

### SELECTING DATA
Count the number of records
```ruby
SELECT COUNT(field_name)
FROM table_name;
```