select distinct 
       a.cd_atendimento ATENDIMENTO,
       e.nm_paciente,
       e.nr_identidade DOCUMENTO,
       d.DT_ATENDIMENTO DT_ATEND,
       d.DT_ALTA DT_ALTA,
       f.nm_prestador PRESTADOR,
       g.ds_pro_fat PROCEDIMENTO, 
       b.cd_con_rec CONTAS_RECEBER , 
       c.vl_duplicata VALOR, 
       decode(c.tp_quitacao, 'C', 'COMPROMETIDO', 'Q','QUITADO','P','PARCIALMENTE QUITADO', 'V','PREVISTO') AS TP_QUITACAO 
       --c.nr_parcela,
       --c.dt_vencimento
                   
from   dbamv.reg_fat a,
       dbamv.con_Rec b,
       dbamv.itcon_rec c,
       dbamv.atendime d,
       dbamv.paciente e,
       dbamv.prestador f,
       dbamv.pro_fat g
where a.sn_fechada = 'S' 
and a.cd_pro_fat_solicitado = g.cd_pro_fat
and a.cd_reg_fat = b.Cd_Reg_Fat   
and b.cd_con_rec = c.cd_con_rec
and a.cd_atendimento = d.CD_ATENDIMENTO
and d.CD_PACIENTE = e.cd_paciente
and d.CD_PRESTADOR = f.cd_prestador
and a.cd_convenio = 352 -- (352 Particular Santa Joana  , 379 Particular Promatre)
and d.DT_ATENDIMENTO between '01/02/2016' and '29/02/2016'
and a.cd_multi_empresa = '1' -- (1 - SANTA JOANA , 2 - PROMATRE)
and c.tp_quitacao = 'Q' -- (C-COMPROMETIDO , Q-QUITADO) 
order by e.nm_paciente 

