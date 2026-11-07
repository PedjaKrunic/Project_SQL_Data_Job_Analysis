/*
Question: What are the top skills based on salary?
- Look at the average salary for each skill for Data Analyst jobs
- Focus on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts 
    and helps identify the most financially rewarding skills to acuqire or improve
*/

SELECT
    sd.skills,
    COUNT(jpf.job_id) AS job_count,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE jpf.salary_year_avg IS NOT NULL AND
      jpf.job_title_short = 'Data Analyst'
GROUP BY sd.skills
HAVING COUNT(jpf.job_id) >= 10
ORDER BY job_count DESC;
