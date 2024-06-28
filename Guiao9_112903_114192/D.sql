--d)
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
