select c.cd_Convenio, c.nm_convenio, g.ds_gru_pro, p.cd_pro_fat, fc_ovmd_tuss(7,
                                 p.cd_pro_fat,
                                 7,
                                 'COD') cd_tuss,
fc_ovmd_tuss(7,p.cd_pro_fat,7, 'DESC')ds_tuss,
i.vl_fator_divisao
from convenio c, pro_Fat p, gru_pro g, imp_bra i
where cd_convenio = 7
and   p.cd_gru_pro = g.cd_gru_pro
and   p.cd_pro_fat = i.cd_pro_fat
and   g.cd_gru_pro in (92,94,12,44)
and   i.cd_tab_fat = 181
