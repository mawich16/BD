--confirma que o utilizador existe e devolve o seu id
CREATE PROCEDURE sp_AutenticarUtilizador
    @Email VARCHAR(255),
    @Password VARCHAR(255),
    @StaySignedIn BIT,
    @Token VARCHAR(255) OUTPUT,
    @TokenExpiration DATETIME OUTPUT,
    @Username VARCHAR(120) OUTPUT,
    @ID INT OUTPUT,
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @UserNameTemp VARCHAR(120);
    DECLARE @HashedPassword NVARCHAR(255);

    SET @HashedPassword = CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', @Password), 2);
    SELECT @ID = ID, @UserNameTemp = Nome FROM GameVault_Utilizador WHERE Email = @Email AND Password = @HashedPassword;

    IF @ID IS NOT NULL
    BEGIN
        SET @Token = NEWID();

        IF @StaySignedIn = 1
        BEGIN
            SET @TokenExpiration = DATEADD(MONTH, 1, GETDATE());
        END
        ELSE
        BEGIN
            SET @TokenExpiration = DATEADD(HOUR, 1, GETDATE());
        END
        
        UPDATE GameVault_Utilizador
        SET Token = @Token, TokenExpiration = @TokenExpiration
        WHERE ID = @ID;

        SET @Username = @UserNameTemp;
        SET @ErrorMessage = NULL;
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Invalid credentials';
    END
END
GO

-- inserir novo utilizador
CREATE PROCEDURE sp_InserirUtilizador
    @Username VARCHAR(120),
    @Password VARCHAR(255),
    @Email VARCHAR(120),
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @date DATE = CURRENT_TIMESTAMP;
    DECLARE @emailVerification INT;
    DECLARE @nameVerification INT;
    DECLARE @HashedPassword NVARCHAR(255);

    BEGIN TRANSACTION;

    BEGIN TRY
        EXEC @emailVerification = udf_VerificacaoEmail @Email;
        EXEC @nameVerification = udf_VerificacaoNome @Username;

        IF @emailVerification = 0
        BEGIN
            SET @ErrorMessage = 'Invalid email format.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        ELSE IF @nameVerification = 0
        BEGIN
            SET @ErrorMessage = 'Invalid username format.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        ELSE
        BEGIN
            IF EXISTS (SELECT ID FROM GameVault_Utilizador WHERE Email = @Email)
            BEGIN
                SET @ErrorMessage = 'Email already in use.';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            ELSE IF EXISTS (SELECT ID FROM GameVault_Utilizador WHERE Nome = @Username)
            BEGIN
                SET @ErrorMessage = 'Username already in use.';
                ROLLBACK TRANSACTION;
                RETURN;
            END
            ELSE
            BEGIN
                SET @HashedPassword = CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', @Password), 2);
                INSERT INTO GameVault_Utilizador (Nome, Email, Data_adesao, [Password])
                VALUES (@Username, @Email, @date, @HashedPassword);
                SET @ErrorMessage = 'User added successfully';
                COMMIT TRANSACTION;
                RETURN;
            END
        END
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = 'An error occurred: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
        RETURN;
    END CATCH
END;
GO

--remover utilizador
CREATE PROCEDURE sp_RemoverUtilizador (@id INT)
AS
BEGIN
	BEGIN TRY;
	IF EXISTS (SELECT ID FROM GameVault_Utilizador WHERE ID = @id)
	BEGIN
	DELETE FROM GameVault_Utilizador WHERE ID = @id;
	PRINT 'Utilizador removido com sucesso.';
	END

	END TRY
	BEGIN CATCH
    PRINT 'Utilizador nao existente'
    END CATCH
END;
GO

--alterar infos de um utilizador
CREATE PROCEDURE sp_AlterarUtilizador
    @Username VARCHAR(120),
    @Userpassword VARCHAR(255),
    @Useremail VARCHAR(120),
    @id INT,
    @NewToken VARCHAR(255) OUTPUT,
    @TokenExpiration DATETIME OUTPUT
AS
BEGIN
    DECLARE @nome VARCHAR(120), @password VARCHAR(255), @email VARCHAR(120);

    SELECT @nome=Nome, @password=[Password], @email=Email
    FROM GameVault_Utilizador
    WHERE ID = @id;

    PRINT @nome;
    PRINT @password;
    PRINT @email;

    DECLARE @nameVerification INT;
    EXEC @nameVerification = udf_VerificacaoNome @Username

    BEGIN TRANSACTION;
    BEGIN TRY
        IF (@nome <> @Username AND @Username IS NOT NULL)
        BEGIN
            IF @nameVerification = 0
                PRINT 'Nome de Utilizador invalido: deve conter entre 3 a 120 caracteres, começar com uma letra e só pode conter letras, números e "." e "_" não consecutivos';
            ELSE
            BEGIN
                UPDATE GameVault_Utilizador SET Nome = @Username WHERE ID = @id;
                PRINT 'nome alterado com sucesso';
            END
        END

        IF (@password <> @Userpassword AND @Userpassword IS NOT NULL)
        BEGIN
            UPDATE GameVault_Utilizador SET [Password] = @Userpassword WHERE ID = @id;
            PRINT 'password alterada com sucesso';
        END

        DECLARE @emailVerification INT;
        EXEC @emailVerification = udf_VerificacaoEmail @Useremail

        IF (@email <> @Useremail AND @Useremail IS NOT NULL)
        BEGIN
            IF @emailVerification = 0
                PRINT 'Email invalido';
            ELSE
            BEGIN
                UPDATE GameVault_Utilizador SET Email = @Useremail WHERE ID = @id;
                PRINT 'email alterado com sucesso';
            END
        END

        SET @NewToken = NULL;
        SET @TokenExpiration = GETDATE();

        UPDATE GameVault_Utilizador
        SET Token = @NewToken, TokenExpiration = @TokenExpiration
        WHERE ID = @id;

        PRINT 'Token expirado com sucesso';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Erro ao atualizar informações do usuário';
    END CATCH
END;
GO

--apresentar os jogos por ordem alfabetica
CREATE PROCEDURE sp_OrdemAlfabetica
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Nome;
END;
GO

--apresentar os jogos por ordem alfabetica oposta
CREATE PROCEDURE sp_OrdemAlfabeticaDesc
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Nome DESC;
END;
GO

--apresentar os jogos por ordem de lancamento
CREATE PROCEDURE sp_OrdemData
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Data_lancamento;
END;
GO

--apresentar os jogos por ordem de lancamento desc
CREATE PROCEDURE sp_OrdemDataDesc
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Data_lancamento DESC;
END;
GO

--apresentar os jogos por ordem de rating less to more
CREATE PROCEDURE sp_OrdemRatingDesc
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Rating;
END;
GO

--apresentar os jogos por ordem de rating more to less
CREATE PROCEDURE sp_OrdemRating
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Rating DESC;
END;
GO

--apresentar os jogos por ordem de crescente de reviews
CREATE PROCEDURE sp_OrdemNumReviews
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Num_Reviews;
END;
GO

--apresentar os jogos por ordem de decrescente de reviews
CREATE PROCEDURE sp_OrdemNumReviewsDesc
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM infoJogo
    WHERE ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
    ORDER BY Num_Reviews DESC;
END;
GO

-- pesquisar jogos por nome
CREATE PROCEDURE sp_PesquisarJogo
    @query NVARCHAR(255)
AS
BEGIN
    SELECT * FROM infoJogo
    WHERE Nome LIKE '%' + @query + '%'
END
GO

-- apresentar 9 jogos aleatorios
CREATE PROCEDURE sp_JogosAleatorios
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 9 *
    FROM infoJogo
    ORDER BY NEWID()
END
GO

--inserir uma review
CREATE PROCEDURE sp_InserirReview (
    @comment VARCHAR(MAX),
    @ID INT,
    @gameID INT,
    @rating DECIMAL(2,1),
    @ErrorMessage NVARCHAR(255) OUTPUT
)
AS
BEGIN
    DECLARE @date DATE = CURRENT_TIMESTAMP;
    DECLARE @time TIME = CURRENT_TIMESTAMP;

    IF LEN(@comment) = 0
        SET @ErrorMessage = 'Comment cannot be empty';

    ELSE IF @rating = 0 OR @rating IS NULL OR @rating > 5 OR @rating < 0
        SET @ErrorMessage = 'Rating must be between 0 and 5';

    ELSE
    BEGIN
        INSERT INTO GameVault_Review (Comentario, Utilizador_ID, Data_review, Hora, Jogo_ID, Rating)
        VALUES (@comment, @ID, @date, @time, @gameID, @rating);
        SET @ErrorMessage = 'Review added successfully!';
    END
END
GO

--remover uma review
CREATE PROCEDURE sp_RemoverReview (@reviewID INT)
AS
BEGIN
	IF EXISTS (SELECT ID FROM GameVault_Review WHERE ID = @reviewID)
	BEGIN
	DELETE FROM GameVault_Review WHERE ID = @reviewID;
	PRINT 'Review removida com sucesso';
	END
END;
GO

-- pesquisar empresas por nome
CREATE PROCEDURE sp_Pesquisarempresas
    @query NVARCHAR(255)
AS
BEGIN
    SELECT * FROM empresaInfo
    WHERE NomeEmpresa LIKE '%' + @query + '%'
END
GO

-- apresentar empresas em ordem aleatorias
CREATE PROCEDURE sp_EmpresasAleatorias
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 9 *
    FROM empresaInfo
    ORDER BY NEWID()
END
GO

--apresentar as empresas que sao desenvolvedoras
CREATE PROCEDURE sp_EmpresasDesenvolvedoras @ids NVARCHAR(MAX)
AS
BEGIN
	SELECT *
	FROM empresaInfo
	WHERE [type]='D' AND ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
END
GO

--apresentar as empresas que sao editoras
CREATE PROCEDURE sp_EmpresasEditoras @ids NVARCHAR(MAX)
AS
BEGIN
	SELECT *
	FROM empresaInfo
	WHERE [type]='E' AND ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
END
GO

--apresentar as empresas que sao plataformas
CREATE PROCEDURE sp_EmpresasPlataformas @ids NVARCHAR(MAX)
AS
BEGIN
	SELECT *
	FROM empresaInfo
	WHERE [type]='P' AND ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
END
GO

--apresentar as empresas que sao lojas
CREATE PROCEDURE sp_EmpresasLojas @ids NVARCHAR(MAX)
AS
BEGIN
	SELECT *
	FROM empresaInfo
	WHERE [type]='L' AND ID IN (SELECT value FROM STRING_SPLIT(@ids, ','))
END
GO

-- x jogos com melhor rating
CREATE PROCEDURE sp_TopRatedGames
    @NumberOfGames INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@NumberOfGames) *
    FROM infoJogo
    ORDER BY Rating DESC, Num_Reviews DESC;
END;
GO

-- validacao do token
CREATE PROCEDURE sp_ValidateToken
    @Token VARCHAR(255),
    @ID INT OUTPUT
AS
BEGIN
    -- Validate the token and check if it is not expired
    SELECT @ID = ID FROM GameVault_Utilizador WHERE Token = @Token AND TokenExpiration > GETDATE();
    
    IF @ID IS NULL
    BEGIN
        SET @ID = 0;
    END
END
GO

-- obter informacao de um jogo
CREATE PROCEDURE sp_GameInfo
    @GameID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM infoJogo 
    WHERE ID = @GameID;
END
GO

--escolher as empresas de um determinado jogo
CREATE PROCEDURE sp_jogoEmpresas (@query NVARCHAR(255))
AS
BEGIN
    DECLARE @table TABLE (ID INT, Nome VARCHAR(120), Num_Reviews INT, Rating DECIMAL(2,1), Genero VARCHAR(120), Data_lancamento DATE, Descricao VARCHAR(MAX), Imagem VARCHAR(MAX),
    NomeEditora VARCHAR(120), IdEditora VARCHAR(120), NomeDesenvolvedora VARCHAR(120), IdDesenvolvedora int, NomePlataforma VARCHAR(120), IdPlataforma INT)

    INSERT @table EXEC sp_PesquisarJogo @query

    DECLARE @storeID INT

    SET @storeID = (SELECT IdLoja FROM vender WHERE (SELECT ID FROM @table) = IdJogo)

    SELECT * FROM empresaInfo WHERE [type]='E' AND ID IN (SELECT IdEditora FROM @table)
    UNION
    SELECT * FROM empresaInfo WHERE [type]='D' AND ID IN (SELECT IdDesenvolvedora FROM @table)
    UNION
    SELECT * FROM empresaInfo WHERE [type]='P' AND ID IN (SELECT IdPlataforma FROM @table)
    UNION
    SELECT * FROM empresaInfo WHERE [type]='L' AND ID = @storeID
END
GO

-- escolher respostas de um post especifico
CREATE PROCEDURE sp_RespostasPost
    @postID INT
AS
BEGIN
    SELECT *
    FROM posts
    WHERE IdPost = @postID;
END
GO

-- apresentar 10 posts mais recentes
CREATE PROCEDURE sp_PostsTop10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10 *
    FROM posts
    ORDER BY Data_post DESC
END
GO

-- pesquisar posts por titulo
CREATE PROCEDURE sp_PesquisarPosts
    @query NVARCHAR(255)
AS
BEGIN
    SELECT * FROM posts
    WHERE PostTitulo LIKE '%' + @query + '%'
END
GO

--apresentar os posts por ordem crescente de replies
CREATE PROCEDURE sp_OrdemCrescenteReplies
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM posts
    WHERE IdPost IN (SELECT VALUE FROM STRING_SPLIT(@ids, ','))
    ORDER BY NumRespostas
END
GO

--apresentar os posts por ordem decrescente de replies
CREATE PROCEDURE sp_OrdemDecrescenteReplies
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM posts
    WHERE IdPost IN (SELECT VALUE FROM STRING_SPLIT(@ids, ','))
    ORDER BY NumRespostas DESC
END
GO

--apresentar os posts por ordem de lancamento
CREATE PROCEDURE sp_OrdemDataPosts
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM posts
    WHERE IdPost IN (SELECT VALUE FROM STRING_SPLIT(@ids, ','))
    ORDER BY Data_post
END
GO

--apresentar os posts por ordem de lancamento descendente
CREATE PROCEDURE sp_OrdemDataDescPosts
    @ids NVARCHAR(MAX)
AS
BEGIN
    SELECT *
    FROM posts
    WHERE IdPost IN (SELECT VALUE FROM STRING_SPLIT(@ids, ','))
    ORDER BY Data_post DESC
END
GO

--inserir um post
CREATE PROCEDURE sp_InserirPost (
    @title VARCHAR(255),
    @userID INT,
    @content VARCHAR(MAX),
    @ErrorMessage NVARCHAR(255) OUTPUT
)
AS
BEGIN
    DECLARE @date DATE = CURRENT_TIMESTAMP;
    DECLARE @time TIME = CURRENT_TIMESTAMP;

    IF LEN(@content) = 0
        SET @ErrorMessage = 'Content cannot be empty';

    IF LEN(@title) = 0
        SET @ErrorMessage = 'Title cannot be empty';

    ELSE
    BEGIN
        INSERT INTO GameVault_Post (Texto, Utilizador_ID, Data_post, Hora, Titulo)
        VALUES (@content, @userID, @date, @time, @title);
        SET @ErrorMessage = 'Post added successfully!';
    END
END
GO

--inserir uma resposta
CREATE PROCEDURE sp_InserirResposta (
    @postID INT,
    @userID INT,
    @content VARCHAR(MAX),
    @ErrorMessage NVARCHAR(255) OUTPUT
)
AS
BEGIN
    DECLARE @date DATE = CURRENT_TIMESTAMP;
    DECLARE @time TIME = CURRENT_TIMESTAMP;

    IF LEN(@content) = 0
        SET @ErrorMessage = 'Content cannot be empty';

    ELSE
    BEGIN
        INSERT INTO GameVault_Resposta (Texto, Utilizador_ID, Data_reposta, Hora,Post_ID)
        VALUES (@content, @userID, @date, @time, @postID);
        SET @ErrorMessage = 'Reply added successfully!';
    END
END
GO

-- editar uma review
CREATE PROCEDURE sp_EditarReview
    @ReviewID INT,
    @UserID INT,
    @Comment VARCHAR(MAX),
    @Rating DECIMAL(2,1),
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF LEN(@Comment) = 0
        SET @ErrorMessage = 'Comment cannot be empty';

    ELSE IF @Rating = 0 OR @Rating IS NULL OR @Rating > 5 OR @Rating < 0
        SET @ErrorMessage = 'Rating must be between 0 and 5';

    ELSE IF EXISTS (SELECT 1 FROM GameVault_Review WHERE ID = @ReviewID AND Utilizador_ID = @UserID)
    BEGIN
        UPDATE GameVault_Review
        SET Comentario = @Comment, Rating = @Rating
        WHERE ID = @ReviewID

        SET @ErrorMessage = 'Review updated successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or review not found.'
    END
END
GO

-- apagar uma review
CREATE PROCEDURE sp_ApagarReview
    @ReviewID INT,
    @UserID INT,
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF EXISTS (SELECT 1 FROM GameVault_Review WHERE ID = @ReviewID AND Utilizador_ID = @UserID)
    BEGIN
        DELETE FROM GameVault_Review WHERE ID = @ReviewID
        SET @ErrorMessage = 'Review deleted successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or review not found.'
    END
END
GO

-- dar upvote numa review
CREATE PROCEDURE sp_UpvoteReview
    @ReviewID INT,
    @UserID INT,
    @Message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Review_Utilizador_Voto
    WHERE Review_ID = @ReviewID AND User_ID = @UserID;

    IF @CurrentVote IS NULL
    BEGIN
        INSERT INTO GameVault_Review_Utilizador_Voto (Review_ID, User_ID, Vote)
        VALUES (@ReviewID, @UserID, 1);

        UPDATE GameVault_Review
        SET Upvotes = Upvotes + 1
        WHERE ID = @ReviewID;

        SET @Message = 'Upvoted successfully!';
    END
    ELSE IF @CurrentVote = -1
    BEGIN
        UPDATE GameVault_Review_Utilizador_Voto
        SET Vote = 1
        WHERE Review_ID = @ReviewID AND User_ID = @UserID;

        UPDATE GameVault_Review
        SET Upvotes = Upvotes + 1,
            Downvotes = Downvotes - 1
        WHERE ID = @ReviewID;

        SET @Message = 'Vote changed to upvote!';
    END
    ELSE
    BEGIN
        DELETE FROM GameVault_Review_Utilizador_Voto
        WHERE Review_ID = @ReviewID AND User_ID = @UserID;

        UPDATE GameVault_Review
        SET Upvotes = Upvotes - 1
        WHERE ID = @ReviewID;

        SET @Message = 'Upvote removed!';
    END
END
GO

-- dar downvote numa review
CREATE PROCEDURE sp_DownvoteReview
    @ReviewID INT,
    @UserID INT,
    @Message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Review_Utilizador_Voto
    WHERE Review_ID = @ReviewID AND User_ID = @UserID;

    IF @CurrentVote IS NULL
    BEGIN
        INSERT INTO GameVault_Review_Utilizador_Voto (Review_ID, User_ID, Vote)
        VALUES (@ReviewID, @UserID, -1);

        UPDATE GameVault_Review
        SET Downvotes = Downvotes + 1
        WHERE ID = @ReviewID;

        SET @Message = 'Downvoted successfully!';
    END
    ELSE IF @CurrentVote = 1
    BEGIN
        UPDATE GameVault_Review_Utilizador_Voto
        SET Vote = -1
        WHERE Review_ID = @ReviewID AND User_ID = @UserID;

        UPDATE GameVault_Review
        SET Upvotes = Upvotes - 1,
            Downvotes = Downvotes + 1
        WHERE ID = @ReviewID;

        SET @Message = 'Vote changed to downvote!';
    END
    ELSE
    BEGIN
        DELETE FROM GameVault_Review_Utilizador_Voto
        WHERE Review_ID = @ReviewID AND User_ID = @UserID;

        UPDATE GameVault_Review
        SET Downvotes = Downvotes - 1
        WHERE ID = @ReviewID;

        SET @Message = 'Downvote removed!';
    END
END
GO

-- dar upvote num post
CREATE PROCEDURE sp_UpvotePost
    @postID INT,
    @userID INT,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Post_Utilizador_Voto
    WHERE Post_ID = @postID AND Utilizador_ID = @userID;

    IF @CurrentVote IS NULL
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO GameVault_Post_Utilizador_Voto (Post_ID, Utilizador_ID, Vote)
            VALUES (@postID, @userID, 1);

            UPDATE GameVault_Post
            SET Upvotes = Upvotes + 1
            WHERE ID = @postID;

            SET @message = 'Upvoted successfully!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to upvote';
        END CATCH
    END

    ELSE IF @CurrentVote = -1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE GameVault_Post_Utilizador_Voto
            SET Vote = 1
            WHERE Post_ID = @postID AND Utilizador_ID = @userID;

            UPDATE GameVault_Post
            SET Upvotes = Upvotes + 1,
                Downvotes = Downvotes - 1
            WHERE ID = @postID;

            SET @message = 'Vote changed to upvote!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to change to upvote';
        END CATCH
    END

    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            DELETE FROM GameVault_Post_Utilizador_Voto
            WHERE Post_ID = @postID AND Utilizador_ID = @userID;

            UPDATE GameVault_Post
            SET Upvotes = Upvotes - 1
            WHERE ID = @postID;

            SET @message = 'Upvote removed!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to remove upvote';
        END CATCH
    END
END
GO

-- dar downvote numa post
CREATE PROCEDURE sp_DownvotePost
    @postID INT,
    @userID INT,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Post_Utilizador_Voto
    WHERE Post_ID = @postID AND Utilizador_ID = @userID;

    IF @CurrentVote IS NULL
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO GameVault_Post_Utilizador_Voto (Post_ID, Utilizador_ID, Vote)
            VALUES (@postID, @userID, -1);

            UPDATE GameVault_Post
            SET Downvotes = Downvotes + 1
            WHERE ID = @postID;

            SET @message = 'Downvoted successfully!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to downvote';
        END CATCH
    END

    ELSE IF @CurrentVote = 1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE GameVault_Post_Utilizador_Voto
            SET Vote = -1
            WHERE Post_ID = @postID AND Utilizador_ID = @userID;

            UPDATE GameVault_Post
            SET Upvotes = Upvotes - 1,
                Downvotes = Downvotes + 1
            WHERE ID = @postID;

            SET @message = 'Vote changed to downvote!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to change to downvote';
        END CATCH
    END

    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            DELETE FROM GameVault_Post_Utilizador_Voto
            WHERE Post_ID = @postID AND Utilizador_ID = @userID;

            UPDATE GameVault_Post
            SET Downvotes = Downvotes - 1
            WHERE ID = @postID;

            SET @message = 'Downvote removed!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to remove downvote';
        END CATCH
    END
END
GO


-- dar upvote numa resposta
CREATE PROCEDURE sp_UpvoteResposta
    @replyID INT,
    @userID INT,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Resposta_Utilizador_Voto
    WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

    IF @CurrentVote IS NULL
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO GameVault_Resposta_Utilizador_Voto (Resposta_ID, Utilizador_ID, Vote)
            VALUES (@replyID, @userID, 1);

            UPDATE GameVault_Resposta
            SET Upvotes = Upvotes + 1
            WHERE ID = @replyID;

            SET @message = 'Upvoted successfully!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to upvote';
        END CATCH
    END

    ELSE IF @CurrentVote = -1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE GameVault_Resposta_Utilizador_Voto
            SET Vote = 1
            WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

            UPDATE GameVault_Resposta
            SET Upvotes = Upvotes + 1,
                Downvotes = Downvotes - 1
            WHERE ID = @replyID;

            SET @message = 'Vote changed to upvote!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to change to upvote';
        END CATCH
    END

    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            DELETE FROM GameVault_Resposta_Utilizador_Voto
            WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

            UPDATE GameVault_Resposta
            SET Upvotes = Upvotes - 1
            WHERE ID = @replyID;

            SET @message = 'Upvote removed!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to remove upvote';
        END CATCH
    END
END
GO

-- dar downvote numa resposta
CREATE PROCEDURE sp_DownvoteResposta
    @replyID INT,
    @userID INT,
    @message NVARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @CurrentVote INT;

    SELECT @CurrentVote = Vote FROM GameVault_Resposta_Utilizador_Voto
    WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

    IF @CurrentVote IS NULL
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO GameVault_Resposta_Utilizador_Voto (Resposta_ID, Utilizador_ID, Vote)
            VALUES (@replyID, @userID, -1);

            UPDATE GameVault_Resposta
            SET Downvotes = Downvotes + 1
            WHERE ID = @replyID;

            SET @message = 'Downvoted successfully!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to downvote';
        END CATCH
    END

    ELSE IF @CurrentVote = 1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE GameVault_Resposta_Utilizador_Voto
            SET Vote = -1
            WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

            UPDATE GameVault_Resposta
            SET Upvotes = Upvotes - 1,
                Downvotes = Downvotes + 1
            WHERE ID = @replyID;

            SET @message = 'Vote changed to downvote!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to change to downvote';
        END CATCH
    END

    ELSE
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            DELETE FROM GameVault_Resposta_Utilizador_Voto
            WHERE Resposta_ID = @replyID AND Utilizador_ID = @userID;

            UPDATE GameVault_Resposta
            SET Downvotes = Downvotes - 1
            WHERE ID = @replyID;

            SET @message = 'Downvote removed!';

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @message = 'Error not possible to remove downvote';
        END CATCH
    END
END
GO


-- obter o voto de um utilizador
CREATE PROCEDURE sp_ObterVotoReview
    @GameID INT,
    @UserID INT
AS
BEGIN
    SELECT
        r.ID,
        r.Comentario,
        r.Utilizador_ID,
        r.Data_review,
        r.Hora,
        r.Jogo_ID,
        r.Rating,
        r.Upvotes,
        r.Downvotes,
        u.Nome,
        ISNULL(v.Vote, 0) AS UserVote -- 0 means no vote, 1 means upvoted, -1 means downvoted
    FROM
        GameVault_Review r
        JOIN GameVault_Utilizador u ON r.Utilizador_ID = u.ID
        LEFT JOIN GameVault_Review_Utilizador_Voto v ON r.ID = v.Review_ID AND v.User_ID = @UserID
    WHERE
        r.Jogo_ID = @GameID
    ORDER BY r.Data_review DESC, r.Hora DESC;
END
GO

-- editar uma resposta
CREATE PROCEDURE sp_EditarResposta
    @replyID INT,
    @userID INT,
    @text VARCHAR(MAX),
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF LEN(@text) = 0
        SET @ErrorMessage = 'Text cannot be empty';

    ELSE IF EXISTS (SELECT 1 FROM GameVault_Resposta WHERE ID = @replyID AND Utilizador_ID = @UserID)
    BEGIN
        UPDATE GameVault_Resposta
        SET Texto = @text
        WHERE ID = @replyID

        SET @ErrorMessage = 'Reply updated successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or reply not found.'
    END
END
GO

-- apagar uma resposta
CREATE PROCEDURE sp_ApagarResposta
    @replyID INT,
    @userID INT,
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF EXISTS (SELECT 1 FROM GameVault_Resposta WHERE ID = @replyID AND Utilizador_ID = @userID)
    BEGIN
        DELETE FROM GameVault_Resposta WHERE ID = @replyID
        SET @ErrorMessage = 'Reply deleted successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or reply not found.'
    END
END
GO

-- editar um post
CREATE PROCEDURE sp_EditarPost
    @postID INT,
    @userID INT,
    @text VARCHAR(MAX),
    @title VARCHAR(255),
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF LEN(@text) = 0
        SET @ErrorMessage = 'Text cannot be empty';

    ELSE IF LEN(@title) = 0
        SET @ErrorMessage = 'Title cannot be empty';

    ELSE IF EXISTS (SELECT 1 FROM GameVault_Post WHERE ID = @postID AND Utilizador_ID = @userID)
    BEGIN
        UPDATE GameVault_Post
        SET Texto = @text, Titulo = @title
        WHERE ID = @postID

        SET @ErrorMessage = 'Post updated successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or post not found.'
    END
END
GO

-- apagar um post
CREATE PROCEDURE sp_ApagarPost
    @postID INT,
    @userID INT,
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET @ErrorMessage = ''

    IF EXISTS (SELECT 1 FROM GameVault_Post WHERE ID = @postID AND Utilizador_ID = @userID)
    BEGIN
        DELETE FROM GameVault_Post WHERE ID = @postID
        SET @ErrorMessage = 'Post deleted successfully!'
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Unauthorized action or post not found.'
    END
END
GO
