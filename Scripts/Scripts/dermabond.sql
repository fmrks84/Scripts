select a.cd_mvto_estoque,
       a.cd_atendimento,
       a.cd_aviso_cirurgia,
       b.qt_movimentacao
        from dbamv.Mvto_Estoque a ,
              dbamv.itmvto_estoque b
where a.cd_atendimento in
(1593326 
,1594369
,1593419 
,1593441
,1593496
,1593511 
,1593685 
,1593687 
,1593732 
,1593899 
,1593800 
,1593732 
,1594848)
and  a.cd_mvto_estoque = b.cd_mvto_estoque
and b.cd_produto = 12694
order by 2


select * from dbamv.pre_med e where e.cd_pre_med = 7118030

select * from dbamv.regra_acoplamento g where g.cd_pro_fat = 08050790

/*select * from dbamv.solsai_pro d 
inner join dbamv.itsolsai_pro e on d.cd_solsai_pro = e.cd_solsai_pro
where d.cd_atendimento = 1593326*/




/*
1594369 – Maria Fernanda Sumyk Ballaminut – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU -- S
1593419 – Giovana Biasia de Sousa  - quant. 2 – PARTO CESÁREA – NÃO UTILIZOU -- S
1593441 - Ludmilla Picosque Baltazar  - quant. 2 – PARTO CESÁREA – NÃO UTILIZOU -- S
1593496 – Cynthia Tiemi Matsubara de Carvalho – quant. 2 – PARTO VAGINAL – NÃO UTILIZOU --  S 2 
1593511 – Mariana Giostri Moraes Oliveira Rolim – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU -- S
1593687 – Aline Fernandes A. Garrone – quant. 2 – PARTO CESÁREA – NÃO UTILIZOU --S
1593800 – Lara Alcobendas Munoz – quant. 1– PARTO CESÁREA – NÃO UTILIZOU -- S
1594848 – Marcelle Francine BAcega Gabure – quant. – UTILIZOU 01 UNIDADE -- S

--------------------------------

1593326 – Adriana Cristina de Moura Leite – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU  --- N  -- presc 7116062
1593685 – Bruna Mendes Araujo – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU -- N  -- presc 7118030
1593732 – Agatha Patricia Marcos G. Mazurkyewistz – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU  --N -- lançado manualmente
1593899 – Patricia Alexandre Carvalho – quant. 1 – PARTO VAGINAL – NÃO UTILIZOU -- N -- presc 7118427
1593732 – Maria Fernanda Sumyk Ballaminut – quant. 1 – PARTO CESÁREA – NÃO UTILIZOU -- N  --  lançado manualmente -- c
*/
