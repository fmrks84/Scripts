select * from mvintegra.integra_entrada_tarifador a 
where 1 =1 --a.tp_integracao = 'T'
and a.nr_telefone = '22851701'
--and a.cd_atendimento = 1867939
order by a.dt_integracao_mv2000 desc 
