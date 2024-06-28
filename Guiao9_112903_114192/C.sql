--c)
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

