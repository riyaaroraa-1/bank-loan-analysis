Create database BankLoanDB;
use  BankLoanDB;

select * from loan_data;

-- =============================
-- Key Performance Indicators (KPIs)
-- =============================

-- 1. Total Loan Applications

select count(*) as total_loan_applications
from loan_data;

-- 1.1 MTD Total loan application (Month to date)

select month(issue_date) as month , count(*) as MTD_total_loan_applications
from loan_data
group by month
order by month asc;

-- 1.2 MoM total loan applications

select Month(issue_date) as Month, 
LAG(Count(id)) OVER (order by Month(issue_date)) as Prev_month,
Count(id) as Total_Loan_Applications,
Count(id) - LAG(count(id)) OVER (order by Month(issue_date)) 
as MoM_difference
from loan_data
group by Month
order by Month;

-- 2 Total Funded amount

select sum(loan_amount) as total_funded_amt
from loan_data;

-- 2.1 MTD total funded amount

select month(issue_date) as month, sum(loan_amount) as MTD_total_funded_amt 
from loan_data
group by month
order by month asc;

-- 2.2 MoM total funded amt

select Month(issue_date) as Month, 
LAG(SUM(loan_amount)) OVER (order by Month(issue_date)) as Prev_month,
SUM(loan_amount) as Total_Funded_amt,
SUM(loan_amount) - LAG(SUM(loan_amount)) OVER (order by Month(issue_date)) 
as MoM_difference
from loan_data
group by Month
order by Month;

-- 3. Total Amount Recieved

select * from loan_data;

select Sum(total_payment) as total_amount_received
from loan_data;

-- 3.1 MTD total amount received

select month(issue_date) as month, Sum(total_payment) as total_amount_received
from loan_data
group by month
order by month;

-- 3.2 MOM of total amount received

select month(issue_date) as Month,
LAG(Sum(total_payment)) Over (order by month(issue_date)) as Prev_month,
Sum(total_payment) as Total_Amount_Received,
Sum(total_payment) - LAG(Sum(total_payment)) Over(order by month(issue_date))
as MoM_difference
from loan_data
group by Month
order by Month;

-- 4. Avg Interest Rate

select concat(round(AVG(int_rate)*100,2),' %') as Avg_int_rate
from loan_data;

-- 4.1  MTD Avg interest rate

select month(issue_date) as month,
 concat(round(AVG(int_rate)*100,2),' %') as Avg_int_rate
from loan_data
group by month
order by month;

-- 4.2 MOM Avg interest rate

select month(issue_date) as month,
LAG(round(AVG(int_rate)*100,2)) over (order by month(issue_date)) as Avg_prev_month,
round(AVG(int_rate)*100,2) as Avg_int_rate,
round(AVG(int_rate)*100 - LAG(AVG(int_rate)*100)over (order by month(issue_date)),2)
as mom_difference
from loan_data
group by month
order by month; 

-- 5. Average Debt to Income Ratio(DTI)

select round(Avg(dti)*100,2) as Avg_DTI
from loan_data;

-- 5.1 MTD Debt to Income Ratio

select month(issue_date) as month,
 round(Avg(dti)*100,2) as Avg_DTI
from loan_data
group by month
order by month;

-- 5.2 MoM Debt to Income Ratio

select month(issue_date) as Month,
LAG(round(AVG(dti)*100,2)) over (order by month(issue_date)) as Avg_DTI_prev_month,
round(AVG(dti)*100,2) as Avg_DTI,
round(AVG(dti)*100 - LAG(AVG(dti)*100)over (order by month(issue_date)),2)
as MoM_difference
from loan_data
group by Month
order by Month; 


-- 6 Good Loan

-- 6.1 Good Loan Percentage

select count(case when loan_status = 'Fully Paid' Or loan_status = 'Current' then id
END) *100/ count(id) as Good_Loan_Percentage
from loan_data;

-- 6.2  Good Loan Applications

select count(*) as Good_Loan_Applications
from loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current';

-- 6.3 Good Loan Funding Amt

select Sum( loan_amount) as Good_Loan_Funding_Amt
from loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current';

-- 6.4

select Sum(total_payment) as Good_Loan_Amt_Received
from loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current';


-- 7 Bad Loan

-- 7.1 Bad Loan Percentage

select count(case when loan_status = 'Charged Off' then id
END) * 100 / count(id) as Bad_Loan_Percentage
from loan_data;

-- 7.2 Bad Loan Total Applications

select count(*) as  Bad_Loan_Applications
from loan_data
where loan_status = 'Charged Off';

-- 7.3 Bad Loan Funding Amount

select Sum(loan_amount) as Bad_Loan_Funding_Amt
from loan_data
where loan_status = 'Charged Off';


-- 7.4 Bad Loan Amt Received
select Sum(total_payment) as Bad_Loan_Amt_Received
from loan_data
where loan_status = 'Charged Off';

-- 8. Loan Status

select loan_status, count(*) as LoanCount,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received,
round(Avg(int_rate)*100,2) as Avg_Interest_Rate,
round(Avg(dti)*100,2) as Avg_DTI
from loan_data
group by loan_status;


select loan_status,
SUM(loan_amount) as MTD_Total_Funded_Amt,
Sum(total_payment) as MTD_Total_Amt_Received
from loan_data
where month(issue_date) = 12
group by loan_status;


-- Bank Loan Report

select * from loan_data;

select month(issue_date) as month_num,
monthname(issue_date) as month_name,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by month_num,month_name
order by month_num;

-- STATE

select address_state as State,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by State
order by State;


--- TERM

select term as Term,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by Term
order by Term;

-- Employee Length

select emp_length as Emp_length,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by Emp_length
order by Emp_length;

-- Purpose

select purpose as Purpose,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by Purpose
order by Purpose;

-- Home ownership

select home_ownership as Home_Ownership,
count(*) as Total_Loan_Applications,
SUM(loan_amount) as Total_Funded_Amt,
Sum(total_payment) as Total_Amt_Received
from loan_data
group by Home_Ownership
order by Home_Ownership;

-- =============================
-- Business Insights Queries
-- =============================

-- 1. Which loan grade/subgrade is more risky?

select grade,count(case when loan_status = 'Charged Off' then id
END) * 100.0 / count(id) as Default_Rate
from loan_data
group by grade
order by Default_Rate desc;

-- Insights
-- Sub- grades F5 and G- series demonstrate critically high default rates, reaching nearly 46%. This suggests that these segments 
-- are highly risky, and financial institution should consider tightning approval criteria,increasing risk-based,or limiting 
-- exposure to these borrowers.

-- 2. How does profitability vary across different loan grades relative to their risk levels?

select grade, 
sum(total_payment) as Total_revenue,
sum(loan_amount) as Total_funded,
sum(total_payment) - sum(loan_amount) as Profit
from loan_data
group by grade
order by Profit desc;

-- Insights
-- Mid - grade loans(B,C AND D) generate the highets profits with relatively lower default risk,making 
-- them balanced and desirable segments for lending.
-- Lower-grade loans (F and G) should high f=default rates with low profitability, suggesting these 
-- segments are high-risk and low -return.

-- 3. Do loans with higher int_rate have higher default rates?

SELECT 
CASE 
    WHEN int_rate < 0.10 THEN 'Low Interest (<10%)'
    WHEN int_rate BETWEEN 0.10 AND 0.15 THEN 'Medium Interest (10-15%)'
    ELSE 'High Interest (>15%)'
END AS interest_bucket,
COUNT(*) AS total_loans,
COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*) AS default_rate
FROM loan_data
GROUP BY 
CASE 
    WHEN int_rate < 0.10 THEN 'Low Interest (<10%)'
    WHEN int_rate BETWEEN 0.10 AND 0.15 THEN 'Medium Interest (10-15%)'
    ELSE 'High Interest (>15%)'
END
ORDER BY default_rate DESC;

-- Insights
-- Loans with higher interest rates(>15%) exhibit significantly higher default rates(~24%) compared to 
-- medium(~14%) and low (~6%) interest loans,indicating a strong positive relationship between interest rate and credit risk.

-- 4. Which loan purpose is most risky?

select purpose,
count(case when loan_status = 'Charged Off' Then 1 END) * 100.0 /Count(*) as default_rate
from loan_data
group by purpose
order by default_rate desc;

-- Insights
-- Loans taken for small business purpose have the highest default rate(~25.6%),
-- followed by renewable_enrgy at (~18 %), indicating these borrowers carry significantly 
-- higher financial risk compared to other loan purposes.

-- 5. Which income group takes higher loan amounts?

select * from loan_data;

select case
when annual_income < 50000 Then 'Low Income'
when annual_income < 100000 then 'Medium Income'
else 'High Income'
END as income_group,
sum(loan_amount) as total_loan_amt,
AVG(loan_amount) AS avg_loan_amount
from loan_data
group by case
when annual_income < 50000 Then 'Low Income'
when annual_income < 100000 then 'Medium Income'
else 'High Income'
END
order by avg_loan_amount desc;

-- Insights
-- High income borrowers(more than 100000) take significantly larger loans on average compared to medium-low
-- income groups indicating higher borrowing capacity and financial stability.

-- 6. Loan Amount by home ownership
SELECT 
home_ownership,
COUNT(*) AS total_loans,
AVG(loan_amount) AS avg_loan_amount
FROM loan_data
GROUP BY home_ownership
ORDER BY avg_loan_amount DESC;

-- Insights
-- Borrowers with mortgages tend to take the highest loan amounts on average,indicating  
-- higher creditworthiness and repayment capacity compared to renters and other ownership groups.

-- 7. Loan Amount by emp_length
SELECT 
emp_length,
COUNT(*) AS total_loans,
AVG(loan_amount) AS avg_loan_amount
FROM loan_data
GROUP BY emp_length
ORDER BY avg_loan_amount DESC;

-- Insights
-- Borrowers with longer employment history tend to take larger loans,with those having 10+ years
-- of experience showing the highest average loan amounts.

-- 8. Loan Amount by purpose
SELECT 
purpose,
COUNT(*) AS total_loans,
AVG(loan_amount) AS avg_loan_amount
FROM loan_data
GROUP BY purpose
ORDER BY avg_loan_amount DESC;

-- Insights
-- Loan taken for small business and housing purposes have the highest average loan amounts, indicating higher
-- capital requirements compared to other loan categories.

-- 9.  How much money is recovered from bad loans?
SELECT 
SUM(total_payment) / SUM(loan_amount) * 100 AS recovery_rate
FROM loan_data
WHERE loan_status = 'Charged Off';
-- Insights
-- 56.89%  money is recovered from bad loans

--10.  Does verification status matter?

select verification_status, count(*) as total_loans,
count(case when loan_status = 'Charged Off' Then 1 END) * 100.0 /Count(*) as default_rate
from loan_data
group by verification_status
order by default_rate desc;

-- Insights
-- The analysis indicates that verification status alone does not reduce default risk.
-- Instead, it appears that riskier borrowers are more likely to undergo verification,
-- which explains the higher default rates observed in verified segments.


