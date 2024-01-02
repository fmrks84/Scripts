select a.cd_reg_fat , 
       a.cd_conta_pai , 
       a.cd_prestador , 
       a.cd_pro_fat , 
       a.tp_pagamento 
from dbamv.itreg_FAt a where a.cd_reg_fat in (1227406,1233092,1226004)-- contas filhas empresa 4
and a.cd_pro_fat in (45010110)
and a.cd_prestador = 1824
for update
