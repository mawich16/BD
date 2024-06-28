--trigger para quando apagar um user e os seus posts nao serem apagados, passam para um user default
CREATE TRIGGER trg_DeleteUser
ON GameVault_Utilizador
INSTEAD OF DELETE
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT ID FROM Deleted) IN (SELECT Utilizador_ID FROM GameVault_Resposta)
                UPDATE GameVault_Resposta
                SET Utilizador_ID = 1 WHERE Utilizador_ID = (SELECT ID FROM Deleted)

            IF (SELECT ID FROM Deleted) IN (SELECT Utilizador_ID FROM GameVault_Post)
                UPDATE GameVault_Post
                SET Utilizador_ID = 1 WHERE Utilizador_ID = (SELECT ID FROM Deleted)

            IF (SELECT ID FROM Deleted) IN (SELECT Utilizador_ID FROM GameVault_Review)
                UPDATE GameVault_Review
                SET Utilizador_ID = 1 WHERE Utilizador_ID = (SELECT ID FROM Deleted)

            DELETE FROM GameVault_Utilizador WHERE ID=(SELECT ID FROM Deleted)
            PRINT 'User deleted sucessfully';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT 'Couldnt delete user';
        ROLLBACK TRANSACTION;
        RETURN;
    END CATCH
END;
GO
