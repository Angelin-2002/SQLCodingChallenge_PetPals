--Coding Challenge
--create database PetPals
create database PetPals

--create table pets
create table Pets(
PetID int identity(1,1) Primary Key Not Null,
Name varchar(25),
Age int,
Breed varchar(30),
Type varchar(20),
AvailableForAdoption bit)

--create table Shelters
create table Shelters(
ShelterID int identity(101,1) primary key Not null,
Name varchar(30),
Loaction varchar(30))

--create table donations
create table Donations(
DonationID int identity(1001,1) primary key Not Null,
DonorName varchar(30),
DonationType varchar(30),
DonationAmount decimal,
DonationItem varchar(30),
DonationDate datetime)

--create table AdoptionEvents
create table AdoptionEvents(
EventID int identity(1,1) primary key Not Null,
EventName varchar(30),
EventDate datetime,
Location varchar(30))

--create table Participants
create table Participants(
ParticipantID int primary key Not NUll,
ParticipantName varchar(30),
ParticipantType varchar(30),
EventID int,
foreign key (EventID) references AdoptionEvents(EventID))

--insert values to Pets
insert into Pets (Name,Age,Breed,Type,AvailableForAdoption)
values
('Max',2,'Labrador','Dog',1),
('Whisker',1,'Persian Cat','Cat',1),
('Tom',3,'German Shepherd','Dog',1),
('Jam',1,'Siamese Cat','Cat',0),
('Rocky',2,'Golden Retriever','Dog',1)

select * from Pets

--insert values to Shelters
insert into Shelters (Name,Loaction) values
('Little Paws','Chennai'),
('Cozy Cat Shop','Bangalore'),
('Happy Paws','Mumbai'),
('Fur Shelter','Delhi'),
('Lovely Tails','Pune')

select * from Shelters

--insert values to Donations
insert into Donations (DonorName,DonationType,DonationAmount,DonationItem,DonationDate) values
('John Dan','Cash',500,Null,'2024-02-29 11:00:00'),
('Jane Wat','Item',Null,'Pet Food','2023-10-14 16:00:00'),
('Sam Wills','Cash',800,Null,'2023-02-28 10:00:00'),
('Emily Watson','Item',Null,'Toys','2024-01-20 10:45:00'),
('Mishel Whine','Cash',1000,Null,'2023-01-23 17:30:00')

select * from Donations

--inert values to AdoptionEvents
insert into AdoptionEvents (EventName,EventDate,Location) values
('Pet Expo','2024-02-29 11:00:00','Coimbatore'),
('Pet Fair','2023-10-29 10:00:00','Chennai'),
('Pet Festival','2023-09-26 09:00:00','Bangalore'),
('Paws Festival','2023-07-14 10:30:00','Darjelling'),
('Adoption Fair','2024-02-14 12:00:00','Delhi')
 
select * from AdoptionEvents

--insert values into Participants
insert into Participants(ParticipantID,ParticipantName,ParticipantType,EventID) values
(1,'Paws Shelter','Shelter',1),
(2,'Cozy Cat','Shelter',2),
(3,'Woofies','Adoption',1),
(4,'Cozy Cat','Shelter',3),
(5,'Adoption Centre','Adoption',4)

select * from Participants

--5.Write an SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that the query filters out pets that are not available for adoption
select Name ,Age,Breed ,Type 
from Pets
where AvailableForAdoption=1

--6.Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query joins the necessary tables to retrieve the participant names and types.
declare @id int
set @id=1
select ParticipantName,ParticipantType
from Participants
where EventID=@id

--7.Create a stored procedure in SQL that allows a shelter to update its information (name and location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information. Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID.


--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. The result should include the shelter name and the total donation amount. Ensure that the query handles cases where a shelter has received no donations.
alter table Donations
add ShelterID int

alter table Donations
add constraint FK_Donation 
foreign key(ShelterID) references Shelters(ShelterID)

select s.Name ,sum(d.DonationAmount) AS TotalDonation
FROM Shelters s
LEFT JOIN Donations d 
on s.ShelterID = d.ShelterID
group by s.Name

--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result set.
--Pets that do not have a owner are those who are available for adoption
select name,age,Breed,type
from Pets
where AvailableForAdoption=1

--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table. The result should include the month-year and the corresponding total donation amount. Ensure that the query handles cases where no donations were made in a specific month-year.


--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
select distinct Breed
from Pets
where (Age between 1 and 3) or (Age>5)


--12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.

alter table Pets
add ShelterID int

alter table Pets
add constraint FK_ShelterID
foreign key (ShelterID) references Shelters(ShelterID)

select p.Name,p.Breed,p.Type,s.Name as ShelterName
from Pets p
join Shelters s
on p.ShelterID =s.ShelterID
where p.AvailableForAdoption=1


--13. Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai

alter table Participants
add ShelterID int

alter table Participants
add constraint FK_SheltersID
foreign key (ShelterID) references Shelters(ShelterID)

select count(distinct p.ParticipantID) as TotalParticipants
from Participants p
join AdoptionEvents a
on p.EventID=a.EventID
join Shelters s
on p.ShelterID=s.ShelterID
where s.Loaction='Chennai' 

--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select distinct Breed
from Pets
where Age between 1 and 5


--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.
select name,age,Breed,type
from Pets
where AvailableForAdoption=1

--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
create table Users(
UserID int primary key,
Name varchar(30))

create table Adoption (
AdoptionID int primary key,
PetID int,
UserID int,
AdoptionDate date,
foreign key (PetID) references Pets(PetID),
foreign key (UserID) references Users(UserID))

Insert into Users (UserID, Name)
values
(1, 'Angelin'),
(2, 'Jwel '),
(3, 'Gem'),
(4, 'Crystal'),
(5, 'Merlin')

Insert into Adoption (AdoptionID, PetID, UserID, AdoptionDate)
values
(1, 1, 1, '2024-02-10'),
(2, 2, 2, '2024-02-29'),
(3, 3, 3, '2024-02-28'),
(4, 4, 4, '2024-01-10'),
(5, 5, 5, '2024-01-02')


select p.Name, u.Name as AdopterName
FROM Adoption a
JOIN Pets p ON a.PetID = p.PetID
JOIN Users u ON a.UserID = u.UserID
WHERE p.AvailableForAdoption = 1;


--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
select s.Name,count(p.PetID) as AvailablePetCount
from Shelters s
left join Pets p
on s.ShelterID=p.ShelterID
and p.AvailableForAdoption=1
group by s.Name

--18. Find pairs of pets from the same shelter that have the same breed.
select p1.Name as Pet1,p2.Name as Pet2,s.Name as ShelterName
from pets p1
join pets p2
on p1.Breed=p2.Breed and p1.ShelterID=p2.ShelterID
and p1.PetID<p2.PetID
join Shelters s 
on p1.ShelterID =s.ShelterID

--19. List all possible combinations of shelters and adoption events.
select s.Name as ShelterName, a.EventName
from Shelters s
cross Join AdoptionEvents a

--20. Determine the shelter that has the highest number of adopted pets.
select top 1 s.ShelterID, s.Name, count(a.AdoptionID) AS PetsCount
from Shelters s
left join Pets p
on s.ShelterID = p.ShelterID
left join Adoption a 
on p.PetID = a.PetID
group by s.ShelterID, s.Name
order by PetsCount desc