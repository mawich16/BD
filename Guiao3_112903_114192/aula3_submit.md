# BD: Guião 3


## ​Problema 3.1
 
### *a)*

```
Um cliente, identificado pelo seu NIF, pode realizar alugueres de veiculos. Alugueres esses que serao distinguiveis atraves de um numero. Estes podem ser realizados num balcao, tambem identificado por um numero. Cada um dos veiculos que esta disponivel para aluguer e identificado pela sua matricula. Estes veiculos, tem ainda um tipo (identificado por um codigo): pesado ou ligeiro. Cada um dos veiculos tem um grau de similaridade para com outros.

Esquema da relacao:
	- Cliente (Nome, Endreco, Num_carta, NIF)
	- Aluguer (Numero, Duracao, Data, NIF_cliente, Num_balcao, Veiculo_matricula)
	- Balcao (Nome, Numero, Endreco)
	- Veiculo (Matricula, Marca, Ano, Tipo_Veiculo_codigo)
	- Tipo Veiculo (Designacao, Arcondicionado, Codigo)
	- Ligeiro (Portas, Combustivel, Numlugares, Tipo_Veiculo_codigo)
	- Pesado (Passageiros, Peso, Tipo_Veiculo_codigo)
	- Similaridade (Tipo_Veiculo_codigo1, Tipo_Veiculo_codigo2)
```


### *b)* 

```
Chaves Candidatas:
	- Cliente: NIF, num_carta 
	- Aluguer: numero
	- Balcao: numero, endreco
	- Veiculo: matricula
	- Tipo Veiculo: codigo, designacao
	- Similaridade: Tipo_Veiculo_codigo1, Tipo_Veiculo_codigo2

Chaves Primárias:
	- Cliente: NIF
	- Aluguer: numero
	- Balcao: numero
	- Veiculo: matricula
	- Tipo Veiculo: codigo
	- Similaridade: Tipo_Veiculo_codigo1 combinada com Tipo_Veiculo_codigo2
	- Ligeiro: Tipo_Veiculo_codigo
	- Pesado: Tipo_Veiculo_codigo

Chaves Estrangeiras: 
	- Aluguer: NIF_cliente, Num_balcao, Veiculo_matricula
	- Veiculo: Tipo_Veiculo_codigo
	- Ligeiro: Tipo_Veiculo_codigo
	- Pesado: Tipo_Veiculo_codigo
	- Similaridade: Tipo_Veiculo_codigo1, Tipo_Veiculo_codigo2
```


### *c)* 

![ex_3_1c!](ex_3_1c.jpg "AnImage")


## ​Problema 3.2

### *a)*

```
Um aviao e identificado pelo seu ID e pode ter varios Leg Instance, ja esta por si só poderá estar apenas associada a um aviao. Cada Leg Instance é uma instância do Flight Leg e cada Flight Leg esta associado a um e apenas um voo. Cada voo e identificado atraves do seu numero e pode ter diferentes tipos de fare. Cada aeroporto, também este identificado por um codigo pode receber varios tipos de avioes e controla tanto ass partidas com as chegadas.

Esquema da relacao:
	- Airport (Airport_code, City, State, Name)
	- Airplane Type (Airplane_Type_Name, Max_seats, Company)
	- Airplane (Airplane_ID, Num_total_seats, Airplane_Type_Name)
	- Flight (Number, Airline, Weekdays)
	- Flight Leg (Flight_num, Leg_num, Airport_Dep_Code, Airport_Arr_Code, Sch_Dep_Time, Sch_Arr_Time)
	- Leg Instance (Flight_num, Flight_leg_num, Airport_Dep_Code, Airport_Arr_Code, Sch_Dep_Time, Sch_Arr_Time, Date, Num_of_avail_seats, Airplane_ID)
	- Seat (Flight_num, Flight_Leg_num, Seat_num, Leg_Instance_Date, Customer_name, Cphone, Airplane_ID)
	- Fare (Code, Amount, Restrictions, Flight_num)
	- Can Land (Airport_code, Airplane_Type_Name)
```


### *b)* 

```
Chaves Candidatas:
	- Airport: Airport_code
	- Airplane Type: Airplane_Type_name
	- Airplane: Airplane_ID
	- Seat: Seat_num
	- Leg Instance: Date
	- Fare: Code, Amount
	- Flight: Number
	- Flight Leg: Leg_num
	- Can Land: Airport_code, Airplane_Type_name

Chaves Primárias:
	- Airport: Airport_code
	- Airplane Type: Airplane_Type_name
	- Airplane: Airplane_ID
	- Seat: Seat_num
	- Leg Instance: Date
	- Fare: Code
	- Flight: Number
	- Flight Leg: Leg_num
	- Can Land: Airport_code combinada com Airplane_Type_name

Chaves Estrangeiras:
	- Airplane: Airplane_Type_Name
	- Flight Leg: Flight_num
	- Leg Instance: Flight_num, Flight_Leg_num, Airplane_ID
	- Seat: Flight_num, Flight_Leg_num, Leg_Instance_Date, Airplane_ID
	- Fare: Flight_num
	- Can Land: Airport_code, Airplane_Type_name
```


### *c)* 

![ex_3_2c!](ex_3_2c.jpg "AnImage")


## ​Problema 3.3


### *a)* 2.1

![ex_3_3_a!](ex_3_3a.jpg "AnImage")

### *b)* 2.2

![ex_3_3_b!](ex_3_3b.jpg "AnImage")

### *c)* 2.3

![ex_3_3_c!](ex_3_3c.jpg "AnImage")

### *d)* 2.4

![ex_3_3_d!](ex_3_3d.jpg "AnImage")