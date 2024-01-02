select a.cd_atendimento
      ,b.cd_convenio
      ,h.nm_convenio
      ,b.cd_reg_fat
      ,b.cd_remessa
      ,g.dt_fechamento
      ,d.cd_pro_fat
      ,d.ds_pro_fat
      ,c.dt_lancamento
      ,c.sn_pertence_pacote
      ,c.vl_unitario consumo
 from dbamv.atendime       a
     ,dbamv.reg_fat        b
     ,dbamv.itreg_fat      c
     ,dbamv.pro_fat        d
     ,dbamv.gru_pro        e
     ,dbamv.gru_fat        f
     ,dbamv.remessa_fatura g
     ,dbamv.convenio       h
where a.cd_atendimento = b.cd_atendimento
and   b.cd_reg_fat     = c.cd_reg_fat
and   c.cd_pro_fat     = d.cd_pro_fat
and   d.cd_gru_pro     = e.cd_gru_pro
and   e.cd_gru_fat     = f.cd_gru_fat
and   b.cd_remessa     = g.cd_remessa
and   b.cd_convenio     = h.cd_convenio
and   e.cd_gru_pro     in (09,89,66,96,14)
And   to_date(c.dt_lancamento,'DD/MM/RRRR') between '01/03/2022' and '30/09/2023'
and   b.cd_multi_empresa = 7
order by 1,4,8

;

select  c.*, r.cd_Atendimento, r.cd_reg_Fat conta, r.cd_remessa, f.dt_competencia, i.sn_pertence_pacote
from reg_fat r, itreg_fat i, remessa_fatura rf, fatura f,
(SELECT e.cd_multi_empresa,
       me.ds_multi_empresa,
       i.cd_ord_com,
       to_date (o.dt_ord_com, 'dd/mm/rrrr') dt_ord_com,
       o.tp_situacao,
       p.cd_especie,
       ep.ds_especie,
       i.cd_produto,
       p.ds_produto,
       p.cd_pro_fat,
       i.qt_comprada,
       i.vl_unitario,
       i.vl_total,
       cp.cd_atendimento
  FROM ORD_COM o
 inner join itord_pro i on i.cd_ord_com = o.cd_ord_com
 inner join consumo_paciente cp on cp.cd_consumo_paciente = o.cd_consumo_paciente
 inner join produto p on i.cd_produto = p.cd_produto
 inner join estoque e on o.cd_estoque = e.cd_estoque
 inner join especie ep on p.cd_especie = ep.cd_especie
 inner join multi_empresas me on me.cd_multi_empresa = e.cd_multi_empresa
 where o.tp_situacao = 'A'
   and p.cd_especie in (19, 20)
   and to_date(o.dt_ord_com,'dd/mm/rrrr') between '01/03/2022' and '31/08/2023'
 ORDER BY 1, 3) c
 where r.cd_reg_Fat = i.cd_reg_fat
 and   r.cd_remessa = rf.cd_remessa(+)
 and   rf.cd_fatura = f.cd_fatura(+)
 and   r.cd_atendimento(+) = c.cd_atendimento
 and   i.cd_pro_fat(+) = c.cd_pro_fat
