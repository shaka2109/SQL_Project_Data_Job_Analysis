# Introduction
An in-depth exploration of the data job market, focusing on Data Engineer roles. The project uncovers insights into the most sought-after skills, highest-paying technologies, remote work trends, and other market dynamics.

Check SQL queries here.
[project_sql folder](/project_SQL/)

This project originated from my desire to deepen my SQL skills and document the practical journey I’ve taken toward becoming a Data Engineer.

# Tools I used

To explore the Data Engineer job market in depth, I combined several powerful tools:

- **SQL**: The foundation of my analysis, used to query databases and extract valuable insights.
- **PostgreSQL**: The chosen database management system, ideal for handling job posting data.
- **Visual Studio Code**: My primary workspace for managing databases and executing SQL queries.
- **Git & GitHub**: Essential for version control, collaboration, and tracking project progress.

# The analysis

Each query for this project aimed at investigation specific aspects of the mrket. Here are the questions that were designed and how they were approached.

### 1. Top paying Data Engineer Jobs
Identify the highest-paying roles, I filtered data engineer positions by average yearly salary and location, focusing on remote jobs.

``` sql
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
```

# What I learned
# Conclusions

