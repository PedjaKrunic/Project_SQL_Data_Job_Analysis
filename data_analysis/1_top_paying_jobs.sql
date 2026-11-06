/*
Question: What are the top paying data analyst jobs?
- Identify the top 10 highest paying data analyst jobs that are available remotely.
- Focus on job postings with specified salaries (remove NULLs)
- Why? Highlight the top-paying opportunities for data analysts to help job seekers make informed career decisions.
*/

SELECT 
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_posted_date,
    jpf.salary_year_avg
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;