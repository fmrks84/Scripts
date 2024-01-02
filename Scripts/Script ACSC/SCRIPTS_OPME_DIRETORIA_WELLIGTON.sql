WITH OC AS
(   SELECT
        consumo_paciente.cd_atendimento,
        consumo_paciente.cd_aviso_cirurgia,
        ord_com.cd_ord_com,
        itord_pro.vl_unitario,
        itord_pro.vl_total,
        itord_pro.qt_comprada,
        produto.cd_produto,
        produto.cd_pro_fat



      from consumo_paciente
      INNER JOIN ord_com ON ord_com.cd_consumo_paciente = consumo_paciente.cd_consumo_paciente
      INNER JOIN itord_pro ON itord_pro.cd_ord_com  = ord_com.cd_ord_com
      INNER JOIN produto ON produto.cd_produto = itord_pro.cd_produto

      WHERE Trunc(ord_com.dt_ord_com) >='01/jan/2022' )
 ,
 vw_guia_valor AS
(  SELECT DISTINCT
          G.CD_GUIA,
          IG.CD_PRO_FAT,
          ig.sn_fatura_direto fatura_direto,
          IGO.TP_REFERENCIA,
          IGO.VL_UNITARIO               AS VL_UNITARIO_OPME,
          IGO.VL_TAXA_COMERCIALIZACAO   AS VL_TAXA_COMERCIALIZACAO,
          IGO.VL_TOTAL                  AS VL_TOTAL_OPME
    FROM DBAMV.GUIA                     G
   INNER JOIN DBAMV.IT_GUIA             IG  ON IG.CD_GUIA = G.CD_GUIA
    inner JOIN DBAMV.VAL_OPME_IT_GUIA   IGO ON IGO.CD_IT_GUIA = IG.CD_IT_GUIA
  WHERE G.TP_GUIA = 'O'
    AND G.DT_GERACAO >= SYSDATE - 720
)

select 
       To_Date(To_Char(dt_lancamento,'dd/mm/yyyy'),'dd/mm/yyyy') dt_lancamento,
       rf.cd_convenio,

       ate.cd_atendimento,

       decode(ate.TP_ATENDIMENTO, 'I', 1, 'U', 2, 'A', 3, 'E', 4) CD_TIPO_ATENDIMENTO,
       ate.cd_tipo_internacao,
       
       ate.cd_especialid,
       ate.cd_prestador,
       ate.CD_PRO_INT,
       
       ate.CD_ORI_ATE,
       ate.CD_TIP_RES,
       ate.CD_MULTI_EMPRESA,
       irf.cd_setor_produziu,
       irf.cd_setor,
       le.cd_unid_int,
       ate.NM_USUARIO,
       TO_date(to_char(ate.DT_ATENDIMENTO, 'dd/mm/yyyy') || ' ' ||
               to_char(ate.hr_atendimento, 'HH24:mi:ss'),
               'DD/MM/YYYY HH24:MI:SS') DH_ATENDIMENTO,
       rf.dt_inicio,
       rf.dt_final,
       case
         when ate.DT_ALTA is not null then
          TO_DATE(TO_CHAR(ate.DT_ALTA, 'DD/MM/YYYY') || ' ' ||
                  to_char(ate.hr_alta, 'HH24:mi:ss'),
                  'DD/MM/YYYY HH24:MI:SS')
         else
          null
       end DH_ALTA,
       TO_date(to_char(irf.dt_lancamento, 'dd/mm/yyyy') || ' ' ||
               to_char(irf.hr_lancamento, 'HH24:mi:ss'),
               'DD/MM/YYYY HH24:MI:SS') DH_LANCAMENTO,
       
      
       case
         when gf.tp_gru_fat = 'OP' then
          '1'
         ELSE
          '0'
       END SN_opme,
       rf.cd_reg_fat,
       
       irf.cd_lancamento,
       irf.cd_pro_fat,
       pac.cd_paciente,
       ate.NR_CARTEIRA,
       -------indicadores
       -----------
   
       case
         when irf.tp_pagamento is null or irf.tp_pagamento = 'P' or
              irf.tp_pagamento = 'F' then
          irf.vl_total_conta
          WHEN irf.tp_mvto = 'Cirurgia' AND irf.tp_pagamento = 'C' THEN     ---corrigido valores
          irf.vl_total_conta
         else
          0
       end vl_total_conta,
       -----------

       irf.qt_lancamento qt_produzido,
       case
         when rfat.dt_entrega_da_fatura is not null 
         then
          irf.vl_total_conta
         else
          irf.vl_total_conta
       end vl_faturado,
       case
         when rfat.dt_entrega_da_fatura is not null then
          irf.qt_lancamento
         else
          0
       end qt_faturado,
       case
         when rf.cd_remessa is not null and
              to_char(rfat.dt_entrega_da_fatura, 'mm/yyyy') =
              to_char(fat.dt_competencia, 'mm/yyyy') then
          irf.vl_total_conta
         else
          0
       end vl_faturado_competencia,
       case
         when rf.cd_remessa is not null and
              rfat.dt_entrega_da_fatura is null 
              then
          irf.vl_total_conta
         else
          irf.vl_total_conta
       end vl_produzido_a_faturar,
       case
         when rf.cd_remessa is null then
          irf.vl_total_conta
         else
          0
       end saldo_a_faturar,
       
      
       rf.cd_remessa remessa,
       remessa_nota_fiscal.remessa_nf,
       
       TO_DATE(to_char(fat.DT_COMPETENCIA, 'dd/mm/yyyy'), 'DD/MM/YYYY') dt_competencia,
       rfat.dt_abertura,
       rfat.dt_fechamento,
       rfat.dt_entrega_da_fatura,
       rfat.dt_prevista_para_pgto,
       rf.dt_remessa,
       decode(IRF.SN_PERTENCE_PACOTE, 'S', '1', 'N', '0') SN_PERTENCE_PACOTE, ---ajustador para numero
       aud.qt_lancamento_ant qt_lancamento_ant,
       aud.qt_lancamento qt_lancamento,
       aud.vl_total_conta_ant,
       aud.vl_total_conta VL_TOTAL_CONTA_AUD,
       aud.cd_motivo_auditoria,
       irf.vl_nota,
       prof.ds_pro_fat,
       gf.ds_gru_Fat,
       oc.cd_ord_com,
        oc.vl_unitario,
        oc.vl_total,
        oc.qt_comprada,
        oc.cd_produto,
                VW_GUIA_VALOR.TP_REFERENCIA,
        VW_GUIA_VALOR.VL_UNITARIO_OPME,
        VW_GUIA_VALOR.VL_TAXA_COMERCIALIZACAO,
        VW_GUIA_VALOR.VL_TOTAL_OPME,
    vw_guia_valor.fatura_direto




  from reg_fat rf,
       itreg_fat irf,
       atendime ate,
       convenio conv,
       pro_fat prof,
       paciente pac,
       gru_fat gf,
       fatura fat,
       remessa_fatura rfat,
       leito le,
       oc,
       vw_guia_valor,
       (Select x.remessa_nf remessa_nf
,max(x.Nota) Nota
From (Select itfat_nota_fiscal.cd_remessa remessa_nf, max(nota_fiscal.nr_id_nota_fiscal) Nota
from dbamv.itfat_nota_fiscal,
dbamv.nota_fiscal
where itfat_nota_fiscal.cd_nota_fiscal = nota_fiscal.cd_nota_fiscal
--and Nota_Fiscal.cd_multi_empresa = 7
and nvl(nota_fiscal.cd_status, 'E') = 'E'
group by itfat_nota_fiscal.cd_remessa
Union
Select nota_fiscal.cd_remessa, max(nota_fiscal.nr_id_nota_fiscal) Nota
from dbamv.nota_fiscal
where /*Nota_Fiscal.cd_multi_empresa = 7
and */nvl(nota_fiscal.cd_status, 'E') = 'E'
group by nota_fiscal.cd_remessa) x
group by x.remessa_nf) remessa_nota_fiscal,
       (select cd_atendimento, cd_guia, guia.nr_guia, guia.cd_senha
          from guia
         where guia.tp_guia = 'I') gui,
       ( ---------auditoria
        SELECT cd_reg_fat || cd_pro_fat || cd_lancamento_fat codigo,
                cd_atendimento,
                cd_reg_Fat,
                cd_pro_fat,
                cd_lancamento_fat,
                dt_auditoria,
                auditoria_conta.qt_lancamento_ant,
                auditoria_conta.qt_lancamento,
                auditoria_conta.vl_total_conta_ant,
                auditoria_conta.vl_total_conta,
                motivo_auditoria.cd_motivo_auditoria
          from AUDITORIA_CONTA,
                motivo_auditoria,
                (select cd_reg_fat || cd_lancamento_fat || cd_pro_fat codigo,
                        max(cd_auditoria_conta) cd_auditoria_conta
                   from AUDITORIA_CONTA
                  group by cd_reg_fat, cd_lancamento_fat, cd_pro_fat) aud
         where auditoria_conta.cd_motivo_auditoria =
               motivo_auditoria.cd_motivo_auditoria
           and auditoria_conta.cd_reg_fat || cd_lancamento_fat || cd_pro_fat =
               aud.codigo
           and auditoria_conta.cd_auditoria_conta = aud.cd_auditoria_conta
         order by cd_atendimento, cd_reg_fat, cd_lancamento_fat

        ) aud --------auditoria

 where rf.cd_reg_fat = irf.cd_reg_fat
   and rf.cd_atendimento = ate.CD_ATENDIMENTO
   and ate.CD_LEITO = le.cd_leito
   and rf.CD_CONVENIO = conv.cd_convenio
   and irf.cd_pro_fat = prof.cd_pro_fat
   and irf.cd_gru_fat = gf.cd_gru_fat
   and ate.CD_PACIENTE = pac.cd_paciente
   and rf.cd_remessa = rfat.cd_remessa
   and rfat.cd_fatura = fat.CD_FATURA
   AND rf.cd_remessa = remessa_nota_fiscal.remessa_nf(+)
   and ate.CD_ATENDIMENTO = gui.cd_atendimento(+)
   and irf.cd_reg_fat || irf.cd_pro_fat || irf.cd_lancamento =
       aud.codigo(+)
       AND irf.cd_gru_fat in (5,9)
  AND oc.cd_atendimento(+) = rf.cd_Atendimento
  AND oc.cd_pro_fat(+) = prof.cd_pro_fat
  AND vw_guia_valor.cd_guia(+) = gui.cd_guia
  AND vw_guia_valor.cd_pro_fat(+) = prof.cd_pro_fat
         AND  To_Date(To_Char(irf.dt_lancamento,'dd/mm/yyyy'),'dd/mm/yyyy') >= to_date('01/01/2020','DD/MM/RRRR')     --trunc(sysdate)-365     


 and ate.cd_atendimento = 5543023 

union all

------------------------- CONTAS INTERNADOS SEM REMESSA ----------------------------------

select

 To_Date(To_Char(dt_lancamento,'dd/mm/yyyy'),'dd/mm/yyyy') dt_lancamento,
 rf.cd_convenio,
 ate.cd_atendimento atendimento,
 decode(ate.TP_ATENDIMENTO, 'I', 1, 'U', 2, 'A', 3, 'E', 4)CD_TIPO_ATENDIMENTO,
 ate.cd_tipo_internacao,
 ate.cd_especialid,
 ate.cd_prestador,
 ate.CD_PRO_INT,
 ate.CD_ORI_ATE,
 ate.CD_TIP_RES,
 ate.CD_MULTI_EMPRESA,
 irf.cd_setor_produziu,
 irf.cd_setor,
 le.cd_unid_int,
 ate.NM_USUARIO,
 TO_date(to_char(ate.DT_ATENDIMENTO, 'dd/mm/yyyy') || ' ' ||
         to_char(ate.hr_atendimento, 'HH24:mi:ss'),
         'DD/MM/YYYY HH24:MI:SS') DH_ATENDIMENTO,
 rf.dt_inicio,
 rf.dt_final,
 case
   when ate.DT_ALTA is not null then
    TO_DATE(TO_CHAR(ate.DT_ALTA, 'DD/MM/YYYY') || ' ' ||
            to_char(ate.hr_alta, 'HH24:mi:ss'),
            'DD/MM/YYYY HH24:MI:SS')
   else
    null
 end DH_ALTA,
 TO_date(to_char(irf.dt_lancamento, 'dd/mm/yyyy') || ' ' ||
         to_char(irf.hr_lancamento, 'HH24:mi:ss'),
         'DD/MM/YYYY HH24:MI:SS') DH_LANCAMENTO,
 case
   when gf.tp_gru_fat = 'OP' then
    '1'
   ELSE
    '0'
 END SN_opme,
 rf.cd_reg_fat,
 irf.cd_lancamento,
 irf.cd_pro_fat,
 pac.cd_paciente PACIENTE,
 ate.NR_CARTEIRA "NUMERO DA CARTEIRA DO CONVENIO",
 ---------indicadores
 ---------



 case
         when irf.tp_pagamento is null or irf.tp_pagamento = 'P' or
              irf.tp_pagamento = 'F' then
          irf.vl_total_conta
          WHEN irf.tp_mvto = 'Cirurgia' AND irf.tp_pagamento = 'C' THEN     ---corrigido valores
          irf.vl_total_conta
         else
          0
       end vl_total_conta,
 ---------

 --irf.vl_total_conta vl_produzido,
 irf.qt_lancamento qt_produzido,
 null vl_faturado,
 null qt_faturado,
 null vl_faturado_competencia,
 null vl_produzido_a_faturar,
 case
   when rf.cd_remessa is null then
    irf.vl_total_conta
   else
    0
 end saldo_a_faturar,
 rf.cd_remessa,
 NULL remessa_nf,
 null DT_COMPETENCIA,
 null dt_abertura,
 null dt_fechamento,
 null dt_entrega_da_fatura,
 null dt_prevista_para_pgto,
 rf.dt_remessa,
 decode(IRF.SN_PERTENCE_PACOTE, 'S', '1', 'N', '0') SN_PERTENCE_PACOTE, ---ajustador para numero
 aud.qt_lancamento_ant qt_lancamento_ant,
 aud.qt_lancamento qt_lancamento,
 aud.vl_total_conta_ant,
 aud.vl_total_conta,
 aud.cd_motivo_auditoria,
       irf.vl_nota,
            prof.ds_pro_fat,
       gf.ds_gru_Fat,
      
        oc.cd_ord_com,
        oc.vl_unitario,
        oc.vl_total,
        oc.qt_comprada,
        oc.cd_produto,
                VW_GUIA_VALOR.TP_REFERENCIA,
        VW_GUIA_VALOR.VL_UNITARIO_OPME,
        VW_GUIA_VALOR.VL_TAXA_COMERCIALIZACAO,
        VW_GUIA_VALOR.VL_TOTAL_OPME,
    vw_guia_valor.fatura_direto





  from reg_fat rf,
       itreg_fat irf,
       remessa_fatura rfat,
       atendime ate,
       convenio conv,
       pro_fat prof,
       paciente pac,
       gru_fat gf,
       leito le,
       oc,
       vw_guia_valor,
       (select cd_atendimento, cd_guia, guia.nr_guia, guia.cd_senha
          from guia
         where guia.tp_guia = 'I') gui,
       ( ---------auditoria
        SELECT cd_reg_fat || cd_pro_fat || cd_lancamento_fat codigo,
                cd_atendimento,
                cd_reg_Fat,
                cd_pro_fat,
                cd_lancamento_fat,
                dt_auditoria,
                auditoria_conta.qt_lancamento_ant,
                auditoria_conta.qt_lancamento,
                auditoria_conta.vl_total_conta_ant,
                auditoria_conta.vl_total_conta,
                motivo_auditoria.cd_motivo_auditoria
          from AUDITORIA_CONTA,
                motivo_auditoria,
                (select cd_reg_fat || cd_lancamento_fat || cd_pro_fat codigo,
                        max(cd_auditoria_conta) cd_auditoria_conta
                   from AUDITORIA_CONTA
                  group by cd_reg_fat, cd_lancamento_fat, cd_pro_fat) aud
         where auditoria_conta.cd_motivo_auditoria =
               motivo_auditoria.cd_motivo_auditoria
           and auditoria_conta.cd_reg_fat || cd_lancamento_fat || cd_pro_fat =
               aud.codigo
           and auditoria_conta.cd_auditoria_conta = aud.cd_auditoria_conta
         order by cd_atendimento, cd_reg_fat, cd_lancamento_fat

        ) aud --------auditoria
 where rf.cd_reg_fat = irf.cd_reg_fat
   and rf.cd_remessa=rfat.cd_remessa (+)
   and rf.cd_atendimento = ate.CD_ATENDIMENTO
   and ate.CD_LEITO = le.cd_leito
   and rf.CD_CONVENIO = conv.cd_convenio
   and irf.cd_pro_fat = prof.cd_pro_fat
   and irf.cd_gru_fat = gf.cd_gru_fat
   and ate.CD_PACIENTE = pac.cd_paciente
   and ate.CD_ATENDIMENTO = gui.cd_atendimento(+)
   and rf.cd_remessa is NULL
   and irf.cd_reg_fat || irf.cd_pro_fat || irf.cd_lancamento =
       aud.codigo(+)
  AND irf.cd_gru_fat IN (5,9)
    AND oc.cd_atendimento(+) = rf.cd_Atendimento
  AND oc.cd_pro_fat(+) = prof.cd_pro_fat
    AND vw_guia_valor.cd_guia(+) = gui.cd_guia
  AND vw_guia_valor.cd_pro_fat(+) = prof.cd_pro_fat
 AND  To_Date(To_Char(irf.dt_lancamento,'dd/mm/yyyy'),'dd/mm/yyyy') > = to_date('01/10/2023','DD/MM/RRRR')     --trunc(sysdate)-365     
--and ate.cd_atendimento = 5543023
