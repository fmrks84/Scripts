-------------  ( ALTERACAO DATA DE ENTREGA E VENCIMENTO DA REMESSA )------
 
 
---- ###   PARA DESCOBRIR SE A REMESSA JA ESTEJA NA NOTA FISCAL ###---------
SELECT IFNF.CD_REMESSA, NF.CD_NOTA_FISCAL,NF.NR_ID_NOTA_FISCAL , VA.VCTO
FROM DBAMV.ITFAT_NOTA_FISCAL IFNF
INNER JOIN DBAMV.NOTA_FISCAL NF ON NF.CD_NOTA_FISCAL = IFNF.CD_NOTA_FISCAL
LEFT OUTER JOIN DBAMV.HNB_SNAP_SALDO_REC_VENC_ANAL VA ON VA.NF LIKE NF.NR_ID_NOTA_FISCAL
--where nf.nr_id_nota_fiscal = 812497
WHERE IFNF.CD_REMESSA IN (
506544,506543  --informar remessa
        
)
GROUP BY IFNF.CD_REMESSA, NF.CD_NOTA_FISCAL,NF.NR_ID_NOTA_FISCAL ,VA.VCTO
 
 
---- ###   VERIFICAR E CORRIGIR TAMBÉM A DATA VENCIMENTO NA TABALA SNAP_VALOR CASO JÁ ESTAVA GERADA  ###---------
 
SELECT ROWID,VA.* FROM dbamv.HNB_SNAP_SALDO_REC_VENC_ANAL va Where va.nf IN ( --= '823169' --,'807517')  --820728
--UPDATE dbamv.HNB_SNAP_SALDO_REC_VENC_ANAL va SET VA.VCTO = '17/10/2021', va.outubro = setembro  Where va.nf = '836605'
'731968'
) 
 
 
SELECT ROWID,RF.DT_ABERTURA,RF.DT_ENTREGA_DA_FATURA,RF.DT_PREVISTA_PARA_PGTO,RF.CD_REMESSA,rf.Cd_Con_Rec
FROM DBAMV.REMESSA_FATURA RF WHERE RF.CD_REMESSA in (
update dbamv.remessa_fatura rf set rf.dt_entrega_da_fatura = '22/07/2022' , rf.dt_prevista_para_pgto = '24/09/2022' where rf.cd_remessa in (
-- update dbamv.remessa_fatura rf set rf.dt_prevista_para_pgto = '23/04/2021' where rf.cd_remessa in (
504732,503086
  )
 
 
select rowid,icr.* from dbamv.itcon_rec icr where icr.cd_con_rec in (
-- Update dbamv.itcon_rec icr set icr.dt_prevista_recebimento = '11/10/2021' , icr.dt_vencimento = '11/10/2021' where icr.cd_con_rec in (
1130451
 
)
