select 
a.cd_cirurgia,
a.cd_pro_fat,
(select pf1.ds_pro_fat from dbamv.pro_Fat pf1 where pf1.cd_pro_fat = a.cd_pro_fat)ds_pro_fat_pacote,
b.cd_pacote,
b.cd_pro_fat_pacote,
c.cd_gru_pro,
d.ds_gru_pro,
c.cd_pro_fat,
(select pf.ds_pro_fat from dbamv.pro_Fat pf where pf.cd_pro_fat = c.cd_pro_fat)ds_pro_fat,
c.cd_setor,
c.cd_tip_acom,
b.cd_multi_empresa,
b.cd_convenio,
b.cd_con_pla
 
from 
dbamv.cirurgia a 
inner join dbamv.pacote b on b.cd_pro_fat = a.cd_pro_fat
left join dbamv.pacote_excecao c on c.cd_pacote = b.cd_pacote
left join dbamv.gru_pro d on d.cd_gru_pro = c.cd_gru_pro
where a.cd_pro_fat = 31009336--1 =1 --b.tp_cobranca_pac_secund = 'V' 
--AND a.cd_pro_fat = 30907136--30912032
and a.sn_ativo = 'S'
and b.cd_multi_empresa in (3,4,7,10,25)
and b.dt_vigencia_final is null
--and b.cd_convenio = 07
order by b.cd_multi_empresa,
         b.cd_convenio,
         b.cd_con_pla
       --  b.cd_pacote,
       --  a.cd_cirurgia,
      --   c.cd_gru_pro
         
---                  
/*FORA DO PACOTE 
E O QUE HÁ PROIBIÇÃO */
--------------
-- 
--select * FROM all_tab_columns z where Z.column_name like '%CD_PACOTE%'
