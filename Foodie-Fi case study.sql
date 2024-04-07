use foodie_fi;

select * from plans;
select * from subscriptions;

-- 1. How many customers has Foodie-Fi ever had? 
	select count(distinct customer_id) from subscriptions;

--   customer subscription journey  
	select s.customer_id, p.plan_name, s.start_date from subscriptions s join plans p on p.plan_id = s.plan_id;
    
    
-- 2. What is the monthly distribution of trial plan start_date values for our dataset 
-- use the start of the month as the group by value 
	SELECT 
    DATE_FORMAT(start_date, '%Y-%m-01') AS Starting_Month,
    COUNT(plan_id) AS trial_count
FROM
    subscriptions
WHERE
    plan_id = 0
GROUP BY DATE_FORMAT(start_date, '%Y-%m-01')
ORDER BY Starting_Month;

-- 3. What plan start_date values occur after the year 2020 for our dataset? 
-- Show the breakdown by count of events for each plan_name 

SELECT p.plan_id, p.plan_name, COUNT(*) AS event_count
FROM subscriptions s
left join plans p on p.plan_id = s.plan_id
WHERE Year(start_date) > 2020
GROUP BY plan_id
order by plan_id;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place? 
SELECT 
    COUNT(customer_id) Churn_customer,
    ROUND(COUNT(customer_id) / (SELECT 
                    COUNT(distinct customer_id)
                FROM
                    subscriptions) * 100,
            1) AS Churn_Percentage
FROM
    subscriptions
WHERE
    plan_id = 4;
    
-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number? 
SELECT 
    COUNT(distinct customer_id) as Customer_churn,
    ROUND(COUNT(customer_id) / (SELECT 
                    COUNT(distinct customer_id)
                FROM
                    subscriptions) * 100) AS Churn_Percentage_Whole_no
FROM
    subscriptions
WHERE
    plan_id = 4 AND DAY(start_date) <= 8;
    
-- 6. What is the number and percentage of customer plans after their initial free trial?
WITH next_plans AS
(
	SELECT *,
	       LEAD(plan_id, 1) OVER (PARTITION BY customer_id ORDER BY plan_id) AS next_plan
	FROM subscriptions
),
planning AS 
(
    SELECT c.next_plan,
           COUNT(DISTINCT customer_id) AS customer_count,
           round(COUNT(distinct customer_id)/ (SELECT COUNT(distinct customer_id) FROM subscriptions)* 100,1) AS percentage
    FROM next_plans c
	LEFT JOIN plans p 
	ON p.plan_id = c.next_plan
	WHERE c.plan_id = 0 
		AND c.next_plan is not null
	GROUP BY c.next_plan
	)

SELECT p.plan_name, 
	   s.customer_count, 
	   s.percentage
FROM planning s
LEFT JOIN plans p 
ON p.plan_id = s.next_plan;
     
-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
SELECT 
    p.plan_name, COUNT(distinct s.customer_id) AS customer_count,
    ROUND(COUNT(distinct s.customer_id) / (SELECT 
                    COUNT(distinct customer_id)
                FROM
                    subscriptions) * 100,
            1) AS Percentage
FROM
    subscriptions s
	join plans p on p.plan_id = s.plan_id
WHERE
    start_date <= "2020-12-31" 

    group by p.plan_name
	order by customer_count desc;

-- 8. How many customers have upgraded to an annual plan in 2020?
select * from plans;
SELECT 
    COUNT(customer_id) AS Upgraded_customer
FROM
    subscriptions
WHERE
    YEAR(start_date) = '2020'
        AND plan_id = (SELECT 
            plan_id
        FROM
            plans
        WHERE
            plan_name = 'pro annual');
            
-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with annual_plan As (
	select customer_id, start_date as annual_date from subscriptions where plan_id = 3 ) ,
    trial_plan As (
		select customer_id, start_date as trial_date from subscriptions where plan_id = 0)
        select round(avg(datediff(annual_date, trial_date))) as Avg_conversion_days from annual_plan ap join trial_plan tp on ap.customer_id = tp.customer_id;
	
    
-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

WITH START_CTE AS (   
                SELECT customer_id,
                       start_date 
                FROM subscriptions s
                INNER JOIN plans p ON s.plan_id = p.plan_id
                WHERE plan_name = 'trial' ),

ANNUAL_CTE AS ( SELECT customer_id,
                       start_date as start_annual
                FROM subscriptions s
                INNER JOIN plans p ON s.plan_id = p.plan_id
                WHERE plan_name = 'pro annual' ),

DIFF_DAY_CTE AS ( SELECT DATEDIFF(start_annual,start_date) as diff_day
                FROM ANNUAL_CTE C2
                LEFT JOIN START_CTE C1 ON C2.customer_id =C1.customer_id),

GROUP_DAY_CTE AS ( SELECT *, FLOOR(diff_day/30) as group_day
                FROM DIFF_DAY_CTE)

SELECT CONCAT((group_day * 30),'- ',(group_day +1)*30 ) as days,
        COUNT(group_day) as number_days
FROM GROUP_DAY_CTE
GROUP BY group_day;

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
SELECT 
    COUNT(DISTINCT s1.customer_id) AS Downgraded_customer
FROM
    subscriptions s1
        JOIN
    subscriptions s2 ON s1.customer_id = s2.customer_id
        AND s1.plan_id - 1 = s2.plan_id
WHERE
    s2.plan_id = 1
        AND (s2.start_date - s1.start_date) > 0
        AND YEAR(s2.start_date) = '2020';