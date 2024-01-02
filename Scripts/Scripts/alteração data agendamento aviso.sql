select * from dbamv.age_cir c where c.cd_aviso_cirurgia = 404836 for update         -- 1º
select * from dbamv.cirurgia_aviso b where b.cd_aviso_cirurgia = 404836 for update ;-- 2º
select * from dbamv.aviso_cirurgia a where a.CD_AVISO_CIRURGIA = 404836 for update ;-- 3º
