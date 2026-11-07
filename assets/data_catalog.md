# Data Catalog – Data Analyst Job Market Analysis

## Overview

This database contains job posting data from 2023 and is designed to support SQL-based analysis of the Data Analyst job market.

It includes information about job postings, companies, salaries and technical skills required by employers.

The database follows a dimensional modeling approach, consisting of one fact table, two dimension tables and one bridge table used to resolve the many-to-many relationship between job postings and skills.

### Objects Overview

| Object | Type | Description |
|---|---|---|
| `public.job_postings_fact` | FACT TABLE | Contains job posting information, including job titles, locations, salary details and employment conditions. |
| `public.company_dim` | DIMENSION TABLE | Contains company-related information associated with job postings. |
| `public.skills_dim` | DIMENSION TABLE | Contains a list of technical skills and their classifications. |
| `public.skills_job_dim` | BRIDGE TABLE | Connects job postings with their required skills through a many-to-many relationship. |

---

## 1. Fact Table: public.job_postings_fact

### Purpose

This table contains job posting information and serves as the central table for the analysis.

It stores details about individual job opportunities, including job titles, locations, employment conditions, salary information and company references.

The table connects to `company_dim` through `company_id` and to `skills_job_dim` through `job_id`.

### Grain

One row represents one unique job posting, identified by `job_id`.

### Columns

| Column | Data Type | Description |
|---|---|---|
| `job_id` | INT | Primary key identifying each unique job posting. |
| `company_id` | INT | Foreign key referencing the company associated with the job posting. |
| `job_title_short` | VARCHAR(255) | Short job title or job category used to classify the position (e.g. Data Analyst, Data Scientist). |
| `job_title` | TEXT | Full job title as provided in the job posting. |
| `job_location` | TEXT | Location associated with the job posting (e.g. Anywhere, New York, NY). |
| `job_via` | TEXT | Platform or source through which the job posting was found. |
| `job_schedule_type` | TEXT | Employment or work schedule type (e.g. Full-time, Part-time, Contract). |
| `job_work_from_home` | BOOLEAN | Indicates whether the job posting is classified as work-from-home. |
| `search_location` | TEXT | Geographic location used when searching for the job posting. |
| `job_posted_date` | TIMESTAMP | Date and time when the job posting was published. |
| `job_no_degree_mention` | BOOLEAN | Indicates whether the job posting contains a mention related to not requiring a degree. |
| `job_health_insurance` | BOOLEAN | Indicates whether health insurance is mentioned in the job posting. |
| `job_country` | TEXT | Country associated with the job posting. |
| `salary_rate` | TEXT | Salary payment frequency or rate type (e.g. yearly, hourly). |
| `salary_year_avg` | NUMERIC | Average annual salary associated with the job posting. |
| `salary_hour_avg` | NUMERIC | Average hourly salary associated with the job posting. |

---

## 2. Dimension Table: public.company_dim

### Purpose

This dimension table contains descriptive information about companies that publish job postings.

It provides company-related details and allows job opportunities to be analyzed by employer.

Each company is identified by a unique `company_id`, which is referenced by the `job_postings_fact` table.

### Columns

| Column | Data Type | Description |
|---|---|---|
| `company_id` | INT | Primary key identifying each unique company. |
| `name` | TEXT | Name of the company associated with the job posting. |
| `link` | TEXT | URL linking to the company's website or related company page. |
| `link_google` | TEXT | Google search URL associated with the company. |
| `thumbnail` | TEXT | URL or reference to the company's thumbnail image or logo. |

---

## 3. Dimension Table: public.skills_dim

### Purpose

This dimension table contains descriptive information about technical skills mentioned in job postings.

It provides a centralized list of skills and their classifications, allowing analysis of skill demand and salary relationships.

The table connects to `job_postings_fact` through the `skills_job_dim` bridge table.

### Columns

| Column | Data Type | Description |
|---|---|---|
| `skill_id` | INT | Primary key identifying each unique skill. |
| `skills` | TEXT | Name of the technical skill (e.g. SQL, Python, Excel, Tableau). |
| `type` | TEXT | Category or classification of the skill (e.g. programming language, database, analytical tool). |

---

## 4. Bridge Table: public.skills_job_dim

### Purpose

This bridge table resolves the many-to-many relationship between job postings and technical skills.

A single job posting can require multiple skills, while the same skill can appear in multiple job postings.

The table connects `job_postings_fact` and `skills_dim` through their respective foreign keys.

### Grain

One row represents one unique association between a job posting and a required skill.

The combination of `job_id` and `skill_id` forms a composite primary key, ensuring that the same skill is not associated with the same job posting more than once.

### Columns

| Column | Data Type | Description |
|---|---|---|
| `job_id` | INT | Foreign key referencing `job_postings_fact.job_id`. Part of the composite primary key. |
| `skill_id` | INT | Foreign key referencing `skills_dim.skill_id`. Part of the composite primary key. |

---

## 5. Relationships

The database contains the following relationships:

| Parent Table | Child Table | Relationship | Join Condition |
|---|---|---|---|
| `company_dim` | `job_postings_fact` | One-to-Many (1:N) | `company_id` |
| `job_postings_fact` | `skills_job_dim` | One-to-Many (1:N) | `job_id` |
| `skills_dim` | `skills_job_dim` | One-to-Many (1:N) | `skill_id` |

### Many-to-Many Relationship

A many-to-many (M:N) relationship exists between `job_postings_fact` and `skills_dim`.

This relationship is implemented through the `skills_job_dim` bridge table.

For example, one job posting may require SQL, Python, and Excel, while SQL may be required by thousands of different job postings.

The bridge table stores each job-skill association separately.