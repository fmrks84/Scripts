select 
cd_paciente ,
nm_paciente,
qt_cpf,
nr_cpf,
dt_nascimento,
cd_multi_empresa
from
(
select length (a.nr_cpf)qt_cpf,
       a.cd_paciente,
       a.nm_paciente,
       a.nr_cpf,
       a.dt_nascimento,
       a.cd_multi_empresa
 from dbamv.paciente a
where  1 =1 --a.cd_paciente = 2548803-- from dual -- = (9)
)where qt_cpf = 10
and cd_multi_empresa = 4
order by 1

begin
  pkg_mv2000.Atribui_Empresa (4);
  end;
select nr_cpf from paciente where cd_paciente = 3127547 for update--2688370,2803852,2823164,2851210,2859561,3127547
select * from atendime where cd_atendimento = 2621852

/*update paciente set nr_cpf = to_char(05154392744) where cd_paciente = 2443713;
commit 
begin
  pkg_mv2000.Atribui_Empresa (7);
  end;
update dbamv.paciente pct set pct.nr_cpf = lpad(pct.nr_cpf,11,0)
where pct.cd_paciente in ()*/

dbamv.paciente_nr_cpf_uk
