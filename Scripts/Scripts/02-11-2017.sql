/*REMESSA COM DIFERENCA DE VALOR.

REMESSA:108849-HMSJ CONV�NIO-5 MAR�TIMA
REMESSA :108850-VANGUARDA-CONV�NIO-5 MAR�TIMA

REMESSA:108852-PMP-CONV�NIO-5 MAR�TIMA
REMESSA:108853-VANGUARDA-CONVENIO-5 MAR�TIMA1447035
*/
select * from dbamv.fatura where cd_Fatura = 27657
select * from dbamv.remessa_fatura b where b.cd_remessa in (108849,108850)
select * from dbamv.reg_Fat a where a.cd_remessa = 108849

select *  from dbamv.tiss_nr_guia d where d.cd_reg_fat in (1452064,1444012,1452504,1452327,1451901,1443902)--1447827)
