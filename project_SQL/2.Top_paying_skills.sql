/* What skills are required for the top-paying data engineer jobs?
    - Identify the top 10 remote jobs and the companies
    - Add specific skills for this roles. 
      then higlight opportunities for data engineers offering insights.
*/

WITH top_DE_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    cd.name AS company_name
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE 
    job_title_short = 'Data Engineer' AND
    salary_year_avg IS NOT NULL AND
    job_location =  'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10
                       )

SELECT
    tDEj.job_id,
    job_title,
    salary_year_avg,
    company_name,
    sd.skills
FROM
    top_DE_jobs AS tDEj
INNER JOIN skills_job_dim AS sjd
    ON tDEj.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id


-- INSIGHTS

/*
Python dominates the toolset, appearing in nearly every listing — 
reaffirming its role as the foundational language for data engineering.

Big data tools like Spark, Hadoop, and Kafka remain essential — 
these are core for distributed data processing and streaming.

Cloud & orchestration tools such as Kubernetes, Databricks, and GCP appear, 
signaling demand for cloud-native data solutions.

Programming diversity: While Python leads, Scala, Java, and even Go show up — 
suggesting versatility is valued.

Data manipulation libraries (Pandas, NumPy, PySpark) 
indicate overlap with data analysis and data science workflows.

*/