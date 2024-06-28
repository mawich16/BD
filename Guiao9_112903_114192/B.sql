-- b)
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
