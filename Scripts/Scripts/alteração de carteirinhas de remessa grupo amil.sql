--- Altere o número da remessa no scritp


--- Fazer um backup da tabela carteira

Create table dbamv.carteira_bkp_75974 as
(Select * from dbamv.carteira 
where (cd_convenio,cd_con_pla,nr_carteira,cd_paciente)
in (select carteira.cd_convenio
          ,carteira.cd_con_pla
          ,carteira.nr_carteira
          ,carteira.cd_paciente
      from dbamv.tb_atendime, dbamv.carteira
     where tb_atendime.cd_paciente = carteira.cd_paciente
       and tb_atendime.cd_atendimento in
           (select distinct itreg_amb.cd_atendimento
              from dbamv.reg_amb, dbamv.itreg_amb
             where reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
               and reg_amb.cd_remessa = 75974
               and reg_amb.cd_multi_empresa = 1)
       and carteira.cd_convenio <> 414));


--- Alterar o numero do convenio na carteira
declare

  cursor c_carteira is
    select tb_atendime.cd_convenio cd_convenio_at
          ,tb_atendime.cd_con_pla cd_con_pla_at
          ,carteira.cd_convenio
          ,carteira.cd_con_pla
          ,carteira.nr_carteira
          ,carteira.cd_paciente
      from dbamv.tb_atendime, dbamv.carteira
     where tb_atendime.cd_paciente = carteira.cd_paciente
       and tb_atendime.cd_atendimento in
           (select distinct itreg_amb.cd_atendimento
              from dbamv.reg_amb, dbamv.itreg_amb
             where reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
               and reg_amb.cd_remessa = 75974
               and reg_amb.cd_multi_empresa = 1)
       and carteira.cd_convenio <> 414;

begin
  dbamv.pkg_mv2000.Atribui_Empresa(1);
  for r_cart in c_carteira
  loop
    begin
      update dbamv.carteira
         set cd_convenio = r_cart.cd_convenio_at,
             cd_con_pla  = r_cart.cd_con_pla_at
       where carteira.cd_convenio = r_cart.cd_convenio
         and carteira.cd_con_pla = r_cart.cd_con_pla
         and carteira.cd_paciente = r_cart.cd_paciente
         and carteira.nr_carteira = r_cart.nr_carteira;
    exception
      when dup_val_on_index then
        null;
    end;
  end loop;
end;
