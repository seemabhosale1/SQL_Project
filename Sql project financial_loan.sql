create database sqlproj2;

use sqlproj2;

select * from bank_data;

select distinct purpose from bank_data;

-- Total Loan Applications
select count(id) as total_loan_applications from bank_data;

-- Total Loan Amount
select sum(loan_amount)/1000000 as total_funded_amount from bank_data;

-- Total Payment Recd
select sum(total_payment)/1000000 as total_payment_recd from bank_data;

-- Average DTI on monthly basis
select year(issue_date) as 'year',
month(issue_date) as 'month',
round(avg(dti), 2) * 100 as 'Average_monthly_dti'
from bank_data
where year(issue_date) = 2021
group by year(issue_date), month(issue_date)
order by month;

select distinct loan_status from bank_data;
-- Good Loan vs Bad Loan
-- Good Loan applications in %
select count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id end) * 100 / count(id) as 'good_loan_application (%)' from bank_data;
select count(case when loan_status in ('Fully Paid', 'Current') then id end) * 100 / count(id) as 'good_loan_application (%)' from bank_data;

-- Good Loan application
select count(case when loan_status in ('Fully Paid', 'Current') then id end) as 'good_loan_application' from bank_data;

-- Total amnt recd in good loan applications
select sum(total_payment) / 1000000  as 'Total_payment_recd' from bank_data where loan_status in ('Fully Paid', 'Current');

-- Month over month total payment recd
with monthlytotals as (
select year(issue_date) as 'Year',
month(issue_date) as 'Month',
sum(total_payment) as 'monthly_total_payment_recd'
from bank_data
where year(issue_date) = 2021
group by year(issue_date), month(issue_date)
),
monthovermonth as (
select T1.year,
T1.month,
T1.monthly_total_payment_recd as 'current_month_payment',
T2.monthly_total_payment_recd as 'previous_month_payment',
T1.monthly_total_payment_recd - T2.monthly_total_payment_recd as 'month_over_month_amnt'
from monthlytotals T1
left join
monthlytotals T2 on T1.year = T2.year and T1.month = T2.month +1
)
select
year,
month,
month_over_month_amnt
from monthovermonth
order by month;