-- What skills are required for the top-paying data engineer jobs in south america?


WITH top_demand_jobs AS (
        SELECT 
            job_id,
            job_title,
            search_location,
            job_work_from_home,
            year_salary,
            cd.name AS company_name
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
        LEFT JOIN company_dim AS cd
            ON sub.company_id = cd.company_id
        WHERE
            job_title_short = 'Data Engineer' AND
            region = 'south america' AND
            year_salary IS NOT NULL AND
            job_work_from_home = TRUE
        ORDER BY
            year_salary DESC
        LIMIT 10
                    )

SELECT
    tdj.job_id,
    job_title,
    year_salary,
    company_name,
    sd.skills
FROM
    top_demand_jobs AS tdj
INNER JOIN skills_job_dim AS sjd
    ON tdj.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id


