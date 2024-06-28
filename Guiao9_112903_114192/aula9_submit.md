# BD: Guião 9


## ​9.1
 
### *a)*

```
CREATE PROC remove_Employee @ssn char(9)
AS
	BEGIN 
		DECLARE @v_ssn char(9)
		SELECT @v_ssn = Ssn FROM Company_Employee WHERE Ssn = @ssn;

		DELETE FROM  Company_Works_On WHERE Essn=@ssn;

		DELETE FROM  Company_Dependents WHERE Essn=@ssn;
		
		DELETE FROM  Company_Employee WHERE Ssn=@ssn;

		UPDATE Company_Employee SET Super_ssn=NULL WHERE Super_ssn=@ssn;

		UPDATE Company_Department SET Mgr_ssn=NULL WHERE Mgr_ssn=@ssn;

		UPDATE Company_Department SET Mgr_start_date=NULL WHERE Mgr_ssn=@ssn;
	END;

/* preocupações: verificar que o ssn existe na tabela employee, apagar os dados da tabela employee em ultimo pois os valores de essn 
das restantes tabela sao os valores de ssn importadas tabela employee, depois de apagar os dados da tabela employee atualizar o super ssn
desse valor para null caso o valor de ssn removido estivesse la presente */

--add transaction
```

### *b)* 

```
CREATE PROC managers_info
AS
	BEGIN
		--data atual
		DECLARE @date AS DATE = GETDATE();

		--tabela temporaria
		CREATE TABLE #Mgr_info 
		(Ssn VARCHAR(10),
		yearsOfService INT);

		--insert table + calculate years
		INSERT INTO #Mgr_info(Ssn, yearsOfService)
		SELECT Mgr_ssn, DATEDIFF(YEAR, Mgr_start_date, @date) AS yearsOfService FROM Company_Department WHERE Mgr_ssn IS NOT NULL;

		SELECT E.Fname, E.Minit, E.Lname, D.Mgr_Ssn, MI.yearsOfService 
		FROM Company_Employee AS E
		INNER JOIN Company_Department AS D ON
		D.Mgr_ssn = E.Ssn
		INNER JOIN #Mgr_info AS MI ON
		E.Ssn = MI.Ssn;

		--get o mais cota
		SELECT TOP 1 Ssn, yearsOfService FROM #Mgr_info ORDER BY yearsOfService DESC;
		DROP TABLE #Mgr_info;
	END;
```

### *c)* 

```
CREATE TRIGGER not_manager ON Company_Department
AFTER INSERT,UPDATE
AS
	BEGIN
		IF EXISTS (
			SELECT Mgr_Ssn FROM Company_Department
			WHERE Mgr_Ssn IN (SELECT Mgr_Ssn
								FROM inserted)
			GROUP BY Mgr_Ssn
			HAVING COUNT(*)>1
		)
		BEGIN
		RAISERROR ('Esse trabalhador já gere um departamento', 16,1);
		ROLLBACK TRAN;
		RETURN;
		END;
	END;
```

### *d)* 

```
CREATE TRIGGER alter_salary ON Company_Employee
AFTER INSERT, UPDATE
AS
	BEGIN
		DECLARE @ssn AS CHAR(9);
		DECLARE @ssn_salary AS INT;
		DECLARE @mgr_ssn AS CHAR(9);
		DECLARE @mgr_salary AS int;
		DECLARE @dno INT;

		SELECT @ssn=inserted.Ssn, @ssn_salary=inserted.Salary, @dno=inserted.Dno
		FROM inserted;

		SELECT @mgr_salary=E.Salary
		FROM Company_Employee E
		INNER JOIN Company_Department D ON D.Mgr_ssn=E.Ssn
		WHERE @dno=D.Dnumber;

		IF @ssn_salary > @mgr_salary
		BEGIN
			UPDATE Company_Employee
			SET Salary = @mgr_salary - 1
			WHERE Ssn=@ssn
		END;
		
	END;
```

### *e)* 

```
CREATE FUNCTION dbo.Company_employeeProjects (@ssn CHAR(9))
RETURNS TABLE
AS
RETURN
(
    SELECT P.Pname, P.Plocation
    FROM Company_Project P
    JOIN Company_Works_On W ON P.Pnumber = W.Pno
    WHERE W.Essn = @ssn
);

SELECT * FROM dbo.Company_employeeProjects('21312332');
```

### *f)* 

```
CREATE FUNCTION dbo.Company_getEmployeesByDepartment (@dno INT)
RETURNS TABLE
AS
RETURN
(
    SELECT E.*
    FROM Company_Employee E
    WHERE E.Dno = @dno
);

SELECT * FROM dbo.Company_getEmployeesByDepartment(3);
```

### *g)* 

```
CREATE FUNCTION dbo.employeeDeptHighAverage(@DeptNum INT)
RETURNS @ProjectCosts TABLE (
    pname VARCHAR(15),
    pnumber INT,
    plocation VARCHAR(15),
    dnum INT,
    budget DECIMAL(10, 2),
    totalbudget DECIMAL(10, 2)
)
AS
BEGIN
    DECLARE @Pname VARCHAR(15), @Pnumber INT, @Plocation VARCHAR(15), @Dnum INT
    DECLARE @Budget DECIMAL(10, 2), @TotalBudget DECIMAL(10, 2)
    DECLARE ProjectCursor CURSOR FOR
    SELECT Pname, Pnumber, Plocation, Dnum
    FROM Company_Project
    WHERE Dnum = @DeptNum

    OPEN ProjectCursor
    FETCH NEXT FROM ProjectCursor INTO @Pname, @Pnumber, @Plocation, @Dnum

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @Budget = SUM(E.Salary * W.Hours / 160)
        FROM Company_Works_On W
        JOIN Company_Employee E ON W.Essn = E.Ssn
        WHERE W.Pno = @Pnumber
        
        SELECT @TotalBudget = @Budget * 4

        INSERT INTO @ProjectCosts (pname, pnumber, plocation, dnum, budget, totalbudget)
        VALUES (@Pname, @Pnumber, @Plocation, @Dnum, @Budget, @TotalBudget)
        
        FETCH NEXT FROM ProjectCursor INTO @Pname, @Pnumber, @Plocation, @Dnum
    END

    CLOSE ProjectCursor
    DEALLOCATE ProjectCursor

    RETURN
END
GO

SELECT * FROM dbo.employeeDeptHighAverage(3);

```

### *h)* 

```
GO
CREATE TRIGGER DepDelAfter ON dbo.[Company_Department]
AFTER DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Company_Department_Deleted')
    BEGIN
        INSERT INTO dbo.[Company_Department_Deleted] (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
        SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date
        FROM DELETED;
    END
    ELSE
    BEGIN
        CREATE TABLE dbo.[Company_Department_Deleted] (
            Dname VARCHAR(32) NOT NULL,
            Dnumber INT NOT NULL,
            Mgr_ssn CHAR(9),
            Mgr_start_date DATE,
            PRIMARY KEY (Dnumber),
            UNIQUE (Dname),
            FOREIGN KEY (Mgr_ssn) REFERENCES Company_Employee(Ssn)
        );

        INSERT INTO dbo.[Company_Department_Deleted] (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
        SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date
        FROM DELETED;
    END;
END;
GO
------------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER DepDelInsteadOf ON dbo.[Company_Department]
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Company_Department_Deleted')
    BEGIN
        INSERT INTO dbo.[Company_Department_Deleted] (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
        SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date
        FROM DELETED;
    END
    ELSE
    BEGIN
        CREATE TABLE dbo.[Company_Department_Deleted] (
            Dname VARCHAR(32) NOT NULL,
            Dnumber INT NOT NULL,
            Mgr_ssn CHAR(9),
            Mgr_start_date DATE,
            PRIMARY KEY (Dnumber),
            UNIQUE (Dname),
            FOREIGN KEY (Mgr_ssn) REFERENCES Company_Employee(Ssn)
        );

        INSERT INTO dbo.[Company_Department_Deleted] (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
        SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date
        FROM DELETED;
    END;

    DELETE FROM dbo.[Company_Department]
    WHERE Dnumber IN (SELECT Dnumber FROM DELETED);
END;
GO

SELECT * FROM  [Company_Department]
SELECT * FROM  [Company_Department_Deleted]
DROP TABLE [Company_Department_Deleted]
INSERT INTO [Company_Department] VALUES ('Dep1', 6, NULL, '2020-01-01')

// Trigger After:
ENABLE TRIGGER DepDelAfter ON dbo.[Company_Department];
DISABLE TRIGGER DepDelInsteadOf ON dbo.[Company_Department];
DELETE FROM dbo.[Company_Department] WHERE Dnumber = 6;

// Trigger Instead Of:
DISABLE TRIGGER DepDelAfter ON dbo.[Company_Department];
ENABLE TRIGGER DepDelInsteadOf ON dbo.[Company_Department];
DELETE FROM dbo.[Company_Department] WHERE Dnumber = 6;

// Discusao:
O trigger After apresenta as seguintes vantagens:
- Podemos ter varios triggers deste tipo numa tabela
- E mais simples e direto pois apenas reage apos a operacao desejada ter sido efetuada
- Garante que a tabela original e alterada primeiro garantindo que a operacao e bem sucedida antes de registar a mudanca na tabela de destino

E as seguintes desvantagens:
- Existe um pequeno atraso pois temos de esperar que a operacao seja efetuada para que o trigger ser acionado
- Se ocorrer uma falha na execucao do trigger, a operacao original ja foi efetuada e nao pode ser revertida, possivelmete resultando em dados inconsistentes

O trigger Instead Of apresenta as seguintes vantagens:
- Permite um controlo maior sobre a operacao que desejamos efetuar podendo validar dados e modificar dados antes de efetuar a operacao
- Permite a execucao da operacao que queremos ate que todas as operacoes adicionais no trigger sejam concluidas com sucesso

E as seguintes desvantagens:
- Apenas podemos ter um por tabela
- O codigo ficara mais complexo pois precisamos de executar manualmente a operacao substituida pelo trigger apos realizar as operacoes adicionais
- Pode ter impacto de performace visto que adicionara logica adicional antes de efetuar a operacao original

A escolha entre os dois tipos de triggers depende do que queremos fazer e do impacto que queremos ter na base de dados. Por exemplo escolheriamos
um trigger Instead Of quando sabemos que uma acao (instrucao DML) tem uma elevada probabilidade de ser rolled back e pretendemos que outra logica
seja executada (instead of) dela isto pode acontecer ao tentar fazer update de uma view non-updatable ou quando queremos apagar um tuplo mas 
pretendemos que esta passe para uma tabela de arquivo.

Já quanto ao trigger After este pode ser usado para processos complexos de validacao de dados envolvendo, por exemplo, varias tabelas, assegurar
regras de negocio complexas, efetuar auditorias aos dados, atualizar campos calculados e assegurar verificacoes de integridade referencial definidas
pelo utilizador e deletes em cascata.
```

### *i)* 

```
Um stored procedure e uma batch armazenada com um nome para uma base de dados especifica, que permite que o SQL Server nao tenha que
recompilar codigo cada vez que um SP e executada, pois o conjunto de instucoes e compilado num Single Execution Plan e depois e 
guardado na memoria cache na primeira execucao, o que permite execucoes de codigo mais rapidas. Estes procedimentos podem ter 
parametros de entrada, ter valores de retorno e pode devolver um conjunto de tuplos.

Mais Valias:
- Extensibilidade: Usar SP e a melhor forma de abstrair ou dissociar uma base de dados.
- Performace: Um SP bem escrita e a forma mais rapida de executar codigo em SQL.
- Usabilidade: e mais fácil para os programadores fazer uma chamada à SP e usar os resultados do que escrever o codigo SQL.
- Integridade de Dados: Um SP criada pelo desenvolvedor da base de dados e menos provável conter erros de integridade de dados e 
e mais fácil de testar do que codigo SQL.
- Segurança: Bloquear o acesso as tabelas e permitir acesso apenas atraves de SP e uma pratica comum para desenvolvimento de base de
dados.

Exemplos de SP:
Os SP são particularmente uteis em atualizacoes em massa por exemplo utilizar um SP para saldos de contas num banco apos o
processamento de transacoes diarias.
Também sao uteis para executar calculos complexos, por exemplo, para criar relatorios financeiros mensais.

Uma User Defined Function apresentam os mesmos beneficios dos SP pois sao igualmente compiladas e optimizadas, mas com mais algumas vantagens:
- Podem ser usadas para incorporar logica complexa dentro de uma consulta
- Oferecem os mesmo benefitos das vistas pois podem ser utilizadas como fontes de dados nas consultas e nas clausulas WHERE/HAVING, acrescendo
o facto de aceitarem parametros de entrada, algo impossivel em views
- Permite-nos criar npvas funções contendo expressoes complexas.

Existem 3 tipos de UDF: Escalares, Inline Table-Valued e Multi-Statement Table-Valued Functions.

Exemplo de UDF:
As USF podem ser uteis para calculos simples tais como calcular a idade de uma pessoa a partir da sua data de nascimento, ou para formatacao
de dados como formatar um numero de telefone ou um codigo postal para um formato padrao.
```
