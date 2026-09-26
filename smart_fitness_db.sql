-- Smart Fitness Centre database (MySQL 8)
-- Tables, sample data, role-based access control and example queries

CREATE DATABASE IF NOT EXISTS SmartFitnessDB;
USE SmartFitnessDB;

-- ---------------- Tables ----------------

CREATE TABLE Trainer (
    TrainerID VARCHAR(10) PRIMARY KEY,
    TrainerName VARCHAR(20) NOT NULL,
    Experience INT NOT NULL,
    TrainerContact VARCHAR(20) NOT NULL,
    TrainerJoinDate DATE NOT NULL
);

CREATE TABLE Plan (
    PlanID VARCHAR(10) PRIMARY KEY,
    PlanName VARCHAR(20) NOT NULL,
    Price DECIMAL(8,2) NOT NULL CHECK (Price > 0)
);

CREATE TABLE Member (
    MemberID VARCHAR(10) PRIMARY KEY,
    MemberName VARCHAR(20) NOT NULL,
    Age INT NOT NULL CHECK (Age > 12),
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M','F','O')),
    MemberContact VARCHAR(20) NOT NULL,
    MembershipType VARCHAR(20) NOT NULL,
    JoinDate DATE NOT NULL,
    TrainerID VARCHAR(10) NOT NULL,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
);

CREATE TABLE MemberPlan (
    MemberPlanID VARCHAR(10) PRIMARY KEY,
    MemberID VARCHAR(10) NOT NULL,
    PlanID VARCHAR(10) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (PlanID) REFERENCES Plan(PlanID)
);

CREATE TABLE Session (
    SessionID VARCHAR(10) PRIMARY KEY,
    MemberID VARCHAR(10) NOT NULL,
    TrainerID VARCHAR(10) NOT NULL,
    SessionDate DATE NOT NULL,
    SessionType VARCHAR(40) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
);

CREATE TABLE Nutrition (
    NutritionPlanID VARCHAR(10) PRIMARY KEY,
    MemberID VARCHAR(10) NOT NULL,
    DietDetails VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
);

CREATE TABLE Payment (
    PaymentID VARCHAR(10) PRIMARY KEY,
    MemberID VARCHAR(10) NOT NULL,
    Amount DECIMAL(8,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(30) NOT NULL,
    PayDate DATE NOT NULL,
    PayStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
);

-- ---------------- Sample data ----------------
INSERT INTO Trainer VALUES
('T001', 'Namal Perera', 5, '0715634889', '2020-01-02'),
('T002', 'Sampath', 3, '0729566543', '2022-06-05'),
('T003', 'Kasun', 4, '071678907', '2021-01-02'),
('T004', 'Senula', 2, '0775467830', '2023-09-09'),
('T005', 'Vidusha', 1, '0718954632', '2024-03-04');

INSERT INTO Plan VALUES
('P001', 'Muscle Gain', 5000.00),
('P002', 'Endurance Plan', 4500.00),
('P003', 'Weight Loss', 4000.00),
('P004', 'Flexible Plan', 3500.00);

INSERT INTO Member VALUES
('M001', 'David Laid', 27, 'M', '0717745678', 'Annual', '2023-05-01', 'T001'),
('M002', 'Anuhas', 19, 'M', '0723915789', 'Monthly', '2024-05-05', 'T002'),
('M003', 'Nimesha', 28, 'F', '0746787890', 'Annual', '2020-02-07', 'T003'),
('M004', 'Ravi Fernando', 30, 'M', '0748888901', 'Annual', '2018-09-04', 'T004'),
('M005', 'Sarah Smith', 21, 'F', '075557812', 'Monthly', '2025-02-02', 'T005');

INSERT INTO MemberPlan VALUES
('MP001', 'M001', 'P001'),
('MP002', 'M001', 'P002'),
('MP003', 'M002', 'P002'),
('MP004', 'M003', 'P001'),
('MP005', 'M003', 'P003'),
('MP006', 'M004', 'P004'),
('MP007', 'M005', 'P003');

INSERT INTO Session VALUES
('S001', 'M001', 'T001', '2023-06-01', 'Strength'),
('S002', 'M002', 'T002', '2024-06-06', 'Endurance'),
('S003', 'M002', 'T002', '2024-05-10', 'Cardio'),
('S004', 'M003', 'T003', '2020-02-10', 'Calisthenics'),
('S005', 'M004', 'T004', '2023-09-09', 'Flexibility'),
('S006', 'M005', 'T005', '2024-03-04', 'Zumba');

INSERT INTO Nutrition VALUES
('N001', 'M001', 'High Protein', '2023-06-01', '2023-12-01'),
('N002', 'M002', 'Balanced Diet', '2024-06-06', '2024-12-06'),
('N003', 'M003', 'Low Carb', '2020-02-10', '2020-08-10'),
('N004', 'M004', 'Flex Diet', '2018-09-05', '2019-03-05'),
('N005', 'M005', 'Keto', '2025-02-05', '2025-08-05');

INSERT INTO Payment VALUES
('PAY001', 'M001', 5000.00, 'Cash', '2023-06-01', 'Paid'),
('PAY002', 'M002', 4500.00,
