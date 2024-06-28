--verificaçao do formato do email
CREATE FUNCTION udf_VerificacaoEmail (@email VARCHAR(255)) RETURNS BIT
AS
BEGIN
    DECLARE @Valid BIT;

    --verifiaçoes de formatacao simples
    IF @Email IS NULL
        SET @Valid = 0;
    ELSE IF @Email NOT LIKE '%_@_%._%'
        SET @Valid = 0;
    ELSE IF CHARINDEX(' ', @Email) > 0
        SET @Valid = 0;
    ELSE
        --verificaçoes mais especificas
        BEGIN
            DECLARE @aPosition INT;
            DECLARE @DotPosition INT;
            DECLARE @EmailLength INT;
            
            SET @EmailLength = LEN(@Email);
            SET @aPosition = CHARINDEX('@', @Email);
            SET @DotPosition = CHARINDEX('.', @Email, @aPosition + 1);

            -- verificar que so ha um '@'
            IF @aPosition = 0 OR @aPosition = @EmailLength OR @EmailLength - @aPosition <= 1
                SET @Valid = 0;
            -- verificar a existencia de '.' depois do '@'
            ELSE IF @DotPosition = 0 OR @DotPosition = @EmailLength OR @DotPosition - @aPosition <= 1
                SET @Valid = 0;
            -- verificar que nao ha pontos seguidos nem caracteres invalidos
            ELSE IF @Email LIKE '%..%' OR @Email LIKE '%@%@%' OR @Email LIKE '%[^a-zA-Z0-9@._-]%'
                SET @Valid = 0;
            ELSE
                SET @Valid = 1;
        END;

    RETURN @Valid;
END;
GO

--verificaçao do formato do nome de utilizador
CREATE FUNCTION udf_VerificacaoNome (@Name VARCHAR(120)) RETURNS BIT
AS
BEGIN
    DECLARE @Valid BIT;
	--partimos do principio que é invalido
	SET @Valid = 0;

    --entre 3 e 120 caracteres
    IF LEN(@Name) < 3 OR LEN(@Name) > 120
        RETURN @Valid;
    --tem de começar com uma letra
    IF @Name NOT LIKE '[A-Za-z]%'
		RETURN @Valid;
    --verificaçao de caracteres invalidos
    IF @Name LIKE '%[^a-zA-Z0-9._]%'
        RETURN @Valid;

	SET @Valid = 1;
	RETURN @Valid;
END;
GO

--filtrar jogos por genero
CREATE FUNCTION udf_FiltrarGenero (@genre VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE Genero = @genre
    RETURN;
END;
GO

--filtrar jogos por desenvolvedora
CREATE FUNCTION udf_FiltrarDesenvolvedora (@developer VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE NomeDesenvolvedora = @developer
    RETURN;
END;
GO

--filtrar jogos por editora
CREATE FUNCTION udf_FiltrarEditora (@publisher VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE NomeEditora = @publisher
    RETURN;
END;
GO

--filtrar jogos por plataforma
CREATE FUNCTION udf_FiltrarPlataforma (@platform VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE NomePlataforma = @platform
    RETURN;
END;
GO

--filtrar jogos por rating com >=
CREATE FUNCTION udf_FiltrarRatingGreater (@rating VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE Rating >= @rating
    RETURN;
END;
GO

--filtrar jogos por rating com <
CREATE FUNCTION udf_FiltrarRatingLess (@rating VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Rating DECIMAL(5,2), Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Rating, Imagem FROM infoJogo WHERE Rating < @rating
    RETURN;
END;
GO

--filtrar jogos por reviews com >=
CREATE FUNCTION udf_FiltrarReviewsGreater (@numReviews VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Num_Reviews INT, Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Num_Reviews, Imagem FROM infoJogo WHERE Num_Reviews >= @numReviews
    RETURN;
END;
GO

--filtrar jogos por reviews com <
CREATE FUNCTION udf_FiltrarReviewsLess (@numReviews VARCHAR(120)) RETURNS @table TABLE (ID INT, Nome VARCHAR(120),
Num_Reviews INT, Imagem NVARCHAR(MAX))
AS
BEGIN
    INSERT INTO @table
    SELECT ID, Nome, Num_Reviews, Imagem FROM infoJogo WHERE Num_Reviews < @numReviews
    RETURN;
END;
GO

-- filtrar jogos por data de lancamento com >=
CREATE FUNCTION udf_FiltrarDataLancamentoGreater (
    @ano INT,
    @mes INT = NULL,
    @dia INT = NULL
) RETURNS @table TABLE (
    ID INT,
    Nome VARCHAR(120),
    Data_lancamento DATE,
    Imagem NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @startDate DATE;

    IF @mes IS NULL
    BEGIN
        SET @startDate = CAST(CAST(@ano AS VARCHAR(4)) + '-01-01' AS DATE);
    END
    ELSE IF @dia IS NULL
    BEGIN
        SET @startDate = CAST(CAST(@ano AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(@mes AS VARCHAR(2)), 2) + '-01' AS DATE);
    END
    ELSE
    BEGIN
        SET @startDate = CAST(CAST(@ano AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(@mes AS VARCHAR(2)), 2) + '-' + RIGHT('00' + CAST(@dia AS VARCHAR(2)), 2) AS DATE);
    END

    INSERT INTO @table
    SELECT ID, Nome, Data_lancamento, Imagem
    FROM infoJogo
    WHERE Data_lancamento >= @startDate;

    RETURN;
END;
GO

-- filtrar jogos por data de lancamento com <
CREATE FUNCTION udf_FiltrarDataLancamentoLess (
    @ano INT,
    @mes INT = NULL,
    @dia INT = NULL
) RETURNS @table TABLE (
    ID INT,
    Nome VARCHAR(120),
    Data_lancamento DATE,
    Imagem NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @endDate DATE;

    IF @mes IS NULL
    BEGIN
        SET @endDate = CAST(CAST(@ano AS VARCHAR(4)) + '-01-01' AS DATE);
    END
    ELSE IF @dia IS NULL
    BEGIN
        SET @endDate = CAST(CAST(@ano AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(@mes AS VARCHAR(2)), 2) + '-01' AS DATE);
    END
    ELSE
    BEGIN
        SET @endDate = CAST(CAST(@ano AS VARCHAR(4)) + '-' + RIGHT('00' + CAST(@mes AS VARCHAR(2)), 2) + '-' + RIGHT('00' + CAST(@dia AS VARCHAR(2)), 2) AS DATE);
    END

    INSERT INTO @table
    SELECT ID, Nome, Data_lancamento, Imagem
    FROM infoJogo
    WHERE Data_lancamento < @endDate;

    RETURN;
END;
GO

--escolher a reviews de um determinado jogo
CREATE FUNCTION udf_Reviews (@gameid INT)
RETURNS @table TABLE (
    ID INT,
    Utilizador_ID INT,
    Username VARCHAR(120),
    Comentario VARCHAR(MAX),
    Rating DECIMAL(2,1),
    Data_review DATE,
    Hora TIME,
    Upvotes INT,
    Downvotes INT
)
AS
BEGIN
    INSERT INTO @table
    SELECT
        r.ID,
        r.Utilizador_ID,
        u.Nome AS Username,
        r.Comentario,
        r.Rating,
        r.Data_review,
        r.Hora,
        r.Upvotes,
        r.Downvotes
    FROM
        GameVault_Review r
    JOIN
        GameVault_Utilizador u ON r.Utilizador_ID = u.ID
    WHERE
        r.Jogo_ID = @gameid;
    RETURN;
END;
GO

--escolher as dlc de um determinado jogo
CREATE FUNCTION udf_DLC (@gameid INT) RETURNS @table TABLE (IdDLC INT, NomeDLC VARCHAR(120), TipoDLC VARCHAR(100), Data_lancamento DATE)
AS
BEGIN
    INSERT INTO @table
    SELECT IdDLC, Nome, Tipo, Data_lancamento
    FROM dlc WHERE IdJogo=@gameid
    RETURN;
END;
GO

--escolher os jogos de uma determinada editora
CREATE FUNCTION udf_editoraJogos (@companyid INT) RETURNS @table TABLE (NomeJogo VARCHAR(120), IdJogo INT)
AS
BEGIN
    INSERT INTO @table
    SELECT Nome, ID AS IdJogo
    FROM infoJogo WHERE IdEditora=@companyid
    RETURN;
END;
GO

--escolher os jogos de uma determinada desenvolvedora
CREATE FUNCTION udf_desenvolvedoraJogos (@companyid INT) RETURNS @table TABLE (NomeJogo VARCHAR(120), IdJogo INT)
AS
BEGIN
    INSERT INTO @table
    SELECT Nome, ID AS IdJogo
    FROM infoJogo WHERE IdDesenvolvedora=@companyid
    RETURN;
END;
GO

--escolher os jogos de uma determinada plataforma
CREATE FUNCTION udf_plataformaJogos (@platformid INT) RETURNS @table TABLE (NomeJogo VARCHAR(120), IdJogo INT)
AS
BEGIN
    INSERT INTO @table
    SELECT Nome, ID AS IdJogo
    FROM infoJogo WHERE IdPlataforma=@platformid
    RETURN;
END;
GO

--escolher os jogos de uma determinada loja
CREATE FUNCTION udf_lojaJogos (@storeid INT) RETURNS @table TABLE (NomeJogo VARCHAR(120), IdJogo INT, preco INT)
AS
BEGIN
    INSERT INTO @table
    SELECT NomeJogo, IdJogo, preco
    FROM vender WHERE IdLoja=@storeid
    RETURN;
END;
GO

--respostas de um post especifico
CREATE FUNCTION udf_respostas (@id INT) RETURNS @table TABLE (ID INT, Texto VARCHAR(MAX), Utilizador_ID INT, Nome VARCHAR(120),
	Data_reposta VARCHAR(10), Hora  VARCHAR(5), Upvotes INT, Downvotes INT)
AS
BEGIN
    INSERT INTO @table
    SELECT IdResposta, RespostaTexto, IDRespostaUtilizador, NomeUtilizadorResposta,
    Data_reposta, RespostaHora, Upvotes, Downvotes
    FROM postsReplies
    WHERE IdPost=@id
    RETURN;
END;
GO

--escolher as infos de uma empresa especifica
CREATE FUNCTION udf_empresaInfo (@id INT, @type VARCHAR(10)) RETURNS @table TABLE (Nome VARCHAR(120), Ano_criacao INT, Localizacao VARCHAR(255), numJogos INT)
AS
BEGIN
    INSERT INTO @table
    SELECT Nome, Ano_criacao, Localizacao, numJogos
    FROM empresaInfo WHERE ID=@id AND [type]=@type
    RETURN;
END;
GO

-- obter o voto de um utilizador
CREATE FUNCTION udf_ObterVotoResposta(
    @replyID INT,
    @userID INT) RETURNS INT
AS
BEGIN
    RETURN(
    SELECT
        ISNULL(v.Vote, 0) AS UserVote -- 0 means no vote, 1 means upvoted, -1 means downvoted
    FROM
        GameVault_Resposta r
        JOIN GameVault_Utilizador u ON r.Utilizador_ID = u.ID
        LEFT JOIN GameVault_Resposta_Utilizador_Voto v ON r.ID = v.Resposta_ID AND v.Utilizador_ID = @userID
    WHERE
        r.ID = @replyID)
END
GO

-- obter o voto de um utilizador
CREATE FUNCTION udf_ObterVotoPost(
    @postID INT,
    @userID INT) RETURNS INT
AS
BEGIN
    RETURN(
    SELECT
        ISNULL(v.Vote, 0) AS UserVote -- 0 means no vote, 1 means upvoted, -1 means downvoted
    FROM
        GameVault_Post p
        JOIN GameVault_Utilizador u ON p.Utilizador_ID = u.ID
        LEFT JOIN GameVault_Post_Utilizador_Voto v ON p.ID = v.Post_ID AND v.Utilizador_ID = @userID
    WHERE
        p.ID = @postID)
END
GO
