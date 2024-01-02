select cd_remessa, cd_reg_amb, cd_convenio, cd_multi_empresa
from reg_amb where cd_reg_amb in (Select cd_reg_amb from itreg_amb where cd_atendimento =604180)

update dbamv.atendime set sn_importa_auto = 'N' where cd_atendimento = '604180'
select SN_IMPORTA_AUTO, CD_ATENDIMENTO_PAI, CD_MULTI_EMPRESA from dbamv.atendime where cd_atendimento = '604180'

commit
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss'

select sn_importa_auto, cd_atendimento_pai from atendime where cd_atendimento = '368106'

Begin
  Pkg_Mv2000.Atribui_Empresa(1 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;

