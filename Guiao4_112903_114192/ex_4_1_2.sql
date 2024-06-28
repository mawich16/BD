CREATE TABLE [Reserva_de_Voos_Airport] (
	Code int NOT NULL,
	City varchar(15) NOT NULL,
	State_airpot varchar(15) NOT NULL,
	Name_airport varchar(15) NOT NULL,
	PRIMARY KEY ([Code]),
)
GO

CREATE TABLE [Reserva_de_Voos_Airplane_Type] (
	Max_seats int NOT NULL,
	Company varchar(15) NOT NULL,
	Name_airplane_type varchar(15) NOT NULL,
	PRIMARY KEY ([Name_airplane_type]),
)
GO

CREATE TABLE [Reserva_de_Voos_Airplane] (
	ID int NOT NULL,
	Toatl_seats int NOT NULL,
	Airplane_Type_Name varchar(15) NOT NULL REFERENCES [Reserva_de_Voos_Airplane_Type]([Name_airplane_type]),
	PRIMARY KEY ([ID]),
)
GO

CREATE TABLE [Reserva_de_Voos_Flight] (
	Number int NOT NULL,
	Airline int NOT NULL,
	Weekdays varchar(10) NOT NULL,
	PRIMARY KEY ([Number]),
)
GO

CREATE TABLE [Reserva_de_Voos_Flight_Leg] (
	Flight_num int NOT NULL,
	Leg_num int NOT NULL,
	Airport_Dep_Code int NOT NULL REFERENCES [Reserva_de_Voos_Airport]([Code]),
	Airport_Arr_Code int NOT NULL REFERENCES [Reserva_de_Voos_Airport]([Code]),
	Sch_Dep_Time time NOT NULL,
	Sch_Arr_Time time NOT NULL,
	PRIMARY KEY ([Flight_num], [Leg_num]),
	FOREIGN KEY ([Flight_num]) REFERENCES [Reserva_de_Voos_Flight]([Number]),
)
GO

CREATE TABLE [Reserva_de_Voos_Leg_Instance] (
    Flight_num int NOT NULL,
    Leg_num int NOT NULL,
    Airport_Dep_Code int NOT NULL,
    Airport_Arr_Code int NOT NULL,
    Sch_Dep_Time time NOT NULL,
    Sch_Arr_Time time NOT NULL,
    Date_leg date NOT NULL,
    Num_of_avail_seats int NOT NULL,
    Airplane_ID int NOT NULL,
    PRIMARY KEY ([Flight_num], [Leg_num], [Date_leg]),
    FOREIGN KEY ([Flight_num], [Leg_num]) REFERENCES [Reserva_de_Voos_Flight_Leg]([Flight_num], [Leg_num]),
    FOREIGN KEY ([Airplane_ID]) REFERENCES [Reserva_de_Voos_Airplane]([ID]),
)
GO

CREATE TABLE [Reserva_de_Voos_Seat] (
	Flight_num int NOT NULL,
	Leg_num int NOT NULL,
	Date_leg_instance date NOT NULL,
	Seat_num int NOT NULL,
	Airplane_ID int NOT NULL REFERENCES [Reserva_de_Voos_Airplane]([ID]),
	Costumer_name varchar(15) NOT NULL,
	Cphone int NOT NULL,
	PRIMARY KEY ([Seat_num],[Date_leg_instance]),
	FOREIGN KEY ([Flight_num],[Leg_num],[Date_leg_instance]) REFERENCES [Reserva_de_Voos_Leg_Instance]([Flight_num],[Leg_num], [Date_leg]),
	
)
GO

CREATE TABLE [Reserva_de_Voos_Fare] (
	Code int NOT NULL,
	Amount int NOT NULL,
	Flight_num int NOT NULL REFERENCES [Reserva_de_Voos_Flight]([Number]),
	Restrictions varchar(30),
	PRIMARY KEY ([Code],[Flight_num]),
)
GO

CREATE TABLE [Reserva_de_Voos_Can_Land] (
	Airport_code int NOT NULL REFERENCES [Reserva_de_Voos_Airport]([Code]),
	Airplane_Type_Name varchar(15) NOT NULL REFERENCES [Reserva_de_Voos_Airplane_Type]([Name_airplane_type]),
	PRIMARY KEY ([Airport_code],[Airplane_Type_Name]),
)
GO