select DISTINCT
        sj3.cd_atendimento,
        sj1.cd_reg_fat,
        sj4.nm_paciente,
        sj1.cd_multi_empresa,
        sj1.vl_total_conta,
 (select sum(SJ1.vl_total_conta) from dbamv.reg_fat SJ1) total
from dbamv.Reg_Fat sj1,
              dbamv.convenio sj2,
              dbamv.atendime sj3,
              dbamv.paciente sj4
 

      
where sj1.cd_convenio in (352,379)
and sj1.sn_fechada = 'N'
and sj1.cd_multi_empresa in (1,2)
and sj1.cd_multi_empresa = sj3.cd_multi_empresa
and sj1.cd_convenio = sj3.cd_convenio
and sj3.cd_paciente = sj4.cd_paciente
and sj3.cd_atendimento = sj1.cd_atendimento
and sj1.vl_total_conta is not null
and sj3.DT_ATENDIMENTO between '01/05/2016' and '29/05/2016'
