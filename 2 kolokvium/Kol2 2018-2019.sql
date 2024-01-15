--Задача 1 (10 поени): Да се излистаат сите клиенти на банката од Скопје и Охрид 
--со нивните телефонски броеви(доколку се внесени)
--Резултат(embg, ime, prezime, adresa_ziveenje, telefonski_broj)
select k.embg_klient, c.ime, c.prezime, k.adresa_ziveenje, tb.telefonski_broj 
from klient as k
left join chovek as c on k.embg_klient = c.embg
left join grad as g on k.id_grad = g.id_grad
left join telefonski_broj as tb on k.embg_klient = tb.embg_klient
where g.ime_grad ilike 'Skopje' or g.ime_grad ilike 'Ohrid';


--Задача 2 (10 поени): Да се прикаже вкупната сума на трансакции 
--во ЕУР или УСД извршени во банката во секоја година посебно
--Резултат: (godina,suma)
select extract(year from t.vreme_izvrsuvanje) as godina, sum(suma) as suma
from transakcija as t
where valuta ilike 'EUR' or valuta ilike 'USD'
group by 1;


--Задача 3 (15 поени): Да се прикаже вкупниот број на извршени трансакции на уплата
--во валута МКД од секоја сметка посебно. Доколну нема такви трансакции да се прикаже 0
--Резултат: (broj_smetka, suma)
select broj_smetka, count(t.broj_transakcija) as suma
from transakcija as t
left join smetka as s on t.broj_smetka_uplata = s.broj_smetka
where t.valuta ilike 'MKD'
group by 1;


--Задача 4 (20 поени): Да се излистаат сите вработени во банката, во која филијала работат
--како и името и презимето на нивниот шеф.
--Резултат: (embg_vraboten,ime_vraboten,prezime_vraboten,id_filijala,adresa_filijala,grad_filijala,
--embg_shef,ime_shef,prezime_shef)
select v.embg as embg_vraboten, c.ime as ime_vraboten, c.prezime as prezime_vraboten,
f.id_filijala, f.adresa_filijala, g.ime_grad as grad_filijala,
v.embg_shef as embg_shef, csef.ime as ime_shef, csef.prezime as prezime_shef
from vraboten as v
left join filijala as f on v.id_filijala = f.id_filijala 
left join grad as g on f.id_grad = g.id_grad 
left join chovek as c on v.embg = c.embg --za vraboten
left join chovek as csef on v.embg_shef = csef.embg; --za shef


--Задача 5 (20 поени): За секој вработен, да се излиста на колку луѓе е шеф и колкав е бројот
--на сметки кои тој ги отворил. Доколку не е шеф на никого, во таа колона да се прикаже 0.
--Доколку не отворил ниту една сметка, во таа колона да се прикаже 0.
--Резултат: (embg, ime, prezime, broj_vraboteni_shef, broj_otvoreni_smetki)
select v.embg, c.ime ,c.prezime ,
count(distinct v2.embg)as broj_vraboteni_shef,
count(distinct ov.broj_smetka) as broj_otvoreni_smetki
from vraboten v
left join chovek c on v.embg =c.embg 
left join vraboten v2 on v.embg = v2.embg_shef 
left join otvorena_vo ov on v.embg  =ov.embg_vraboten
group by v.embg ,c.ime,c.prezime


--Задача 6 (25 поени): За секој клиент кој живее во Скопје, да се најде вкупен број на
--извршени трансакции на испалта, вкупен број на извршени трансакции на уплата, на сите 
--сметки од тој клиент.
--Резултат(embg, ime, prezime, broj_uplati, broj_isplati)
select c.embg, c.ime, c.prezime, 
count(distinct tisplata.broj_transakcija), 
count(distinct tuplata.broj_transakcija)
from klient as k
left join chovek as c on k.embg_klient = c.embg 
left join grad as g on k.id_grad = g.id_grad 
left join smetka as s on k.embg_klient = s.embg_klient 
left join transakcija as tisplata on s.broj_smetka = tisplata.broj_smetka_isplata 
left join transakcija as tuplata on s.broj_smetka = tuplata.broj_smetka_uplata
where g.ime_grad ilike 'Skopje'
group by 1,2,3;

















