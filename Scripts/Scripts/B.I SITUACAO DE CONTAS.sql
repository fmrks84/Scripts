SELECT 
CD_ATENDIMENTO
,DECODE(TP_ATENDIMENTO,'I','INTERNACAO','U','URGENCIA') TP_ATENDIMENTO
,CONTA
,CD_CON_REC
,DT_ATENDIMENTO
,DT_ALTA
,NM_PACIENTE
,NM_CONVENIO
,DS_LEITO
,CD_REMESSA
,SN_FECHADA
,DECODE (TP_QUITACAO, 'C','COMPROMETIDO', 
                      'V','PREVISTO', 
                      'P','PARCIAL PAGA', 
                      'Q','QUITADO', 
                      'N','CANCELADO', 
                      'T','LIQUID TOT DEVOL',
                      'L','LIQUID PARC DEVOL')TP_QUITACAO 
,VL_DUPLICATA 
,NM_USUARIO_FECHOU
,nm_usuario
,DS_OBSERVACAO
,max (dt_envio)DT_ENVIO  
,cd_protocolo_doc
,dt_recebimento dt_Receb_prot
,nm_usuario_recebimento nm_usuario_Financ

FROM
(
SELECT REG_FAT . CD_ATENDIMENTO,
 ATENDIME . TP_ATENDIMENTO,
 ATENDIME . CD_PACIENTE,
 REG_FAT . CD_REG_FAT CONTA,
 ITREG_FAT . CD_LANCAMENTO,
 ATENDIME . DT_ATENDIMENTO,
 ATENDIME . DT_ALTA,
 ATENDIME . CD_LEITO,
 REG_FAT . CD_CONVENIO CD_CONVENIO,
 PACIENTE . NM_PACIENTE,
 CONVENIO . NM_CONVENIO,
 LEITO . DS_LEITO,
 UNID_INT . CD_UNID_INT,
 nvl(UNID_INT . DS_UNID_INT, ori_ate . ds_ori_ate) DS_UNID_INT,
 REG_FAT . DT_INICIO DT_INICIO,
 REG_FAT . DT_FINAL DT_FINAL,
 REG_FAT . CD_REMESSA,
 DECODE(NVL(REG_FAT . SN_FECHADA, 'N'), 'S', 'SIM', 'N�O') SN_FECHADA,
 DECODE(NVL(REMESSA_FATURA . SN_PAGA, 'N'), 'S', 'SIM', 'N�O') SN_PAGA,
 REMESSA_FATURA . DT_ABERTURA,
 REMESSA_FATURA . DT_FECHAMENTO,
 NVL (ITCON_REC . VL_DUPLICATA,0) VL_DUPLICATA ,
 REG_FAT.NM_USUARIO_FECHOU, 
 ITCON_REC.TP_QUITACAO, 
 CON_REC . CD_CON_REC,
 A.DS_OBSERVACAO ,
 i.dt_envio,
 h.dt_recebimento,
 h.nm_usuario_recebimento nm_usuario_recebimento ,
 i.cd_protocolo_doc,
 a.nm_usuario


 
 FROM DBAMV . ATENDIME,
 DBAMV . REG_FAT,
 DBAMV . ITREG_FAT,
 DBAMV . PRO_FAT,
 DBAMV . CONVENIO,
 DBAMV . PACIENTE,
 DBAMV . LEITO,
 DBAMV . UNID_INT,
 DBAMV . REMESSA_FATURA,
 DBAMV . CON_REC,
 DBAMV . ITCON_REC, 
 DBAMV . EMPRESA_CONVENIO,
 DBAMV . ORI_ATE,
 dbasgu.usuarios a,  
 dbamv.documento_prot g,  
 dbamv.it_protocolo_doc h,
 dbamv.protocolo_doc  i  
 
 
 
 WHERE EMPRESA_CONVENIO.CD_CONVENIO = CONVENIO.CD_CONVENIO
 AND EMPRESA_CONVENIO.CD_MULTI_EMPRESA IN ($GEmpresaMV2000$) 
 AND ATENDIME.CD_MULTI_EMPRESA =
 NVL(($GEmpresaMV2000$), ATENDIME.CD_MULTI_EMPRESA)
 AND ATENDIME.CD_ATENDIMENTO = REG_FAT.CD_ATENDIMENTO
 AND CONVENIO.TP_CONVENIO <> 'H'
 AND REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO
 AND CON_REC.CD_CON_REC = ITCON_REC.CD_CON_REC 
 AND REG_FAT.CD_MULTI_EMPRESA IN ($GEmpresaMV2000$)
 AND REG_FAT.CD_CONVENIO = CONVENIO.CD_CONVENIO
 AND REG_FAT.CD_REMESSA = REMESSA_FATURA.CD_REMESSA(+)
 AND REG_FAT.CD_REG_FAT = CON_REC.CD_REG_FAT(+)
 AND REG_FAT.CD_REG_FAT = ITREG_FAT.CD_REG_FAT
 AND ITREG_FAT.CD_PRO_FAT = PRO_FAT.Cd_Pro_Fat
 AND NVL(ITREG_FAT.SN_PERTENCE_PACOTE, 'N') <> 'S'
 AND ((CON_REC.CD_PREVISAO IS NULL AND CONVENIO.TP_CONVENIO = 'P') OR
 CONVENIO.TP_CONVENIO <> 'P')
 AND ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE
 AND ATENDIME.CD_LEITO = LEITO.CD_LEITO(+)
 AND ATENDIME.CD_ORI_ATE = ORI_ATE.CD_ORI_ATE
 AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT(+)
 AND NVL(ATENDIME.CD_ATENDIMENTO_PAI, 0) NOT IN
 (SELECT ATENDIME_PAI.CD_ATENDIMENTO
 FROM DBAMV.ATENDIME ATENDIME_PAI
 WHERE NVL(ATENDIME_PAI.QT_SESSOES, 0) > 0)
 AND TRUNC(ATENDIME.DT_ATENDIMENTO) BETWEEN $GDtini$ AND $GDtfim$  
 AND (CONVENIO.TP_CONVENIO = 'P' AND
 (CON_REC.CD_REG_FAT IS NULL OR EXISTS
 (SELECT 1
 FROM DBAMV.ITCON_REC
 WHERE ITCON_REC.CD_CON_REC = CON_REC.CD_CON_REC
 AND ITCON_REC.TP_QUITACAO NOT IN ('Q', 'L', 'G'))))
 and convenio.tp_convenio = 'P'
 and REG_FAT . VL_TOTAL_CONTA >0
 and a.cd_usuario = REG_FAT.NM_USUARIO_FECHOU  
 and h.cd_documento_prot = g.cd_documento_prot
 and i.cd_protocolo_doc = h.cd_protocolo_doc
 and atendime.CD_ATENDIMENTO = h.cd_atendimento
 and g.cd_documento_prot = 59
 and a.cd_usuario = REG_FAT.NM_USUARIO_FECHOU
 


UNION ALL

SELECT DISTINCT ITREG_AMB . CD_ATENDIMENTO,
 ATENDIME . TP_ATENDIMENTO,
 ATENDIME . CD_PACIENTE,
 ITREG_AMB . CD_REG_AMB CONTA,
 ITREG_AMB . CD_LANCAMENTO,
 ATENDIME . DT_ATENDIMENTO,
 NVL(ATENDIME . DT_ALTA, ATENDIME . DT_ATENDIMENTO) DT_ALTA,
 ATENDIME . CD_LEITO,
 REG_AMB . CD_CONVENIO CD_CONVENIO,
 PACIENTE . NM_PACIENTE,
 CONVENIO . NM_CONVENIO,
 LEITO . DS_LEITO,
 UNID_INT . CD_UNID_INT,
 NVL(UNID_INT . DS_UNID_INT, ori_ate . ds_ori_ate) DS_UNID_INT,
 ATENDIME . DT_ATENDIMENTO DT_INICIO,
 ATENDIME . DT_ATENDIMENTO DT_FINAL,
 REG_AMB . CD_REMESSA,
 DECODE(NVL(ITREG_AMB . SN_FECHADA, 'N'), 'S', 'SIM', 'N�O') SN_FECHADA,
 DECODE(NVL(REMESSA_FATURA . SN_PAGA, 'N'),
 'S',
 'SIM',
 'N�O') SN_PAGA,
 REMESSA_FATURA . DT_ABERTURA,
 REMESSA_FATURA . DT_FECHAMENTO,
 NVL (ITCON_REC . VL_DUPLICATA,0) VL_DUPLICATA, 
 ITREG_AMB . NM_USUARIO_FECHOU, 
 ITCON_REC.TP_QUITACAO,
 CON_REC . CD_CON_REC,
 b.ds_observacao, 
 e.dt_envio,
 D.DT_RECEBIMENTO,  
 D.NM_USUARIO_RECEBIMENTO nm_usuario_recebimento, 
 e.cd_protocolo_doc,
 b.nm_usuario

 
 FROM DBAMV . ATENDIME,
 DBAMV. REG_AMB,
 DBAMV.ITREG_AMB,
 DBAMV . PRO_FAT,
 DBAMV . CONVENIO,
 DBAMV . PACIENTE,
 DBAMV . LEITO,
 DBAMV . UNID_INT,
 DBAMV . REMESSA_FATURA,
 DBAMV . CON_REC,
 DBAMV . ITCON_REC,
 DBAMV . EMPRESA_CONVENIO,
 DBAMV . ORI_ATE,
 dbasgu.usuarios b, 
 dbamv.documento_prot c, 
 dbamv.it_protocolo_doc d , 
 dbamv.protocolo_doc  e 
 
 
 WHERE EMPRESA_CONVENIO.CD_CONVENIO = CONVENIO.CD_CONVENIO
 AND EMPRESA_CONVENIO.CD_MULTI_EMPRESA IN ($GEmpresaMV2000$) 
 AND ATENDIME.CD_MULTI_EMPRESA = NVL(($GEmpresaMV2000$), ATENDIME.CD_MULTI_EMPRESA)
 AND ATENDIME.CD_ATENDIMENTO = ITREG_AMB.CD_ATENDIMENTO
 AND ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE
 AND ATENDIME.CD_LEITO = LEITO.CD_LEITO(+)
 AND LEITO.CD_UNID_INT = UNID_INT.CD_UNID_INT(+)
 AND ITREG_AMB.CD_REG_AMB = REG_AMB.CD_REG_AMB
 AND REG_AMB.CD_REMESSA = REMESSA_FATURA.CD_REMESSA(+)
 AND REG_AMB.CD_REG_AMB = CON_REC.CD_REG_AMB(+)
 AND ((CON_REC.CD_PREVISAO IS NULL AND CONVENIO.TP_CONVENIO = 'P') OR
 CONVENIO.TP_CONVENIO <> 'P')
 AND REG_AMB.CD_CONVENIO = CONVENIO.CD_CONVENIO
 AND CON_REC.CD_CON_REC = ITCON_REC.CD_CON_REC 
 AND CONVENIO.TP_CONVENIO <> 'H'
 AND NVL(ITREG_AMB.SN_PERTENCE_PACOTE, 'N') <> 'S'
 AND NVL(ATENDIME.CD_ATENDIMENTO_PAI, 0) NOT IN
 (SELECT ATENDIME_PAI.CD_ATENDIMENTO
 FROM DBAMV.ATENDIME ATENDIME_PAI
 WHERE NVL(ATENDIME_PAI.QT_SESSOES, 0) > 0)
 and atendime.cd_ori_ate = ori_ate.cd_ori_ate
 AND TRUNC(ATENDIME.DT_ATENDIMENTO) BETWEEN $GDtini$ AND $GDtfim$ 
 AND (CONVENIO.TP_CONVENIO = 'P' AND
 (CON_REC.CD_REG_AMB IS NULL OR EXISTS
 (SELECT 1
 FROM DBAMV.ITCON_REC
 WHERE ITCON_REC.CD_CON_REC = CON_REC.CD_CON_REC
  AND ITCON_REC.TP_QUITACAO NOT IN ('Q', 'L', 'G'))))
 and convenio.tp_convenio = 'P'
 and REG_amb . VL_TOTAL_CONTA >0
 and b.cd_usuario = ITREG_AMB . NM_USUARIO_FECHOU  
 and d.cd_documento_prot = c.cd_documento_prot    
 and e.cd_protocolo_doc = d.cd_protocolo_doc       
 and atendime.CD_ATENDIMENTO = d.cd_atendimento    
 and c.cd_documento_prot = 59
 and b.cd_usuario = ITREG_AMB . NM_USUARIO_FECHOU
 ORDER BY 
 cd_convenio,
 nm_paciente
)

GROUP BY
CD_ATENDIMENTO
,TP_ATENDIMENTO
,CD_PACIENTE
,CONTA
,DT_ATENDIMENTO
,DT_ALTA
,CD_CONVENIO
,NM_PACIENTE
,NM_CONVENIO
,DS_LEITO
,CD_UNID_INT
,DT_INICIO
,DT_FINAL
,CD_REMESSA
,SN_FECHADA
,DT_ABERTURA
,DT_FECHAMENTO
,NM_USUARIO_FECHOU
,nm_usuario_recebimento
,nm_usuario
,DS_OBSERVACAO
,TP_QUITACAO
,VL_DUPLICATA
,CD_CON_REC
,dt_envio
,dt_recebimento  
,nm_usuario_recebimento 
,cd_protocolo_doc --
ORDER BY DT_ATENDIMENTO
-- DT_ABERTURA 

---- atendimento teste 1530117 

/*select *
from dbamv.documento_prot g
inner join dbamv.it_protocolo_doc h on h.cd_documento_prot = g.cd_documento_prot
inner join dbamv.protocolo_doc  i on i.cd_protocolo_doc = h.cd_protocolo_doc
inner join dbamv.atendime l on l.CD_ATENDIMENTO = h.cd_atendimento
where h.cd_atendimento = 1517617
and  g.cd_documento_prot = 59*/
