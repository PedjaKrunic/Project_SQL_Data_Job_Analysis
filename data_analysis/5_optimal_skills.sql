/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst jobs
- Concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salary),
    offering strategic insights for career development in data analysis
*/

WITH top_demand_skills AS (
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Analyst' AND
          jpf.salary_year_avg IS NOT NULL AND
          jpf.job_work_from_home = True
    GROUP BY sd.skill_id
),
top_paying_skills AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id
    WHERE jpf.salary_year_avg IS NOT NULL AND
          jpf.job_work_from_home = True
    AND jpf.job_title_short = 'Data Analyst'
    GROUP BY sd.skill_id
)   


SELECT 
    tds.skill_id,
    tds.skills,
    tds.demand_count,
    tps.avg_salary
FROM top_demand_skills AS tds
INNER JOIN top_paying_skills AS tps
    ON tds.skill_id = tps.skill_id
WHERE tds.demand_count >= 10
ORDER BY tps.avg_salary DESC, tds.demand_count DESC