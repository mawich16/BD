--view com infos do user
CREATE VIEW perfiles AS
	SELECT u.ID, u.Nome, COALESCE(r.Num_Reviews, 0) AS Num_Reviews, COALESCE(p.Num_Posts, 0) AS Num_Posts,
	COALESCE(rs.Num_Respostas, 0) AS Num_Respostas
	FROM GameVault_Utilizador AS u
	LEFT JOIN
    (SELECT Utilizador_ID, COUNT(ID) AS Num_Reviews FROM GameVault_Review GROUP BY Utilizador_ID) AS r
    ON u.ID = r.Utilizador_ID
	LEFT JOIN
    (SELECT Utilizador_ID, COUNT(ID) AS Num_Posts FROM GameVault_Post GROUP BY Utilizador_ID) AS p
    ON u.ID = p.Utilizador_ID
	LEFT JOIN
    (SELECT Utilizador_ID, COUNT(ID) AS Num_Respostas FROM GameVault_Resposta GROUP BY Utilizador_ID) AS rs
    ON u.ID = rs.Utilizador_ID
GO

--view com informaçao completa do jogo
CREATE VIEW infoJogo AS
    SELECT j.ID, j.Nome, r.Num_Reviews, r.Rating, gn.Genero, j.Data_lancamento, j.Descricao, j.Imagem,
    emp.NomeEditora, emp.IdEditora, dsv.NomeDesenvolvedora, dsv.IdDesenvolvedora,
    pl.NomePlataforma, pl.IdPlataforma
    FROM GameVault_Jogo AS j
    JOIN
    (SELECT Jogo_ID, COUNT(Jogo_ID) AS Num_Reviews, AVG(Rating) AS Rating
    FROM GameVault_Review
    GROUP BY Jogo_ID) AS r
    ON r.Jogo_ID = j.ID
    JOIN
    (SELECT g.Nome AS Genero, j.Nome AS NomeJogo, j.ID AS IdJogo
    FROM GameVault_Genero AS g
    JOIN GameVault_Jogo_Genero AS jg
    ON g.ID=jg.Genero_ID
    JOIN GameVault_Jogo AS j
    ON jg.Jogo_ID=j.ID) AS gn
    ON gn.IdJogo = j.ID
    JOIN
    (SELECT em.Nome AS NomeEditora, em.ID AS IdEditora, j.Nome AS NomeJogo, j.ID AS IdJogo
    FROM GameVault_Empresa AS em
    JOIN GameVault_Publica AS p
    ON em.ID=p.Editora_ID
    JOIN GameVault_Jogo AS j
    on p.Jogo_ID=j.ID) AS emp
    ON emp.IdJogo = j.ID
    JOIN
    (SELECT em.Nome AS NomeDesenvolvedora, em.ID AS IdDesenvolvedora, j.Nome AS NomeJogo, j.ID AS IdJogo
    FROM GameVault_Empresa AS em
    JOIN GameVault_Desenvolve AS d
    ON em.ID=d.Desenvolvedora_ID
    JOIN GameVault_Jogo AS j
    ON d.Jogo_ID=j.ID) AS dsv
    ON dsv.IdJogo = j.ID
    JOIN
    (SELECT p.Nome AS NomePlataforma, p.ID AS IdPlataforma, j.Nome AS NomeJogo, j.ID AS IdJogo
    FROM GameVault_Plataforma AS p
    JOIN GameVault_Disponibiliza AS d
    ON p.ID=d.Plataforma_ID
    JOIN GameVault_Jogo AS j
    ON d.Jogo_ID=j.ID) AS pl
    ON pl.IdJogo = j.ID
GO

--view lojas e respetivos jogos
CREATE VIEW vender AS
    SELECT v.Preco, l.Nome AS NomeLoja, l.ID AS IdLoja, j.Nome AS NomeJogo, j.ID AS IdJogo
    FROM GameVault_Loja AS l
    JOIN GameVault_Vende AS v
    ON l.ID=v.Loja_ID
    JOIN GameVault_Jogo AS j
    ON v.Jogo_ID=j.ID
GO

CREATE VIEW nomeDesenvolvedora AS
    SELECT
    d.Empresa_ID AS IdDesenvolvedora,
    e.Nome AS NomeDesenvolvedora
    FROM
    GameVault_Desenvolvedora AS d
    JOIN
    GameVault_Empresa AS e ON d.Empresa_ID = e.ID;
GO

CREATE VIEW nomeEditora AS
    SELECT
    p.Empresa_ID AS IdEditora,
    e.Nome AS NomeEditora
    FROM
    GameVault_Editora AS p
    JOIN
    GameVault_Empresa AS e ON p.Empresa_ID = e.ID;
GO

--view empresas + plataforma + lojas e numero de jogos associados + info
CREATE VIEW empresaInfo AS
    SELECT emp.Nome, emp.ID, emp.Ano_criacao, emp.Localizacao, COUNT(j.ID) AS numJogos, 'D' AS [type]
    FROM GameVault_Empresa AS emp
    JOIN GameVault_Desenvolve AS p
    ON emp.ID=p.Desenvolvedora_ID
    JOIN GameVault_Jogo AS j
    On p.Jogo_ID=j.ID
    GROUP BY emp.Nome,emp.ID, emp.Ano_criacao, emp.Localizacao
    UNION
    SELECT emp.Nome, emp.ID, emp.Ano_criacao, emp.Localizacao, COUNT(j.ID) AS numJogos, 'E' AS [type]
    FROM GameVault_Empresa AS emp
    JOIN GameVault_Publica AS p
    ON emp.ID=p.Editora_ID
    JOIN GameVault_Jogo AS j
    On p.Jogo_ID=j.ID
    GROUP BY emp.Nome,emp.ID, emp.Ano_criacao, emp.Localizacao
    UNION
    SELECT p.Nome, p.ID,NULL AS Ano_criacao, NULL AS Localizacao, COUNT(j.ID) AS numJogos, 'P' AS [type]
    FROM GameVault_Disponibiliza AS d
    JOIN GameVault_Plataforma AS p
    ON p.ID=d.Plataforma_ID
    JOIN GameVault_Jogo AS j
    On d.Jogo_ID=j.ID
    GROUP BY p.Nome,p.ID
    UNION
    SELECT l.Nome, l.ID,NULL AS Ano_criacao, NULL AS Localizacao, COUNT(j.ID) AS numJogos, 'L' AS [type]
    FROM GameVault_Loja AS l
    JOIN GameVault_Vende AS v
    ON l.ID=v.Loja_ID
    JOIN GameVault_Jogo AS j
    ON v.Jogo_ID=j.ID
    GROUP BY l.Nome,l.ID
GO

--view post e informacoes
CREATE VIEW posts AS
    SELECT 	p.ID AS IdPost, p.Texto AS PostTexto, p.Utilizador_ID AS IDPostUtilizador, u.Nome AS NomeUtilizadorPost, FORMAT(p.Data_post, 'dd-MM-yyyy') AS Data_post,
    Convert(VARCHAR(5), p.Hora, 108) AS PostHora, p.Titulo AS PostTitulo, COALESCE(COUNT(r.ID), 0) AS NumRespostas, ISNULL(p.Upvotes, 0) AS Upvotes,
    ISNULL(p.Downvotes, 0) AS Downvotes
    FROM GameVault_Post AS p
    JOIN GameVault_Utilizador AS u
    ON p.Utilizador_ID=u.ID
    LEFT JOIN GameVault_Resposta AS r
    ON p.ID=r.Post_ID
    GROUP BY p.ID, p.Texto, p.Utilizador_ID, u.Nome, FORMAT(p.Data_post, 'dd-MM-yyyy'),
    Convert(VARCHAR(5), p.Hora, 108), p.Titulo, p.Downvotes, p.Upvotes
GO

--view post e respetivas replies
CREATE VIEW postsReplies AS
    SELECT 	p.ID AS IdPost, r.ID AS IdResposta,
	r.Texto AS RespostaTexto, r.Utilizador_ID AS IDRespostaUtilizador, ut.Nome AS NomeUtilizadorResposta,
    FORMAT(r.Data_reposta, 'dd-MM-yyyy') AS Data_reposta, Convert(VARCHAR(5), r.Hora, 108) AS RespostaHora,
    ISNULL(r.Upvotes, 0) AS Upvotes, ISNULL(r.Downvotes, 0) AS Downvotes
    FROM GameVault_Post AS p
    JOIN GameVault_Resposta AS r
    ON p.ID=r.Post_ID
    JOIN GameVault_Utilizador AS u
    ON p.Utilizador_ID=u.ID
    JOIN GameVault_Utilizador AS ut
    ON r.Utilizador_ID=ut.ID
GO

--view jogos e respetivos dlc
CREATE VIEW dlc AS
    SELECT dlc.ID AS IdDLC, dlc.Nome, dlc.Tipo, dlc.Data_lancamento, j.ID AS IdJogo, j.Nome AS NomeJogo
    FROM GameVault_DLC AS dlc
    JOIN GameVault_Jogo AS j
    ON dlc.Jogo_ID=j.ID
GO