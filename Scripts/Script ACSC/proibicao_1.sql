select Decode (p.cd_multi_empresa,'3','CSSJ'
                                 ,'7','HSC') as empresa
      ,p.cd_pro_fat 
      ,f.ds_pro_fat
      ,f.sn_ativo
      ,f.cd_gru_pro
      ,g.ds_gru_pro
      ,p.cd_con_pla as plano
      ,p.cd_convenio
      ,c.nm_convenio
      ,Decode(p.tp_proibicao,'NA','NAO AUTORIZADO'
                            ,'FC','FORA DA CONTA')as tp_proibicao
      ,Decode(p.tp_atendimento,'I','INTERNADO'
                              ,'U','URGENCIA'
                              ,'A','AMBULATORIO'
                              ,'E','EXTERNO'
                              ,'T','TODOS')as tp_atendimento
      ,p.dt_inicial_proibicao  
from proibicao p
    ,pro_fat f
    ,gru_pro g
    ,convenio c   
Where p.cd_pro_fat = f.cd_pro_fat
and f.cd_gru_pro = g.cd_gru_pro
and p.cd_convenio = c.cd_convenio
and p.dt_fim_proibicao is null
and p.tp_proibicao in ('NA','FC')
and p.cd_multi_empresa in ('3','7')
and g.cd_gru_pro in ('89','96')
and f.sn_ativo = 'S'
order by 2,7,8

