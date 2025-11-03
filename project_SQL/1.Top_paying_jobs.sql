
/* What are the top-paying data engineer jobs?
    - Identify the top 10 remote jobs and the companies, 
      then higlight opportunities for data engineers offering insights.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    cd.name AS company_name, 
    job_posted_date
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

