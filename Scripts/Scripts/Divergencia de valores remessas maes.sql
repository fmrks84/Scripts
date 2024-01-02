select distinct a.cd_atendimento ,
                a.nm_paciente
 from dbamv.tiss_guia a where a.nr_guia in ('8094154','8094199','8094345','8094467',
                                                   '8094645','8094749','8094819','8094826',
                                                   '8094845','8094906','8094912','8094996')-- '8095145')
order by 2
                                                   
