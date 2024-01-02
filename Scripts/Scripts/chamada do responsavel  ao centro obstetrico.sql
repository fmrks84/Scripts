select b.NM_PACIENTE,
       a.cd_aviso_cirurgia,
       a.dt_chamada,
       a.tp_chamada,
       a.sn_bip,
       a.sn_fone

  from dbamv.hmsj_chamar_resp a, 
       dbamv.aviso_cirurgia b

 where b.cd_cen_cir = 2
   and a.cd_aviso_cirurgia = b.CD_AVISO_CIRURGIA
   and a.status NOT IN ('C')
   and Trunc(a.dt_chamada) Between To_Date('01/11/2016', 'dd/mm/yyyy')
   and To_Date('27/11/2016', 'dd/mm/yyyy')
 order by 1


/*
select sum (sn_bip)Total_cham_bip,
       sum (sn_fone)Total_cham_tel,
       sum (tp_chamada)Total_cham_painel
from 
(
select b.NM_PACIENTE,
       a.cd_aviso_cirurgia,
       a.dt_chamada,
       decode (a.tp_chamada,'P','1')TP_CHAMADA, 
       a.sn_bip ,
       a.sn_fone

  from dbamv.hmsj_chamar_resp a, 
       dbamv.aviso_cirurgia b

 where b.cd_cen_cir = 2
   and a.cd_aviso_cirurgia = b.CD_AVISO_CIRURGIA
   and a.status NOT IN ('C')
   and Trunc(a.dt_chamada) Between To_Date('28/10/2016', 'dd/mm/yyyy')
   and To_Date('27/11/2016', 'dd/mm/yyyy')
   group by 
       b.NM_PACIENTE,
       a.cd_aviso_cirurgia,
       a.dt_chamada,
       a.tp_chamada,
       a.sn_bip,
       a.sn_fone
)

*/
