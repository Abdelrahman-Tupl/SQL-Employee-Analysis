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