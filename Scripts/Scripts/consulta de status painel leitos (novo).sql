select * from dbamv.hmsj_historico_movimento where CD_atendimento = 1936459 ORDER BY DH_HISTORICO_MOVIMENTO DESC FOR UPDATE  -- cd_atendimento = 987026 and status ='A'FOR UPDATE 
select * FROM DBAMV.HMSJ_SOLIC_TRANSF_LEITO WHERE CD_ATENDIMENTO = 1936459 ORDER BY DH_SOLIC_TRANSF_LEITO --DESC FOR UPDATE 993041 AND STATUS = 'A' FOR UPDATE 

select * from dbamv.mov_int where cd_leito = 128 order by dt_mov_int desc for update
select * from dbamv.leito where cd_leito = 128

select * from dbamv.hmsj_p
