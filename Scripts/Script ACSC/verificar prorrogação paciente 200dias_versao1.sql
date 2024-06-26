select
       g2.cd_multi_empresa,
       g4.ds_gru_pro,
       trunc(sysdate - trunc(g2.dt_atendimento))dias_internados,
       trunc(sysdate - trunc(g2.dt_atendimento)) - sum(g1.qt_autorizada_convenio)qtd_diarias_pend_aut,
       sum(g1.qt_autorizado)qtd_solicitada,
       sum(g1.qt_autorizada_convenio)qtd_autorizada,
      (sum(g1.qt_autorizado) - sum(g1.qt_autorizada_convenio))qtd_diaria_Ag_autorizacao

from guia g
inner join it_Guia g1 on g.cd_guia = g1.cd_guia
inner join atendime g2 on g2.cd_atendimento = g.cd_atendimento
inner join pro_fat g3 on g3.cd_pro_fat = g1.cd_pro_fat
inner join gru_pro g4 on g4.cd_gru_pro = g3.cd_gru_pro
where g.cd_atendimento in (2639915)--(3261910)--- 2639915
and g3.cd_gru_pro = 1
and g.tp_guia in ('R','I')
group by g2.cd_multi_empresa,
         g4.ds_gru_pro,
         g2.dt_atendimento

;
select 
    nvl(sum(qt_nao_autorizado),0)total_qt_nao_autorizado,
    nvl(sum(qt_autorizado),0)total_qt_autorizado,
    nvl(sum(qt_nao_autorizado) + sum(qt_autorizado),0)total_diarias
   
from
(
select 
      /* case when b.cd_guia is null then sum(1) end qt_nao_autorizado,
       case when b.cd_guia is not null then sum(1) end qt_autorizado*/
*         
from reg_Fat a 
inner join itreg_fat b on b.cd_reg_fat = a.cd_reg_fat
where a.cd_atendimento = 2639915
and a.cd_convenio = 152
and b.cd_gru_fat = 1
group by b.cd_guia
)

;

select * from ensemble.vw_atendimento_faturamento where cd_Atendimento in (2639915);

select /*sum(quantidade_diarias_solicitada)total_diarias_solicitados,
       sum(quantidade_diarias_autorizados)total_diarias_autorizadas */
       *
from ensemble.vw_autorizacao_faturamento 
where cd_atendimento in (3261910); --, 




