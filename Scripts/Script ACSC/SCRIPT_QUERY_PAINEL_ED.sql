SELECT
cd_convenio,
nm_convenio,
cd_ord_com,
dt_ord_com,
cast (nome as varchar2(2000))nome,
dt_mvto,
cd_mvto,
cd_lote,
tp_situacao,
cd_estoque,
cd_condicao_pagamento,
cd_consumo_paciente,
cd_fornecedor,
nm_fornecedor,
ds_ordem_de_compra,
cd_produto,
ds_produto,
qt_ord_com,
vl_compra,
cd_atendimento,
cd_aviso_cirurgia,
qt_consumo,
conta,
cd_pro_fat,
sn_fechada,
cd_remessa,
cd_remessa,
dt_abertura,
dt_fechamento,
competencia,
rps,
emissao_nf,      
CASE
    WHEN sn_remessa IS NULL
    THEN 'N'
    ELSE 'S'
END sn_remessa,
qt_lancamento,
vl_unitario,
qt_guia,
vl_unitario_guia,
vl_proposto_guia,
vl_total_autorizado_guia,
ds_multi_empresa,
ds_motivo_auditoria,
acompanhamento

FROM (

with

vw_ordem_compra_aberta as
            (
            select
                    oc.cd_ord_com,
                    oc.dt_ord_com,
                    oc.tp_situacao,
                    oc.cd_estoque,
                    oc.cd_condicao_pagamento,
                    oc.cd_consumo_paciente,
                    fornecedor.cd_fornecedor,
                    fornecedor.nm_fornecedor,
                    oc.ds_ordem_de_compra,
                    nvl(REPLACE(substr(oc.ds_ordem_de_compra,instr(oc.ds_ordem_de_compra,'#',1,1)+1,(instr(oc.ds_ordem_de_compra,'#',1,2)-instr(oc.ds_ordem_de_compra,'#',1,1))-1),' ',''),'SEMTRATAMENTO') as ACOMPANHAMENTO,
                    itord.cd_produto,
                    p.ds_produto,
                    itord.qt_comprada qt_ord_com,
                    itord.vl_unitario as vl_compra,
                    p.cd_pro_fat

            from dbamv.ord_com oc,
                 dbamv.itord_pro itord,
                 dbamv.produto p,
                 dbamv.fornecedor

            where oc.cd_ord_com = itord.cd_ord_com
            and oc.cd_fornecedor = fornecedor.cd_fornecedor
            and itord.cd_produto = p.cd_produto
            and trunc(oc.dt_ord_com) BETWEEN Trunc(SYSDATE) -30 AND Trunc(SYSDATE) --(Select Trunc(Add_Months(SYSDATE,-1),'MM') FROM DUAL)
            ),

consumo_pac as
            (
            select cp.cd_consumo_paciente,
                   cp.cd_atendimento,
                   cp.cd_aviso_cirurgia,
                   itcons.cd_produto,
                   produto.cd_pro_fat,
                   sum(itcons.QT_CONSUMO) QT_CONSUMO

            from dbamv.consumo_paciente cp
            inner join dbamv.itconsumo_paciente itcons on cp.cd_consumo_paciente = itcons.cd_consumo_paciente
            inner join dbamv.produto on itcons.cd_produto = produto.cd_produto
            inner join (select cd_consumo_paciente, cd_produto
                        from vw_ordem_compra_aberta
                        group by cd_consumo_paciente, cd_produto) v on itcons.cd_consumo_paciente = v.cd_consumo_paciente and v.cd_produto = itcons.cd_produto
            group by cp.cd_consumo_paciente, cp.cd_atendimento, cp.cd_aviso_cirurgia, itcons.cd_produto, produto.cd_pro_fat
            ),

vw_conta_paciente as
            (
            select
            a.cd_atendimento,
            it.cd_mvto, rf.cd_reg_fat conta, rf.sn_fechada,
            it.cd_pro_fat, rf.cd_remessa,
            --decode(nvl(rf.cd_remessa, 0),0,0,1) as sn_remessa,
            rf.cd_remessa as sn_remessa,
            sum (it.qt_lancamento) qt_lancamento, it.vl_unitario
            from dbamv.reg_fat rf, dbamv.itreg_fat it, dbamv.atendime a,
                (select cd_atendimento, cd_pro_fat from consumo_pac group by cd_atendimento, cd_pro_fat) atend
            where rf.cd_reg_fat = it.cd_reg_fat
            and rf.cd_atendimento = a.cd_atendimento
            and atend.cd_atendimento = a.cd_atendimento
            and atend.cd_pro_fat = it.cd_pro_fat
            and it.cd_gru_fat in (5,9)
            group by a.cd_atendimento, it.cd_mvto, rf.cd_reg_fat, rf.sn_fechada, it.cd_pro_fat, rf.cd_remessa, decode(nvl(rf.cd_remessa, 0),0,0,1), it.vl_unitario

            union all

            select
            a.cd_atendimento,
            it.cd_mvto, rf.cd_reg_amb conta, rf.sn_fechada,
            it.cd_pro_fat, rf.cd_remessa,
            decode(nvl(rf.cd_remessa, 0),0,0,1) as sn_remessa,
            sum (it.qt_lancamento) qt_lancamento, it.vl_unitario
            from dbamv.reg_amb rf,
                 dbamv.itreg_amb it, atendime a,
                (select cd_atendimento, cd_pro_fat from consumo_pac group by cd_atendimento, cd_pro_fat) atend
            where rf.cd_reg_amb = it.cd_reg_amb
            and it.cd_atendimento = a.cd_atendimento
            and atend.cd_atendimento = a.cd_atendimento
            and atend.cd_pro_fat = it.cd_pro_fat
            and it.cd_gru_fat in (5,9)
            group by a.cd_atendimento, it.cd_mvto, rf.cd_reg_amb, rf.sn_fechada, it.cd_pro_fat, rf.cd_remessa, decode(nvl(rf.cd_remessa, 0),0,0,1), it.vl_unitario
            ),

mov_prod as
            (
            select  itmvto_estoque.cd_mvto_estoque,
                    itmvto_estoque.dh_mvto_estoque dt_mvto,
                    itmvto_estoque.cd_lote,
                    itmvto_estoque.cd_mvto_estoque cd_mvto,
                    mvto_estoque.TP_MVTO_ESTOQUE,
                    itmvto_estoque.cd_produto,
                    produto.cd_pro_fat

            from dbamv.mvto_estoque
            inner join dbamv.itmvto_estoque on mvto_estoque.cd_mvto_estoque = itmvto_estoque.cd_mvto_estoque
            inner join dbamv.produto on itmvto_estoque.cd_produto = produto.cd_produto
            inner join (select cd_mvto, cd_pro_fat from vw_conta_paciente group by cd_mvto, cd_pro_fat) v on mvto_estoque.cd_mvto_estoque = v.cd_mvto and v.cd_pro_fat = produto.cd_pro_fat
            ),

vw_guia as
            (
            select
            g.cd_atendimento,
            it.cd_pro_fat,
            g.cd_aviso_cirurgia,
            g.tp_guia,
            sum (it.qt_autorizado) qt_autorizado_guia,
            max (vit.vl_unitario) vl_unitario_guia,
            max (vit.vl_proposto) vl_proposto_guia,
            max (vit.vl_total_autorizado) vl_total_autorizado_guia
            from guia g, it_guia it, atendime a, val_opme_it_guia vit,
                (select cd_atendimento, cd_pro_fat from consumo_pac group by cd_atendimento, cd_pro_fat) atend
            where g.cd_guia = it.cd_guia
            and g.cd_atendimento = a.cd_atendimento
            and atend.cd_atendimento = a.cd_atendimento
            and atend.cd_pro_fat = it.cd_pro_fat
            and it.cd_it_guia = vit.cd_it_guia (+)
            and g.tp_guia = 'O'
            and it.cd_pro_fat is not NULL
            and (a.tp_atendimento =  'I' and g.cd_aviso_cirurgia is not null
             or  a.tp_atendimento <> 'I')

            group by
            g.cd_atendimento,
            it.cd_pro_fat,
            g.cd_aviso_cirurgia,
            g.tp_guia
            ),

MOT_AUDIT AS
(
    SELECT TRUNC(AC.DT_LANCAMENTO) DTLANCAMENTO,
           NVL(AC.CD_REG_FAT,AC.CD_REG_AMB) CONTA,
           AC.CD_ATENDIMENTO,
           AC.CD_PRO_FAT,
           AC.CD_MVTO CD_MVTO_ESTOQUE,
           AC.CD_CONVENIO,
           MA.DS_MOTIVO_AUDITORIA,
           P.CD_PRODUTO

    FROM DBAMV.AUDITORIA_CONTA  AC,
         DBAMV.MOTIVO_AUDITORIA MA,
         DBAMV.PRODUTO          P

    WHERE AC.TP_MVTO = 'Produto'
    AND AC.CD_MOTIVO_AUDITORIA = MA.CD_MOTIVO_AUDITORIA
    AND AC.CD_PRO_FAT = P.CD_PRO_FAT(+)
    AND P.CD_ESPECIE IN (17,19,20)

    UNION ALL

    SELECT TRUNC(LFI.DT_IMPORTACAO) DTLANCAMENTO,
           NVL(LFI.CD_REG_FAT,LFI.CD_REG_AMB) CONTA,
           LFI.CD_ATENDIMENTO,
           LFI.CD_PRO_FAT,
           LFI.CD_MVTO_FALHA CD_MVTO_ESTOQUE,
           NVL(RF.CD_CONVENIO,RA.CD_CONVENIO) CD_CONVENIO,
           LFI.DS_MSG_ERRO DS_MOTIVO_AUDITORIA,
           P.CD_PRODUTO

    FROM DBAMV.LOG_FALHA_IMPORTACAO LFI,
         DBAMV.REG_FAT              RF,
         DBAMV.REG_AMB              RA,
         DBAMV.PRODUTO              P

    WHERE LFI.TP_IMPORTACAO = 'Produto'
    AND LFI.CD_REG_FAT = RF.CD_REG_FAT(+)
    AND LFI.CD_REG_AMB = RA.CD_REG_AMB(+)
    AND LFI.CD_PRO_FAT = P.CD_PRO_FAT(+)
    AND P.CD_ESPECIE IN (17,19,20)
),

REMESSA AS
(
 Select distinct r.cd_remessa,
        r.dt_abertura,
        r.dt_fechamento,
        to_char(f.dt_competencia,'mm/yyyy')competencia,
        nf.nr_id_nota_fiscal rps,
        nf.dt_emissao emissao_nf  
             
 from   remessa_fatura r,
        fatura         f,
        nota_fiscal    nf,
        itfat_nota_fiscal inf
      
 where  r.cd_fatura = f.cd_fatura
 and    r.cd_remessa = inf.cd_remessa(+)
 and    inf.cd_remessa = nf.cd_remessa(+)
) 

select * from
(
    Select
        atendime.cd_convenio,
        c.nm_convenio,
        remessa.dt_abertura,
        remessa.dt_fechamento,
        remessa.competencia,
        remessa.rps,
        remessa.emissao_nf,  
        vw_ordem_compra_aberta.cd_ord_com,
        vw_ordem_compra_aberta.dt_ord_com,
        case when paciente.SN_UTILIZA_NOME_SOCIAL = 'S' and paciente.nm_paciente is not null
        then 'SOCIAL: '||paciente.NM_SOCIAL_PACIENTE
        else paciente.NM_PACIENTE end nome,
        mov_prod.dt_mvto,
        mov_prod.cd_mvto,
        mov_prod.cd_lote,
        vw_ordem_compra_aberta.tp_situacao,
        vw_ordem_compra_aberta.cd_estoque,
        vw_ordem_compra_aberta.cd_condicao_pagamento,
        vw_ordem_compra_aberta.cd_consumo_paciente,
        vw_ordem_compra_aberta.cd_fornecedor,
        vw_ordem_compra_aberta.nm_fornecedor,
        vw_ordem_compra_aberta.ds_ordem_de_compra,
        vw_ordem_compra_aberta.cd_produto,
        vw_ordem_compra_aberta.ds_produto,
        vw_ordem_compra_aberta.qt_ord_com,
        vw_ordem_compra_aberta.vl_compra,
        consumo_pac.cd_atendimento,
        consumo_pac.cd_aviso_cirurgia,
        consumo_pac.QT_CONSUMO,
        vw_conta_paciente.conta,
        vw_conta_paciente.cd_pro_fat,
        vw_conta_paciente.sn_fechada,
        vw_conta_paciente.cd_remessa,
        vw_conta_paciente.sn_remessa,
        vw_conta_paciente.qt_lancamento,
        vw_conta_paciente.vl_unitario,
        vw_guia.qt_autorizado_guia qt_guia,
        vw_guia.vl_unitario_guia,
        vw_guia.vl_proposto_guia,
        vw_guia.vl_total_autorizado_guia,
        multi_empresas.ds_multi_empresa,
        vw_ordem_compra_aberta.ACOMPANHAMENTO,

       (SELECT LISTAGG(DS_MOTIVO_AUDITORIA,';') WITHIN GROUP (ORDER BY DS_MOTIVO_AUDITORIA) DS_MOTIVO_AUDITORIA
        FROM (SELECT MOT_AUDIT.DS_MOTIVO_AUDITORIA
                FROM MOT_AUDIT
               WHERE ((MOT_AUDIT.CD_MVTO_ESTOQUE IS NOT NULL
                   AND MOT_AUDIT.CD_MVTO_ESTOQUE = mov_prod.cd_mvto
                   AND MOT_AUDIT.CD_PRODUTO      = vw_ordem_compra_aberta.cd_produto)
                  OR  (MOT_AUDIT.CD_ATENDIMENTO = consumo_pac.cd_atendimento
                   AND MOT_AUDIT.CD_PRODUTO     = vw_ordem_compra_aberta.cd_produto))
                 GROUP BY MOT_AUDIT.DS_MOTIVO_AUDITORIA)) DS_MOTIVO_AUDITORIA

    from vw_ordem_compra_aberta,
         consumo_pac,
         mov_prod,
         vw_conta_paciente,
         vw_guia,
         dbamv.atendime,
         dbamv.paciente,
         dbamv.convenio,
         dbamv.estoque,
         dbamv.multi_empresas,
         convenio c,
         remessa

    where vw_ordem_compra_aberta.cd_consumo_paciente = consumo_pac.cd_consumo_paciente
    and   vw_ordem_compra_aberta.cd_produto = consumo_pac.cd_produto
    and atendime.cd_paciente                         = paciente.cd_paciente
    and convenio.cd_convenio                         = atendime.cd_convenio
    and consumo_pac.cd_atendimento                   = atendime.cd_atendimento
    and consumo_pac.cd_atendimento                   = vw_conta_paciente.cd_atendimento (+)
    and consumo_pac.cd_aviso_cirurgia     = vw_guia.cd_aviso_cirurgia (+)
    and vw_ordem_compra_aberta.cd_pro_fat = vw_guia.cd_pro_fat (+)
    and vw_ordem_compra_aberta.cd_pro_fat = vw_conta_paciente.cd_pro_fat (+)
    and vw_conta_paciente.cd_mvto         = mov_prod.cd_mvto_estoque (+)
    and vw_conta_paciente.cd_pro_fat      = mov_prod.cd_pro_fat (+)
    and atendime.cd_convenio = c.cd_Convenio
    and vw_conta_paciente.cd_remessa = remessa.cd_remessa(+)
    AND estoque.cd_estoque = vw_ordem_compra_aberta.cd_estoque
    AND estoque.cd_multi_empresa = multi_empresas.cd_multi_empresa
)
)
