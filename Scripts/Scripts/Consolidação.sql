select * from dbamv.log_erro_ent_pro
delete from dbamv.log_erro_ent_pro
select * from dbamv.itent_pro where cd_custo_medio not in ( select cd_custo_medio from dbamv.custo_medio)
begin
dbamv.pkg_mv2000.atribui_empresa(2);
dbamv.prc_mges_custo_diario (sysdate, null, null );
commit;
end;
commit
alter trigger dbamv.trg_chk_custo_medio enable
alter trigger dbamv.trg_chk_custo_medio disable


select * from custo_medio where cd_custo_medio = 971798
