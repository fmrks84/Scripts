select p.cd_especie, e.ds_especie,  p.cd_produto, p.ds_produto, p.cd_procedimento_sus CODIGOSUS, ps.ds_procedimento DESCRICAOSUS, vs.vl_total_internacao VALOR
from dbamv.produto p
     inner join dbamv.especie e on e.cd_especie = p.cd_especie
     left outer join dbamv.procedimento_sus_valor vs on vs.cd_procedimento = p.cd_procedimento_sus
          and vs.dt_vigencia =
          (
              select max(vs1.dt_vigencia)
              from dbamv.procedimento_sus_valor vs1
              where vs1.cd_procedimento = p.cd_procedimento_sus
          )

     left outer join dbamv.proCEDIMENTO_SUS ps on ps.cd_procedimento = p.cd_procedimento_sus
where p.cd_especie in (19,20)
      --and p.cd_procedimento_sus is not null
      and exists (select * from dbamv.empresa_produto ep where ep.cd_produto = p.cd_produto
                         and ep.cd_multi_empresa in (3,4,7,10,11,25)
                         and ep.sn_movimentacao = 'S'  )
      --and vl_total_internacao > 0
