--Задача 1 (10 поени): Да се прикажат сите клиники кои во името содржат „medika“ заедно со
--нивните вработени лекари (доколку ги има) и специјалностите на лекарите (доколку ги има).
--Резултат: (id_klinika, ime_klinika, ulica, broj, embg_lekar, ime_lekar, prezime_lekar,
--naziv_specijalnost_lekar)
select k.id_klinika, k.ime_klinika, k.ulica, k.broj, l.embg as embg_lekar, 
c.ime as ime_lekar, c.prezime as prezime_lekar, s.naziv_specijalnost as naziv_specijalnost_lekar
from klinika as k
left join lekar_vraboten_klinika as lvk on k.id_klinika = lvk.id_klinika
left join lekar as l on lvk.embg_lekar = l.embg
left join chovek as c on l.embg = c.embg
left join specijalnost as s on l.id_specijalnost = s.id_specijalnost
where k.ime_klinika ilike '%medika%';


--Задача 2 (10 поени): Да се прикаже вкупниот број на упати закажани и одржани секој месец и година.
--Резултат: (mesec, godina, broj_zakazani, broj_odrzani)
select extract(month from termin) as mesec, extract(year from termin) as godina, 
count(id_upat) as broj_zakazani, count(id_pregled) as broj_odrzani
from upat
group by mesec,godina;


--Задача 3 (15 поени): Да се прикаже кај секој пациент која дијагноза колку пати ја има
--дијагностицирано. Да се прикажат и пациентите кај кои нема ниту една дијагноза.
--Резултат: (embg_pacient, ime_pacient, prezime_pacient, mkb10, opis_dijagnoza, broj_dijagnozi)
select pr.embg_pacient, ch.ime as ime_pacient, ch.prezime as prezime_pacinet, 
d2.mkb10, d2.opis as opis_dijagnoza, count(d2.mkb10) as broj_dijagnozi
from pacient as p
join chovek as ch on p.embg  = ch.embg
left join pregled as pr on p.embg = pr.embg_pacient
left join dijagnosticira as d on pr.id_pregled  = d.id_pregled 
left join dijagnoza as d2 on d.mkb10 = d2.mkb10
group by 1,2,3,4,5;


--Задача 4 (20 поени): Да се прикажат сите упати закажани следниот месец заедно со нивните
--детали (доколку ги има) во овој формат:
--Резултат: (embg_pacient, termin, ime_pacient, prezime_pacient,
--ime_lekar_upatuva, prezime_lekar_upatuva, ime_lekar_upaten, prezime_lekar_upaten,
--naziv_specijalnost_lekar_upaten, ime_klinika, ime_oddel)
select cp.embg as embg_pacient, u.termin, cp.ime as ime_pacient, cp.prezime as prezime_pacient,
clupatuva.ime as ime_lekar_upatuva, clupatuva.prezime as prezime_lekar_upatuva,
clupaten.ime as ime_lekar_upaten, clupaten.prezime as prezime_lekar_upaten,
s.naziv_specijalnost as naziv_specijalnost_lekar_upaten, k.ime_klinika, o.ime_oddel
from upat as u
left join klinika as k on u.id_klinika = k.id_klinika 
left join oddel as o on u.id_oddel = o.id_oddel
left join pacient as p on u.embg_pacient = p.embg 
left join chovek as cp on p.embg = cp.embg --od tuka za pacient
left join lekar as lupatuva on u.embg_lekar_upatuva = lupatuva.embg -- lekar koj upatuva
left join chovek as clupatuva on lupatuva.embg = clupatuva.embg 
left join lekar as luptaen on u.embg_lekar_upaten = luptaen.embg -- lekar kaj koj e upaten
left join chovek as clupaten on luptaen.embg = clupaten.embg 
left join specijalnost as s on luptaen.id_specijalnost = s.id_specijalnost 
where extract(month from u.termin) = extract(month from now()) + 1;


--Задача 5 (20 поени): За секој лекар да се најде колку прегледи извршил, колку упати биле
--креирани за него, колку од тие упати биле реализирани, колку вкупно дијагнози поставил и
--колку различни дијагнози биле поставени од него.
--Резултат: (embg_lekar, ime_lekar, prezime_lekar, broj_pregledi, broj_kreirani_upati,
--broj_realizirani_upati, broj_dijagnozi, broj_razlicni_dijagnozi)
select l.embg as embg_lekar, c.ime as ime_lekar, c.prezime as prezime_lekar,
count(p.id_pregled) as broj_pregledi, count(u.id_upat) as broj_kreirani_upati,
count(u.id_pregled) as broj_realizirani_upati, count(d.mkb10) as broj_dijagnozi, count(distinct d.mkb10) as broj_razlicni_dijagnozi
from lekar as l
left join chovek as c on l.embg = c.embg
left join pregled as p on l.embg = p.embg_lekar
left join upat as u on l.embg = u.embg_lekar_upaten 
left join dijagnosticira as d on p.id_pregled = d.id_pregled
group by 1,2,3;


--Задача 6 (25 поени): На шемата банка: да се прикаже месечниот промет на секоја сметка во
--секој месец и година во која има извршено трансакции, по секоја валута на трансакција
--Резултат: (mesec, godina, valuta, promet)
select extract(month from vreme_izvrsuvanje) as mesec, extract(year from vreme_izvrsuvanje) as godina, s.valuta, sum(suma) as promet
from smetka as s
join transakcija as t on s.broj_smetka = t.broj_smetka_isplata
group by 1,2,3;


























