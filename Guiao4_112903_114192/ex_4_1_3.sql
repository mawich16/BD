DROP TABLE Stock_Itens
DROP TABLE Stock_Produtos
DROP TABLE Stock_Encomenda
DROP TABLE Stock_Fornecedor
DROP TABLE Stock_Tipo_Fornecedor

CREATE TABLE Stock_Tipo_Fornecedor (
	Designacao VARCHAR(120),
	Codigo INT NOT NULL,
	PRIMARY KEY (Codigo)
)
GO

CREATE TABLE Stock_Fornecedor (
	Morada VARCHAR(120),
	Nome VARCHAR(120),
	Fax INT,
	NIF INT NOT NULL,
	Condicoes_Pagamento_Codigo INT NOT NULL,
	Tipo_Fornecedor_Codigo INT NOT NULL,
	PRIMARY KEY (NIF),
	FOREIGN KEY (Tipo_Fornecedor_Codigo) REFERENCES Stock_Tipo_Fornecedor(Codigo)
)
GO

CREATE TABLE Stock_Encomenda (
	Numero INT NOT NULL,
	[Data] DATE,
	Fornecedor_NIF INT NOT NULL,
	PRIMARY KEY (Numero),
	FOREIGN KEY (Fornecedor_NIF) REFERENCES Stock_Fornecedor(NIF),
)
GO

CREATE TABLE Stock_Produtos (
	Codigo INT NOT NULL,
	Nome VARCHAR (120),
	Preco Decimal (10,3) NOT NULL,
	Taxa_IVA INT CHECK (Taxa_IVA >= 0),
	Unidades INT NOT NULL,
	PRIMARY KEY (Codigo)
)
GO

CREATE TABLE Stock_Itens (
	Produto_Codigo INT NOT NULL,
	Quantidade INT NOT NULL,
	Encomenda_Num INT NOT NULL,
	FOREIGN KEY (Produto_Codigo) REFERENCES Stock_Produtos(Codigo),
	FOREIGN KEY (Encomenda_Num) REFERENCES Stock_Encomenda(Numero),
)
GO