SELECT nr_protocolo_retorno, REPLACE(nr_protocolo_retorno,' ','') FROM dbamv.tiss_mensagem WHERE nr_protocolo_retorno LIKE '% %'; --369
--update dbamv.tiss_mensagem SET nr_protocolo_retorno = REPLACE(nr_protocolo_retorno,' ','') WHERE nr_protocolo_retorno LIKE '% %'
--commit
SELECT nr_protocolo_retorno, REPLACE(nr_protocolo_retorno,'  ','') FROM dbamv.tiss_mensagem WHERE nr_protocolo_retorno LIKE '%  %'    --154
--update dbamv.tiss_mensagem SET nr_protocolo_retorno = REPLACE(nr_protocolo_retorno,'  ','') WHERE nr_protocolo_retorno LIKE '%  %'
select * from tiss_mensagem x where x.nr_protocolo_retorno = '340089887637'--x.nr_documento = '498720'--x.nr_protocolo_retorno =  11895
