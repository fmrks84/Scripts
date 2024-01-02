----- NESTA QUERY SERÁ APRESENTADO OS VALORES DOS PRODUTOS QUE ESTÃO LIBERADOR PARA CASA SELECIONADA
----- A MESMA APRESENTARÁ OS VALORES DA SIMPRO E BRASINDICE QUE CONSTAM EM SISTEMA 

with prc_simp as (
select 
sp.cd_pro_fat,
sp.cd_simpro,
psp.dt_vigencia,
psp.vl_simpro  
     

       from imp_simpro sp 
inner join precos_simpro psp on psp.cd_simpro = sp.cd_simpro 
inner join log_simpro lsp on lsp.cd_import_simpro = psp.cd_import_simpro and lsp.cd_tab_fat = sp.cd_tab_fat
where sp.cd_tab_fat = 3447
and psp.dt_vigencia = (select max(x.dt_vigencia) from precos_simpro x where  x.cd_simpro = psp.cd_simpro)
),
prc_bras as (
select 
xp.cd_pro_fat,
xp.cd_brasindice,
xp.vl_medicamento vl_brasindice
from 
vw_acsc_prec_brasind xp
where xp.cd_tab_fat = 3447
)

select 
pf.cd_pro_fat||' - '||pf.ds_pro_fat cod_desc_procedimento,
pd.cd_produto||' - '||pd.ds_produto cod_desc_produto,
pd.vl_ultima_entrada,
tps.cd_Simpro,
tps.vl_simpro,
tbr.cd_brasindice,
tbr.vl_brasindice
from 
dbamv.pro_Fat pf 
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto
left join prc_simp tps on tps.cd_pro_fat = pf.cd_pro_fat
left join prc_bras tbr on tbr.cd_pro_fat = pf.cd_pro_fat
where pf.cd_gru_pro in (8,89,95,96)
and pf.sn_ativo = 'S'
and pd.sn_bloqueio_de_compra = 'N'
--AND PD.CD_PRO_FAT = 70272964
and epd.cd_multi_empresa = 4
--order by 2
---
--BRASI, SIMPRO  TAB 3447


/*
;



select 
cd_pro_fat,
cd_brasindice,
vl_medicamento
from
(
with prc_bras as (
select 
distinct
bpr.cd_apresentacao,
max(bpr.vl_medicamento)vl_medicamento,
bpr.cd_medicamento,
bpr.cd_laboratorio

from 
b_precos bpr
inner join log_brasindice lbr on lbr.cd_import = bpr.cd_import
where trunc(lbr.Dt_Vigencia) = (select max(x.Dt_Vigencia) from log_brasindice x where x.cd_import = lbr.cd_import)
group by 
bpr.cd_apresentacao,
bpr.cd_medicamento,
bpr.cd_laboratorio
)
select 
ibra.cd_pro_fat,
ibra.cd_tiss cd_brasindice,
bras.vl_medicamento

from 
imp_bra ibra 
inner join prc_bras bras on bras.cd_apresentacao = ibra.cd_apresentacao
and bras.cd_medicamento = ibra.cd_medicamento
and bras.cd_laboratorio = ibra.cd_laboratorio
where ibra.cd_tab_fat = 3447
)
*/
