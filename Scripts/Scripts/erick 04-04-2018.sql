/*CR - 495316 (CONTA CONTABIL CORRETA 1561)
CR - 495742 (CONTA CONTABIL CORRETA 1561)
CR - 496298 (CONTA CONTABIL CORRETA 1561)
CR - 500421 (CONTA CONTABIL CORRETA 1561)
*/
select * from dbamv.con_Rec a where a.cd_con_rec in (495316,495742,496298,500421);
select * from dbamv.itcon_rec b where b.cd_con_rec in (495316,495742,496298,500421);
select * from dbamv.reccon_rec c where c.cd_itcon_rec in (499839,500280,500859,505176);
select * from dbamv.rat_conrec d where d.cd_con_rec in (495316,495742,496298,500421)
