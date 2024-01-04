select distinct r.cd_pro_fat, p.ds_pro_fat,  r.ds_unidade_xml ds_unidade, i.cd_tiss, i.cd_tuss
from regra_substituicao_proced r, pro_fat p,
(select distinct cd_pro_fat, cd_tiss, cd_tuss from imp_bra where cd_tab_fat in (1081,690)) i
where  r.cd_pro_fat = p.cd_pro_fat
and    r.cd_pro_fat = i.cd_pro_fat
and r.cd_convenio = 112
and r.cd_pro_fat in (select cd_pro_fat from pro_fat where cd_gru_pro in (select cd_gru_pro from gru_pro where tp_gru_pro = 'MD'))
and r.dt_vigencia = (select max(dt_vigencia) from regra_substituicao_proced where cd_convenio = 112 and cd_pro_fat = r.cd_pro_fat)
 
union all
 
select p.cd_pro_fat,  p.ds_pro_fat, p.ds_unidade, i.cd_tiss, i.cd_tuss
from pro_fat p, (select distinct cd_pro_fat, cd_tiss, cd_tuss from imp_bra where cd_tab_fat in (1081,690)) i
where p.cd_gru_pro in (select cd_gru_pro from gru_pro where tp_gru_pro = 'MD')
and    p.cd_pro_fat = i.cd_pro_fat
and p.cd_pro_fat not in (select r.cd_pro_fat
from regra_substituicao_proced r, pro_fat p
where  r.cd_pro_fat = p.cd_pro_fat
and r.cd_convenio = 112
and r.dt_vigencia = (select max(dt_vigencia) from regra_substituicao_proced where cd_convenio = 112 and cd_pro_fat = r.cd_pro_fat))

--select cd_tab_Fat from tab_fat where tab_Fat.Ds_Tab_Fat like '%BRASIN%'--cd_tab_fat in (1081,690)                        


select distinct r.cd_pro_fat, p.ds_pro_fat,  r.ds_unidade_xml ds_unidade, i.cd_simpro, i.cd_tuss
from regra_substituicao_proced r, pro_fat p,
(select distinct cd_pro_fat, cd_simpro, cd_tuss from imp_simpro where cd_tab_fat in (871)) i
where  r.cd_pro_fat = p.cd_pro_fat
and    r.cd_pro_fat = i.cd_pro_fat
and r.cd_convenio = 112
and r.cd_pro_fat in (select cd_pro_fat from pro_fat where cd_gru_pro in (select cd_gru_pro from gru_pro where tp_gru_pro in ('MT','OP')))
and r.dt_vigencia = (select max(dt_vigencia) from regra_substituicao_proced where cd_convenio = 112 and cd_pro_fat = r.cd_pro_fat)
 
union all
 
select p.cd_pro_fat, p.ds_pro_fat, p.ds_unidade, i.cd_simpro, i.cd_tuss
from pro_fat p, (select distinct cd_pro_fat, cd_simpro, cd_tuss from imp_simpro where cd_tab_fat in (871)) i
where p.cd_gru_pro in (select cd_gru_pro from gru_pro where tp_gru_pro = 'MT')
and    p.cd_pro_fat = i.cd_pro_fat
and p.cd_pro_fat not in (select r.cd_pro_fat
from regra_substituicao_proced r, pro_fat p
where  r.cd_pro_fat = p.cd_pro_fat
and r.cd_convenio = 189
and r.dt_vigencia = (select max(dt_vigencia) from regra_substituicao_proced where cd_convenio = 189 and cd_pro_fat = r.cd_pro_fat))
tem menu de contexto
