# Tibi Foods Sales Overview Q3 and Q4

### Table of Contents
- [Project Overview](#project-overview)  
- [Project objectives](#project-objectives)
- [Data Source](#data-source)  
- [Tools](#tools)  
- [Approach](#approach)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Results and Recommendations](#results-and-recommendations)
- [Report Page](#report-page)
- [Data Analysis](#data-analysis)
  
 ### Project Overview
Tibi Foods (fictional business) is a large quick service restaurant chain store in Nigeria and is available on Chowdeck, where online customers can order a range of mouth-watering meals.
Based on available data, Tibi Foods stakeholders wants a monthly business review for Tibi Foods for Q3 and Q4 2023. 

### Project Objectives
This project aims to:
- Give an overview of Tibi Foods' current business
- Measure the performance of Tibi Food’s business in Q4 2023 relative to Q3 2023.
- Provide recommendations to help Tibi Foods improve their services and grow revenue based on insights from the analysis.
 
### Data Source
The dataset, sourced from Tibi Foods’ data on Chowdeck. Chowdeck is an online platform that allows users to place order for home food delivery from registered restaurants. The csv dataset provided has details as: order_referenceid, store_name, order_accept datetime, order create datetime, order_status, courier_arrival_time.

### TOOLS
- Structured Query Language (SQL): for exploratory data analysis
-	PowerBI: for data visualization and reporting

### Approach
-	Data cleaning: leveraged SQL functionalities to perform data cleaning tasks as handling missing values, column splits, standardizing data types and formats, removing unwanted columns.
-	Data Exploration: utilized SQL queries to probe the wrangled dataset, to explore various metrics such as order count, count of successful deliveries, pickup time, wait time, delivery time, rejected delivery, revenue etc.
-	Data visualization: crafted visually appealing, clear, and friendly and interactive visualization using appropriate charts in Power BI to communicate insights from the analysis effectively to stakeholders.

### Exploratory Data Analysis 
-	Leveraged SQL queries to explore the business operations of Tibi Foods by store name. There were seven stores that formed Tibi Foods operations.
-	Analyzed order acceptance time, order creation time, courier arrival time, order ready time, courier pickup time and order delivery time, to measure the cumulative effects of the on numbers of successful orders or rejected orders.

### Results and Recommendations
- In Q3, six of Tibi Foods stores had orders and deliveries, excluding Surulere.
- In Q4, only two stores - Ikeja and Surulere - out of the seven region had orders. The two stores making total order growth of 41.12%. It was observed that the other five stored did not have any order at all. This calls for intensive targeted marketing campaigns to boost revenue. Customer satisfaction can be improved upon along with given incentives or discounts on orders.
- There was 28.85% growth in revenue from Q3 to Q4. Growth would have been higher if revenue was spread across the stores, only two of Tibi stores the 28.85% revenue growth.
- Revenue dropped lowest in October and peaked in December.
- There is a positive correlation between the delivery time and order rejection. Longer delivery time led to increased order rejection. However, it was observed that the wait time (time it takes between when the courier arrives and when the courier picks up an item) and the pickup time (time it takes between when the order is marked ready for pick-up and when the courier picks up). This implies that there is a necessity for increased efficiency in order acceptance and making order ready; thus, reducing wait time and pickup time. 

 ### Report page
![tibi](https://github.com/user-attachments/assets/5202b0d6-993a-414a-8db1-95b47d6e6d49)

### Data Analysis
``` sql
-- CHECKING THE DATA TABLE interrogate
SELECT * FROM tibi;
		
		-- CHECKING FOR THE VARIOUS OUTLETS
SELECT DISTINCT store_name
FROM tibi;
		--CREATING BACKUP FOR THE TABLE
SELECT * INTO tibibackup
FROM tibi;
		-- CHECKING THE BACKUP TABLE
SELECT * FROM tibibackup;
		-- ADD QUATER COLUMN 
ALTER TABLE tibi
ADD qaurter VARCHAR; 

UPDATE tibi
SET qaurter =
 CASE 
 	WHEN order_create_date BETWEEN '23/10/01' AND '23/12/31' THEN 'Q4'
	WHEN order_create_date BETWEEN '23/07/01' AND '23/09/30' THEN 'Q3'
	ELSE 'Q2'
	END;
		--THIRD QUARTER =1994
SELECT count(order_referenceid)
AS THIRD_QUATER_TOTAL_ORDERS
FROM tibi
WHERE qaurter = 'Q3';
		-- FOURTH QUARTER = 3176 
SELECT COUNT(DISTINCT order_referenceid)
AS FOURTH_QUARTER_TOTAL_ORDERS
FROM tibi
WHERE QAURTER ='Q4'

		-- JUNE ORDER (645 IN TOTAL)
SELECT COUNT(DISTINCT order_referenceid)
FROM tibi
WHERE qaurter ='Q2';

		--3RD AND FOURTH QUARTER
SELECT order_create_date, order_accepted_datetime, order_marked_ready_for_pickup
FROM tibi
WHERE qaurter  BETWEEN 'Q3' AND 'Q4';

WITH CTE_TIBI AS(
SELECT *
FROM TIBI
WHERE qaurter  BETWEEN 'Q3' AND 'Q4'
),

CTE_Q3 AS(
SELECT *
FROM tibi
WHERE qaurter ='Q3'
),
CTE_Q4 AS (
SELECT *
FROM tibi
WHERE qaurter ='Q4'
)

SELECT
COUNT(qqq.order_referenceid) AS Q3_total_order,
COUNT(qqqq.order_referenceid) AS q4_total_order,
COUNT(qqqq.order_referenceid) -
COUNT(qqq.order_referenceid) AS order_variance,
COALESCE(100.00 *  COUNT(qqqq.order_referenceid)/
nullif(COUNT(qqq.order_referenceid),0)-100, 0) AS percentage_variance
FROM tibi as tib
FULL JOIN cte_q3 AS qqq ON TIB.order_referenceid = qqq.order_referenceid
FULL JOIN cte_q4 AS qqqq on tib.order_referenceid = qqqq.order_referenceid;
	
WITH cte_total_profit AS(
SELECT *
FROM tibi
WHERE qaurter  BETWEEN 'Q3' AND 'Q4'
),
cte_qqq AS(
SELECT *
FROM tibi
WHERE qaurter ='Q3'
), 
cte_qqqq AS(
SELECT *
FROM tibi
WHERE qaurter = 'Q4'
)
SELECT
SUM(Q3.order_total_net) AS QQQ_TOTAL, SUM(Q4.order_total_net) AS q4_total,
SUM(tot.order_total_net) AS TOTAL, SUM(q4.order_total_net), SUM(q3.order_total_net) AS q4_q3_profit_variance, COALESCE( (SUM(Q4.order_total_net)/SUM(Q3.order_total_net) -1) * 100,0) AS percentage_PROFIT_variance  FROM cte_total_profit tot FULL JOIN cte_qqq q3 ON tot.order_referenceid = q3.order_referenceid FULL JOIN cte_qqqq q4 ON tot.order_referenceid = q4.order_referenceid;	 	 

SELECT COUNT(order_referenceid)
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - VI'; 
SELECT COUNT(order_referenceid), order_referenceid
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - Ikeja'
GROUP BY order_referenceid

SELECT store_name, COUNT(order_referenceid) AS order_per_location, 
SUM(order_total_net) AS Total_Profit, QAURTER AS QUARTER
FROM tibi
WHERE qaurter  BETWEEN 'Q3' AND 'Q4'
GROUP BY store_name,QAURTER ORDER BY QAURTER;
		
UPDATE tibi
SET order_delivered_datetime=
CONCAT('20',order_delivered_datetime)
where order_delivered_datetime is NOT NULL
		
ALTER TABLE tibi
ALTER COLUMN order_create_date type date
USING TO_DATE(order_create_date,'YYYY/MM/DD')

ALTER TABLE tibi
ALTER COLUMN order_delivered_datetime TYPE TIMESTAMP
USING TO_TIMESTAMP(order_delivered_datetime, 'YYYY/MM/DD HH24:MI')

SELECT * INTO tibi_time_backup
FROM tibi

SELECT
order_create_datetime , order_delivered_datetime , order_delivered_datetime - order_create_datetime AS DIFF
FROM tibi
WHERE store_name ='Tibi Foods - Ikeja' AND qaurter ='Q3';
SELECT
order_create_datetime , order_delivered_datetime , finished_order_status,
order_delivered_datetime - order_create_datetime AS DIFF
FROM tibi
WHERE store_name ='Tibi Foods - Ikeja' AND qaurter ='Q4'
```





