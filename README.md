# Introduction
An in-depth exploration of the data job market, focusing on Data Engineer roles in the main countries of South America. The project uncovers insights into the most sought-after skills, highest-paying technologies, remote work trends, and other market dynamics.

Check SQL queries here.
[project_sql folder](/project_SQL/)

This project originated from my desire to deepen my SQL skills and document the practical journey I’ve taken toward becoming a Data Engineer and the database is taken from the course [SQL Course](https://lukebarousse.com/sql), as a Data Job Market in 2023.

# Tools I used

To explore the Data Engineer job market in depth, I combined several powerful tools:

- **SQL**: The foundation of my analysis, used to query databases and extract valuable insights.
- **PostgreSQL**: The chosen database management system, ideal for handling job posting data.
- **Visual Studio Code**: My primary workspace for managing databases and executing SQL queries.
- **Git & GitHub**: Essential for version control, collaboration, and tracking project progress.

# Analysis

Each query for this project aimed at investigation specific aspects of the market stipulation as a base for the study a filter of Data Engineer position and job offers in South America. Here are the questions that were designed and how they were approached.

## 1. Top paying Data Engineer Jobs
Identify the highest-paying roles in south america, I normalized the job postings where the salary was hourly to yearly, then by using a subquery I filtered data engineer positions and countries in south america, finally I joined a dimension table with company data in order to show the companies related to the filtered jobs, focusing on remote jobs.

``` sql
SELECT 
    job_title,
    search_location,
    job_work_from_home,
    year_salary,
    cd.name AS company_name
FROM (   
    SELECT *,
        CASE
            WHEN search_location IN ('Colombia','Brazil','Peru','Chile','Argentina','Paraguay','Uruguay','Bolivia','Venezuela','Ecuador') THEN 'south america'
            ELSE 'rest of the world'
            END AS region,
        CASE
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg*2080
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            ELSE NULL
            END AS year_salary
    FROM job_postings_fact 
    ) AS sub
LEFT JOIN company_dim AS cd ON sub.company_id = cd.company_id
WHERE
    job_title_short = 'Data Engineer' AND
    region = 'south america' AND
    year_salary IS NOT NULL AND
    job_work_from_home = TRUE
ORDER BY
    year_salary DESC
LIMIT 10
```

###

- The highest-paying roles ($171,875) come from Near, likely targeting senior or specialized data platform engineers.
- Braintrust dominates mid-to-high salary range (~$166,400) across multiple South American countries — this suggests a consistent pay model for remote contractors across borders.
- Robert Half ($110,000) and Pocket Network ($60,000) show that traditional recruitment and smaller startups offer substantially less.

### Insights

The same roles (especially Braintrust postings) appear replicated across Colombia, Brazil, Argentina, Bolivia, Paraguay, Peru, and Venezuela — indicating pan-regional remote hiring rather than country-specific recruitment.

This supports the idea that location within South America has little impact on pay, as salaries are standardized in USD for remote global positions. Companies like Near and Braintrust treat South America as a unified remote talent region, not by individual market.


## 2. What skills are required for the top-paying data engineer jobs in south america?

To identify the skills required in top-paying job offers for south america, I normalized again the salary to yearly, and I create a subquery to filter by job role and countries. Subsequently, I joined a dimension table with skills data in order to show the name of the skills related to the top_paying remote jobs.

``` sql
WITH top_demand_jobs AS 
(
        SELECT 
            job_id,
            job_title,
            search_location,
            job_work_from_home,
            year_salary,
            cd.name AS company_name
        FROM 
        (   SELECT *,
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
            FROM job_postings_fact 
        ) AS sub
        LEFT JOIN company_dim AS cd ON sub.company_id = cd.company_id
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
INNER JOIN skills_job_dim AS sjd ON tdj.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
```

###


### Insights

## 3. What are the most-indemand skills for data engineer in south america?

To identify the top 10 in-demand skills in job offers for south america, I normalized again the salary to yearly, and I create a subquery to filter by job role and countries. Subsequently, I joined a dimension table with skills data in order to group by the skills and calculate the amount of time a skill is mentioned for the filtered jobs. This way I order by the count and get the result.

``` sql
SELECT
  skills,
  COUNT(sjd.skill_id) AS demand_count
FROM
     (  SELECT
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
            FROM job_postings_fact 
     )  AS sub
INNER JOIN skills_job_dim AS sjd ON sub.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Engineer' AND
      region = 'south america'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10
```

### Result

|   skills   |  demand_count  |
|------------|----------------|
|   python   |      5703      |
|     sql    |      5690      |
|     aws    |      3372      |
|    spark   |      2503      |
|    azure   |      2444      |

### Insights

---###---

## 4. What are the top skills based on salary in south america?

To identify the top-paying skills in south america, I normalized again the salary to yearly, and I create a subquery to filter by job role and countries. Subsequently, I joined a dimension table with skills data in order to group by the skills and calculate through an aggregation function the average salary for each individual skill. This way I order by the average salary and get the result.

``` sql
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
            FROM job_postings_fact 
    )   AS sub
INNER JOIN skills_job_dim AS sjd ON sub.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Engineer' AND
      year_salary IS NOT NULL AND
      region = 'south america' AND
      job_work_from_home = TRUE
GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 5
```

### Result

|    skills   | skill_avg_salary |
|-------------|------------------|
|elasticsearch|       171875     |
|    zoom     |       168542     |
|     rust    |       168542     |
|   express   |       168542     |
|     db2     |       166400     |


### Insights
----###-----

## 5. What are the most optimal skills to learn (High demand and high paying) in south america?

To identify the most optimal skills in south america, I create two CTE's from the previous calculation for the question 3 and 4. Subsequently, I joined a dimension table with skills data in order to group by the skills filtered by a reasonable numer of demand skills and order by the average salay to get the result.

``` sql
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
  sd.skill_id,
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
LIMIT 10
```

### Result

|  skills  | demand_count |skill_avg_salary|
|----------|--------------|----------------|
|  oracle  |      12      |     166400     |
|   java   |      12      |     166400     |
|    c#    |      12      |     166400     |
|   db2    |      12      |     166400     |
|snowflake |      12      |     166400     |


### Insights
----###----


# What I learned

# Conclusions

