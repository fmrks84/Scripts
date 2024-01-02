/* C2108/10847 --> extração conforme os parâmetros solicitados:
1. Período de 01/08/20 a 31/07/21 - Apenas para o HSC
2. tela de guias procedimentos lançados OPME
3. Referente aos avisos de cirurgia*/

select decode(a.cd_multi_empresa, 7, 'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') EMPRESA
      ,g.cd_atendimento
      ,a.dt_atendimento
      ,g.cd_convenio
      ,c.nm_convenio
      ,g.cd_aviso_cirurgia
      ,g.nr_guia
      ,g.cd_senha
      ,decode (g.tp_guia, 'O','OPME') TP_GUIA
      ,it.cd_pro_fat
      ,p.ds_pro_fat
      ,it.tp_pre_pos_cirurgico
      ,decode (it.tp_situacao, 'A', 'AUTORIZADA', 'S', 'SOLICITADA', 'P', 'PENDENTE', 'C', 'CANCELADA', 'N', 'NEGADA') STATUS

from guia g
    
INNER JOIN it_guia it ON (it.cd_guia = g.cd_guia)
INNER JOIN convenio c ON (g.cd_convenio = c.cd_convenio)
INNER JOIN atendime a ON (g.cd_atendimento = a.cd_atendimento) 
INNER JOIN pro_fat  p ON (it.cd_pro_fat = p.cd_pro_fat)

and a.cd_convenio <> 1
and a.dt_atendimento between '01/08/2020' and '31/07/2021'
and a.cd_multi_empresa in (7)
and g.tp_guia = 'O'
and g.cd_aviso_cirurgia is not null
--and a.cd_atendimento = 2601733 

order by cd_atendimento, dt_atendimento desc





