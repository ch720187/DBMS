/*List names and sellers of products that are no longer available (quantity=0)*/
select merchants.name, products.name, quantity_available
from sell
inner join merchants
inner join products
On (merchants.mid = sell.mid and products.pid = sell.pid)
where quantity_available = 0;


/*List names and descriptions of products that are not sold.*/
select products.name, products.description
from products
where products.pid NOT IN(select pid from sell);

/*
How many customers bought SATA drives but not any routers?*/
select DISTINCT (customers.cid) from customers
INNER JOIN place 
INNER JOIN contain
INNER JOIN products
On (customers.cid = place.cid and place.oid = contain.oid and products.pid = contain.pid)
where products.name = "Hard Drive" not in (select customers.cid from customers INNER JOIN place INNER JOIN contain INNER JOIN products On (customers.cid = place.cid and place.oid = contain.oid and products.pid = contain.pid) where products.name = 'Router');



/*HP has a 20% sale on all its Networking products.*/
Select DISTINCT(products.name) as "Product Name", price*0.8 as "Sale Price", merchants.name as "Merchant Name" from sell
INNER JOIN products
INNER JOIN merchants
On(merchants.mid = sell.mid and products.pid = sell.pid)
where merchants.name = 'HP' and products.category = 'Networking';

/*What did Uriel Whitney order from Acer? (make sure to at least retrieve product names and prices).*/

Select DISTINCT(products.name) as "Product Name", price as "Product Price", merchants.name as "Merchant Name" from sell
INNER JOIN products
INNER JOIN merchants
INNER JOIN customers
INNER JOIN place
INNER JOIN contain
On(customers.cid = place.cid and contain.pid = sell.pid = products.pid)
where fullname = "Uriel Whitney" and merchants.name = 'Acer';


/*List the annual total sales for each company (sort the results along the company and the year attributes).*/

Select merchants.name as 'Company', year(order_date) as 'Year', sum(price) as 'Total Sales' from sell
INNER JOIN contain
INNER JOIN place
INNER JOIN merchants
On(sell.pid = contain.pid and contain.oid = place.oid and merchants.mid = sell.mid)
Group by merchants.name, year(order_date)
Order by merchants.name, Year desc;

/*Which company had the highest annual revenue and in what year?*/

Select merchants.name as 'Company', year(order_date) as 'Year', sum(price) as 'Total Sales' from sell
INNER JOIN contain
INNER JOIN place
INNER JOIN merchants
On(sell.pid = contain.pid and contain.oid = place.oid and merchants.mid = sell.mid)
Group by merchants.name, year(order_date)
Order by sum(price) desc
Limit 1;


/*On average, what was the cheapest shipping method used ever?*/

Select shipping_method, avg(shipping_cost) from orders
Group by shipping_method
Order by avg(shipping_cost) asc
Limit 1;


/*What is the best sold ($) category for each company?*/

Select merchants.name as 'Company', sum(price) as 'Total Sales', category from products 
INNER JOIN merchants
INNER JOIN sell
INNER JOIN contain
INNER JOIN place
On(sell.pid = contain.pid = products.pid and contain.oid = place.oid and merchants.mid = sell.mid)
Group by category, merchants.name
Order by sum(price) desc;


/*For each company find out which customers have spent the most and the least amounts.*/

Select merchants.name, customers.fullname, sum(price) as "Total Spent" from place
INNER JOIN merchants
INNER JOIN sell
INNER JOIN contain
INNER JOIN customers
INNER JOIN orders
On (place.cid = customers.cid and place.oid = orders.oid = contain.oid and sell.pid = contain.pid)
Group by merchants.mid, customers.cid;

Select sub.name, sub.fullname, max(Total_Spent) from (Select merchants.name, customers.fullname, sum(price) as Total_Spent from place
INNER JOIN merchants
INNER JOIN sell
INNER JOIN contain
INNER JOIN customers
INNER JOIN orders
On (place.cid = customers.cid and place.oid = orders.oid = contain.oid and sell.pid = contain.pid)
Group by merchants.mid, customers.cid) as sub
Group by sub.name, sub.fullname;

Select sub.name, sub.fullname, min(Total_Spent) from (Select merchants.name, customers.fullname, sum(price) as Total_Spent from place
INNER JOIN merchants
INNER JOIN sell
INNER JOIN contain
INNER JOIN customers
INNER JOIN orders
On (place.cid = customers.cid and place.oid = orders.oid = contain.oid and sell.pid = contain.pid)
Group by merchants.mid, customers.cid) as sub
Group by sub.name, sub.fullname;