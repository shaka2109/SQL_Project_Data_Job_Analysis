
/* What are the top-paying data engineer jobs in south america?
    - Identify the top 10 remote and not remote. 
*/

-- Remote job

SELECT 
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


-- No remote job

SELECT 
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
    job_work_from_home = false
ORDER BY
    year_salary DESC
LIMIT 10

-- INSIGHTS

/*


*/
