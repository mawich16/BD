DROP TABLE Medicamento_Prescricao_Farmaco
DROP TABLE Medicamento_Farmaco
DROP TABLE Medicamento_Companhia_Farmaceutica
DROP TABLE Medicamento_Prescricao
DROP TABLE Medicamento_Farmacia
DROP TABLE Medicamento_Paciente
DROP TABLE Medicamento_Medico

CREATE TABLE Medicamento_Medico (
	Numero_SNS INT NOT NULL,
	Nome VARCHAR(100),
	Especialidade VARCHAR(50),
	PRIMARY KEY (Numero_SNS)
)
GO

CREATE TABLE Medicamento_Paciente (
	Num_Utente INT NOT NULL,
	Nome VARCHAR(100),
	Data_Nascimento DATE,
	Morada VARCHAR(50),
	PRIMARY KEY (Num_Utente)
)
GO

CREATE TABLE Medicamento_Farmacia (
	Nome VARCHAR(50),
	Telefone INT,
	Morada VARCHAR(50),
	PRIMARY KEY (Nome)
)
GO

CREATE TABLE Medicamento_Prescricao (
	Numero INT NOT NULL,
	Paciente_Num_Utente INT NOT NULL,
	Num_SNS_Medico INT NOT NULL,
	Farmacia VARCHAR (50),
	Data_Processo DATE,
	PRIMARY KEY (Numero),
	FOREIGN KEY (Paciente_Num_Utente) REFERENCES Medicamento_Paciente(Num_Utente),
	FOREIGN KEY (Num_SNS_Medico) REFERENCES Medicamento_Medico(Numero_SNS),
	FOREIGN	KEY (Farmacia) REFERENCES Medicamento_Farmacia(Nome)
)
GO

CREATE TABLE Medicamento_Companhia_Farmaceutica (
	Num_Registo INT NOT NULL,
	Nome VARCHAR(30),
	Morada VARCHAR(50),
	PRIMARY KEY (Num_Registo)
)
GO

CREATE TABLE Medicamento_Farmaco (
	Num_Registo_Companhia_Farmaceutica INT NOT NULL,
	Nome_Unico_Farmaceutico VARCHAR(20),
	Formula VARCHAR(50) NOT NULL,
	PRIMARY KEY (Formula),
	FOREIGN KEY (Num_Registo_Companhia_Farmaceutica) REFERENCES Medicamento_Companhia_Farmaceutica(Num_Registo)
)
GO

CREATE TABLE Medicamento_Prescricao_Farmaco (
	Prescricao_Num INT NOT NULL,
	Num_Registo_Companhia_Farmaceutica INT NOT NULL,
	Nome_Farmaco VARCHAR(50),
	PRIMARY KEY (Prescricao_Num, Nome_Farmaco),
	FOREIGN KEY (Prescricao_Num) REFERENCES Medicamento_Prescricao(Numero),
	FOREIGN KEY (Num_Registo_Companhia_Farmaceutica) REFERENCES Medicamento_Companhia_Farmaceutica(Num_Registo)
)
GO