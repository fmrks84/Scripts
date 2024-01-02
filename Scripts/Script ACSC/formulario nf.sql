select * from dbamv.formulario_nf a where a.cd_formulario_nf in (6,9,11,13,14,15,16,17)--15 -- 215613
select * from dbamv.empresa_convenio b where b.b.cd_multi_empresa in (50,49,25,47,5,4,3,10,41)
select * from dbamv.multi_empresas c where c.cd_uf = 'RJ'--c.cd_multi_empresa = 1
select * from nota_Fiscal b1 where b1.nr_cgc_cpf = '08592086728'--b1.nr_id_nota_fiscal = 226654

select * from con_rec cr where cr.nr_documento in ('226654','226657')
select * from nota_Fiscal b where b.cd_formulario_nf = 15 and b.ds_retorno_nfe like '%E38%' order by b.dt_emissao  desc  --b.nr_id_nota_fiscal = 224754
select * from nota_fiscal c where c.cd_formulario_nf = 1 order by 1 desc 
select * from empresa_convenio where cd_convenio = 261

select * from tuss where cd_pro_Fat = '20101014'

select * from atendime where cd_atendimento = 2370113
