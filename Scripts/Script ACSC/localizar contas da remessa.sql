select distinct  -- caso queira ver os lançamentos no atendimento apenas comentar o disticnt 
       c.cd_atendimento,
       c.cd_reg_amb,
       c.sn_fechada,
       b.sn_fechada
        from dbamv.remessa_fatura a
inner join dbamv.reg_amb b on b.cd_remessa = a.cd_remessa
inner join dbamv.itreg_amb c on c.cd_reg_amb = b.cd_reg_amb
where a.cd_remessa = 178200
order by c.cd_atendimento 

