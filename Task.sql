
CREATE DATABASE IF NOT EXISTS Engineer_Management;

USE Engineer_Management;


-- Task 1: Create Tables

-- Create Member Table
CREATE TABLE IF NOT EXISTS Member (
    Member_ID INT PRIMARY KEY,
    First_Name VARCHAR(20),
    Last_Name VARCHAR(20),
    Member_Location VARCHAR(20),
    Member_Age INT
);

-- Create Vehicle Table
CREATE TABLE IF NOT EXISTS Vehicle (
    Vehicle_Registration VARCHAR(10) PRIMARY KEY,
    Vehicle_Make VARCHAR(10),
    Vehicle_Model VARCHAR(10),
    Member_ID INT,
    FOREIGN KEY (Member_ID) REFERENCES Member(Member_ID) ON DELETE CASCADE
);

-- Create Engineer Table
CREATE TABLE IF NOT EXISTS Engineer (
    Engineer_ID INT PRIMARY KEY,
    First_Name VARCHAR(20),
    Last_Name VARCHAR(20)
);

-- Create Breakdown Table
CREATE TABLE IF NOT EXISTS Breakdown (
    Breakdown_ID INT PRIMARY KEY,
    Vehicle_Registration VARCHAR(10),
    Engineer_ID INT,
    Breakdown_Date DATE,
    Breakdown_Time TIME,
    Breakdown_Location VARCHAR(20),
    FOREIGN KEY (Vehicle_Registration) REFERENCES Vehicle(Vehicle_Registration) ON DELETE CASCADE,
    FOREIGN KEY (Engineer_ID) REFERENCES Engineer(Engineer_ID) ON DELETE SET NULL
);


-- Task 2: Insert Data

-- Insert into Member Table
INSERT INTO Member (Member_ID, First_Name, Last_Name, Member_Location, Member_Age) VALUES
(1, 'John', 'Doe', 'New York', 35),
(2, 'Jane', 'Smith', 'Los Angeles', 29),
(3, 'Jason', 'Johnson', 'Chicago', 42),
(4, 'Emily', 'Davis', 'Miami', 53),
(5, 'Michael', 'Browson', 'San Francisco', 60);

-- Insert into Vehicle Table
INSERT INTO Vehicle (Vehicle_Registration, Vehicle_Make, Vehicle_Model, Member_ID) VALUES
('ABC123', 'Toyota', 'Corolla', 1),
('XYZ987', 'Honda', 'Civic', 2),
('LMN456', 'Tesla', 'Model 3', 3),
('JKL789', 'Chevrolet', 'Cruze', 1),
('GHI321', 'Nissan', 'Altima', 4),
('DEF654', 'Hyundai', 'Elantra', 5),
('TUV111', 'Kia', 'Soul', 5),
('WXY222', 'Toyota', 'Camry', 2);

-- Insert into Engineer Table
INSERT INTO Engineer (Engineer_ID, First_Name, Last_Name) VALUES
(101, 'Alice', 'Williams'),
(102, 'David', 'Miller'),
(103, 'Chris', 'Taylor');

-- Insert into Breakdown Table
INSERT INTO Breakdown (Breakdown_ID, Vehicle_Registration, Engineer_ID, Breakdown_Date, Breakdown_Time, Breakdown_Location) VALUES
(1, 'ABC123', 101, '2024-01-05', '10:30:00', 'New York'),
(2, 'XYZ987', 102, '2024-01-12', '12:00:00', 'Los Angeles'),
(3, 'LMN456', 101, '2024-01-20', '14:00:00', 'Chicago'),
(4, 'JKL789', 101, '2024-02-15', '09:30:00', 'New York'),
(5, 'GHI321', 102, '2024-02-15', '11:45:00', 'Miami'),
(6, 'DEF654', 101, '2024-03-03', '08:30:00', 'San Francisco'),
(7, 'DEF654', 102, '2024-04-11', '16:00:00', 'San Francisco'),
(8, 'TUV111', 101, '2024-03-25', '10:15:00', 'San Francisco'),
(9, 'TUV111', 102, '2024-06-30', '13:40:00', 'San Francisco'),
(10, 'ABC123', 101, '2023-04-15', '11:00:00', 'New York'),
(11, 'XYZ987', 102, '2023-05-10', '09:45:00', 'Los Angeles'),
(12, 'LMN456', 101, '2023-06-25', '14:15:00', 'Chicago');


-- Task 3: Perform Queries

-- 1. Retrieve the first 3 members from the Member table.
SELECT * FROM Member LIMIT 3;

-- 2. Retrieve 3 members, skipping the first 2.
SELECT * FROM Member LIMIT 2, 3;

-- 3. Retrieve all vehicles whose Vehicle_Make starts with 'T'.
SELECT * FROM Vehicle WHERE Vehicle_Make LIKE 'T%';

-- 4. Retrieve all breakdowns that occurred between '2023-01-01' and '2023-06-30'.
SELECT * FROM Breakdown WHERE Breakdown_Date BETWEEN '2023-01-01' AND '2023-06-30';

-- 5. Retrieve details of vehicles with registrations 'ABC123', 'XYZ987', and 'LMN456'.
SELECT * FROM Vehicle WHERE Vehicle_Registration IN ('ABC123', 'XYZ987', 'LMN456');

-- 6. Retrieve the number of breakdowns each vehicle has had.
SELECT Vehicle_Registration, COUNT(*) AS Breakdown_Count
FROM Breakdown
GROUP BY Vehicle_Registration;

-- 7. Retrieve all members sorted by Member_Age in descending order.
SELECT * FROM Member ORDER BY Member_Age DESC;

-- 8. Retrieve all vehicles that are either 'Toyota' make or 'Honda' make, and the model starts with 'C'.
SELECT * FROM Vehicle WHERE (Vehicle_Make = 'Toyota' OR Vehicle_Make = 'Honda') AND Vehicle_Model LIKE 'C%';

-- 9. Retrieve all engineers who do not have any breakdowns assigned.
SELECT e.Engineer_ID, e.First_Name, e.Last_Name
FROM Engineer e
LEFT JOIN Breakdown b ON e.Engineer_ID = b.Engineer_ID
WHERE b.Engineer_ID IS NULL;

-- 10. Retrieve all members aged between 25 and 40.
SELECT * FROM Member WHERE Member_Age BETWEEN 25 AND 40;

-- 11. Retrieve all members whose First_Name starts with 'J' and Last_Name contains 'son'.
SELECT * FROM Member WHERE First_Name LIKE 'J%' AND Last_Name LIKE '%son%';

-- 12. Retrieve the top 5 oldest members.
SELECT * FROM Member ORDER BY Member_Age DESC LIMIT 5;

-- 13. Retrieve all vehicle registrations in uppercase.
SELECT UPPER(Vehicle_Registration) AS Vehicle_Registration FROM Vehicle;

-- 14. Retrieve the details of all members along with the vehicles they own.
SELECT m.Member_ID, m.First_Name, m.Last_Name, v.Vehicle_Registration, v.Vehicle_Make, v.Vehicle_Model
FROM Member m
JOIN Vehicle v ON m.Member_ID = v.Member_ID;

-- 15. Retrieve all members and any associated vehicles, including members who do not own any vehicles.
SELECT m.Member_ID, m.First_Name, m.Last_Name, v.Vehicle_Registration, v.Vehicle_Make, v.Vehicle_Model
FROM Member m
LEFT JOIN Vehicle v ON m.Member_ID = v.Member_ID;

-- 16. Retrieve all vehicles and the associated members, including vehicles that are not owned by any members.
SELECT v.Vehicle_Registration, v.Vehicle_Make, v.Vehicle_Model, m.Member_ID, m.First_Name, m.Last_Name
FROM Vehicle v
LEFT JOIN Member m ON v.Member_ID = m.Member_ID;

-- 17. Retrieve the number of breakdowns each member has had.
SELECT m.Member_ID, m.First_Name, m.Last_Name, COUNT(b.Breakdown_ID) AS Breakdown_Count
FROM Member m
JOIN Vehicle v ON m.Member_ID = v.Member_ID
JOIN Breakdown b ON v.Vehicle_Registration = b.Vehicle_Registration
GROUP BY m.Member_ID;

-- 18. Retrieve all breakdowns along with member first name and last name that occurred for vehicles owned by members aged over 50.
SELECT b.Breakdown_ID, b.Vehicle_Registration, b.Breakdown_Date, b.Breakdown_Location, m.First_Name, m.Last_Name
FROM Breakdown b
JOIN Vehicle v ON b.Vehicle_Registration = v.Vehicle_Registration
JOIN Member m ON v.Member_ID = m.Member_ID
WHERE m.Member_Age > 50;


-- Task 4: Update and Delete Records

-- 1. Update 3 records in the Engineer table
UPDATE Engineer
SET First_Name = 'Alex' --
WHERE Engineer_ID = 101;

UPDATE Engineer
SET First_Name = 'Daniel'
WHERE Engineer_ID = 102;

UPDATE Engineer
SET Last_Name = 'Jackson'
WHERE Engineer_ID = 103;

-- 2. Delete 2 records from the Breakdown table
DELETE FROM Breakdown
WHERE Breakdown_ID = 6;

DELETE FROM Breakdown
WHERE Breakdown_ID = 9;

