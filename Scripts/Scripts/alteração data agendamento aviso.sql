select * from dbamv.age_cir c where c.cd_aviso_cirurgia = 404836 for update         -- 1�
select * from dbamv.cirurgia_aviso b where b.cd_aviso_cirurgia = 404836 for update ;-- 2�
select * from dbamv.aviso_cirurgia a where a.CD_AVISO_CIRURGIA = 404836 for update ;-- 3�
