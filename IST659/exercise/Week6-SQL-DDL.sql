-- don't forget to save your sql script!
-- remember where you save it!

-- two ways to add comments
-- comments
/* comments */

-- SQL I: create/drop/alter tables; insert/delete/update values

-- Part I: create/drop tables, insert/delete values

-- If you need to practice data insertion, deletion, and update, try create other tables with different names 
-- because we will use the following tables and their data in the future classes.

-- ---------------
-- create table --
-- ---------------

-- always create entities without FKs first.

-- step 1: define table name, write an empty create statement

create table customer
(
);
-- doesn't work, need to have content

-- step 2: define column names and data types

create table customer
(
customerID CHAR(10),
customerName VARCHAR(30)
);

-- run it, then check content
select * from customer;
select customerID from customer;

-- drop the table because we still need to revise the table structure
drop table customer;

-- step 3: define whether each column is nullable, if it is not nullable, add "not null" to the column definition, otherwise no change
create table customer
(
customerID CHAR(10) not null,
customerName VARCHAR(30) not null
);

-- step 4: define primary key  

create table customer
(
customerID CHAR(10) not null,
customerName VARCHAR(30) not null, -- don't forget to add the comma after adding the constraint

  constraint customer_PK PRIMARY KEY (customerID)

);

-- an alternative approach to define simple primary key (You CANNOT use it to define composite primary key!)
-- add keyword "primary key" by the primary key column
-- since primary key column has to be not nullable, no need to write "not null" once it is defined as the primary key
create table customer
(
customerID CHAR(10) primary key,
customerName VARCHAR(30) not null
);

-- exercise: now let's create the product table

create table product
(
  productID CHAR(10) NOT NULL,
  productName VARCHAR(30) NOT NULL,
  productDesc VARCHAR(100) NOT NULL,
  productPrice DECIMAL(6,2),
  
  constraint product_PK PRIMARY KEY (productID)
);

-- "decimal" or "numeric"
-- SQL Server allows both as valid data type. Actually when you look up either one of the data types, 
-- the SQL Server manual points to the same entry, meaning they are identical. 
-- Such redundancy is not necessary. Maybe in future version one of them will be gone.

-- step 5: control values in columns
-- add constraint "check"
-- e.g. add a column "productFinish", in which the product finish can only be one of the following three values "cherry", "walnut", and "oak"

drop table product;
create table product
(
  productID CHAR(10) NOT NULL,
  productName VARCHAR(30) NOT NULL,
  productDesc VARCHAR(100) NOT NULL,
  productPrice DECIMAL(6,2) NOT NULL,
  productFinish VARCHAR(10) NOT NULL check( productFinish IN ('cherry', 'walnut', 'oak')),
  
  constraint product_PK PRIMARY KEY (productID)
);

-- step 5: control values in columns
-- add constraint "unique"
-- e.g. product names have to be unique
-- are unique columns all candidate primary keys? Maybe not, if they are nullable

drop table product;
create table product
(
  productID CHAR(10) NOT NULL,
  productName VARCHAR(30) NOT NULL UNIQUE,
  productDesc VARCHAR(100) NOT NULL,
  productPrice DECIMAL(6,2) NOT NULL,
  productFinish VARCHAR(10) NOT NULL check( productFinish IN ('cherry', 'walnut', 'oak')),
  
  CONSTRAINT product_PK PRIMARY KEY (productID)
);


-- let's move on to create the order table
-- we need to define foreign key in this table 
create table order
(
  orderID NUMERIC(11,0) NOT NULL,
  orderDate DATETIME,
  customerID CHAR(10) NOT NULL,
  
  constraint order_PK PRIMARY KEY (orderID),
  constraint order_FK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

-- error message "Incorrect syntax near the keyword 'order'. Keywords are shown in blue. 
-- diagnosis: do not use system-reserved words (e.g. "order") to name your data objects (tables, attributes, indices, etc.)
create table customerOrder
(
  orderID NUMERIC(11,0) NOT NULL,
  orderDate DATETIME,
  customerID CHAR(10) NOT NULL,
  
  constraint order_PK PRIMARY KEY (orderID),
  constraint order_FK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

-- re-run, pass

-- step 5: control values in columns
-- add constraint "default": set default value for a column
-- e.g. set the default value of orderDate to the current date
-- try run select getdate(); separately and see what the result looks like.
select getDate();


drop table customerOrder;
create table customerOrder
(
  orderID CHAR(10) NOT NULL,
  orderDate DATETIME default getdate(), 
  customerID CHAR(10) NOT NULL,
  
  constraint order_PK PRIMARY KEY (orderID),
  constraint order_FK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);

-- now let's move on to create the orderLine table
-- new problem: define composite primary key
create table orderline
(
  orderID CHAR(10) NOT NULL,
  productID CHAR(10) NOT NULL,
  quantity INTEGER NOT NULL,

  constraint orderline_PK PRIMARY KEY (orderID, productID),
  constraint orderline_FK1 FOREIGN KEY (productID) REFERENCES product(productID),
  constraint orderline_FK2 FOREIGN KEY (orderID) REFERENCES customerOrder(orderID)
);

-- Now we are done creating the four tables

-- any indices to create?
-- e.g. we often need to search customer order by the order date
-- solution: create an index on the orderDate column

create index orderDateIDX on customerOrder(orderDate);

-- Now let's move on to populate the tables

-- ----------------
-- insert values --
-- ----------------

-- the order of populating the tables is the same order of creating tables

-- populate the customer table
insert into customer values ( 'C100000001', 'Syracuse University' );
insert into customer values ( 'C100000002', 'Upstate Medical Center' );
select * from customer;

-- clean out the table: delete the rows
-- we will learn how to delete a certain row or rows
delete from customer;

-- exercise: populate the product table
insert into product values ( 'P100000001', 'Computer Desk', 'xxx', 399.95, 'oak');
insert into product values ( 'P100000002', 'Chair', 'xxx', 99.95, 'ash');
-- error message
-- The INSERT statement conflicted with the CHECK constraint "CK__product__product__1DE57479". The conflict occurred in database "ist659m001wang”, table "dbo.product", column 'productFinish'.
-- diagnosis: violate the check constraint
-- fix
insert into product values ( 'P100000002', 'Chair', 'xxx', 99.95, 'cherry');
select * from product;

-- more exercise: populate the customerOrder table
insert into customerOrder (orderID, orderDate, customerID) values ('O100000001', '11/23/2006', 'C100000001');
insert into customerOrder (orderID, customerID) values ('O100000002', 'C100000001');
select * from customerOrder;
-- check the date of order 'O100000002', should be today's date
insert into customerOrder (orderID, orderDate, customerID) values ('O100000003', '11/23/2006', 'C100000003');
-- error message
-- The INSERT statement conflicted with the FOREIGN KEY constraint "order_FK". The conflict occurred in database "ist659m001wang”, table "dbo.customer", column 'customerID'.
-- diagnosis: violate the foreign key constraint - the customerID does not exist in the customer table
-- fix
insert into customerOrder (orderID, orderDate, customerID) values ('O100000003', '11/23/2006', 'C100000002');
select * from customerOrder;

-- more exercise: populate the orderline table
insert into orderline values ('O100000001', 'P100000001', 2);
select * from orderline;

----------------------------------------------------------------------------------
-- now we are done with creating and populating the four tables in this data model
----------------------------------------------------------------------------------

-- play more with the data? 
sp_rename 'customer.customerName', 'customerFirstName','COLUMN';

ALTER TABLE customer ADD customerLastName VARCHAR(30) NOT NULL;
-- fix
ALTER TABLE customer ADD customerLastName VARCHAR(30);