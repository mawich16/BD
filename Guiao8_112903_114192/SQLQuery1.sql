-- i
CREATE CLUSTERED INDEX employeeSsn ON Company_Employee(Ssn);

--ii
CREATE INDEX [name] ON Company_Employee(Fname,Lname);

--iii
CREATE INDEX department ON Company_Department(Dno);

--iv
CREATE CLUSTERED INDEX worksOn ON Company_Works_On(essn,pno);

--v
CREATE INDEX employeesDependent ON Company_Dependent(ssn);

--vi
CREATE INDEX department ON Company_Projects(dnum);