begin 
  pkg_mv2000.Atribui_Empresa(3);
  
  update paciente 
  set tp_cor = 'P'
  where cd_paciente in 
  (
    select 
    pc.cd_paciente
    from atendime
    inner join paciente pc on pc.cd_paciente = atendime.cd_paciente
    where atendime.dt_atendimento between to_date('01/04/2023', 'dd/mm/yyyy') and trunc(sysdate)
    and atendime.cd_multi_empresa = 3
    and pc.tp_cor = null
    and (pc.tp_cor is null or pc.tp_cor = 'S')

  )
  and  (tp_cor is null or tp_cor = 'S');
end;
/
commit;

/*begin 
  pkg_mv2000.Atribui_Empresa(7);
  
  update paciente 
  set tp_cor = 'P'
  where (tp_cor = 'S' or tp_cor is null);
end;
/
commit;*/



