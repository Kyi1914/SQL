# Course 3 - Joining Data in SQL

## Chapter 1 : Inner Join
<img src = '.\image\2.png'>

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
INNER JOIN right_table AS r
ON l.id = r.id;
```

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
INNER JOIN right_table AS r
USING (id); --if columns has the same name in both table
```

### about relationships
- one-to-many relationships
- one-to-one
- many-to-one

### Multiple Joins
```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
INNER JOIN right_table AS r
ON l.id = r.id
INNER JOIN third_table AS t
ON l.id = t.id
```

### Joining Multiple Keys
```sql
SELECT *
FROM left_table AS l
INNER JOIN right_table AS r
ON l.id = r.id AND l.date = r.date;
```

## Chapter 2: Outer Joins, Cross Joins and Self Joins
Outer Joins >> 
- LEFT and RIGHT Joins
- FULL JOINS
  
### LEFT JOIN
<img src = '.\image\4.png'>

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
LEFT JOIN right_table AS r
USING (id); --if columns has the same name in both table
```

### RIGHT JOIN
<img src = '.\image\5.png'>

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
RIGHT JOIN right_table AS r
USING (id); --if columns has the same name in both table
```
### FULL JOIN
Full join combines a LEFT join and a RIGHT join.
<img src = '.\image\6.png'>

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
FULL JOIN right_table AS r
USING (id); --if columns has the same name in both table
```

### CROSS JOIN
cross join create all possible combinations of two tables
<img src = '.\image\7.png'>

```sql
SELECT l.column_name, r.column_name
FROM left_table AS l
CROSS JOIN right_table AS r;
```

### SELF JOIN
self joins are tables joined with themselves.


```sql
SELECT l1.column_name, l2.column_name
FROM left_table AS l1
INNER JOIN left_table AS l2
ON l1.continent = l2.continent 
    AND l1.contry <> l2.country
LIMIT 10; 
```

## Chapter 3: SET theory for SQL Joins
<img src = '.\image\8.png'>
- UNION
- UNION ALL

### UNION
UNION takes two tables input, and returns all records from both tables.
<img src = '.\image\9.png'>

```sql
SELECT *
FROM left_table
UNION 
SELECT *
FROM right_table;
```

### UNION ALL
UNION takes two tables input, and returns all records from both tables, including duplicates.
<img src = '.\image\10.png'>

```sql
SELECT *
FROM left_table
UNION ALL
SELECT *
FROM right_table;
ORDER BY clause
LIMIT 10;
```

### INTERCEPT

<img src = '.\image\11.png'>

```sql
SELECT *
FROM left_table
INTERCEPT
SELECT *
FROM right_table;
```

### EXCEPT
<img src = '.\image\12.png'>

```sql
SELECT *
FROM left_table
EXCEPT
SELECT *
FROM right_table;
```

## Chapter 4: Subqueries

### Subqueries with Semi Joins and Anti Joins

#### Semi Join 
A semi join chooses records in the first table where a condition is met in the second table.
<img src = '.\image\13.png'>

```sql
SELECT president, country, continent
FROM presidents
WHERE country IN
    (
        SELECT country
        FROM states
        WHERE indep_year < 1800
    );
```

####  Anti Join 
<img src = '.\image\14.png'>
A semi join chooses records in the first table where a condition is met in the second table.

```sql
SELECT president, country
FROM presidents
WHERE continent LIKE '%America' AND country NOT IN
    (
        SELECT country
        FROM states
        WHERE indep_year < 1800
    );
```

### Subqueries inside WHERE and SELECT and FROM

#### WHERE
- where is the most common place for subqueries

syntax for query using WHERE IN statement
```sql
SELECT *
FROM table
WHERE field IN(subquery);
```

#### SELECT
```sql
SELECT DISTINCT continent,
    (SELECT count(*) FROM m WHERE continent = '') AS m_count
FROM states;
```

#### FROM
