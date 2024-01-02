/*C2202/13370*/
select decode(a.cd_multi_empresa, 7, 'HSC', 3, 'CSSJ', 4, 'HST', 10,'HSJ', 25,'HCNSC') EMPRESA
      ,g.cd_atendimento
      ,a.dt_atendimento
      ,g.cd_convenio
      ,c.nm_convenio
      ,g.cd_aviso_cirurgia
      ,g.nr_guia
      ,g.cd_senha
      ,decode (g.tp_guia,'O','OPME','I','INTERNACAO','C','CONSULTA','R','PRORROGACAO','P','PROCEDIMENTO','Q','QUIMIOTERAPIA','D','RADIOTERAPIA','S','SADT','M','MEDICAMENTOS','T','MATERIAIS') TP_GUIA
      ,it.cd_pro_fat
      ,p.ds_pro_fat
      ,it.qt_autorizado QT_SOLIC
      ,g.dt_solicitacao
      ,it.qt_autorizada_convenio QT_AUT
      ,g.dt_autorizacao
      ,it.tp_pre_pos_cirurgico 
      ,decode (it.tp_situacao, 'A', 'AUTORIZADA', 'S', 'SOLICITADA', 'P', 'PENDENTE', 'C', 'CANCELADA', 'N', 'NEGADA') STATUS

from guia g, it_guia it, convenio c, atendime a, pro_fat  p
    
where it.cd_guia = g.cd_guia
and g.cd_convenio = c.cd_convenio
and g.cd_atendimento = a.cd_atendimento
and it.cd_pro_fat = p.cd_pro_fat

and a.cd_convenio <> 1
and a.dt_atendimento between '01/09/2021' and '28/02/2022'
and a.cd_multi_empresa in (7)
--and a.cd_atendimento = 3285241

order by cd_atendimento desc










