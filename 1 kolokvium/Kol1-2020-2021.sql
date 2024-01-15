set search_path = 'Kol1-2020-2021';

-- Задача 1 (8 поени): Креирај ги табелите според следниве спецификации:
-- prodavnica(id_prodavnica, ime_prodavnica, adresa, id_prodavac*(prodavac))
-- prodavac(id_prodavac, ime, prezime, datum_vrabotuvanje)

create table prodavac(
	id_prodavac integer primary key,
	ime varchar(30) not null,
	prezime varchar(30) not null,
	datum_vrabotuvanje date
);

create table prodavnica(
	id_prodavnica integer primary key,
	ime_prodavnica varchar(30) not null,
	adresa varchar(30),
	id_prodavac integer references prodavac(id_prodavac)
);

select * from prodavac;
select * from prodavnica;

-- Задача 2 (5 поени): Во табелата smetka вметни податоци за по три нови сметки на двајца постоечки клиенти
insert into smetka(id, smetka)
values 
(1, 3000),
(1, 5000),
(1, 6000),
(2, 2000),
(2, 7000),
(2, 1000);

-- Задача 3 (7 поени): Во табелата filijala, додај колона id_odgovoren која ќе референцира кон
-- табелата vraboten. Колоната треба да дозволува null вредности
alter table filijala 
add id_odgovoren integer references vraboten(id_vraboten);

--ili vtoro resenie:
alter table filijala 
add constraint fk_filijala_vraboten foreign key (id_odgovoren) references vraboten(vraboten_id);

-- Задача 4 (10 поени): Во табелата kredit, сетирај ги ратите на кредит на 3000 кај сите кредити
-- отворени пред 20.01.2020
update kredit 
set rati_kredit = 3000
where datum_kredi < '2020-01-20'::date;

-- Задача 5 (10 поени): Излистај ги сите луѓе (*) на кои презимето им завршува на „ски“ или
-- „ска“ и се родени пред 2000 година (ова може да го извадите од ЕМБГ).
select * from ljuge
where (prezime like '%ski' or prezime ilike '%ska') and 
substr(embg,5,1) > 0;

-- Задача 6 (10 поени): Од табелата transakcii, излистај ги сите трансакции (*) кои се направени
-- во тековниот месец пред 13:00 часот. За „тековен месец“ би требало да работи во секое време
select * from transakcii
where extract(month from now()) = extract(month from datum_transakcija)
and extract(hour from datum_transakcija) < 13;

--Задача 8 (15 поени): Од табелата трансакции, најди ги сите денарски трансакции од износ
-- поголем од 1000 денари кои се направени во последните 10 дена, во периодот помеѓу 13:00 и
-- 15:00 часот. Да се прикажат само бројот на трансакција, време на трансакција и износот.
-- (broj_transakcija, vreme izvrsuvanje, suma)
select broj_transakcija, vreme_izvrsuvanje, suma
from transakcii
where suma > 1000 and 
datum_transakcija between (now() - interval '10 days') and
extract(hour from datum_transakcija) >= 13 and 
extract(hour from datum_transakcija) >= 15;

--vtoro resnie:
select broj_transakcija, vreme izvrsuvanje, suma
from transakcii
where mkd > 1000 and 
(datum_transakcija between (now() - interval  ’10 days’) and(now()) and 
(datum_transakcija::time between (time ’13:00:00’) and (time ’15:00:00’));

-- Задача 7 (25+10 поени):
-- a) (25) За дадениот ЕР дијаграм креирај ги соодветните табели. Треба да се постават
-- соодветните типови на податоци за колоните, да се сетираат примарни клучеви и надворешни
-- клучеви со соодветни ограничувања за null вредности на клучевите, Притоа да се користи
-- мапирачка трансформација.

create table skolo(
	kod_skolo integer primary key,
	naziv_skolo varchar(30) not null,
	adresa_skolo varchar(50)
);


create table nastavnik(
	EMBG_nastavnik varchar(13) primary key,
	ime_nastavnik varchar(30) not null,
	prezime_nastavnik varchar(30) not null
);

create table oddelenie(
	kod_skolo integer references skolo(kod_skolo),
	paralelka varchar(10),
	godina char(1),
	constraint pk_oddelenie primary key (kod_skolo,paralelka,godina)
);

create table ucenik(
	id_ucenik integer primary key,
	kod_skolo integer not null,
	paralelka varchar(10) not null,
	godina char(1) not null,
	ime_ucenik varchar(30) not null,
	prezime_ucenik varchar(30) not null,
	constraint fk_ucenik_oddelenie foreign key (kod_skolo,paralelka,godina) 
	references oddelenie(kod_skolo,paralelka,godina)
);

create table predava_na(
	EMBG_nastavnik varchar(13),
	kod_skolo integer not null,
	paralelka varchar(10) not null,
	godina char(1) not null,
	constraint pk_predava_na primary key(EMBG_nastavnik,kod_skolo,paralelka,godina),
	constraint fk_predava_na_oddelenie foreign key(kod_skolo,paralelka,godina) 
		references oddelenie(kod_skolo,paralelka,godina)
);




















































