CREATE TABLE [ATL_Pessoa] (
	Nome varchar(15) NOT NULL,
	Morada varchar(30) NOT NULL,
	Data_nascimento date NOT NULL,
	Telefone int NOT NULL,
	Email varchar(30) NOT NULL,
	CC int NOT NULL,
	PRIMARY KEY ([CC]),
)
GO

CREATE TABLE [ATL_Encarregado_Educacao] (
	CC_pessoa int NOT NULL REFERENCES [ATL_Pessoa]([CC]),
	PRIMARY KEY ([CC_pessoa]),
)
GO

CREATE TABLE [ATL_Professor] (
	Num_funcionario int NOT NULL,
	CC_pessoa int NOT NULL REFERENCES [ATL_Pessoa]([CC]),
	PRIMARY KEY ([CC_pessoa]),
)
GO

CREATE TABLE [ATL_Turma] (
	Designacao varchar(30) NOT NULL,
	CC_professor int NOT NULL REFERENCES [ATL_Professor]([CC_pessoa]),
	ID int NOT NULL,
	Num_max_alunos int NOT NULL,
	Ano_letivo int NOT NULL,
	PRIMARY KEY ([ID]),
)
GO

CREATE TABLE [ATL_Aluno] (
	Nome varchar(15) NOT NULL,
	Morada varchar(30) NOT NULL,
	Data_nascimento date NOT NULL,
	ID_turma int NOT NULL REFERENCES [ATL_Turma]([ID]),
	Grau_parentesco_EE varchar(30) NOT NULL,
	CC int NOT NULL,
	CC_EE int NOT NULL REFERENCES [ATL_Encarregado_Educacao]([CC_pessoa]),
	PRIMARY KEY ([CC]),
)
GO

CREATE TABLE [ATL_Atividades] (
	ID int NOT NULL,
	Custo int NOT NULL,
	Descricao varchar(30) NOT NULL,
	PRIMARY KEY ([ID]),
)
GO

CREATE TABLE [ATL_Realiza] (
	ID_atividades int NOT NULL REFERENCES [ATL_Atividades]([ID]),
	ID_turma int NOT NULL REFERENCES [ATL_Turma]([ID]),
	PRIMARY KEY ([ID_atividades],[ID_turma]),
)
GO

CREATE TABLE [ATL_Participa] (
	CC_aluno int NOT NULL REFERENCES [ATL_Aluno]([CC]),
	ID_turma int NOT NULL REFERENCES [ATL_Turma]([ID]),
	PRIMARY KEY ([CC_aluno],[ID_turma]),
)
GO