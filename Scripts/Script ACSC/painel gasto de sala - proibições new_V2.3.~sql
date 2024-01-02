/*select 
distinct
cd_Reg_fat,
cd_multi_empresa,
cd_mvto_estoque,
cd_estoque,
dt_mvto_estoque,
cd_aviso_cirurgia,
dt_aviso,
cd_atendimento,
nm_paciente,
nm_convenio,
cd_pro_fat,
cd_produto,
ds_produto,
cd_lote,
dt_validade,
qt_movimentacao,
tipo_proibicao,
STATUS_AUTORIZACAO,
NR_GUIA,
QT_AG_AUTORIZACAO,
QT_AUTORIZADO,
SN_PERTENCE_PACOTE,
nm_pacote,
EXCECAO_PACOTE,
cd_gru_pro_conta,
nm_gru_pro_conta,
GRU_PRO_SN_EXCECAO,
cd_gru_pro_excecao,
nm_gru_pro_excecao,
cd_pro_Fat_excecao,
nm_pro_Fat_excecao,
PRO_FAT_SN_EXCECAO
from (*/
select 
       x3.cd_reg_fat,
       x1.cd_multi_empresa,
       x1.cd_mvto_estoque,
       x1.cd_estoque,
       x1.dt_mvto_estoque,
       x1.cd_aviso_cirurgia,
       trunc(x7.dt_inicio_age_cir)dt_aviso,
       x1.cd_atendimento,
       x6.nm_paciente,
       x10.nm_convenio, 
        x2.cd_pro_fat ,
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
         CASE WHEN X3.SN_PERTENCE_PACOTE = 'S' THEN  'SIM' ELSE 'NÃO' END SN_PERTENCE_PACOTE,  
      
         (select pf.ds_pro_fat from pro_Fat pf where pf.cd_pro_fat = x9.cd_pro_fat_pacote)nm_pacote,  
         x4.cd_guia,
       '-------------->'EXCECAO_PACOTE,
       x9.cd_pacote,
       (select pf.ds_pro_fat from pro_Fat pf where pf.cd_pro_fat = x9.cd_pro_fat_pacote)nm_pacote,
       x10.nm_convenio,
       pf1.cd_gru_pro cd_gru_pro_conta,
       pex.cd_gru_pro cd_gru_pro_excecao,
       case when pex.cd_gru_pro <> pf1.cd_gru_pro then 'NAO' ELSE 'SIM' END SN_PERTENCE_EXC_PACOTE,
       pex.cd_pro_fat cd_pro_Fat_excecao,
       case when pex.cd_pro_fat = x3.cd_pro_fat then 'SIM'  
        when pex.cd_pro_fat <> x3.cd_pro_fat then 'NAO'
          END SN_PERTENCE_PRO_FAT_EXC_PACOTE
     
   
  

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
inner join pacote_excecao pex on pex.cd_pacote = x9.cd_pacote 
left join pro_Fat pf1 on pf1.cd_pro_fat = x3.cd_pro_fat 
where x1.cd_multi_empresa = 7 --- filtro empresa 
--and  x1.cd_aviso_cirurgia = 206643 
and x3.cd_reg_fat = 324989
and exists (select y.cd_gru_pro from pacote_excecao y where y.cd_pacote = x9.cd_pacote) 
and pex.cd_gru_pro is not null
--and trunc(x7.dt_inicio_age_cir) between '01/07/2021' and  '30/07/2021' -- filtro dt_cirurgia
order by 
        x1.cd_aviso_cirurgia,                        
        pex.cd_gru_pro

/*)
where cd_reg_fat = cd_reg_fat 
order by cd_gru_pro_conta*\*/

--select * from itreg_fat where cd_reg_fat = 325610 and cd_pro_fat = 00053616
