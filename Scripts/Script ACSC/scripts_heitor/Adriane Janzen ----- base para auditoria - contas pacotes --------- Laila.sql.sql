/*C2202/8313 - 23/02/2022 - reg_amb*/
SELECT decode (r.cd_multi_empresa,1,'HMRP',3,'CSSJ',4,'HST',7,'HSC',10,'HSJ',25,'HCNSC') casa
      ,r.cd_convenio
      ,c.nm_convenio
      ,decode(a.tp_atendimento,'U','Urgencia','A','Ambulatorio','E','Externo') tp_atendimento
      ,(case
                  when (select count(*)
                          from itreg_amb ie
                         where ie.cd_reg_amb = r.cd_reg_amb
                           and ie.sn_pertence_pacote = 'S') > 0 then
                   'S'
                  else
                   'N'
                end) possui_pacote
      ,i.cd_atendimento
      ,r.cd_reg_amb conta
      ,a.dt_atendimento  
      ,i.cd_pro_fat
      ,p.ds_pro_fat
      ,i.qt_lancamento
      ,i.vl_total_conta vl_item
      ,(select sum (x.vl_total_conta) from itreg_amb x where x.cd_reg_amb = r.cd_reg_amb and x.sn_pertence_pacote = 'N') vl_faturado
      ,(select sum(i2.vl_total_conta) from itreg_amb i2 where i2.cd_reg_amb = r.cd_reg_amb and i.sn_pertence_pacote = 'N' and cd_conta_pacote is null)vl_fora_pacote
      ,(select sum(i3.vl_total_conta) from itreg_amb i3 where i3.cd_reg_amb = r.cd_reg_amb)vl_total --buscar valor total itens da conta AT.3532875 CSSJ
     --,(select sum(r2.vl_total_conta) from reg_amb r2 where r2.cd_reg_amb = r.cd_reg_amb)vl_total --buscar valor total remessa AT.3532875 CSSJ
      ,i.cd_usuario
      ,i.tp_mvto
      ,r.cd_remessa 
      ,f.dt_competencia 
      ,rf.dt_abertura dt_abertura_remessa  
      ,g.ds_gru_fat
      ,i.sn_pertence_pacote
     
      
FROM reg_amb r, itreg_amb i, pro_fat p, convenio c, atendime a, remessa_fatura rf, fatura f, gru_fat g

WHERE r.cd_reg_amb = i.cd_reg_amb
and   p.cd_pro_fat = i.cd_pro_fat
and   c.cd_convenio = r.cd_convenio
and   a.cd_atendimento = i.cd_atendimento
and   rf.cd_remessa = r.cd_remessa
and   f.cd_fatura = rf.cd_fatura
and   g.cd_gru_fat = i.cd_gru_fat

and f.dt_competencia between '01/11/2021' and '01/01/2022'
and i.cd_reg_amb in (select distinct cd_reg_amb from itreg_amb where sn_pertence_pacote = 'S') --trazer somente contas q possuem PCT
and c.tp_convenio <> all ('H','P')
and r.cd_multi_empresa in (3)
--and r.cd_reg_amb = 2871917 

ORDER BY 6 desc
;
/*select sum (x.vl_total_conta) from itreg_amb x where x.cd_reg_amb = 2148764 and x.sn_pertence_pacote = 'N' --2923908
select * from itreg_amb where cd_reg_amb = 2148764 --2923908*/
