--alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss'

select sum (qt_lancamento) from (
select cd_reg_fat, cd_setor, qt_lancamento, dt_lancamento from itreg_fat where cd_pro_fat = '07011647'
and dt_lancamento > '01/01/2008 00:00:00'
and dt_lancamento < '30/06/2008 23:59:59'
and cd_setor in (132)
order by dt_lancamento)
