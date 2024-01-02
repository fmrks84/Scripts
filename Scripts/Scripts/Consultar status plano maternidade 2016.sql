select  a.nr_contrato_adiant,
        a.ds_contrato_adiant,
        c.nr_parcela,
        c.dt_vencimento,
        c.vl_duplicata,
        c.vl_soma_recebido VALOR_PAGO ,
        a.cd_atendimento,
        decode (a.st_contrato_adiant, 'C', 'COMPROMETIDO', 'Q', 'QUITADO')TP_QUITACAO,
        b.cd_con_rec,
        b.ds_con_rec,
        a.dt_contrato_adiant
        
        from dbamv.contrato_adiantamento a, 
             dbamv.con_Rec b ,
             dbamv.itcon_rec c 
where 1=1--a.nr_contrato_adiant = 5330--6666-- simulacao
and a.cd_contrato_adiant = b.cd_contrato_adiant
and b.cd_con_rec = c.cd_con_rec
and a.dt_contrato_adiant > = '01/11/2016'
and a.cd_contrato_adiant = (2863)--(2688)--5330 ,2688
and a.cd_atendimento is null
order by 1


