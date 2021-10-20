#Order book:
SELECT a.orderNumber,orderLineNumber, orderDate,a.customerNumber,customerName, b.productCode,productName,productLine,quantityOrdered,priceEach, round(priceEach*quantityOrdered,2) as rowNetValue, requiredDate,shippedDate,
requiredDate-shippedDate AS Datedifference
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
LEFT JOIN products d
ON b.productCode = d.productCode;

--Sales analysis--

#Order intake table:
SELECT a.orderNumber, orderDate,a.customerNumber,customerName, round(SUM(priceEach*quantityOrdered),2) AS orderintake
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
GROUP BY a.orderNumber
ORDER BY orderintake DESC;
--top3: LIMIT 3

#Number of orders & sales per customer
SELECT customerName, round(SUM(priceEach*quantityOrdered),2) AS sales, COUNT(DISTINCT(a.orderNumber)) AS numberOfOder
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
GROUP BY customerName
ORDER BY sales DESC;

#Number of orders & sales per product line
SELECT productLine, round(SUM(priceEach*quantityOrdered),2) AS sales, COUNT(DISTINCT(a.orderNumber)) AS numberOfOder
FROM orderdetails a
LEFT JOIN products b
ON a.productCode = b.productCode
GROUP BY productLine
ORDER BY sales DESC;

#Best-selling products:
SELECT productName, productLine, COUNT(DISTINCT(a.orderNumber)) AS numberSold, round(SUM(priceEach*quantityOrdered),2) AS sales
FROM orderdetails a
LEFT JOIN products b
ON a.productCode = b.productCode
GROUP BY productName, productLine
ORDER BY numberSold DESC;

#Office that make most revenue (=that locate sales pre who bring most revenue to company):
SELECT e.city AS office, round(SUM(priceEach*quantityOrdered),2) AS sales, COUNT(DISTINCT(a.orderNumber)) AS numberOfOder
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
LEFT JOIN employees d
ON c.salesRepEmployeeNumber = d.employeeNumber
LEFT JOIN offices e
ON d.officeCode = e.officeCode
GROUP BY office
ORDER BY sales DESC;

# Does location affect sales (e.g office located in same city as customer?)
SELECT e.country AS officeLocation, c.country AS customerLocation, round(SUM(priceEach*quantityOrdered),2) AS sales, COUNT(DISTINCT(a.orderNumber)) AS numberOfOder
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
LEFT JOIN employees d
ON c.salesRepEmployeeNumber = d.employeeNumber
LEFT JOIN offices e
ON d.officeCode = e.officeCode
GROUP BY officeLocation,customerLocation
ORDER BY sales DESC;

SELECT e.country AS officeLocation, c.country AS customerLocation, round(SUM(priceEach*quantityOrdered),2) AS sales, COUNT(DISTINCT(a.orderNumber)) AS numberOfOder
FROM orders a
LEFT JOIN orderdetails b
ON a.orderNumber = b.orderNumber
LEFT JOIN customers c
ON a.customerNumber = c.customerNumber
LEFT JOIN employees d
ON c.salesRepEmployeeNumber = d.employeeNumber
LEFT JOIN offices e
ON d.officeCode = e.officeCode
GROUP BY customerLocation, officeLocation
ORDER BY sales DESC;
--

-- Profit analysis--

#Profit per order (margin between product selling price and buying price)
SELECT orderNumber, round(SUM(priceEach*quantityOrdered),2) AS salesprice, round(SUM(buyPrice*quantityOrdered),2) AS cost,
ROUND((SUM(priceEach*quantityOrdered) - SUM(buyPrice*quantityOrdered)),2) AS profit
FROM orderdetails a
LEFT JOIN products b
ON a.productCode = b.productCode
GROUP BY orderNumber
ORDER BY profit DESC;

#Product that generate most profit:
SELECT productName, productLine, round(SUM(priceEach*quantityOrdered),2) AS salesprice, round(SUM(buyPrice*quantityOrdered),2) AS cost,
ROUND((SUM(priceEach*quantityOrdered) - SUM(buyPrice*quantityOrdered)),2) AS profit, COUNT(DISTINCT(a.orderNumber)) AS numberSold
FROM orderdetails a
LEFT JOIN products b
ON a.productCode = b.productCode
GROUP BY productName, productLine
ORDER BY profit DESC;


-- Customer analysis --



#Match customers coming from same country (self join)
SELECT a.customerName AS customername1, b.customerName AS customername2, a.city
FROM customers a
left JOIN customers b
ON a.city = b.city
WHERE a.customerName != b.customerName
ORDER BY customername1


