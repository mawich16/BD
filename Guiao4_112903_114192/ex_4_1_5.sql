DROP TABLE Conferencia_Estudante
DROP TABLE Conferencia_Comprovativo
DROP TABLE Conferencia_Nao_Estudante
DROP TABLE Conferencia_Participante
DROP TABLE Conferencia_Tem
DROP TABLE Conferencia_Autor
DROP TABLE Conferencia_Instituicao
DROP TABLE Conferencia_Pessoa
DROP TABLE Conferencia_Artigo_Cientifico

CREATE TABLE Conferencia_Artigo_Cientifico (
	Titulo VARCHAR(50),
	Num_Registo INT NOT NULL,
	PRIMARY KEY (Num_Registo)
)
GO

CREATE TABLE Conferencia_Pessoa (
	Email VARCHAR(50),
	PRIMARY KEY (Email)
)
GO

CREATE TABLE Conferencia_Instituicao (
	Nome VARCHAR(50),
	Morada VARCHAR(50),
	PRIMARY KEY (Morada)
)
GO

CREATE TABLE Conferencia_Autor (
	Nome VARCHAR(100),
	Email VARCHAR(50),
	Mor_Instituicao VARCHAR(50),
	PRIMARY KEY (Email),
	FOREIGN KEY (Email) REFERENCES Conferencia_Pessoa(Email),
	FOREIGN KEY (Mor_Instituicao) REFERENCES Conferencia_Instituicao(Morada)
)
GO

CREATE TABLE Conferencia_Tem (
	Email_Autor VARCHAR(50),
	Num_Registo_Artigo INT NOT NULL,
	PRIMARY KEY (Email_Autor, Num_Registo_Artigo),
	FOREIGN KEY (Email_Autor) REFERENCES Conferencia_Autor(Email),
	FOREIGN KEY (Num_Registo_Artigo) REFERENCES Conferencia_Artigo_Cientifico(Num_Registo)
)
GO

CREATE TABLE Conferencia_Participante (
	Nome VARCHAR(100),
	Morada VARCHAR(50),
	Data_Inscricao DATE,
	Email VARCHAR(50),
	PRIMARY KEY (Email),
	FOREIGN KEY (Email) REFERENCES Conferencia_Pessoa(Email)
)
GO

CREATE TABLE Conferencia_Nao_Estudante (
	Email VARCHAR(50),
	Referencia_Transferencia INT NOT NULL,
	PRIMARY KEY (Email),
	FOREIGN KEY (Email) REFERENCES Conferencia_Participante(Email)
)
GO

CREATE TABLE Conferencia_Comprovativo (
	Localizacao_Eletronica VARCHAR(50),
	Mor_Instituicao VARCHAR(50),
	PRIMARY KEY (Localizacao_Eletronica),
	FOREIGN KEY (Mor_Instituicao) REFERENCES Conferencia_Instituicao(Morada)
)
GO

CREATE TABLE Conferencia_Estudante (
	Email VARCHAR(50),
	Comprovativo VARCHAR(50),
	Mor_Instituicao VARCHAR(50),
	PRIMARY KEY (Email),
	FOREIGN KEY (Email) REFERENCES Conferencia_Participante(Email),
	FOREIGN KEY (Comprovativo) REFERENCES Conferencia_Comprovativo(Localizacao_Eletronica),
)