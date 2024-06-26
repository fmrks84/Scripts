select * from dbamv.estrutura_srv a where a.cd_id_estrutura_srv in (1097,1455,1493)--for update --;
select * from dbamv.config_proto b  where b.cd_id_estrutura_srv IN (1097,1455,1493) AND b.cd_multi_empresa = 3
 for update 
select c.cd_config_proto  from dbamv.config_proto c where c.cd_id_estrutura_srv = 1056
order by c.cd_config_proto desc 
2429

select * from dbamv.config_proto 
where cd_hospital = 719
and cd_id_estrutura_srv in (1154,1155)
and cd_multi_empresa in (1,2,3,4,5)
and ds_id_cliente = 414492
order by cd_config_proto desc  -- 2780
for update 

-- codigo referencia do fabricante
select cd_ref_fabricante from tuss where cd_pro_fat = :par4 and cd_ref_fabricante is not null and rownum =1  
-- paramentro query alternativa guia sadt convenio 170 empresa 4   
select case when :val = '12' then '00' else :val end from dbamv.itreg_amb where cd_pro_fat in ('40202666','40202712') and cd_prestador = 18038 and cd_atendimento = :par1
------ tipo de faturamento 
select case when tp_classificacao_Conta = 'C' then '3' else :val end from reg_Fat where cd_reg_Fat = :par2
-------------- fila de oncologia 
select case when :val = '225275' then '225125' when :val = '225121' then '225125' else :val end from dual
-- 2647631 atendime empresa 3 - internado  dev1 - convenio bradesco 
-- 2658443 atendime empresa 3 - urgencia   dev1 
--select case when :val = '225275' then '225125' else :val end from dual
select case when :val IN ('225203','225275','225121') then '225125' else :val end from dual 

select case when :val = then '1' else :val from itreg_Fat  where cd_gru_fat = 98 
-- 1 c
--select case when :val = '225275' then '225125' when :val = '225121' then '225125' else :val end from dual -- 2
-- conta teste ambu dev3 2192044 
-- conta teste hosp dev3 297043
select prt.cd_prestador, em.cd_especialid from prestador prt
inner join esp_med em on prt.cd_prestador = em.cd_prestador
where prt.sn_atuante = 'S'
and em.cd_especialid in (5,15,45)
and prt.cd_multi_empresa = 3

---select * from cbo_especialidade where cd_cbo in ('225203','225275','225121')
--select * from especialid where cd_cbos in ('225203','225275','225121')

select case when :val in ('225125')end from dbamv.atendime a , dbamv.esp dual 
--- query alternativa criada dia 09/09/2021 referente para guia de consultar campo cbos trazer o cbos da especilidade do atendimento
select case when :val = :val then CD_CBOS_ATENDIMENTO end from VW_ACSC_QUERY_ALT_CBOS_CONS where CD_ATENDIMENTO = :par1 and cd_prestador = :par4
--select * from VW_ACSC_QUERY_ALT_CBOS_CONS x where x.CD_ATENDIMENTO = 3100584;

select case when :val  from tuss t where t.cd_tip_tuss = 98

select 475285
--- query alternativa de tipo de faturamento 
select decode (tp_classificacao_conta, 'P',1,'N',2,'C',3,4) from reg_fat where cd_reg_fat = :par2
select decode (tp_classificacao_conta, 'P',1,'N',2,'C',3,4) from reg_Fat where cd_reg_fat = :par2
select decode (cd_tipo_internacao, 'P',1,'N',2,'C',3,4) from atendime where cd_atendimento = :par1

---- problema no id_it_envio 09-11-2022
(18-ReferÍncia do material no fabricante
select cd_ref_fabricante from tuss where cd_pro_fat = :par4 and cd_ref_fabricante is not null and rownum =1)

---- caracter atendimento amil hsc
select decode (cd_tipo_internacao, '1',2,'2',2,'3',1,'4',1,'7',1,1) from atendime where cd_atendimento = :par1

