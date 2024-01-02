select cd_atendimento,
       cd_reg_fat,
       cd_pro_Fat,
       cd_conta_pai conta_mae,
       trunc (hr_lancamento),  --- FILTRO (DT LANCAMENTO) (INCIO E FIM)
       cd_remessa,
       DT_COMPETENCIA,
       nr_guia,
       nr_carteira,
       qt_lancamento,
       sn_fechada,
       decode (cd_multi_empresa, '1', 'HMSJ' , '2', 'PMP')EMPRESA --- FILTRO POR EMPRESA      
from (       
select a.cd_atendimento,
       b.cd_reg_fat,
       b.cd_conta_pai,
       a.cd_remessa,
       d.DT_COMPETENCIA,
       b.cd_pro_fat,
       b.qt_lancamento,
       b.hr_lancamento,
       e.nr_guia,
       f.nr_carteira,
       a.sn_fechada,
       a.cd_multi_empresa
from dbamv.reg_Fat a 
inner join dbamv.itreg_fat b on b.cd_conta_pai = a.cd_reg_fat
inner join dbamv.Remessa_Fatura c on c.cd_remessa = a.cd_remessa
inner join dbamv.fatura d on d.cd_fatura = c.cd_fatura
inner join dbamv.guia e on e.cd_atendimento = a.cd_atendimento
inner join dbamv.tb_atendime f on f.cd_atendimento = a.cd_atendimento
where 1 =1 --a.cd_atendimento = 1403276 ---b.cd_reg_fat in(1261768,1261828)
and trunc (b.hr_lancamento) between '01/06/2016' and '31/10/2016'
and b.cd_pro_fat = 00030023
and e.tp_guia = 'I'
group by 
       a.cd_atendimento,
       b.cd_reg_fat,
       b.cd_conta_pai,
       a.cd_remessa,
       d.DT_COMPETENCIA,
       b.cd_pro_fat,
       b.qt_lancamento,
       b.hr_lancamento,
       e.nr_guia,
       f.nr_carteira,
       a.sn_fechada,
       a.cd_multi_empresa
)
group by 
      cd_atendimento,
      cd_reg_fat,
      cd_pro_fat,
      cd_conta_pai,
      hr_lancamento,
      cd_remessa,
      DT_COMPETENCIA,
      qt_lancamento,
      nr_guia,
      nr_carteira,
      sn_fechada,
      cd_multi_empresa
----  MOSTRAR NA IMAGEM DO LAYOUT  COD_PROCEDIMENTO   E EMPRESA QUE ESTA SENDO CONSULTADA  
-----TRAZER NO LAYOUT DO RELATORIO  (CD_ATENDIMENTO , CD_REG_fAT, CONTA_MAE, NR_CARTEIRA, DT_LANCAMENTO,QT_LANCAMENTO,)




/*select distinct a.cd_atendimento,
       b.cd_reg_fat CD_CONTA,
       a.cd_remessa NR_REMESSA,
       e.DT_COMPETENCIA,
       b.cd_pro_fat CD_PROCEDIMENTO,
       b.hr_lancamento,
       G.NR_GUIA NR_GUIA_INTERNACAO,
       c.nr_carteira,
       decode(a.cd_multi_empresa,'1','HMSJ','2','PROMATRE')EMPRESA,
       a.sn_fechada FECHADA 
       
from dbamv.reg_Fat a 
inner join dbamv.itreg_Fat b on b.cd_reg_fat = a.cd_reg_fat 
inner join dbamv.Tb_Atendime c on c.cd_atendimento = a.cd_atendimento
inner join dbamv.remessa_Fatura d on d.cd_remessa = a.cd_remessa
inner join dbamv.fatura e on e.CD_FATURA = d.cd_fatura
inner join dbamv.multi_empresas f on f.cd_multi_empresa = a.cd_multi_empresa
inner join dbamv.guia g on g.cd_atendimento = a.cd_atendimento
where b.cd_pro_Fat = 00030023
--and b.cd_reg_fat = 1260991--1260545
and g.tp_guia = 'I'
and  trunc (b.hr_lancamento) between '01/06/2016' and '01/06/2016'
and a.cd_multi_empresa in (1)
order by 2*/


