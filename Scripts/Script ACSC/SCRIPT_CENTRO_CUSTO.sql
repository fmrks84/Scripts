/*select * from gru_pro x order by x.cd_gru_pro desc 

select * from pro_Fat where cd_gru_pro = 57
--SELECT * FROM PRO_FAT P WHERE P.DS_PRO_FAT LIKE '%ROBO%'--P.CD_PRO_FAT IN ('98906230','98906244')

select * from produto pr where pr.cd_produto = 2041178

*/
--84487,84488


--;
--99
select
distinct 
pf.cd_gru_pro
from
Gru_pro gp 
inner join pro_Fat pf on pf.cd_gru_pro = gp.cd_gru_pro
order by 1
;
select cd_gru_pro from gru_pro 

order by cd_gru_pro

;
select * from pro_fat where  CD_PRO_FAT = '02037628'--cd_gru_pro in
( 
select 
cd_Gru_pro from 
gru_pro where cd_Gru_pro in
(71,73,74,75,76,
77,78,82,83
));

select 
cd_Gru_pro,
ds_Gru_pro
from 
gru_pro where cd_Gru_pro in
(71,73,74,75,76,
77,78,82,83) --- usar 71,73
;


select  distinct cpla.cd_regra  from empresa_con_pla cpla where cpla.cd_convenio = 40 --and cpla.cd_con_pla = 1


select distinct
      itregra.cd_tab_fat ,
       tab_Fat.Ds_Tab_Fat
from itregra, tab_Fat 
where  tab_Fat.Cd_Tab_Fat = itregra.cd_tab_fat
and itregra.cd_regra in 
(42,245,271,66,21,35,268,56,238)and 
cd_gru_pro in (71,73,74,75,76,
77,78,82,83) -- Criar tabela de faturamento rob�tica 



SELECT * FROM GRU_PRO where cd_gru_pro in (71)-- FOR UPDATE --,73,74,75,76,
77,78,82,83)
select * from convenio where cd_convenio = 43
;

-- AVISO = 332295,332296,332299
--- PACIENTE 21779,1144862,1147189
-- ATEND: 4579853,4579854,4579855,4579856
-- PRODUTO: 2037636
SELECT * FROM AVISO_CIRURGIA WHERE CD_AVISO_CIRURGIA = 332296
SELECT * FROM Cirurgia_Aviso WHERE CD_AVISO_CIRURGIA = 332296

select * from pacote pc where pc.cd_pro_fat = 02037636
and pc.dt_vigencia_final is null
and pc.cd_convenio = 40
order by pc.cd_pro_fat_pacote  ---cd_pro_fat_pacote = 10001662
;



select cd_pro_fat from produto where cd_produto in (84487,84488)

select * from pro_Fat where cd_pro_fat in ('02037636')
--ds_pro_Fat like upper ('%Pinca%Bipolar%Maryland%')--cd_pro_fat in ('02037628')

select * from gru_pro where cd_gru_pro in (95,96);
select * from itreg_fat where cd_pro_Fat in ('02037636','00285886','02038234','02038235')
select * from pro_Fat where cd_pro_FAt in ('02037636','00285886','02038234','02038235')
select * from produto where cd_pro_fat in 
('02037636'/*,'00285886','02038234','02038235'*/)

select * from est_pro where cd_produto = 2037636

--    

select 
vpx.cd_tab_fat,
tb.ds_tab_fat,
vpx.cd_pro_fat,
vpx.dt_vigencia,
vpx.vl_total
from val_pro vpx
inner join tab_fat tb on tb.cd_tab_fat = vpx.cd_tab_fat
where vpx.cd_pro_Fat in ('02037636')
and tb.ds_tab_fat like '%HSC%'
and vpx.dt_vigencia = (select max(vpxx.dt_vigencia)from val_pro vpxx where vpxx.cd_tab_fat = vpx.cd_tab_fat and vpxx.cd_pro_fat = vpx.cd_pro_fat)
order by vpx.cd_pro_fat, vpx.cd_tab_fat
--- USAR TABELA 2 - HSC _MATERIAIS_SIMPRO



select * from pro_Fat where cd_pro_fat = '71000001'

select * from pacote where cd_pro_Fat = 40801055
delete from pacote_excecao where cd_pacote in (select cd_pacote from pacote where cd_pro_Fat = 02037636)

select * from pacote_excecao_procedimento wu where wu.cd_pro_fat in (02037636)

select * from produto where cd_produto = 2037636


2037636


select * from gru_pro where cd_gru_pro = 99 for update 
