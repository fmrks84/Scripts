declare
  cursor x is
    select *
      from filme_tab
     where cd_tab_fat = 3; ---and cd_pro_fat like '33%'; -- Copiar de:
begin
  for i in x
  loop
    begin
      insert into filme_tab
        (cd_tab_fat, cd_pro_fat, dt_vigencia, nr_incidencias, qt_m2_filme)
      values
        (458, i.cd_pro_fat, '01/01/2016', i.nr_incidencias, i.qt_m2_filme);
      commit;
    exception
      when dup_val_on_index then
        null;
    end;
  end loop;
end;

