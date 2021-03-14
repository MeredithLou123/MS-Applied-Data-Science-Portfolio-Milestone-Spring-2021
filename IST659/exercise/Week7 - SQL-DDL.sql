--USE [659DB1]

create table customer
(
customerID CHAR(10) not null,
customerName VARCHAR(30) not null, -- don't forget to add the comma after adding the constraint

  constraint customer_PK PRIMARY KEY (customerID)

);


create table product
(
  productID CHAR(10) NOT NULL,
  productName VARCHAR(30) NOT NULL UNIQUE,
  productDesc VARCHAR(100) NOT NULL,
  productPrice DECIMAL(6,2) NOT NULL,
  productFinish VARCHAR(10) NOT NULL check( productFinish IN ('cherry', 'walnut', 'oak')),
  
  CONSTRAINT product_PK PRIMARY KEY (productID)
);


create table customerOrder
(
  orderID CHAR(10) NOT NULL,
  orderDate DATETIME DEFAULT getdate(), 
  customerID CHAR(10) NOT NULL,
  
  constraint order_PK PRIMARY KEY (orderID),
  constraint order_FK FOREIGN KEY (customerID) REFERENCES customer(customerID)
);


create table orderline
(
  orderID CHAR(10) NOT NULL,
  productID CHAR(10) NOT NULL,
  quantity INTEGER NOT NULL,

  constraint orderline_PK PRIMARY KEY (orderID, productID),
  constraint orderline_FK1 FOREIGN KEY (productID) REFERENCES product(productID),
  constraint orderline_FK2 FOREIGN KEY (orderID) REFERENCES customerOrder(orderID)
);

create index orderDateIDX on customerOrder(orderDate);


insert into customer values ( 'C100000001', 'Syracuse University' );
insert into customer values ( 'C100000002', 'Upstate Medical Center' );

-- exercise: populate the product table
insert into product values ( 'P100000001', 'Computer Desk', 'xxx', 399.95, 'oak');
insert into product values ( 'P100000002', 'Chair', 'xxx', 99.95, 'cherry');

insert into customerOrder (orderID, orderDate, customerID) values ('O100000001', '11/23/2006', 'C100000001');
insert into customerOrder (orderID, customerID) values ('O100000002', 'C100000001');


insert into orderline values ('O100000001', 'P100000001', 2);

