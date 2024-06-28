# BD: Guião 8


## ​8.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.484 | 531        | 1171      | WorkOrderID| Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  | 1     | 0,00  | 28         | 54        | WorkOrderID| Clustered Index Scan |            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               | 11    | 0,00  | 26         | 97        | WorkOrderID| Clustered Index Scan |            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   | 72591 | 0,183 | 812        | 948       | WorkOrderID| Clustered Index Scan |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'                                          | 1983  | 0.015 | 1983       | 257       | WorkOrderID| Clustered Index Scan |            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   | 9     | 0.00  | 46         | 77        | ProductID  | Index Seek           |            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              | 9     | 0.00  | 46         | 58        | ProductID  | Index Seek           |            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              | 1105  | 0.01  | 559        | 80        | WorkOrderID| Index Seek           |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            | 1     | 0.008 | 814        | 37        | WorkOrderID| Index Seek           |            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' | 1     | 0.009 | 814        | 23        |ProductID and| Index Seek          |            |
                                                                                                                                                                StartDate
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' | 1     | 0.11  | 814        | 40        |  Composite| Index Seek            |            |

## ​8.2.

### a)

```
ALTER TABLE mytemp
ADD CONSTRAINT PK_mytemp_rid PRIMARY KEY CLUSTERED (rid);

```

### b)

```
Inserted      50000 total records
Milliseconds used: 68483

Percentagem de Fragmentacao dos indices: 98.81%
Ocupação de Páginas dos indices: 68.61%

```

### c)

```
ALTER TABLE mytemp
DROP CONSTRAINT PK_mytemp_rid;

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 65, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 76923

DROP INDEX rid_Index ON mytemp;

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 80, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 74230

DROP INDEX rid_Index ON mytemp;

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 90, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 97307

```

### d)

```
DROP TABLE mytemp;

CREATE TABLE mytemp (
rid BIGINT IDENTITY (1, 1) NOT NULL,
at1 INT NULL,
at2 INT NULL,
at3 INT NULL,
lixo varchar(100) NULL
);

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 65, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 78117

DROP INDEX rid_Index ON mytemp;

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 80, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 84710

DROP INDEX rid_Index ON mytemp;

CREATE UNIQUE CLUSTERED INDEX rid_Index ON mytemp(rid) WITH (FILLFACTOR = 90, PAD_INDEX=ON);
Inserted      50000 total records
Milliseconds used: 84180

Código alterado:
-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time
-- Generate random records
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;
SET nocount ON
WHILE @val <= @nelem
BEGIN
DBCC DROPCLEANBUFFERS; -- need to be sysadmin
INSERT mytemp (at1, at2, at3, lixo)
SELECT cast((RAND()*@nelem) as int),
cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
SET @val = @val + 1;
END
PRINT 'Inserted ' + str(@nelem) + ' total records'
-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND,
@start_time, @end_time));

```

### e)

```
DROP TABLE mytemp;

CREATE TABLE mytemp (
rid BIGINT /*IDENTITY (1, 1)*/ NOT NULL,
at1 INT NULL,
at2 INT NULL,
at3 INT NULL,
lixo varchar(100) NULL
);

Sem indices:
Inserted      50000 total records
Milliseconds used: 78690

Com indices:
CREATE INDEX IX_mytemp_rid ON mytemp(rid);
CREATE INDEX IX_mytemp_at1 ON mytemp(at1);
CREATE INDEX IX_mytemp_at2 ON mytemp(at2);
CREATE INDEX IX_mytemp_at3 ON mytemp(at3);

Inserted      50000 total records
Milliseconds used: 129060

Os tempos de execução irão aumentar pois a inserção de registos é mais lenta devido à criação de indices.

```

## ​8.3.

```
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
```
