CREATE OR REPLACE VIEW dbamv.vw_acsc_prec_brasind 
(
cd_pro_fat,
cd_brasindice,
vl_medicamento,
cd_tab_fat
)
as

(
select 
cd_pro_fat,
cd_brasindice,
vl_medicamento,
cd_tab_fat
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
bras.vl_medicamento,
ibra.cd_tab_fat
from 
imp_bra ibra 
inner join prc_bras bras on bras.cd_apresentacao = ibra.cd_apresentacao
and bras.cd_medicamento = ibra.cd_medicamento
and bras.cd_laboratorio = ibra.cd_laboratorio
where 1 = 1 
));

GRANT SELECT ON dbamv.vw_acsc_prec_brasind TO acsc_fabio_santos;
GRANT SELECT ON dbamv.vw_acsc_prec_brasind TO acsc_afonso_faria;
GRANT SELECT ON dbamv.vw_acsc_prec_brasind TO rsc_laila_hamzi;

