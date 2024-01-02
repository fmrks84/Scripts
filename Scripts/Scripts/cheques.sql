Select * From Dbamv.Cheque Where cd_Cheque = '24721'
Select * From   Dbamv.pagcon_pag p Where  p.cd_cheque = '24721'
Select * from Dbamv.pagcon_pag p where p.cd_pagcon_pag = 149978
select * from dbamv.itcon_pag i where i.cd_itcon_pag = 238932
select * from dbamv.con_pag c where c.cd_con_pag = 221355


select * 
    from dbamv.con_pag c 
    where c.cd_con_pag in (Select * 
                           from   dbamv.itcon_pag i 
                           where  i.cd_itcon_pag In (Select * 
                                                    From   Dbamv.pagcon_pag p 
                                                    Where  p.cd_cheque = '24721'))



