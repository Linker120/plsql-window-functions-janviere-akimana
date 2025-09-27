
-- Create Customers table
CREATE TABLE customers (
  customer_id NUMBER(10) PRIMARY KEY,
  name        VARCHAR2(100),
  region      VARCHAR2(50)
);

-- Create Products table
CREATE TABLE products (
  product_id NUMBER(10) PRIMARY KEY,
  name       VARCHAR2(100),
  category   VARCHAR2(50)
);

-- Create Transactions table
CREATE TABLE transactions (
  transaction_id NUMBER(10) PRIMARY KEY,
  customer_id    NUMBER(10),
  product_id     NUMBER(10),
  sale_date      DATE,
  amount         NUMBER(12,2),
  CONSTRAINT fk_trx_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_trx_product  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

COMMIT;

-- Insert sample customers
INSERT INTO customers (customer_id, name, region) VALUES (1001, 'Janviere Akimana', 'Kigali');
INSERT INTO customers (customer_id, name, region) VALUES (1002, 'Miracle Ihirwe',   'Bugesera');
INSERT INTO customers (customer_id, name, region) VALUES (1003, 'Maxyme Abakunzi',  'Musanze');
INSERT INTO customers (customer_id, name, region) VALUES (1004, 'Holy Isezerano',   'Kigali');

-- Insert sample products
INSERT INTO products (product_id, name, category) VALUES (2001, 'Coffee Beans',   'Beverages');
INSERT INTO products (product_id, name, category) VALUES (2002, 'Instant Coffee', 'Beverages');
INSERT INTO products (product_id, name, category) VALUES (2003, 'Ground Coffee',  'Beverages');
INSERT INTO products (product_id, name, category) VALUES (2004, 'Coffee Capsules','Beverages');

-- Insert sample transactions (Jan - Mar 2024)
-- Janviere Akimana (Kigali)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3001, 1001, 2001, DATE '2024-01-15', 25000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3002, 1001, 2002, DATE '2024-02-12', 35000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3003, 1001, 2003, DATE '2024-03-10', 45000);

-- Miracle Ihirwe (Bugesera)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3004, 1002, 2002, DATE '2024-01-20', 20000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3005, 1002, 2004, DATE '2024-02-14', 30000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3006, 1002, 2003, DATE '2024-03-18', 15000);

-- Maxyme Abakunzi (Musanze)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3007, 1003, 2003, DATE '2024-01-25', 40000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3008, 1003, 2001, DATE '2024-02-10', 25000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3009, 1003, 2004, DATE '2024-03-05', 30000);

-- Holy Isezerano (Kigali)
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3010, 1004, 2001, DATE '2024-01-18', 30000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3011, 1004, 2002, DATE '2024-02-22', 20000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount) VALUES (3012, 1004, 2003, DATE '2024-03-15', 50000);

COMMIT;

-- ======================================================
-- WINDOW FUNCTION QUERIES (examples you should run and screenshot)
-- ======================================================

-- 1) Top products per region (top 5)
WITH region_product_sales AS (
  SELECT c.region,
         p.name AS product_name,
         SUM(t.amount) AS total_sales
  FROM transactions t
  JOIN customers c ON c.customer_id = t.customer_id
  JOIN products p ON p.product_id = t.product_id
  GROUP BY c.region, p.name
)
SELECT region, product_name, total_sales, product_rank
FROM (
  SELECT rps.*,
         RANK() OVER (PARTITION BY rps.region ORDER BY rps.total_sales DESC) AS product_rank
  FROM region_product_sales rps
)
WHERE product_rank <= 5
ORDER BY region, product_rank;

-- 2) Running monthly sales totals (monthly + cumulative)
SELECT sales_month,
       monthly_sales,
       SUM(monthly_sales) OVER (ORDER BY sales_month ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM (
  SELECT TO_CHAR(sale_date,'YYYY-MM') AS sales_month,
         SUM(amount) AS monthly_sales
  FROM transactions
  GROUP BY TO_CHAR(sale_date,'YYYY-MM')
)
ORDER BY sales_month;

-- 3) Month-over-month growth (%)
SELECT sales_month,
       monthly_sales,
       prev_month_sales,
       ROUND(
         (monthly_sales - prev_month_sales) / NULLIF(prev_month_sales,0) * 100, 2
       ) AS growth_pct
FROM (
  SELECT sales_month,
         monthly_sales,
         LAG(monthly_sales,1) OVER (ORDER BY sales_month) AS prev_month_sales
  FROM (
    SELECT TO_CHAR(sale_date,'YYYY-MM') AS sales_month,
           SUM(amount) AS monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date,'YYYY-MM')
  )
)
ORDER BY sales_month;

-- 4) Customer quartiles (NTILE)
SELECT customer_name, total_spent, quartile FROM (
  SELECT c.name AS customer_name,
         SUM(t.amount) AS total_spent,
         NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS quartile
  FROM transactions t
  JOIN customers c ON c.customer_id = t.customer_id
  GROUP BY c.name
)
ORDER BY quartile, total_spent DESC;

-- 5) 3-month moving average
SELECT sales_month,
       monthly_sales,
       ROUND(AVG(monthly_sales) OVER (ORDER BY sales_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_3m
FROM (
  SELECT TO_CHAR(sale_date,'YYYY-MM') AS sales_month,
         SUM(amount) AS monthly_sales
  FROM transactions
  GROUP BY TO_CHAR(sale_date,'YYYY-MM')
)
ORDER BY sales_month;

PROMPT -- END SCRIPT --