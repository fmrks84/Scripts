select decode(r.cd_multi_empresa,3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC')casa, r.cd_reg_Fat conta, c.nm_convenio,
r.dt_inicio, r.dt_final, r.sn_fechada, r.vl_total_conta,r.cd_remessa, (nvl(trunc(r.dt_final),trunc(sysdate))-trunc(r.dt_inicio)) permanencia,
a.qt_Diaria, r.cd_con_pla, p.ds_con_pla, r.tp_classificacao_conta, t.ds_tip_acom
from reg_Fat r, convenio c, con_pla p,
(select count(cd_pro_Fat) qt_Diaria, cd_reg_Fat from itreg_fat where cd_pro_fat in
(select cd_pro_fat from pro_fat where cd_gru_pro = 1 and sn_pacote = 'N') group by cd_reg_Fat) a,
tip_acom t
where r.cd_convenio = c.cd_convenio
and   r.cd_reg_Fat = a.cd_reg_fat(+)
and   r.cd_convenio = p.cd_convenio
and   r.cd_con_pla = p.cd_con_pla
and   r.cd_tip_acom = t.cd_tip_acom
--and   r.cd_remessa not in (select cd_remessa from remessa_fatura where sn_fechada = 'S')
and   r.dt_inicio >= '01/02/2021'
and   c.tp_convenio = 'C'
order by 1,3
