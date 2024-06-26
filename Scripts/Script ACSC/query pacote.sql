select 
pct.cd_multi_empresa,
pct.cd_convenio,
pct.cd_con_pla,
pct.cd_pacote,
pct.cd_pro_fat,
pf.ds_pro_fat,
pct.cd_pro_fat_pacote,
pf2.ds_pro_fat,
pct.dt_vigencia,
pct.dt_vigencia_final

from cirurgia cir
inner join pacote pct on pct.cd_pro_fat = cir.cd_pro_fat
inner join pro_Fat pf on pf.cd_pro_fat = pct.cd_pro_fat
inner join pro_Fat pf2 on pf2.cd_pro_fat = pct.cd_pro_fat_pacote
where cir.cd_cirurgia = 2341
and pct.cd_multi_empresa = 7
and pct.cd_convenio = 7
and pct.dt_vigencia_final is null
;

select 
pce.cd_pacote_excecao,
pce.cd_pacote,
pce.cd_gru_pro,
pce.cd_pro_fat,
pce.cd_setor,
pce.cd_tip_acom,
gp.cd_gru_pro,
gp.ds_gru_pro,
gf.cd_gru_fat,
gf.ds_gru_fat
from 
pacote_excecao pce
inner join gru_pro gp on gp.cd_gru_pro = pce.cd_gru_pro
inner join gru_Fat gf on gp.cd_gru_fat = gf.cd_gru_fat
where pce.cd_pacote = 4244
order by 3
;

select 
*
from 
pacote_gru_pro pgp
where pgp.cd_pacote = 4244
;

select
*
from
pacote_pro_fat ppf
where ppf.cd_pacote = 4244
;

select 
*
from
aviso_cirurgia avcir
inner join age_cir agcir on agcir.cd_aviso_cirurgia = avcir.cd_aviso_cirurgia
where avcir.cd_aviso_cirurgia = 207829
;

select 
*
from
mvto_estoque mvto
inner join itmvto_estoque imvto on imvto.cd_mvto_estoque = mvto.cd_mvto_estoque
where mvto.cd_aviso_cirurgia = 207829
;



select 
rf.cd_multi_empresa,
mvt1.cd_aviso_cirurgia,
rf.cd_atendimento,
rf.cd_convenio,
iest.cd_produto,
irf.cd_pro_fat,
irf.cd_gru_fat

from reg_Fat rf
inner join itreg_Fat irf on irf.cd_reg_fat = rf.cd_reg_fat
left join itmvto_estoque iest on iest.cd_mvto_estoque = irf.cd_mvto
                               and iest.cd_itmvto_estoque = irf.cd_itmvto
left join Mvto_Estoque mvt1 on mvt1.cd_mvto_estoque = iest.cd_mvto_estoque
left join aviso_cirurgia avcir1 on avcir1.cd_aviso_cirurgia = mvt1.cd_aviso_cirurgia

left join cirurgia_aviso cirav on cirav.cd_aviso_cirurgia = avcir1.cd_aviso_cirurgia
left join cirurgia cir1 on cir1.cd_cirurgia = cirav.cd_cirurgia
left join pacote pct1 on pct1.cd_pro_fat = cir1.cd_pro_fat and rf.cd_convenio = pct1.cd_convenio                                      
where rf.cd_atendimento = 2946515
and pct1.dt_vigencia_final is null
--order by irf.cd_pro_fat


