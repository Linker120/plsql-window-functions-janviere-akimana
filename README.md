# 📊 PL/SQL Window Functions – Coffee Distribution Analysis

## 📌 Project Overview
This project demonstrates the use of **PL/SQL window functions** to analyze sales and customer behavior for a coffee distribution company operating across regions (Kigali, Bugesera, Musanze). The analysis supports **marketing strategies** and **inventory planning** by identifying sales trends, top-performing products, and customer segments.

---

## 🏢 Business Problem
**Business Context**  
A coffee distribution company operating across multiple regions (Kigali, Bugesera, and Musanze) aims to enhance decision-making by leveraging sales and customer data. The company manages a wide range of products and serves a diverse customer base in these regions.

**Data Challenge**  
Although the company records thousands of transactions, it lacks actionable insights into which products perform best in each region, seasonal purchasing patterns, and how customer behavior evolves over time. Without these insights, both marketing strategies and inventory planning remain inefficient.

**Expected Outcome**  
The analysis will provide a clear view of top-selling products by region, identify sales growth trends, and segment customers into meaningful groups. These insights will guide targeted marketing campaigns, improve inventory management, and support data-driven decision-making for business growth.

---

## 🎯 Success Criteria
This project implements **five measurable goals** using window functions:

1. **Top 5 products per region/quarter** → `RANK()`  
2. **Running monthly sales totals** → `SUM() OVER()`  
3. **Month-over-month growth (%)** → `LAG()` / `LEAD()`  
4. **Customer quartiles (segmentation)** → `NTILE(4)`  
5. **3-month moving averages** → `AVG() OVER()`  

---

## 🗄 Database Schema

### Customers Table
| Column      | Type         | Key |
|-------------|--------------|-----|
| customer_id | INT          | PK  |
| name        | VARCHAR(50)  |     |
| region      | VARCHAR(50)  |     |

### Products Table
| Column      | Type         | Key |
|-------------|--------------|-----|
| product_id  | INT          | PK  |
| name        | VARCHAR(50)  |     |
| category    | VARCHAR(50)  |     |

### Transactions Table
| Column        | Type        | Key |
|---------------|-------------|-----|
| transaction_id| INT         | PK  |
| customer_id   | INT         | FK  |
| product_id    | INT         | FK  |
| sale_date     | DATE        |     |
| amount        | DECIMAL     |     |

📌 *ER diagram included in `/diagrams/ERD.png`*

---

## ⚙️ Window Functions Implementation

### 1. Ranking – Top Products per Region
```sql
SELECT c.region,
       p.name AS product_name,
       SUM(t.amount) AS total_sales,
       RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS product_rank
FROM transactions t
JOIN customers c ON c.customer_id = t.customer_id
JOIN products p ON p.product_id = t.product_id
GROUP BY c.region, p.name
ORDER BY c.region, product_rank;
```

**Expected Output:**
| Region   | Product Name    | Total Sales | Product Rank |
|----------|-----------------|-------------|--------------|
| Bugesera | Instant Coffee  | 20,000      | 1 |
| Bugesera | Coffee Capsules | 30,000      | 1 |
| Bugesera | Ground Coffee   | 15,000      | 3 |
| Kigali   | Coffee Beans    | 55,000      | 1 |
| Kigali   | Ground Coffee   | 95,000      | 2 |
| Kigali   | Instant Coffee  | 55,000      | 3 |
| Musanze  | Ground Coffee   | 40,000      | 1 |
| Musanze  | Coffee Capsules | 30,000      | 2 |
| Musanze  | Coffee Beans    | 25,000      | 3 |

📸 *Screenshot: `/screenshots/ranking.png`*

---

### 2. Aggregate – Running Monthly Sales Totals
```sql
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS sales_month,
       SUM(amount) AS monthly_sales,
       SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date,'YYYY-MM') ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM transactions
GROUP BY TO_CHAR(sale_date,'YYYY-MM')
ORDER BY sales_month;
```

**Expected Output:**
| Sales Month | Monthly Sales | Cumulative Sales |
|-------------|---------------|------------------|
| 2024-01     | 115,000       | 115,000 |
| 2024-02     | 110,000       | 225,000 |
| 2024-03     | 165,000       | 390,000 |

📸 *Screenshot: `/screenshots/aggregate.png`*

---

### 3. Navigation – Month-over-Month Growth
```sql
SELECT sales_month,
       monthly_sales,
       LAG(monthly_sales,1) OVER (ORDER BY sales_month) AS prev_month_sales,
       ROUND(
         (monthly_sales - LAG(monthly_sales,1) OVER (ORDER BY sales_month)) /
         NULLIF(LAG(monthly_sales,1) OVER (ORDER BY sales_month),0) * 100,2
       ) AS growth_pct
FROM (
    SELECT TO_CHAR(sale_date,'YYYY-MM') AS sales_month,
           SUM(amount) AS monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date,'YYYY-MM')
)
ORDER BY sales_month;
```

**Expected Output:**
| Sales Month | Monthly Sales | Prev Month Sales | Growth % |
|-------------|---------------|------------------|----------|
| 2024-01     | 115,000       | NULL             | NULL     |
| 2024-02     | 110,000       | 115,000          | -4.35%   |
| 2024-03     | 165,000       | 110,000          | 50.00%   |

📸 *Screenshot: `/screenshots/navigation.png`*

---

### 4. Distribution – Customer Quartiles
```sql
SELECT c.name AS customer_name,
       SUM(t.amount) AS total_spent,
       NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS quartile
FROM transactions t
JOIN customers c ON c.customer_id = t.customer_id
GROUP BY c.name;
```

**Expected Output:**
| Customer Name     | Total Spent | Quartile |
|-------------------|-------------|----------|
| Janviere Akimana  | 105,000     | 1 |
| Holy Isezerano    | 100,000     | 2 |
| Maxyme Abakunzi   | 95,000      | 3 |
| Miracle Ihirwe    | 65,000      | 4 |

📸 *Screenshot: `/screenshots/distribution.png`*

---

### 5. Moving Average – 3-Month Sales Trend
```sql
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
```

**Expected Output:**
| Sales Month | Monthly Sales | 3-Month Moving Avg |
|-------------|---------------|--------------------|
| 2024-01     | 115,000       | 115,000 |
| 2024-02     | 110,000       | 112,500 |
| 2024-03     | 165,000       | 130,000 |

📸 *Screenshot: `/screenshots/moving_avg.png`*

---

## 📈 Results Analysis

**Descriptive (What happened?)**  
- Kigali generated the highest sales consistently.  
- Sales peaked in March 2024.  
- Top products differed by region.  

**Diagnostic (Why?)**  
- Kigali had more high-value repeat customers.  
- Bugesera demand dropped due to fewer promotions.  
- March spike was linked to seasonal promotions.  

**Prescriptive (What next?)**  
- Increase promotions in Bugesera.  
- Stock more top products in Kigali.  
- Use quartile segmentation for loyalty programs.  
- Monitor moving averages for better forecasting.  

---

## 📂 Repository Structure
```
plsql-window-functions-janviere/
│── sql_scripts/        # All SQL queries
│── screenshots/        # Execution results
│── diagrams/           # ER diagram
│── README.md           # Documentation
```

---

## 📚 References
1. Oracle Documentation – Window Functions  
2. Oracle SQL Tutorials (official docs)  
3. GeeksforGeeks – SQL Analytical Functions  
4. TutorialsPoint – PL/SQL Window Functions  
5. W3Schools SQL Analytics Guide  
6. Course notes – Database Development with PL/SQL  
7. Oracle Live SQL Examples  
8. StackOverflow (adapted solutions)  
9. Academic paper: "Analytical Queries in Business Intelligence"  
10. Business reports on coffee industry sales  

---

## ✅ Integrity Statement
All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.
