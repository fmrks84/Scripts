SELECT *
FROM APAC
WHERE NR_APAC IN
(3323204256130)
--and cd_fat_sia = 342

select * from dbamv.eve_siasus where cd_apac in (126394);

;

delete from dbamv.apac where cd_apac = 90702;
commit;

