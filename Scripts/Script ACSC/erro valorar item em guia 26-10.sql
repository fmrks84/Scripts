select * from guia g where g.cd_aviso_cirurgia = 229283;
select cd_multi_empresa from atendime where cd_atendimento = 3161185;

select * from it_guia g1 
inner join pro_Fat pf on pf.cd_pro_fat = g1.cd_pro_fat
where g1.cd_guia in (3057208/*,3092934,3092743*/)
and g1.cd_it_guia in (6847660,6847661,6847662,6847663)
 ;
select * from val_opme_it_guia g2 where g2.cd_guia in (3057208,3092934,3092743)
