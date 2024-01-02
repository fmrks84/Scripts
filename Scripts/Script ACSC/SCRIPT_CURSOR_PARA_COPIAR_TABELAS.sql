declare
  cursor x is
    select *
      from acresc_descontos_proc
     where cd_regra = 55; ---and cd_pro_fat like '33%'; -- Copiar de:
begin
  for i in x
  loop
    begin
      insert into acresc_descontos_proc
        (cd_pro_fat,
       cd_regra,
       vl_perc_acrescimo,
       vl_perc_desconto,
       tp_atend_ambulatorial,
       tp_atend_externo,
       tp_atend_internacao,
       tp_atend_urgeme,
       ds_desconto,
       ds_acrescimo,
       sn_vl_filme,
       sn_vl_honorario,
       sn_vl_operacional,
       tp_atend_homecare,
       sn_destacar_na_fatura,
       vl_perc_acrescimo_exame,
       ds_acrescimo_exame,
       dt_inicio_vigencia,
       dt_final_vigencia)
      values
        (i.cd_pro_fat,
       336,
       i.vl_perc_acrescimo,
       i.vl_perc_desconto,
       i.tp_atend_ambulatorial,
       i.tp_atend_externo,
       i.tp_atend_internacao,
       i.tp_atend_urgeme,
       i.ds_desconto,
       i.ds_acrescimo,
       i.sn_vl_filme,
       i.sn_vl_honorario,
       i.sn_vl_operacional,
       i.tp_atend_homecare,
       i.sn_destacar_na_fatura,
       i.vl_perc_acrescimo_exame,
       i.ds_acrescimo_exame,
       i.dt_inicio_vigencia,
       i.dt_final_vigencia);
      commit;
    exception
      when dup_val_on_index then
        null;
    end;
  end loop;
end;



/*select i.cd_pro_fat,
       i.cd_regra,
       i.vl_perc_acrescimo,
       i.vl_perc_desconto,
       i.tp_atend_ambulatorial,
       i.tp_atend_externo,
       i.tp_atend_internacao,
       i.tp_atend_urgeme,
       i.ds_desconto,
       i.ds_acrescimo,
       i.sn_vl_filme,
       i.sn_vl_honorario,
       i.sn_vl_operacional,
       i.tp_atend_homecare,
       i.sn_destacar_na_fatura,
       i.vl_perc_acrescimo_exame,
       i.ds_acrescimo_exame,
       i.dt_inicio_vigencia,
       i.dt_final_vigencia from acresc_descontos_proc i  where cd_regra = 335

select * from regra where cd_regra = 335*/

select * from acresc_descontos_proc x where x.cd_regra = 336
