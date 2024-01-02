declare
cursor x is
select * from val_pro where cd_tab_fat = 384; ---and cd_pro_fat like '33%'; -- Copiar de:
begin
    for i in x loop
    insert into val_pro(CD_TAB_FAT,CD_PRO_FAT,DT_VIGENCIA,VL_HONORARIO,
    VL_OPERACIONAL,VL_TOTAL,CD_IMPORT,VL_SH,VL_SD,QT_PONTOS,
    QT_PONTOS_ANEST,SN_ATIVO,NM_USUARIO,DT_ATIVACAO)
    VALUES
    (454,i.CD_PRO_FAT,i.DT_VIGENCIA,i.VL_HONORARIO, --- Para
    i.VL_OPERACIONAL,i.VL_TOTAL,i.CD_IMPORT,i.VL_SH,i.VL_SD,i.QT_PONTOS,
    i.QT_PONTOS_ANEST,i.SN_ATIVO,i.NM_USUARIO,i.DT_ATIVACAO);
    end loop;
end;

--select * from val_pro where cd_tab_fat = 361 and cd_pro_fat like '33%'

