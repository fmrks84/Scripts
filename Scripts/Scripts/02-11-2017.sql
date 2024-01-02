/*REMESSA COM DIFERENCA DE VALOR.

REMESSA:108849-HMSJ CONVÊNIO-5 MARÍTIMA
REMESSA :108850-VANGUARDA-CONVÊNIO-5 MARÍTIMA

REMESSA:108852-PMP-CONVÊNIO-5 MARÍTIMA
REMESSA:108853-VANGUARDA-CONVENIO-5 MARÍTIMA1447035
*/
select * from dbamv.fatura where cd_Fatura = 27657
select * from dbamv.remessa_fatura b where b.cd_remessa in (108849,108850)
select * from dbamv.reg_Fat a where a.cd_remessa = 108849

select *  from dbamv.tiss_nr_guia d where d.cd_reg_fat in (1452064,1444012,1452504,1452327,1451901,1443902)--1447827)
