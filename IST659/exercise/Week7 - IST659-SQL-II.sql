/* BEGIN SQL Script Commandments 
 * 1. save your script
 * 2. remember where you saved it
 * 3. add comments to explain your code
 * END SQL Script Commandments */

-- Last week: SQL I create/drop tables; insert/delete values
-- This week: alter tables; update values; using single-table select and aggregate functions to answer data questions
-- Next week: using multi-table select to answer data questions

-----------------------
-- alter table
-----------------------

-- alter table is the command to change definitions of tables that already exist
-- we did that last week by using drop table and then create table again
-- the drop/create approach is problematic when there are foreign key constraints between tables
-- alter table statement allows us to make small changes here and there
-- sometimes the tables are empty; sometimes they are already populated
-- DBMS checks if the new changes affect the old data

-- imagine we are the SQL language designers
-- let's think about what information we should tell the software in order to alter table
-- what functions do we need? add a new column; drop an old column; change the data type of an old column; 
-- what parameters should we transfer to DBMS? (1) which table to alter; (2) which column to alter; (3) how to alter: add/drop/change? (4) what is the new data type in the case of add and change

-- can we design the best alter table syntax? as brief as possible, easy to understand, comprehensive to include all functions

-- add a new column
-- e.g. add customerAddress to the customer table
-- how about this?
alter table customer add column customerAddress varchar(100);
-- syntax error: we have to remove the keyword "column" in this case. Why?
-- think about this: can we add anything else to the table except for new columns?
-- the answer is NO. That's why the keyword "column" is not necessary here. And the design principle is to keep everything as simple as possible
-- my 2 cents: I'd rather keep the keyword "column" since it would make syntax more consistent among similar commands like 'drop column' and 'alter column; 

-- so the following statement is correct
-- step 1: define as nullable
alter table customer add customerAddress varchar(100);

-- since the new column is nullable, the DBMS automatically set the values of the new column to 'null' for all existing rows
-- if the new column should be defined as not null, what should we do?

SELECT * FROM customer;
-- step 2: change the null values to real ones for all existing rows
UPDATE customer SET customerAddress='501 Daniel St., Champaign, IL 61820' WHERE customerID='C100000002'; 
-- step 3: redefine the column as not null
alter table customer alter column customerAddress varchar(100) not null; 

/*
alter table product
add constraint product_finish_default DEFAULT 'Cherry' FOR productFinish;
*/

-- ------------
-- update values
-- ------------

-- update one value
update customer set customerAddress='501 Daniel St., Champaign, IL 61801' where customerID='C100000002'; 

-- we can use math operators to change values
-- e.g. price increase 5%
update product set productPrice=productPrice*1.05



-- drop a column
alter table customer drop column customerAddress;


