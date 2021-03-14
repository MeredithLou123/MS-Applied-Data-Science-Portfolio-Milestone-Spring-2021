drop table FlightTransaction
drop table MemberCustomer
drop table FlightSeat
drop table FlightSeatclass
drop table FlightHistory
drop table Flight
drop table Arrival_Airport;
drop table Departure_Airport
drop table AirlineCompany



create table Arrival_Airport (
	Arrival_AirportId Integer not null,
	Arrival_AirportName varchar(100) not null,
	Arrival_AirportCity varchar(30) not null,
	Arrival_AirportCountry varchar(30) not null,
	constraint Arrival_Airport_PK Primary Key (Arrival_AirportId)
);

create table Departure_Airport (
	Departure_AirportId Integer not null,
	Departure_AirportName varchar(100) not null,
	Departure_AirportCity varchar(30) not null,
	Departure_AirportCountry varchar(30) not null,
	constraint Departure_Airport_PK Primary Key (Departure_AirportId)
);


create table AirlineCompany (
	ACId Integer not null,
	ACName varchar(30) not null,
	ACEmail varchar(30) not null,
	ACPhone varchar(30) not null,
	constraint AC_PK Primary Key (ACID)
);



create table MemberCustomer(
	CID varchar(30) not null,
	CFName  varchar(30) not null,
	CLName varchar(30) not null,
	CPhone varchar(50) not null,
	CEmail varchar(100) not null,
	CStreetNo varchar(30) not null,
	CStreetName varchar(30) not null,
	CCity varchar(30) not null,
	CState varchar(30) not null,
	CZip varchar(30) not null,
	CBday varchar(30) not null,
	CPassportNum varchar(100) not null,
	constraint MemberCustomer_PK Primary Key (CID)
);

create table Flight(
	FlightID VARCHAR(20) not null,
	ACId Integer not null,
	DepartureAirportId Integer not null, 
	ArrivalairportId Integer not null,
	Totalflightduration FLOAT not null,
	constraint Flight_PK Primary Key(FlightID),
	constraint Flight_FK1 Foreign Key (ACId) references AirlineCompany(ACId),
	constraint Flight_FK2 Foreign Key (DepartureAirportId) references Departure_Airport(Departure_AirportId),
	constraint Flight_FK3 Foreign Key (ArrivalairportId) references Arrival_Airport(Arrival_AirportId),
);
create table FlightHistory(
	HisotryID varchar(30) not null,
	FlightID VARCHAR(20) not null,
	Departuredate datetime default getdate() not null,
	Arrivaldate datetime default getdate() not null,
	DelayTime varchar(50) not null,
	Realflightduration FLOAT not null,
	Flightservicestatus varchar(20) not null check (Flightservicestatus in ('Delayed','On Time','Cancelled')),
	Specialinstruction text,
	CancellationReasoning text,
	constraint FH_PK Primary Key(HisotryID),
	constraint FH_FK Foreign Key (FlightID) references Flight(FlightID)
);

create table FlightSeatclass(
	FlightseatclassID varchar(60) not null,
	Seatclass varchar(60) not null,
	constraint FlightSeatclass_PK Primary Key(FlightseatclassID)
);
create table FlightSeat(
	FlightseatID varchar(30) not null,
	FlightID VARCHAR(20) not null,
	FlightseatclassID varchar(60) not null,
	Seatprice float not null,
	Startdate datetime default getdate() not null,
	Enddate date,
	constraint Flightseat_PK Primary Key (FlightseatID),
	constraint Flightseat_FK1 Foreign Key (FlightID) references Flight(FlightID),
	constraint Flightseat_FK2 Foreign Key (FlightseatclassID) references FlightSeatclass(FlightseatclassID)
);

create table FlightTransaction(
	TransactionID varchar(30) not null,
	FlightID VARCHAR(20) not null,
	CID varchar(30) not null,
	FlightseatID varchar(30) not null,
	FlightDate datetime default getdate() not null,
	OrderStatus varchar(60) not null check (OrderStatus in ('Purchased','ShoppingCart')),
	constraint transcation_PK Primary Key (TransactionID), 
	constraint FlightTransaction_FK1 Foreign Key (FlightID) references Flight(FlightID),
	constraint FlightTransaction_FK2 Foreign Key (CID) references MemberCustomer(CID),
	constraint FlightTransaction_FK3 Foreign Key (FlightseatID) references FlightSeat(FlightseatID),
);

INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (1, 'Beijing Capital International Airport', 'Beijing', 'China') 
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (2, 'New York JFK International Airport', 'New York', 'USA') 
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (3, 'Shanghai Pudong International Airport', 'Shanghai', 'China')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (4, 'Los Angeles International Airport', 'Los Angeles', 'USA')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (5, 'Chicago O Hare International Airport', 'Chicago', 'USA')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (6, 'Shenzhen Bao an International Airport', 'Shenzhen', 'China')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (7, 'Frankfurt Airport', 'Frankfurt', 'German')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (8, 'Detroit Metropolitan Wayne County Airport', 'Detroit', 'USA')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (9, 'San Francisco International Airport', 'San Francisco', 'USA')
INSERT INTO Arrival_Airport (Arrival_AirportId, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry)  
VALUES (10, 'Dallas-Fort Worth International Airport', 'Dallas', 'USA')

INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (1, 'Beijing Capital International Airport', 'Beijing', 'China') 
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (2, 'New York JFK International Airport', 'New York', 'USA') 
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (3, 'Shanghai Pudong International Airport', 'Shanghai', 'China')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (4, 'Los Angeles International Airport', 'Los Angeles', 'USA')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (5, 'Chicago O Hare International Airport', 'Chicago', 'USA')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (6, 'Shenzhen Bao an International Airport', 'Shenzhen', 'China')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (7, 'Frankfurt Airport', 'Frankfurt', 'German')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (8, 'Detroit Metropolitan Wayne County Airport', 'Detroit', 'USA')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (9, 'San Francisco International Airport', 'San Francisco', 'USA')
INSERT INTO Departure_Airport (Departure_AirportId, Departure_AirportName, Departure_AirportCity, Departure_AirportCountry)  
VALUES (10, 'Dallas-Fort Worth International Airport', 'Dallas', 'USA')


INSERT INTO AirlineCompany (ACId, ACName, ACEmail, ACPhone)  
VALUES (1, 'China Airlines', 'ChinaAirlines@163.com', '86-666-666-8888')
INSERT INTO AirlineCompany (ACId, ACName, ACEmail, ACPhone)  
VALUES (2, 'United Airlines', 'UnitedAirlines@usa.com', '1-800-864-8331')
INSERT INTO AirlineCompany (ACId, ACName, ACEmail, ACPhone)  
VALUES (3, 'Cathay Pacific', 'CathayPacific@cp.com', '1-800-233-2742')
INSERT INTO AirlineCompany (ACId, ACName, ACEmail, ACPhone)  
VALUES (4, 'China Southern Airlines', 'skypearl@csair.com', '86-020-8613-4388')
INSERT INTO AirlineCompany (ACId, ACName, ACEmail, ACPhone)  
VALUES (5, 'Deutsche Lufthansa AG', 'Lufthansa@deut.com', '1-800-645-3880')


INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (1, 'Yun', 'Zhang', 'zhangyun@163.com','315-999-9999','22','main st','Syracuse','NY','13402','June-09-1992','CH1231111')

INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (2, 'Meili', 'Wang', 'meiliwang@163.com','315-222-2222','45','John st','Syracuse','NY','13409','March-09-1978','CH1674444')


INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (3, 'John', 'Trump', 'trumpjohn@gmail.com','346-222-9999','1','main st','New York','NY','12001','Dec-12-1981','USA333321')


INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (4, 'Mary', 'Bullis', 'marybullis@gmail.com','322-111-9999','111','Clinton ave','Chicago','IL','30242','Jan-11-1971','USA322389')

INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (5, 'Xiaoli', 'Huang', 'huangxiaoli@gmail.com','605-222-3434','2','star ave','Los Angeles','CA','90055','Feb-16-1995','CH1119389')

INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (6, 'Mingbo', 'Li', 'mingbol@gmail.com','535-231-7675','216','elen ave','Los Angeles','CA','90055','Oct-17-1998','CH0248599')

INSERT INTO MemberCustomer (CID, CFName,CLName,CPhone,CEmail,CStreetNo,CStreetName,CCity,CState,CZip,CBday,CPassportNum)  
VALUES (7, 'shenjing', 'liu', 'liushenjing@gmail.com','444-444-3434','44','noew ave','Syracuse','NY','13210','Apr-14-1994','CH1114424')


insert into Flight (FlightID,ACId,DepartureAirportId,ArrivalairportId,Totalflightduration) values ('CA5885',1,2,1,14.30)
insert into Flight (FlightID,ACId,DepartureAirportId,ArrivalairportId,Totalflightduration) values ('UA960',2,4,3,15.30)
insert into Flight (FlightID,ACId,DepartureAirportId,ArrivalairportId,Totalflightduration) values ('CP8288',3,5,6,16)
insert into Flight (FlightID,ACId,DepartureAirportId,ArrivalairportId,Totalflightduration) values ('AA9009',3,10,3,14)
insert into Flight (FlightID,ACId,DepartureAirportId,ArrivalairportId,Totalflightduration) values ('UA200',2,9,3,15)

insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus) values ('1','CA5885','2020-04-28 12:00','2020-4-29 14:27','0',14.27,'On Time')
insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus) values ('2','UA960','2020-04-28 16:00','2020-4-29 17:56','26',15.56,'Delayed')
insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus,CancellationReasoning) values ('3','CP8288','2020-06-12 09:00','2020-6-13 13:00','0',15.56,'Cancelled','New Border Control Regulation Due to COVID-19')
insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus) values ('4','UA200','2020-10-03 10:00','2020-10-04 15:00','0',15,'On Time')
insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus,CancellationReasoning) values ('5','CP8288','2020-10-15 13:00','2020-10-16 17:00','0',14,'Cancelled','New Border Control Regulation Due to COVID-19')
insert into FlightHistory (HisotryID,FlightID,Departuredate,Arrivaldate,DelayTime,Realflightduration,Flightservicestatus,CancellationReasoning) values ('6','CA5885','2020-11-03 17:00','2020-11-04 21:00','0',14,'Cancelled','New Border Control Regulation Due to COVID-19')



insert into FlightSeatclass (FlightseatclassID,Seatclass) values ('1','First-Class')
insert into FlightSeatclass (FlightseatclassID,Seatclass) values ('2','Business')
insert into FlightSeatclass (FlightseatclassID,Seatclass) values ('3','Prime-Economy')
insert into FlightSeatclass (FlightseatclassID,Seatclass) values ('4','Economy')

insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('1','CA5885','2',2500,'2020-02-12')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate,Enddate) values ('2','CA5885','3',1700,'2020-02-12','2020-03-29')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('3','CA5885','3',1900,'2020-03-30')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('4','CA5885','1',4500,'2020-02-12')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('5','UA200','4',1900,'2020-03-11')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('6','AA9009','3',2500,'2020-02-17')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('7','UA960','3',2500,'2020-02-17')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('8','UA960','1',5500,'2020-02-17')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('9','UA960','2',3500,'2020-02-17')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('10','UA200','1',3900,'2020-03-11')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('11','UA200','2',3000,'2020-03-11')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('12','UA200','3',2200,'2020-03-11')
insert into FlightSeat (FlightseatID,FlightID,FlightseatclassID,Seatprice,Startdate) values ('13','UA200','4',1900,'2020-03-11')

insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('1','CA5885','2','3','2020-04-28 12:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('2','CA5885','1','4','2020-04-28 12:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('3','CA5885','3','4','2020-04-28 12:00','ShoppingCart')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('4','CA5885','3','1','2020-04-28 12:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('5','UA960','6','2','2020-04-28 16:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('6','UA960','5','8','2020-04-28 16:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('7','UA200','7','13','2020-10-03 10:00','Purchased')
insert into FlightTransaction (TransactionID,FlightID,CID,FlightseatID,FlightDate,OrderStatus) values ('8','UA200','4','12','2020-10-03 10:00','Purchased')



select * from Arrival_Airport
select * from Departure_Airport
select * from AirlineCompany
select * from MemberCustomer
select * from Flight
select * from FlightHistory
select * from FlightSeat
select * from FlightSeatclass
select * from FlightTransaction

select Flight.FlightID,AirlineCompany.ACName,Arrival_Airport.Arrival_AirportName,Departure_AirportName,FlightHistory.HisotryID
from Flight,AirlineCompany,Arrival_Airport,Departure_Airport,FlightHistory where Flight.ACId=AirlineCompany.ACId and Flight.ArrivalairportId=Arrival_Airport.Arrival_AirportId and Flight.DepartureAirportId=Departure_Airport.Departure_AirportId and FlightHistory.FlightID=Flight.FlightID


select AirlineCompany.ACName, SUM(FlightSeat.Seatprice) as 'Total Revenue' from AirlineCompany,Flight,FlightSeat,FlightTransaction where AirlineCompany.ACId=Flight.ACId and Flight.FlightID=FlightTransaction.FlightID and FlightTransaction.FlightseatID=FlightSeat.FlightseatID and FlightTransaction.OrderStatus='Purchased' group by AirlineCompany.ACName

select FlightTransaction.FlightID,MemberCustomer.*,FlightSeat.Seatprice,FlightTransaction.OrderStatus from FlightSeat,FlightTransaction,MemberCustomer where FlightSeat.FlightID=FlightTransaction.FlightID and MemberCustomer.CID=FlightTransaction.CID and FlightTransaction.FlightseatID = FlightSeat.FlightseatID order by FlightTransaction.FlightID

Create View flight_history AS
select FlightID,  ROUND(((SUM(CASE WHEN Flightservicestatus = 'Cancelled' THEN 1.000 ELSE 0 END)) / COUNT(*)), 2) AS "Cancellation Rate" 
from  FlightHistory
group by FlightID

select * from flight_history

select a.FlightID,c.ACId,a.OrderStatus,b.Totalflightduration,C.ACName from FlightTransaction a  left join Flight b on a.FlightID = b.FlightID join AirlineCompany c on b.ACId = c.ACId


select FlightTransaction.FlightID,AirlineCompany.ACId,AirlineCompany.ACName,FlightTransaction.OrderStatus,Flight.Totalflightduration from FlightTransaction,Flight,AirlineCompany where FlightTransaction.FlightID=Flight.FlightID and Flight.ACId=AirlineCompany.ACId

select  FlightID, Arrival Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry, Departure_AirportName,Departure_AirportCity,Departure_AirportCountry, Totalflightduration,FlightDate,FlightseatID
from (select a.FlightID,b.ArrivalairportId,b.Totalflightduration,b.DepartureAirportId, a.CID,a.FlightDate,a.FlightseatID from FlightTransaction a left join Flight b on a.FlightID = b.FlightID where OrderStatus = 'Purchased') as tmp join Arrival_Airport c on tmp.ArrivalairportId = c.Arrival_AirportId 
join Departure_Airport d on d.Departure_AirportId = tmp.DepartureAirportId

select FlightTransaction.FlightID,Arrival_Airport.Arrival_AirportName,Arrival_Airport.Arrival_AirportCity,Arrival_Airport.Arrival_AirportCountry,Departure_Airport.Departure_AirportName,Departure_Airport.Departure_AirportCity,Departure_Airport.Departure_AirportCountry,Flight.Totalflightduration,FlightTransaction.FlightDate
from FlightTransaction,Flight,Arrival_Airport,Departure_Airport where FlightTransaction.FlightID=Flight.FlightID and Flight.ArrivalairportId=Arrival_Airport.Arrival_AirportId and Departure_Airport.Departure_AirportId=Flight.DepartureAirportId and FlightTransaction.OrderStatus='Purchased'

create view airport_summary AS
select CID, FlightID, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry, Departure_AirportName,Departure_AirportCity,Departure_AirportCountry, Totalflightduration,FlightDate,FlightseatID
from (select a.FlightID,b.ArrivalairportId,b.Totalflightduration,b.DepartureAirportId, a.CID,a.FlightDate,a.FlightseatID from FlightTransaction a left join Flight b on a.FlightID = b.FlightID where OrderStatus = 'Purchased') as tmp join Arrival_Airport c on tmp.ArrivalairportId = c.Arrival_AirportId 
join Departure_Airport d on d.Departure_AirportId = tmp.DepartureAirportId




select  b.CFName,b.CLName, FlightID, Arrival_AirportName, Arrival_AirportCity, Arrival_AirportCountry, Departure_AirportName,Departure_AirportCity,Departure_AirportCountry,Totalflightduration,FlightDate,Seatclass,Seatprice
from airport_summary a left join MemberCustomer b on a.CID = b.CID left join (select a.Seatclass,b.FlightseatID,b.Seatprice from FlightSeatclass a join FlightSeat b on a.FlightseatclassID = b.FlightseatclassID) tmp on tmp.FlightseatID = a.FlightseatID

select MemberCustomer.CFName,MemberCustomer.CLName,FlightTransaction.FlightID,Arrival_Airport.Arrival_AirportName,Arrival_Airport.Arrival_AirportCity,Arrival_Airport.Arrival_AirportCountry,Departure_Airport.Departure_AirportName,Departure_Airport.Departure_AirportCity,Departure_Airport.Departure_AirportCountry,Flight.Totalflightduration,FlightTransaction.FlightDate,FlightSeatclass.Seatclass,FlightSeat.Seatprice from FlightTransaction,Flight,Arrival_Airport,Departure_Airport,MemberCustomer,FlightSeatclass,FlightSeat where FlightTransaction.FlightID=Flight.FlightID and Flight.ArrivalairportId=Arrival_Airport.Arrival_AirportId and Departure_Airport.Departure_AirportId=Flight.DepartureAirportId and FlightTransaction.OrderStatus='Purchased' and MemberCustomer.CID=FlightTransaction.CID and FlightSeatclass.FlightseatclassID=FlightSeat.FlightseatclassID and FlightTransaction.FlightseatID=FlightSeat.FlightseatID




select Flight.FlightID,FlightSeatclass.Seatclass,FlightSeat.Seatprice,FlightSeat.Startdate,FlightSeat.Enddate from Flight,FlightSeaclass,FlightSeat where Flight.FlightID=FlightSeat.FlightID and FlightSeat.FlightseatclassID=FlightSeatclass.FlightseatclassID order by Flight.FlightID

create view seat_summary AS
select f.FlightID,Seatclass,Seatprice,Startdate,Enddate from Flight f left join (select a.Seatclass, b.FlightID,b.Seatprice,b.Startdate,b.Enddate from FlightSeatclass a join FlightSeat b on a.FlightseatclassID = b.FlightseatclassID) tmp on f.FlightID = tmp.FlightID

select FlightID,SUM(CASE WHEN Seatclass = 'First-Class' THEN 1 ELSE 0 END) as first_class_available_seats,SUM(CASE WHEN Seatclass = 'Business' THEN 1 ELSE 0 END) as Business__available_seats,SUM(CASE WHEN Seatclass = 'Prime-Economy' THEN 1 ELSE 0 END) as Prime_economy_available_seats, SUM(CASE WHEN Seatclass = 'Economy' THEN 1 ELSE 0 END) as economy_available_seats
from seat_summary
group by FlightID

select TOP 1 FlightID, count(ACID) as counts
from airlines_summary
group by  FlightID
order by counts desc

Create View Customers_order AS
Select a.CID,a.CFName,a.CLName,FlightID, FlightDate, b.OrderStatus
from MemberCustomer a join FlightTransaction b on a.CID = b.CID
where b.OrderStatus = 'Purchased'

Create View airlines_summary AS
select a.FlightID,c.ACId,a.OrderStatus,b.Totalflightduration,C.ACName from FlightTransaction a  left join Flight b on a.FlightID = b.FlightID join AirlineCompany c on b.ACId = c.ACId





select AirlineCompany.ACName, count(FlightTransaction.FlightID) 'Total Visits' from FlightTransaction,Flight,AirlineCompany where FlightTransaction.FlightID=Flight.FlightID and Flight.ACId=AirlineCompany.ACId group by AirlineCompany.ACName