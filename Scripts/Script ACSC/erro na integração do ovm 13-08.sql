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
                'Não' uti,
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
 WHERE /*A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND*/ A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+10
  AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
  and i.tp_status = 'A'
  and f.nm_paciente like '%VITOR FERNANDES BATTISTI PETRIS%'
   --and a.cd_paciente = 793492 
  -- and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
  ;
/*  select * from item_agendamento y where y.cd_item_agendamento = 100
  select * from modalidade_exame y1 where y1.cd_modalidade_exame
  select * from exa_rx y2 where y2.cd_exa_rx = 1619
  select * from IT_MOVIMENTO_AGENDA_CENTRAL y5 where y5.cd_agenda_central = 462739*/
