select cd_multi_empresa,
       DT_CIRURGIA,
       cd_aviso_cirurgia,
       nm_paciente,
       nm_convenio,
       sum(qt_autorizada)QT_AUTORIZADA,
       sum(qt_nao_autorizada)QT_NAO_AUTORIZADA,
       prod_pertence_pacote

from
(
select 
        atend.cd_multi_empresa,
        trunc(ag.dt_inicio_age_cir)DT_CIRURGIA,
         mvt.Cd_Aviso_Cirurgia, 
         a1.cd_atendimento, 
         a1.cd_convenio,
         conv.nm_convenio,
         pc.nm_paciente,
         mvt.cd_mvto_estoque, 
         mvt.cd_estoque,
         imvt.qt_movimentacao,
         a2.cd_pro_fat,
         pf.ds_pro_fat,
         a1.cd_guia,
         a1.nr_guia, 
         a1.cd_senha, 
         CASE 
         WHEN A1.TP_SITUACAO = 'P'
         THEN UPPER('pendente')
         WHEN A1.TP_SITUACAO = 'S'
         THEN UPPER('solicitada')
         WHEN A1.TP_SITUACAO = 'A'
         THEN UPPER('autorizada')
         WHEN A1.TP_SITUACAO = 'G'
         THEN UPPER('negociação')
         END STATUS_AUTORIZACAO,
         irf.cd_conta_pacote,
         case when irf.cd_conta_pacote is not null 
         then 'SIM' else 'NÃO'
         end prod_pertence_pacote,
 
         case when a1.tp_situacao in ('P','S','G')
         then 1 else 0 end QT_NAO_AUTORIZADA,
           
         case when a1.tp_situacao in ('A')
         then 1 else 0 end QT_AUTORIZADA
    
from guia a1 
inner join it_guia a2 on a2.cd_guia = a1.cd_guia
inner join pro_fat pf on pf.cd_pro_fat = a2.cd_pro_fat
inner join produto pd on pd.cd_pro_fat = a2.cd_pro_fat
inner join Mvto_Estoque mvt on mvt.cd_atendimento = a1.cd_atendimento
inner join itmvto_estoque imvt on imvt.cd_mvto_estoque = mvt.cd_mvto_estoque and imvt.cd_produto = pd.cd_produto
inner join atendime atend on atend.cd_atendimento = mvt.cd_atendimento
inner join proibicao pb on pb.cd_pro_fat = a2.cd_pro_fat and pb.cd_convenio = atend.cd_convenio
                                                         and pb.cd_con_pla = atend.cd_con_pla
                                                         and pb.cd_multi_empresa = atend.cd_multi_empresa
inner join aviso_cirurgia av on av.cd_aviso_cirurgia = mvt.cd_aviso_cirurgia  
inner join paciente pc on pc.cd_paciente = atend.cd_paciente           
inner join itreg_fat irf on irf.cd_pro_fat = pd.cd_pro_fat and irf.cd_mvto = mvt.cd_mvto_estoque   
left join conta_pacote cpct on cpct.cd_conta_pacote = irf.cd_conta_pacote        
left join pacote pct on pct.cd_pacote = cpct.cd_pacote    
inner join convenio conv on conv.cd_convenio = atend.cd_convenio    
inner join age_cir ag on ag.cd_aviso_cirurgia = av.cd_aviso_cirurgia  
--inner join cirurgia_aviso cav on cav.cd_aviso_cirurgia = av.cd_aviso_cirurgia and cav.cd_convenio = conv.cd_convenio           
where trunc(ag.dt_inicio_age_cir) = '11/08/2021'
and atend.cd_multi_empresa = 7
and mvt.cd_aviso_cirurgia = 185518
--and a1.cd_atendimento in (2801867)
order by 4,7
)group by 
       cd_multi_empresa,
       DT_CIRURGIA,
       cd_aviso_cirurgia,
       nm_paciente,
       nm_convenio,
       prod_pertence_pacote
order by nm_paciente       
;

select 
         atend.cd_multi_empresa,
         trunc(ag.dt_inicio_age_cir)DT_CIRURGIA,
         mvt.Cd_Aviso_Cirurgia, 
         a1.cd_atendimento, 
         a1.cd_convenio,
         conv.nm_convenio,
         pc.nm_paciente,
         mvt.cd_mvto_estoque, 
         mvt.cd_estoque,
         imvt.qt_movimentacao,
         a2.cd_pro_fat,
         pf.ds_pro_fat,
         a1.cd_guia,
         a1.nr_guia, 
         a1.cd_senha, 
         CASE 
         WHEN A1.TP_SITUACAO = 'P'
         THEN UPPER('pendente')
         WHEN A1.TP_SITUACAO = 'S'
         THEN UPPER('solicitada')
         WHEN A1.TP_SITUACAO = 'A'
         THEN UPPER('autorizada')
         WHEN A1.TP_SITUACAO = 'G'
         THEN UPPER('negociação')
         END STATUS_AUTORIZACAO,
         irf.cd_conta_pacote,
         case when irf.cd_conta_pacote is not null 
         then 'SIM' else 'NÃO'
         end prod_pertence_pacote,
 
         case when a1.tp_situacao in ('P','S','G')
         then a2.qt_autorizado else 0 end QT_NAO_AUTORIZADA,
           
         case when a1.tp_situacao in ('A')
         then a2.qt_autorizado else 0 end QT_AUTORIZADA
    
from guia a1 
inner join it_guia a2 on a2.cd_guia = a1.cd_guia 
inner join pro_fat pf on pf.cd_pro_fat = a2.cd_pro_fat
inner join produto pd on pd.cd_pro_fat = a2.cd_pro_fat
inner join Mvto_Estoque mvt on mvt.cd_atendimento = a1.cd_atendimento
inner join itmvto_estoque imvt on imvt.cd_mvto_estoque = mvt.cd_mvto_estoque and imvt.cd_produto = pd.cd_produto and imvt.qt_movimentacao = a2.qt_autorizado                                            
inner join atendime atend on atend.cd_atendimento = mvt.cd_atendimento
inner join proibicao pb on pb.cd_pro_fat = a2.cd_pro_fat and pb.cd_convenio = atend.cd_convenio
                                                         and pb.cd_con_pla = atend.cd_con_pla
                                                         and pb.cd_multi_empresa = atend.cd_multi_empresa
inner join aviso_cirurgia av on av.cd_aviso_cirurgia = mvt.cd_aviso_cirurgia  
inner join paciente pc on pc.cd_paciente = atend.cd_paciente           
inner join itreg_fat irf on irf.cd_pro_fat = pd.cd_pro_fat and irf.cd_mvto = mvt.cd_mvto_estoque 
left join conta_pacote cpct on cpct.cd_conta_pacote = irf.cd_conta_pacote        
left join pacote pct on pct.cd_pacote = cpct.cd_pacote    
inner join convenio conv on conv.cd_convenio = atend.cd_convenio  
inner join age_cir ag on ag.cd_aviso_cirurgia = av.cd_aviso_cirurgia         
where trunc(ag.dt_inicio_age_cir) = '11/08/2021'
and atend.cd_multi_empresa = 7
and mvt.cd_aviso_cirurgia = 185518
--and a1.cd_atendimento in (2801867)
order by pc.nm_paciente      


--select * from mvto_estoque x where x.cd_aviso_cirurgia = 185518

/*
select * from itmvto_estoque y where y.cd_mvto_estoque = 21219556
and cd_produto = 15083

select * from produto where cd_pro_fat = '00289500'*/
/*
select * from reg_Fat where cd_atendimento = 2801867
and cd_reg_Fat in (select cd_reg_Fat from itreg_fat where cd_pro_Fat = 70264260)
and cd_atendimento = 2801867*/


/*select * from itreg_fat where cd_reg_fat in (312458,322563)
and cd_mvto = 21212407
and cd_pro_Fat = 70264260*/

--select * from it_guia where cd_guia in (2740812,2614190) and cd_pro_fat = 70264260


