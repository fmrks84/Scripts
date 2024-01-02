select * from dbamv.con_rec a where a.nr_documento = '52714';
select * from dbamv.itcon_Rec b where b.cd_con_rec in (501220, 501223)--;
select c.cd_exp_contabilidade from dbamv.reccon_rec c where c.cd_itcon_rec in (505993,505990); --FOR UPDATE
