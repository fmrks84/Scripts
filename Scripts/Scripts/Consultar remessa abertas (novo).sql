Select x.cd_atendimento, x.cd_multi_empresa, x.cd_reg_fat, x.dt_inicio, x.dt_final, x.sn_fechada, x.dt_fechamento, x.cd_remessa
from   dbamv.reg_fat x where x.cd_remessa in (select f.cd_remessa from dbamv.remessa_fatura f where nvl(f.cd_remessa_pai,f.cd_remessa) In (55035))
order by x.cd_atendimento, x.cd_multi_empresa
