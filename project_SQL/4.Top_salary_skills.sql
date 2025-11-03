
/* What are the top skills based on salary?
    - Identify the top 5 skills for data engineers with highest salary (and remote)
      then higlight opportunities for data engineers offering insights.
*/


SELECT
  skills,
  ROUND(AVG(salary_year_avg),0) AS skill_avg_salary  -- ROUND(valor,# decimals)
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Engineer' AND
      salary_year_avg IS NOT NULL AND
      job_work_from_home =  TRUE
GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 10

/*

1. High salaries correlate with specialization

These skills are not mainstream for typical data engineers (like Python, SQL, or Spark).
They’re niche, specialized tools or languages, meaning fewer professionals know them — 
and that scarcity drives up pay.

2. Cross-domain expertise is rewarded

Many of these skills sit at the intersection of data engineering and other advanced areas:

- Rust, Assembly → systems-level optimization, performance engineering.
- Solidity, Neo4j, GraphQL → blockchain, graph analytics, and modern API ecosystems.
- Julia, ggplot2 → heavy computational and data visualization tasks, bridging into data science.

3. Emerging + legacy tech both pay well

Interestingly:

Rust, Solidity, GraphQL are emerging technologies, tied to innovation and R&D roles.
Perl and Assembly are legacy or specialized systems still vital in some finance, 
aerospace, or embedded environments.
Both ends of the spectrum command high pay due to rarity of expertise.

4. Databases beyond SQL

MongoDB (NoSQL) and Neo4j (Graph) show that engineers who master non-relational data systems earn a premium — 
especially in big data, AI, or network analytics contexts.

*/