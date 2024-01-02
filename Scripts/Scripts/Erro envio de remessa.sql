delete from dbamv.tiss_nr_guia
where cd_reg_fat in
(select cd_reg_fat from dbamv.reg_fat where cd_remessa in ('51734')
 union all
 select distinct cd_reg_Fat from dbamv.itreg_fat where cd_conta_pai in (
  select cd_reg_fat from dbamv.reg_fat where cd_remessa in ('51734')) )
/
commit
/
update dbamv.itreg_fat set nr_guia_envio = null
    where cd_reg_fat in
(select cd_reg_fat from dbamv.reg_fat where cd_remessa in ('51734')
 union all
 select distinct cd_reg_Fat from dbamv.itreg_fat where cd_conta_pai in (
  select cd_reg_fat from dbamv.reg_fat where cd_remessa in ('51734')) )

/
commit
/
Select * From Dbamv.Tiss_Nr_Guia T Where T.Cd_Reg_Fat In (Select R.Cd_reg_Fat From Dbamv.Reg_Fat R Where R.Cd_Remessa in (51734))
