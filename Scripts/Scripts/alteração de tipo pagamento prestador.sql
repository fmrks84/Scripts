update dbamv.prestador_aviso set tp_pagamento = 'P' where tp_pagamento is null
and cd_aviso_cirurgia in (select a.cd_aviso_cirurgia from dbamv.aviso_cirurgia a
  where a.TP_SITUACAO not in ('R', 'C'))


select * from dbamv.prestador_aviso where tp_pagamento is null and cd_aviso_cirurgia in 
(select a.cd_aviso_cirurgia from dbamv.aviso_cirurgia a
  where a.TP_SITUACAO not in ('R', 'C'))
    
