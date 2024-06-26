CREATE OR REPLACE VIEW VW_OVMD_GUIA_SADT_ELETIVO AS
select cd_multi_empresa,  ID, cd_convenio, Nr_Registro_Operadora_Ans, nm_paciente, nr_carteira, nm_prestador,ds_codigo_conselho,
uf_conselho, cd_cbos, trunc(dh_solicitado)dh_solicitado,LISTAGG(DS_INDICACAO, '; ') WITHIN GROUP (ORDER BY CD_MULTI_EMPRESA) DS_INDICACAO, ds_carater, cd_tipo_internacao, cd_cid, cd_procedimento, ds_procedimento,
uti, count(qt_solicitada) qt_solicitada, tp_regime_internacao, trunc(dt_sugerida_internacao)dt_sugerida_internacao,sn_previsao_uso_opme, cd_documento_clinico,
Cd_Atendimento, diaria, qt_diarias_solicitada, tp_atendimento
from (

-----RESSONANCIA,TOMO,MAMO,DENSITOMETRIA

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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3
----------------------------------------------------------------
UNION all
------EXAMES RESSONANCIA
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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3

 ------------------------------------
 union all
 ------ULTRASSOM

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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
 --order by 3

 --------------------------------------------------------------------
 union all
 ------ENDOSCOPIA

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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518
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
 --order by 3

  --------------------------------------------------------------------
 union all
 -------ENDOSCOPIA BRADESCO

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
                'N�o' uti,
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
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3

--------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
                case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
                'N�o' uti,
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
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+12
   AND D.ds_sigla_modalidade IN ('ES')
   and b.cd_item_agendamento = 1940
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3

------------------------------------------------------
UNION all
-----EXAMES ENDOSCOPIA

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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518
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
 --order by 3

 -----------------------------------
 union all
 -----CARDIO, OUTROS
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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
   and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
-- order by 3
 -----------------------------------------------------

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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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

-------------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
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
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
 and f.cd_usuario_movimentacao <> 'INTEGRADOR.AGENDA'
 --order by 3

---------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C2.cd_pro_fat_sus cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
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

-----------------------------------------
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
'ELETIVA' ds_carater,
'EXTERNO' cd_tipo_internacao,
  null cd_cid,--a.cd_cid,
i.cd_pro_fat cd_procedimento,
pf.ds_pro_fat ds_procedimento,
'N�O' uti,
i.qt_autorizado qt_solicitada,
'Externo' tp_regime_internacao,
a.hr_atendimento dt_sugerida_internacao,
'N' sn_previsao_uso_opme,
null cd_documento_clinico,
g.cd_atendimento cd_atendimento,
null diaria,
null qt_diarias_solicitada,
'externo' tp_atendimento
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

-----------------------------------------
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
'ELETIVA' ds_carater,
'EXTERNO' cd_tipo_internacao,
  null cd_cid,--a.cd_cid,
i.cd_pro_fat cd_procedimento,
pf.ds_pro_fat ds_procedimento,
'N�O' uti,
i.qt_autorizado qt_solicitada,
'Externo' tp_regime_internacao,
a.hr_atendimento dt_sugerida_internacao,
'N' sn_previsao_uso_opme,
null cd_documento_clinico,
g.cd_atendimento cd_atendimento,
null diaria,
null qt_diarias_solicitada,
'externo' tp_atendimento
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

-------------------------------------------------------------------
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
                to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3
----------------------------------------------------------------
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
                to_date(a.Hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '734' then '41101189' when '2032' then '41101189' else null end cd_procedimento,
                case to_char(b.cd_item_agendamento) when '734' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' when '2032' then 'RM - PELVE (NAO INCLUI ARTICULACOES COXOFEMORAIS)' else null end ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
 --order by 3

 ------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
 --order by 3

 --------------------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (8,41,5,3,59,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518
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
 --order by 3

  --------------------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
   AND to_date(A.HR_AGENDA,'dd/mm/rrrr') between to_date(sysdate,'dd/mm/rrrr') and to_date(sysdate,'dd/mm/rrrr')+4
   AND D.ds_sigla_modalidade IN ('ES')
   and   c.exa_rx_cd_pro_fat in (select cd_pro_fat from proibicao where tp_proibicao = 'AG'
         and tp_atendimento in ('T','E') and dt_fim_proibicao is null and cd_convenio = a.cd_convenio)
   --and B.cd_item_agendamento not in (2008,1940,2020,2172,43,2300,270,2247,1980,1981,1979,276,1998,2285,250)
   and i.tp_status = 'A'
   and f.cd_usuario_movimentacao = 'INTEGRADOR.AGENDA'
 --order by 3

------------------------------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                case to_char(b.cd_item_agendamento) when '1940' then '40202615' else null end cd_procedimento,
                case b.cd_item_agendamento when 1940 then 'ENDOSCOPIA DIGESTIVA ALTA'  else null end ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,42,13,16,22,33) --retirado conv. 48 - chamado C2203/12518
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
 --order by 3

 -----------------------------------
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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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
-- order by 3
 -----------------------------------------------------

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
                to_date(A.hr_agenda,'dd/mm/rrrr') dh_solicitado,
                (b.ds_item_agendamento || ' - ' || (select ds_resposta from per_pedrx where cd_it_agenda_central = A.cd_it_agenda_central and cd_pergunta = 117 and rownum = 1)) ds_indicacao,
                'Eletiva' ds_carater ,
                'Externo' cd_tipo_internacao ,
                null cd_cid,
                C.exa_rx_cd_pro_fat cd_procedimento,
                H.ds_pro_fat ds_procedimento,
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33) --RETIRADO CONV. 5 AMIL - CHAMADO C2212/7521
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

-------------------------------------------------------------
UNION all
-------MEDICINA NUCLEAR
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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (7,8,41,5,3,59,23,38,39,50,11,12,32,48,42,13,16,22,33)
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
 --order by 3

-----------------------------------------------------

UNION all
------PROVA DE FUNCAO PULMONAR
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
                'N�o' uti,
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
 WHERE A.CD_CONVENIO in (5,12,14)
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
 --order by 3
 ------------------------  VIEW CASA DE SAUDE S�O JOS� -------------------------------
  union all 
  
  SELECT 
                --E.CD_MULTI_EMPRESA CD_MULTI_EMPRESA,
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
                'N�o' UTI,
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
 WHERE 1 =1 ---A.CD_CONVENIO IN (73) 
   AND A.CD_ITEM_AGENDAMENTO = B.CD_ITEM_AGENDAMENTO
   AND B.CD_EXA_RX = C.CD_EXA_RX
   AND C.CD_MODALIDADE_EXAME = D.CD_MODALIDADE_EXAME
   AND F.CD_MOVIMENTO_AGENDA_CENTRAL = I.CD_MOVIMENTO_AGENDA_CENTRAL
   AND I.CD_IT_AGENDA_CENTRAL = A.CD_IT_AGENDA_CENTRAL
   AND A.CD_CONVENIO = G.CD_CONVENIO
   AND C.EXA_RX_CD_PRO_FAT = H.CD_PRO_FAT
   AND E.CD_AGENDA_CENTRAL = A.CD_AGENDA_CENTRAL
  -- AND I.CD_PRESTADOR = P.CD_PRESTADOR
  AND TO_DATE(A.HR_AGENDA,'DD/MM/RRRR') BETWEEN TO_DATE(SYSDATE,'DD/MM/RRRR') AND TO_DATE(SYSDATE,'DD/MM/RRRR')+10
  --AND A.CD_PACIENTE IN (2907882)
   AND   C.EXA_RX_CD_PRO_FAT IN (SELECT CD_PRO_FAT FROM PROIBICAO WHERE TP_PROIBICAO = 'AG'
         AND TP_ATENDIMENTO IN ('T','E','A') AND DT_FIM_PROIBICAO IS NULL AND CD_CONVENIO = A.CD_CONVENIO)
   AND I.TP_STATUS IN (SELECT MAX(MAC.TP_STATUS) FROM IT_MOVIMENTO_AGENDA_CENTRAL MAC WHERE  MAC.CD_MOVIMENTO_AGENDA_CENTRAL = I.CD_MOVIMENTO_AGENDA_CENTRAL
    AND MAC.CD_IT_AGENDA_CENTRAL = I.CD_IT_AGENDA_CENTRAL AND MAC.TP_STATUS = I.TP_STATUS AND  I.TP_STATUS = 'A')
   AND F.CD_USUARIO_MOVIMENTACAO <> 'INTEGRADOR.AGENDA'
   AND A.CD_CONVENIO IN (68) -- AMIL 
   AND E.CD_MULTI_EMPRESA = 3 

)
--where id = '508584.1-1704'
group by
cd_multi_empresa,  ID, cd_convenio, Nr_Registro_Operadora_Ans, nm_paciente, nr_carteira, nm_prestador,ds_codigo_conselho,
uf_conselho, cd_cbos, dh_solicitado, ds_carater, cd_tipo_internacao, cd_cid, cd_procedimento, ds_procedimento,
uti, tp_regime_internacao, dt_sugerida_internacao, sn_previsao_uso_opme, cd_documento_clinico,
Cd_Atendimento, diaria, qt_diarias_solicitada, tp_atendimento
order by nm_paciente
;
