select * from pacote pc where pc.cd_pro_fat_pacote = 10001662
select * from pro_Fat where cd_pro_fat = '02037628'

select xp.cd_tab_fat,
       xp.cd_pro_fat,
       xp.dt_vigencia,
       xp.vl_total
        from val_pro xp where xp.cd_pro_fat in(
select cd_pro_fat from pro_Fat where cd_pro_fat in
 (select pc.cd_pro_fat from pacote pc where pc.cd_pro_fat_pacote = 10001662))
 and trunc(dt_vigencia) = (select max(xx.dt_vigencia) from val_pro xx where xx.cd_pro_fat = xp.cd_pro_fat and xx.cd_tab_fat = xp.cd_tab_fat)
 
 
 select * from val_pro where cd_pro_fat = '10001662'

-- 4553553 atend dev1



select * from produto where cd_pro_fat in (02037628,02037627)

select * from est_pro where cd_produto in (2037628,2037627)

select 
 p.cd_pro_fat,
 p.cd_pro_fat_pacote,
 pf.ds_pro_fat,
 p.dt_vigencia,
 vp.vl_total
 from pacote p
 inner join pro_fat pf on pf.cd_pro_fat = p.cd_pro_fat_pacote
 inner join val_pro vp on vp.cd_pro_fat = p.cd_pro_fat_pacote
 where trunc(vp.dt_vigencia) = (select max(x.dt_vigencia) from val_pro x where x.cd_pro_fat = vp.cd_pro_fat and vp.cd_tab_fat = x.cd_tab_fat)
 and p.cd_pro_fat in (02037628,02037627)
and p.dt_vigencia_final is  null 
and p.cd_convenio = 40 
order by 2 
