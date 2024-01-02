select cd_produto, cd_custo_medio, vl_custo_medio_antes, vl_entrada,
       vl_custo_medio, tp_custo_medio, cd_multi_empresa
from custo_medio where cd_produto = 12630 and cd_multi_empresa = 2
alter trigger dbamv.trg_chk_custo_medio disable
alter trigger dbamv.trg_chk_custo_medio enable

------------------------------------------------------------------------------------------------------------------

select cd_uni_pro, cd_contagem, qt_estoque, vl_custo_medio  from itcontagem where cd_produto = 50585
select * from uni_pro where cd_produto = 50098
alter trigger dbamv.trg_I_itcontagem enable
alter trigger dbamv.trg_I_itcontagem disable

----------------------------------------------------------------------------------------

select cd_uni_pro, cd_ent_pro, qt_entrada,  vl_custo_real, vl_total from itent_pro where cd_produto = 12541
select * from itent_pro where cd_produto = 50098 --and cd_custo_medio in (346920,346921,346922,346923,346924)
alter trigger dbamv.trg_U_itent_pro enable
alter trigger dbamv.trg_U_itent_pro disable

-------------------------------------------------------------------------------------------------

select * from custo_medio where cd_produto = 50075 and cd_custo_medio in (346920,346921,346922,346923,346924)
select vl_custo_medio from itcontagem where cd_produto = 50310

select vl_custo_medio, cd_contagem from itcontagem where cd_produto = 50899
select vl_custo_medio from produto where cd_produto = 50310


alter trigger dbamv.trg_chk_custo_medio enable
alter trigger dbamv.trg_chk_custo_medio disable
-------------------------------------------------------------------------------------------------------------

select* from itmvto_estoque where cd_produto in (50075,50098)
alter trigger dbamv.trg_U_itmvto_estoque enable
alter trigger dbamv.trg_U_itmvto_estoque disable
--------------------------------------------------------
select * from itcontagem where cd_produto = 50585
