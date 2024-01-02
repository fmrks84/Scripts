-------------- Query principal -------------------------------------
select  cd_aviso_cirurgia NR_AVISO_CIRURGIA,
        nm_paciente NOME_PACIENTE,
        nm_convenio NOME_CONVENIO,
        sum(qtd_aut_guia)AUTORIZADO_POR_GUIA,
        sum(qtd_nao_autorizado)NAO_AUTORIZADO,
        PROD_PERTENCE_A_PACOTE

from
(
select 
cd_multi_empresa,
cd_mvto_estoque,
cd_estoque,
dt_mvto_estoque,
cd_setor,
cd_aviso_cirurgia ,
cd_atendimento,
nm_paciente,
cd_convenio,
nm_convenio,
cd_pro_fat,
cd_produto,
ds_produto,
qt_movimentacao,
TIPO_PROIBICAO,
case when sn_pertence_pacote = 'S'
  then 'SIM'
    else 'NÃO'
      END PROD_PERTENCE_A_PACOTE,

DS_PACOTE,
case when tipo_proibicao = 'AUTORIZADO POR GUIA'
  then qt_movimentacao
    else 0
   end QTD_AUT_GUIA,
case when tipo_proibicao = 'NÃO AUTORIZADO'
  then qt_movimentacao
    else 0
   end QTD_NAO_AUTORIZADO   
   
from 
(
select distinct
       econv.cd_multi_empresa,
       mvest.cd_mvto_estoque,
       mvest.cd_estoque,
       mvest.dt_mvto_estoque,
       mvest.cd_setor,
       mvest.cd_aviso_cirurgia,
       mvest.cd_atendimento,
       avcir.nm_paciente,
       cav.cd_convenio,
       conv.nm_convenio,
        prd.cd_pro_fat,
       itest.cd_produto,
       prd.ds_produto,
       itest.qt_movimentacao,
       case when pbc.tp_proibicao = 'NA'
        then 'NÃO AUTORIZADO'
          ELSE 'AUTORIZADO POR GUIA'
            END TIPO_PROIBICAO,
          irf.sn_pertence_pacote , 
          pct.cd_pacote,
          (select pf1.ds_pro_fat from dbamv.pro_Fat pf1 where pf1.cd_pro_fat  = pct.cd_pro_fat_pacote)DS_PACOTE
               
from dbamv.mvto_estoque mvest 
inner join dbamv.itmvto_estoque itest on itest.cd_mvto_estoque = mvest.cd_mvto_estoque
inner join dbamv.aviso_cirurgia avcir on avcir.cd_aviso_cirurgia = mvest.Cd_Aviso_Cirurgia
inner join dbamv.cirurgia_aviso cav on cav.cd_aviso_cirurgia = avcir.cd_aviso_cirurgia
inner join dbamv.produto prd on prd.cd_produto = itest.cd_produto
inner join dbamv.pro_fat pf on pf.cd_pro_fat = prd.cd_pro_fat
inner join dbamv.convenio conv on conv.cd_convenio = cav.cd_convenio
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
                                        and econv.cd_multi_empresa = mvest.cd_multi_empresa
inner join dbamv.proibicao pbc on pbc.cd_pro_fat = prd.cd_pro_fat and pbc.cd_convenio = cav.cd_convenio 
                                                                  and pbc.cd_con_pla  = cav.cd_con_pla
                                                                  and pbc.cd_multi_empresa = econv.cd_multi_empresa
inner join dbamv.reg_Fat rf on rf.Cd_Atendimento = mvest.cd_atendimento 
inner join dbamv.itreg_Fat irf on irf.cd_pro_fat = pbc.cd_pro_fat and irf.cd_mvto = mvest.cd_mvto_estoque 
left join dbamv.conta_pacote cpct on cpct.cd_conta_pacote = irf.cd_conta_pacote
left join dbamv.pacote pct on pct.cd_pacote = cpct.cd_pacote
inner join convenio conv on conv.cd_convenio = 
where avcir.cd_aviso_cirurgia in (136425) 
and mvest.dt_mvto_estoque > = '01/01/2021'
and pbc.tp_proibicao in ('NA','AG')
--and conv.tp_convenio = 'C'
order by avcir.nm_paciente
)
)group by cd_aviso_cirurgia,
          nm_paciente,
          nm_convenio,
          PROD_PERTENCE_A_PACOTE
order by nm_paciente

;
-------------------------- Query Detalhe ----------------------------------------------
select 
cd_multi_empresa CODIGO_CASA,
cd_mvto_estoque NR_MOVIM_ESTOQUE,
cd_estoque CODIGO_ESTOQUE,
dt_mvto_estoque DATA_MOV_PRODUTO,
cd_setor COD_SETOR,
cd_aviso_cirurgia NR_AVISO_CIR ,
cd_atendimento,
nm_paciente,
cd_convenio,
nm_convenio,
cd_pro_fat,
cd_produto,
ds_produto,
qt_movimentacao,
TIPO_PROIBICAO,

case when sn_pertence_pacote = 'S'
  then 'SIM'
    else 'NÃO'
      end sn_pertence_pacote ,

case 
  when sn_pertence_pacote = 'S'
    then ds_pacote
      else null
        end NM_PACOTE,
case when tipo_proibicao = 'AUTORIZADO POR GUIA'
  then qt_movimentacao
    else 0
   end QTD_AUT_GUIA,
case when tipo_proibicao = 'NÃO AUTORIZADO'
  then qt_movimentacao
    else 0
   end QTD_NAO_AUTORIZADO   
   
from 
(
select distinct
       econv.cd_multi_empresa,
       mvest.cd_mvto_estoque,
       mvest.cd_estoque,
       mvest.dt_mvto_estoque,
       mvest.cd_setor,
       mvest.cd_aviso_cirurgia,
       mvest.cd_atendimento,
       avcir.nm_paciente,
       cav.cd_convenio,
       conv.nm_convenio,
        prd.cd_pro_fat,
       itest.cd_produto,
       prd.ds_produto,
       itest.qt_movimentacao,
       case when pbc.tp_proibicao = 'NA'
        then 'NÃO AUTORIZADO'
          ELSE 'AUTORIZADO POR GUIA'
            END TIPO_PROIBICAO,
          irf.sn_pertence_pacote , 
          pct.cd_pacote,
          (select pf1.ds_pro_fat from dbamv.pro_Fat pf1 where pf1.cd_pro_fat  = pct.cd_pro_fat_pacote)DS_PACOTE
               
from dbamv.mvto_estoque mvest 
inner join dbamv.itmvto_estoque itest on itest.cd_mvto_estoque = mvest.cd_mvto_estoque
inner join dbamv.aviso_cirurgia avcir on avcir.cd_aviso_cirurgia = mvest.Cd_Aviso_Cirurgia
inner join dbamv.cirurgia_aviso cav on cav.cd_aviso_cirurgia = avcir.cd_aviso_cirurgia
inner join dbamv.produto prd on prd.cd_produto = itest.cd_produto
inner join dbamv.pro_fat pf on pf.cd_pro_fat = prd.cd_pro_fat
inner join dbamv.convenio conv on conv.cd_convenio = cav.cd_convenio
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
                                        and econv.cd_multi_empresa = mvest.cd_multi_empresa
inner join dbamv.proibicao pbc on pbc.cd_pro_fat = prd.cd_pro_fat and pbc.cd_convenio = cav.cd_convenio 
                                                                  and pbc.cd_con_pla  = cav.cd_con_pla
                                                                  and pbc.cd_multi_empresa = econv.cd_multi_empresa
inner join dbamv.reg_Fat rf on rf.Cd_Atendimento = mvest.cd_atendimento 
inner join dbamv.itreg_Fat irf on irf.cd_pro_fat = pbc.cd_pro_fat and irf.cd_mvto = mvest.cd_mvto_estoque 
left join dbamv.conta_pacote cpct on cpct.cd_conta_pacote = irf.cd_conta_pacote
left join dbamv.pacote pct on pct.cd_pacote = cpct.cd_pacote

where avcir.cd_aviso_cirurgia in (136425)
and mvest.dt_mvto_estoque > = '01/02/2021'
and pbc.tp_proibicao in ('NA','AG')
--and conv.tp_convenio = 'C'
order by avcir.nm_paciente
)


