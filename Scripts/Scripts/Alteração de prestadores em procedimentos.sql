select i.cd_prestador
,cd_pro_Fat, dt_lancamento, cd_lancamento
from  Dbamv.itreg_Fat I
where i.cd_prestador not in 299 ---- nesse campo colocar o prestador que irá ser colocado no lugar do atual--
and   i.cd_pro_fat in ('51010194','51010399','51010470')
and   i.dt_lancamento > '01/08/2013'
and   i.cd_reg_fat in (select r.cd_reg_fat 
                       from   Dbamv.reg_fat r 
                       where  r.cd_atendimento in (select a.cd_atendimento
                                                   from   Dbamv.atendime a 
                                                   where  a.CD_MULTI_EMPRESA = 1)) 
order by dt_lancamento for update;

