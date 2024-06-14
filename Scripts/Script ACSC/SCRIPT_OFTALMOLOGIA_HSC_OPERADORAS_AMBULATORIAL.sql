with oftalmo as (
select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro
from dbamv.pro_Fat pf where pf.cd_pro_Fat in ('20101198','41301129','41401301','41301242','41301471','41401271',
'10101012','10101039','10102019','41301307','30304032','20104324','30301017','41301323','40901530','41301420',
'41301250','41301498','41301200','41301170','30313066','41301030','30306043','30302137','30301084','30301114',
'30301157','30313023','30301165','30301220','30301190','30301262','30301211','30303052','30305047','30301149',
'30311039','30302110','30301254','30311047','30301181','30310032','30306060','30306019','30301246','30301041',
'30308038','30303109','30303044','30309026','30305012','30304032','30303087','30301033','30301050','30304105',
'30304091','30101352','30306078','30301130','30304067','30301238','30303060','30302021','30302056','30302072',
'30301203','30305020','30301173','30309018','30302048','20104324','30301076','30303010','30303079','30303095',
'30304016','30304024','30304059','30304075','30305039','30310067','30310105','30313015','30313040','30313074',
'30303028','30308011','30311012','30301025','30307139','30311055','30310040','30302013','30313031','30306035',
'30306035','30306051','30302064','30312132','30302080','30309034','30313058','30307120','30306027','30307147',
'30304113','30304121','31501010','30301068','30312094','30301092','30301270') 
)
--;

select 
decode(ecpla.sn_permite_ambulatorio,'S','Ambulatorio')Cobertura,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
cpla.cd_regra,
rg.ds_regra,
oft.cd_pro_Fat ,
oft.ds_pro_fat,
oft.cd_gru_pro,
gp.ds_gru_pro,
irg.cd_tab_fat,
tf.ds_tab_fat,
vp.dt_vigencia dt_ult_vigencia,
vp.vl_total vl_ult_vigencia

from 
dbamv.convenio conv 
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio and conv.tp_convenio = 'C'
and econv.sn_ativo = 'S'
and conv.sn_ativo = 'S'
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio and cpla.sn_ativo = 'S'
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_convenio = conv.cd_convenio and cpla.cd_con_pla = ecpla.cd_con_pla
and ecpla.cd_multi_empresa = econv.cd_multi_empresa and ecpla.sn_permite_ambulatorio = 'S'
inner join dbamv.regra rg on rg.cd_regra = cpla.cd_regra
inner join dbamv.itregra irg on irg.cd_regra = rg.cd_regra
left join oftalmo oft on oft.cd_gru_pro = irg.cd_gru_pro
inner join dbamv.tab_Fat tf on tf.cd_tab_fat = irg.cd_tab_fat
left join dbamv.val_pro vp on vp.cd_tab_fat = irg.cd_tab_fat and vp.cd_pro_fat = oft.cd_pro_fat 
inner join dbamv.gru_pro gp on gp.cd_gru_pro = oft.cd_Gru_pro
where trunc(vp.dt_vigencia) = (select max(vpx.dt_vigencia)from val_pro vpx where vpx.cd_pro_fat = vp.cd_pro_fat and vpx.cd_tab_fat = vp.cd_tab_fat)
and econv.cd_multi_empresa = 7
and conv.cd_convenio not in (60,43)
order by conv.cd_convenio,cpla.cd_con_pla,vp.cd_pro_fat,vp.dt_vigencia
