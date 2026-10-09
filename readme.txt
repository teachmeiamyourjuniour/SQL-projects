# 🎵 Music Store Data Analysis Using SQL

## 📌 Project Overview

The **Music Store Data Analysis** project uses SQL to analyze a music store's transactional database and extract meaningful business insights. Using MySQL, this project explores customer purchasing behavior, sales performance, music genre preferences, and artist popularity.

The goal is to transform raw relational data into actionable insights that can support business decisions, targeted marketing campaigns, and revenue optimization.

## 🎯 Project Objectives

- Analyze customer purchasing patterns and identify high-value customers.
- Identify countries and cities generating the highest sales.
- Determine the most popular music genres across countries.
- Identify artists and tracks contributing to music sales.
- Practice SQL concepts using real-world business questions.
- Develop efficient queries for data analysis and reporting.

## 🛠️ Technologies Used

- **Database:** MySQL
- **Query Language:** SQL
- **Data Source:** Music Store relational database
- **Tools:** MySQL-compatible database management tools

## 🗂️ Database Overview

The database contains interconnected tables representing the music store's business operations.

| Table | Description |
|---|---|
| `Employee` | Employee details and reporting relationships |
| `Customer` | Customer information and support representatives |
| `Invoice` | Customer purchase transactions |
| `InvoiceLine` | Individual tracks purchased in each invoice |
| `Track` | Track details, including duration and price |
| `Album` | Album information |
| `Artist` | Artist details |
| `Genre` | Music genre classifications |
| `MediaType` | Track media formats |
| `Playlist` | Playlist information |
| `PlaylistTrack` | Relationships between playlists and tracks |

Primary keys and foreign keys connect these tables and enable relational analysis.

## 🔍 Key Business Questions

This project addresses the following business problems:

1. Who is the senior-most employee based on job title?
2. Which countries generate the highest number of invoices?
3. What are the top three invoice values?
4. Which city generates the highest total revenue?
5. Who is the highest-spending customer?
6. Which customers listen to Rock music?
7. Which artists have produced the most Rock tracks?
8. Which tracks are longer than the average song duration?
9. How much does each customer spend on different artists?
10. What is the most popular music genre in each country?
11. Who is the highest-spending customer in each country?

## 🧠 SQL Concepts Applied

The project demonstrates practical use of:

- `SELECT`, `WHERE`, `ORDER BY`, and `LIMIT`
- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- `GROUP BY` and `HAVING`
- Joins across multiple related tables
- Subqueries and nested queries
- Common Table Expressions (CTEs), where applicable
- Window functions and ranking techniques, where applicable
- Date-based analysis and conditional logic
- Primary keys, foreign keys, and relational database design

## 💼 Business Value

The analysis supports data-driven decision-making by helping the business:

- Identify high-value customers for targeted promotions.
- Select promising cities for promotional events and music festivals.
- Understand regional music preferences.
- Identify popular artists and genres for marketing initiatives.
- Better understand revenue distribution and purchasing behavior.

## 📁 Repository Structure

```text
music-store-sql-analysis/
│
├── README.md
├── music_store_analysis.sql
├── Music Store SQL Analysis PPT.pptx
└── schema/
    └── schema_diagram.png
```

*Update the filenames and folder structure to match the actual files in your repository.*

## 🚀 Getting Started

1. Install MySQL or use a compatible SQL environment.
2. Create a database named `music_store`.
3. Create the tables using the database schema.
4. Import the required dataset into the corresponding tables.
5. Execute the SQL queries to reproduce the analysis.
6. Review the query results and interpret the business insights.

Ensure that the data is imported correctly and that table relationships are established before running the analysis.

## 📈 Key Learnings

Through this project, I strengthened my understanding of relational databases, SQL querying, multi-table joins, aggregation, subqueries, and business-oriented data analysis. The project also helped me practice translating business questions into structured SQL queries.

## 👤 Author

**Mukund**

- GitHub: [@teachmeiamyourjuniour](https://github.com/teachmeiamyourjuniour)

## ⭐ Conclusion

The Music Store Data Analysis project demonstrates how SQL can be used to explore transactional data, identify business trends, and generate actionable insights. It showcases practical database querying skills and the application of SQL to real-world analytical problems.
