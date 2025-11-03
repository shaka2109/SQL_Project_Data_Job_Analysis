/* What are the most-indemand skills for data engineer?
    - Identify the top 5 in_demand skills for data engineers
      then higlight opportunities for data engineers offering insights.
*/



SELECT
  skills,
  COUNT(sjd.skill_id) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Engineer'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5