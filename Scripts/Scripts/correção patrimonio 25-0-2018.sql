select a.cd_bem,
       a.ds_bem,
       a.ds_plaqueta,
       a.cd_setor,
      (select x.NM_SETOR from dbamv.setor x where x.CD_SETOR = a.cd_setor)nm_setor_localiz,
      (select X1.SN_ATIVO from dbamv.setor x1 where x1.CD_SETOR = a.cd_setor )SN_SETOR_LOCALIZ,
       b.cd_setor ,
       c.NM_SETOR NM_SETOR_DEPRE,
       c.SN_ATIVO,
      -- b.vl_bem_perc_setor,
      decode(a.cd_multi_empresa,'1','HMSJ','2','PMP','13','SANTA MARIA')EMPRESA
       from dbamv.bens a ,
            dbamv.bens_deprec_setor b,
            dbamv.setor c
where a.cd_bem = b.cd_bem
and c.CD_SETOR = b.cd_setor
and a.cd_bem = 5808
--and c.SN_ATIVO = 'N'
and a.dt_baixa is null 
--AND A.CD_MULTI_EMPRESA = 2
--AND A.CD_SETOR = 707
and a.cd_setor <> b.cd_setor
order by a.cd_bem

----------




/*UPDATE DBAMV.BENS_DEPREC_SETOR A2
SET A2.CD_SETOR = 683
WHERE A2.CD_SETOR = 194
and a2.cd_bem in ()
*/




