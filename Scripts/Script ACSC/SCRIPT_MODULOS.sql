select p.cd_papel,p.ds_papel,m.cd_modulo
from dbasgu.papel_mod m
inner join dbasgu.papel p on m.cd_papel = p.cd_papel
where m.cd_modulo in ('M_HORARIO_CONTRATADO','M_PREST_REP','M_PRO_FAT_SEM_PRESTADOR','M_REG_REP','M_REG_REP_DESC','M_REG_REP_SIA','M_REG_REP_SIH')
