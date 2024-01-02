
-- TIP ATENDI =
-- TIPO PROIB <> 
-- DT INICIAL =

select
decode (pb.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') CASA,
conv.cd_convenio||' - '||conv.nm_convenio nm_convenio,
ecpla.cd_con_pla||' - '||cpla.ds_con_pla nm_plano,
pb.cd_pro_fat,
pf.ds_pro_fat nm_procedimento,
case when pb.tp_atendimento = 'T' then 'TODOS'
     when pb.tp_atendimento = 'I' then 'INTERNAÇÃO'
     when pb.tp_atendimento = 'U' then 'URGÊNCIA/EMERGÊNCIA'
     when pb.tp_atendimento = 'E' then 'EXTERNO'
     when pb.tp_atendimento = 'A' then 'AMBULATORIAL'
     end TP_ATENDIMENTO,
case when pb.tp_proibicao = 'NA' then 'NÃO AUTORIZADO'
  


     when pb.tp_proibicao = 'AG' then 'AUTORIZADO P/GUIA'
     when pb.tp_proibicao = 'FC' then 'FORA DA CONTA'
     end tp_proibicao,
pb.cd_setor,
st.nm_setor,
pb.dt_inicial_proibicao,
pb.dt_fim_proibicao
from 
proibicao pb                        
inner join empresa_convenio econv on econv.cd_multi_empresa = pb.cd_multi_empresa
                                 and econv.cd_convenio      = pb.cd_convenio
inner join convenio conv          on conv.cd_convenio       = pb.cd_convenio
inner join empresa_con_pla ecpla  on ecpla.cd_multi_empresa  = pb.cd_multi_empresa
                                 and ecpla.cd_convenio = pb.cd_convenio      
                                 and ecpla.cd_con_pla = pb.cd_con_pla   
inner join con_pla cpla           on cpla.cd_con_pla = ecpla.cd_con_pla
                                 and cpla.cd_convenio = ecpla.cd_convenio    
                         
left join setor st                on st.cd_setor      = pb.cd_setor
                                 and st.cd_multi_empresa = pb.cd_multi_empresa    
inner join pro_fat pf             on pf.cd_pro_fat    = pb.cd_pro_fat    

                                                              
where pb.cd_multi_empresa in (select x.cd_multi_empresa from proibicao x where x.tp_atendimento = pb.tp_atendimento
                                                                        and x.tp_proibicao <> pb.tp_proibicao
                                                                        and x.cd_multi_empresa = pb.cd_multi_empresa
                                                                        and x.cd_pro_fat = pb.cd_pro_fat
                                                                        and x.cd_convenio = pb.cd_convenio
                                                                        and x.cd_con_pla = pb.cd_con_pla
                                                                        and x.dt_inicial_proibicao = pb.dt_inicial_proibicao) 
and pb.cd_convenio = 464
--and pb.cd_pro_fat in ('28910192')
and pb.cd_con_pla = 5
and pb.cd_multi_empresa = 7
and pb.dt_fim_proibicao is null
order by  pb.cd_convenio,
          pb.cd_con_pla,
          pb.cd_pro_fat
