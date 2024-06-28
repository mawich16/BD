
CREATE TABLE [Rent_a_Car_Cliente] (
	Nome varchar(15) NOT NULL,
	Endereco char NOT NULL,
	Num_carta int NOT NULL,
	NIF int NOT NULL,
	PRIMARY KEY ([NIF]),
)
GO

CREATE TABLE [Rent_a_Car_Balcao] (
	Nome varchar(15) NOT NULL,
	Numero int NOT NULL,
	Endereco varchar(40) NOT NULL,
	PRIMARY KEY ([Numero]),
)
GO

CREATE TABLE [Rent_a_Car_Tipo_Veiculo] (
	Designacao varchar(40) NOT NULL,
	Arcondicionado bit NOT NULL,
	Codigo int NOT NULL,
	PRIMARY KEY ([Codigo]),
)
GO

CREATE TABLE [Rent_a_Car_Veiculo] (
	Marca varchar(25) NOT NULL,
	Ano int NOT NULL,
	Tipo_Veiculo_Codigo int NOT NULL REFERENCES [Rent_a_Car_Tipo_Veiculo]([Codigo]),
	Matricula varchar(6) NOT NULL,
	PRIMARY KEY ([Matricula]),
)
GO

CREATE TABLE [Rent_a_Car_Aluguer] (
	Numero int NOT NULL,
	Duracao int NOT NULL,
	Data_aluguer date NOT NULL,
	Num_balcao int NOT NULL REFERENCES [Rent_a_Car_Balcao]([Numero]),
	NIF_cliente int NOT NULL REFERENCES [Rent_a_Car_Cliente]([NIF]),
	Veiculo_matricula varchar(6) NOT NULL REFERENCES [Rent_a_Car_Veiculo]([Matricula]),
	PRIMARY KEY ([Numero]),
)
GO

CREATE TABLE [Rent_a_Car_Ligeiro] (
	Portas int NOT NULL,
	Combustivel int NOT NULL,
	Num_lugares int NOT NULL,
	Tipo_Veiculo_Codigo int NOT NULL REFERENCES [Rent_a_Car_Tipo_Veiculo]([Codigo]),
	PRIMARY KEY ([Tipo_Veiculo_Codigo]),
)
GO

CREATE TABLE [Rent_a_Car_Pesado] (
	Peso int NOT NULL,
	Passageiros int NOT NULL,
	Tipo_Veiculo_Codigo int NOT NULL REFERENCES [Rent_a_Car_Tipo_Veiculo]([Codigo]),
	PRIMARY KEY ([Tipo_Veiculo_Codigo]),
)
GO

CREATE TABLE [Rent_a_Car_Similaridade] (
	Tipo_Veiculo_Codigo_Ligeiro int NOT NULL REFERENCES [Rent_a_Car_Ligeiro]([Tipo_Veiculo_Codigo]),
	Tipo_Veiculo_Codigo_Pesado int NOT NULL REFERENCES [Rent_a_Car_Pesado]([Tipo_Veiculo_Codigo]),
	PRIMARY KEY ([Tipo_Veiculo_Codigo_Pesado],[Tipo_Veiculo_Codigo_Ligeiro]),
)
GO
