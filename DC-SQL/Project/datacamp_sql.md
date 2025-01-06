# Practical Exam: Hotel Operations  
LuxurStay Hotels is a major, international chain of hotels. They offer hotels for both business and leisure travellers in major cities across the world. The chain prides themselves on the level of customer service that they offer.

However, the management has been receiving complaints about slow room service in some hotel branches. As these complaints are impacting the customer satisfaction rates, it has become a serious issue. Recent data shows that customer satisfaction has dropped from the 4.5 rating that they expect.

You are working with the Head of Operations to identify possible causes and hotel branches with the worst problems.

Data
The following schema diagram shows the tables available. You have only been provided with data where customers provided a feedback rating.

<img src = 'practice.png'/>

# Task 1
Before you can start any analysis, you need to confirm that the data is accurate and reflects what you expect to see.

It is known that there are some issues with the branch table, and the data team have provided the following data description.

Write a query to return data matching this description. You must match all column names and description criteria.

Column Name	Criteria
id	Nominal. The unique identifier of the hotel.
Missing values are not possible due to the database structure.
location	Nominal. The location of the particular hotel. One of four possible values, 'EMEA', 'NA', 'LATAM' and 'APAC'.
Missing values should be replaced with “Unknown”.
total_rooms	Discrete. The total number of rooms in the hotel. Must be a positive integer between 1 and 400.
Missing values should be replaced with the default number of rooms, 100.
staff_count	Discrete. The number of staff employeed in the hotel service department.
Missing values should be replaced with the total_rooms multiplied by 1.5.
opening_date	Discrete. The year in which the hotel opened. This can be any value between 2000 and 2023.
Missing values should be replaced with 2023.
target_guests	Nominal. The primary type of guest that is expected to use the hotel. Can be one of 'Leisure' or 'Business'.
Missing values should be replaced with 'Leisure'.

error task 1
```sql
-- Write your query for task 1 in this cell
-- SELECT * FROM branch LIMIT 10;
SELECT 
    CAST(id AS TEXT) AS id,
    COALESCE(
        CASE 
            WHEN location IN ('EMEA', 'NA', 'LATAM', 'APAC') THEN location
            ELSE 'Unknown'
        END, 
        'Unknown'
    ) AS location,
    COALESCE(
        CASE 
            WHEN total_rooms BETWEEN 1 AND 400 THEN total_rooms
            ELSE 100
        END, 
        100
    ) AS total_rooms,
    COALESCE(
        staff_count, 
        COALESCE(
            CASE 
                WHEN total_rooms BETWEEN 1 AND 400 THEN total_rooms
                ELSE 100
            END, 
            100
        ) * 1.5
    ) AS staff_count,
    CAST(
        COALESCE(
            CASE
                WHEN opening_date ~ '^[0-9]+$' AND CAST(opening_date AS INTEGER) BETWEEN 2000 AND 2023 THEN opening_date
                ELSE '2023'
            END, 
            '2023'
        ) AS INTEGER
    ) AS opening_date,
    COALESCE(
        CASE 
            WHEN LOWER(target_guests) LIKE 'b%' THEN 'Business'
            ELSE 'Leisure'
        END, 
        'Leisure'
    ) AS target_guests
FROM branch
```
answer 2
```sql
SELECT 
    id,
    COALESCE(location, 'Unknown') AS location,
    CASE
        WHEN total_rooms BETWEEN 1 AND 400 THEN total_rooms
        ELSE 100
    END AS total_rooms,
    CASE
        WHEN staff_count IS NOT NULL THEN staff_count
        ELSE total_rooms * 1.5
    END AS staff_count,
    CASE
        WHEN opening_date = '-' THEN '2023'
        WHEN opening_date BETWEEN '2000' AND '2023' THEN opening_date
        ELSE '2023'
    END AS opening_date,
    CASE
        WHEN target_guests IS NULL THEN 'Leisure'
        WHEN LOWER(target_guests) LIKE 'b%' THEN 'Business'
        ELSE target_guests END AS target_guests
FROM 
    public.branch;
```

# Task 2

The Head of Operations wants to know whether there is a difference in time taken to respond to a customer request in each hotel. They already know that different services take different lengths of time. 

Calculate the average and maximum duration for each branch and service. Your output should include the columns `service_id`, `branch_id`, `avg_time_taken` and `max_time_taken`. Values should be rounded to two decimal places where appropriate. 

```sql
-- Write your query for task 2 in this cell
SELECT 
	service_id, 
	branch_id, 
	ROUND(AVG(time_taken),2) AS avg_time_taken, 
	ROUND(MAX(time_taken),2) AS max_time_taken
FROM request
GROUP BY branch_id, service_id
ORDER BY service_id, branch_id
```

# Task 3

The management team want to target improvements in `Meal` and `Laundry` service in Europe (`EMEA`) and Latin America (`LATAM`). 

Write a query to return the `description` of the service, the `id` and `location` of the branch, the id of the request as `request_id` and the `rating` for the services and locations of interest to the management team. 

Use the original branch table, not the output of task 1. 

```sql
-- Write your query for task 3 in this cell
SELECT s.description, b.id, b.location, r.id AS request_id,r.rating
FROM request r
INNER JOIN branch b 
ON r.branch_id = b.id
INNER JOIN service s
ON r.service_id = s.id
WHERE s.description IN ('Meal', 'Laundry')
AND b.location IN ('EMEA','LATAM')
ORDER BY b.location, s.description, r.id;
```

# Task 4

So that you can take a more detailed look at the lowest performing hotels, you want to get service and branch information where the average rating for the branch and service combination is lower than 4.5 - the target set by management.  

Your query should return the `service_id` and `branch_id`, and the average rating (`avg_rating`), rounded to 2 decimal places.

```sql
-- Write your query for task 4 in this cell
SELECT service_id, branch_id, ROUND(avg(rating),2) AS avg_rating
FROM request
GROUP BY service_id, branch_id
HAVING AVG(rating) < 4.5
ORDER BY avg_rating;
```
