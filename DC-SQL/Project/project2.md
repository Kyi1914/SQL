# Project 2: Analyzing Motorcycle Part Sales

You're working for a company that sells motorcycle parts, and they've asked for some help in analyzing their sales data!

They operate three warehouses in the area, selling both retail and wholesale. They offer a variety of parts and accept credit cards, cash, and bank transfer as payment methods. However, each payment type incurs a different fee.

The board of directors wants to gain a better understanding of wholesale revenue by product line, and how this varies month-to-month and across warehouses. You have been tasked with calculating net revenue for each product line and grouping results by month and warehouse. The results should be filtered so that only "Wholesale" orders are included.

They have provided you with access to their database, which contains the following table called sales:

### Sales Table

| **Column**       | **Data Type** | **Description**                                                                        |
|-------------------|---------------|----------------------------------------------------------------------------------------|
| `order_number`    | VARCHAR       | Unique order number.                                                                  |
| `date`            | DATE          | Date of the order, from June to August 2021.                                          |
| `warehouse`       | VARCHAR       | The warehouse that the order was made from—North, Central, or West.                   |
| `client_type`     | VARCHAR       | Whether the order was Retail or Wholesale.                                            |
| `product_line`    | VARCHAR       | Type of product ordered.                                                              |
| `quantity`        | INT           | Number of products ordered.                                                           |
| `unit_price`      | FLOAT         | Price per product (dollars).                                                          |
| `total`           | FLOAT         | Total price of the order (dollars).               

### Query Output Format

| **product_line** | **month** | **warehouse** | **net_revenue** |
|-------------------|-----------|---------------|------------------|
| product_one       | ---       | ---           | ---              |
| product_one       | ---       | ---           | ---              |
| product_one       | ---       | ---           | ---              |
| product_one       | ---       | ---           | ---              |
| product_one       | ---       | -

## Answer starts here

-- check the table
SELECT *
FROM sales;

-- Corrected SQL code
SELECT product_line, EXTRACT(MONTH FROM date) AS month, warehouse, SUM(total) - SUM(payment_fee) AS revenue_by_product_line
FROM sales
GROUP BY product_line, EXTRACT(MONTH FROM date), warehouse
ORDER BY product_line, EXTRACT(MONTH FROM date), warehouse;