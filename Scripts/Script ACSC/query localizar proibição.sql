select 
a.tp_mvto_estoque,
b.tp_estoque,
f.cd_solsai_pro,
f.tp_solsai_pro,
a.cd_aviso_cirurgia,
a.cd_mvto_estoque,
a.hr_mvto_estoque,
a.Cd_Atendimento,
a.cd_estoque,
a.cd_setor,
b.cd_produto,
b.cd_lote,
b.dt_validade,
b.qt_movimentacao,
e.tp_proibicao,
e.tp_atendimento

from 
dbamv.mvto_estoque a 
inner join dbamv.itmvto_estoque b on b.cd_mvto_estoque = a.cd_mvto_estoque
inner join dbamv.atendime c on c.cd_atendimento = a.cd_atendimento 
inner join dbamv.solsai_pro f on f.cd_atendimento = a.cd_atendimento
inner join dbamv.itsolsai_pro f1 on f1.cd_solsai_pro = f.cd_solsai_pro
inner join dbamv.produto d on d.cd_produto = b.cd_produto
inner join dbamv.proibicao e on e.cd_pro_fat = d.cd_pro_fat 
                            and e.cd_convenio = c.cd_convenio
                            and e.cd_con_pla = c.cd_con_pla
                            and e.cd_multi_empresa = c.cd_multi_empresa
where a.cd_atendimento = 2555729
--

--select * from dbamv.solsai_pro z where z.cd_atendimento = 2555729
