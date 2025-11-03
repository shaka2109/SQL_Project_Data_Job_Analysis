
/* What are the most optimal skills to learn (High demand and high paying)?
    - Identify the top 10 skills
      then higlight opportunities for data engineers offering insights.
*/


WITH skills_demand AS (
              SELECT
                sd.skill_id,
                sd.skills,
                COUNT(sd.skill_id) AS demand_count
              FROM
                  job_postings_fact AS jpf
              INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
              INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
              WHERE job_title_short = 'Data Engineer' AND
                    salary_year_avg IS NOT NULL AND
                    job_work_from_home =  TRUE
              GROUP BY sd.skill_id
                      ),
-- multiples CTE's se divide por , y se obvian los siguientes WITH
     avg_salary_skills AS (
              SELECT
                sd.skill_id,
                sd.skills,
                ROUND(AVG(salary_year_avg),0) AS skill_avg_salary  -- ROUND(valor,# decimals)
              FROM
                  job_postings_fact AS jpf
              INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
              INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
              WHERE job_title_short = 'Data Engineer' AND
                    salary_year_avg IS NOT NULL AND
                    job_work_from_home =  TRUE
              GROUP BY sd.skill_id
                          )

SELECT
  sd.skill_id,
  sd.skills,
  demand_count,
  skill_avg_salary
FROM
  skills_demand AS sd
INNER JOIN avg_salary_skills AS ass ON sd.skill_id = ass.skill_id
WHERE
  demand_count > 10
ORDER BY
  skill_avg_salary DESC
LIMIT 20
