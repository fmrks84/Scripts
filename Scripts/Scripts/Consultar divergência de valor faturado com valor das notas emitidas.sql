select * From dbamv.remessa_fatura where cd_remessa in (60347,60345,60346)
--------------------------------
select i.cd_reg_fat, i.vl_total_conta, i.vl_nota 
From Dbamv.itreg_fat i where cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_remessa in (60346)
and i.vl_total_conta = i.vl_nota) for update;--,60345,60346)
----------------------------------------------------------------------
select i.cd_reg_fat,  i.vl_nota From Dbamv.itlan_med i where cd_reg_fat in (select cd_reg_fat from dbamv.reg_fat where cd_remessa in (60346)) for update;
