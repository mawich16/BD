ALTER TABLE [Company_Department]
			DROP CONSTRAINT [DEPTMGRFK]
ALTER TABLE [Company_Employee]
			DROP CONSTRAINT [EMPDEPTFK]
DROP TABLE [Company_Dependents]
DROP TABLE [Company_Works_On]
DROP TABLE [Company_Project]
DROP TABLE [Company_Dept_Locations]
DROP TABLE [Company_Department]
DROP TABLE [Company_Employee]

CREATE TABLE [Company_Employee] (
	Fname varchar(15) NOT NULL,
	Minit char,
	Lname varchar(15) NOT NULL,
	Ssn char(9) NOT NULL,
	Bdate date,
	Address varchar(30),
	Sex char,
	Salary decimal(10,2),
	Super_ssn char(9),
	Dno int NOT NULL,
	PRIMARY KEY ([Ssn]),
	FOREIGN KEY ([Super_ssn]) REFERENCES [Company_Employee]([Ssn]),
)
GO

CREATE TABLE [Company_Department] (
	Dname varchar(32) NOT NULL,
	Dnumber int NOT NULL,
	Mgr_ssn char(9),
	Mgr_start_date date,
	PRIMARY KEY ([Dnumber]),
	UNIQUE ([Dname]),
	FOREIGN KEY ([Mgr_ssn]) REFERENCES [Company_Employee]([Ssn]),
)
GO

ALTER TABLE [Company_Employee]
			ADD CONSTRAINT [EMPDEPTFK] FOREIGN KEY ([Dno]) REFERENCES [Company_Department]([Dnumber])
GO

ALTER TABLE [Company_Department]
			ADD CONSTRAINT [DEPTMGRFK] FOREIGN KEY ([Mgr_ssn]) REFERENCES [Company_Employee]([Ssn])
GO

CREATE TABLE [Company_Dept_Locations] (
	Dnumber int NOT NULL,
	Dlocation varchar(15) NOT NULL,
	PRIMARY KEY ([Dnumber], [Dlocation]),
	FOREIGN KEY ([Dnumber]) REFERENCES [Company_Department]([Dnumber]),
)
GO

CREATE TABLE [Company_Project] (
	Pname varchar(15) NOT NULL,
	Pnumber int NOT NULL,
	Plocation varchar(15),
	Dnum int NOT NULL,
	PRIMARY KEY ([Pnumber]),
	UNIQUE ([Pname]),
	FOREIGN KEY ([Dnum]) REFERENCES [Company_Department]([Dnumber]),
)
GO

CREATE TABLE [Company_Works_On] (
	Essn char(9) NOT NULL,
	Pno int NOT NULL,
	Hours decimal(3,1) NOT NULL,
	PRIMARY KEY ([Essn], [Pno]),
	FOREIGN KEY ([Essn]) REFERENCES [Company_Employee]([Ssn]),
	FOREIGN KEY ([Pno]) REFERENCES [Company_Project]([Pnumber]),
)
GO

CREATE TABLE [Company_Dependents] (
	Essn char(9) NOT NULL,
	Dependent_name varchar(15) NOT NULL,
	Sex char,
	Bdate date,
	Relationship varchar(8),
	PRIMARY KEY ([Essn], [Dependent_name]),
	FOREIGN KEY ([Essn]) REFERENCES [Company_Employee]([Ssn]),
)