select decode (r.cd_multi_empresa, 7, 'HSC', 3, 'CSSJ', 1, 'HMRP') empresa, 
       i.cd_atendimento, 
       a.dt_Atendimento, 
       c.nm_convenio,
(case
                  when (select count(*)
                          from itreg_amb ie
                         where ie.cd_reg_amb = r.cd_reg_amb
                           and ie.sn_pertence_pacote = 'S') > 0 then
                   'S'
                  else
                   'N'
                end) possui_pacote,
        r.cd_reg_amb conta,
        r.cd_remessa,
        rf.dt_abertura,
        r.dt_lancamento dt_abertura,
        r.dt_lancamento_final,
        r.vl_total_conta vl_faturado,
(select sum(i2.vl_total_conta) from itreg_amb i2 where i2.cd_reg_amb = r.cd_reg_amb and i.sn_pertence_pacote = 'N' and cd_conta_pacote is null)vl_fora_pacote,
(select sum(i3.vl_total_conta) from itreg_amb i3 where i3.cd_reg_amb = r.cd_reg_amb)vl_total,
        i.cd_pro_fat,
        p.ds_pro_fat,
        g.ds_gru_fat,        
        i.qt_lancamento,
        i.vl_total_conta vl_item
from reg_amb r, itreg_amb i, convenio c, pro_fat p, atendime a, remessa_fatura rf, gru_fat g
where r.cd_reg_amb = i.cd_reg_amb
and   r.cd_convenio = c.cd_convenio
and   i.cd_pro_fat = p.cd_pro_fat
and   i.cd_atendimento = a.cd_atendimento
and   r.cd_remessa = rf.cd_remessa
and   g.cd_gru_fat = i.cd_gru_fat
and   r.cd_reg_amb in (select distinct cd_reg_amb from itreg_amb where sn_pertence_pacote = 'S')
and   rf.dt_abertura between '01/05/2018' and '30/04/2019'
and   r.cd_multi_empresa in (1,4,7)
--and   i.cd_atendimento = 410 -- HSC



