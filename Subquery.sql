-- Subquery (Nested Query: Query inside a query)
-- Tips for understanding Subquery: 
-- Always write all the queries one by one. 
-- Secondly try to find common columns
-- Remember that innermost query is executed first.

-- List all customers whose creditLimit is more than Average creditLimit
-- Query1 (Q1)
select avg(creditLimit) as Avg_cred
from customers;

-- Query 2: Q2(Q1)
select customerNumber,customerName,creditLimit
from customers
where creditLimit>(select avg(creditLimit) as Avg_cred
from customers);


-- List top 3 customers whose creditLimit is more than Average creditLimit
select customerNumber,customerName,creditLimit
from customers
where creditLimit>(select avg(creditLimit) as Avg_cred
from customers)
order by creditLimit desc
limit 3;


-- Find list of employees who work in office located in USA
-- Q1
select officeCode 
from offices 
where country="USA";

-- Q2(Q1)
select employeeNumber,firstName,email,officeCode
from employees
where officeCode in (select officeCode 
from offices 
where country="USA");


-- Fetch details of all customers whose creditlimit is equal to Maximum creditLimit
-- Query1 (Q1)
select max(creditLimit) as Max_cred
from customers;

-- Query2 (Q2(Q1))
select customerNumber,customerName,creditLimit
from customers
where creditLimit=(select max(creditLimit) as Max_cred
from customers)
order by creditLimit desc;


-- Fetch the name of products of all cancelled orders
-- Q1 
select orderNumber, status 
from orders
where status="Cancelled";

-- Q2
select orderNumber, productCode
from orderdetails;

-- Q3 = Q3(Q2(Q1)))
select productName
from products
where productCode in (select productCode
from orderdetails where orderNumber in (select orderNumber
from orders
where status="Cancelled"));


-- Fetch Min, max and Average of the count of Ordernumber.
-- Floor(2.4)= a int value before 2.4 (i.e. 2)
-- Ceil(2.4)= a int value after 2.4 (i.e. 3)
select max(item),min(item),floor(avg(item)) 
from
(select orderNumber,count(orderNumber) as item
from orderdetails
group by ordernumber) as order_count;


-- Co-related subquery (Inner query is dependent on the data of the outer query)
-- Select products where buyprice is greater than average buy price
-- Here we compare and check each record from productLine one by one whether it is greater than the average buyPrice of the same productLine. 
select productname, buyPrice
from products p1
where buyPrice > (select avg(buyPrice) from products where productLine = p1.productLine);


-- Exists Clause
-- Exists Clase Q1 exists (Q2) will show the output if at least one record from Q2 is returned.
--  If Q2 generates output with at least one record it returns TRUE to the outer query.
select customerNumber, customername
from customers
where exists(select orderNumber, sum(priceEach*quantityOrdered) total
from orderdetails inner join orders using (orderNumber)
Group by orderNumber
having sum(priceEach*quantityOrdered) > 60000);

-- Not Exists Clause
-- Exists Clase Q1 exists (Q2) will show the output if at least one record from Q2 is returned.
--  If Q2 generates output with at least one record it returns FALSE to the outer query.
select customerNumber, customername
from customers
where not exists(select orderNumber, sum(priceEach*quantityOrdered) total
from orderdetails inner join orders using (orderNumber)
Group by orderNumber
having sum(priceEach*quantityOrdered) > 60000);

