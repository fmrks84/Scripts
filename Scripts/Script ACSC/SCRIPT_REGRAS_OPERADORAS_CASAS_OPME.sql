select  xx.cd_aviso_cirurgia,xx.cd_convenio,xx.cd_con_pla
from cirurgia_aviso xx where xx.cd_aviso_cirurgia in (433974);

select xp.tp_opme_vl_referencia from empresa_convenio xp where xp.cd_convenio in 
 (select xx.cd_convenio  from cirurgia_aviso xx where xx.cd_aviso_cirurgia = 433974);


with tab_referencia as (
select 
TF.CD_TAB_FAT,
TF.DS_TAB_FAT,
case when tf.ds_tab_fat like '%SIMPRO' then 'SIMPRO_PURA'
     when tf.ds_tab_fat like '%MATER%BRADESCO%' then 'TABELA_PROPRIA_BRADESCO'
     when tf.ds_tab_fat like '%MATER%SAS%' then 'TABELA_PROPRIA_SULAMERICA'
     when tf.ds_tab_fat like '%MATER%CNU%' then 'TABELA_PROPRIA_CNU'
     when tf.ds_tab_fat like 'HSC%MAT%CONG%PETR%' then 'MATERIAL_TABELA_PROPRIA_PETROBRAS'
     when tf.ds_tab_fat like 'CSSJ%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HCNSC%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HST%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like 'HSJ%MAT%CONG%PETR%' then 'MATERIAL_SIMPRO_CONGELADA_PETROBRAS_03-2022'
     when tf.ds_tab_fat like '%MAT%CONG%UNIM%' then 'MATERIAL_CONGEL_UNIMED_SEGUROS'
     when tf.ds_tab_fat like 'HCNSC%MAT%UNIM%RIOS' then 'MATERIAL_CONGEL_UNIMED_3_RIOS'
     when tf.ds_tab_fat like '%MAT%ASSIM' then 'MATERIAL_SIMPRO_CONGELADA_ASSIM_01-2021'
     when tf.ds_tab_fat like '%HST%ASSIM%MATERIA%' then 'MATERIAL_SIMPRO_CONGELADA_ASSIM_01-2021'
     when tf.ds_tab_fat like '%SEGUROS%UNIM%CONGEL%' then 'MATERIAL_CONGEL_UNIMED_SEGUROS'
     when tf.ds_tab_fat like '%MATER%AMIL%' then 'MATERIAL_SIMPRO_CONGELADA_AMIL_03-2019'
     when tf.ds_tab_fat like '%MATER%SOMPO%' then 'MATERIAL_SIMPRO_CONGELADA_SOMPO_07-2017'
     when tf.ds_tab_fat like '%CASSI%MATER%' then 'MATERIAL_TABELA_PROPRIA_CASSI'
     when tf.ds_tab_fat like '%CASSI%MAT%CONG%' then 'MATERIAL_TABELA_PROPRIA_CASSI'
     when tf.ds_tab_fat like '%MATER%VIVEST%' then 'MATERIAL_TABELA_PROPRIA_VIVEST'
     when tf.ds_tab_fat like '%HSC%MATER%NOTRE%INTER%' then 'MATERIAL_TABELA_PROPRIA_NOTRE_INTERM'
     when tf.ds_tab_fat like '%HST%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_01-05-2022'
     when tf.ds_tab_fat like '%HCNSC%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_30-03-2022'
     when tf.ds_tab_fat like '%HSJ%MATER%NOTRE%INTER%' then 'MATERIAL_SIMPRO_CONGELADA_NOTRE_INTERM_09-04-2022'
     when tf.ds_tab_fat like '%MATER%FRIBURGO%' then 'MATERIAL_TABELA_PROPRIA_FRIBURGO'
     when tf.ds_tab_fat like '%CNEN%MATE%' then 'MATERIAL_TABELA_PROPRIA_CNEN'
     when tf.ds_tab_fat like '%HSC%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HSC'
     when tf.ds_tab_fat like '%HCNSC%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HCNSC'
     when tf.ds_tab_fat like '%HST%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_HST'
     when tf.ds_tab_fat like '%CSSJ%MATE%ESP%' then 'MATERIAL_ESPECIAL_TABELA_PROPRIA_CSSJ'
     when tf.ds_tab_fat like '%HSC%MATE%DESC%' then 'MATERIAL_DESCONTINUADO_TABELA_PROPRIA_HSC'
     when tf.ds_tab_fat like '%HMRP%OPME' then 'MATERIAL_OPME_TABELA_PROPRIA_HMRP'


     ELSE 'X'
     END TABELA_REFERENCIA    
from
tab_fat tf 
where (tf.ds_tab_fat like '%HSC%MAT%'
OR  tf.ds_tab_fat like '%CSSJ%MAT%'
OR  tf.ds_tab_fat like '%HST%MAT%'
OR  tf.ds_tab_fat like '%HSJ%MAT%'
OR  tf.ds_tab_fat like '%HMRP%MAT%'
OR  tf.ds_tab_fat like '%HCNSC%MAT%'
OR  tf.ds_tab_fat like '%OPME%')
and tf.ds_tab_fat not like '%INATIVO%'
and tf.ds_tab_fat not like '%BRASIND%'
and tf.ds_tab_fat not like '%PARTI%'
and tf.cd_tab_fat not in (3447)
order by 1
)


select 
decode(econv.cd_multi_empresa, '3','CSSJ','4','HST','7','HSC','10','HSJ','11','HMRP','25','HCNSC')casa,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
pf.cd_pro_fat,
pf.ds_pro_fat,
lpd.cd_produto,
lpd.cd_registro anvisa,
case when pf.ds_pro_fat not like '%REF%' then null
     else substr(pf.ds_pro_fat,instr(pf.ds_pro_fat,' REF')+5,50)
     end referencia,
irg.cd_regra,
rg.ds_regra,
irg.cd_gru_pro,
gp.ds_gru_pro,
vp.dt_vigencia,
tf.cd_tab_fat,
tf.ds_tab_fat,
trf.tabela_referencia,
irg.vl_percetual_pago,
case when irg.vl_percetual_pago < =100 then (100-irg.vl_percetual_pago)
  else 0
  end deflator_perc,
  case when irg.vl_percetual_pago > =100 then ((irg.vl_percetual_pago)-100)
 else 0
  end inflator_perc,
vp.vl_total vl_total_puro,
(vp.vl_total * irg.vl_percetual_pago)/100 valor_a_cobrar,
econv.tp_opme_vl_referencia

from 
dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio 
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = conv.cd_convenio
inner join dbamv.regra rg on rg.cd_regra = ecpla.cd_regra
inner join dbamv.itregra irg on irg.cd_regra = rg.cd_regra
inner join dbamv.pro_fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
left join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
left join tab_fat tf on tf.cd_tab_fat = irg.cd_tab_fat
left join val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat and vp.cd_pro_fat = pf.cd_pro_fat
left join produto pd on pd.cd_pro_fat = pf.cd_pro_fat 
left join lab_pro lpd on lpd.cd_produto = pd.cd_produto
left join empresa_produto epr on epr.cd_produto = pd.cd_produto and econv.cd_multi_empresa = epr.cd_multi_empresa
left join tab_referencia trf on trf.cd_Tab_fat = vp.cd_tab_fat
where trunc(vp.dt_vigencia) = (select max(trunc(vpx.dt_vigencia))from val_pro vpx where vpx.cd_pro_fat = vp.cd_pro_fat and vpx.cd_tab_fat = vp.cd_tab_fat)
and gp.cd_gru_pro in (select x.cd_gru_pro from gru_pro x where x.tp_gru_pro in ('MD','OP','MT'))
--and (irg.cd_gru_pro in (9,89,95,96) or pf.sn_opme = 'S')-- grupos opmes deixar fixado 
and conv.cd_convenio = 8
and vp.cd_pro_fat in ('00127409') --00016102,70760462
and cpla.cd_con_pla = 1
and conv.tp_convenio = 'C'
and conv.sn_ativo = 'S'
and econv.sn_ativo = 'S'
and ecpla.sn_ativo = 'S'
and econv.cd_multi_empresa in (3,4,7,10,11,25) -- multi_empresas 
and conv.nm_convenio not like '%SMO%'
and conv.nm_convenio not like '%COVID%'
group by 
econv.cd_multi_empresa,
irg.cd_regra,
rg.ds_regra,
pf.cd_pro_fat,
pf.ds_pro_fat,
gp.tp_gru_pro,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
vp.dt_vigencia,
tf.cd_tab_fat,
tf.ds_tab_fat,
lpd.cd_registro,
lpd.cd_produto,
irg.vl_percetual_pago,
vp.vl_total,
econv.tp_opme_vl_referencia,
trf.tabela_referencia
order by casa ,conv.cd_convenio, cpla.cd_con_pla--irg.cd_regra,tf.cd_tab_fat,irg.vl_percetual_pago

--select * from pro_fat where cd_pro_fat = '09068018'

/*;
select * from val_pro where cd_pro_fat = 00275589 and cd_Tab_fat = 2 
--select * from pro_fat where cd_pro_fat = '00275589'

select * from produto where cd_pro_fat in (00275589,70760462)*/
/*-- As Informações obtidas refere-se as regras acordadas conforme contrato com as operdoras,caso a informação esteja divergente entre em contato com o setor comercial 
select * from gru_pro where cd_gru_pro in (8,9,89,95,96)
select * from pro_fat where cd_pro_fat = '00275589'
select * from gru_pro where cd_gru_pro = 8 */

--348457--
--4783017
--select * from gru_pro where cd_gru_pro = 89
--select * from cirurgia_Aviso where cd_aviso_cirurgia = 348672

--select * from itreg_fat where cd_reg_fat = 529152
--select * from sys.itreg_fat_audit x where  x.cd_reg_Fat in (529152)--,479796)--(304957)
