select 
        cd_aviso_cirurgia,
        nm_paciente,
        nm_convenio,
        sum(NAO_AUTORIZADO)NAO_AUTORIZADO,
        sum(AUTORIZADO_GUIA)AUTORIZADO_GUIA

from
(
select 
       cd_aviso_cirurgia,
       nm_paciente,
       nm_convenio,
       QT_MOVIMENTACAO,
       case
         when tp_proibicao = 'NA'
           then qt_movimentacao
             else 0
             end NAO_AUTORIZADO,
        case
          when tp_proibicao = 'AG'
            then qt_movimentacao
              else 0
                end AUTORIZADO_GUIA  ,
         tp_proibicao   
from
(
select distinct
       mvest.cd_mvto_estoque,
       mvest.cd_estoque,
       mvest.dt_mvto_estoque,
       mvest.cd_setor,
       mvest.cd_aviso_cirurgia,
       avcir.nm_paciente,
       cav.cd_convenio,
       conv.nm_convenio,
       itest.cd_produto,
       prd.ds_produto,
       itest.qt_movimentacao,
       pbc.tp_proibicao
       
       
       
from dbamv.mvto_estoque mvest 
inner join dbamv.itmvto_estoque itest on itest.cd_mvto_estoque = mvest.cd_mvto_estoque
inner join dbamv.aviso_cirurgia avcir on avcir.cd_aviso_cirurgia = mvest.Cd_Aviso_Cirurgia
inner join dbamv.cirurgia_aviso cav on cav.cd_aviso_cirurgia = avcir.cd_aviso_cirurgia
inner join dbamv.produto prd on prd.cd_produto = itest.cd_produto
inner join dbamv.convenio conv on conv.cd_convenio = cav.cd_convenio
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
                                        and econv.cd_multi_empresa = mvest.cd_multi_empresa
inner join dbamv.proibicao pbc on pbc.cd_pro_fat = prd.cd_pro_fat and pbc.cd_convenio = cav.cd_convenio --
                                                                  and pbc.cd_con_pla  = cav.cd_con_pla  --
                                                                  and pbc.cd_multi_empresa = econv.cd_multi_empresa

where mvest.cd_aviso_cirurgia in (175472,184074)
and pbc.tp_proibicao in ('NA','AG')
and mvest.dt_mvto_estoque > = '01/01/2021'
)
)group by cd_aviso_cirurgia,
          nm_paciente,
          nm_convenio
order by nm_paciente
;
select distinct
       mvest.cd_mvto_estoque,
       mvest.cd_estoque,
       mvest.dt_mvto_estoque,
       mvest.cd_setor,
       mvest.cd_aviso_cirurgia,
       mvest.cd_atendimento,
       avcir.nm_paciente,
       cav.cd_convenio,
       conv.nm_convenio,
       itest.cd_produto,
       prd.ds_produto,
       itest.qt_movimentacao,
       case when pbc.tp_proibicao = 'NA'
        then 'NÃO AUTORIZADO'
          ELSE 'AUTORIZADO POR GUIA'
            END TIPO_PROIBICAO
       
       
       
from dbamv.mvto_estoque mvest 
inner join dbamv.itmvto_estoque itest on itest.cd_mvto_estoque = mvest.cd_mvto_estoque
inner join dbamv.aviso_cirurgia avcir on avcir.cd_aviso_cirurgia = mvest.Cd_Aviso_Cirurgia
inner join dbamv.cirurgia_aviso cav on cav.cd_aviso_cirurgia = avcir.cd_aviso_cirurgia
inner join dbamv.produto prd on prd.cd_produto = itest.cd_produto
inner join dbamv.convenio conv on conv.cd_convenio = cav.cd_convenio
inner join dbamv.empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
                                        and econv.cd_multi_empresa = mvest.cd_multi_empresa
inner join dbamv.proibicao pbc on pbc.cd_pro_fat = prd.cd_pro_fat and pbc.cd_convenio = cav.cd_convenio 
                                                                  and pbc.cd_con_pla  = cav.cd_con_pla
                                                                  and pbc.cd_multi_empresa = econv.cd_multi_empresa

where mvest.cd_aviso_cirurgia in (175472,184074)
and pbc.tp_proibicao in ('NA','AG')
and mvest.dt_mvto_estoque > = '01/01/2021'
order by avcir.nm_paciente




/*select p.cd_pro_fat ,
       p.cd_convenio,
       p.cd_con_pla,
       pd.cd_produto,
       pd.ds_produto,
       p.tp_proibicao,
       pd.cd_especie,
       pd.cd_classe,
       pd.cd_sub_cla
       
       from dbamv.proibicao p
inner join dbamv.produto pd on pd.cd_pro_fat = p.cd_pro_fat  
where p.cd_convenio = 7
and p.cd_con_pla = 20
and p.tp_proibicao in ('AG','NA'\*,'FC'*\)
*/
