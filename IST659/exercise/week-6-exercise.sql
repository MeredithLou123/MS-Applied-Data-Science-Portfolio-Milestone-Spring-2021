-- week 6 exercise
--practice create and drop table
create table employee
(
employeeID CHAR(9),
employeeFirstName VARCHAR(30),
employeeLastName VARCHAR(30),

constraint Employee_PK PRIMARY KEY (employeeID),
);
DROP table projectAssignment;


create table projectAssignment
(
employeeID CHAR(9) NOT NULL,
projectID CHAR(9) NOT NULL,
employeeRole VARCHAR(30),

constraint projectAssignment_PK1 PRIMARY KEY (employeeID),

constraint projectAssignment_FK1 FOREIGN KEY (employeeID) REFERENCES employee(employeeID),


constraint projectAssignment_FK2 FOREIGN KEY (projectID) REFERENCES project(projectID),
);
create table project
(
projectID CHAR(9) NOT NULL,
projectDescribtion VARCHAR(30),
ProjectStartDate DATETIME,
ProjectDuration NUMERIC,

constraint project_PK PRIMARY KEY (projectID)
);

