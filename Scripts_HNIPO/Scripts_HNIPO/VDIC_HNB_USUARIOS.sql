CREATE OR REPLACE VIEW VDIC_HNB_USUARIOS AS
select "SISTEMA","MODULO","PAPEL","USUARIO","NM_USUARIO","DS_MULTI_EMPRESA","CD_EMPRESA" from (
select distinct m.cd_sistema sistema, m.cd_modulo modulo, 'AUTORIZADO NO PERFIL' papel , u.cd_usuario usuario, u.nm_usuario, empresas.ds_multi_empresa,
empresas.cd_multi_empresa cd_empresa
    from DBASGU.MOD_SIS m, DBASGU.AUT_MOD a, DBASGU.USUARIOS u, dbamv.USUARIO_MULTI_EMPRESA multi, dbamv.multi_empresas empresas
    where m.cd_modulo = a.cd_modulo
    and a.cd_usuario = u.cd_usuario
    and u.cd_usuario = multi.cd_id_usuario
    and multi.cd_multi_empresa = empresas.cd_multi_empresa
    and u.sn_ativo = 'S'
  --  and u.cd_usuario = 'ADRIANA.MESQUITA'
  --  and empresas.cd_multi_empresa = 1
  --  and m.cd_sistema in ('FCCT')

UNION

SELECT  distinct m.cd_sistema_dono sistema, m.nm_modulo modulo, p.ds_papel, us.cd_usuario usuario, us.nm_usuario, empresas.ds_multi_empresa,
        empresas.cd_multi_empresa cd_empresa
  FROM    DBASGU.MODULOS M, DBASGU.PAPEL_MOD PM, DBASGU.PAPEL P, DBASGU.MOD_SIS si, dbasgu.papel_usuarios pp, DBASGU.USUARIOS us,
          dbamv.USUARIO_MULTI_EMPRESA multi, dbamv.multi_empresas empresas
  WHERE   PM.cd_modulo = M.cd_modulo
  AND     P.cd_papel = PM.cd_papel
  and     m.cd_modulo = si.cd_modulo
  and     m.cd_sistema_dono = si.cd_sistema
  and     p.cd_papel = pp.cd_papel
  and     pp.cd_usuario = us.cd_usuario
  and     us.cd_usuario = multi.cd_id_usuario
  and     multi.cd_multi_empresa = empresas.cd_multi_empresa
  and     us.sn_ativo = 'S'
--  and     p.ds_papel = 'GLOSAS'
  and     pp.tp_papel is not null
--  and     us.cd_usuario = 'WALMIR.LIMA'
--  and     empresas.cd_multi_empresa = 1
--  and     m.cd_sistema_dono in ('FCCT')
) order by 1,4
;
