/*select 
*
from

it_repasse x where x.Cd_Reg_Amb in
(*/
select *
  from reg_amb
 where cd_convenio = 152 and cd_remessa in 
 (select cd_remessa
          from remessa_fatura
         where cd_fatura in
         (select cd_fatura
                  from fatura
                 where dt_competencia = '01/02/2023'))

   and cd_reg_amb in (select cd_reg_amb
                        from itreg_amb
                       where cd_atendimento in
                       (select cd_atendimento
                                from atendime
                               where tp_atendimento = 'U'))
                            --   )
                               
-- C2302/1584
