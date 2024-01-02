select * from dbamv.faixa_guia_convenio
where cd_convenio = 3
and cd_multi_empresa = 2
order by cd_faixa_guia

select * from dbamv.item_faixa_guia_convenio
where cd_faixa_guia = 770
order by nr_sequencia desc

Select * From DBAMV.TISS_NR_GUIA Where CD_ATENDIMENTO IN (111133,111157,111190,111410,111437,111494)
Delete From DBAMV.TISS_NR_GUIA Where CD_ATENDIMENTO IN (111133,111157,111190,111410,111437,111494)
