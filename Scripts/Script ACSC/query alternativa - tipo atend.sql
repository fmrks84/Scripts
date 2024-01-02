19.05.2023
Realizado c/ Fábio

HSC

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode (cd_ori_ate,1,'04',2,'03',3,'05',4,'05',5,'05',6,'03',9,'11',10,'11',11,'05',12,'03',13,'05',14,'03',16,'05',17,'05',18,'03',19,'03',20,'04',22,'03',23,'03',24,'03',62,'03',63,'04',64,'04',65,'04',66,'03',67,'03',68,'03',101,'11',121,'13',541,'13',561,'04',601,'04',602,'04',621,'04',622,'04',721,'04',741,'04',821,'13') from atendime where cd_atendimento = :par1 


Versão 4.0 -- (11 Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode (cd_ori_ate,1,'04',2,'03',3,'23',4,'23',5,'23',6,'03',9,'04',10,'04',11,'23',12,'03',13,'23',14,'03',16,'23',17,'23',18,'03',19,'03',20,'04',22,'03',23,'03',24,'03',62,'03',63,'04',64,'04',65,'04',66,'03',67,'03',68,'03',101,'04',121,'13',541,'13',561,'04',601,'04',602,'04',621,'04',622,'04',721,'04',741,'04',821,'13') from atendime where cd_atendimento = :par1 

---------------------------------------------------------------------------
CSSJ

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode (cd_ori_ate,141,'05',142,'05',143,'11',144,'05',145,'05',149,'05',150,'13',321,'04',421,'05',521,'11',523,'04',581,'04',681,'04',861,'04',862,'05') from atendime where cd_atendimento = :par1


Versão 4.0 -- (11 Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode (cd_ori_ate,141,'23',142,'23',143,'04',144,'23',145,'23',149,'23',150,'13',321,'04',421,'23',521,'04',523,'04',581,'04',681,'04',861,'04',862,'23') from atendime where cd_atendimento = :par1



---------------------------------------------------------------------------
HST

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode (cd_ori_ate,261,'05',263,'05',264,'05',265,'13',266,'05',267,'05',268,'05',269,'05',270,'13',271,'03',272,'05',273,'05',274,'05',275,'05',276,'05',283,'11',284,'04',285,'04',286,'05',287,'05',288,'03',289,'03',290,'04',291,'04',292,'04',294,'11',296,'04',297,'04',298,'04',299,'04',301,'04',302,'11',462,'11',481,'04',641,'04',701,'05',761,'13',801,'13',802,'13') from atendime where cd_atendimento = :par1

Versão 4.0 -- (11 Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode (cd_ori_ate,261,'23',263,'23',264,'23',265,'13',266,'23',267,'23',268,'23',269,'23',270,'13',271,'03',272,'23',273,'23',274,'23',275,'23',276,'23',283,'04',284,'04',285,'04',286,'23',287,'23',288,'03',289,'03',290,'04',291,'04',292,'04',294,'04',296,'04',297,'04',298,'04',299,'04',301,'04',302,'04',462,'04',481,'04',641,'04',701,'23',761,'13',801,'13',802,'13') from atendime where cd_atendimento = :par1

---------------------------------------------------------------------------
HSJ

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode(cd_ori_ate,201,'13',202,'05',203,'05',205,'11',206,'04',207,'05',209,'04',211,'04',401,'13',501,'04') from atendime where cd_atendimento = :par1

Versão 4.0 -- (11 Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode(cd_ori_ate,201,'13',202,'23',203,'23',205,'04',206,'04',207,'23',209,'04',211,'04',401,'13',501,'04') from atendime where cd_atendimento = :par1

---------------------------------------------------------------------------
HCNSC

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode(cd_ori_ate,182,'04',183,'05',184,'05',185,'13',188,'11',190,'05',191,'05',194,'13',199,'04',241,'11',461,'11',661,'11',662,'05',663,'05',664,'13',665,'11',841,'11',842,'11') from atendime where cd_atendimento = :par1

Versão 4.0 -- (11-Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode(cd_ori_ate,182,'04',183,'23',184,'23',185,'13',188,'04',190,'23',191,'23',194,'13',199,'04',241,'04',461,'04',661,'04',662,'23',663,'23',664,'13',665,'04',841,'04',842,'04') from atendime where cd_atendimento = :par1

---------------------------------------------------------------------------
HMRP

query alternativa 
baseada coom o padrão Bradesco Saude

VERSAO 3.0
select decode(cd_ori_ate,782,'05',783,'05',786,'11',787,'04',788,'05',790,'04',792,'04',793,'04',794,'04') from atendime where cd_atendimento = :par1

Versão 4.0 -- (11-Pronto Socorro será alterado p/ 04 Consulta --- 05 Exame Ambul. será alterado 23 Exame)
select decode(cd_ori_ate,782,'23',783,'23',786,'04',787,'04',788,'23',790,'04',792,'04',793,'04',794,'04') from atendime where cd_atendimento = :par1

---------------------------------------------------------------------------

select * from ori_ate where cd_multi_empresa = 7 
