--City (id_city, name)
create table city(
	id_city integer primary key,
	name varchar(30) not null
);

insert into city(id_city, name)
values 
(1, 'Skopje'),
(2, 'London'),
(3, 'New York');

select * from city;

--Airport (id_airport, name, code, id_city*(city))
create table airport(
	id_airport integer primary key,
	name varchar(30) not null,
	iata_code char(3) not null,
	icao_code char(4) not null unique,
	id_city integer not null references city(id_city)
);

insert into airport(id_airport, name, iata_code, icao_code, id_city)
values
(1, 'Petrovac', 'SKP', 'LWSK', 1),
(2,'Heathrow','LND','LNDN',2),
(3,'Luton','LNL','LNLT',2);

select * from airport;

--Phone number (id_airport*(airport), phone_number)
create table phone_number(
	id_airport integer,
	phone_number varchar(30),
	constraint pk_phone_number primary key (id_airport,phone_number),
	constraint fk_phone_number_airport 
		foreign key (id_airport) 
			references airport(id_airport) on delete cascade
);

insert into phone_number(id_airport,phone_number)
values
(1, '055-055-055'),
(2, '101-101-101'),
(3, '225-225-225');

select * from phone_number;

--Route (route code, distance, active_from, active_to,id_airport_from*(airport), id_airport_to*(airport))
create table route(
	route_code serial primary key,
	distance integer not null,
	active_from date not null,
	active_to date,
	id_airport_from integer not null references airport(id_airport),
	id_airport_to integer not null references airport(id_airport)
	constraint ck_diff_airport check (id_airport_from != id_airport_to)
);

insert into route(distance, active_from, id_airport_from, id_airport_to)
values 
(1000, '2023-05-05', 1, 2);

select * from route;

--Line (id_line, departure_time, arrival_time, minimum_price,route_code*(route))
create table line(
	id_line integer primary key,
	departure_time time not null,
	arrival_time time not null,
	minimum_price integer not null default 1,
	route_code integer not null references route(route_code)
);

insert into line(id_line, departure_time, arrival_time, minimum_price, route_code)
values
(1, now()-interval'2 hours', now()+interval'3 hours',100,1);

select * from line;

--Airplane type (id_airplane_type, model, manufacturer)
create table airplane_type(
	id_airplane_type integer primary key,
	model varchar(30) not null,
	manufacturer varchar(30) not null
);

insert into airplane_type(id_airplane_type, model, manufacturer)
values 
(1, '747', 'BOEING'),
(2, '737', 'BOEING'),
(3, 'A380', 'AIRBUS');

select * from airplane_type;

--Aircraft (serial_number, id_airplane_type*(airplane_type))
create table aircraft(
	serial_number integer primary key,
	id_airplane_type integer not null references airplane_type(id_airplane_type)
);

insert into aircraft(serial_number, id_airplane_type)
values
(1,1),
(2,2);

select * from aircraft;

--Airline (id_airline, name, code)
create table airline(
	id_airline integer primary key,
	name varchar(50) not null,
	code char(4) not null unique
);

insert into airline(id_airline, name, code)
values 
(1, 'WIZZAIR', 'WIZZ'),
(2, 'RYANAIR', 'RYAN'),
(3, 'BRITISH AIRWAYS', 'BAWW');

select * from airline;

--Aircraft ownership (tail_number, owned_to_date,owned_from_date, id_airline*(airline),serial_number*(aircraft))
create table aircraft_ownership(
	tail_number varchar(10) primary key,
	owned_to_date date,
	owned_from_date date not null,
	id_airline integer not null references airline(id_airline),
	serial_number integer not null references aircraft(serial_number)
);

insert into aircraft_ownership(tail_number, owned_from_date, id_airline, serial_number)
values
('Z3ABCD',now()-interval'3 years',1,1);

select * from aircraft_ownership;

--Passenger (id_passenger, first_name, last_name)
create table passenger(
	id_passenger integer primary key,
	name varchar(30) not null,
	last_name varchar(30) not null
);

insert into passenger(id_passenger, name, last_name)
values 
(1, 'Sergej', 'Norski'),
(2, 'Misela', 'Manasievska');

select * from passenger;

--Passport (id_passenger*(passenger), passport_number)
create table passport(
	id_passenger integer references passenger(id_passenger),
	passport_number varchar(20),
	constraint pk_passport primary key (id_passenger, passport_number)
);

insert into passport(id_passenger, passport_number)
values
(1, '050510'),
(2, '030320');

select * from passport;

--Travel (id_travel, luggage, id_passenger *(passenger))
create table travel(
	id_travel integer primary key,
	luggage char(1) not null,
	id_passenger integer not null references passenger(id_passenger)
);

insert into travel (id_travel, luggage, id_passenger)
values 
(1,'Y',1),
(2,'N',2);

select * from travel;

--Flight (id_line*(line), id_flight, added_price,actual_arrival_time, actual_departutre_time,
--tail_number*(aircraft_ownership))
create table flight(
	id_line integer references line(id_line),
	id_flight integer,
	added_price integer not null,
	actual_arrival_time timestamp,
	actual_departure_time timestamp,
	tail_number varchar(10) not null references aircraft_ownership(tail_number),
	constraint pk_flight primary key (id_line,id_flight)
);

insert into flight(id_line, id_flight, added_price, tail_number)
values 
(1, 1, 100, 'Z3ABCD');

select * from flight;

--Ticket (id_ticket, price, id_travel*(travel), (id_line,id_flight)*(flight))
create table ticket(
	id_ticket integer primary key,
	price integer not null,
	id_travel integer not null references travel(id_travel),
	id_line integer not null,
	id_flight integer not null,
	constraint fk_ticket_flight foreign key (id_line,id_flight) references flight(id_line, id_flight)
);

insert into ticket (id_ticket, price, id_travel, id_line, id_flight)
values 
(1, 100, 1, 1, 1);

select * from ticket;

--Airline_operates_line (id_airline*(airline), id_line*(line))
create table airline_operates_line(
	id_airline integer not null references airline(id_airline),
	id_line integer not null references line(id_line),
	constraint pk_airline_operates_line primary key (id_airline, id_line)
);

insert into airline_operates_line(id_airline, id_line)
values
(1, 1);

select * from airline_operates_line;

--Aircraft_lease_to_airline (id_airline*(airline), tail_number*(aircraft_ownership), leased_to, leased_from)
create table aircraft_lease_to_airline(
	id_airline integer not null references airline(id_airline),
	tail_number varchar(10) not null references aircraft_ownership(tail_number),
	leased_to date,
	leased_from date not null,
	constraint pk_aircraft_lease_to_airline primary key (id_airline, tail_number)
);

insert into aircraft_lease_to_airline(id_airline, tail_number, leased_from)
values 
(1, 'Z3ABCD', '2023-10-10');

select * from aircraft_lease_to_airline;


--Search:
--da se prikazat site tipovi avioni od proizvoditel airbus
select * from airplane_type;

select * from airplane_type
where lower(manufacturer) = 'airbus';

-- da se prikazat site tipovi na avioni kade sto
-- imeto na modelot pocnuva na A (malo ili golemo)

-- like matchuva pattern
--ilike like with ignore case
--vtoro resenie so ilike
select * from airplane_type
where model ilike 'A%';

--da se prikazat  site avioni koi bile iznajmeni vo 2023
select * from aircraft_lease_to_airline;

select * from aircraft_lease_to_airline
where extract (year from leased_from)=2023;

-- da se prikazat tail number i id_airline na site avioni koi bile iznajmeni
-- vo 2022 i bile vrateni vo istata godina
select tail_number, id_airline
from aircraft_lease_to_airline
where extract (year from leased_from)=2022
and extract (year from leased_to)=2022;

-- da se prikaze tail number na site avioni iznajmeni na 2023-10-10
select tail_number from aircraft_lease_to_airline
where leased_from='2023-10-10';

-- da se prikazat site zakazani iznajmuvanja vo idnina
select * from aircraft_lease_to_airline
where leased_from > now();

-- da se prikazat site iznajmuvanja na avioni napraveni vo ponedelnik
select * from aircraft_leased_to_airline
where extract(dow from leased_from)=1;

-- da se prikazat site iznajmuvanja pomegu 2022-03-05 i 2023-06-10
select * from aircraft_lease_to_airline
where leased_from>'2022-03-05'::date and
leased_from<'2023-06-10'::date;
--ili
select * from aircraft_lease_to_airline
where leased_from between '2022-03-05'::date and 
'2023-06-10'::date;

-- da se prikazat tail number na site tekovno iznajmeni avioni
select tail_number from aircraft_lease_to_airline
where leased_from < now() and 
(leased_to isnull or leased_to > now());

-- da se prikazat site iznajmuvanja na avioni koi pocnale vo tekovnata godina
select * from aircraft_lease_to_airline
where extract(year from leased_from)= extract(year from now());

-- da se prikazat iznajmuvanja na avioni koi se podolgi od edna godina
select * from aircraft_leased_to_airline
where leased_from+interval '1 year' < leased_to
or (leased_to isnull and leased_from+interval '1 year' < now());

-- da se prikazat site patnici cii preziminja zavrsuvaat na ska
select * from passenger
where last_name ilike '%ska';

-- da se prikazat site patnici cii iminja ponucvaat na se i zavrsuvaat na ski
select * from passenger 
where name ilike 'se%' and last_name ilike '%ski';

-- da se pronajdat site preziminja podolgi od 9 karakteri
select * from passenger 
where char_length(last_name) > 6;












