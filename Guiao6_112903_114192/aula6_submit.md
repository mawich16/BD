# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT *
	FROM authors
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT authors.au_fname, authors.au_lname, authors.phone
	FROM authors
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT authors.au_fname, authors.au_lname, authors.phone
	FROM authors
	ORDER BY authors.au_fname, authors.au_lname
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone
	FROM authors
	ORDER BY authors.au_fname, authors.au_lname
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT authors.au_fname AS first_name, authors.au_lname AS last_name, authors.phone AS telephone, STATE
	FROM authors
	WHERE authors.[state] = 'CA' AND  authors.au_lname <> 'Ringer'
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT *
	FROM publishers
	WHERE pub_name LIKE '%Bo%'
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT P.pub_id, P.pub_name
	FROM publishers AS P, titles AS T
	WHERE T.[type] = 'business' AND P.pub_id = T.pub_id
```

### *h)* Número total de vendas de cada editora; 

```
SELECT P.pub_id, P.pub_name, SUM(S.qty) AS sales
	FROM sales AS S, titles AS T, publishers AS P
	WHERE S.title_id = T.title_id AND T.pub_id = P.pub_id
	GROUP BY P.pub_id, P.pub_name
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT P.pub_id, P.pub_name, T.title, SUM(S.qty) AS sales
	FROM sales AS S, titles AS T, publishers AS P
	WHERE S.title_id = T.title_id AND T.pub_id = P.pub_id
	GROUP BY P.pub_id, P.pub_name, T.title
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT stores.stor_name, titles.title_id, titles.title
	FROM stores, sales, titles
	WHERE titles.title_id = sales.title_id AND sales.stor_id = stores.stor_id AND stores.stor_name = 'Bookbeat'
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
SELECT COUNT(titles.[type]) AS numTypes, authors.au_fname, authors.au_lname
	FROM authors, titleauthor, titles
	WHERE authors.au_id = titleauthor.au_id AND  titleauthor.title_id = titles.title_id
	GROUP BY authors.au_fname, authors.au_lname
	HAVING COUNT(titles.[type]) > 1
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT AVG(titles.price) AS avgPrice, titles.[type], titles.pub_id
	FROM titles, sales
	WHERE sales.title_id = titles.title_id
	GROUP BY titles.[type], titles.pub_id
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT [type], MAX(advance) AS max_advance, AVG(advance) AS avg_advance
	FROM titles
	GROUP BY [type]
	HAVING MAX(advance) > 1.5 * AVG(advance)
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT authors.au_fname,authors.au_lname, titles.title, SUM(sales.qty * titles.price) AS 'total sale'
	FROM (
		((authors JOIN titleauthor ON authors.au_id = titleauthor.au_id) JOIN titles ON titleauthor.title_id = titles.title_id) JOIN sales ON titles.title_id = sales.title_id
		)
	GROUP BY titles.title,authors.au_fname,authors.au_lname
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT title, ytd_sales,price*ytd_sales AS facturacao, price*ytd_sales*royalty/100 AS auths_revenue, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_revenue
	FROM titles;
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
SELECT title, ytd_sales, CONCAT(authors.au_fname, ' ', authors.au_lname) AS 'author', price*ytd_sales*royalty/100 AS auths_revenue, price*ytd_sales-price*ytd_sales*royalty/100 AS publisher_revenue
	FROM (titles JOIN titleauthor ON titles.title_id = titleauthor.title_id) JOIN authors ON authors.au_id = titleauthor.au_id
	ORDER BY title
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT stor_name
	FROM (stores JOIN sales ON stores.stor_id = sales.stor_id) JOIN titles ON sales.title_id = titles.title_id
	GROUP BY stor_name
	HAVING COUNT(title) = (SELECT COUNT(title_id) FROM titles)
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT stor_name
	FROM (stores JOIN sales ON stores.stor_id = sales.stor_id)
	GROUP BY stor_name
	HAVING SUM(sales.qty) > AVG(sales.qty)
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
(SELECT DISTINCT title FROM titles)
EXCEPT
(SELECT DISTINCT title 
	FROM (titles LEFT OUTER JOIN sales ON titles.title_id = sales.title_id) JOIN stores ON sales.stor_id = stores.stor_id
	WHERE stores.stor_name = 'Bookbeat')
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
SELECT publishers.pub_name, stores.stor_name
    FROM ((stores LEFT OUTER JOIN sales ON stores.stor_id=sales.stor_id) LEFT OUTER JOIN titles ON sales.title_id=titles.title_id) LEFT OUTER JOIN publishers ON titles.pub_id=publishers.pub_id
	GROUP BY publishers.pub_name, stores.stor_name
	HAVING COUNT(sales.qty)=0
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT Fname, Minit, Lname, Pnumber
	FROM (([Company_Project] JOIN [Company_Works_On] ON [Company_Project].Pnumber = [Company_Works_On].Pno) JOIN [Company_Employee] ON [Company_Works_On].Essn = [Company_Employee].ssn)
	GROUP BY Fname, Minit, Lname, Pnumber
	ORDER BY Pnumber;
```

##### *b)* 

```
SELECT employee.Fname, employee.Lname
	FROM [Company_Employee] as employee, [Company_Employee] as Chefe
	WHERE employee.Super_ssn = Chefe.Ssn and  Chefe.Fname = 'Carlos' AND Chefe.Minit = 'D' AND Chefe.Lname = 'Gomes'
	GROUP BY Fname, Lname;
```

##### *c)* 

```
SELECT Pname, Pno, SUM([Company_Works_On].Hours) As WorkedHours
	FROM [Company_Project] JOIN [Company_Works_On] ON [Company_Project].Pnumber = [Company_Works_On].Pno
	GROUP BY [Company_Project].Pname, [Company_Works_On].Pno
	ORDER BY Pno;
```

##### *d)* 

```
SELECT Fname, Minit, Lname, Pnumber, Pname, Dno, Hours
	FROM (([Company_Project] JOIN [Company_Works_On] ON [Company_Project].Pnumber = [Company_Works_On].Pno) JOIN [Company_Employee] ON [Company_Works_On].Essn = [Company_Employee].ssn)
	WHERE Pname = 'Aveiro Digital' AND Dno=3 AND Hours >= 20
	GROUP BY Fname, Minit, Lname, Pnumber, Pname, Dno, Hours
	ORDER BY Pnumber;
```

##### *e)* 

```
SELECT Fname, Minit, Lname
	FROM [Company_Employee] LEFT OUTER JOIN [Company_Works_On] ON [Company_Employee].Ssn = [Company_Works_On].Essn
	WHERE Essn is NULL
	GROUP BY Fname, Minit, Lname
	ORDER BY Fname;
```

##### *f)* 

```
SELECT Dno, Dname, AVG(Salary) AS AverageFemaleSalary
	FROM [Company_Department] JOIN [Company_Employee] ON [Company_Department].Dnumber = [Company_Employee].Dno
	WHERE Sex = 'F'
	GROUP BY Dno, Dname
	ORDER BY Dno;
```

##### *g)* 

```
SELECT Essn, Fname, Minit, Lname, COUNT (Dependent_name) AS dependentCount
	FROM [Company_Employee] JOIN [Company_Dependents] ON [Company_Employee].Ssn = [Company_Dependents].Essn
	GROUP BY Essn, Fname, Minit, Lname
	HAVING COUNT(dependent_name) > 2
	ORDER BY Fname;
```

##### *h)* 

```
SELECT Ssn, Fname, Minit, Lname, Dnumber
	FROM [Company_Employee] JOIN [Company_Department] ON [Company_Employee].Ssn = [Company_Department].Mgr_ssn
	WHERE [Company_Employee].Ssn NOT IN (
	SELECT [Company_Employee].Ssn
		FROM [Company_Employee] JOIN [Company_Dependents] ON [Company_Employee].Ssn = [Company_Dependents].Essn);
```

##### *i)* 

```
SELECT Fname, Lname, Dlocation, PLocation
	FROM (((( [Company_Employee] JOIN [Company_Works_On] ON [Company_Employee].Ssn = [Company_Works_On].Essn) JOIN [Company_Project] ON [Company_Works_On].Pno = [Company_Project].Pnumber) JOIN [Company_Department] ON [Company_Employee].Dno = [Company_Department].Dnumber) JOIN [Company_Dept_Locations] ON [Company_Department].Dnumber = [Company_Dept_Locations].Dnumber)
	WHERE Dlocation <> 'Aveiro' AND Plocation = 'Aveiro'
	GROUP BY Fname, Lname, Dlocation, PLocation
	ORDER BY Fname;
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT Nome
	FROM (Stock_Fornecedor LEFT OUTER JOIN Stock_Encomenda ON Stock_Fornecedor.NIF = Stock_Encomenda.Fornecedor_NIF)
	WHERE Stock_Encomenda.Fornecedor_NIF IS NULL
```

##### *b)* 

```
SELECT Produto_Codigo, AVG(Quantidade) AS Media
	FROM Stock_Itens
	GROUP BY Produto_Codigo
```


##### *c)* 

```
SELECT AVG(CAST(Produto_Encomenda as float)) AS Media_Produto_Encomenda
FROM (
    SELECT Encomenda_Num, COUNT(Produto_Codigo) AS Produto_Encomenda
    FROM Stock_Itens
    GROUP BY Encomenda_Num
) AS Total_Produtos
```


##### *d)* 

```
SELECT Stock_Fornecedor.Nome, Stock_Produtos.Nome, SUM(Stock_Itens.Quantidade) AS Quantidade 
	FROM (((Stock_Fornecedor JOIN Stock_Encomenda ON NIF = Fornecedor_NIF) JOIN Stock_Itens ON Encomenda_Num = Numero) JOIN Stock_Produtos ON Codigo = Produto_Codigo)
	GROUP BY Stock_Fornecedor.Nome, Stock_Produtos.Nome
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT Num_Utente, Nome, Data_Nascimento, Morada
	FROM Medicamento_Paciente LEFT OUTER JOIN Medicamento_Prescricao ON Medicamento_Paciente.Num_Utente = Medicamento_Prescricao.Paciente_Num_Utente
	WHERE Medicamento_Prescricao.Paciente_Num_Utente is NULL
	GROUP BY Num_Utente, Nome, Data_Nascimento, Morada
	ORDER BY Num_Utente;
```

##### *b)* 

```
SELECT Especialidade, COUNT(Especialidade) AS PrescricoesPorEspecialidade
	FROM Medicamento_Medico JOIN Medicamento_Prescricao ON Medicamento_Medico.Numero_SNS = Medicamento_Prescricao.Num_SNS_Medico
	GROUP BY Especialidade
	ORDER BY Especialidade;
```


##### *c)* 

```
SELECT Nome, COUNT(Nome) AS NumeroPrescricoes
	FROM Medicamento_Farmacia JOIN Medicamento_Prescricao ON Medicamento_Farmacia.Nome = Medicamento_Prescricao.Farmacia
	GROUP BY Nome
	ORDER BY Nome;
```


##### *d)* 

```
SELECT Nome_Unico_Farmaceutico AS NomeFarmaco
	FROM Medicamento_Farmaco
	WHERE Medicamento_Farmaco.Num_Registo_Companhia_Farmaceutica = 906
	EXCEPT
	SELECT Nome_Unico_Farmaceutico
	FROM Medicamento_Farmaco JOIN Medicamento_Prescricao_Farmaco ON Medicamento_Prescricao_Farmaco.Nome_Farmaco = Medicamento_Farmaco.Nome_Unico_Farmaceutico
	WHERE Medicamento_Farmaco.Num_Registo_Companhia_Farmaceutica = 906;
```

##### *e)* 

```
SELECT Farmacia, Nome, COUNT(Nome_Farmaco) AS VendasFarmcacosDasFarmaceuticas
	FROM Medicamento_Prescricao, Medicamento_Prescricao_Farmaco, Medicamento_Companhia_Farmaceutica
	WHERE Medicamento_Prescricao.Data_Processo IS NOT NULL AND Medicamento_Prescricao_Farmaco.Prescricao_Num = Medicamento_Prescricao.Numero AND Medicamento_Companhia_Farmaceutica.Num_Registo = Medicamento_Prescricao_Farmaco.Num_Registo_Companhia_Farmaceutica
	GROUP BY Farmacia, Nome
	ORDER BY Farmacia, Nome;
```

##### *f)* 

```
SELECT Medicamento_Paciente.Nome
	FROM (Medicamento_Paciente JOIN Medicamento_Prescricao ON Medicamento_Paciente.Num_Utente = Medicamento_Prescricao.Paciente_Num_Utente) JOIN Medicamento_Medico ON Medicamento_Prescricao.Num_SNS_Medico = Medicamento_Medico.Numero_SNS
	GROUP BY Medicamento_Paciente.Nome
	HAVING COUNT(Numero_SNS) > 1
	ORDER BY Nome;
```
