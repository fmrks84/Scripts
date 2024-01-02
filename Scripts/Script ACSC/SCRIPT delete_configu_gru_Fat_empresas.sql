select --distinct
 count(*)
   --  b.cd_gru_fat,
     -- b.cd_estoque,
 -- b.cd_setor
     --  b.cd_especie,
      -- b.cd_classe,
      -- b.cd_sub_cla,
      -- b.cd_produto
 from dbamv.setor a 
inner join dbamv.configu_importacao_gru_fat b on b.cd_setor = a.cd_setor
where a.cd_multi_empresa = 7
---and b.cd_conf_import > = 112503
and  b.cd_produto is not null 


/*
select count(*)from 
dbamv.configu_importacao_gru_fat  -- empresa 3
where cd_setor in (810,811,851,807,853,854,793,806,847,852
,874,3037,3399,872,801,3036,3098,797,799,805,848,849,3097
,831,3096,792,795,873,932,3595,3596,850,798,876,804,808,
865,870,871,794,796,800,802,803,809,812,3626)
and cd_produto is not null     */

/*select count(*)from 
dbamv.configu_importacao_gru_fat  -- empresa 4
where cd_setor in (1080,1103,1158,1159,1162,1163,1167,1168,1173
,1174,1179,1180,1181,1182,1183,1184,1185,1186
,1187,1188,1189,1190,3156,3159)
and cd_produto is not null 
*/

/*select count(*)from 
dbamv.configu_importacao_gru_fat  -- empresa 7
where cd_setor in (2,3,4,10,12,17,18,24,26,27,28,31,32,35,37,
                     38,39,40,44,45,72,73,105,106,107,132,147,
                     150,151,155,156,157,158,175,183,184,199,
                     200,208,211,232,235,236,237,249,253,270,
                     311,3129)
and cd_produto is not null                  
         */
         
/*select count(*)from 
dbamv.configu_importacao_gru_fat  -- empresa 10
where cd_setor in          (1331,1371,1362,1366,1363,1367,1361
,1365,1370,1373,1372,1374,3600,1368,
1364,1369,1375,1319)   
and cd_produto is not null   */    

/*select count(*)from 
dbamv.configu_importacao_gru_fat  -- empresa 25
where cd_setor in (2449,2450,2452,2457,2465,2467,2448
,2456,2459,2463,2464,3437,2445,2455
,2451,2453,2458,2446,2462,2447,2444
,2454,2460,2461,2466)
and cd_produto is not null*/ 
