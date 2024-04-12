select decode (cd_ori_ate,1,'04',2,'03',3,'23',4,'23',5,'23',
6,'03',9,'04',10,'04',11,'23',12,'03',13,'23',14,'03',16,'23',
17,'23',18,'03',19,'03',20,'04',22,'03',23,'03',24,'03',62,'03'
,63,'04',64,'04',65,'04',66,'03',67,'03',68,'03',101,'04',121,'13',
541,'13',561,'04',601,'04',602,'04',621,'04',622,'04',721,'04',741,'04'
,821,'13') from atendime where cd_atendimento = :par1
;

select 
ori.cd_ori_ate,
ori.ds_ori_ate,
case when ori.cd_ori_ate in (1,9,10,20,63,64,65,101,561,601,602,621,622,721,741) then '04'
     when ori.cd_ori_ate in(2,6,12,14,18,19,22,23,24,62,66,67,68) then '03'
     when ori.cd_ori_ate in (3,4,5,11,13,16,17) then '23'
     when ori.cd_ori_ate in (121,541,821) then '13'
     end tp_Atendimento ,
ori.tp_origem
from 
ori_ate ori 
where ori.cd_multi_empresa = 7 
and ori.tp_origem not in ('I')
order by 1 


select * from tiss_guia tg where tg.nr_guia = '457721' and tg.cd_convenio = 9
