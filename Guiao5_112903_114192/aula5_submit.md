# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π employee.Fname, employee.Minit, employee.Lname, project.Pnumber
(
	project
	⨝ project.Pnumber=works_on.Pno
	works_on
	⨝ works_on.Essn=employee.Ssn
	employee
)
```


### *b)* 

```
π employee.Fname, employee.Lname
(
	employee
	⨝ employee.Super_ssn=Chefe.BossCode
	ρ Chefe
	π Ssn -> BossCode
	σ Fname='Carlos' ∧ Minit = 'D' ∧ Lname='Gomes'
	employee
)
```


### *c)* 

```
γ Pname, Pno; sum(Hours) -> WorkedHours
(
	project
	⨝ project.Pnumber=works_on.Pno
	works_on
)
```


### *d)* 

```
σ project.Pname = 'Aveiro Digital' ∧ employee.Dno = 3 ∧ works_on.Hours ≥ 20
(
	π employee.Fname, employee.Minit, employee.Lname, project.Pnumber, project.Pname, employee.Dno, works_on.Hours
	(
		project
		⨝ project.Pnumber=works_on.Pno
		works_on
		⨝ works_on.Essn=employee.Ssn
		employee
))
```


### *e)* 

```
π Fname,Minit,Lname
(
	σ Essn = null
	(
		employee
		⟕ Ssn=Essn
		works_on
))
```


### *f)* 

```
γ Dno, Dname; avg(Salary) -> AverageFemaleSalary
(
	σ employee.Sex = 'F' (employee)
	⨝ department.Dnumber = employee.Dno
	department
)
```


### *g)* 

```
σ dependentCount > 2
(
	γ Essn, Fname, Minit, Lname; count(Dependent_name) -> dependentCount
	(
		employee
		⨝ employee.Ssn = dependent.Essn
		dependent
))
```


### *h)* 

```
π employee.Ssn, employee.Fname, employee.Minit, employee.Lname, department.Dnumber
(
	(employee
		-
		π employee.Fname,	employee.Minit,	employee.Lname,	employee.Ssn,	employee.Bdate,	employee.Address,	employee.Sex,	employee.Salary,	employee.Super_ssn,	employee.Dno	
		(
		employee
		⨝ employee.Ssn = dependent.Essn
		dependent
	))
	⨝ employee.Ssn = department.Mgr_ssn
	department
)
```


### *i)* 

```
π employee.Fname, employee.Lname, dept_location.Dlocation, project.Plocation
(
	σ dept_location.Dlocation ≠ 'Aveiro' ∧ project.Plocation = 'Aveiro'
	(
		employee
		⨝ employee.Ssn = works_on.Essn
		works_on
		⨝ works_on.Pno = project.Pnumber
		project
		⨝ employee.Dno = department.Dnumber
		department
		⨝ department.Dnumber = dept_location.Dnumber
		dept_location
))
```


## ​Problema 5.2

### *a)*

```
π fornecedor.nome -> NomeFornecedor
σ numero=null
(
	fornecedor
	⟕ encomenda.fornecedor=fornecedor.nif
	encomenda
)
```

### *b)* 

```
π produto.codigo -> CodProd,produto.nome -> NomeProd ,NumMedioEnc
(
	produto
	⨝ item.codProd=produto.codigo
	γ codProd; avg(unidades)->NumMedioEnc
	item
)
```


### *c)* 

```
γ avg(NumProdEnc) -> NumMedioProdEnc
γ numEnc; count(codProd)->NumProdEnc
(item)
```


### *d)* 

```
π fornecedor.nome -> NomeFornecedor, fornecedor.nif -> NIFFornecedor, produto.codigo -> CodProd, produto.nome -> NomeProd, UnidadesFornecidas
(
	produto
	⨝ item.codProd=produto.codigo
	γ codProd, fornecedor.nome, fornecedor.nif; sum(unidades) -> UnidadesFornecidas
	(item
		⨝ encomenda.numero=item.numEnc
		encomenda
		⨝ fornecedor.nif=encomenda.fornecedor
		fornecedor
))
```


## ​Problema 5.3

### *a)*

```
(
	π paciente.numUtente (paciente)
	-
	π prescricao.numUtente (prescricao)
)
⨝ 
paciente
```

### *b)* 

```
γ especialidade; count(especialidade) -> prescricoes_por_especialidade
(
	medico
	⨝ medico.numSNS = prescricao.numMedico
	prescricao
)
```


### *c)* 

```
γ nome; count(nome) -> num_de_precricoes
(
	farmacia
	⨝ farmacia.nome = prescricao.farmacia
	prescricao
)
```


### *d)* 

```
(
	π nome -> NomeFarmaco
	σ numRegFarm=906
	(
		farmaco
	)
)
-
(
	π nome
	σ farmaco.numRegFarm=906
	(
		farmaco
		⨝ presc_farmaco.nomeFarmaco = farmaco.nome
		presc_farmaco
	)
)
```

### *e)* 

```
π farmacia.nome -> NomeFarmacia, farmaceutica.nome -> NomeFarmaceutica, VendasFarmacosFarmaceuticas
γ farmacia.nome,farmaceutica.nome;count(farmaceutica.nome) -> VendasFarmacosFarmaceuticas
(
	prescricao
	⨝ farmacia.nome=prescricao.farmacia
	farmacia
	⨝
	presc_farmaco
	⨝ farmaceutica.numReg=presc_farmaco.numRegFarm
	farmaceutica
)
```

### *f)* 

```
π paciente.nome -> NomePaciente, NumMedicos
σ NumMedicos > 1
γ paciente.nome; count(medico.numSNS) -> NumMedicos
π paciente.nome, paciente.numUtente, medico.numSNS, medico.nome
(
	paciente
	⨝ prescricao.numUtente=paciente.numUtente
	prescricao
	⨝ medico.numSNS=prescricao.numMedico
	medico
)
```