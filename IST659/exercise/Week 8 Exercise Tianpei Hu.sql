--Exercise 1
select customerID, count(orderID) from customerOrder group by customerID 
select orderID, count(productID) 'product count' from orderline group by orderID order by 'product count'
select orderID, sum(quantity) 'piece count' from orderline group by orderID order by orderID
select * from customer c, customerOrder co where c.customerID = co.customerID
select p.productID, productDesc, orderID from product p, orderline o where p.productID = o.productID

select *
from table1 t1
inner join table2 t2
on t1.ID = t2.ID

select *
from customer c
join customerOrder co
on c.customerID = co.customerID

select t1.*, t2.*
from table1 t1 left join table2 t2
on t1.ID = t2.ID

select t1.*, t2.*
from table1 t1 right join table2 t2
on t1.ID = t2.ID

select t1.*, t2.*
from table1 t1 full outer join table2 t2
on t1.ID = t2.ID;

select c.customerID, 
c.customerFName, 
c.customerLName, 
c.customerStreetNo,
c.customerCity,
c.customerState,
c.customerZip,
co.orderID,
co.orderDate
from customer c left join customerOrder co 
on c.customerID=co.customerID;

insert into product values(6, 'Dresser', 'Cherry', 200.00)
select * from product;

select p.productID, orderID, ol.productID
from product p left join orderline ol
on p.productID = ol.productID;

--Exercise 2
select *
from customer c 
inner join customerOrder co 
on c.customerID=co.customerID
inner join orderline ol
on co.orderID=ol.orderID
inner join product p 
on ol.productID=p.productID 
order by c.customerID, ol.orderID, p.productID;

select t1.*,t2.*
from table1 t1 left join table2 t2
on t1.ID=t2.ID
where t2.ID is null;

--subqueries
select t1.*
from table1 t1
where t1.ID not in
(select t2.ID from table2 t2);

select t1.*,t2.*
from table1 t1 
full join table2 t2
on t1.ID=t2.ID
where t2.ID is null or t1.ID is null;

select *
from customer
where customerID
not in (
select customerID from customerOrder);

--Exercise 3
select * 
from product
where productID not in
(select productID from orderline);

select 
max(standardPrice) 
from product
union
(
select 
min(standardPrice) 
from product
)
union all
(select 800)

select * 
from product
where standardPrice = 
(select 
min(standardPrice) 
from product) 
union all
(
select * 
from product
where standardPrice = 
(select 
max(standardPrice) 
from product)
)

select *
from customer cross join product

--Trigger



















