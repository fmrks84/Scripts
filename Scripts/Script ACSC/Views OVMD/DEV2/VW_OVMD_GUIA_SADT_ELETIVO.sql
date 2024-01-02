CREATE OR REPLACE VIEW ENSEMBLE.VW_OVMD_GUIA_SADT_ELETIVO AS
select cd_multi_empresa,  ID, cd_convenio, Nr_Registro_Operadora_Ans, nm_paciente, nr_carteira, nm_prestador,ds_codigo_conselho,
uf_conselho, cd_cbos, trunc(dh_solicitado)dh_solicitado,LISTAGG(DS_INDICACAO, '; ') WITHIN GROUP (ORDER BY CD_MULTI_EMPRESA) DS_INDICACAO, ds_carater, cd_tipo_internacao, cd_cid, cd_procedimento, ds_procedimento,
uti, count(qt_solicitada) qt_solicitada, tp_regime_internacao, trunc(dt_sugerida_internacao)dt_sugerida_internacao,sn_previsao_uso_opme, cd_documento_clinico,
Cd_Atendimento, diaria, qt_diarias_solicitada, tp_atendimento, origem_pedido, cd_convenio_ovm
from (
-----RESSONANCIA,TOMO,MAMO,DENSITOMETRIA--->1
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                a.Hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate + 10)
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat
                                   from proibicao
                                  where tp_proibicao = 'AG'
                                    and tp_atendimento in ('T','E')
                                    and dt_fim_proibicao is null
                                    and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
---------------------------------------------------------------->2
UNION all
------EXAMES RESSONANCIA
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                a.Hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '734' then '41101189' when '2032' then '41101189' else null end cd_procedimento,
                case to_char(b.cd_item_agendamento) when '734' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' when '2032' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' else null end ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate +10)
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento  in (734,2032)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
  ------------------------------------>3
 union all
 ------ULTRASSOM
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'1'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate + 10)
   AND D.ds_sigla_modalidade IN ('US')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 -------------------------------------------------------------------->4
 union all
 ------ENDOSCOPIA
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate +10)
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
  -------------------------------------------------------------------->5
 union all
 -------ENDOSCOPIA BRADESCO
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate + 4)
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
-------------------------------------------------------->6
union all
----ENDOSCOPIA BRADESCO
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
                case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate +4)
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
------------------------------------------------------>7
UNION all
-----EXAMES ENDOSCOPIA
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'2'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
                case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate + 10)
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 ----------------------------------->8
 union all
 -----CARDIO, OUTROS
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_movimento_agenda_central)||'.'||'3'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and (sysdate+10)
   AND D.ds_sigla_modalidade IN ('OT','CARDIO')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
-- order by 3
 ----------------------------------------------------->9
 UNION all
------ECOCARDIOGRAMA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND B.Cd_Item_Agendamento in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
  and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
------------------------------------------------------------->10
UNION all
-------MEDICINA NUCLEAR
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('NM')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
 and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3
--------------------------------------------------------->11
UNION all
-------LAB AGENDADO
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C2.cd_pro_fat_sus cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_LAB            C2,
       --MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_lab = C2.cd_exa_lab
   --AND c2.cd = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C2.Cd_Pro_Fat_Sus = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
  and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
----------------------------------------->12
union all
--------------LAB SEM AGENDA
select
to_Char(a.cd_multi_empresa) cd_multi_empresa,
to_char(g.cd_guia) id,
g.cd_convenio,
c.nr_registro_operadora_ans,
p.nm_paciente,
a.nr_carteira,
pr.nm_prestador,
pr.ds_codigo_conselho,
case a.cd_multi_empresa when 7 then 'SP' else 'RJ' end uf_conselho,
--decode(a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') empresa,
/*(select cd_cbos from especialid where cd_especialid = (select cd_especialid from esp_med where sn_principal = 'S'
        and cd_prestador = pr.cd_prestador) cd_cbos,*/
'225125' cd_cbos,
--to_char(a.dt_atendimento) dt_atendimento,
g.dt_solicitacao DH_SOLICITADO,
cid.ds_cid ds_indicacao,
'eletivo' ds_carater,
'EXTERNO' cd_tipo_internacao,
  null cd_cid,--a.cd_cid,
i.cd_pro_fat cd_procedimento,
pf.ds_pro_fat ds_procedimento,
'NÃO' uti,
i.qt_autorizado qt_solicitada,
'Externo' tp_regime_internacao,
a.hr_atendimento dt_sugerida_internacao,
'N' sn_previsao_uso_opme,
null cd_documento_clinico,
g.cd_atendimento cd_atendimento,
to_number(null) diaria,
to_number(null) qt_diarias_solicitada,
'externo' tp_atendimento,
'sadt' origem_pedido,
mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              a.cd_multi_empresa ,
                                              'OVERMIND',
                                              g.cd_convenio ,NULL) cd_convenio_ovm
from guia g, atendime a, convenio c, paciente p, prestador pr, conselho co, cid, it_guia i, pro_fat pf
where g.cd_Atendimento = a.cd_atendimento
and   g.cd_guia = i.cd_guia
and   a.cd_convenio = c.cd_convenio
and   a.cd_paciente = p.cd_paciente
and   a.cd_prestador = pr.cd_prestador
and   pr.cd_conselho = co.cd_conselho
and   a.cd_cid = cid.cd_cid(+)
and   i.cd_pro_fat = pf.cd_pro_fat
and   a.cd_multi_empresa = 7
and   A.CD_CONVENIO in (7,8,5,41,59,22,23,35,38,39,9,50,11,12,32,48,42,13,16,22,33)
and   a.tp_atendimento = 'E'
and   g.tp_situacao in ('S','P')
and   g.cd_movimento_agenda_central is null
--and   to_char(g.dt_geracao,'dd/mm/yyyy') = trunc(sysdate)
and   trunc(nvl(g.dt_geracao, sysdate)) = trunc(sysdate)
and   a.cd_ori_ate = 3
--and   g.cd_atendimento = 1030707
--ORDER BY 5
----------------------------------------->13
union all
--------------LAB SEM AGENDA ALLIANZ
select
to_Char(a.cd_multi_empresa) cd_multi_empresa,
to_char(g.cd_guia) id,
g.cd_convenio,
c.nr_registro_operadora_ans,
p.nm_paciente,
a.nr_carteira,
pr.nm_prestador,
pr.ds_codigo_conselho,
case a.cd_multi_empresa when 7 then 'SP' else 'RJ' end uf_conselho,
--decode(a.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') empresa,
/*(select cd_cbos from especialid where cd_especialid = (select cd_especialid from esp_med where sn_principal = 'S'
        and cd_prestador = pr.cd_prestador) cd_cbos,*/
'225125' cd_cbos,
--to_char(a.dt_atendimento) dt_atendimento,
g.dt_solicitacao DH_SOLICITADO,
cid.ds_cid ds_indicacao,
'eletivo' ds_carater,
'EXTERNO' cd_tipo_internacao,
  null cd_cid,--a.cd_cid,
i.cd_pro_fat cd_procedimento,
pf.ds_pro_fat ds_procedimento,
'NÃO' uti,
i.qt_autorizado qt_solicitada,
'Externo' tp_regime_internacao,
a.hr_atendimento dt_sugerida_internacao,
'N' sn_previsao_uso_opme,
null cd_documento_clinico,
g.cd_atendimento cd_atendimento,
to_number(null) diaria,
to_number(null) qt_diarias_solicitada,
'externo' tp_atendimento,
'sadt' origem_pedido,
mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              a.cd_multi_empresa ,
                                              'OVERMIND',
                                              g.cd_convenio ,NULL) cd_convenio_ovm
from guia g, atendime a, convenio c, paciente p, prestador pr, conselho co, cid, it_guia i, pro_fat pf
where g.cd_Atendimento = a.cd_atendimento
and   g.cd_guia = i.cd_guia
and   a.cd_convenio = c.cd_convenio
and   a.cd_paciente = p.cd_paciente
and   a.cd_prestador = pr.cd_prestador
and   pr.cd_conselho = co.cd_conselho
and   a.cd_cid = cid.cd_cid(+)
and   i.cd_pro_fat = pf.cd_pro_fat
and   a.cd_multi_empresa = 7
and   A.CD_CONVENIO in (3)
and   a.tp_atendimento = 'E'
and   g.tp_situacao in ('S')
and   g.cd_movimento_agenda_central is null
--and   to_char(g.dt_geracao,'dd/mm/yyyy') = trunc(sysdate)
and   trunc(nvl(g.dt_geracao, sysdate)) = trunc(sysdate)
and   a.cd_ori_ate = 3
--and   g.cd_atendimento = 1030707
--ORDER BY 5
------------------------------------------------------------------->14
UNION ALL
-------AGENDAMENTO ONLINE
-----RESSONANCIA,TOMO,MAMO,DENSITOMETRIA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
---------------------------------------------------------------->15
UNION all
------EXAMES RESSONANCIA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '734' then '41101189' when '2032' then '41101189' else null end cd_procedimento,
                case to_char(b.cd_item_agendamento) when '734' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' when '2032' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' else null end ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('MR', 'CT', 'MG', 'DO')
   AND B.Cd_Item_Agendamento  in (734,2032)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
 ------------------------------------>16
 union all
 ------ULTRASSOM
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('US')
   AND B.Cd_Item_Agendamento not in (259,373,372,2172,511,512,374,1965,2182)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
 -------------------------------------------------------------------->17
 union all
 ------ENDOSCOPIA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
  -------------------------------------------------------------------->18
 union all
 -------ENDOSCOPIA BRADESCO
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+4
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
------------------------------------------------------>19
UNION all
-----EXAMES ENDOSCOPIA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
                case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND C.cd_exa_rx not in (2353,1875,1904)
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
 ----------------------------------->20
 union all
 -----CARDIO, OUTROS
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('OT','CARDIO')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
-- order by 3
 ----------------------------------------------------->21
 UNION all
------ECOCARDIOGRAMA
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
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND B.Cd_Item_Agendamento in (259,373,372,2172,511,512,374,1965,2182)
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
  and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
------------------------------------------------------------->22
UNION all
-------MEDICINA NUCLEAR
SELECT  E.cd_multi_empresa cd_multi_empresa,
                (to_char(F.cd_paciente)||'.'||'5'||'-'||to_char(a.hr_agenda,'ddmm')) ID,
                A.cd_convenio,
                G.Nr_Registro_Operadora_Ans,
                F.nm_paciente,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 102 and rownum = 1) nr_carteira,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 100 and rownum = 1) nm_prestador,
                (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 101 and rownum = 1) ds_codigo_conselho,
                case e.cd_multi_empresa when '7' then 'SP' else 'RJ' end uf_conselho,
                '225125' cd_cbos,
                A.hr_agenda dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'eletivo' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'Não' uti,
                1 qt_solicitada,
                'Externo' tp_regime_internacao,
                a.Hr_agenda dt_sugerida_internacao,
                'N' sn_previsao_uso_opme,
                null cd_documento_clinico,
                A.Cd_Atendimento,
                to_number(null) diaria,
                to_number(null) qt_diarias_solicitada,
                'externo' tp_atendimento,
				'sadt' origem_pedido,
				mvintegra.fnc_imv_retorna_depara('OPERADORA_CONVENIO',
                                              e.cd_multi_empresa ,
                                              'OVERMIND',
                                              a.cd_convenio ,NULL) cd_convenio_ovm
  FROM IT_AGENDA_CENTRAL A,
       ITEM_AGENDAMENTO  B,
       EXA_RX            C,
       MODALIDADE_EXAME  D,
       AGENDA_CENTRAL    E,
       MOVIMENTO_AGENDA_CENTRAL F,
       CONVENIO          G,
       PRO_FAT           H,
       IT_MOVIMENTO_AGENDA_CENTRAL I
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
   AND A.cd_item_agendamento = B.cd_item_agendamento
   AND B.cd_exa_rx = C.cd_exa_rx
   AND C.cd_modalidade_exame = D.cd_modalidade_exame
   AND F.Cd_Movimento_Agenda_Central = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.Cd_It_Agenda_Central = A.CD_IT_AGENDA_CENTRAL
   AND A.Cd_Convenio = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.cd_pro_Fat
   AND E.Cd_Agenda_Central = A.CD_AGENDA_CENTRAL
   AND A.HR_AGENDA between trunc(sysdate) and sysdate+10
   AND D.ds_sigla_modalidade IN ('NM')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   and i.tp_status = 'A'
 and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
)
group by
cd_multi_empresa,  ID, cd_convenio, Nr_Registro_Operadora_Ans, nm_paciente, nr_carteira, nm_prestador,ds_codigo_conselho,
uf_conselho, cd_cbos, dh_solicitado, ds_carater, cd_tipo_internacao, cd_cid, cd_procedimento, ds_procedimento,
uti, tp_regime_internacao, dt_sugerida_internacao, sn_previsao_uso_opme, cd_documento_clinico,
Cd_Atendimento, diaria, qt_diarias_solicitada, tp_atendimento, origem_pedido, cd_convenio_ovm;
