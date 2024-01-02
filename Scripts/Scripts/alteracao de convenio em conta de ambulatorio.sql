Begin
  Pkg_Mv2000.Atribui_Empresa(2);  -->> Trocar a empresa e rodar uma vez para cada empresa
End;

select c.CD_PACIENTE, c.CD_CONVENIO , c.CD_CON_PLA from dbamv.atendime c where c.CD_ATENDIMENTO = 1388709 for update --1º
select  a.cd_convenio  from dbamv.reg_amb a where a.cd_reg_amb = 859165 for update --2º
select b.cd_lancamento,b.cd_convenio, b.cd_con_pla , b.cd_reg_amb from dbamv.itreg_amb b where b.Cd_Atendimento = 1388709 for update-- b.cd_reg_amb = 852749 for update --3º
select * from dbamv.carteira a where a.cd_paciente = 587031 for update -- 4º

