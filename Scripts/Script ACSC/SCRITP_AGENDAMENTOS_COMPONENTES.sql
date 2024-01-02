--CREATE OR REPLACE VIEW VW_OVMD_GUIA_SADT_ELETIVO AS
SELECT
  CD_MULTI_EMPRESA,
  ID,
  CD_CONVENIO,
  NR_REGISTRO_OPERADORA_ANS,
  NM_PACIENTE,
  NR_CARTEIRA,
  NM_PRESTADOR,
  DS_CODIGO_CONSELHO,
  UF_CONSELHO,
  CD_CBOS,
  TRUNC(DH_SOLICITADO)DH_SOLICITADO,
  LISTAGG(DS_INDICACAO, '; ') WITHIN GROUP (ORDER BY CD_MULTI_EMPRESA) DS_INDICACAO,
  DS_CARATER,
  CD_TIPO_INTERNACAO,
  CD_CID,
  CD_PROCEDIMENTO,
  TRIM(DS_PROCEDIMENTO) DS_PROCEDIMENTO,
  UTI,
  COUNT(QT_SOLICITADA) QT_SOLICITADA,
  TP_REGIME_INTERNACAO,
  TRUNC(DT_SUGERIDA_INTERNACAO)DT_SUGERIDA_INTERNACAO,
  SN_PREVISAO_USO_OPME,
  CD_DOCUMENTO_CLINICO,
  CD_ATENDIMENTO,
  DIARIA,
  QT_DIARIAS_SOLICITADA,
  TP_ATENDIMENTO
FROM (
----------------------------------------------------------------------------------------
----- 07 - HOSPITAL SANTA CATARINA
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----- RESSONANCIA,TOMO,MAMO,DENSITOMETRIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
  -- AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND A.HR_AGENDA between (sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and b.cd_item_agendamento not in (select x.cd_item_agendamento from It_Agenda_Central x where x.cd_agenda_central = a.cd_agenda_central
   and x.cd_convenio IN (48,213) and x.cd_item_agendamento = 225) --- chamamdo C2308/11864 
   and c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   AND tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- EXAMES RESSONANCIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
      (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
      A.cd_convenio, --- A.cd_it_agenda_central
      G.Nr_Registro_Operadora_Ans,
      F.nm_paciente,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
      case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
      '225125' cd_cbos,
      --null dt_atendimento,
      to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
      (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
      'Eletiva' ds_carater ,
      'Externo' cd_tipo_internacao ,
      null cd_cid,
      case to_char(b.cd_item_agendamento) when '734' then '41101189' when '2032' then '41101189' else null end cd_procedimento,
      case to_char(b.cd_item_agendamento) when '734' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' when '2032' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' else null end ds_procedimento,
      'N¿¿o' uti,
      1 qt_solicitada,
      'Externo' tp_regime_internacao,
      to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
      'N' sn_previsao_uso_opme,
      null cd_documento_clinico,
      A.Cd_Atendimento,
      null diaria,
      null qt_diarias_solicitada,
      'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
  -- AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
  AND A.HR_AGENDA between (sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento  in (734,2032)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- ULTRASSOM
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('US')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- ENDOSCOPIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (8,41,5,3,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518, retirado conv 59 - C2307/10387
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- ENDOSCOPIA BRADESCO
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
      (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
      A.cd_convenio, --- A.cd_it_agenda_central
      G.Nr_Registro_Operadora_Ans,
      F.nm_paciente,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
      (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
      case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
      '225125' cd_cbos,
      --null dt_atendimento,
      to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
      (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
      'Eletiva' ds_carater ,
      'Externo' cd_tipo_internacao ,
      null cd_cid,
      C.exa_rx_cd_pro_fat cd_procedimento,
      H.ds_pro_fat ds_procedimento,
      'N¿¿o' uti,
      1 qt_solicitada,
      'Externo' tp_regime_internacao,
      to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
      'N' sn_previsao_uso_opme,
      null cd_documento_clinico,
      A.Cd_Atendimento,
      null diaria,
      null qt_diarias_solicitada,
      'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- ENDOSCOPIA BRADESCO
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
        case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- EXAMES ENDOSCOPIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
        case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (8,41,5,3,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518 , reitrado conv.59 C2307/10387
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- CARDIO E OUTROS
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'3'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
       -- null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('OT','CARDIO')
   and c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- ECOCARDIOGRAMA
----------------------------------------------------------------------------------------
 SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'3'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND B.Cd_Item_Agendamento in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
  and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- MEDICINA NUCLEAR
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'5'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('NM')
   and c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- LABORAT¿¿RIO - AGENDADO
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'7'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C2.cd_pro_fat_sus cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_LAB            C2,
       --MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_lab = C2.cd_exa_lab
   --AND c2.cd = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C2.Cd_Pro_Fat_Sus = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- LABORAT¿¿RIO - SEM AGENDA
----------------------------------------------------------------------------------------
SELECT
  to_char(a.cd_multi_empresa) cd_multi_empresa,
  to_char(g.cd_guia) id,
  g.cd_convenio,
  c.nr_registro_operadora_ans,
  p.nm_paciente,
  a.nr_carteira,
  pr.nm_prestador,
  pr.ds_codigo_conselho,
  CASE a.cd_multi_empresa WHEN 7 THEN 'SP' ELSE 'RJ' END uf_conselho,
  --decode(a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') empresa,
  --(select cd_cbos from especialid where cd_especialid = (select cd_especialid from esp_med where sn_principal = 'S'        and cd_prestador = pr.cd_prestador) cd_cbos,
  '225125' cd_cbos,
  --to_char(a.dt_atendimento) dt_atendimento,
  g.dt_solicitacao DH_SOLICITADO,
  cid.ds_cid ds_indicacao,
  'ELETIVA' ds_carater,
  'EXTERNO' cd_tipo_internacao,
  NULL cd_cid,
  --a.cd_cid,
  i.cd_pro_fat cd_procedimento,
  pf.ds_pro_fat ds_procedimento,
  'N¿¿O' uti,
  i.qt_autorizado qt_solicitada,
  'Externo' tp_regime_internacao,
  a.hr_atendimento dt_sugerida_internacao,
  'N' sn_previsao_uso_opme,
  NULL cd_documento_clinico,
  g.cd_atendimento cd_atendimento,
  NULL diaria,
  NULL qt_diarias_solicitada,
  'externo' tp_atendimento
FROM
  GUIA G,
  ATENDIME A,
  CONVENIO C,
  PACIENTE P,
  PRESTADOR PR,
  CONSELHO CO,
  CID,
  IT_GUIA I,
  PRO_FAT PF
WHERE
  1 = 1
  AND G.CD_ATENDIMENTO = A.CD_ATENDIMENTO
  AND G.CD_GUIA = I.CD_GUIA
  AND A.CD_CONVENIO = C.CD_CONVENIO
  AND A.CD_PACIENTE = P.CD_PACIENTE
  AND A.CD_PRESTADOR = PR.CD_PRESTADOR
  AND PR.CD_CONSELHO = CO.CD_CONSELHO
  AND A.CD_CID = CID.CD_CID(+)
  AND I.CD_PRO_FAT = PF.CD_PRO_FAT
  AND A.CD_MULTI_EMPRESA = 7
  AND A.CD_CONVENIO IN (7, 8, 5, 41, 59, 23, 35, 38, 39, 9, 50, 11, 12, 32, 48, 42, 13, 16, 22, 33)
  AND A.TP_ATENDIMENTO = 'E'
  AND G.TP_SITUACAO IN ('S', 'P')
  AND G.CD_MOVIMENTO_AGENDA_CENTRAL IS NULL
  --AND   TO_CHAR(G.DT_GERACAO,'DD/MM/YYYY') = TRUNC(SYSDATE)
  AND TRUNC(NVL(G.DT_GERACAO, SYSDATE)) = TRUNC(SYSDATE)
  AND A.CD_ORI_ATE = 3
  AND NVL(G.DT_GERACAO, SYSDATE) >= TO_DATE('25/05/2023 13:15:00', 'DD/MM/RRRR HH24:MI:SS')
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - EXAMES RESSONANCIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and b.cd_item_agendamento not in (select x.cd_item_agendamento from It_Agenda_Central x where x.cd_agenda_central = a.cd_agenda_central
   and x.cd_convenio IN (48,213) and x.cd_item_agendamento = 225) --- chamamdo C2308/11864 
   and c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - EXAMES RESSONANCIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        case to_char(b.cd_item_agendamento) when '734' then '41101189' when '2032' then '41101189' else null end cd_procedimento,
        case to_char(b.cd_item_agendamento) when '734' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' when '2032' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' else null end ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento  in (734,2032)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - ULTRASSOM
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('US')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - ENDOSCOPIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (8,41,5,3,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518 , retirado conv. 59 C2307/10387
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - ENDOSCOPIA BRADESCO
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+4
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - EXAMES ENDOSCOPIA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
        case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,5,3,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518 , retirado conv. 59 - chamado C2307/10387
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - CARDIO, OUTROS
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'3'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
       -- null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('OT','CARDIO')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - ECOCARDIOGRAMA
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'3'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND B.Cd_Item_Agendamento in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - MEDICINA NUCLEAR
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_paciente)||'.'||'5'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        C.exa_rx_cd_pro_fat cd_procedimento,
        H.ds_pro_fat ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+10
   AND D.ds_sigla_modalidade IN ('NM')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
   and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- AGENDAMENTO ONLINE - PROVA DE FUNCAO PULMONAR
----------------------------------------------------------------------------------------
SELECT  E.cd_multi_empresa cd_multi_empresa,
        (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
        A.cd_convenio, --- A.cd_it_agenda_central
        G.Nr_Registro_Operadora_Ans,
        F.nm_paciente,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
        (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
        case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
        '225125' cd_cbos,
        --null dt_atendimento,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
        (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
        'Eletiva' ds_carater ,
        'Externo' cd_tipo_internacao ,
        null cd_cid,
        case to_char(b.cd_item_agendamento) when '393' then '40105075' else null end cd_procedimento,
        case to_char(b.cd_item_agendamento) when '393' then 'PROVA DE FUNCAO PULMONAR COMPLETA (OU ESPIROMETRIA)' else null end ds_procedimento,
        'N¿¿o' uti,
        1 qt_solicitada,
        'Externo' tp_regime_internacao,
        to_date(a.Hr_agenda,'dd/mm/rrrr') dt_sugerida_internacao,
        'N' sn_previsao_uso_opme,
        null cd_documento_clinico,
        A.Cd_Atendimento,
        null diaria,
        null qt_diarias_solicitada,
        'externo' tp_atendimento
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE 1 = 1
   AND A.CD_CONVENIO in (5,12,14)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ESPIRO')
   AND B.Cd_Item_Agendamento  in (393)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------------------------------------------------------
UNION ALL
----------------------------------------------------------------------------------------
----- 03 - CASA DE SA¿¿DE S¿¿O JOS¿
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----- ANGIO / RESSONANCIA / PET - BRADESCO
----------------------------------------------------------------------------------------
 SELECT E.CD_MULTI_EMPRESA CD_MULTI_EMPRESA,
        (TO_CHAR(F.CD_MOVIMENTO_AGENDA_CENTRAL)||'.'||'1'||'-'||TO_CHAR(A.HR_AGENDA,'ddmm')) ID,
        A.CD_CONVENIO,
        G.NR_REGISTRO_OPERADORA_ANS,
        F.NM_PACIENTE,
        (SELECT DS_RESPOSTA FROM PER_PEDRX WHERE CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL AND CD_PERGUNTA = 102 AND ROWNUM = 1) NR_CARTEIRA,
        (SELECT DS_RESPOSTA FROM PER_PEDRX WHERE CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL AND CD_PERGUNTA = 100 AND ROWNUM = 1) NM_PRESTADOR,
        (SELECT DS_RESPOSTA FROM PER_PEDRX WHERE CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL AND CD_PERGUNTA = 101 AND ROWNUM = 1) DS_CODIGO_CONSELHO,
        CASE E.CD_MULTI_EMPRESA WHEN '7' THEN 'SP' ELSE 'RJ' END UF_CONSELHO,
        '225125' CD_CBOS,
        TO_DATE(A.HR_AGENDA,'dd/mm/rrrr') DH_SOLICITADO,
        (B.DS_ITEM_AGENDAMENTO || ' - ' || (SELECT DS_RESPOSTA FROM PER_PEDRX WHERE CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL AND CD_PERGUNTA = 117 AND ROWNUM = 1)) DS_INDICACAO,
        'Eletiva' DS_CARATER ,
        'Externo' CD_TIPO_INTERNACAO ,
        NULL CD_CID,
        C.EXA_RX_CD_PRO_FAT CD_PROCEDIMENTO,
        H.DS_PRO_FAT DS_PROCEDIMENTO,
        'N¿¿o' UTI,
        1 QT_SOLICITADA,
        'Externo' TP_REGIME_INTERNACAO,
        TO_DATE(A.HR_AGENDA,'dd/mm/rrrr') DT_SUGERIDA_INTERNACAO,
        'N' SN_PREVISAO_USO_OPME,
        NULL CD_DOCUMENTO_CLINICO,
        A.CD_ATENDIMENTO,
        NULL DIARIA,
        NULL QT_DIARIAS_SOLICITADA,
        'externo' TP_ATENDIMENTO
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
    --   PRESTADOR P
 WHERE 1 = 1
   AND A.CD_CONVENIO IN (73,661) -- BRADESCO
   AND A.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
   AND B.CD_EXA_RX = C.CD_EXA_RX
   AND C.CD_MODALIDADE_EXAME = D.CD_MODALIDADE_EXAME
   AND F.CD_MOVIMENTO_AGENDA_CENTRAL = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL
   AND A.CD_CONVENIO = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.CD_PRO_FAT
   AND E.CD_AGENDA_CENTRAL = A.CD_AGENDA_CENTRAL
  -- AND I.CD_PRESTADOR = P.CD_PRESTADOR
   AND TO_DATE(A.DT_GRAVACAO,'DD/MM/RRRR') = TRUNC(SYSDATE)
 ---  AND TO_DATE(A.HR_AGENDA,'DD/MM/RRRR') BETWEEN TO_DATE(SYSDATE,'DD/MM/RRRR') AND TO_DATE(SYSDATE,'DD/MM/RRRR')+10
  --AND A.CD_PACIENTE IN (2907882)
   AND   C.EXA_RX_CD_PRO_FAT IN (SELECT CD_PRO_FAT FROM PROIBICAO WHERE TP_PROIBICAO = 'AG'
   AND TP_ATENDIMENTO IN ('T','E','A') AND DT_FIM_PROIBICAO IS NULL AND CD_CONVENIO = A.CD_CONVENIO)
   AND I.TP_STATUS IN (SELECT MAX(MAC.TP_STATUS) FROM IT_MOVIMENTO_AGENDA_CENTRAL MAC WHERE  MAC.CD_MOVIMENTO_AGENDA_CENTRAL = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND MAC.CD_IT_AGENDA_CENTRAL = I.CD_IT_AGENDA_CENTRAL AND MAC.TP_STATUS = I.TP_STATUS AND  I.TP_STATUS = 'A')
   AND F.CD_USUARIO_MOVIMENTACAO <> 'INTEGRADOR.AGENDA'
   AND E.CD_MULTI_EMPRESA = 3
   AND I.CD_SETOR NOT IN (865)
   AND B.CD_ITEM_AGENDAMENTO IN (8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,38,40,41,
   51,55,63,64,71,72,85,86,87,88,89,90,91,92,93,94,95,96,97,100,101,
   102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,
   119,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,
   137,138,139,140,141,142,144,146,147,150,152,155,156,157,158,159,160,
   161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,
   178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,
   195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,
   212,213,214,215,216,217,218,219,220,221,222,223,224,225,238,239,244,
   249,250,251,254,256,257,258,262,263,264,265,266,267,268,269,271,274,
   276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,
   293,294,296,297,298,299,300,301,302,303,304,305,306,308,309,317,318,
   319,320,321,322,331,332,333,335,336,337,346,347,348,349,353,355,365,
   366,367,368,369,370,371,372,373,374,388,389,453,475,476,477,478,479,
   480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,
   497,498,499,500,501,502,503,504,505,506,507,511,514,515,516,517,518,
   519,520,521,522,523,524,525,526,527,528,700,701,710,717,718,722,725,
   726,727,728,729,730,731,732,733,734,1883,1900,1901,1902,1903,1904,1905,
   1907,1908,1909,1910,1911,1912,1913,1914,1915,1916,1917,1918,1937,1976,
   1978,1979,1980,1981,1986,1987,1989,1990,1992,1993,1994,1995,1996,1997,
   1998,2001,2004,2009,2010,2011,2012,2018,2022,2023,2024,2025,2026,2028,
   2029,2030,2031,2032,2033,2034,2035,2036,2037,2038,2039,2040,2041,2042,
   2043,2044,2045,2046,2047,2048,2049,2050,2051,2052,2053,2054,2055,2056,
   2057,2058,2059,2060,2061,2062,2063,2064,2065,2066,2067,2068,2069,2070,
   2071,2072,2073,2074,2075,2076,2077,2078,2079,2080,2081,2082,2083,2084,
   2085,2086,2087,2088,2089,2090,2091,2092,2093,2094,2095,2097,2099,2100,
   2101,2103,2105,2106,2107,2108,2114,2172,2174,2214,2215,2216,2217,2218,
   2219,2220,2221,2222,2223,2224,2225,2226,2227,2228,2229,2230,2234,2245,
   2247,2286,2287,2300,2301,2303,2307,2326,2328,2332,2339,2357,2358,2359,
   2360,2361,2362,2363,2364,2365,2366,2367,2368,2369,2370,2371,2372,2373,
   2374,2375,2376,2377,2378,2379,2380,2381,2382,2383,2384,2385,2386,2387,
   2388,2389,2390,2391,2392,2393,2394,2395,2396,2400,2401,2402,2403,2408,
   2409,2410,2411,2412,2413,2417,2418,2419,2420,2421,2422,2423,2424,2426,
   2427,2428,2429,2433,2434,2435,2436,2438,2439,2440,2441,2442,2445,2448,
   2449,2450,2452,2453,2454,2456,2457,2458,2459,2460,2463,2464,2465,2466,
   2467,2474,2480,2481,2489,2497,2498,2550,2551,2599,2669,2672,2675,2711,
   2717,2771,2772,2773,2774,2775,2776,2777,2778,2779,2780,2781,2782,2783,
   2784,2790,2794,2795,2796,2797,2798,2799,2800,2801,2802,2863,2893)
)
WHERE NM_PACIENTe Like '%DANIELA%SILVE%'--1 = 1
--ID = '508584.1-1704'
GROUP BY CD_MULTI_EMPRESA,
    ID,
    CD_CONVENIO,
    NR_REGISTRO_OPERADORA_ANS,
    NM_PACIENTE,
    NR_CARTEIRA,
    NM_PRESTADOR,
    DS_CODIGO_CONSELHO,
    UF_CONSELHO,
    CD_CBOS,
    DH_SOLICITADO,
    DS_CARATER,
    CD_TIPO_INTERNACAO,
    CD_CID,
    CD_PROCEDIMENTO,
    DS_PROCEDIMENTO,
    UTI,
    TP_REGIME_INTERNACAO,
    DT_SUGERIDA_INTERNACAO,
    SN_PREVISAO_USO_OPME,
    CD_DOCUMENTO_CLINICO,
    CD_ATENDIMENTO,
    DIARIA,
    QT_DIARIAS_SOLICITADA,
    TP_ATENDIMENTO
--ORDER BY NM_PACIENTE
;
