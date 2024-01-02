select a.cd_reg_fat,
       a.cd_pro_fat,
       a.hr_lancamento,
       b.sn_fechada,
      -- a.cd_lancamento,
       a.qt_lancamento
     -- count(*)
from dbamv.itreg_Fat a
inner join dbamv.Reg_Fat b on b.cd_reg_fat = a.cd_conta_pai
where 1=1     
and a.cd_gru_fat = 2
and b.cd_convenio = 379
--and to_char (a.hr_lancamento,'dd/mm/yyyy') = '09/02/2017'-- 14:48:00') 
and a.cd_pro_fat in (75000002,75000001,75000004,75000003)
and a.cd_reg_fat in (1353223)-- (1357600,1357599,1357602,1357425,1357597) 
--and a.hr_lancamento > = '31/01/2017'
--and b.sn_fechada = 'N'
order by 2 , 3
for update 
/*group by 
       a.cd_reg_fat,
       a.cd_pro_fat,
       a.hr_lancamento,
       b.sn_fechada,
       a.cd_lancamento
having count (*) >= 2
order by a.hr_lancamento,a.cd_pro_fat

--for update 
*/
