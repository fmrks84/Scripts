select 
ORG.CD_ORI_ATE,
--ORG.DS_ORI_ATE,
--ORG.TP_ORIGEM,
CASE WHEN ORG.TP_ORIGEM = 'E' THEN '023'
    WHEN ORG.TP_ORIGEM = 'U' THEN '004'
      END TP
--decode ORG.CD_ORI_ATE(3,'23',4,'23',5,'23',6,'23',9,'04',10,'04',11,'23',12,'23',13,'23',14,'23',16,'23',17,'23',24,'23',66,'23',67,'23',68,'23',101,'04',121,'23',141,'23',142,'23',143,'04',144,'23',
from 
ori_ate org
where 
org.sn_ativo = 'S'
and org.tp_origem in ('E','U')
ORDER BY 1
