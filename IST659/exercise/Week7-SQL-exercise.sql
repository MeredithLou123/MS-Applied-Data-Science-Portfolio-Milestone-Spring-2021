create table employee
(employeeID VARCHAR(10) NOT NULL,
employeeFirstName VARCHAR(30) NOT NULL,
employeeLastName VARCHAR(30) NOT NULL,
constraint employee_PK PRIMARY KEY (employeeID)
);
select * from employee;

create table project
(projectID VARCHAR(10) NOT NULL,
projectDescription VARCHAR(100),
projectStartDate DATETIME default getdate(),
projectDuration VARCHAR(30),
constraint project_PK PRIMARY KEY (projectID)
);
select * from  project;

create table projectAssignment
(employeeID VARCHAR(10) NOT NULL,
projectID VARCHAR(10) NOT NULL,
projectRole VARCHAR(30),
constraint projectAssignment_PK PRIMARY KEY (employeeID, projectID),
constraint projectAssignment_FK1 FOREIGN KEY (employeeID) REFERENCES employee(employeeID),
constraint projectAssignment_FK2 FOREIGN KEY (projectID) REFERENCES project(projectID)
);
select * from projectAssignment;

delete employee;
delete project;
delete projectAssignment;

insert into employee values ('1','MC','Donald');
insert into employee values ('2', 'Syracuse','University');

insert into project values ('1','zoo','2020/10/07','100days');
insert into project values ('2','tea','2020/01/07','1000days');

insert into projectAssignment(employeeID,projectID) values ('1','1');
insert into projectAssignment(employeeID,projectID) values ('1','2');

sp_help 'employee';
