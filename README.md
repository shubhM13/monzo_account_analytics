# monzo_account_analytics

- Task 1 -  https://github.com/shubhM13/monzo_account_analytics/blob/main/dbt_models/models/mart/dim_account.sql
- Task 2 - https://github.com/shubhM13/monzo_account_analytics/blob/main/dbt_models/models/mart/mt_rolling_7day_active_users.sql
- DBT Github - https://github.com/shubhM13/monzo_account_analytics
- Colab Notebooks Github - https://github.com/shubhM13/monzo_account_analytics/tree/main/colab_notebooks
- Weekly Cohort Retention Analytics  - [here](https://colab.research.google.com/drive/1m5082ef3xuOyh8z10P6mb2lbiK6RjjuV?usp=sharing)
- Monthly Cohort Retention Analytics - [here](https://colab.research.google.com/drive/1qgxJlEUPRwT8UTez0v23ZG1C2ZhLiPFQ?usp=sharing)
- 7d_rolling_active_users Analytics - [here](https://colab.research.google.com/drive/1fEZkPt_DtNM0S5Nqh6HZ_yLTrTrdXVta?usp=sharing)
- Basic Account Analysis - [here](https://colab.research.google.com/drive/1TGvvpbdfDVFCHEcuzSa8VXJbmiJSh5wh?usp=sharing)

# Tasks

### Provided Data

Big-query Project: `analytics-take-home-test`
Dataset: `monzo_datawarehouse`

Data from a Banking SaaS application includes:
1. account_created
2. account_closed
3. account_reopened
4. account_transactions

### Task 1: Account Modelling

Develop a reliable data model representing different Monzo accounts. Ensure accuracy, completeness, usability, and documentation. Implement tests to validate data integrity.

### Task 2: 7-day Active Users

Calculate the 7d_active_users metric: users with transactions over the past 7 days divided by users with at least one open account.

Requirements:
- Intuitive and flexible data model
- Exclude users with only closed accounts
- Calculate the metric for any date
- Ensure historical consistency

# Solution

Implemented in [DBT](https://www.getdbt.com/) on BigQuery with advanced analytics in Google Colab.

 ##Architecture

The solution uses a Medallion architecture:
- **Bronze (Raw)**: Raw transactional tables.
- **Silver (Clean)**: Cleaned and deduplicated data.
- **Gold (Mart)**: Aggregated facts and dimensions.

<img width="970" alt="image" src="https://github.com/shubhM13/monzo_account_analytics/assets/43113962/ec3a4215-6003-4739-9604-5eab3dc12d95">


## Data Modelling Approach

The approach follows Ralph Kimball’s dimensional modelling with fact and dimension tables for efficient querying and reporting.

**Fact Tables**
- `fact_active_user_transactions`
- `mt_daily_active_users`
- `mt_daily_cum_active_accounts`
- `mt_rolling_7day_active_users`

**Dimension Tables**
- `dim_account`
- `dim_date`
- `dim_users`

### Data Models

**Raw Data (Bronze)**
- `account_created`
- `account_closed`
- `account_reopened`
- `account_transactions`

**Clean Data (Silver)**
- `account_created.sql`
- `account_closed.sql`
- `account_reopened.sql`
- `account_transactions.sql`

**Marts (Gold)**
- `dim_account.sql`
- `dim_date.sql`
- `dim_users.sql`
- `fact_valid_user_transactions.sql`
- `mt_daily_active_users.sql`
- `mt_daily_cum_active_accounts.sql`
- `mt_rolling_7day_active_users.sql`

**Cohorts**
- `cohort_retention_monthly.sql`
- `cohort_retention_weekly.sql`
- `user_activity.sql`
- `user_first_action.sql`

### Data Quality Tests

Implemented in `schema.yml` for uniqueness, completeness, accepted values, integrity, consistency, and range/format.


## 7-Day Rolling Active Users

Analyzed user activity by day and month to identify engagement patterns and inform strategic decisions. Seasonality analysis helps understand high/low activity periods.

### Seasonality Analysis

Identify trends and patterns using 7d_rolling_active_users metric. Box plots show distribution of user activity by day and month.


## Cohort & Retention Analysis

Cohort analysis helps understand user behavior over time, focusing on retention, activation, and activity. It informs strategies for improving customer engagement and retention.

### Retention Log Curves

Visualize retention trends over time using log scales for a nuanced view of user engagement.

### Retention Matrix

Heatmap visualizes retention percentages for each cohort and period, guiding strategic decisions to enhance user engagement.


More detailed analysis:
- [Weekly Cohort Retention](https://colab.research.google.com/drive/1m5082ef3xuOyh8z10P6mb2lbiK6RjjuV?usp=sharing)
- [Monthly Cohort Retention](https://colab.research.google.com/drive/1qgxJlEUPRwT8UTez0v23ZG1C2ZhLiPFQ?usp=sharing)
