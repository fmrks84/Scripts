select * from dbamv.custo_medio 
where cd_produto = 4944
and cd_multi_empresa = 2
order by  1 desc

update dbamv.custo_medio
set qt_estoque_antes = 2
 where cd_produto = 4944 and cd_multi_empresa = 2
 and cd_custo_medio = 3677161 commit
