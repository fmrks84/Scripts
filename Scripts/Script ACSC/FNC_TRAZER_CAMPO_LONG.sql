CREATE OR REPLACE FUNCTION fc_acsc_campo_long (r rowid) return varchar2 is
temporary_varchar varchar2(4000);
begin
select ai.ds_observacao into temporary_varchar from dbamv.con_pla_obs ai where rowid=r;
return temporary_varchar;
end;

GRANT EXECUTE ON "DBAMV"."fc_acsc_campo_long" TO "MV2000";
GRANT EXECUTE ON "DBAMV"."fc_acsc_campo_long" TO "MVINTEGRA";
GRANT EXECUTE ON "DBAMV"."fc_acsc_campo_long" TO "DBAMV";


select ocpla.cd_convenio,
ocpla.cd_con_pla,
ocpla.tp_atendimento,
ocpla.cd_multi_empresa,
fc_acsc_campo_long(ocpla.rowid)ds_observacao
from dbamv.con_pla_obs ocpla
where ocpla.cd_convenio = 464

