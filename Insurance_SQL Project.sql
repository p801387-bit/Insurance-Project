CREATE DATABASE insurance_data;
 SELECT user();
  SELECT @hostname;
  SELECT user, host FROM mysql.user;
  use insurance_data; 
  ----   KPI1
Select 'Account Executive', count(distinct policy_number) as Number_of_invoices from invoice
group by 'Account Executive' order by Number_of_invoices;

----    KPI2
SELECT `Account Exe ID`, COUNT(meeting_date) AS Count_of_meetings
FROM meeting
GROUP BY `Account Exe ID`
ORDER BY Count_of_meetings DESC;

----   KPI3
SELECT 
    ib.`Employee Name`,
    ib.`Cross sell bugdet` AS cross_sell_target,
    COALESCE(bf.cross_sell_achieve, 0) AS cross_sell_achieve,
    COALESCE(inv.cross_sell_new, 0) AS cross_sell_new,

    ib.`New Budget` AS new_target,
    COALESCE(bf.new_achieve, 0) AS new_achieve,
    COALESCE(inv.new_new, 0) AS new_new,

    ib.`Renewal Budget` AS renewal_target,
    COALESCE(bf.renewal_achieve, 0) AS renewal_achieve,
    COALESCE(inv.renewal_new, 0) AS renewal_new
FROM `individual_budgets` ib
-- Brokerage + Fees combined (achieve)
LEFT JOIN (
    SELECT  
        `Account Exe ID`,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'CROSS SELL' THEN amount ELSE 0 END) AS cross_sell_achieve,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'NEW' THEN amount ELSE 0 END) AS new_achieve,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'RENEWAL' THEN amount ELSE 0 END) AS renewal_achieve
    FROM (
        SELECT `Account Exe ID`, income_class, amount FROM `brokerage`
        UNION ALL
        SELECT `Account Exe ID`, income_class, amount FROM `fees`
    ) bf
    GROUP BY `Account Exe ID`
) bf
ON ib.`Account Exe ID` = bf.`Account Exe ID`
-- Invoice (new)
LEFT JOIN (
    SELECT  
        `Account Exe ID`,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'CROSS SELL' THEN amount ELSE 0 END) AS cross_sell_new,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'NEW' THEN amount ELSE 0 END) AS new_new,
        SUM(CASE WHEN TRIM(UPPER(income_class)) = 'RENEWAL' THEN amount ELSE 0 END) AS renewal_new
    FROM `invoice`
    GROUP BY `Account Exe ID`
) inv
ON ib.`Account Exe ID` = inv.`Account Exe ID`;

-- KPI 4
Select stage, sum(revenue_amount) as total_revenue
from opportunity group by stage order by total_revenue desc;

-- KPI 5
Select `Account Executive`, count(*) as Number_of_meetings
from meeting group by `Account Executive` order by Number_of_meetings desc;

-- KPI 6
Select stage, revenue_amount from opportunity order by revenue_amount desc limit 10;

    


