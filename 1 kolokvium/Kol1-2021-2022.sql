set search_path = 'Kol1-2021-2022';

-- Задача 1 (8 поени): Креирај ги табелите според следниве спецификации (се извршува на
-- schema ispitna):
-- proizvod(id_proizvod, ime_proizvod, opis)
-- naracka(id_naracka, vreme_naracka, status_naracka) (статус на нарачка е текст со
-- произволна големина)
-- naracan_proizvod(id_proizvod*(proizvod), id_naracka*(naracka), kolicina)
create table proizvod(
	id_proizvod integer primary key,
	ime_proziv varchar(50) not null,
	opis varchar(255)
);

create table narcka(
	id_narcka integer primary key,
	vreme_naracka timestamp not null,
	status_narcka varchar(255) not null
);

create table naracan_proizvod(
	id_proizvod integer references proizvod,
	id_naracka integer references narcka,
	kolicina int not null,
	constraint pk_naracan_proizvod primary key (id_proizvod, id_naracka)
);

-- Задача 2 (5 поени): Во табелата proizvod вметни податоци за пет произволни производи.
-- Вметнете и една нарачка со најмалку два нарачани производи.
insert into proizvod(id_proizvod, ime_proziv, opis)
values
(1, 'Proizvod_1', 'Opis_1'),
(2, 'Proizvod_2', 'Opis_2'),
(3, 'Proizvod_3', 'Opis_3'),
(4, 'Proizvod_4', 'Opis_4'),
(5, 'Proizvod_5', 'Opis_5');

insert into narcka(id_narcka, vreme_naracka, status_narcka)
values 
(1, '2023-11-21 15:45:00', 'SE PROCESIRA');

insert into naracan_proizvod(id_proizvod, id_naracka, kolicina)
values
(1, 1, 5),
(2, 1, 10);

-- Задача 3 (7 поени): Во табелата proizvod, дополнително додај колона cena од тип integer која
-- нема да дозволува null вредности.
alter table proizvod
add cena integer not null default 0;

-- Задача 4 (10 поени): Во табелата naracka, сетирај ги статусите на сите нарачки како
-- kompletirana.
update narcka
set status_narcka = 'KOMPLETIRAN';

-- Задача 5 (10 поени): Излистај ги сите луѓе (*) на кои презимето им завршува на „ски“ или
-- „ска“ (кирилица или латиница) и се родени во 1995 година.
select * 
from ljuge
where (prezime ilike '%ski' or prezime ilike '%ски' or prezime ilike '%ska' or prezime ilike '%ска') and
extract(year from datum_rodeni) = 1995;

create table ljuge(
	id integer primary key,
	prezime varchar(20),
	datum_rodeni timestamp
);

insert into ljuge(id,prezime,datum_rodeni)
values 
(1, 'Норски', '1995-05-05 19:00:00'),
(2, 'Норска', '1995-05-05 19:00:00'),
(3, 'Norski', '1995-05-05 19:00:00'),
(4, 'Norska', '1995-05-05 19:00:00'),
(5, 'Норска', '1996-05-05 19:00:00'),
(6, 'Норски', '1996-05-05 19:00:00'),
(7, 'Norski', '1996-05-05 19:00:00'),
(8, 'Norskа', '1996-05-05 19:00:00');

-- Задача 6 (10 поени): Од табелата прегледи излистајте ги сите прегледи кои се направени во
-- месец Октомври во тековната година 
select *
from pregled
where extract(month from datum_pregled) = 11 and
extract(year from datum_pregled) = extract(year from now());

create table pregled(
	id integer primary key,
	datum_pregled timestamp
);

insert into pregled(id,datum_pregled)
values 
(1, '2023-11-05 10:00:00'),
(2, '2022-11-05 10:00:00'),
(3, '2023-10-05 10:00:00');

-- Задача 8 (15 поени): Од табелата преглед, најди ги сите прегледи извршени во тековниот
-- месец од минатата година, направени помеѓу 9:00 и 15:00 часот, кои не направени во
-- клиника. Внимавајте- тековен месец не значи фиксно ноември.
select * 
from pregled 
where (extract(month from datum_pregled) = extract(month from now())) and 
(extract(year from datum_pregled) = extract(year from now() - interval '1 year')) and 
(datum_pregled::time between (time '09:00:00') and (time '15:00:00'));
--za proverka deka ne e napravena vo klinika dodavame: and id_klinika is null;




































