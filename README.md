# 🎬 Netflix SQL Analysis

## 📌 Project Overview
Performed structured SQL analysis on Netflix content data 
to answer 15 real-world business questions using MySQL. 
The project covers content distribution, ratings, genre 
trends, country-wise analysis, actor insights, and 
content categorization.

---

## 📊 Dataset Summary
- **Source:** Netflix Titles Dataset
- **Total Records:** 8,807+ titles
- **Key Columns:** show_id, type, title, director, casts, 
  country, date_added, release_year, rating, duration, 
  listed_in, description
- **Data Loaded via:** MySQL `LOAD DATA LOCAL INFILE`
- **Null Handling:** Empty strings converted to NULL 
  using `NULLIF()` during data load

---

## 🛠 Tools & Technologies
| Tool | Usage |
|------|-------|
| MySQL | Database creation & querying |
| SQL (DDL + DML) | Table creation, data load, analysis |
| Window Functions | RANK() for rating analysis |
| String Functions | SUBSTRING_INDEX, TRIM, CHAR_LENGTH |
| CASE Statements | Content categorization |

---

## ❓ 15 Business Questions Solved

| # | Business Question | Key Technique |
|---|-------------------|---------------|
| Q1 | Count of Movies vs TV Shows | GROUP BY |
| Q2 | Most common rating for Movies & TV Shows | CTE + RANK() Window Function |
| Q3 | All movies released in a specific year (2020) | WHERE + Filter |
| Q4 | Top 5 countries with most content | SUBSTRING_INDEX + JOIN |
| Q5 | Longest movie on Netflix | CAST + ORDER BY |
| Q6 | Content added in last 5 years | GROUP BY + ORDER BY |
| Q7 | Movies/Shows by director 'Rajiv Chilaka' | WHERE + LIKE |
| Q8 | TV Shows with more than 5 seasons | CAST + SUBSTRING_INDEX |
| Q9 | Content count per genre | SUBSTRING_INDEX + JOIN |
| Q10 | Top 5 years with highest avg content release in India | Subquery + ROUND |
| Q11 | All documentary movies | LIKE filter |
| Q12 | Content without a director | IS NULL |
| Q13 | Movies with 'Salman Khan' in last 10 years | LIKE + YEAR() + CURDATE() |
| Q14 | Top 10 actors in Indian movies | SUBSTRING_INDEX + JOIN + GROUP BY |
| Q15 | Content categorized as 'Good' vs 'Bad' | CASE + Subquery |

---

## 🔍 Key SQL Insights

- **Movies dominate** Netflix content over TV Shows
- **TV-MA** is the most common rating for both Movies and TV Shows
- **USA, India, UK, Canada, France** are the top 5 content-producing countries
- **India's top content release years** show a consistent growth trend
- **Salman Khan** appeared in multiple movies in the last 10 years
- Content with keywords **'kill' or 'violence'** classified as Bad; 
  majority of content falls under **'Good'** category
- **Documentaries** form a significant portion of Netflix movies

---

## 💡 Advanced SQL Concepts Used

- **CTEs (Common Table Expressions)** — Q2 rating analysis
- **Window Functions** — `RANK() OVER (PARTITION BY...)`
- **String Splitting** — `SUBSTRING_INDEX` to handle 
  multi-value columns (country, cast, genre)
- **Dynamic Row Generation** — Number table JOIN trick 
  for splitting comma-separated values
- **Conditional Aggregation** — `CASE WHEN` for content labeling
- **Subqueries** — Nested SELECT for percentage calculations
- **NULL Handling** — `IS NULL`, `NULLIF()` during ETL

---

## 🗄️ Database Setup
```sql
-- Step 1: Create database
CREATE DATABASE netflix_db;

-- Step 2: Create table
CREATE TABLE netflix (
    show_id     VARCHAR(6),
    type        VARCHAR(10),
    title       VARCHAR(150),
    director    VARCHAR(208),
    casts       VARCHAR(1000),
    country     VARCHAR(150),
    date_added  VARCHAR(50),
    release_year INT,
    rating      VARCHAR(10),
    duration    VARCHAR(15),
    listed_in   VARCHAR(100),
    description VARCHAR(250)
);

-- Step 3: Load data
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'your_path/netflix_dataset.csv'
INTO TABLE netflix ...
```

## 👤 Author
**Aditya Kumar**  
Data Analyst | [GitHub](https://github.com/adityak024)
