/*select
convenio.nm_convenio NOME_CONVENIO,
remessa_fatura.cd_remessa,
to_char(remessa_fatura.dt_abertura,'DD/MM/YYYY')    DATA_ABERTURA,
to_char(remessa_fatura.dt_fechamento,'DD/MM/YYYY')  DATA_FECHAMENTO,
to_char(remessa_fatura.dt_entrega_da_fatura,'dd/mm/yyyy')  DATA_ENTREGA_FATURA,
itreg_amb.cd_convenio,
convenio.nm_convenio NM_CONVENIO_1,
sum(nvl(itreg_amb.vl_total_conta,0)) vl_total_conta,
tb_fatura.cd_multi_empresa EMP_FILHA,
tb_atendime.cd_multi_empresa EMP_PAI,
(select m.ds_multi_empresa from dbamv.multi_empresas m where m.cd_multi_empresa = tb_fatura.cd_multi_empresa) NOME_EMP_FILHA,
DBAMV.MM_SAR_NFRF(TO_CHAR(remessa_fatura.cd_remessa)) NUMERONF
,TO_CHAR(tb_fatura.dt_competencia,'MMYYYY')
from
dbamv.remessa_fatura,
dbamv.tb_fatura,
dbamv.reg_amb,
dbamv.itreg_amb,
dbamv.convenio,
dbamv.agrupamento ,
dbamv.remessa_fatura remessa_pai,
dbamv.tb_fatura fatura_pai,
dbamv.tb_atendime
where remessa_fatura.cd_fatura = tb_fatura.cd_fatura
and remessa_fatura.cd_remessa = reg_amb.cd_remessa
and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
and tb_atendime.cd_atendimento = itreg_amb.cd_atendimento
and itreg_amb.cd_convenio = convenio.cd_convenio
and convenio.tp_convenio not in ('H','A')
and nvl(itreg_amb.tp_pagamento,'X') <> 'C'
and nvl(itreg_amb.sn_pertence_pacote,'N') = 'N'
and agrupamento.cd_agrupamento(+) = remessa_fatura.cd_agrupamento
and remessa_pai.cd_remessa(+) = remessa_fatura.cd_remessa_pai
and fatura_pai.cd_fatura(+) = remessa_pai.cd_fatura
--and tb_atendime.cd_multi_empresa = P_EMPRESA
--and reg_amb.cd_multi_empresa in (P_FILHA_REGAMB1,P_FILHA_REGAMB2,P_FILHA_REGAMB3)
--and tb_fatura.cd_multi_empresa in (P_FILHA_FAT1,P_FILHA_FAT2,P_FILHA_FAT3)
and TO_CHAR(tb_fatura.dt_competencia,'MMYYYY') = '012016' ----P_COMPETENCIA
and remessa_fatura.sn_fechada = 'S' -- somente remessas fechadas
and itreg_amb.sn_fechada = 'S' -- somente contas fechadas
and remessa_fatura.cd_remessa in (81982,82872,82313)
group by
remessa_fatura.cd_remessa,
remessa_fatura.dt_abertura,
remessa_fatura.dt_fechamento,
remessa_fatura.dt_entrega_da_fatura,
itreg_amb.cd_convenio,
convenio.nm_convenio,
tb_fatura.cd_multi_empresa,
tb_atendime.cd_multi_empresa
,TO_CHAR(tb_fatura.dt_competencia,'MMYYYY')*/


/*select * from dbamv.remessa_fatura a where a.cd_remessa in (83020,83033,83079,81982,82006,82024,82059,82062,82065,82073,82077,82093,82129,82181,82233,82269,82281,82286,
                                                            82298,82308,82315,82332,82367,82400,82402,82474,82475,82480,82483,82489,82492,82516,82524,82527,82549,82556,
                                                            82631,82632,82652,82657,82712,82742,82872,82876,82898,82926,82961,82964,82967,82969,83001,83003,83006,83014,
                                                            83017,83018,97568,83020,83033,83079)
for update                                                             
                
select * from dbamv.itfat_nota_fiscal c where c.cd_remessa in (83020,83033,83079,81982,82006,82024,82059,82062,82065,82073,82077,82093,82129,82181,82233,82269,82281,82286,
                                                            82298,82308,82315,82332,82367,82400,82402,82474,82475,82480,82483,82489,82492,82516,82524,82527,82549,82556,
                                                            82631,82632,82652,82657,82712,82742,82872,82876,82898,82926,82961,82964,82967,82969,83001,83003,83006,83014,
                                                            83017,83018,97568,83020,83033,83079,97727)
for update  
                                            
select * from dbamv.Remessa_Fatura b where b.cd_remessa = 97056                                                            
.

--25756 01/2017
-- 23212 02/2017
--

*/

/*select *
  from dbamv.remessa_fatura, dbamv.tb_fatura
 where remessa_fatura.cd_fatura = tb_fatura.cd_fatura
   and to_char(tb_fatura.dt_competencia, 'MMYYYY') = '022017' ----P_COMPETENCIA

select * from dbamv.remessa_fatura where cd_remessa = 97033

select * from dbamv.fatura where cd_fatura = 25935*/


select * from dbamv.remessa_fatura a where a.cd_remessa in (82662,82313)/*(82872,81982,82006,82024,82059,82062,82065,82073,82077,
            82093,82129,82181,82233,82269,82281,82286,82298,82308,82315,82332,82367,82400,82402,82474,82475,
            82480,82483,82489,82492,82516,82524,82527,82549,82556,82631,82632,82652,82657,82712,82742,82876,83033,82898)*/
order by a.cd_agrupamento  -- 01/2016  , 01/2016(25932)(H), 01/2016 (96127) (A) 
for update 

select * from dbamv.remessa_fatura b where b.cd_remessa in (82926,82961,82964,82967,82969,83001,83003,83006,83014,83017,83018,83020,83079) 
order by b.cd_agrupamento  -- 02/2016 , 02/2016 (23402)(H)  --- 23212 02/2017 -- 23235
for update

select * from dbamv.remessa_fatura c where c.cd_remessa in (82872,82662,82313,82068) -- 
order by c.cd_agrupamento -- 1
for update 




select * from dbamv.fatura d where d.CD_FATURA = 23212 --d.DT_COMPETENCIA = '01/01/2016'
and d.CD_MULTI_EMPRESA = 1
and d.CD_CONVENIO = 10--- d.CD_FATURA in (25932)

select * from dbamv.reg_Fat z where z.cd_reg_fat = 1188712
