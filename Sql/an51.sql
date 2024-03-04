SELECT productName
FROM products
WHERE productName LIKE 'Classic%Car';

SELECT addressLine1
FROM customers
WHERE addressLine1 LIKE '%Street%' OR addressLine1 LIKE '%Avenue%';

SELECT orders.orderNumber, SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS totalAmount
FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY orders.orderNumber
HAVING totalAmount BETWEEN 1000 AND 5000;

SELECT *
FROM payments
WHERE paymentDate BETWEEN '2004-01-01' AND '2004-06-30';

SELECT orderNumber, SUM(priceEach * quantityOrdered) AS totalAmount
FROM orderdetails
GROUP BY orderNumber
HAVING totalAmount > (SELECT AVG(totalAmount) FROM (SELECT SUM(priceEach * quantityOrdered) AS totalAmount FROM orderdetails GROUP BY orderNumber) AS avg_sales);

SELECT productCode
FROM orderdetails
WHERE quantityOrdered = (SELECT MAX(quantityOrdered) FROM orderdetails);

SELECT customerName
FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE payments.amount > ANY (SELECT 0.9 * MAX(amount) FROM payments) 
AND (city LIKE '%Los Angeles%' OR city LIKE '%NYC%');

select city from offices;

SELECT productName, 
       SUM(CASE 
               WHEN orders.orderDate BETWEEN '2003-12-21' AND '2004-03-20' THEN quantityOrdered 
               ELSE 0 
           END) AS winter_sales,
       AVG(CASE 
               WHEN orders.orderDate BETWEEN '2003-12-21' AND '2004-03-20' THEN quantityOrdered 
               ELSE 0 
           END) AS winter_avg,
       SUM(CASE 
               WHEN orders.orderDate BETWEEN '2004-06-21' AND '2004-09-22' THEN quantityOrdered 
               ELSE 0 
           END) AS summer_sales,
       AVG(CASE 
               WHEN orders.orderDate BETWEEN '2004-06-21' AND '2004-09-22' THEN quantityOrdered 
               ELSE 0 
           END) AS summer_avg
FROM orderdetails
JOIN products ON orderdetails.productCode = products.productCode
Join orders ON orderdetails.orderNumber = orders.orderNumber
GROUP BY productName
having winter_sales > ALL (SELECT AVG(winter_avg) FROM (SELECT SUM(CASE WHEN orders.orderDate BETWEEN '2003-12-21' AND '2004-03-20' THEN quantityOrdered ELSE 0 END) AS winter_avg FROM orderdetails GROUP BY productName) AS winter_avg)
    OR summer_sales > ALL (SELECT AVG(summer_avg) FROM (SELECT SUM(CASE WHEN orders.orderDate BETWEEN '2004-06-21' AND '2004-09-22' THEN quantityOrdered ELSE 0 END) AS summer_avg FROM orderdetails GROUP BY productName) AS summer_avg);




