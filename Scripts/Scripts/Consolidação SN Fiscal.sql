select TP_PROCESSO_CONSIG from dbamv.configest --- Veja qual o Tipo de Consignados

update dbamv.configest
set TP_PROCESSO_CONSIG = 'F' -- Informar o Tipo de Consignados

alter trigger dbamv.trg_u_configest disable  -- Desbilitar a Trigger Antes de Fazer o Update
commit
