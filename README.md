# Advanced SQL: Comprehensive Employee Analysis

## Project Overview
This project provides a comprehensive analysis of the 'Parks and Recreation' employee dataset. It leverages advanced SQL techniques, including Common Table Expressions (CTEs) and Window Functions, to generate an integrated analytical report. The analysis offers insights into salary structures, intra-departmental employee rankings, and overall employee demographics.

## Skills Demonstrated
* Advanced SQL
* Common Table Expressions (CTEs)
* Window Functions (`ROW_NUMBER`, `AVG`)
* Complex `JOIN`s
* Data Aggregation & Analysis (`ROUND`, `ORDER BY`)

## How to Run
1.  Execute the script in the `1_database_setup.sql` file to create the database schema and populate the tables.
2.  Run the queries in the `2_analysis_queries.sql` file to view the analysis.

## Key Query & Analysis
The following query is the main engine for this analysis. It joins data from multiple tables and uses CTEs and Window Functions to calculate key analytical metrics for each employee.

```sql
WITH emp_demographics AS (
    SELECT ed.employee_id, ed.first_name, ed.age, ed.gender
    FROM employee_demographics ed
),
emp_salary AS (
    SELECT
        es.employee_id, es.salary, pd.department_name,
        ROW_NUMBER() OVER(PARTITION BY pd.department_name ORDER BY es.salary DESC) AS salary_rank_in_dept,
        AVG(es.salary) OVER(PARTITION BY pd.department_name) AS avg_salary_in_dept,
        (es.salary - AVG(es.salary) OVER(PARTITION BY pd.department_name)) AS difference_from_avg
    FROM employee_salary es
    JOIN parks_departments pd ON es.dept_id = pd.department_id
)
SELECT
    ed.first_name,
    ed.age,
    ed.gender,
    es.salary,
    es.department_name,
    es.salary_rank_in_dept,
    es.avg_salary_in_dept,
    es.difference_from_avg,
    ROUND(es.avg_salary_in_dept, 2) AS avg_salary_rounded,
    ROUND(es.difference_from_avg, 2) AS difference_rounded
FROM emp_demographics ed
JOIN emp_salary es ON ed.employee_id = es.employee_id
ORDER BY es.department_name, es.salary_rank_in_dept;
```

## Key Insights
* The analysis provides a clear, salary-based ranking of employees within each department.
* It highlights the deviation of each employee's salary from their department's average, helping to identify potential salary discrepancies.