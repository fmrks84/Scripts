select
rm.cd_remessa id_remessa,
rm.dt_abertura data_emissao,
case when rm.sn_Fechada = 'N' then 'false' else 'True' end SN_Fechada,
rm.dt_abertura data_Cadastro,
rm.dt_fechamento dt_fechamento,
''responsavel_Cadastro,
''data_atualizacao,
''resposavel_atualizacao   
from 
dbamv.remessa_Fatura rm
where cd_remessa = 
--;



