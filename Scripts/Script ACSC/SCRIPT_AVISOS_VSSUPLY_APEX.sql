select 
G.CD_GUIA,
G.CD_CONVENIO,
G.CD_AVISO_CIRURGIA,
G.NR_GUIA,
G.TP_GUIA,
G.NR_GUIA,
G.CD_SENHA,
G.DT_SOLICITACAO,
G.DT_AUTORIZACAO,
ig.dt_geracao,
ig.cd_pro_fat,
ig.cd_usu_geracao


from
guia g
inner join aviso_cirurgia cr on cr.cd_aviso_cirurgia = g.cd_aviso_cirurgia
INNER JOIN CIRURGIA_AVISO CRr ON CRr.CD_AVISO_CIRURGIA = cr.CD_AVISO_CIRURGIA
INNER JOIN it_guia ig on ig.cd_guia = g.cd_guia
where g.tp_guia = 'O'
and g.cd_aviso_cirurgia is not null
and g.cd_atendimento is null
and cr.cd_multi_empresa = 7
and crr.cd_convenio not in (40)
and ig.cd_pro_fat is not null
--and ig.cd_usu_geracao = 'MVINTEGRACAO'
--and trunc(ig.dt_geracao) > = to_date('31/08/2023','dd/mm/rrrr')
--and ig.cd_pro_fat is not null
--and g.cd_aviso_cirurgia = 389782
order by g.cd_guia desc 
--And atd.cd_convenio = 41
;
select * from val_opme_it_guia x where x.cd_guia in (5362879)
---376291
select cd_produto,ds_produto,cd_pro_fat from produto where cd_pro_fat in (70466408,09081590,09014735,70906815);
;
select * from pacote pc where pc.cd_pro_fat in (60001038)     
and pc.cd_pro_fat_pacote in (20000001)
and pc.cd_convenio in (41);



delete from dbamv.nota_fiscal nf where nf.cd_multi_empresa = 7 --nf.nr_id_nota_fiscal = '202793'
and nf.cd_status = 'C' 
and nf.cd_reg_amb is null
and nf.cd_reg_fat is null
and nf.ds_retorno_nfe is null
and nf.dt_emissao > = '01/08/2023';


select * from empresa_prestador
