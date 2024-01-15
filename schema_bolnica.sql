-- Bolnica
set search_path = 'bolnica';

-- REDOSLED NA EDNO QUERY:
-- select
-- from
-- join
-- where
-- group by
-- having
-- order by

-- JOINS:
-- ako sakame da dozvolime da propustime null vrednosti od leva strana: left join
-- ako sakame da dozvolime da propustime null vrednosti od desna strana: right join
-- ako sakame da dozvolime da propustime null vrednosti i od leva strana i od desna: full outer join
-- ako sakame celosno poklopuvanje togas samo join

-- OPERACII SO MNOZESTVA:
-- union (unija)
-- intersect (presek)



----------------------------- Auditoriski vezbi 12/1/2021 -----------------------------
---------- JOINS ----------
-- da se prikazat site lekari so ime i prezime
select * 
from lekar
join chovek on lekar.embg = chovek.embg;

-- da se prikazat site lekari so nivnata specijalnost
-- gi prikazuva samo lekarite koi imaat specijalnost
select * 
from lekar
join chovek on lekar.embg = chovek.embg
join specijalnost on lekar.id_specijalnost = specijalnost.id_specijalnost;

-- da se prikazat site lekari so nivnata specijalnost
-- gi prikazuva i lekarite koi nemaat specijalnost
select chovek.ime, chovek.prezime, lekar.broj_faksimil, specijalnost.naziv_specijalnost 
from lekar
join chovek on lekar.embg = chovek.embg
left join specijalnost on lekar.id_specijalnost = specijalnost.id_specijalnost;

-- da se prikazat site specijalnosti i lekarite specijalzirani vo taa oblast, dokolku ima takvi
select chovek.ime, chovek.prezime, lekar.broj_faksimil, specijalnost.naziv_specijalnost 
from lekar
join chovek on lekar.embg = chovek.embg
right join specijalnost on lekar.id_specijalnost = specijalnost.id_specijalnost;

-- full outer join (kombinaicja od left i right join)
select chovek.ime, chovek.prezime, lekar.broj_faksimil, specijalnost.naziv_specijalnost 
from lekar
join chovek on lekar.embg = chovek.embg
full outer join specijalnost on lekar.id_specijalnost = specijalnost.id_specijalnost;

-- da se prikazat site pregledi, so iminja na pacient,lekar i klinika vo koja e napraven pregledot
select pr.id_pregled, datum_pregled, cp.ime as ime_pacient, cl.ime as ime_lekar, k.ime_klinika
from pregled as pr
join pacient as pa on pr.embg_pacient = pa.embg
join chovek as cp on pa.embg = cp.embg
join lekar as le on pr.embg_lekar = le.embg
join chovek as cl on le.embg = cl.embg
left join klinika as k on pr.id_klinika = k.id_klinika
order by pr.id_pregled asc;

-- da se prikazat site pregledi, so iminja na pacient,lekar i klinika vo koja e napraven pregledot
-- pregledi sto se izvrseni vo prethodniot mesec
select pr.id_pregled, datum_pregled, cp.ime as ime_pacient, cl.ime as ime_lekar, k.ime_klinika
from pregled as pr
join pacient as pa on pr.embg_pacient = pa.embg
join chovek as cp on pa.embg = cp.embg
join lekar as le on pr.embg_lekar = le.embg
join chovek as cl on le.embg = cl.embg
left join klinika as k on pr.id_klinika = k.id_klinika
where extract(month from datum_pregled) = extract(month from now()) -1
order by pr.id_pregled asc;

-- da se prikazat site bolesti dijagnosticirani kaj pacienti i kaj koi pacienti se dijagnosticirani
select distinct ch.ime,prezime,ezbo,di2.mkb10,di2.opis, pr.datum_pregled
from pacient as pa
join chovek as ch on pa.embg = ch.embg
join pregled as pr on  pa.embg = pr.embg_pacient
join dijagnosticira as di on pr.id_pregled = di.id_pregled
join dijagnoza  as di2 on di.mkb10 = di2.mkb10
order by datum_pregled asc;



----------------------------- Auditoriski vezbi 12/9/2021 -----------------------------
---------- VIEWS ----------
-- ne moze da se izvrsi, nema permisii
-- create view isotrija_na_pregledi as
select pa.embg, datum_pregled, chp.ime as ime_pacient, chp.prezime as prezime_pacient,
chl.ime as ime_lekar, chl.prezime as prezime_lekar, ime_klinika, d3.mkb10, opis
from pregled as pr
join pacient as pa on pr.embg_pacient = pa.embg
join chovek as chp on pa.embg  = chp.embg 
join lekar as l on pr.embg_lekar = l.embg 
join chovek as chl on l.embg = chl.embg 
left join klinika as k on pr.id_klinika = k.id_klinika 
left join dijagnosticira d2 on pr.id_pregled = d2.id_pregled 
left join dijagnoza d3 on d2.mkb10 = d3.mkb10;


---------- TRANSAKCII ----------
-- ne moze da se izvrsi, nema permisii
-- zapocnuva so transakcija
begin;

-- pravime nesto na baza
delete from dijagnosticira;

-- dokolku pogresime nesto, skaame da se vratime
rollback;

-- ako se e ok, ako sakame da zapiseme ne baza
commit;


---------- AGREGATNI FUNKCII / GRUPIRANJE ----------
-- sakame da prebroime kolku vkupno pregledi ima izvresno do sega
select count(*)
from pregled;

-- sakame da prebroime kolku razlicni pacienti se pojavile na pregled
select count(distinct embg_pacient) 
from pregled;

-- prebroj kolku pati sekoj pacient se javil na pregled
select embg_pacient, count(id_pregled) 
from pregled
group by embg_pacient;

-- da se prikaze posledniot pregled za sekoj pacient
select embg_pacient, max(datum_pregled)
from pregled
group by embg_pacient;

-- da se prikaze posledniot pregled za sekoj doktor
select embg_pacient,embg_lekar, max(datum_pregled)
from pregled
group by embg_pacient,embg_lekar;

-- od istorijat na pregledi da se najdat najcestite pregledi
-- zatoa sto ne moze da se kreira view, ke gi koristam kodot
select d3.mkb10, d3.opis, count(pr.datum_pregled)
from pregled as pr
join pacient as pa on pr.embg_pacient = pa.embg
join chovek as chp on pa.embg  = chp.embg 
join lekar as l on pr.embg_lekar = l.embg 
join chovek as chl on l.embg = chl.embg 
left join klinika as k on pr.id_klinika = k.id_klinika 
left join dijagnosticira d2 on pr.id_pregled = d2.id_pregled 
left join dijagnoza d3 on d2.mkb10 = d3.mkb10
group by 1,2;

-- broj na dijagostiranja na sekoja dijagonza kaj sekoj pacient od isotirjat
-- zatoa sto ne moze da se kreira view, ke gi koristam kodot
select pr.embg_pacient, chp.ime as ime_pacient, chp.prezime as prezime_pacient, d3.mkb10,
d3.opis, count(*)
from pregled as pr
join pacient as pa on pr.embg_pacient = pa.embg
join chovek as chp on pa.embg  = chp.embg 
join lekar as l on pr.embg_lekar = l.embg 
join chovek as chl on l.embg = chl.embg 
left join klinika as k on pr.id_klinika = k.id_klinika 
left join dijagnosticira d2 on pr.id_pregled = d2.id_pregled 
left join dijagnoza d3 on d2.mkb10 = d3.mkb10
group by pr.embg_pacient, chp.ime, chp.prezime, d3.mkb10,
d3.opis
order by pr.embg_pacient asc, d3.mkb10 asc;

-- da se dade izvestaj za broj na izvrseni pregledi po mesec i po godina
select extract(month from datum_pregled) as mesec, extract(year from datum_pregled) as godina, count(id_pregled)
from pregled
group by 1,2
order by godina asc, mesec asc;

-- da se dade izvestaj za broj na izvrseni pregledi po mesec i po godina
-- da se prikazat samo mesecite kade sto imalo povekje od 5 pregleda
select extract(month from datum_pregled) as mesec, extract(year from datum_pregled) as godina, count(id_pregled)
from pregled
group by 1,2
having count(id_pregled) > 5
order by godina asc, mesec asc;

-- da se najde broj na upat spored lekar kaj kogo se upateni, vo sekoj mesec od godinata
-- da se prikazat lekarite, so ime i prezime
select extract(month from termin) as mesec, extract(year from termin) as godina,
embg_lekar_upaten, c.ime, c.prezime, count(id_upat)
from upat
join lekar as l on upat.embg_lekar_upaten = l.embg
join chovek as c on l.embg = c.embg
group by 1,2,3,4,5
order by mesec asc, godina asc;

-- da se najdat brojot na specijalisti od sekoja specijalnost
select sp.id_specijalnost, naziv_specijalnost, count(distinct embg)
from specijalnost as sp
left join lekar as l on sp.id_specijalnost = l.id_specijalnost
group by 1,2;

-- da se najde kolku od ljugeto vo nasata baza se lekari, kolku se pacienti ,a kolku i dvete
select count(distinct c.embg) as ljuge, count(distinct l.embg) as lekari, count(distinct p.embg) as pacienti,
count(l.embg=p.embg) as lekari_pacineti
from chovek as c
left join lekar as l on c.embg = l.embg 
left join pacient as p on c.embg = p.embg;

-- da najdeme statistika kolku pacienti, kolku pati na pregled bile
select broj_pregledi, count(embg_pacient) as broj_pacienti
from (
select embg_pacient, count(id_pregled) as broj_pregledi
from pregled
group by embg_pacient) as pacienti_pregledi
group by broj_pregledi;



----------------------------- Auditoriski vezbi 12/15/2021 -----------------------------
---------- VGENZDENI QUERY-NJA ----------
-- da se najdat korelirani dijagnozi(boelsti koi se dijagnosticiraat kaj isti pacienti) i koi se najcesti takvi parovi
select pd.mkb10 as mkb10_1, pd.opis as opis_1, vd.mkb10 as mkb10_2, vd.opis as opis_2, count(*) as pojavuvanja
from (
select embg_pacient, d3.mkb10, opis, datum_pregled
from pregled as pr
join dijagnosticira as d2 on pr.id_pregled = d2.id_pregled 
join dijagnoza as d3 on d2.mkb10 = d3.mkb10) as pd
join (
select embg_pacient, d3.mkb10, opis, datum_pregled
from pregled as pr
join dijagnosticira as d2 on pr.id_pregled = d2.id_pregled 
join dijagnoza as d3 on d2.mkb10 = d3.mkb10) as vd on pd.embg_pacient = vd.embg_pacient
where pd.mkb10 <> vd.mkb10
and pd.datum_pregled < vd.datum_pregled -- so vremenesko podreduvanje, vtorata dijagznoa da se javi posle prvata
and pd.datum_pregled + interval '30 days' > vd.datum_pregled
group by 1,2,3,4
order by pojavuvanja desc;



----------------------------- Auditoriski vezbi 12/22/2021 -----------------------------
---------- VEZBI ZA POSLOZENI QUERY-NJA ----------
-- da se izlistaat site upati vo narednite 30 dena, kaj koj doktor so koja specijalnost se zakazani i vo koj oddel i koja bolnica
select u.id_upat, u.termin, ch.ime as ime_pacient, ch.prezime as prezime_pacient, k.ime_klinika, o.ime_oddel
from upat as u
left join lekar as l on u.embg_lekar_upaten = l.embg
left join chovek as ch on l.embg = ch.embg
left join specijalnost as sp on l.id_specijalnost = sp.id_specijalnost
left join oddel as o on u.id_oddel = o.id_oddel and u.id_oddel = o.id_oddel
left join klinika as k on o.id_klinika = k.id_klinika
where u.termin between now() and now() + interval '30 days';

-- da se izlistaat site dijagnozi postaveni na pregled koj e izvrsen po osnov na upat
select d3.mkb10, d3.opis 
from upat as u
join pregled as p on u.id_pregled = p.id_pregled
join dijagnosticira as d2 on p.id_pregled = d2.id_pregled
join dijagnoza as d3 on d2.mkb10 = d3.mkb10;

-- naredni primeri se na schema banka
set search_path = 'banka';
-- da se prikazat site transakcii, zaedno do podatoci za uplakjac i isplakjac
select vreme_izvrsuvanje as datum_izvrsvuanje, t.valuta, t.suma, su.broj_smetka as smetka_uplata, si.broj_smetka as smetka_isplata,
cu.ime as ime_uplakjac, cu.prezime as prezime_uplakjac, ci.ime as ime_isplakjac, ci.prezime as prezime_isplakjac
from transakcija as t
join smetka as su on t.broj_smetka_uplata = su.broj_smetka
join smetka as si on t.broj_transakcija = si.broj_smetka
join klient as ku on su.embg_klient = ku.embg_klient
join klient as ki on si.embg_klient = ki.embg_klient
join chovek as cu on ku.embg_klient = cu.embg
join chovek as ci on ki.embg_klient = ci.embg;

-- da se najde vkupna suma na site denarski transakcii vo sekoj mesec i godina posebno
select extract(month from t.vreme_izvrsuvanje) as mesec, 
extract(year from t.vreme_izvrsuvanje) as godina, sum(suma) as vkupno
from transakcija as t
where valuta ilike 'MKD'
group by mesec,godina
order by godina asc, mesec asc;

-- da se prikaze momentalno saldo na sekoja smetka, zaedno so vkupna suma na prilivi i odlivi
select s.broj_smetka, s.valuta, s.saldo,
transakcii.vkupno_prilivi, transakcii.valuta_priliv,
transakcii.vkupno_odlivi, transakcii.valuta_odliv
from smetka as s
left join(
	select case when prilivi.broj_smetka notnull then prilivi.broj_smetka else odlivi.broj_smetka end as broj_smetka,
			case when prilivi.vkupno isnull then 0 else prilivi.vkupno end as vkupno_prilivi,
			prilivi.valuta as valuta_priliv,
			case when odlivi.vkupno isnull then 0 else odlivi.vkupno end as vkupno_odlivi,
			odlivi.valuta as valuta_odliv
	from(
select s.broj_smetka, t.valuta, sum(t.suma) as vkupno
from smetka as s
join transakcija as t on s.broj_smetka = t.broj_smetka_isplata
group by 1,2) as prilivi
full outer join(
select s.broj_smetka, t.valuta, sum(t.suma) as vkupno
from smetka as s
join transakcija as t on s.broj_smetka = t.broj_smetka_uplata 
group by 1,2) as odlivi on prilivi.broj_smetka = odlivi.broj_smetka and prilivi.valuta = odlivi.valuta ) as transakcii
	on s.broj_smetka = transakcii.broj_smetka
order by s.broj_smetka asc;



----------------------------- Auditoriski vezbi 12/29/2021 -----------------------------
---------- VEZBI ZA POSLOZENI QUERY-NJA ----------
-- da se najdat broj na upati realizirani kaj sekoj oddel vo klinikite kade se realizirani
select ime_klinika , ime_oddel, count(distinct id_upat) as kreiirani,count(distinct id_pregled) as realizirani
from upat as u
join klinika as k on u.id_klinika = k.id_klinika
join oddel as o on u.id_upat = o.id_oddel and u.id_klinika = o.id_klinika
group by ime_klinika , ime_oddel;

-- da se prikazat site specijalnosti, zaedno so broj na odeli i broj na specijalisti so taa specijalnost
select s.id_specijalnost, s.naziv_specijalnost, count(distinct l.embg) as lekari, count(distinct k.id_klinika) as kliniki  
from specijalnost as s
left join lekar as l on s.id_specijalnost = l.id_specijalnost
left join klinika_ima_specijalnost ks on s.id_specijalnost = ks.id_specijalnost
left join klinika k on ks.id_klinika = k.id_klinika
group by s.id_specijalnost, s.naziv_specijalnost;

-- kolku lekari od koja klinika se specijalisti vo sekoja specijalnost
select s.naziv_specijalnost, k.ime_klinika , count(l.embg)
from specijalnost as s
left join lekar as l on s.id_specijalnost = l.id_specijalnost
left join klinika_ima_specijalnost ks on s.id_specijalnost = ks.id_specijalnost
left join klinika k on ks.id_klinika = k.id_klinika
left join lekar_vraboten_klinika as lvk on k.id_klinika = lvk.id_klinika and l.embg = lvk.embg_lekar
where l.embg = lvk.embg_lekar
group by 1,2;

-- schema banka
-- za sekoj klient posebno, da se presmeta suma za site transakcii vo sekoja vlauta posebno, od site negovi smetki
-- uplatite da se presmetuvaat kako pozitivni transakcii, a isplatite kako negativni
select *
from klient as k
join smetka as s on k.embg_klient = s.embg_klient
join transakcija as tu on s.broj_smetka = tu.broj_smetka_uplata 
join transakcija as ti on s.broj_smetka = ti.broj_smetka_isplata








































