
-- What are the most optimal skills to learn (High demand and high paying) in south america?

WITH skills_demand AS (
        SELECT
          sd.skill_id,
          sd.skills,
          COUNT(sd.skill_id) AS demand_count
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
              region = 'south america' AND
              year_salary IS NOT NULL AND
              job_work_from_home = TRUE
        GROUP BY sd.skill_id
                    ),
-- multiples CTE's se divide por , y se obvian los siguientes WITH
    salary_skills AS (
            SELECT
              sd.skill_id,
              sd.skills,
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
            GROUP BY sd.skill_id
                    )

SELECT
  sd.skills,
  demand_count,
  skill_avg_salary
FROM
  skills_demand AS sd
INNER JOIN salary_skills AS ss ON sd.skill_id = ss.skill_id
WHERE
  demand_count > 10
ORDER BY
  skill_avg_salary DESC
LIMIT 5