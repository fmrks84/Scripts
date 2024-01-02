select s.cd_solic_transf_leito cd_solic_transf_leito
      ,t.ds_tip_acom           ds_tip_acom
      ,s.cd_atendimento        cd_atendimento
      ,p.nm_paciente           nm_paciente
      ,me.nm_prestador         nm_prestador
      ,pro.cd_pro_fat          cd_pro_fat
      ,pro.ds_pro_fat          ds_pro_fat
      ,s.sn_incl_manual        sn_incl_manual
  from dbamv.hmsj_solic_transf_leito s
      ,dbamv.atendime                a
      ,dbamv.paciente                p
      ,dbamv.leito                   l
      ,dbamv.tip_acom                t
      ,dbamv.prestador               me
      ,dbamv.pro_fat                 pro
 where a.cd_atendimento = s.cd_atendimento
   and a.dt_alta_medica is null
   and a.dt_alta is null
   and a.tp_atendimento = 'I'
   and a.cd_atendimento_pai is null
   and a.cd_multi_empresa = 2 --:Controle.Empresa
   and p.cd_paciente = a.cd_paciente
   and l.cd_leito(+) = s.cd_leito
   and t.cd_tip_acom = l.cd_tip_acom
   and s.cd_mot_canc is null
   and (l.sn_extra = 'S' or s.sn_incl_manual = 'S')
   and me.cd_prestador = a.cd_prestador
   and dbamv.pkg_hmsj_checkin.pendencia_solic(s.cd_solic_transf_leito) =
       'NAO'
   and pro.cd_pro_fat = a.cd_pro_int
   and trunc(s.dh_solic_transf_leito) between '22/09/2013' and '26/09/2013'
   and s.status = 'A'
 order by s.dh_solic_transf_leito
