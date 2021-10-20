/*Task 1: In the orderdetails table at the car retailer database, please count the number of different prices that each product (productCode) have, 
and return the productCode of only those who have been sold in more than 5 different prices.
*/
SELECT productCode,  COUNT(distinct(priceEach)) as freq FROM orderdetails
GROUP BY productCode
HAVING freq >5;

/*Task 2: 
-	Please count how many empty values there are in the column of Sub_product at the cfpb_complaints_2500.
-	Replace these empty values with NULL
-	Drop the records that have NULL values in sub_product from table.
*/
SELECT * FROM cfpb_complaints_2500 
WHERE Sub_product ='';

UPDATE cfpb_complaints_2500
SET Sub_product = NULL
WHERE Sub_product ='';

DELETE FROM cfpb_complaints_2500 
WHERE Sub_product IS NULL;

DROP TABLE cfpb_complaints_2500
/*
Which company received the largest amount of complaints from consumers on Wednesday? 
Assume the Data_received is the date that company received complaints*/

SELECT company, COUNT(*) AS freq FROM cfpb_complaints_2500
WHERE DAYOFWEEK(Data_received) = 4
GROUP BY company 
order BY freq DESC 

SELECT company, COUNT(*) AS freq FROM cfpb_complaints_2500
WHERE dayname(Data_received) = "Wednesday"
GROUP BY company 
order BY freq DESC 

/*Which weekday did companies receive the largest amount of complaints? */
SELECT DAYNAME (Data_received) AS weekday, COUNT(*) AS freq FROM cfpb_complaints_2500
GROUP BY WEEKDAY
order by freq DESC

/*Task 5: Which month did the companies receive the largest amount of complaints? 
*/
SELECT MONTHNAME (Data_received) AS month, COUNT(*) AS freq FROM cfpb_complaints_2500
GROUP BY month
order by freq DESC

/*Task 6: Considering only the first 7 days of each month, which month did the companies receive the largest amount of complaints?*/

SELECT MONTHNAME (Data_received) AS month, COUNT(*) AS freq FROM cfpb_complaints_2500
WHERE DAY(Data_received) < 8 
GROUP BY month
order by freq DESC;


/*Task 7: in the table cfpb_complaints_2500, create a new column in the name of ‘datedifference’, 
this column contains the difference in days between Data_sent_to_company and Data_received.
*/
ALTER TABLE cfpb_complaints_2500 ADD datedifference INT;
UPDATE cfpb_complaints_2500 SET datedifference = DATEDIFF(Data_sent_to_company,Data_received);
SELECT datedifference FROM cfpb_complaints_2500

/*Task 8: When will be date that you have living in this world for 10,000 days? How about 20,000 days?*/
SELECT DATE_ADD('1997-08-16', INTERVAL 10000 DAY);

/*
Task 9: How many days have you living in this world by today?
*/
SELECT DATEDIFF(CURRENT_DATE(),'1997-08-16');
--or
SELECT DATEDIFF(now(),'1997-08-16')

/*
Task 10:  In the table products of the car retailing database, add two new columns of Price_difference, and Value_difference, given that:
•	Price_difference = (MSRP-buyPrice)
•	Value_difference = (MSRP-buyPrice)* quantityInStock
*/
ALTER TABLE products ADD Price_difference DECIMAL (10,2);
ALTER TABLE products ADD Value_difference DECIMAL (10,2);

UPDATE products SET Price_difference = (MSRP-buyPrice);
UPDATE products SET Value_difference = (MSRP-buyPrice)*quantityInStock;

/*
Task 11: Remove the two new columns of Price_difference, and Value_difference
*/

ALTER TABLE products DROP COLUMN Price_difference;
ALTER TABLE products DROP COLUMN Value_difference;

/*
	Task 12: In the Classicmodels database, retrieve the names of the customers who purchased Ferrari in 2004! 
Tips:
•	In the table products, you will find productName including the word “Ferrari”
•	In the table orderdetails, you will find the all the orderNumber that have ordered the products including “Ferrari”
*/
-- find ordernumber from orderdetails table
SELECT orderNumber FROM orderdetails 
WHERE productCode IN (SELECT distinct(productCode) FROM products WHERE productName REGEXP ("ferrari"));


-- create temp table to store customerNumber
CREATE TABLE temp AS (SELECT customerNumber FROM orders WHERE orderNumber IN (SELECT orderNumber FROM orderdetails 
WHERE productCode IN (SELECT productCode FROM products WHERE productName REGEXP ("ferrari"))) 
AND year(orderDate) = 2004);

-- Find customer name from 'customers' table:
SELECT customerName, customerNumber FROM customers WHERE customerNumber IN (SELECT * FROM temp);

/*
Task 13: In the table [cfpb_complaints_2500], count the frequencies of different Issues for different companies 
and show the starting date and ending date that different issues have been reported, and order the records based on first the company name from A-Z and then on frequencies in a descending manner. 
Save the results to a new table “Count_result”
*/

CREATE TABLE Count_result AS (
SELECT company, issue, COUNT(*) AS freq, MIN(Data_received) as startingday, MAX(Data_received) as endingday FROM cfpb_complaints_2500 
GROUP BY company, issue
ORDER BY company asc, freq DESC);

/*
Task 14: Based on the results in above table “Count_result”, create a report like below.
*/

SELECT GROUP_CONCAT('The company - ', company,' have issues related to ',issue,' for ', freq, ' time(s) during ', startingday, ' and ', endingday,'.')
FROM Count_result
GROUP BY company, Issue;


/*Task 15. In the [tripadvisor_data_for_handson_assignment_ONLY] dataset, please evaluate whether 
and how the use of mobile device to write a review affects how people gave a rating to a hotel. */
Select via_mobile, avg(overall_rating), avg(service), avg(value), avg(rooms), avg(cleanliness), avg(location), avg(sleep_quality), avg(reviewlength) 
from tripadvisor_data_for_handson_assignment_ONLY group by via_mobile

/*Task 16. Research shows that the review given at the same month of lodging vs. different month of lodging would be significantly different. 
Please find evidence from our data. Please also check how the review generation method (via mobile phone) affect the reported difference.
- the column ‘review_date’ provides the date of when the review is provided.
- the columns ‘year_stayed’ and ‘review_date’ provides the information of which month the accommodation in a hotel took place. 
*/
SELECT via_mobile, avg(overall_rating), avg(service), avg(value), avg(rooms), avg(cleanliness), avg(location), avg(sleep_quality), avg(reviewlength) 
FROM tripadvisor_data_for_handson_assignment_ONLY
WHERE YEAR(review_date) = year_stayed AND MONTH(review_date) = month_stayed
GROUP BY via_mobile
union
SELECT via_mobile, avg(overall_rating), avg(service), avg(value), avg(rooms), avg(cleanliness), avg(location), avg(sleep_quality), avg(reviewlength) 
FROM tripadvisor_data_for_handson_assignment_ONLY
WHERE NOT (YEAR(review_date) = year_stayed AND MONTH(review_date) = month_stayed)
GROUP BY via_mobile;

/*
Task 17. Please import ‘tripadvisor_hotel_sample.sql’ to your database. This data table provides the information of hotels, while the [tripadvisor_data_for_handson_assignment_ONLY] table provides the information of reviews on hotels. 
Please get the list of hotels that are in [tripadivsor_hotel_sample] table, but not in [tripadvisor_data_ for_handson_assignment_ONLY] table. 
*/
SELECT hotel_id,NAME FROM tripadivsor_hotel_sample WHERE hotel_id NOT IN (SELECT hotel_id FROM tripadvisor_data_for_handson_assignment_ONLY);

/*
Task 18. In the tripadvisor_hotel_sample table, please find out whether different hotels are actually using the same hotel name? 
Please sort the result by having the most frequently used name appear first.
*/
SELECT RID, NAME,COUNT(*) AS freq FROM tripadivsor_hotel_sample
GROUP BY NAME
HAVING freq>1
ORDER BY freq desc

/*
	Task 19. Through the above task, we find different hotels using the same name. 
However, whether could different hotels with the same name appear in the same city? 
*/

Select locality, name, count(*) fre from tripadivsor_hotel_sample 
group by locality, name order by fre desc 

/*
	Task 20. Please write ONE query to count the number of hotels with different hotel stars, 
calculate the average length of hotel name, average length of hotel address, 
and think about why these differences exist among different stars of hotels. 
*/

SELECT hotel_class, COUNT(*) AS nr_of_hotel, AVG(LENGTH(name)), AVG(LENGTH(address)) FROM tripadivsor_hotel_sample
GROUP BY hotel_class

/*
	Task 21. In the ‘orders’ table of ‘classicmodels’ database, we can find time (orderDate) of product orders (orderNumber) that were made by each customer (customerNumber). 
Could you please identify the first order (in term of orderDate) made by each customer in the database?
*/

SELECT * FROM orders WHERE (orderNumber, orderDate) IN (SELECT orderNumber, min(orderDate) FROM orders
GROUP BY customerNumber)
/*
	Task 22.  In the answer of task 21, what would be the results, if we replace “IN” with “NOT IN”.
*/
SELECT * FROM orders WHERE (orderNumber, orderDate) NOT IN (SELECT orderNumber, min(orderDate) FROM orders
GROUP BY customerNumber)

