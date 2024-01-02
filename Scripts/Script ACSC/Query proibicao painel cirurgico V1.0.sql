select
decode (pb.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') CASA,
conv.cd_convenio||' - '||conv.nm_convenio nm_convenio,
ecpla.cd_con_pla||' - '||cpla.ds_con_pla nm_plano,
gf.cd_gru_fat||' - '||gf.ds_gru_fat gr_faturamento,
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
inner join empresa_con_pla ecpla  on ecpla.cd_multi_empresa  = pb.cd_multi_empresa--econv.cd_multi_empresa 
                                 and ecpla.cd_convenio = pb.cd_convenio--econv.cd_convenio            
                                 and ecpla.cd_con_pla = pb.cd_con_pla   
inner join con_pla cpla           on cpla.cd_con_pla = ecpla.cd_con_pla
                                 and cpla.cd_convenio = ecpla.cd_convenio     
left join setor st                on st.cd_setor      = pb.cd_setor
                                 and st.cd_multi_empresa = pb.cd_multi_empresa    
inner join pro_fat pf             on pf.cd_pro_fat    = pb.cd_pro_fat    
inner join gru_pro gp             on gp.cd_gru_pro    = pf.cd_gru_pro
inner join gru_fat gf             on gf.cd_gru_fat    = gp.cd_gru_fat
                                                              
where trunc(pb.dt_inicial_proibicao) = (select max(x.dt_inicial_proibicao) from proibicao x where x.cd_convenio = pb.cd_convenio
                                                                     and  x.cd_con_pla  = pb.cd_con_pla
                                                                     and x.cd_multi_empresa = pb.cd_multi_empresa
                                                                     and x.cd_pro_Fat = pb.cd_pro_Fat)
                           
and pb.cd_multi_empresa = 7  --> DEIXAR FIXO CODIGO DA EMPRESA 
and pb.cd_convenio = 1  -- Criar filtro nm_convenio --- deixar com default o convenio  =1 permitindo o usuário selecionar outros convenios
and pb.cd_con_pla = 1   -- Criar filtro nm_con_pla  --- deixar con default o cd_plano = 1 permitindo o usuário selecionar outros plano
and pb.dt_fim_proibicao is null
order by pb.cd_pro_fat,gf.ds_gru_fat
         

--- FILTROS ----
--nm_convenio 
--nm_plano


--- 31217500
--- 30075458
--- 25923742


-- TIP ATENDI =
-- TIPO PROIB <> 
-- DT INICIAL =
