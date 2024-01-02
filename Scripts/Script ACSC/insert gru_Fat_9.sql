select
   count(*)
/*   distinct
   c1.cd_especie,
   c1.cd_classe,
   gp1.cd_gru_fat,
   conf.cd_setor, 
   conf.cd_estoque,
   conf.cd_conf_import,
   c1.cd_sub_cla,
   c1.cd_produto    
   conf.cd_gru_fat  cd_gru_Fat_conf_Fat*/
       from dbamv.pro_fat b
       inner join dbamv.gru_pro gp1 on gp1.cd_gru_pro = b.cd_gru_pro
       inner join dbamv.gru_fat gft on gft.cd_gru_fat = gp1.cd_gru_fat
       inner join dbamv.produto c1 on c1.cd_pro_fat = b.cd_pro_fat
       inner join dbamv.especie espc on espc.cd_especie = c1.cd_especie
       inner join dbamv.classe clasc on clasc.cd_especie = c1.cd_especie and clasc.cd_classe = c1.cd_classe
       inner join dbamv.sub_clas subclas on subclas.cd_especie = c1.cd_especie and subclas.cd_sub_cla = c1.cd_sub_cla
       inner join dbamv.configu_importacao_gru_fat conf on conf.cd_especie = c1.cd_especie and conf.cd_classe = c1.cd_classe
       inner join dbamv.setor st on st.cd_setor = conf.Cd_Setor
       inner 
       and subclas.cd_classe = c1.cd_classe
       where gp1.cd_gru_pro in (89,96)
       and conf.cd_gru_fat <> 9
       and st.cd_multi_empresa in (25)--3,4,7,10,25
       and b.sn_ativo = 'S'
       
--

--select * from dbamv.gru_pro where cd_gru_pro in (89,96)  --gru_pro=(89,96) gru_FAt = 9       
