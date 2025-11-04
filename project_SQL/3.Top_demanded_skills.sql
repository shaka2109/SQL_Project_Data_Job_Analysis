/* What are the most-indemand skills for data engineer in south america?
    - Identify the top 5 in_demand skills for data engineers
      then higlight opportunities for data engineers offering insights.
*/

SELECT
  skills,
  COUNT(sjd.skill_id) AS demand_count
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
      region = 'south america'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10


-- INSIGHTS

/*


*/


