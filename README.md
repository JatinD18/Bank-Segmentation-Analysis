# 🏦 Bank Customer Segmentation Analysis — SQL & Power BI Portfolio Project

## Overview

This project performs a bank customer segmentation analysis using simulated banking data containing:

- **10,000 customers**
- **~14,000 accounts**
- **100,000 transactions**

The objective is to identify high-value customers, dormant accounts, cross-sell opportunities, and city-wise performance trends using SQL, and present the findings through a Power BI dashboard.

This project demonstrates the full analytics workflow:

1. Database design and data modeling in MySQL
2. Simulated data generation using SQL
3. Business question-driven SQL analysis
4. RFM customer segmentation
5. Power BI dashboard creation
6. Portfolio documentation using GitHub

---

## 🛠️ Tools & Technologies

- **MySQL 8.0** — Database design, data generation, analytical queries
- **Power BI** — Dashboard creation and business visualization
- **GitHub** — Version control and portfolio documentation
- **VS Code** — Project organization and Git workflow

---

## 📊 Power BI Dashboard

![Power BI Dashboard](https://github.com/JatinD18/Bank-Segmentation-Analysis/blob/main/dashboard/assets/powerbi_dashboard.png)

The dashboard focuses on four business questions:

1. Which customers belong to which RFM segment?
2. Which accounts are dormant or at risk of churn?
3. Which customers hold only one product and can be cross-sold?
4. Which cities generate the highest transaction volume and customer value?

---

## 🔑 Key Business Insights

### 1. City-wise Performance

Bangalore is the strongest transaction hub, generating the highest total transaction volume.

| City | Total Transaction Volume | Revenue Per Customer |
|---|---:|---:|
| Bangalore | ₹274,174,565.73 | ₹254,809.08 |
| Ahmedabad | ₹260,387,394.00 | ₹254,284.56 |
| Mumbai | ₹255,684,210.77 | ₹249,204.88 |
| Pune | ₹252,980,151.28 | ₹257,093.65 |

**Insight:**  
Bangalore leads in total transaction volume, while Pune delivers the highest revenue per customer. This suggests that Pune customers may be more valuable on a per-customer basis, even if Bangalore has a larger overall transaction base.

**Recommendation:**  
The bank should study Pune’s product penetration and customer behavior model, then replicate successful strategies in other metros such as Mumbai, Chennai, and Hyderabad.

---

### 2. Dormancy and Retention Risk

Dormancy rates are relatively consistent across cities, but Lucknow shows the highest dormant account percentage.

| City | Total Accounts | Active Accounts | Dormant Accounts | Dormant % |
|---|---:|---:|---:|---:|
| Lucknow | 1,441 | 1,282 | 159 | 11.0% |
| Delhi | 1,455 | 1,304 | 151 | 10.4% |
| Jaipur | 1,473 | 1,321 | 152 | 10.3% |
| Kolkata | 1,437 | 1,289 | 148 | 10.3% |
| Pune | 1,500 | 1,361 | 139 | 9.3% |

**Insight:**  
Pune has the lowest dormancy rate at 9.3%, while Lucknow has the highest at 11.0%. Bangalore has the largest active account base with 1,491 active accounts.

**Recommendation:**  
Launch targeted win-back campaigns in Lucknow, Delhi, Jaipur, and Kolkata. Since dormancy is not extremely uneven across regions, a centralized digital retention campaign may be more effective than city-specific branch interventions.

---

### 3. Cross-Sell Opportunity

Several customers hold only one banking product, mainly Current, Savings, or Fixed Deposit accounts.

**Insight:**  
Single-product customers are more vulnerable to competitor switching. Banking research commonly shows that customers with multiple products have higher retention and higher lifetime value.

**Recommendation:**  
Create automated cross-sell triggers:

- Current account customers → offer Savings account or credit card
- Savings account customers → offer Fixed Deposit or personal loan
- Fixed Deposit customers → offer digital Savings account for daily transactions

---

### 4. RFM Segmentation

RFM segmentation classifies customers based on:

- **Recency** — how recently the customer transacted
- **Frequency** — how often the customer transacts
- **Monetary** — how much value the customer moves

Customers are assigned to segments such as:

- Champions
- Loyal Customers
- Big Spenders
- Recent Customers
- At Risk
- Need Attention
- Hibernating

**Insight:**  
RFM segmentation helps the bank move beyond simple account status and classify customers by actual transaction behavior. This is especially important because some accounts marked as active may not have transacted recently.

**Recommendation:**  
Protect Champions with premium services, recover At Risk customers through targeted campaigns, and reactivate Hibernating customers using low-friction digital offers.

---

## 🧠 SQL Skills Demonstrated

### Data Modeling

- Created normalized tables:
  - `customers`
  - `accounts`
  - `transactions`
- Used primary keys and foreign keys
- Designed relational joins between customers, accounts, and transactions

### Data Generation

- Generated simulated customer, account, and transaction data
- Used recursive CTEs for bulk data generation
- Created stored procedures for batch inserts
- Handled MySQL recursion and timeout limitations

### Analytical SQL

Used:

- `JOIN`
- `GROUP BY`
- `HAVING`
- `CASE WHEN`
- `COUNT()`
- `SUM()`
- `AVG()`
- `ROUND()`
- `MAX()`
- `DATEDIFF()`
- `DATE_FORMAT()`
- `DATE_SUB()`
- `CURDATE()`

### Advanced Segmentation

Used:

- CTEs — Common Table Expressions
- Window functions — `NTILE()`
- RFM scoring logic
- Customer segment classification using `CASE WHEN`

---

## 📁 Repository Structure

```text
Bank-Segmentation-Analysis/
│
├── data/
│   └── exported/
│       ├── rfm_segment_summary.csv
│       ├── dormant_accounts.csv
│       ├── single_product_customers.csv
│       └── city_performance.csv
│
├── sql/
│   ├── 01_schema_setup.sql
│   ├── 02_data_generation.sql
│   ├── 02c_generating_transactions.sql
│   ├── 03_business_queries.sql
│   └── 04_rfm_segmentation.sql
│
├── dashboard/
│   ├── assets/
│   │   ├── powerbi_dashboard.png
│   │   ├── 01_rfm_segment_distribution.png
│   │   ├── 02_dormant_accounts.png
│   │   ├── 03_single_product_customers.png
│   │   └── 04_city_performance.png
│   ├── Bank_Segmentation_Dashboard.pbix
│   └── Bank_Segmentation_Dashboard.pdf
│
├── .gitignore
└── README.md
```

---

## 🖼️ SQL Analysis Highlights

### 1. RFM Segment Distribution

![RFM Segment Distribution](https://github.com/JatinD18/Bank-Segmentation-Analysis/blob/main/dashboard/assets/01_rfm_segment_distribution.png)

### 2. Dormant Accounts Detection

![Dormant Accounts](https://github.com/JatinD18/Bank-Segmentation-Analysis/blob/main/dashboard/assets/02_dormant_accounts.png)

### 3. Single Product Customers

![Single Product Customers](https://github.com/JatinD18/Bank-Segmentation-Analysis/blob/main/dashboard/assets/03_single_product_customers.png)

### 4. City-wise Performance

![City Performance](https://github.com/JatinD18/Bank-Segmentation-Analysis/blob/main/dashboard/assets/04_city_performance.png)

---

## 🚀 How to Run This Project

### Step 1: Open MySQL Workbench

Connect to your local MySQL server.

### Step 2: Create Database and Tables

Run:

```sql
sql/01_schema_setup.sql
```

### Step 3: Generate Simulated Data

Run:

```sql
sql/02_data_generation.sql
```

This will generate:

- customers
- accounts
- transactions

### Step 4: Run Business Analysis Queries

Run:

```sql
sql/03_business_queries.sql
```

This includes queries for:

- total spend
- salary trends
- active accounts
- monthly/yearly trends
- high-value customers
- dormant accounts
- single-product customers
- service usage
- city performance
- active vs dormant split

### Step 5: Run RFM Segmentation

Run:

```sql
sql/04_rfm_segmentation.sql
```

This creates customer segments using Recency, Frequency, and Monetary scoring.

### Step 6: Open Power BI Dashboard

Open:

```text
dashboard/Bank_Segmentation_Dashboard.pbix
```

Or view the exported PDF:

```text
dashboard/Bank_Segmentation_Dashboard.pdf
```

---

## 👤 Author

**Jatin Naresh Dolas**

[LinkedIn](https://www.linkedin.com/in/jatin-dolas) | [GitHub](https://github.com/JatinD18)
