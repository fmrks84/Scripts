select cd_multi_empresa,
       dt_aviso,
       cd_aviso_cirurgia,
       nm_paciente,
       nm_convenio,
       sum(qt_movimentacao)total_movimentacao,
       sum(QT_AG_AUTORIZACAO)total_ag_autorizacao,
       sum(QT_AUTORIZADO)total_autorizado,
       case when SN_PERTENCE_PACOTE = 'SIM' then SUM(1)ELSE 0 END PROD_PERTENCE_PACOTE,
       case when SN_PERTENCE_PACOTE = 'NÃO' then SUM(1)ELSE 0 END PROD_NAO_PERTENCE_PACOTE  
           
from
(
select
       x1.cd_multi_empresa,
       x1.cd_mvto_estoque,
       x1.cd_estoque,
       x1.dt_mvto_estoque,
       x1.cd_aviso_cirurgia,
       trunc(x7.dt_inicio_age_cir)dt_aviso,
       x1.cd_atendimento,
       x6.nm_paciente,
       x10.nm_convenio, 
        x2.cd_pro_fat,
       x.cd_produto,
       x2.ds_produto,
       x.cd_lote,
       x.dt_validade,
       x.qt_movimentacao,
      CASE WHEN  x11.tp_proibicao = 'G' THEN 'AUT.POR GUIA'
           WHEN  x11.tp_proibicao = 'F' THEN 'FORA DA CONTA'
           WHEN  x11.tp_proibicao = 'NA'THEN 'NÃO AUTORIZADO'
           WHEN  x11.tp_proibicao is null then 'SEM PROIBIÇÃO' 
      END tipo_proibicao,
       CASE  
         WHEN x4.tp_situacao  = 'P'
         THEN UPPER('pendente')
         WHEN x4.tp_situacao  = 'S'
         THEN UPPER('solicitada')
         WHEN x4.tp_situacao  = 'A'
         THEN UPPER('autorizada')
         WHEN x4.tp_situacao  = 'G'
         THEN UPPER('negociação')
         END STATUS_AUTORIZACAO,
          CASE WHEN x4.nr_guia IS NOT NULL THEN X4.NR_GUIA ELSE 'AGUARD_NR_GUIA' END NR_GUIA,
         CASE WHEN x4.tp_situacao IN ('P','S','G') THEN x3.qt_lancamento ELSE 0 END QT_AG_AUTORIZACAO ,
         CASE WHEN x4.tp_situacao IN ('A')THEN x3.qt_lancamento ELSE 0 END QT_AUTORIZADO,
         CASE WHEN X3.CD_CONTA_PACOTE IS NOT NULL THEN 'SIM' ELSE 'NÃO' END SN_PERTENCE_PACOTE,  
         (select pf.ds_pro_fat from pro_Fat pf where pf.cd_pro_fat = x9.cd_pro_fat_pacote)nm_pacote
        -- x4.cd_guia 
        

       
        from itmvto_Estoque x
inner join mvto_Estoque x1 on x1.cd_mvto_estoque = x.cd_mvto_estoque
inner join produto x2 on x2.cd_produto = x.cd_produto
inner join itreg_fat x3 on x3.cd_pro_fat = x2.cd_pro_fat and x3.cd_mvto = x1.cd_mvto_estoque and x3.cd_itmvto = x.cd_itmvto_estoque
inner join guia x4 on x4.cd_guia = x3.cd_guia 
inner join atendime x5 on x5.cd_atendimento = x1.cd_atendimento
inner join paciente x6 on x6.cd_paciente = x5.cd_paciente
inner join age_cir x7 on x7.cd_aviso_cirurgia = x1.cd_aviso_cirurgia
left join conta_pacote x8 on x8.cd_conta_pacote = x3.cd_conta_pacote
left join pacote x9 on x9.cd_pacote = x8.cd_pacote
inner join convenio x10 on x10.cd_convenio = x5.cd_convenio
left join proibicao x11 on x11.cd_pro_fat = x3.cd_pro_fat
                         and x11.cd_convenio = x5.cd_convenio
                         and x11.cd_con_pla = x5.cd_con_pla
                         and x11.cd_multi_empresa = x5.cd_multi_empresa
                         and x11.tp_atendimento = x5.tp_atendimento
where x1.cd_multi_empresa = 7 -- filtro empresa 
and x1.cd_aviso_cirurgia = 207048
--and trunc(x7.dt_inicio_age_cir) between '01/07/2021' and  '01/07/2021'  -- filtro data cirurgia
)
group by 
cd_multi_empresa,
dt_aviso,
cd_aviso_cirurgia,
nm_paciente,
nm_convenio,
SN_PERTENCE_PACOTE
order by 
dt_aviso,
nm_paciente
;
select
       x1.cd_multi_empresa,
       x1.cd_mvto_estoque,
       x1.cd_estoque,
       x1.dt_mvto_estoque,
       x1.cd_aviso_cirurgia,
       trunc(x7.dt_inicio_age_cir)dt_aviso,
       x1.cd_atendimento,
       x6.nm_paciente,
       x10.nm_convenio, 
        x2.cd_pro_fat,
       x.cd_produto,
       x2.ds_produto,
       x.cd_lote,
       x.dt_validade,
       x.qt_movimentacao,
      CASE WHEN  x11.tp_proibicao = 'G' THEN 'AUT.POR GUIA'
           WHEN  x11.tp_proibicao = 'F' THEN 'FORA DA CONTA'
           WHEN  x11.tp_proibicao = 'NA'THEN 'NÃO AUTORIZADO'
           WHEN  x11.tp_proibicao is null then 'SEM PROIBIÇÃO' 
      END tipo_proibicao,
       CASE  
         WHEN x4.tp_situacao  = 'P'
         THEN UPPER('pendente')
         WHEN x4.tp_situacao  = 'S'
         THEN UPPER('solicitada')
         WHEN x4.tp_situacao  = 'A'
         THEN UPPER('autorizada')
         WHEN x4.tp_situacao  = 'G'
         THEN UPPER('negociação')
         END STATUS_AUTORIZACAO,
         CASE WHEN x4.nr_guia IS NOT NULL THEN X4.NR_GUIA ELSE 'AGUARD_NR_GUIA' END NR_GUIA,
         CASE WHEN x4.tp_situacao IN ('P','S','G') THEN x3.qt_lancamento ELSE 0 END QT_AG_AUTORIZACAO ,
         CASE WHEN x4.tp_situacao IN ('A')THEN x3.qt_lancamento ELSE 0 END QT_AUTORIZADO,
         CASE WHEN X3.CD_CONTA_PACOTE IS NOT NULL THEN 'SIM' ELSE 'NÃO' END SN_PERTENCE_PACOTE,  
         (select pf.ds_pro_fat from pro_Fat pf where pf.cd_pro_fat = x9.cd_pro_fat_pacote)nm_pacote,
          x4.cd_guia 
         

       
        from itmvto_Estoque x
inner join mvto_Estoque x1 on x1.cd_mvto_estoque = x.cd_mvto_estoque
inner join produto x2 on x2.cd_produto = x.cd_produto
inner join itreg_fat x3 on x3.cd_pro_fat = x2.cd_pro_fat and x3.cd_mvto = x1.cd_mvto_estoque 
                                                         and x3.cd_itmvto = x.cd_itmvto_estoque
inner join guia x4 on x4.cd_guia = x3.cd_guia 
inner join atendime x5 on x5.cd_atendimento = x1.cd_atendimento
inner join paciente x6 on x6.cd_paciente = x5.cd_paciente
inner join age_cir x7 on x7.cd_aviso_cirurgia = x1.cd_aviso_cirurgia
left join conta_pacote x8 on x8.cd_conta_pacote = x3.cd_conta_pacote
left join pacote x9 on x9.cd_pacote = x8.cd_pacote
inner join convenio x10 on x10.cd_convenio = x5.cd_convenio
left join proibicao x11 on x11.cd_pro_fat = x3.cd_pro_fat
                         and x11.cd_convenio = x5.cd_convenio
                         and x11.cd_con_pla = x5.cd_con_pla
                         and x11.cd_multi_empresa = x5.cd_multi_empresa
                         and x11.tp_atendimento = x5.tp_atendimento
where x1.cd_multi_empresa = 7 --- filtro empresa 
and  x1.cd_aviso_cirurgia = 207048
--and trunc(x7.dt_inicio_age_cir) between '01/07/2021' and  '01/07/2021' -- filtro dt_cirurgia
order by nm_paciente , cd_mvto_estoque ,ds_produto
