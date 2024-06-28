-- a)
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