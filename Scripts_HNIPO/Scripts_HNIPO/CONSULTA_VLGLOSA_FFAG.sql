select 
sum(vl_glosa_ffag)
from
(
SELECT CD_EMPRESA,
       CD_CONTA_FFCV,
       CD_ATENDIMENTO,
       CD_CONVENIO,
       CD_REMESSA,
       NR_DOCUMENTO,
       SN_DETALHADO,
       CD_NOTA_FISCAL,
       CD_CON_REC,
       CD_ITCON_REC,
       CD_PACIENTE,
       NM_PACIENTE,
       SUM_VL_TOTAL_CONTA,
       TP_CONTA,
       VL_GLOSA_FFAG,
       CD_CON_PLA,
       NR_GUIA_ENVIO_PRINCIPAL,
       nr_remessa_convenio,
       STATUS,
       CD_PRO_INT_PROCEDIMENTO_ENTRAD,
       DT_ENTREGA_DA_FATURA
  FROM dbamv.V_CONSULTA_CONTAS_PACIENTE
 WHERE CD_EMPRESA = 1
   AND (sn_recebimento = 'S' OR sn_detalhado = 'N')
   and nr_documento = '845909'
 order by nm_paciente
)

---235081
