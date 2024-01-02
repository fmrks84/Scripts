select * from reg_amb where cd_reg_amb in (7422726,
7416881,
7451339,
7433225)

select * from itreg_amb where cd_reg_amb in (7422726,
7416881,
7451339,
7433225)

select * from atendime where cd_atendimento in (8217291,
8223726,
8235490,
8255735)


select * from remessa_fatura where cd_remessa = 472908
select * from fatura where cd_fatura = 18716 --for update

select b.cd_atendimento, b.cd_reg_amb from reg_amb  a
inner join itreg_amb b on b.cd_reg_amb = a.cd_reg_amb
where a.cd_remessa = 472908

select * from itfat_nota_fiscal c where c.cd_remessa = 472908
select * from nota_fiscal d where d.cd_nota_fiscal = 697924

select * from DBAMV.V_TISS_STATUS_PROTOCOLO z where z.cd_remessa = 472908
select * from tiss_mensagem z1 where z1.nr_lote = 11486 and z1.cd_convenio = 20 and z1.nr_documento = 472908
