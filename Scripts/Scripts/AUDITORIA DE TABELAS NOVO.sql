select *
         from dbamv.audit_tabela b,
              dbamv.audit_coluna c 
where 1 =1 
and b.cd_tabela = c.cd_tabela
and b.cd_audit_tabela = c.cd_audit_tabela
and b.cd_tabela = 'PRO_FAT'
and c.chave_primaria in ('00017090')--('00017004','00017004','00017002','00017005','00017836','00017837','0000170900017123','00017124')--''
and c.coluna = 'TP_SERV_HOSPITALAR'
--and b.tp_transacao = 'U'
order by b.dt_transacao desc 
--select * from dbamv.pro_Fat a where a.cd_pro_fat = '00017090'
--select * from dbamv.Mov_Concor b where b.cd_mov_concor = 925224--b.dt_movimentacao = '31/10/2017'-- b.ds_movimentacao = 
