update dbamv.atendime set cd_mot_alt = 35
where cd_atendimento in (
select cd_atendimento ---, cd_pro_int, cd_paciente, cd_pro_int_procedimento_entrad,  DT_ATENDIMENTO, cd_ssm_cih,  cd_mot_alt, dt_alta
from  dbamv.atendime x
where tp_atendimento = 'I'
and   cd_pro_int_procedimento_entrad in ('45080097','45080194','45080186','45080020')
and   dt_alta is not null
and   cd_mot_alt = 1
and   dt_alta >= '01-out-2010'
and   dt_alta < '01-nov-2010'
and   cd_multi_empresa = 1
)



update dbamv.atendime 
set   cd_mot_alt = 35
where cd_pro_int_procedimento_entrad = '45080186' 
and   cd_pro_int in ('45080097','45080194','45080186','45080020','00020010')
and   cd_mot_alt = 1
and   cd_multi_empresa = 1





select cd_pro_int, cd_paciente, cd_pro_int_procedimento_entrad, dt_atendimento
     , hr_atendimento, cd_ssm_cih,  cd_mot_alt, dt_alta, hr_alta, dt_alta_medica, hr_alta_medica
     ,cd_atendimento, cd_atendimento_pai
from   dbamv.atendime 
where  cd_paciente in () ---(215060)---(186886,206751,214323,183209,200912,68690,211649,203930,18038,213983,215003)
and    tp_atendimento = 'I'
ORDER BY DT_ALTA DESC

select * from dbamv.admissao_co where cd_atendimento = 457710
select * from dbamv.recem_nascido where cd_admissao_co = 77122


select cd_pro_int, cd_paciente, cd_pro_int_procedimento_entrad, dt_atendimento
     , hr_atendimento, cd_ssm_cih,  cd_mot_alt, dt_alta, hr_alta, cd_atendimento
     , cd_atendimento_pai 
from dbamv.atendime where cd_atendimento in (592968,593146,593253,597590,597607,598090)

Begin
  Pkg_Mv2000.Atribui_Empresa( 2 );  -->> Trocar a empresa e rodar uma vez para cada empresa
End;

select  cd_pro_int, cd_paciente, cd_pro_int_procedimento_entrad, dt_atendimento
     , hr_atendimento, cd_ssm_cih,  cd_mot_alt, dt_alta, hr_alta, cd_atendimento
     , cd_atendimento_pai 
from dbamv.atendime
where cd_atendimento in (571221)  
order by dt_atendimento


--(600013,600622,600932,601841,601915,602623,602436,602729,602690,602656,604044)  
--(594269,594733,595552,595722,595679,596685,596310,596910,597334,597590,597607,597954,598090,598416,598615
--                       , 599267,599389,599579,599806,599868,554815,580553,582859,583104,583562,583731,586918,587505
--                       , 587631,587672,588253,588219,590573,591079,591131,591556,592483,592516,592968
--                       , 593146,593253,593565,594023)  

select * from dbamv.atendime where cd_atendimento = 571221



and dt_alta is not null
order by dt_atendimento desc, cd_paciente
