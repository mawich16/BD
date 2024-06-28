DROP TABLE Medicamento_Prescricao_Farmaco
DROP TABLE Medicamento_Farmacia_Farmaco
DROP TABLE Medicamento_Companhia_Farmaco
DROP TABLE Medicamento_Farmaco
DROP TABLE Medicamento_Companhia_Farmaceutica
DROP TABLE Medicamento_Farmacia_Prescricao
DROP TABLE Medicamento_Farmacia
DROP TABLE Medicamento_Prescricao
DROP TABLE Medicamento_Paciente
DROP TABLE Medicamento_Medico
DROP TABLE Medicamento_Especialidade

CREATE TABLE Medicamento_Especialidade (
	Codigo INT NOT NULL,
	Designacao VARCHAR(35),
	PRIMARY KEY (Codigo)
)
GO

CREATE TABLE Medicamento_Medico (
	Numero_SNS INT NOT NULL,
	Nome VARCHAR(100),
	Especialidade_Codigo INT NOT NULL,
	PRIMARY KEY (Numero_SNS),
	FOREIGN KEY (Especialidade_Codigo) REFERENCES Medicamento_Especialidade(Codigo)
)
GO

CREATE TABLE Medicamento_Paciente (
	Nome VARCHAR(100),
	Morada VARCHAR(50),
	Data_Nascimento DATE,
	Num_Utente INT NOT NULL,
	PRIMARY KEY (Num_Utente)
)
GO

CREATE TABLE Medicamento_Prescricao (
	Numero INT NOT NULL,
	Data_Emissao DATE,
	Quantidade INT NOT NULL,
	Paciente_Num_Utente INT NOT NULL,
	Num_SNS_Medico INT NOT NULL,
	Data_Processo DATE,
	PRIMARY KEY (Numero),
	FOREIGN KEY (Paciente_Num_Utente) REFERENCES Medicamento_Paciente(Num_Utente),
	FOREIGN KEY (Num_SNS_Medico) REFERENCES Medicamento_Medico(Numero_SNS)
)
GO

CREATE TABLE Medicamento_Farmacia (
	Nome VARCHAR(25),
	Morada VARCHAR(50),
	Telefone INT,
	NIF INT NOT NULL,
	PRIMARY KEY (NIF)
)
GO

CREATE TABLE Medicamento_Farmacia_Prescricao (
	Prescricao_Num INT NOT NULL,
	NIF_Farmacia INT NOT NULL,
	Data DATE,
	PRIMARY KEY (Prescricao_Num, NIF_Farmacia),
	FOREIGN KEY (Prescricao_Num) REFERENCES Medicamento_Prescricao(Numero),
	FOREIGN KEY (NIF_Farmacia) REFERENCES Medicamento_Farmacia(NIF)
)
GO

CREATE TABLE Medicamento_Companhia_Farmaceutica (
	Morada VARCHAR(50),
	Nome VARCHAR(30),
	Telefone INT,
	Num_Registo INT NOT NULL,
	PRIMARY KEY (Num_Registo)
)
GO

CREATE TABLE Medicamento_Farmaco (
	Num_Registo_Companhia_Farmaceutica INT NOT NULL,
	Nome_Unico_Farmaceutico VARCHAR(20),
	Nome_Comercial VARCHAR(25),
	Formula VARCHAR(50) NOT NULL,
	PRIMARY KEY (Formula),
	FOREIGN KEY (Num_Registo_Companhia_Farmaceutica) REFERENCES Medicamento_Companhia_Farmaceutica(Num_Registo)
)
GO

CREATE TABLE Medicamento_Companhia_Farmaco (
	Num_Registo_CF INT NOT NULL,
	Formula_Farmaco VARCHAR(50) NOT NULL,
	PRIMARY KEY (Num_Registo_CF, Formula_Farmaco),
	FOREIGN KEY (Num_Registo_CF) REFERENCES Medicamento_Companhia_Farmaceutica(Num_Registo),
	FOREIGN KEY (Formula_Farmaco) REFERENCES Medicamento_Farmaco(Formula)
)
GO

CREATE TABLE Medicamento_Farmacia_Farmaco (
	NIF_Farmacia INT NOT NULL,
	Formula_Farmaco VARCHAR(50) NOT NULL,
	PRIMARY KEY (NIF_Farmacia, Formula_Farmaco),
	FOREIGN KEY (NIF_Farmacia) REFERENCES Medicamento_Farmacia(NIF),
	FOREIGN KEY (Formula_Farmaco) REFERENCES Medicamento_Farmaco(Formula)
)
GO

CREATE TABLE Medicamento_Prescricao_Farmaco (
	Prescricao_Num INT NOT NULL,
	Formula_Farmaco VARCHAR(50) NOT NULL,
	Quantidade INT NOT NULL,
	PRIMARY KEY (Prescricao_Num, Formula_Farmaco),
	FOREIGN KEY (Prescricao_Num) REFERENCES Medicamento_Prescricao(Numero),
	FOREIGN KEY (Formula_Farmaco) REFERENCES Medicamento_Farmaco(Formula)
)
GO