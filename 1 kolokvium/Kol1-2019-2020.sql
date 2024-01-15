set search_path = 'Kol1-2019-2020';

-- Zadaca 1: Kreiraj gi tabelite:
create table produkti(
	id integer primary key,
	ime varchar(50) not null
);

insert into produkti(id,ime)
values
(1,'Sergej'),
(2,'Matej'),
(3,'Misela');

create table narcka(
	id integer primary key,
	vreme timestamp not null,
	id_produkt integer not null references produkti(id)
);

-- Zadaca 2: Vmetni gi dadenite redici vo tabelata apteki
--ovie ne mozat da se izvrsat zatoa sto ja nemame tabelata
insert into apteki(id,ime,adresa,telefon,grad_id)
values
(10, 'nova apteka', 'partizanski odredi bb', '02 5555 777', 1),
(11, 'apteka 1', 'ilindeska 53', '070 555 777', 2);

insert into gradovi(grad_id, ime)
values 
(3, 'Ohird'),
(5, 'Bitola');

-- Zadaca 3:Во табелата lekovi, сетирај го полето za_naracka во true за сите лекови
-- кај кои количината е помала од 15 и цената е помала или еднаква од 500, и кај лековите кај
-- кои цената е над 500 и количината е помала или еднаква од 15
update lekovi
set za_naracka = true 
where (kolicina < 15 and cena <= 500) or (cena > 500 and kolicina<=15);

-- Zadaca 4:Излистај ги имињата и ATC кодовите (name, atc_code) на сите лекови
-- кои во името или во описот го содржат зборот “icin”. 
-- Напомена: треба да се излистаат сите
-- редици каде има појавување на зборот, во името или во описот, на кирилица или латиница, со
-- мали или големи букви
select name, atc_code 
from lekovi 
where name ilike '%icin%' or name ilike '%ицин%' or 
atc_code ilike '%icin%' or atc_code ilike '%ицин%';

--Задача 5 (10 поени): Од табелата prodazba_lekovi, излистај ги сите лекови (*) кои се
--продадени по 20-тиот ден во месецот (било кој месец), пред 11:00 часот
select * from prodazba_lekovi 
where extract(day from datum_prodazba) > 20 and
datum_prodzba::time < '11:00'::time;
--ili
select * from prodazba_lekovi 
where extract(day from datum_prodazba) > 20 and
extract(hour from datum_prodazba) < 11;

-- Zadaca 7:
--Задача 7 (25 поени): Од табелата prodazba_lekovi, најди ја вкупната количина на продадени
--лекови по ден од неделата и месец за секоја аптека, за лековите кај кои првите две букви од
--ATC кодот се B1. Притоа, треба да се прикажат само записите кога имало вкупна продажба од
--најмалку 100 денари. Колони кои треба да фигурират во излезот: apteka_ime, den, mesec,
--vkupna_prodazba, broj_na_prodadeni_lekovi.
--Резултатите треба да се подредат по име на аптека во опаѓачки редослед.
-- ne e celosno resenie
select apteka_ime,den,mesec,vkupna_prodazba,broj_na_prodadeni_lekovi
from prodazba_lekovi
where atc_code ilike 'B1%' and
vkupna_prodazba > 100
order by 
apteka_name desc;

-- Zadaca 6:
-- За дадениот ЕР дијаграм креирај ги соодветните табели. Треба да се
-- постават соодветните типови на податоци за колоните, да се сетираат примарни клучеви и
-- надворешни клучеви со соодветни ограничувања за null вредности на клучевите, Притоа да
-- се користи мапирачка трансформација.

create table specijalizacija(
	id integer primary key,
	naziv varchar(30) not null
);

create table doktor(
	faksimil integer primary key,
	ime varchar(30) not null
	id integer references specijalizacija(id)
);

create table klinika(
	id integer primary key,
	ime varchar(30) not null
);

create table tel_broj(
	id integer references klinika(id),
	tel_broj varchar(30),
	constraint pk_tel_broj primary key (id,tel_broj)
);

create table raboti_vo(
	faksimil integer references doktor(faksimil),
	id integer references klinika(id),
	constraint pk_raboti_vo primary key (faksimil,id)
	
);





































