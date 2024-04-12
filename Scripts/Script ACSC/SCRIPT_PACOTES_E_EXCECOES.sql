select 
       pct.cd_pacote,
       pct.cd_convenio,
       conv.nm_convenio,
       pct.cd_con_pla,
       cpla.ds_con_pla,
       pct.cd_pro_fat,
       pf.ds_pro_fat,
       dbamv.fc_acsc_tuss(pct.cd_multi_empresa,
                   pct.cd_pro_fat_pacote,
                    pct.cd_convenio,
                   'COD')TUSS_PACOTE,
       pct.cd_pro_fat_pacote,
       pf1.ds_pro_fat,
       'EXCEÇÕES PACOTE-->>>>',
       epct.cd_gru_pro,
       gp.ds_gru_pro,
       epct.cd_pro_fat,
       pf2.ds_pro_fat,
       epct.cd_setor,
       st.nm_setor,
       epct.cd_tip_acom
       
        from dbamv.pacote pct
inner join dbamv.Pacote_Excecao epct on epct.cd_pacote = pct.cd_pacote
and pct.cd_multi_empresa = 7 ---- AQUI ESTA SETADO PARA TRAZER SOMENTE OS PACOTES DO HSC 
inner join dbamv.pro_fat pf on pf.cd_pro_fat = pct.cd_pro_fat
inner join dbamv.pro_fat pf1 on pf1.cd_pro_fat = pct.cd_pro_fat_pacote
left join dbamv.gru_pro gp on gp.cd_gru_pro = epct.cd_gru_pro
left join dbamv.pro_fat pf2 on pf2.cd_pro_fat = epct.cd_pro_fat
left join dbamv.setor st on st.cd_setor = epct.cd_setor
left join dbamv.Tip_Acom tc on tc.cd_tip_acom = epct.cd_tip_acom
left join dbamv.Empresa_Con_Pla ecpla on ecpla.cd_convenio = pct.cd_convenio
and ecpla.cd_multi_empresa = pct.cd_convenio
and ecpla.cd_con_pla = pct.cd_con_pla
left join dbamv.con_pla cpla on cpla.cd_con_pla = pct.cd_con_pla
and cpla.cd_convenio = pct.cd_convenio
inner join dbamv.convenio conv on conv.cd_convenio = pct.cd_convenio
where pct.cd_convenio = 7 -- INSERIR CÓDIGO CONVENIO 
and pct.dt_vigencia_final is null
order by pct.cd_pacote
