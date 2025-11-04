
-- What are the top skills based on salary in south america?

SELECT
  skills,
  ROUND(AVG(year_salary), 0) AS skill_avg_salary
FROM
    (   SELECT
            *,
            CASE
                WHEN search_location IN ('Colombia','Brazil','Peru',
                                    'Chile','Argentina','Paraguay','Uruguay',
                                    'Bolivia','Venezuela','Ecuador') THEN 'south america'
                ELSE 'rest of the world'
                END AS region,
            CASE
                WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
                WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
                ELSE NULL
                END AS year_salary
            FROM job_postings_fact ) AS sub
INNER JOIN skills_job_dim AS sjd ON sub.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Engineer' AND
      year_salary IS NOT NULL AND
      region = 'south america' AND
      job_work_from_home = TRUE
GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 5
