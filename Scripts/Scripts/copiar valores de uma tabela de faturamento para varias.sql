declare
  --
  cursor c_pro_fat is
  select max(trunc(val.dt_vigencia)) dt_vigencia
         ,val.cd_pro_fat
    from dbamv.val_pro val
   where nvl(val.sn_ativo, 'S') = 'S'
     and val.cd_tab_fat in (292, 293, 294, 296)
    group by val.cd_pro_fat;
  -- cursor para inserir na tabela ajuste que deverá conter a nova tabela --
  cursor c_val_pro(pdt_vigencia in date, pcd_pro_fat in number) is
  select val.dt_vigencia
       ,val.cd_pro_fat 
       ,val.vl_honorario
       ,val.vl_operacional
    --   ,case when val.cd_tab_fat in (292,293) then val.vl_total*1.2 else val.vl_total end vl_total
       ,val.vl_total
    from dbamv.val_pro val
    where cd_pro_fat = pcd_pro_fat
    and dt_vigencia = pdt_vigencia
    and nvl(val.sn_ativo, 'S') = 'S'
    and val.cd_tab_fat in (292, 293, 294, 296);
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
          (465,
           r_pro_fat.cd_pro_fat,
           '25/10/2017',
           r_val_pro.vl_honorario,
           r_val_pro.vl_total,
           'S');
        --   
        --commit;
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
