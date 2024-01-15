--Задача 1 (10 поени): Да се излистаат сите клиенти на банката кои имаат валиден ЕМБГ (13
--цифри) со нивните телефонски броеви (доколку се внесени броеви).
--Резултат: (embg, ime, prezime, adresa_ziveenje, telefonski_broj)
select ch.embg, ch.ime, ch.prezime, k.adresa_ziveenje, tb.telefonski_broj
from klient as k
left join chovek as ch on k.embg_klient = ch.embg 
left join telefonski_broj as tb on k.embg_klient = tb.embg_klient
where char_length(ch.embg) = 13;


--Задача 2 (10 поени): Да се прикаже вкупната сума на денарски трансакции извршени во банката во секој месец посебно (без година).
--Резултат: (mesec, suma)
select extract(month from vreme_izvrsuvanje) as mesec, sum(suma)
from transakcija as t
where valuta = 'MKD'
group by 1;


--Задача 3 (15 поени): Да се прикаже вкупниот број на шалтерски работници (работно место
--Shalter) во секоја филијала посебно. Доколку нема шалтерски работници во дадена филијала, да се прикаже 0.
--Резултат: (id_filijala, adresa_filijala, ime_grad, br_shalterski_rabotnici)
select f.id_filijala, f.adresa_filijala, g.ime_grad, 
count(case when v.rabotno_mesto='Shalter' then 1 else null end) as br_shalterski_rabotnici
from filijala as f
left join vraboten as v on f.id_filijala = v.id_filijala
left join grad as g on f.id_grad = g.id_grad
group by 1,2,3;


--Задача 4 (20 поени): Да се прикажат сите извршени трансакции во тековниот месец, заедно
--со име и презиме на уплаќач и име и презиме на исплатениот клиент.
--Резултат: (embg_uplakjach, ime_uplakjach, prezime_uplakjach, embg_isplaten, ime_isplaten,
--prezime_isplaten, valuta, suma, vreme_transakcija)
select 	suplata.embg_klient as embg_uplakjach, csuplata.ime as ime_uplakjach, csuplata.prezime as prezime_uplakjach,
		sisplata.embg_klient as embg_isplaten, csisplata.ime as ime_isplaten, csisplata.prezime as prezime_isplaten,
		t.valuta, t.suma, t.vreme_izvrsuvanje as vreme_transakcija
from transakcija as t
left join smetka as suplata on t.broj_smetka_uplata = suplata.broj_smetka --smetka uplata
left join klient as kuplata on suplata.embg_klient = kuplata.embg_klient
left join chovek as csuplata on kuplata.embg_klient = csuplata.embg
left join smetka as sisplata on t.broj_smetka_isplata = sisplata.broj_smetka --smetka isplata
left join klient as kisplata on sisplata.embg_klient = kisplata.embg_klient 
left join chovek as csisplata on kisplata.embg_klient = csisplata.embg
where extract(month from vreme_izvrsuvanje) = extract(month from now()) and 
extract(year from vreme_izvrsuvanje) = extract(year from now());


--Задача 5 (20 поени): За секој град да се прикаже колку филијали има во градот и колку
--клиенти има банката во тој град. Доколку нема клиенти да се прикаже 0. Доколку нема
--филијали, да се прикаже 0.
--Резултат: (id_grad, ime_grad, broj_filijali, broj_klienti)
select gr.id_grad, ime_grad,
count(distinct f.id_filijala) as br_filijali, 
count(distinct k.embg_klient) as broj_klienti
from grad as gr
left join filijala as f on gr.id_grad = f.id_grad
left join klient as k on gr.id_grad = k.id_grad
group by 1,2 order by 1;


--Задача 6 (25 поени): Да се прикаже вкупната сума на исплатени пари во денари кон сите
--клиенти со место на живеење во Скопје, кон сметките отворени во филијала во Скопје.
--Сумата да се прикаже по секоја година посебно.
--Резултат: (godina, suma)
select extract(year from t.vreme_izvrsuvanje), sum(suma)
from klient as k
left join grad as g on k.id_grad = g.id_grad
left join smetka as sispalta on k.embg_klient = sispalta.embg_klient 
left join transakcija as t on t.broj_smetka_isplata = sispalta.broj_smetka 
left join smetka as suplata on t.broj_smetka_uplata = suplata.broj_smetka
left join otvorena_vo as ov on suplata.broj_smetka = ov.broj_smetka 
left join filijala as f on ov.id_filijala = f.id_filijala 
left join grad as g2 on f.id_grad = g2.id_grad 
where g.ime_grad = 'Skopje' and t.valuta = 'MKD' and g2.ime_grad = 'Skopje'
group by 1;



