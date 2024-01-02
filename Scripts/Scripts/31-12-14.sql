select * from dbamv.reg_FAt where cd_atendimento = 1081177 for update
select * from dbamv.remessa_fatura r where r.cd_remessa in (64722
,64723
,64895
,64896
,64852
,64853)for update
delete from dbamv.reg_fat where cd_reg_fat in (965923
,985906
,992755
,986383)
delete from dbamv.itreg_fat x where x.cd_reg_fat in (1007359)
,1012632
,1018076
,1033896
,1028074
,1028074
,1001002
,982215
,996202
,1007359
)
delete from dbamv.itfat_nota_fiscal where cd_reg_Fat = 996203--cd_remessa in (64853)--,63263,63534,64336,64569)for update
delete from dbamv.auditoria_conta where cd_atendimento = 982215

select cd_remessa, cd_reg_fat, Cd_Conta_Pai, Cd_Multi_Empresa from dbamv.reg_fat where nvl(cd_conta_pai, cd_reg_Fat) in (1018076
,1012632
,1018076
,1033896
,1028074
,1028074
,1001002
,982215
,996202
,1007359
) for update;

delete from dbamv.it_repasse where cd_reg_Fat = 1001002
select * from dbamv.repasse_consolidado where cd_reg_Fat = 1001002

select * from dbamv.itlan_med where cd_reg_fat = 1007359
delete from dbamv.tiss_nr_guia where cd_atendimento = 1081177
