create table customer
(
  customerID NUMERIC(10,0) NOT NULL,
  customerFName VARCHAR(20) NOT NULL,
  customerLName VARCHAR(20) NOT NULL,
  customerStreetNo VARCHAR(10) NOT NULL,
  customerStreet VARCHAR(20) NOT NULL,
  customerCity VARCHAR(20) NOT NULL,
  customerState VARCHAR(2) NOT NULL,
  customerZip VARCHAR(9) NOT NULL,

  constraint customer_PK PRIMARY KEY (customerID)

);

-- the "productID" column is defined as INT type with IDENTITY(1,1). Here IDENTITY(a,b) means the system will automatically generate an integer everytime a new record is inserted into the product table. The automatically generated integer starts from integer "a", and increase by "b". Hence IDENTITY(1,1) means the productID will start from 1, and increase by 1 everytime, so the productID series should look like 1,2,3,4,.... 
-- Microsoft Access has similar function called "AutoNumber".

create table product
(
  productID INT IDENTITY(1,1),
  productDesc VARCHAR(50) NOT NULL,
  productFinish VARCHAR(20)
	check(productFinish in ('Cherry', 'Natural Ash', 'White Ash', 'Red Oak', 'Natural Oak', 'Walnut')),
  standardPrice DECIMAL(6,2),
  
  constraint product_PK PRIMARY KEY (productID),
  
);

create table customerOrder
(
  orderID INT IDENTITY(1001, 1),
  orderDate DATETIME NOT NULL,
  customerID NUMERIC(10,0) NOT NULL,
  
  constraint order_PK PRIMARY KEY (orderID),
  constraint order_FK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

-- when creating the orderline table, the productID column is a foreign key that references the productID column in the product table. So the productID column in this orderline table should have the same dataype as the the productID column in the product table. That is why it is defined as INT also, but without the IDENTITY(1,1) part because the values entered into this productID column should have existed in the parent table. 

create table orderline
(
  orderID INT NOT NULL,
  productID INT NOT NULL,
  quantity INT NOT NULL,

  constraint orderline_PK PRIMARY KEY (orderID, productID),
  constraint orderline_FK1 FOREIGN KEY (productID) REFERENCES product(productID),
  constraint orderline_FK2 FOREIGN KEY (orderID) REFERENCES customerOrder(orderID),
);

insert into customer values (1000000001, 'John', 'Smith', '708', 'Main Street', 'Pinesville', 'TX', '45678');
insert into customer values (1000000002, 'Abe', 'Kelly', '6508', 'Wright Street', 'Pinesville', 'MN', '24680');
insert into customer values (1000000003, 'Ben', 'Muller', '508', 'Oak Street', 'Greensville', 'NY', '13579');
insert into customer values (1000000004, 'Carl', 'Lyle', '608', 'Pine Street', 'Mountain View', 'CA', '12345');
insert into customer values (1000000005, 'Diane', 'Nielsen', '650', 'Maple Street', 'Savoy', 'RI', '67890');
insert into customer values (1000000006, 'Elaine', 'Thomas', '511', 'Apple Street', 'Thunder', 'CA', '55555');

insert into product values ('End Table', 'Cherry', 175.00);
insert into product values ('Coffee Table', 'Natural Ash', 400.00);
insert into product values ('Computer Desk', 'Cherry', 175.00);
insert into product values ('Dining Table', 'Cherry', 800.00);
insert into product values ('Computer Desk', 'Walnut', 250.00);

insert into customerOrder values('01/01/2001', 1000000001);
insert into customerOrder values('01/03/2001', 1000000002);
insert into customerOrder values('01/05/2001', 1000000003);
insert into customerOrder values('01/06/2001', 1000000004);
insert into customerOrder values('01/09/2001', 1000000005);
insert into customerOrder values('01/30/2001', 1000000003);

insert into orderline values(1001, 1, 2);
insert into orderline values(1001, 2, 2);
insert into orderline values(1001, 4, 1);
insert into orderline values(1002, 3, 5);
insert into orderline values(1003, 3, 3);
insert into orderline values(1004, 5, 2);
insert into orderline values(1004, 4, 2);
insert into orderline values(1005, 4, 4);

/* Query: find products with standard price less than $275 */
select * from product where standardPrice<275;

select productDesc, standardPrice from product where standardPrice<275;

select productDesc from product where standardPrice<275;

/* DISTINCT */
select DISTINCT productDesc from product where standardPrice<275;

/* using table and column alias */
SELECT 
	c.customerID  'Customer ID',
	c.customerFName 'First Name',
	c.customerLName 'Last Name' 
FROM customer AS c
WHERE c.customerID= 1000000001;

/* select using wild card */
select productDesc from product where productDesc LIKE '%Table';
select productDesc from product where productDesc LIKE '_Table';
select customerFName, customerLName from customer where customerLName LIKE '_elly';

/* select using boolean operators */
SELECT productID, productDesc, productFinish, standardPrice
FROM product
WHERE productDesc LIKE '%Desk' OR productDesc LIKE '%Table';

SELECT productID, productDesc, productFinish, standardPrice
FROM product
WHERE (productDesc LIKE '%Desk' OR productDesc LIKE '%Table') AND standardPrice > 200;

/* select using ranges */
SELECT productID, productDesc, productFinish, standardPrice
FROM product
WHERE standardPrice between 200 and 500;

/* select using sets of values */
SELECT customerID, customerFName, customerLName, customerState
FROM customer
WHERE customerState IN ('FL', 'TX', 'CA', 'HI');

SELECT customerID, customerFName, customerLName, customerState
FROM customer
WHERE customerState NOT IN ('FL', 'TX', 'CA', 'HI');

SELECT customerFName, customerLName, customerState
FROM customer
WHERE customerState IN ('FL', 'TX', 'CA', 'HI')
ORDER BY customerState, customerLName;

/* aggregate functions */

/* Query:  how many different items were ordered on order number 1004 */
select count(*) from orderline where orderID=1004;
/* compare with */
select count(productID) from orderline where orderID=1004;

/* min */
select min(standardPrice) from product;

/* max */
select max(standardPrice) from product;

/* avg */
select avg(standardPrice) from product;

/* Query: how many pieces of furniture in order 1004? */
select sum(quantity) from orderline where orderID=1004;

/* aggregate plus distinct */
SELECT customerID FROM customerOrder;
SELECT COUNT(DISTINCT customerID) FROM customerOrder;
SELECT COUNT(customerID) FROM customerOrder;


/* group by */

/* query: how many customers in each state? */

/* for a specific state */
select count(customerID) 'total number of customers' from customer where customerState='CA';

/* for all states */
select count(customerID) 'total number of customers' from customer group by customerState;

/* better readability*/
select customerState, count(customerID) 'total number of customers' from customer group by customerState;

/* query: find the total quantity sold for each product */

/* for a specific product */
select sum(quantity) 'total quantity sold' from orderline where productID=3;

/* for all products */
select sum(quantity) 'total quantity sold' from orderline group by productID;

/* for better readability */
select productID, sum(quantity) 'total quantity sold' from orderline group by productID;

/*will this work? why?*/
/*orderID not in aggregate function nor in group by*/
select productID, orderID, sum(quantity) 'total quantity sold' from orderline group by productID;

/* find the best seller */
select top 1 productID, sum(quantity) 'total quantity sold'  
from orderline group by productID;

/* selecting category */

/* find all states with more than 1 customer, output the customer count */
select customerState, count(customerID) 'total number of customers' from customer group by customerState having count(customerID)>1;

/* find all states with warm weather, output the customer count */
select customerState, count(customerID) 'total number of customers' from customer 
group by customerState having customerState IN ('CA', 'TX');


