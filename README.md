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
![table customers](https://github.com/user-attachments/assets/fe09baa1-fb73-4500-824e-7acbc41ed72e)
![ER Diagram customers](https://github.com/user-attachments/assets/c4545338-266b-411d-968c-1cacc111e71b)

### Products Table
![table products](https://github.com/user-attachments/assets/2dffa251-8758-4c2f-a87a-f08e037f9d2c)
![ER Diagram product](https://github.com/user-attachments/assets/9c0d235a-ec10-4e81-b2ff-1916ab748eb6)

### Transactions Table
![table transactions](https://github.com/user-attachments/assets/1011fe24-8946-4235-bea0-95c3570e07c7)
![ER Diagram transactions](https://github.com/user-attachments/assets/17979610-6ba0-433d-8cce-6a8f7435288b)

This schema tracks transactions involving animal-related products and customers. It includes three main tables:
CUSTOMERS: Stores customer details like ID, name, and region.
PRODUCTS: Contains product information including ID, name, and price.
TRANSACTIONS: Records each transaction with fields for transaction ID, customer ID, product ID, date, and amount.
 Relationships:
- Each transaction links to one customer and one product using foreign keys.

---

## ⚙️ Window Functions Implementation

### 1. Ranking – Top Products per Region
This query calculates the total revenue per customer and applies different ranking functions. RANK() assigns positions but leaves gaps if ties exist, DENSE_RANK() avoids gaps, ROW_NUMBER() gives unique sequential numbers, and PERCENT_RANK() shows percentile ranking.

![ranking](https://github.com/user-attachments/assets/bae2c737-6b90-495b-a771-ece3aae30088)

---

### 2. Aggregate – Running Monthly Sales Totals
SUM() OVER (...) gives a running total of sales per customer across time. AVG() OVER (...) with a frame calculates a 3-row moving average, useful for smoothing trends.

![aggregate](https://github.com/user-attachments/assets/e7324d50-4147-446c-97c8-1f6aff35e4a6)


---

### 3. Navigation – Month-over-Month Growth
LAG() looks at the previous month’s sales, and LEAD() looks at the next month’s sales. This allows you to compare a customer’s sales from one month to another 
![navigate](https://github.com/user-attachments/assets/51244523-5dbf-41f8-8310-cbeefb3abe5f)

---

### 4. Distribution – Customer Quartiles
NTILE(4) divides customers into 4 revenue-based groups (quartiles). CUME_DIST() shows the cumulative distribution position of each customer in the revenue ranking.
![distribution](https://github.com/user-attachments/assets/98b076d4-3635-44a3-a3ba-12edf8db56a3)

---

### 5. Moving Average – 3-Month Sales Trend
![moving averages](https://github.com/user-attachments/assets/7da74740-7174-42df-802d-ccb204bb3a22)

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

Thank you for visiting my repository

