select * from dbamv.config_ffcv c
where c.cd_multi_empresa in (1,2,3)
for update
order by cd_multi_empresa asc
  
 ---- empresa 1 sempre for 352
 ---- empresa 2 sempre for 379
 ---- empresa 3 sepre for 378
  --s = setor
  --l = laudo
  --A = tudo


--S - pedido - faturamento psdi
