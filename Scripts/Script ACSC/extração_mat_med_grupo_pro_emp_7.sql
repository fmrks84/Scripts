select 
b.cd_gru_pro,
b.Ds_Gru_Pro,
C.CD_TUSS,
C.DS_TUSS,
C.CD_PRO_FAT


from 
pro_fat a 
inner join gru_pro b on b.cd_gru_pro = a.cd_gru_pro
inner join tuss c on c.cd_pro_fat = a.cd_pro_fat
where b.cd_gru_pro in ('7','8','12','89','96','95','44','43')
and a.sn_ativo = 'S'
and c.dt_fim_vigencia is null
and c.cd_multi_empresa = 7
and c.cd_convenio is null
order by b.cd_gru_pro , c.ds_tuss


