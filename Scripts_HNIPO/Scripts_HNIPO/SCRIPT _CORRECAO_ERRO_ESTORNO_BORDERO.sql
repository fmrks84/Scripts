insert into dbamv.bordero(cd_bordero,ds_bordero,nr_identificacao,cd_multi_empresa)
values (45894,'BORDERÔ BOLETO NR. 45894','B-45894',1)

update dbamv.pagcon_pag set cd_bordero = 45894
where cd_pagcon_pag IN (838146,838153,838158,838152,838156,838150,838144,838159,838151,838149,838147,838148,837530,838154,838145,838155,838157)
