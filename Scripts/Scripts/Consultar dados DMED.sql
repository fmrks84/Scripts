select  tb_atendime.cd_multi_empresa,
        responsa.cd_atendimento ,
        tb_atendime.dt_atendimento,
        paciente.nm_paciente ,
        responsa.nm_responsavel,
        responsa.nr_cpf,
        reccon_rec.dt_recebimento,
        con_Rec.Cd_Con_Rec,
        reccon_rec.vl_recebido,
        Con_Rec.Nr_Documento,
        nota_fiscal.nr_nota_fiscal_nfe
        from dbamv.Responsa ,
              dbamv.tb_atendime ,
              dbamv.paciente,
              dbamv.con_Rec,
              dbamv.itcon_rec ,
              dbamv.reccon_rec ,
              dbamv.nota_fiscal 
               
where responsa.nm_responsavel like '%RN RAFAELA SILVA MACHADO%'
and responsa.cd_atendimento = tb_Atendime.Cd_Atendimento
and tb_atendime.cd_paciente = paciente.cd_paciente
and con_Rec.Cd_Atendimento (+) = tb_atendime.cd_atendimento 
and con_Rec.Cd_Con_Rec = itcon_rec.cd_con_rec
and itcon_rec.cd_itcon_rec = reccon_rec.cd_itcon_rec (+)
and nota_fiscal.nr_id_nota_fiscal = con_Rec.Nr_Documento


select * from dbamv.responsa ,
              dbamv.tb_atendime 
            
where responsa.nm_responsavel like '%RN RAFAELA SILVA MACHADO%'
and responsa.cd_atendimento = tb_atendime.cd_atendimento
