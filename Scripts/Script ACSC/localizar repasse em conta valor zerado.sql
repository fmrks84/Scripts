------- conta hospitalar 
select a.cd_repasse,
       a.cd_it_repasse,
        a.cd_lancamento_fat,
       a1.cd_pro_fat,
       a.vl_repasse,
       pf.ds_pro_fat from 
dbamv.it_repasse a 
inner join itreg_Fat a1 on a1.cd_lancamento = a.cd_lancamento_fat and a1.cd_reg_fat = a.cd_reg_fat
inner join pro_fat pf on pf.cd_pro_fat = a1.cd_pro_fat
where a.cd_reg_fat in (293549)
and a.vl_repasse = '0,00'
order by a.cd_lancamento_fat 

------- conta ambulatorial 
select a.cd_repasse,
       a.cd_it_repasse,
        a.cd_lancamento_fat,
       a2.cd_pro_fat,
       a.vl_repasse,
       pf.ds_pro_fat from 
dbamv.it_repasse a 
inner join itreg_amb a2 on a2.cd_lancamento = a.cd_lancamento_amb  and a2.cd_reg_amb = a.cd_reg_amb
inner join pro_fat pf on pf.cd_pro_fat = a2.cd_pro_fat
where a2.cd_reg_amb = 2080114 
and a.vl_repasse = '0,00'
order by a.cd_lancamento_amb

delete from 
it_repasse where cd_it_repasse in (14296397,
14296779,
14363624,
14363617,
14363623,
14363630,
14363621,
14363614,
14363627,
14363619,
14363632,
14363625,
14363618,
14363622,
14363620,
14363629,
14363628,
14363616,
14363631,
14363626,
14363615)



/*select * 
from dbamv.itreg_fat b where b.cd_reg_fat = 250921
and b.sn_repassado = 'S'
and b.cd_gru_fat = 4
--and b.cd_pro_fat in (70034060,00031365)
and b.cd_prestador is null 
order by b.cd_lancamento
*/


