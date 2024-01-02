select * from dbamv.pre_pad a 
where a.ds_pre_pad like '%BERC%ADMIS%'
and a.cd_multi_empresa is null

select B.CD_PRE_PAD COD_PRESC_PADRAO,
       B.DS_PRE_PAD NM_PRESC_PADRAO
       from dbamv.pre_pad b where b.cd_pre_pad in (7,8,9,10,11,12,162)--and b.cd_tip_presc = 73741
and b.sn_ativo = 'S'
order by  1

select * from dbamv.itpre_pad b where b.cd_tip_presc = 73741
AND b.cd_pre_pad in (1,7,8,9,10,11,12,162)
and b.sn_ativo = 'S'
order by  1
for update 
