WITH REG_CONV AS (
SELECT
CONV.CD_CONVENIO,
CPLA.CD_CON_PLA,
CPLA.CD_REGRA,
PF.CD_PRO_FAT,
IRG.CD_GRU_PRO,
IRG.CD_TAB_FAT,
ISP.CD_SIMPRO
FROM 
CONVENIO CONV 
INNER JOIN EMPRESA_CONVENIO ECONV ON ECONV.CD_CONVENIO = CONV.CD_CONVENIO
INNER JOIN CON_PLA CPLA ON CPLA.CD_CONVENIO = ECONV.CD_CONVENIO 
INNER JOIN REGRA RG ON RG.CD_REGRA = CPLA.CD_REGRA
INNER JOIN ITREGRA IRG ON IRG.CD_REGRA = RG.CD_REGRA 
INNER JOIN PRO_FAT PF ON PF.CD_GRU_PRO = IRG.CD_GRU_PRO
INNER JOIN IMP_SIMPRO ISP ON ISP.CD_PRO_FAT = PF.CD_PRO_FAT 
AND ISP.CD_TAB_FAT = IRG.CD_TAB_FAT
WHERE PF.SN_ATIVO = 'S'
AND CONV.TP_CONVENIO = 'C' 
--AND CONV.CD_CONVENIO = 41
AND IRG.CD_TAB_FAT IN (2)--,525,689,871,3433)
--ORDER BY CPLA.CD_CON_PLA
)

(

SELECT 
AV.CD_AVISO_CIRURGIA,
AVCIR.CD_CONVENIO,
AVCIR.CD_CON_PLA,
(SELECT X.DS_PRO_FAT FROM PRO_FAT X WHERE X.CD_PRO_FAT = CIR.CD_PRO_FAT)NM_CIRURGIA,
DECODE(AV.TP_CIRURGIAS,'E','ELETIVA','M','EMERGENCIA','U','URGENCIA')TIPO_CIRURGIA,
TRUNC(AV.DT_PREV_INTER),
AV.CD_ATENDIMENTO,
AV.CD_PACIENTE,
AV.NM_PACIENTE,
CONV.LOGOTIPO LOGO_OPERADORA,
G.CD_CONVENIO,
CONV.NM_CONVENIO,
AV.NR_CARTEIRA,
VOP.CD_FORNECEDOR,
FNC.NM_FORNECEDOR,
FAB.NM_LABORATOR,
IG.CD_PRO_FAT,
fc_ovmd_tuss(AV.CD_MULTI_EMPRESA,IG.CD_PRO_FAT,G.CD_CONVENIO,'COD')TUSS,
fc_ovmd_tuss(AV.CD_MULTI_EMPRESA,IG.CD_PRO_FAT,G.CD_CONVENIO,'DESC')DS_TUSS,
VOP.DT_VIGENCIA,
VOP.CD_RMS,
VOP.DT_VALIDADE_REGISTRO,
IG.QT_AUTORIZADO,
VOP.VL_UNITARIO,
VOP.VL_REFERENCIA,
VOP.VL_TAXA_COMERCIALIZACAO,
VOP.VL_PROPOSTO,
VOP.VL_TOTAL_AUTORIZADO,
SPRO.CD_SIMPRO

FROM 
GUIA G 
INNER JOIN IT_GUIA IG ON IG.CD_GUIA = G.CD_GUIA
INNER JOIN AVISO_CIRURGIA AV ON AV.CD_AVISO_CIRURGIA = G.CD_AVISO_CIRURGIA
INNER JOIN VAL_OPME_IT_GUIA VOP ON VOP.CD_IT_GUIA = IG.CD_IT_GUIA AND VOP.CD_GUIA = IG.CD_GUIA
INNER JOIN FORNECEDOR FNC ON FNC.CD_FORNECEDOR = VOP.CD_FORNECEDOR
LEFT JOIN PACIENTE PC ON PC.CD_PACIENTE = AV.CD_PACIENTE
LEFT JOIN ATENDIME ATEND ON ATEND.CD_ATENDIMENTO = AV.CD_ATENDIMENTO
INNER JOIN CONVENIO CONV ON CONV.CD_CONVENIO = G.CD_CONVENIO
INNER JOIN PRO_FAT PF ON PF.CD_PRO_FAT = IG.CD_PRO_FAT
LEFT JOIN LABORATOR FAB ON FAB.CD_LABORATOR = VOP.CD_LABORATOR
LEFT JOIN IMP_SIMPRO SIMP ON SIMP.CD_PRO_FAT = IG.CD_PRO_FAT 
INNER JOIN CIRURGIA_AVISO AVCIR ON AVCIR.CD_AVISO_CIRURGIA = AV.CD_AVISO_CIRURGIA
INNER JOIN CIRURGIA CIR ON CIR.CD_CIRURGIA = AVCIR.CD_CIRURGIA
LEFT JOIN REG_CONV SPRO ON SPRO.CD_CONVENIO = G.CD_CONVENIO 
AND SPRO.CD_CON_PLA = AVCIR.CD_CON_PLA 
AND SPRO.CD_PRO_FAT = IG.CD_PRO_FAT 
AND SPRO.CD_GRU_PRO = PF.CD_GRU_PRO
WHERE G.Cd_Aviso_Cirurgia = 348280
AND G.TP_GUIA = 'O'
AND IG.CD_PRO_FAT IS NOT NULL
)


select pd.cd_produto ,  pf.cd_pro_fat, pf.ds_pro_fat, gp.cd_gru_pro , pf.sn_opme
from pro_fat pf 
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto empx on empx.cd_produto = pd.cd_produto and empx.cd_multi_empresa = 7
where pf.cd_gru_pro = 89 
or gp.tp_gru_pro = 'OP'
and pf.sn_opme = 'S'
and pf.sn_ativo = 'S'
and pd.sn_consignado = 'S'
and pd.sn_movimentacao = 'S'

71075585,71075275,70239070

select cd_produto,cd_pro_fat, ds_produto from produto where cd_pro_fat in (09040348,09087074)
--SELECT * FROM TUSS X WHERE X.CD_PRO_FAT = '09055714'
--SELECT * FROM TIP_TUSS 
--SELECT DISTINCT(CD_tAB_FAT) FROM IMP_SIMPRO 
/*

SELECT  FROM IMP_SIMPRO A
INNER JOIN TAB_FAT B ON B.CD_TAB_FAT = A.CD_TAB_FAT*/
/*;
select cd_produto,cd_pro_fat, ds_produto from produto where cd_pro_fat in (09040348,09087074)

select * from Faixa_Guia_Convenio  where cd_convenio = 41
select * from item_faixa_guia_convenio where cd_faixa_Guia in (select cd_Faixa_guia from Faixa_Guia_Convenio  where cd_convenio = 41)
and cd_faixa_guia = 1139
and nr_guia is not null


select * from aviso_cirurgia where cd_aviso_cirurgia = 352227


--WITH SIMP AS (
SELECT
CONV.CD_CONVENIO,
CPLA.CD_CON_PLA,
CPLA.CD_REGRA,
PF.CD_PRO_FAT,
IRG.CD_GRU_PRO,
IRG.CD_TAB_FAT,
ISP.CD_SIMPRO
FROM 
CONVENIO CONV 
INNER JOIN EMPRESA_CONVENIO ECONV ON ECONV.CD_CONVENIO = CONV.CD_CONVENIO
INNER JOIN CON_PLA CPLA ON CPLA.CD_CONVENIO = ECONV.CD_CONVENIO 
INNER JOIN REGRA RG ON RG.CD_REGRA = CPLA.CD_REGRA
INNER JOIN ITREGRA IRG ON IRG.CD_REGRA = RG.CD_REGRA 
INNER JOIN PRO_FAT PF ON PF.CD_GRU_PRO = IRG.CD_GRU_PRO
INNER JOIN IMP_SIMPRO ISP ON ISP.CD_PRO_FAT = PF.CD_PRO_FAT 
AND ISP.CD_TAB_FAT = IRG.CD_TAB_FAT
WHERE PF.SN_ATIVO = 'S'
AND CONV.TP_CONVENIO = 'C' 
AND CONV.CD_CONVENIO = 7
AND PF.CD_PRO_FAT = '70655952'
AND IRG.CD_TAB_FAT IN (2,525,689,871,3433)
--)
;


--SELECT * FROM PRODUTO WHERE CD_PRO_FAT = 70655952

/*;
SELECT 
IG.CD_PRO_FAT,
X.CD_SIMPRO
FROM 
IT_GUIA IG 
INNER JOIN SIMP X ON X.CD_PRO_FAT = IG.CD_PRO_FAT
WHERE IG.CD_GUIA IN (4667715,4801948,4804674)

*/

select distinct pd.cd_produto ,  pf.cd_pro_fat, pf.ds_pro_fat, gp.cd_gru_pro , pf.sn_opme
from pro_fat pf 
inner join gru_pro gp on gp.cd_gru_pro = pf.cd_gru_pro
inner join produto pd on pd.cd_pro_fat = pf.cd_pro_fat
inner join empresa_produto epd on epd.cd_produto = pd.cd_produto
where pf.cd_gru_pro = 89 
or gp.tp_gru_pro = 'OP'
and epd.cd_multi_empresa = 7
and pf.sn_opme = 'S'
and pf.sn_ativo = 'S'
and pd.cd_produto in (2702)

select * from empresa_produto where cd_produto in (2702,1050)and cd_multi_empresa = 7
select cd_produto,ds_produto, cd_pro_fat from produto where cd_produto in (1293,2081,3070,3712)
select * from pro_Fat where cd_pro_Fat in ('70238898','70127824')


-- aviso 348267
2702	70127824	CATETER DIAG TEMPO RS 05FX080CM CORDIS REF.451546S0	
1050	70238898	BROCA CONICA 10CMX1.7MM MEDTRONIC REF.10MH17	
--- aviso 348274
101048	00327546	LAMINA DE SERRA RECIPROCANTE L-A-DAA TRAUMEC REF.PA02030895	
101052	09101052	PARAFUSO COMPR CAN PG CURTO D7.0-55X16MM RAZEK REF.500070400	


-- 1� transf para cotacao
-- 2� aguarda retorno cotacao
---- rodar quando passar para fazee aguardando retorno da cota��o opme 
BEGIN 
  PKG_MV2000.Atribui_Empresa(7);
  END;
select * from produto where cd_produto = 1050 for update 

mvintegra.PRC_IMVW_OUT_AVISO_BAIX_JOB;
end;


select '348267'aviso,cd_produto, ds_produto from produto where cd_produto in (2702,1050);
select '348274'aviso,cd_produto, ds_produto from produto where cd_produto in (101048,101052)

select * from cirurgia_aviso where cd_aviso_cirurgia = 348277
select * from aviso_cirurgia where cd_aviso_cirurgia = 348277
select * from prestador_aviso where cd_aviso_cirurgia = 348277
select * from cirurgia where cd_cirurgia = 662
--
select * from guia where cd_aviso_cirurgia = 348276 and tp_guia = 'O'
select * from  reg_fat where cd_multi_empresa = 7 and cd_reg_Fat in (
select cd_Reg_Fat from itreg_Fat where cd_pro_Fat = '80071059')--'82010536' )
--GROUP BY CD_REG_FAT



--select * from  reg_fat where cd_multi_empresa = 7 and cd_reg_Fat in (
select count(*),cd_setor  from itreg_Fat where cd_pro_Fat IN (select cd_pro_fat from pro_fat where cd_gru_pro = 14 and sn_ativo = 'S')and cd_reg_fat in
 (select cd_REg_fat from  reg_fat where cd_multi_empresa = 7 )
 group by cd_setor
 order by 1 desc 



select * from setor where cd_setor = 793
select * pro_Fat 

select * from itreg_Fat where cd_reg_Fat = 529009 and cd_pro_fat = 81091869
 

select cd_produto,ds_produto,cd_pro_Fat from produto where cd_produto in (1050,2702,40348)--cd_pro_Fat in (70058164,70908230)
 --348280


---- faixa de valores quando for faturamento direto 
select  
distinct
l.cd_reg_fat,
u.cd_produto,
pf.cd_pro_fat,
u.dt_gravacao,
e.dt_mvto_estoque,
e.hr_mvto_estoque,
vop.cd_guia,
vop.vl_total
from  itmvto_estoque u 
inner join mvto_estoque e on e.cd_mvto_estoque = u.cd_mvto_estoque 
inner join log_falha_importacao l on l.cd_mvto_falha = e.cd_mvto_estoque 
inner join produto pd on pd.cd_produto = u.cd_produto
inner join pro_fat pf on pf.cd_pro_fat = pd.cd_pro_fat
inner join guia g on g.cd_atendimento = e.cd_atendimento and g.tp_guia = 'O'
inner join it_guia ig on ig.cd_guia = g.cd_guia and ig.cd_pro_fat = pf.cd_pro_fat
inner join val_opme_it_guia vop on vop.cd_it_guia = ig.cd_it_guia and vop.cd_guia = g.cd_guia
and l.cd_atendimento = e.cd_atendimento
where e.cd_atendimento = 4782873


select unt.cd_setor
from atendime atd 
inner join leito lt on lt.cd_leito = atd.cd_leito 
inner join unid_int unt on unt.cd_unid_int = lt.cd_unid_int
where atd.cd_atendimento = 4782887

select * from tiss_guia ts where ts.Cd_Atendimento = 4782887

 70239070, 71075585, 70239061, 71075275, 30101972
