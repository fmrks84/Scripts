select rp.cd_atendimento_pai,
       rp.cd_atendimento_filho,
       p.cd_processo,
       p.nm_processo,
       p.ds_processo,
       to_char(rp.dh_registro, 'dd/mm/yyyy') Data_Reg,
       to_char(rp.dh_registro, 'hh24:mi:ss') Hora_Reg,
       rp.dh_registro dh_reg,
       rp.cd_colaborador_origem,
       c.nm_colaborador,
       rp.cd_leito,
       rp.sn_offline
       from babysafe.processo p
 inner join babysafe.registro_processo rp
    on rp.cd_processo = p.cd_processo
 inner join babysafe.colaborador_total c
    on c.cd_colaborador = rp.cd_colaborador_origem
 where rp.cd_leito = 3731
 order by 6 
 
 
