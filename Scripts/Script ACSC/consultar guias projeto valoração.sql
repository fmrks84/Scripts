select * from guia a where a.tp_guia = 'O'
and a.cd_aviso_cirurgia is not null
order by a.dt_solicitacao desc 
