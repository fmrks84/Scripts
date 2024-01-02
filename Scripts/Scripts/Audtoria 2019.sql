/*SELECT 
       SUM(VL)
FROM       
(*/
select cd_atendimento ATENDIMENTO, 
       dt_atendimento DATA_ATENDIMENTO,
       dt_alta DATA_ALTA,
       cd_reg_amb CONTA_AMBULATORIO , 
       cd_reg_fat CONTA_HOSPITALAR,
        dt_inicio,
        dt_final,
       sum(vl_itfat_nf)VALOR ,
       nr_id_nota_fiscal RPS,
       dt_emissao DT_EMISSAO_RPS,
       nr_nota_fiscal_nfe NF_E,
       hr_emissao_nfe DT_EMISSAO_NF_E,
       DECODE(CD_MULTI_EMPRESA,'1','HMSJ','2','PROMATRE','13','HMSM')EMPRESA
    

from
(
select 
       a.cd_atendimento, 
       b.dt_atendimento,
       b.dt_alta,
       a.cd_reg_amb , 
       a.cd_reg_fat,
      d.dt_inicio,
      d.dt_final,
       a.vl_itfat_nf ,
       c.nr_id_nota_fiscal,
       c.dt_emissao,
       c.nr_nota_fiscal_nfe,
       c.hr_emissao_nfe,
       C.CD_MULTI_EMPRESA
from dbamv.itfat_nota_fiscal a ,
     dbamv.tb_atendime       b ,
     dbamv.nota_fiscal       c,
     dbamv.reg_Fat           d
   --  dbamv.reg_amb           e,
    -- dbamv.itreg_amb         f
     
where a.cd_atendimento = b.cd_atendimento
and   c.cd_nota_fiscal = a.cd_nota_fiscal
and   a.cd_reg_fat     = d.cd_reg_fat(+)
--and   a.cd_reg_amb     = e.cd_reg_amb 
--and   c.cd_reg_amb     =  a.cd_reg_amb
--and   f.cd_reg_amb     =  a.cd_reg_amb
--and C.NR_ID_NOTA_FISCAL = 203057--a.cd_nota_fiscal = 357096
--AND A.CD_ATENDIMENTO = 1844147
--and a.cd_atendimento = 1900520
AND C.CD_MULTI_EMPRESA IN (1,2,13)
AND C.DT_EMISSAO BETWEEN '01/01/2019' AND SYSDATE
AND C.DT_CANCELAMENTO IS NULL
)group by 
       cd_atendimento, 
       dt_atendimento,
       dt_alta,
       cd_reg_amb , 
       cd_reg_fat,
       dt_inicio,
      dt_final,
      -- a.vl_itfat_nf ,
       nr_id_nota_fiscal,
       dt_emissao,
       nr_nota_fiscal_nfe,
       hr_emissao_nfe,
       CD_MULTI_EMPRESA
ORDER BY    nr_id_nota_fiscal   
      
--)      
