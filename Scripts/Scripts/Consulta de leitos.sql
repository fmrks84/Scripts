Select Leito.Cd_Leito, Leito.Ds_Leito, Leito.Ds_Resumo, Leito.Cd_Tip_Acom, Leito.Tp_Ocupacao, Leito.Tp_Situacao 
From   Dbamv.Leito 
Where  Leito.Cd_Unid_Int = 67 AND TP_SITUACAO = 'A'
ORDER BY DS_LEITO
--And    Leito.Cd_Tip_Acom =  
--Order By Leito.Cd_Leito
--for update;
