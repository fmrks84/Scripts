--select * from dbamv.gru_pro a where a.cd_gru_pro in (9,89,96) -- 9 ORTESES , PROTESES E SINTESES 
                                                              -- 89 MATERIAL ESPECIAL
                                                              -- 96 MATERIAL ESPECIAL DESCONTINUADO

--select * from dbamv.gru_Fat c where c.cd_gru_fat in (5,9)   
-- 5 ORTESES E PROTESES(OP)
-- 9 MATERIAIS ESPECIAIS (ME)
--regra--9 p/5  , 89,96 p/9

select 
   distinct
  -- GP1.CD_GRU_PRO,
  -- gp1.ds_gru_pro, 
   gp1.cd_gru_fat,
  --  gft.ds_gru_fat, 
  --  b.cd_pro_fat,
   conf.cd_estoque,
   -- b.ds_pro_fat,
   -- c1.cd_produto,
    conf.cd_setor,
    c1.cd_especie,
   -- espc.ds_especie,
    c1.cd_classe,
   -- clasc.ds_classe,
   --  c1.cd_sub_cla,
   --  subclas.ds_sub_cla,
   c1.cd_produto 
    -- conf.cd_gru_fat  cd_gru_Fat_conf_Fat
       from dbamv.pro_fat b 
       inner join dbamv.gru_pro gp1 on gp1.cd_gru_pro = b.cd_gru_pro
       inner join dbamv.gru_fat gft on gft.cd_gru_fat = gp1.cd_gru_fat
       inner join dbamv.produto c1 on c1.cd_pro_fat = b.cd_pro_fat
       inner join dbamv.especie espc on espc.cd_especie = c1.cd_especie
       inner join dbamv.classe clasc on clasc.cd_especie = c1.cd_especie and clasc.cd_classe = c1.cd_classe
       inner join dbamv.sub_clas subclas on subclas.cd_especie = c1.cd_especie and subclas.cd_sub_cla = c1.cd_sub_cla
       inner join dbamv.configu_importacao_gru_fat conf on conf.cd_especie = c1.cd_especie and conf.cd_classe = c1.cd_classe
       and subclas.cd_classe = c1.cd_classe 
       where gp1.cd_gru_pro in (9,89,96)
       and espc.cd_especie in (20,19)
       and conf.cd_gru_fat = 5
      and b.cd_pro_fat = '00271586'
       and b.sn_ativo = 'S'
      -- and c1.cd_especie = 60 
       order by c1.cd_classe, c1.cd_sub_cla
 --      and c1.cd_produto = 7001
--;

/*select * from dbamv.configu_importacao_gru_fat cgf 
inner join dbamv.setor st on st.cd_setor = cgf.cd_setor
where cgf.cd_especie = 61
and cgf.cd_classe = 1*/
--select * from dbamv.gru_pro gp where gp.cd_gru_fat in (5,9);
--select * from dbamv.gru_Fat gf where gf.cd_gru_fat in (4,9,8)
--and cgf.cd_gru_fat in (5,9)


/*select 
   distinct
 
   gp1.cd_gru_fat,
  
   conf.cd_estoque,
   
    conf.cd_setor,
    c1.cd_especie,
  
    c1.cd_classe,
  
   c1.cd_sub_cla,
  
   c1.cd_produto ,
    conf.cd_gru_fat  cd_gru_Fat_conf_Fat
       from dbamv.pro_fat b 
       inner join dbamv.gru_pro gp1 on gp1.cd_gru_pro = b.cd_gru_pro
       inner join dbamv.gru_fat gft on gft.cd_gru_fat = gp1.cd_gru_fat
       inner join dbamv.produto c1 on c1.cd_pro_fat = b.cd_pro_fat
       inner join dbamv.especie espc on espc.cd_especie = c1.cd_especie
       inner join dbamv.classe clasc on clasc.cd_especie = c1.cd_especie and clasc.cd_classe = c1.cd_classe
       inner join dbamv.sub_clas subclas on subclas.cd_especie = c1.cd_especie and subclas.cd_sub_cla = c1.cd_sub_cla
       inner join dbamv.configu_importacao_gru_fat conf on conf.cd_especie = c1.cd_especie and conf.cd_classe = c1.cd_classe
       and subclas.cd_classe = c1.cd_classe 
       where gp1.cd_gru_pro in (89,96)
          
       and conf.cd_gru_fat <> 9
     
       and b.sn_ativo = 'S'
*/


