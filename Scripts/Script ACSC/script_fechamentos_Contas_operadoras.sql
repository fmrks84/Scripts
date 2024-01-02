select econv.qtd_dias_quebra, conv.cd_convenio,conv.nm_convenio from convenio conv 
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
where conv.tp_convenio = 'C'
and econv.cd_multi_empresa = 7 
and conv.cd_convenio not in (7,641,38,39)
and econv.qtd_dias_quebra is not null

update  empresa_convenio set qtd_dias_quebra = 5 where cd_convenio in (3, 5, 11, 14, 22, 12, 6, 15, 21, 
17, 24, 25, 26, 30, 32, 23, 18, 19, 20, 27, 31, 33, 34, 35, 41, 36, 45, 47, 50, 46, 44,
 48, 49, 53, 55, 56, 57, 13, 16, 29, 63, 42, 51, 28, 52, 8, 9, 10, 62, 58, 59, 401, 464,
  501, 541, 212, 213, 821, 983, 211, 209, 559, 502)
