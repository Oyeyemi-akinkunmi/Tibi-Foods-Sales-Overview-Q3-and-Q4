		-- CHECKING THE DATA TABLE
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


		-- GROWTH INCREASED BY 59.2778%  (1182 0RDERS) INCREASE

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
	
	
	
	-- CHECKING QoQ DIFFERENCE IN PROFIT
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
SUM(Q3.order_total_net) AS QQQ_TOTAL,
SUM(Q4.order_total_net) AS q4_total,
SUM(tot.order_total_net) AS TOTAL,
SUM(q4.order_total_net) -
SUM(q3.order_total_net) AS q4_q3_profit_variance,
COALESCE(
(SUM(Q4.order_total_net)/SUM(Q3.order_total_net) -1) * 100,0) AS percentage_PROFIT_variance
FROM cte_total_profit tot
FULL JOIN cte_qqq q3 ON tot.order_referenceid = q3.order_referenceid
FULL JOIN cte_qqqq q4 ON tot.order_referenceid = q4.order_referenceid;

	 
	 
-- FESTAC
/*
TOTAL ORDERS = 407
Q4 ORDERS = 0
Q3 ORDERS = 407
*/

		-- VI ORDERS
		/*
TOTAL ORDERS = 425
Q4 ORDERS = 0
Q3 ORDERS = 425
*/

SELECT COUNT(order_referenceid)
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - VI';
	
		-- IKEJA
		/*
TOTAL ORDERS = 1776
Q4 ORDERS = 1764
Q3 ORDERS = 12
*/

SELECT COUNT(order_referenceid), order_referenceid
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - Ikeja'
GROUP BY order_referenceid


		-- YABA
		/*
TOTAL ORDERS = 0
Q4 ORDERS = 0
Q3 ORDERS = 0
*/

SELECT order_referenceid
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - Yaba'

	 

		-- LEKKI
		/*
TOTAL ORDERS = 586
Q4 ORDERS = 0
Q3 ORDERS = 586
*/

SELECT COUNT(order_referenceid)
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - Lekki'; n
	
	
	
select * from tibibackup2


			-- IKOYI
			
		/* TOTAL ORDERS = 564
		Q4 ORDERS = 0
		Q3 ORDERS = 564
		*/
		
SELECT COUNT(order_referenceid)
FROM TIBI
WHERE qaurter BETWEEN 'Q3' AND 'Q4'
AND store_name = 'Tibi Foods - Ikoyi'


		--SURULERE
	/*
	TOTAL ORDERS = 1412
	Q4 ORDERS = 1412
	Q3 ORDERS = 0
	*/
	
		-- CHECKING OVERALL QUARTER 0VER QUARTER ORDER AND PROFIT BY LOCATION 
 
SELECT store_name, COUNT(order_referenceid) AS order_per_location, 
SUM(order_total_net) AS Total_Profit, QAURTER AS QUARTER
FROM tibi
WHERE qaurter  BETWEEN 'Q3' AND 'Q4'
GROUP BY store_name,QAURTER
ORDER BY QAURTER;


		-- UPDATE DATE FROM 23 - 2023
UPDATE tibi
SET order_delivered_datetime=
CONCAT('20',order_delivered_datetime)
where order_delivered_datetime is NOT NULL
 

		-- CONVERTING VARCHAR TO DATE/DATETIME TYPE
ALTER TABLE tibi
ALTER COLUMN order_create_date type date
USING TO_DATE(order_create_date,'YYYY/MM/DD')

ALTER TABLE tibi
ALTER COLUMN order_delivered_datetime TYPE TIMESTAMP
USING TO_TIMESTAMP(order_delivered_datetime, 'YYYY/MM/DD HH24:MI')


		-- CREATING A NEW BACKUP TABLE AFTER TIME STAMP	
SELECT * INTO tibi_time_backup
FROM tibi

SELECT
order_create_datetime , order_delivered_datetime ,
order_delivered_datetime - order_create_datetime AS DIFF
FROM tibi
WHERE store_name ='Tibi Foods - Ikeja'
AND qaurter ='Q3';


SELECT
order_create_datetime , order_delivered_datetime , finished_order_status,
order_delivered_datetime - order_create_datetime AS DIFF
FROM tibi
WHERE store_name ='Tibi Foods - Ikeja'
AND qaurter ='Q4'


		-- CHECKING FOR THE METRICS
SELECT
order_create_datetime , order_delivered_datetime , finished_order_status,
order_accepted_datetime - order_create_datetime AS create_accept_diff,
order_accepted_datetime, order_marked_ready_for_pickup,
order_marked_ready_for_pickup - order_accepted_datetime AS accept_ready_diff,
courier_arrive_datetime - order_marked_ready_for_pickup AS ready_courier_arrival,
courier_arrive_datetime, courier_pickup_datetime,
courier_pickup_datetime - courier_arrive_datetime AS arrive_pickup
FROM tibi

WHERE qaurter IN ('Q3', 'Q4')
AND finished_order_status = 'success'
AND order_delivered_datetime IS NOT NULL
AND order_create_datetime IS NOT NULL;
ORDER BY create_accept_diff DESC;

ALTER TABLE tibi
ADD diff_delivery interval;

UPDATE tibi
SET diff_delivery =order_delivered_datetime - order_create_datetime
WHERE qaurter IN ('Q3', 'Q4')
AND order_delivered_datetime IS NOT NULL
AND order_create_datetime IS NOT NULL;


		-- AVERAGE DELIVERY TIME
SELECT
AVG(order_delivered_datetime - order_create_datetime) AS Delivery_time
FROM TIBI
WHERE  
order_delivered_datetime IS NOT NULL
AND order_create_datetime IS NOT NULL
AND finished_order_status ='success'
AND qaurter IN ('Q3', 'Q4')
AND delivery_type = 'delivery';




	-- AVERAGE WAIT TIME
SELECT
AVG(courier_pickup_datetime - courier_arrive_datetime) AS average_wait
FROM TIBI
WHERE  
courier_pickup_datetime IS NOT NULL
AND courier_arrive_datetime IS NOT NULL
AND qaurter IN ('Q3','Q4')
AND delivery_type = 'delivery';


ALTER TABLE tibi
ADD wait_time interval;

UPDATE tibi
SET wait_time =
courier_pickup_datetime - courier_arrive_datetime 
WHERE  
courier_pickup_datetime IS NOT NULL
AND courier_arrive_datetime IS NOT NULL
AND qaurter IN ('Q3', 'Q4') ;


		-- AVERAGE ACCEPTANCE TIME
SELECT
AVG(order_accepted_datetime - order_create_datetime)
FROM TIBI
WHERE  
order_delivered_datetime IS NOT NULL
AND order_create_datetime IS NOT NULL
AND qaurter !='Q2'
AND delivery_type = 'delivery';

ALTER TABLE tibi
ADD acceptance_time interval


UPDATE tibi
SET acceptance_time =
order_accepted_datetime - order_create_datetime
WHERE  
order_delivered_datetime IS NOT NULL
AND order_create_datetime IS NOT NULL
AND qaurter IN ('Q3', 'Q4');


		-- AVERAGE PICKUP TIME
SELECT
AVG(courier_pickup_datetime - order_marked_ready_for_pickup)
FROM TIBI
WHERE  
order_marked_ready_for_pickup IS NOT NULL
AND courier_pickup_datetime IS NOT NULL
AND qaurter !='Q2'
AND delivery_type = 'delivery'
AND finished_order_status ='success'


ALTER TABLE tibi
ADD pickup_time interval


UPDATE tibi
SET pickup_time =
courier_pickup_datetime - order_marked_ready_for_pickup
WHERE  
order_marked_ready_for_pickup IS NOT NULL
AND courier_pickup_datetime IS NOT NULL
AND qaurter IN ('Q3', 'Q4');


SELECT
AVG(CAST(order_delivered_datetime AS TIME))
FROM TIBI
WHERE  
order_marked_ready_for_pickup IS NOT NULL
AND courier_pickup_datetime IS NOT NULL
AND qaurter !='Q2'
AND delivery_type = 'delivery'

AND finished_order_status ='success'

ALTER TABLE tibi
ADD pickup TIME;

UPDATE tibi
set Pickup = 
CAST(Pickup_time AS TIME);