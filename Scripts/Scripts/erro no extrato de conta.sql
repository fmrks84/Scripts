select *
from dbamv.Mov_Concor a where a.cd_con_cor = 11
and a.dt_movimentacao between '16/10/2017' and '16/10/2017'
for update
--and a.nr_documento_identificacao IN ('C-8658', 'C-8659' )
--for update;

select  * from dbamv.Mov_Concor a where a.cd_con_cor = 11
and a.dt_movimentacao between '02/10/2017' and '02/10/2017'



--8658 429062
--8659 429063

--8658 421080
--8659 421081

----------------------8658---------------------------------------
select * from dbamv.pagcon_pag b where b.cd_pagcon_pag in (429062,421080);
select * from dbamv.itcon_pag c where c.cd_itcon_pag = 628671;
select * from dbamv.con_pag d where d.cd_con_pag = 577313;


/*select * from dbamv.pagcon_pag b where b.cd_pagcon_pag = 421080;
select * from dbamv.itcon_pag c where c.cd_itcon_pag = 628671;
select * from dbamv.con_pag d where d.cd_con_pag = 577313;*/
---------------------8659----------------------------------------
select * from dbamv.pagcon_pag b where b.cd_pagcon_pag IN (429063,421081);
select * from dbamv.itcon_pag c where c.cd_itcon_pag = 628672 ;
select * from dbamv.con_pag d where d.cd_con_pag = 577314;

/*select * from dbamv.pagcon_pag b where b.cd_pagcon_pag = ;
select * from dbamv.itcon_pag c where c.cd_itcon_pag = 628672 ;
select * from dbamv.con_pag d where d.cd_con_pag = 577314*/

select * from dbamv.saldo_mensal_gerencial
-----------------------------------------------------------------

select * from dbamv.Mov_Concor a where a.cd_con_cor = 11


------------------------------------------------------------------

--select DBAMV.VL_SALDO_BANCARIO(11,'30/09/2017', 'S','ANT','A'/*,'L','C'*/)from dual 

select   mcc.cd_mov_concor             cd_mov_concor
               ,decode('A','A',mcc.vl_movimentacao,mcc.vl_movimentacao - abs(nvl(tar.vl_movimentacao,0)))  vl_movimentacao
               ,lcc.tp_operacao_saldo_conta   tp_opr_saldo_cta
               ,lcc.sn_transferencia          sn_transferencia
               ,lcc.cd_lan_concor
               ,decode(mcc.dt_estorno,null,decode(mcc.cd_cheque,null,mcc.dt_movimentacao               
               ,decode('C','C',decode(c.dt_compensacao,null,
               Decode(2, 967, c.dt_compensacao, c.dt_emissao)
               ,c.dt_compensacao),c.dt_emissao)),mcc.dt_estorno)    
       from     dbamv.mov_concor              mcc
               ,dbamv.lan_concor              lcc
               ,dbamv.cheque                 c  
               ,dbamv.processo                p
               ,(Select m.Cd_Mov_Pai,
                        Nvl(Sum(m.Vl_Movimentacao),0) Vl_Movimentacao
                   From Dbamv.mov_concor m
                       ,dbamv.processo p
                  Where  'A' = 'L'
                    And m.cd_processo = p.cd_processo
                    And p.Cd_Estrutural = '1.6.1.1.10.3'
                  Group By Cd_Mov_Pai ) Tar
              
       where    lcc.cd_lan_concor             =  mcc.cd_lan_concor
       and      mcc.cd_cheque                 =  c.cd_cheque (+) 
       and      mcc.cd_mov_concor             =  Tar.Cd_Mov_Pai (+)
       and      mcc.cd_processo               =  p.cd_processo
       and      mcc.cd_con_cor                =  11
       and    decode(mcc.dt_estorno,null,decode(mcc.cd_cheque,null,mcc.dt_movimentacao,                  
                       decode('C','C',decode(c.dt_compensacao,null,
               Decode(2, 967, c.dt_compensacao, c.dt_emissao)
             ,c.dt_compensacao),c.dt_emissao)),mcc.dt_estorno)                        
       between  '30/09/2017' and '05/10/2017'
       and      mcc.sn_conciliado             =  'S'      
       and ( ( 'A' = 'L' And p.CD_ESTRUTURAL <> '1.6.1.1.10.3' ) Or ( 'A' = 'A'))
       order by 6
