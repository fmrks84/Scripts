select * from DBAMV.V_TISS_STATUS_PROTOCOLO A      -- 1° 
where a.cd_remessa in (363715,366791,326066)--(195899);

delete from tiss_lote b where b.id_pai in (2889619, 3322322, 3322333) --for update; -- 2° colocar o id da tabela  V_TISS_STATUS_PROTOCOLO

select from site_xml c where c.cd_site_servico = 561
and c.cd_wizard_origem  in (2889619, 3322322, 3322333) --for update           -- 3° colocar o id_pai da tabela tiss_lote 


--delete from tiss_guia where cd_remessa = 373395;

select * from remessa_fatura where cd_remessa = 371206;
select * from fatura where cd_fatura = 50988

--select * from tiss_mensagem z where z.nr_lote = 19718 for update  -- 19529/ 19718
