--select cd_pro_fat from dbamv.produto where cd_produto = 2030664
-- 52895 item de prescrição
--90268733 cod_procedimento 


select *
from dbamv.itsolsai_pro a 
inner join dbamv.solsai_pro b on b.cd_solsai_pro = a.cd_solsai_pro 
inner join itreg_amb c on c.cd_atendimento = b.cd_atendimento
inner join dbamv.reg_amb c1 on c1.cd_reg_amb = c.cd_reg_amb
inner join dbamv.atendime d on d.cd_atendimento = c.cd_atendimento 
inner join dbamv.produto p on p.cd_produto = a.cd_produto and p.cd_pro_fat = c.cd_pro_fat
inner join dbamv.tip_presc tp on tp.cd_produto = p.cd_produto
inner join dbamv.itpre_med ipm on ipm.cd_tip_presc = tp.cd_tip_presc and ipm.cd_produto = tp.cd_produto
where a.cd_produto = 2030664
and d.cd_multi_empresa = 3
and trunc(b.dt_solsai_pro) between '01/01/2020' and sysdate 
and d.cd_convenio = 72
--and b.dt_solsai_pro = sysdate - 10
--


--- atendimento = 2350666
