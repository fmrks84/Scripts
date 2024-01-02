select c.cd_atendimento,
       c.cd_guia,
       c.cd_convenio,
       c.Cd_Aviso_Cirurgia,
       c.tp_guia,
       b.cd_pro_fat,
       d.cd_produto,
       d.ds_produto,
       e.cd_registro,
       e.dt_validade_registro
       
       
 from pro_fat a 
inner join it_guia b on b.cd_pro_fat = a.cd_pro_fat
inner join guia c on c.cd_guia = b.cd_guia
inner join produto d on d.cd_pro_fat = b.cd_pro_fat
left join lab_pro  e on e.cd_produto = d.cd_produto
where c.dt_solicitacao between '01/07/2022' and sysdate
and a.cd_pro_fat LIKE '090%'
and a.sn_ativo = 'S'
--and c.cd_guia = 2512763
--and b.cd_pro_fat = 08014651
order by c.dt_solicitacao desc 
;

select * from produto x 
left join lab_pro e on e.cd_produto = x.cd_produto
where x.cd_pro_fat like '090%'
--and e.cd_registro is not null--e.nr_registro_anvisa is not null

--3332
