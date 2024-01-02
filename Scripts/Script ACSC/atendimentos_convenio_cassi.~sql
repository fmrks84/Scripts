select 
case when a.tp_atendimento = 'I' then 'INTERNACAO'
     when a.tp_atendimento = 'U' then 'URGENCIA'
     when a.tp_atendimento = 'E' then 'EXTERNO'
     END TP_ATENDIMENTO,
a.cd_atendimento,
a.cd_ori_ate||' - '||c.ds_ori_ate origem_Atendimento,
b.nm_paciente,
a.dt_atendimento,
a.dt_alta,
a.cd_pro_int,
(select x.ds_pro_fat from pro_Fat x where x.cd_pro_fat = a.cd_pro_int)proced_atendimento
from 
atendime a
inner join paciente b on b.cd_paciente = a.cd_paciente
inner join ori_ate c on c.cd_ori_ate = a.cd_ori_ate
where a.cd_convenio = 80
and a.dt_atendimento BETWEEN '01/08/2018' and SYSDATE 
ORDER BY  A.DT_ATENDIMENTO
