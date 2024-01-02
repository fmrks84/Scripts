SELECT
      
      cd_multi_empresa, 
      Cd_Convenio,
      nm_convenio,
       SUM(Vl_Internacao)Vl_Internacao,
       SUM(Vl_Ambulatorial)Vl_Ambulatorial,
       SUM(Vl_Urgencia)Vl_Urgencia,
       SUM(Vl_Externo)Vl_Externo 
  FROM ((SELECT Atendime . Cd_Atendimento,
               atendime . cd_multi_empresa,
               Convenio . Cd_Convenio,
               convenio . nm_convenio,
               Reg_Fat . Cd_Reg_Fat,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'I',
                          Nvl(Nvl(Itlan_Med . Vl_Liquido,
                                  Itreg_Fat . Vl_Total_Conta),
                              0),
                          'H',
                          Nvl(Nvl(Itlan_Med . Vl_Liquido,
                                  Itreg_Fat . Vl_Total_Conta),
                              0),
                          NULL)) Vl_Internacao,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'A',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Ambulatorial,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'E',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Externo,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'U',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Urgencia,
               Decode(Atendime . Tp_Atendimento, 'I', 1, 'H', 1, 0) Qt_Internacao,
               Decode(Atendime . Tp_Atendimento, 'A', 1, 0) Qt_Ambulatorial,
               Decode(Atendime . Tp_Atendimento, 'E', 1, 0) Qt_Externo,
               Decode(Atendime . Tp_Atendimento, 'U', 1, 0) Qt_Urgencia,
               SUM(Nvl(Itreg_Fat . Vl_Total_Conta, 0)) Vl_Total_Conta,
               Con_Pla . Cd_Con_Pla Cd_Con_Pla,
               Con_Pla . Ds_Con_Pla Ds_Con_Pla
               
          FROM Dbamv . Reg_Fat,
               Dbamv . Itreg_Fat,
               Dbamv . Convenio,
               dbamv . empresa_convenio,
               Dbamv . Con_Pla,
               DBAmv . Empresa_Con_Pla,
               Dbamv . Atendime,
               Dbamv . Servico,
               Dbamv . Gru_Fat,
               Dbamv . Itlan_Med
         WHERE Reg_Fat . Cd_Reg_Fat = Itreg_Fat . Cd_Reg_Fat
           AND Itreg_Fat . Cd_Reg_Fat = Itlan_Med .
         Cd_Reg_Fat(+)
           AND empresa_convenio . cd_convenio = convenio .
         cd_convenio
          /* AND empresa_convenio .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND empresa_con_pla . cd_convenio = con_pla .
         cd_convenio
           AND empresa_con_pla . cd_con_pla = con_pla .
         cd_con_pla
           /*AND empresa_con_pla .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND Itreg_Fat . Cd_Lancamento = Itlan_Med .
         Cd_Lancamento(+)
           AND Nvl(Nvl(Itlan_Med . Tp_Pagamento, Itreg_Fat . Tp_Pagamento),
                   'X') <> 'C'
          AND Nvl(Itreg_Fat . Sn_Pertence_Pacote, 'N') = 'N'
           AND Reg_Fat . Cd_Atendimento = Atendime . Cd_Atendimento
           AND Reg_Fat . Cd_Convenio = Convenio . Cd_Convenio
           AND Reg_Fat . Cd_Convenio = Con_Pla . Cd_Convenio
           AND Reg_Fat . Cd_Con_Pla = Con_Pla . Cd_Con_Pla
           AND Convenio . Tp_Convenio <> 'H'
           AND Atendime . Cd_Servico = Servico . Cd_Servico(+)
           AND Itreg_Fat .
         Dt_Lancamento BETWEEN To_Date(&Dt_Inicio, 'DD/MM/YYYY') AND
               (To_Date(&Dt_Final || ' 23:59:59', 'DD/MM/YYYY hh24:mi:ss'))
           AND Itreg_Fat . Cd_Gru_Fat = Gru_Fat . Cd_Gru_Fat
           AND Atendime . Cd_Multi_Empresa in &Cd_Multi_Empresa
        --   and reg_fat.sn_fechada = 'S'
         GROUP BY Atendime . Cd_Atendimento,
                  atendime . cd_multi_empresa,
                  Convenio . Cd_Convenio,
                  convenio . nm_convenio,
                  Reg_Fat . Cd_Reg_Fat,
                  Decode(Atendime . Tp_Atendimento, 'I', 1, 'H', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'A', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'E', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'U', 1, 0),
                  Con_Pla . Cd_Con_Pla,
                  Con_Pla . Ds_Con_Pla
                 
        UNION ALL
        SELECT Atendime . Cd_Atendimento,
               atendime . cd_multi_empresa,
               Convenio . Cd_Convenio,
               convenio . nm_convenio,
               
               Reg_Amb . Cd_Reg_Amb,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'I',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          'H',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Internacao,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'A',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Ambulatorial,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'E',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Externo,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'U',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Urgencia,
               Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0) Qt_Internacao,  
               Decode(Atendime . Tp_Atendimento, 'A', 1, 0) Qt_Ambulatorial,
               Decode(Atendime . Tp_Atendimento, 'E', 1, 0) Qt_Externo,
               Decode(Atendime . Tp_Atendimento, 'U', 1, 0) Qt_Urgencia,
               SUM(Nvl(Itreg_Amb . Vl_Total_Conta, 0)) Vl_Total_Conta,
               Con_Pla . Cd_Con_Pla Cd_Con_Pla,
               Con_Pla . Ds_Con_Pla Ds_Con_Pla
          FROM Dbamv . Reg_Amb,
               Dbamv . Itreg_Amb,
               Dbamv . Convenio,
               dbamv . empresa_convenio,
               Dbamv . Con_Pla,
               dbamv . empresa_con_pla,
               Dbamv . Atendime,
               Dbamv . Servico,
               Dbamv . Gru_Fat
         WHERE Reg_Amb . Cd_Reg_Amb = Itreg_Amb .
         Cd_Reg_Amb
         AND Nvl(Itreg_Amb . Sn_Pertence_Pacote, 'N') = 'N'
           AND empresa_convenio . cd_convenio = convenio .
         cd_convenio
        /*   AND empresa_convenio .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND empresa_con_pla . cd_convenio = con_pla .
         cd_convenio
           AND empresa_con_pla . cd_con_pla = con_pla .
         cd_con_pla
           /*AND empresa_con_pla .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND Itreg_Amb . Cd_Atendimento = Atendime . Cd_Atendimento
           AND Itreg_Amb . Cd_Convenio = Convenio . Cd_Convenio
           AND Itreg_Amb . Cd_Convenio = Con_Pla . Cd_Convenio
           AND Itreg_Amb . Cd_Con_Pla = Con_Pla .
         Cd_Con_Pla
           AND Nvl(Itreg_Amb . Tp_Pagamento, 'X') <> 'C'
      --     AND Reg_Amb . Cd_Multi_Empresa = &Cd_Multi_Empresa
           AND Convenio . Tp_Convenio <> 'H'
           AND Atendime . Cd_Servico = Servico . Cd_Servico(+)
           AND Atendime .
         Dt_Atendimento BETWEEN To_Date(&Dt_Inicio, 'DD/MM/YYYY') AND
               (To_Date(&Dt_Final || ' 23:59:59', 'DD/MM/YYYY hh24:mi:ss'))
           AND Itreg_Amb . Cd_Gru_Fat = Gru_Fat . Cd_Gru_Fat
           AND Atendime . Cd_Multi_Empresa in &Cd_Multi_Empresa--(3,4,5,7,10,25)--= &Cd_Multi_Empresa
         ---  and itreg_amb.sn_fechada = 'S'
         GROUP BY Atendime . Cd_Atendimento,
                  atendime . cd_multi_empresa,
                  Convenio . Cd_Convenio,
                  convenio . nm_convenio,
                  Reg_Amb . Cd_Reg_Amb,
                  Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'A', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'E', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'U', 1, 0),
                  Con_Pla . Cd_Con_Pla,
                  Con_Pla . Ds_Con_Pla
        UNION ALL
        SELECT Atendime . Cd_Atendimento,
               atendime . cd_multi_empresa,
               Convenio . Cd_Convenio,
               convenio . nm_convenio,
               Reg_Fat . Cd_Reg_Fat,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'I',
                          Nvl(Nvl(Itlan_Med . Vl_Liquido,
                                  Itreg_Fat . Vl_Total_Conta),
                              0),
                          'H',
                          Nvl(Nvl(Itlan_Med . Vl_Liquido,
                                  Itreg_Fat . Vl_Total_Conta),
                              0),
                          NULL)) Vl_Internacao,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'A',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Ambulatorial,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'E',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Externo,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'U',
                          Nvl(Itreg_Fat . Vl_Total_Conta, 0),
                          NULL)) Vl_Urgencia,
               Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0) Qt_Internacao,
               Decode(Atendime . Tp_Atendimento, 'A', 1, 0) Qt_Ambulatorial,
               Decode(Atendime . Tp_Atendimento, 'E', 1, 0) Qt_Externo,
               Decode(Atendime . Tp_Atendimento, 'U', 1, 0) Qt_Urgencia,
               SUM(Nvl(Itreg_Fat . Vl_Total_Conta, 0)) Vl_Total_Conta,
               Con_Pla . Cd_Con_Pla Cd_Con_Pla,
               Con_Pla . Ds_Con_Pla Ds_Con_Pla
          FROM Dbamv . Reg_Fat,
               Dbamv . Itreg_Fat,
               Dbamv . Convenio,
               dbamv . empresa_convenio,
               Dbamv . Con_Pla,
               dbamv . empresa_con_pla,
               Dbamv . Atendime,
               Dbamv . Pro_Fat,
               Dbamv . Servico,
               Dbamv . Gru_Fat,
               Dbamv . Itlan_Med
         WHERE Reg_Fat . Cd_Reg_Fat = Itreg_Fat . Cd_Reg_Fat
           AND empresa_convenio . cd_convenio = convenio .
         cd_convenio
           /*AND empresa_convenio .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND empresa_con_pla . cd_convenio = con_pla .
         cd_convenio
           AND empresa_con_pla . cd_con_pla = con_pla .
         cd_con_pla
          /* AND empresa_con_pla .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND Itreg_Fat . Cd_Pro_Fat = Pro_Fat .
         Cd_Pro_Fat
         AND Nvl(Pro_Fat . Sn_Pacote, 'N') = 'N'
           AND Itreg_Fat . Cd_Reg_Fat = Itlan_Med . Cd_Reg_Fat(+)
           AND Itreg_Fat . Cd_Lancamento = Itlan_Med .
         Cd_Lancamento(+)
           AND Nvl(Nvl(Itlan_Med . Tp_Pagamento, Itreg_Fat . Tp_Pagamento),
                   'X') <> 'C'
           AND Reg_Fat . Cd_Atendimento = Atendime . Cd_Atendimento
           AND Reg_Fat . Cd_Convenio = Convenio . Cd_Convenio
           AND Reg_Fat . Cd_Convenio = Con_Pla . Cd_Convenio
           AND Reg_Fat . Cd_Con_Pla = Con_Pla . Cd_Con_Pla
           AND Convenio . Tp_Convenio <> 'H'
           AND Atendime . Cd_Servico = Servico . Cd_Servico(+)
           AND Itreg_Fat .
         Dt_Lancamento BETWEEN To_Date(&Dt_Inicio, 'DD/MM/YYYY') AND
               (To_Date(&Dt_Final || ' 23:59:59', 'DD/MM/YYYY hh24:mi:ss'))
           AND Itreg_Fat . Cd_Gru_Fat = Gru_Fat . Cd_Gru_Fat
           AND Atendime . Cd_Multi_Empresa in &Cd_Multi_Empresa--(3,4,5,7,10,25)--= &Cd_Multi_Empresa
         --  AND CONVENIO.CD_CONVENIO = '73'
          AND CONVENIO.CD_CONVENIO IS NULL
         --  and reg_fat.sn_fechada = 'S'
         GROUP BY Atendime . Cd_Atendimento,
                  atendime . cd_multi_empresa,
                  Convenio . Cd_Convenio,
                  convenio . nm_convenio,
                  Reg_Fat . Cd_Reg_Fat,
                  Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'A', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'E', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'U', 1, 0),
                  Con_Pla . Cd_Con_Pla,
                  Con_Pla . Ds_Con_Pla
        UNION ALL
        SELECT Atendime . Cd_Atendimento,
               atendime . cd_multi_empresa,
               Convenio . Cd_Convenio,
               convenio . nm_convenio,
               Reg_Amb . Cd_Reg_Amb,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'I',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          'H',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Internacao,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'A',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Ambulatorial,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'E',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Externo,
               SUM(Decode(Atendime . Tp_Atendimento,
                          'U',
                          Nvl(Itreg_Amb . Vl_Total_Conta, 0),
                          NULL)) Vl_Urgencia,
               Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0) Qt_Internacao,
               Decode(Atendime . Tp_Atendimento, 'A', 1, 0) Qt_Ambulatorial,
               Decode(Atendime . Tp_Atendimento, 'E', 1, 0) Qt_Externo,
               Decode(Atendime . Tp_Atendimento, 'U', 1, 0) Qt_Urgencia,
               SUM(Nvl(Itreg_Amb . Vl_Total_Conta, 0)) Vl_Total_Conta,
               Con_Pla . Cd_Con_Pla Cd_Con_Pla,
               Con_Pla . Ds_Con_Pla Ds_Con_Pla
          FROM Dbamv . Reg_Amb,
               Dbamv . Itreg_Amb,
               Dbamv . Pro_Fat,
               Dbamv . Convenio,
               dbamv . empresa_convenio,
               Dbamv . Con_Pla,
               dbamv . empresa_con_pla,
               Dbamv . Atendime,
               Dbamv . Servico,
               Dbamv . Gru_Fat
         WHERE Reg_Amb . Cd_Reg_Amb = Itreg_Amb . Cd_Reg_Amb
           AND empresa_convenio . cd_convenio = convenio .
         cd_convenio
        /*   AND empresa_convenio .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND empresa_con_pla . cd_convenio = con_pla .
         cd_convenio
           AND empresa_con_pla . cd_con_pla = con_pla .
         cd_con_pla
          /* AND empresa_con_pla .
         cd_multi_empresa = &Cd_Multi_Empresa*/
           AND Itreg_Amb . Cd_Pro_Fat = Pro_Fat .
         Cd_Pro_Fat
           AND Nvl(Pro_Fat . Sn_Pacote, 'N') = 'N'
           AND Itreg_Amb . Cd_Atendimento = Atendime . Cd_Atendimento
           AND Itreg_Amb . Cd_Convenio = Convenio . Cd_Convenio
           AND Itreg_Amb . Cd_Convenio = Con_Pla . Cd_Convenio
           AND Itreg_Amb . Cd_Con_Pla = Con_Pla . Cd_Con_Pla
          -- AND Reg_Amb . Cd_Multi_Empresa = &Cd_Multi_Empresa
           AND Convenio . Tp_Convenio <> 'H'
           AND Atendime . Cd_Servico = Servico . Cd_Servico(+)
           AND Atendime .
         Dt_Atendimento BETWEEN To_Date(&Dt_Inicio, 'DD/MM/YYYY') AND
               (To_Date(&Dt_Final || ' 23:59:59', 'DD/MM/YYYY hh24:mi:ss'))
           AND Itreg_Amb . Cd_Gru_Fat = Gru_Fat . Cd_Gru_Fat
           AND Atendime . Cd_Multi_Empresa in &Cd_Multi_Empresa --(3,4,5,7,10,25)--= &Cd_Multi_Empresa
           AND CONVENIO.CD_CONVENIO IS NULL
   --        and itreg_amb.sn_fechada = 'S'
         GROUP BY Atendime . Cd_Atendimento,
                  atendime . cd_multi_empresa,
                  Convenio . Cd_Convenio,
                  convenio . nm_convenio,
                  Reg_Amb . Cd_Reg_Amb,
                  Decode(Atendime . Tp_Atendimento, 'I', 1,'H', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'A', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'E', 1, 0),
                  Decode(Atendime . Tp_Atendimento, 'U', 1, 0),
                  Con_Pla . Cd_Con_Pla,
                  Con_Pla . Ds_Con_Pla)
 )WHERE  CD_CONVENIO = CD_CONVENIO --IN &CD_CONVENIO
 GROUP BY Cd_Convenio,
          cd_multi_empresa, 
           nm_convenio
     --      qt_internacao
ORDER BY   cd_multi_empresa
           --nm_convenio
