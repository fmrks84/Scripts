select xp.tp_opme_vl_referencia from empresa_convenio xp where xp.cd_convenio in 
 (select xx.cd_convenio  from cirurgia_aviso xx where xx.cd_aviso_cirurgia = 349081);


select * from pro_fat where cd_pro_fat in('09004528')--,);
select * from gru_pro where cd_gru_pro in (9)
select * from val_pro where cd_tab_fat in (2) and cd_pro_fat in ('09004528') order by 3 desc 
select * from produto where cd_pro_fat in ('09004406','00260855','00273153')--,09011140)
SELECT * FROM TAB_FAT WHERE CD_TAB_fAT = 93

select  xx.cd_aviso_cirurgia,xx.cd_convenio,xx.cd_con_pla
from cirurgia_aviso xx where xx.cd_aviso_cirurgia in (349132)

select * from aviso_cirurgia where cd_aviso_cirurgia = 429476
select * from age_cir ac where ac.cd_aviso_cirurgia = 429476

select * from 

select * 
/*96 - tabela 
89 - simpro
9 - tabela
95 - tabela
*/
select 
distinct
irg.cd_gru_pro,
gp.ds_gru_pro,
--cpla.cd_regra,
irg.cd_regra,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
trunc (max(vp.dt_vigencia))dt_vigencia,
tf.ds_tab_fat,
vp.cd_pro_fat,
pf.ds_pro_fat,
irg.vl_percetual_pago,
case when irg.vl_percetual_pago < =100 then (100-irg.vl_percetual_pago)
  else 0
  end deflator,
  case when irg.vl_percetual_pago > =100 then ((irg.vl_percetual_pago)-100)
  else 0
  end inflator,
nvl(vp.vl_total,0)VL_TOTAL
--(irg.vl_percetual_pago * nvl(vp.vl_total,0))/100 VL_A_COBRAR

from 
dbamv.convenio conv
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
inner join dbamv.con_pla cpla on cpla.cd_convenio = conv.cd_convenio
inner join dbamv.empresa_con_pla ecpla on ecpla.cd_con_pla = cpla.cd_con_pla and ecpla.cd_convenio = conv.cd_convenio
inner join dbamv.itregra irg on irg.cd_regra = cpla.cd_regra
inner join dbamv.pro_Fat pf on pf.cd_gru_pro = irg.cd_gru_pro and pf.sn_ativo = 'S'
left join dbamv.val_pro vp on vp.cd_pro_fat = pf.cd_pro_fat and vp.cd_tab_fat = irg.cd_tab_fat
left join gru_pro gp on gp.cd_gru_pro = irg.cd_gru_pro
left join tab_fat tf on tf.cd_tab_fat = vp.cd_tab_fat
where trunc(vp.dt_vigencia) = (select max(vpx.dt_vigencia)from val_pro vpx where vpx.cd_pro_fat = vp.cd_pro_fat and vpx.cd_tab_fat = vp.cd_tab_fat) --PF.CD_PRO_FAT = '09085708'
--and vp.cd_pro_fat in ('09076773')
--and irg.cd_gru_pro IN (9)--(9,89,95,96)
and conv.cd_convenio = 9
and vp.cd_pro_fat in ('09099464')
and cpla.cd_con_pla = 387
and econv.cd_multi_empresa = 7
group by 
cpla.cd_regra,
irg.cd_regra,
conv.cd_convenio,
conv.nm_convenio,
cpla.cd_con_pla,
cpla.ds_con_pla,
irg.cd_gru_pro,
gp.ds_gru_pro,
irg.cd_tab_fat,
tf.ds_tab_fat,
vp.cd_pro_fat,
pf.ds_pro_fat,
irg.vl_percetual_pago,
nvl(vp.vl_total,0)
order by irg.cd_regra,irg.cd_tab_fat,irg.vl_percetual_pago



select * from pro_fat where cd_pro_Fat = '09099464'

/*
select 
       ac.cd_multi_empresa,
       g.cd_aviso_cirurgia,
       g.cd_guia,
       g.nr_guia,
       gi.cd_it_guia,
       gi.cd_pro_fat,
       gi.ds_procedimento,
       gi.cd_usu_geracao,
       g2.cd_fornecedor,
       g2.vl_total
       
        from guia g 
inner join it_guia gi on gi.cd_guia = g.cd_guia
left join val_opme_it_guia g2 on g2.cd_it_guia = gi.cd_it_guia
inner join aviso_cirurgia ac on ac.cd_aviso_cirurgia = g.Cd_Aviso_Cirurgia
where g.cd_aviso_cirurgia = 348404 -- 348404 -atd 4778700 -- 06-10-2023
and g.tp_guia = 'O'

select * from itregra where cd_regra = 277

delete from itreg_Fat where cd_Reg_Fat = 528097 and cd_Gru_fat <> 9--cd_atendimento = 4778700



select to_Date('18/10/2023','dd/mm/rrrr')+ 30/1440 from dual 

select * from atendime where cd_atendimento = 5484362
select * from a


SELECT * FROM DBASGU.VW_USUARIOS X WHERE X.NM_USUARIO like '%FLAVIA%ALMEIDA%TAVARES%PASSOS%'*/
--select * from val_pro vp where vp.cd_tab_fat = 2 and vp.cd_pro_fat = 00260855


/*
select * from produto pd where pd.cd_pro_fat in ('09027160','00260855');
select * from pro_Fat where cd_pro_fat in ('09027160','00260855');
select * from gru_pro gp where gp.cd_gru_pro in (8,9);
select * from configu_importacao_gru_fat ex where ex.cd_produto = 54049

select * from guia g 
inner join it_guia gg on gg.cd_guia = g.cd_guia
where g.cd_aviso_cirurgia = 348518
and g.cd_guia = 4805396
and g.dt

select * from itcob_pre 

349048
*/
 5985544
select * from aviso_cirurgia where cd_Aviso_cirurgia = 437654
select * from cirurgia_aviso where cd_Aviso_cirurgia = 437654
select * from val_pro where  cd_tab_fat = 2 and cd_pro_Fat = '09068018'
select * from setor where cd_setor = 4092  


update guia c set c.cd_atendimento = 5985544 where c.cd_guia = 6083172;
commit;

select * from atendime where cd_atendimento = 5985544
select * from res_lei x where x.cd_atendimento = 5976149

select * from atendime where cd_atendimento = 5780281  
select * from leito where cd_leito = 113
select * from unid_int where cd_setor = 32 --cd_unid_int = 47 


select * from reg_Fat where cd_reg_fat = 646887
select * from sys.reg_fat_audit where /*o_cd_atendimento = 4688994 and*/ cd_reg_Fat = 646887   order by dt_aud desc 

select * from mvto_estoque mv where mv.cd_mvto_estoque = 41181946;
select * from mvto_estoque mv where mv.cd_mvto_estoque = 41181946

select * from itmvto_estoque imv where imv.cd_mvto_estoque in (
select mv.cd_mvto_estoque from mvto_estoque mv where mv.cd_mvto_estoque = 41181946)





