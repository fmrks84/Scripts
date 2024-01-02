Select cd_atendimento, Cd_Reg_Fat, Cd_Conta_Pai, Vl_Total_Conta, Cd_Multi_Empresa, Sn_Fechada, Cd_Remessa, Vl_Desconto_Conta 
From Dbamv.Reg_Fat Where cd_REG_fat in (255244)--for update;

select sum (to_number (g.vl_total_geral_hono,'999990.00'))-- g.nm_paciente ,g.nm_prestador_exe, g.cd_reg_fat,g.cd_reg_amb ,g.vl_tot_geral , g.vl_total_geral_hono 
from dbamv.tiss_guia g where g.cd_remessa in (89157) order by 1 for update ---ORDER BY --  and g.nm_xml in ('guiaHonorarioIndividual','guiaSP_SADT') order by 1--and g.cd_remessa = 65212 o
--cd_atendimento = 1086589 and cd_reg_fat = 1017993

-------------------

select sum (vl_total_conta) from dbamv.itreg_fat where cd_reg_Fat = 1070492 and id_it_envio is null

sum (to_number (g.vl_tot_geral,'999990.00'))


select x.cd_remessa , x.cd_remessa_pai, x.sn_fechada from dbamv.Remessa_Fatura x where x.Cd_Remessa IN (101126) for update
select * from dbamv.Reg_Fat where cd_remessa = 101126--cd_Reg_fat = 1390373 for update


Begin
  Pkg_Mv2000.Atribui_Empresa(2);  -->> Trocar a empresa e rodar uma vez para cada empresa
End;

select * from dbamv.reg_fat where cd_remessa = 67503
select * from dbamv.remessa_fatura f where f.cd_remessa in (67503,67504)for update
SELECT * FROM DBAMV.REG_fAT WHERE CD_rEG_fAT  IN (1060091,1054334)FOR UPDATE
SELECT * FROM DBAMV.REMESSA_FATURA WHERE CD_REMESSA = 67504 FOR UPDATE
select * from dbamv.reg_fat where cd_reg_Fat in (1029730)for update
SELECT * FROM DBAMV.AVISO_CIRURGIA C WHERE C.CD_AVISO_CIRURGIA = 288182 FOR UPDATE
select * From dbamv.v_tiss_guia_sp_sadt_v3 v where v.cd_atendimento = 1086589


select * from dbamv.
