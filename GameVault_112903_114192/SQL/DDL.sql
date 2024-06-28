DROP TABLE GameVault_Review_Utilizador_Voto;
DROP TABLE GameVault_Post_Utilizador_Voto;
DROP TABLE GameVault_Resposta_Utilizador_Voto;
DROP TABLE GameVault_Disponibiliza;
DROP TABLE GameVault_Jogo_Genero;
DROP TABLE GameVault_Vende;
DROP TABLE GameVault_Desenvolve;
DROP TABLE GameVault_Publica;
DROP TABLE GameVault_Loja;
DROP TABLE GameVault_Genero;
DROP TABLE GameVault_DLC;
DROP TABLE GameVault_Plataforma;
DROP TABLE GameVault_Desenvolvedora;
DROP TABLE GameVault_Editora;
DROP TABLE GameVault_Empresa;
DROP TABLE GameVault_Resposta;
DROP TABLE GameVault_Post;
DROP TABLE GameVault_Review;
DROP TABLE GameVault_Utilizador;
DROP TABLE GameVault_Jogo;



CREATE TABLE GameVault_Jogo (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	Data_lancamento DATE,
	Descricao VARCHAR(MAX),
	Imagem NVARCHAR(MAX) DEFAULT ('https://img.freepik.com/premium-photo/abstract-neon-light-game-controller-artwork-design-digital-art-wallpaper-glowing-space-background-generative-ai_742252-10382.jpg'),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_Utilizador (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	Email VARCHAR(255),
	Data_adesao DATE,
	[Password] VARCHAR(255),
	Imagem NVARCHAR(MAX) DEFAULT ('https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fgamer-avatar&psig=AOvVaw02wTGW7nKXKGBkGguqu7YH&ust=1716546654897000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPigheDIo4YDFQAAAAAdAAAAABAE'),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_Review (
	ID INT IDENTITY(1,1) NOT NULL,
	Comentario VARCHAR(MAX),
	Utilizador_ID INT,
	Data_review DATE,
	Hora TIME,
	Jogo_ID INT,
	Rating DECIMAL(2,1),
	PRIMARY KEY (ID),
	FOREIGN KEY (Utilizador_ID) REFERENCES GameVault_Utilizador(ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Post (
	ID INT IDENTITY(1,1) NOT NULL,
	Texto VARCHAR(MAX),
	Utilizador_ID INT,
	Data_post DATE,
	Hora TIME,
	Titulo VARCHAR(255),
	PRIMARY KEY (ID),
	FOREIGN KEY (Utilizador_ID) REFERENCES GameVault_Utilizador(ID)
)
GO

CREATE TABLE GameVault_Resposta (
	ID INT IDENTITY(1,1) NOT NULL,
	Texto VARCHAR(MAX),
	Utilizador_ID INT,
	Data_reposta DATE,
	Hora TIME,
	Post_ID INT,
	PRIMARY KEY (ID),
	FOREIGN KEY (Utilizador_ID) REFERENCES GameVault_Utilizador(ID),
	FOREIGN KEY (Post_ID) REFERENCES GameVault_Post(ID)
)
GO

CREATE TABLE GameVault_Empresa (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	Ano_criacao INT,
	Localizacao VARCHAR(255),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_Editora (
	Empresa_ID INT NOT NULL,
	PRIMARY KEY (Empresa_ID),
	FOREIGN KEY (Empresa_ID) REFERENCES GameVault_Empresa(ID)
)
GO

CREATE TABLE GameVault_Desenvolvedora (
	Empresa_ID INT NOT NULL,
	PRIMARY KEY (Empresa_ID),
	FOREIGN KEY (Empresa_ID) REFERENCES GameVault_Empresa(ID)
)
GO

CREATE TABLE GameVault_Plataforma (
	ID INT IDENTITY(1,1)NOT NULL,
	Nome VARCHAR(120),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_DLC (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	Jogo_ID INT,
	Tipo VARCHAR(100),
	Data_lancamento DATE,
	PRIMARY KEY (ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Genero (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_Loja (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(120),
	PRIMARY KEY (ID)
)
GO

CREATE TABLE GameVault_Publica (
	Editora_ID INT NOT NULL,
	Jogo_ID INT NOT NULL,
	PRIMARY KEY (Editora_ID,Jogo_ID),
	FOREIGN KEY (Editora_ID) REFERENCES GameVault_Editora(Empresa_ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Desenvolve (
	Desenvolvedora_ID INT NOT NULL,
	Jogo_ID INT NOT NULL,
	PRIMARY KEY (Desenvolvedora_ID,Jogo_ID),
	FOREIGN KEY (Desenvolvedora_ID) REFERENCES GameVault_Desenvolvedora(Empresa_ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Vende (
	Loja_ID INT NOT NULL,
	Jogo_ID INT NOT NULL,
	Preco DECIMAL(5,2),
	PRIMARY KEY (Loja_ID,Jogo_ID),
	FOREIGN KEY (Loja_ID) REFERENCES GameVault_Loja(ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Jogo_Genero (
	Genero_ID INT NOT NULL,
	Jogo_ID INT NOT NULL,
	PRIMARY KEY (Genero_ID,Jogo_ID),
	FOREIGN KEY (Genero_ID) REFERENCES GameVault_Genero(ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

CREATE TABLE GameVault_Disponibiliza (
	Plataforma_ID INT NOT NULL,
	Jogo_ID INT NOT NULL,
	PRIMARY KEY (Plataforma_ID,Jogo_ID),
	FOREIGN KEY (Plataforma_ID) REFERENCES GameVault_Plataforma(ID),
	FOREIGN KEY (Jogo_ID) REFERENCES GameVault_Jogo(ID)
)
GO

ALTER TABLE GameVault_Utilizador
ADD Token VARCHAR(255),
    TokenExpiration DATETIME;
GO

ALTER TABLE GameVault_Utilizador
ADD UNIQUE (Email, Nome);
GO

ALTER TABLE GameVault_Review
ADD Upvotes INT DEFAULT 0,
    Downvotes INT DEFAULT 0;
GO

ALTER TABLE GameVault_Post
ADD Upvotes INT DEFAULT 0,
    Downvotes INT DEFAULT 0;
GO

ALTER TABLE GameVault_Resposta
ADD Upvotes INT DEFAULT 0,
    Downvotes INT DEFAULT 0;
GO

CREATE INDEX Post_Titulo
ON GameVault_Post (Titulo);
GO

CREATE INDEX Empresa_Nome
ON GameVault_Empresa (Nome);
GO

CREATE INDEX Jogo_Nome
ON GameVault_Jogo (Nome);
GO

CREATE TABLE GameVault_Review_Utilizador_Voto (
    ID INT IDENTITY(1,1) NOT NULL,
    Review_ID INT NOT NULL,
    User_ID INT NOT NULL,
    Vote INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Review_ID) REFERENCES GameVault_Review(ID),
    FOREIGN KEY (User_ID) REFERENCES GameVault_Utilizador(ID)
)

CREATE TABLE GameVault_Post_Utilizador_Voto (
    ID INT IDENTITY(1,1) NOT NULL,
    Post_ID INT NOT NULL,
    Utilizador_ID INT NOT NULL,
    Vote INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Post_ID) REFERENCES GameVault_Post(ID),
    FOREIGN KEY (Utilizador_ID) REFERENCES GameVault_Utilizador(ID)
)

CREATE TABLE GameVault_Resposta_Utilizador_Voto (
    ID INT IDENTITY(1,1) NOT NULL,
    Resposta_ID INT NOT NULL,
    Utilizador_ID INT NOT NULL,
    Vote INT NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Resposta_ID) REFERENCES GameVault_Resposta(ID),
    FOREIGN KEY (Utilizador_ID) REFERENCES GameVault_Utilizador(ID)
)
