
begin
 pkg_mv2000.Atribui_Empresa(4);
 end;
 
select cd_procedimento_sus
 from produto xx where xx.cd_produto = 34522 for update 
 
/*inner join empresa_produto x on x.cd_produto = xx.cd_produto
where xx.cd_procedimento_sus = 0702030139 --xx.cd_produto = 34522 
and xx.cd_sub_cla = 1
and xx.cd_classe = 3
and xx.cd_especie = 20
and x.cd_multi_empresa = 4 

--for update */
select * from produto x where x.cd_produto in (34522,22719)
