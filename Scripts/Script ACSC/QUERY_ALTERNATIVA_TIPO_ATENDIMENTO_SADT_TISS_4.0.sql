/*select decode 
(cd_ori_ate, 6,'03',9,'11',10,'11',1,'04',2,'10',12,'04',18,'03',19,'03',20,'04',
22,'04',23,'09',24,'09',62,'03',63,'04',64,'04',65,'04',66,'03',67,'03',68,'03',182,'04',
188,'11',192,'11',193,'11',194,'02',195,'02',196,'11',197,'11',198,'11',199,'04',401,'02',
463,'11',561,'04',321,'02',461,'11',501,'04',541,'04',201,'04',204,'03',205,'11',206,'04',
209,'04',270,'02',271,'03',462,'11',521,'11',523,'04',581,'04',101,'11',143,'11',283,'11',
284,'04',285,'04',288,'03',289,'10',290,'04',291,'03',292,'03',294,'11',296,'04',297,'04',
298,'04',299,'04',301,'04',302,'11',481,'04',4,'05',5,'05',11,'05',3,'05',13,'05',14,'05',
16,'05',17,'05',121,'05',183,'05',184,'05',185,'05',189,'05',190,'05',191,'05',242,'05',
243,'05',421,'05',202,'05',203,'05',207,'05',261,'05',265,'05',263,'05',264,'05',266,'05',
267,'05',268,'05',269,'05',272,'05',273,'05',274,'05',275,'05',276,'05',141,'05',142,'05',
144,'05',145,'05',149,'05',150,'05',286,'05',287,'05',602,'04',601,'03',621,'04',721,'04',
622,'04',741,'04') from atendime where cd_atendimento = :par1
*/

select decode (cd_ori_ate, 6,'03',9,'04',10,'04',1,'04',2,'10',12,'04',18,'03',19,'03',20,'04',22,'04',23,'09',24,'09',62,'03',63,'04',64,'04',65,'04',66,'03',67,'03',68,'03',182,'04',188,'04',192,'04',193,'04',194,'02',195,'02',196,'04',197,'04',198,'04',199,'04',401,'02',463,'04',561,'04',321,'02',461,'04',501,'04',541,'04',201,'04',204,'03',205,'04',206,'04',209,'04',270,'02',271,'03',462,'04',521,'04',523,'04',581,'04',101,'04',143,'04',283,'04',284,'04',285,'04',288,'03',289,'10',290,'04',291,'03',292,'03',294,'04',296,'04',297,'04',298,'04',299,'04',301,'04',302,'04',481,'04',4,'23',5,'23',11,'23',3,'23',13,'23',14,'23',16,'23',17,'23',121,'23',183,'23',184,'23',185,'23',189,'23',190,'23',191,'23',242,'23',243,'23',421,'23',202,'23',203,'23',207,'23',261,'23',265,'23',263,'23',264,'23',266,'23',267,'23',268,'23',269,'23',272,'23',273,'23',274,'23',275,'23',276,'23',141,'23',142,'23',144,'23',145,'23',149,'23',150,'23',286,'23',287,'23',602,'04',601,'03',621,'04',721,'04',622,'04',741,'04') from atendime where cd_atendimento = :par1
