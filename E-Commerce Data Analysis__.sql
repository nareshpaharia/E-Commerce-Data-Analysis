SELECT * FROM e_commerce.list_of_orders;      /*   Order ID/ Order Date/ CustomerName/State/City/Age          */
SELECT * FROM e_commerce.order_details;       /*    Order ID/ Amount/Profit/ Quantity/Category/Sub-Category   */
SELECT * FROM e_commerce.rfm;                 /*    Row Lables/ Min OF Recency /sum of profit                 */
SELECT * FROM e_commerce.sales_target;        /*    Month of order date/Catagory/Taget                        */

/* 1. STATISTICS REGARDING DATASET - Total Number of orders */
-- ------------------------------------------------
SELECT count(*) FROM e_commerce.list_of_orders;

/* Total Quantity of products sold  */
-- ------------------------------------------------
SELECT 
    COUNT(Quantity) AS TOTAL_QUANTITY
FROM
    e_commerce.order_details; 

/* Total profit made by the store  */
-- -------------------------------------------
SELECT SUM(Profit) AS total_profit 
FROM e_commerce.order_details;

/* No of customers  */
 -- --------------------------------------------------
SELECT count(DISTINCT CustomerName) AS no_of_customer 
FROM e_commerce.list_of_orders;

/* Average price of products in the store  */
-- ------------------------------------------------------
SELECT AVG(Amount) AS avg_price 
FROM e_commerce.order_details;

/* Least and the most expensive products in the store  */
-- ------------------------------------------------------------
SELECT * FROM e_commerce.order_details;

SELECT 'least expensive product', MIN(Amount) AS price 
FROM order_details
UNION ALL 
SELECT 'most expensive product', MAX(Amount) AS Price 
FROM order_details ;

SELECT 'Least Expesnive Product',min(Amount) AS price
FROM  e_commerce.order_details
UNION ALL 
SELECT 'Most Expesive Product',max(Amount) AS price
FROM e_commerce.order_details;

/* 2. ANALYTICAL QUESTIONS -  status of the order   */
-- -------------------------------------------------
SELECT *,
CASE WHEN Profit >0 THEN 'profit'
     WHEN Profit<0 THEN 'Loss'
     ELSE 'NON' END AS STATUS
     
     FROM e_commerce.order_details;
     

/* No of orders resulting in profit vs no of orders resulting in loss  */
-- -----------------------------------------------------------------------
WITH cte_Status AS
(SELECT *,
CASE WHEN Profit >0 THEN 'profit'
     WHEN Profit <0 THEN 'loss'
     ELSE 'non' END AS Status
FROM e_commerce.order_details)

SELECT Status ,count(*) AS counts
FROM cte_Status 
GROUP BY Status
ORDER BY counts  DESC ;

/* Find out total Cost for each order ID */
-- ----------------------------------------------------
WITH cte_cp AS 
(SELECT `Order ID` AS order_id,Amount*Quantity AS cost_price
FROM e_commerce.order_details)

SELECT order_id,sum(cost_price) AS total_cost_price
FROM cte_cp
GROUP BY order_id;


/* Find out total Cost for each order ID */
 -- ------------------------------------------------------
WITH cte_cp AS 
(SELECT `Order ID` AS order_id,Amount*Quantity AS cost_price
FROM e_commerce.order_details)

SELECT order_id,sum(cost_price) AS total_cost_price
FROM cte_cp 
GROUP BY order_id 
ORDER BY total_cost_price DESC ;


/*Total orders by different categories */
-- ---------------------------------------------
SELECT Category ,count(*)  AS total_order
FROM e_commerce.order_details
GROUP BY Category;


/*Total orders by different subcategories */
-- --------------------------------------------------------
SELECT Category,`Sub-Category` AS Sub_Catagory ,COUNT(*) AS total_order
FROM e_commerce.order_details
GROUP BY Category,Sub_Catagory 
ORDER BY total_order DESC;


/*Sales Targets for each category */
-- ---------------------------------------------------
SELECT Category, SUM(Target) AS TagetSale
FROM e_commerce.sales_target
GROUP BY Category
ORDER BY TagetSale DESC ;

/*TOP Profitable category*/
-- -----------------------------------------
SELECT Category, SUM(Profit) AS totalProfit
FROM e_commerce.order_details
GROUP BY Category
ORDER BY totalProfit DESC  ;

/*TOP 3 Profitable Sub-Categories for each category */
-- ---------------------------------------------------
WITH cte_Product AS
(SELECT Category ,`Sub-Category` AS Sub_Category,SUM(Profit) AS Profit ,
DENSE_RANK() OVER(PARTITION BY Category ORDER BY SUM(Profit) DESC ) AS rnk
FROM e_commerce.order_details
GROUP BY Category,Sub_Category) 

SELECT Category,Sub_Category,Profit 
FROM cte_Product
WHERE rnk<=3;


/*Top 5 profitable cities */
-- ---------------------------
SELECT o.City,SUM(od.Profit) AS Profit 
FROM e_commerce.list_of_orders AS o JOIN e_commerce.order_details AS od ON o.`Order ID`=od.`Order ID`
GROUP BY o.City
ORDER BY  Profit DESC 
LIMIT 5;


/*Total Quantity sold per state */
-- --------------------------------------
SELECT o.State,sum(od.Quantity) AS total_qty_sold
FROM e_commerce.list_of_orders AS o JOIN e_commerce.order_details AS od ON o.`Order ID`=od.`Order ID`
GROUP BY o.State
ORDER BY total_qty_sold DESC;


/*No of customers state-wise */
-- -----------------------------------------------
SELECT State ,COUNT(`Order ID`) AS COUNT_customers
FROM e_commerce.list_of_orders
GROUP BY State
ORDER BY State ;

/* Total Revenue Generated by the store*/ 
-- -------------------------------------------------------------------
WITH cte_SP AS 
(SELECT `Order ID` AS order_id,Category, (Amount * Quantity) + profit AS SellPrice
FROM order_details) 

SELECT SUM(SellPrice) AS Total_Revenue 
FROM cte_SP ;


/*Total Revenue per category */
-- ------------------------------------------
WITH cte_sp AS 
(SELECT `Order ID` AS order_id, Category, Amount*Quantity+profit AS sell_price
FROM  e_commerce.order_details)

SELECT Category, sum(sell_price) AS Total_Revnue
FROM cte_sp
GROUP BY Category;

/*Customer Age Group segmentation by count orders */
-- ----------------------------------------------------
WITH CTE_AgeGroup AS 
(SELECT *, 
CASE WHEN Age BETWEEN 15 AND 20 THEN 'Age Group 15-20'
     WHEN Age BETWEEN 21 and 30 THEN 'Age Group 21-30'
     WHEN Age BETWEEN 31 AND 40 THEN 'Age Group 31-40'
     ELSE 'Age group 41-50' END AS Age_Bracket
     FROM e_commerce.list_of_orders)
     
SELECT c.Age_Bracket,COUNT(od.`Order ID`) AS count_orders
FROM CTE_AgeGroup AS c 
JOIN e_commerce.order_details AS od ON c.`Order ID`=od.`Order ID`
GROUP BY c.Age_Bracket;

-- ----------------------------**END**------------------------------------------------------------
-- ----------------------------*******------------------------------------------------------------





