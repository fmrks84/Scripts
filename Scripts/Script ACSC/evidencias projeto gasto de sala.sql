select * from dbamv.itreg_Fat where cd_reg_fat = 255773
select * from dbamv.itlan_med z where z.cd_reg_fat = 255773 order by z.vl_ato

select y.cd_pro_fat, y2.cd_produto ,y2.ds_produto, y.tp_proibicao, y.tp_atendimento, y.cd_setor from dbamv.proibicao y 
inner join produto y2 on y2.cd_pro_fat = y.cd_pro_fat
where y.cd_convenio = 7
and y.cd_con_pla = 4
and y.cd_multi_empresa = 7
--and y2.cd_produto = 11422
and y.cd_pro_fat = 00161164


select * from dbamv.produto 
where cd_especie = 19
and cd_classe = 1
and cd_sub_cla = 3
and cd_pro_Fat = '00161164'

select * from proibicao where cd_pro_fat = '00040600' for update 

select * from empresa_produto where cd_produto in (11422,2019139)
 for update 
select * from produto where cd_produto = 11422
select * from empresa_produto where cd_produto = 11422
select * from est_pro where cd_produto = 2019139
select * from dbamv.reg_Fat where cd_atendimento = 2370026
select * from dbamv.itreg_Fat where cd_reg_fat = 260574


