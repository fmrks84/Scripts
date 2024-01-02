select decode (row_number()over (partition by q.cd_atendimento order by q.cd_amostra),1,'AMOSTRA:', null) SEQ
       , q.* from (select pc.cd_paciente
      ,pc.nm_paciente
      ,pc.nm_mae
      ,pc.ds_endereco
      ,pack_internamento.retorna_idade(PC.DT_NASCIMENTO, SysDate) IDADE
      ,it.cd_exa_lab|| ' - ' || el.nm_exa_lab EXAME
      ,EL.DS_ESPELHO
      ,b.cd_bancada
      ,b.ds_bancada
      ,pl.cd_prestador
      ,decode(pl.cd_prestador,
              null,
              pl.nm_prestador,
              pr.nm_prestador) nm_prestador
      ,pl.cd_setor
      ,s.nm_setor
      ,pl.cd_ped_lab
      ,it.cd_itped_lab
      ,pl.ds_observacao
      ,pl.dt_pedido
      ,pl.hr_ped_lab
      ,pc.tp_sexo
      ,l.ds_resumo
      ,at.cd_atendimento
      ,a.cd_amostra
      ,m.ds_material
        from dbamv.ped_lab pl
inner join dbamv.atendime at on at.cd_atendimento = pl.cd_atendimento
left join dbamv.leito l on l.cd_leito = at.cd_leito
inner join dbamv.paciente pc on pc.cd_paciente = at.cd_paciente
inner join dbamv.itped_lab it on it.cd_ped_lab = pl.cd_ped_lab
inner join dbamv.exa_lab el on el.cd_exa_lab = it.cd_exa_lab
inner join dbamv.amostra_exa_lab a on a.cd_itped_lab = it.cd_itped_lab
inner join dbamv.lote_bancada lb on lb.cd_bancada = a.cd_bancada and lb.cd_lote_bancada = it.cd_lote_bancada
inner join dbamv.bancada b on b.cd_bancada = lb.cd_bancada
inner join dbamv.setor s on s.cd_setor = pl.cd_setor
left join dbamv.prestador pr on pr.cd_prestador = pl.cd_prestador
inner join dbamv.amostra am on am.cd_amostra = a.cd_amostra
left join dbamv.material m on m.cd_material = am.cd_material
where lb.cd_lote_bancada = 476516 ) Q--pl.cd_ped_lab = 1903695 --a.cd_amostra = 4725566 --pl.cd_atendimento = 8765651
