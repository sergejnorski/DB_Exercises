--1. (10) За секој град да се најде колку аптеки има. Доколку во градот нема аптеки, да се
--прикаже нула. Резултатна табела: (id_grad, grad_ime, broj_apteki)
select g.id_grad, g.ime_grad, count(a.id_apteka) as broj_apteki
from apteki as a
right join gradovi as g on a.id_grad = g.id_grad
group by 1,2;


--2. (15) Да се излистаат сите сметки со кои има продадено лек чиј АТЦ код започнува со А02.
--Резултатна табела: (id_grad, grad_ime, broj_apteki)id_smetka)
select s.id_smetka 
from smetki as s
left join prodazba as p on s.id_smetka = p.id_smetka
left join lekovi as l on p.id_lek = l.id_lek
where l.atc_code ilike 'A02%';


















