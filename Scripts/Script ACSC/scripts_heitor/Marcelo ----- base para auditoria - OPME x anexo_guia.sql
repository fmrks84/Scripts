/* C2108/10847 --> extração conforme os parâmetros solicitados:
1. Período de 01/08/20 a 31/07/21 - Apenas para o HSC
2. Documentações lançadas na tela de guias 
3. Referente aos avisos de cirurgia (incluí no relatório quando o tipo da Guia = OPME independente se tem aviso ou não, pois a tela é alimentada quando o tipo de guia é OPME mesmo não tendo aviso informado).
4. Identificado as documentações inseridas 
5. Identificado o documento, código do tipo, tipo de documento, Usuário, Data*/

select decode(a.cd_multi_empresa, 7, 'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') empresa
      ,g.cd_atendimento
      ,a.dt_atendimento
      ,g.cd_convenio
      ,c.nm_convenio
      ,g.cd_aviso_cirurgia
      ,g.nr_guia
      ,g.cd_senha
      ,decode (g.tp_guia, 'O','OPME') tp_guia
      ,ag.cd_anexos_guia
      ,ag.tp_documento
      ,ag.nm_documento
      ,ag.nm_documento_anexo
      ,ag.nm_usuario
      ,ag.dt_efetivacao

from anexos_guia ag
    
INNER JOIN guia g ON (ag.cd_guia = g.cd_guia)
INNER JOIN convenio c ON (g.cd_convenio = c.cd_convenio)
INNER JOIN atendime a ON (g.cd_atendimento = a.cd_atendimento) 
--INNER JOIN dbasgu.usuarios d ON (a.nm_usuario = d.nm_usuario)

and a.cd_convenio <> 1
and a.dt_atendimento between '01/08/2020' and '31/07/2021'
and a.cd_multi_empresa in (7)
and g.tp_guia = 'O'
--and a.cd_atendimento = 3002136 

order by dt_atendimento desc
