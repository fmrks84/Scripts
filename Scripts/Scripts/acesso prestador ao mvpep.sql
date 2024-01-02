CREATE OR REPLACE VIEW DBAMV.VDIC_HMSJ_ACESSO_MV_MEDICO AS (
select A.CD_USUARIO USUARIO_MV,
       A.NM_USUARIO NM_PRESTADOR,
       B.CD_PRESTADOR COD_PRESTADOR,
       B.DS_CODIGO_CONSELHO CRM,
       D.DS_ESPECIALID ESPECIALIDADE
       
       
        from dbasgu.usuarios a 
inner join dbamv.prestador b on b.cd_prestador = a.cd_prestador
inner join dbamv.esp_med c on a.cd_prestador = c.cd_prestador
inner join dbamv.especialid d on d.cd_especialid = c.cd_especialid
where a.sn_ativo = 'S'
and b.Cd_Tip_Presta in (84,83,85)
and b.tp_situacao = 'A'
and c.sn_especial_principal = 'S');


GRANT SELECT ON DBAMV.VDIC_HMSJ_ACESSO_MV_MEDICO TO dbaps;
GRANT SELECT ON DBAMV.VDIC_HMSJ_ACESSO_MV_MEDICO TO dbasgu;
GRANT DELETE,INSERT,SELECT,UPDATE ON DBAMV.VDIC_HMSJ_ACESSO_MV_MEDICO TO mv2000;
GRANT SELECT ON DBAMV.VDIC_HMSJ_ACESSO_MV_MEDICO TO mvintegra;


