declare
  cursor c_config is
    select cd_especie, cd_classe, cd_gru_fat, 428 cd_setor  -- destino 
      from dbamv.configu_importacao_gru_fat
     where cd_especie = 1 ---- origem 
       and cd_setor = 127; --- setor de origem 
  nExiste number;
begin
  --
  for r_config in c_config
  loop
    --
    select count(*)
      into nexiste
      from dbamv.configu_importacao_gru_fat
     where cd_especie = r_config.cd_especie
       and cd_classe = r_config.cd_classe
       and cd_gru_fat = r_config.cd_gru_fat
       and cd_setor = r_config.cd_setor;
    --
    If nExiste = 0 then
      --
      insert into dbamv.configu_importacao_gru_fat
        (cd_especie, cd_classe, cd_gru_fat, cd_setor, cd_conf_import)
      values
        (r_config.cd_especie,
         r_config.cd_classe,
         r_config.cd_gru_fat,
         r_config.cd_setor,
         dbamv.seq_conf_import.nextval);
      --   
    end if;    
  --
  end loop;
  --
end;

-- Se der tudo certo, fazer o commit
