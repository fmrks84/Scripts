/*ID:1435 - Data da autorização
Query alternativa: 
select distinct min(to_char(g.dt_autorizacao,'rrrr-mm-dd')) from dbamv.guia g where g.cd_atendimento = :par2 and 
(g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q')
ID:1436 - Senha
Query alternativa: 
select distinct min(g.Cd_Senha) from dbamv.guia g where g.cd_atendimento = :par2 and (g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q')
ID:1434 - Número da guia atribuído pela operadora
Query alternativa: 
select distinct min(g.nr_guia) from dbamv.guia g where g.cd_atendimento = :par2 and (g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q')

*/

select a.cd_atendimento,
       B.TP_GUIA,
      count(*)
        from atendime a 
inner join guia b on b.cd_atendimento = a.cd_atendimento
and a.tp_atendimento = 'U'
where a.cd_multi_empresa = 7
and b.tp_guia = 'P'
group by a.cd_atendimento,B.TP_GUIA
having count(b.tp_guia) > = 2
order by a.cd_atendimento desc



select * from reg_amb where cd_Reg_amb = 5179057


select (to_char(g.dt_autorizacao,'rrrr-mm-dd')) from dbamv.guia g where g.cd_atendimento = 6253032 and g.cd_Guia = :par1 and (g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q' OR g.tp_guia ='C')

select (g.Cd_Senha) from dbamv.guia g where g.cd_atendimento = :par2 and g.cd_Guia = :par1 and (g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q' or g.tp_guia ='C')

select (g.nr_guia) from dbamv.guia g where g.cd_atendimento = :par2 and g.cd_Guia = :par1 and (g.tp_guia = 'P' or g.tp_guia = 'M' or g.tp_guia ='Q' or g.tp_guia ='C')

