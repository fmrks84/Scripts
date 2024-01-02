declare
  --
  cursor c_pro_fat is
    select max(trunc(val.dt_vigencia)) dt_vigencia, val.cd_pro_fat
      from dbamv.val_pro val, dbamv.val_pro val2
     where nvl(val.sn_ativo, 'S') = 'S'
       and val.cd_tab_fat in (292, 293, 294, 296/*,355*/)
       and val2.cd_tab_fat = 321 -- tabela destino
       and val2.cd_pro_fat = val.cd_pro_fat
       and nvl(val2.sn_ativo, 'S') = 'S'
    group by val.cd_pro_fat;
  --
  cursor c_val_pro(pdt_vigencia in date, pcd_pro_fat in number) is
    select val.vl_honorario, val.vl_operacional, val.vl_total
      from dbamv.val_pro val, dbamv.val_pro val2
     where nvl(val.sn_ativo, 'S') =
           decode('S', 'T', nvl(val.sn_ativo, 'S'), 'S')
       and val.cd_tab_fat in (292, 293, 294, 296/*,355*/)
       and val.dt_vigencia = pdt_vigencia
       and val.cd_pro_fat = pcd_pro_fat
       and val2.cd_tab_fat = 321 -- tabela destino
       and val2.cd_pro_fat = val.cd_pro_fat;
  --
begin
  --
  for r_pro_fat in c_pro_fat
  loop
    --
    for r_val_pro in c_val_pro(r_pro_fat.dt_vigencia, r_pro_fat.cd_pro_fat)
    loop
      --
      begin
        insert into dbamv.val_pro
          (cd_tab_fat,
           cd_pro_fat,
           dt_vigencia,
           vl_honorario,
           vl_total,
           sn_ativo)
        values
          (321,
           r_pro_fat.cd_pro_fat,
           '01/12/2017',
           r_val_pro.vl_honorario,
           r_val_pro.vl_total,
           'S');
        --   
        commit;
        --
      exception
        when dup_val_on_index then
        
          null;
      end;
    
    end loop;
    --
  end loop;
  --
end;
