select --sum(a.vl_estoque_final)
    b.cd_produto,
     b.ds_produto,
      a.qt_estoque_final,
      a.vl_estoque_final,
     c.cd_estoque,
    c.ds_estoque,
    c.cd_multi_empresa
    
 from dbamv.c_conest a,
     dbamv.produto b,
      dbamv.estoque c
 where a.cd_ano = '2018'
and a.cd_produto = b.cd_produto
and c.cd_estoque = a.cd_estoque
and a.cd_mes = '12'
--and a.vl_estoque_final < '0,0000'
and a.cd_produto = 480
order by a.cd_produto,
         c.cd_multi_empresa
         

---  6553334,2575 todos 


--select


------------- 1ºpasso
update      
dbamv.c_conest a set a.vl_estoque_final = '0,0000'
where a.cd_ano = '2018'
and a.cd_mes = '12'
and a.vl_estoque_final < '0,0000'
--and a.qt_estoque_final = '0,0000'
--and a.cd_produto = 480
--and a.qt_estoque_final = '0,0000'
--and c.cd_estoque in (36,51,59,61,177,178,182)
--and a.cd_produto = 69840
--and a.cd_estoque = 64

------------ 2° passo 

update      
dbamv.c_conest a set a.qt_estoque_final ='0,0000'
where a.cd_ano = '2018'
and a.cd_mes = '12'
and a.vl_estoque_final = '0,0000'
and a.qt_estoque_final > '0,0000'
--and a.cd_produto = 71864
--and a.qt_estoque_final = '0,0000'
--and c.cd_estoque in (36,51,59,61,177,178,182)
--and a.cd_produto = 59778


select  * from dbamv.estoque est where est.cd_multi_empresa = 1
order by est.cd_estoque

select  --sum(aa2.vl_estoque_final) 
        aa2.cd_produto, 
        aa2.cd_estoque,
        aa2.qt_estoque_final,
        aa2.vl_estoque_final
        
        from dbamv.c_conest aa2 where aa2.cd_ano = '2018'
and aa2.cd_mes = '12'
/*and aa2.cd_estoque  in (1,2,3,4,7,9,11,12,13,14,15,16,17,18,19,20,21,22,
23,36,40,42,43,44,45,46,47,48,49,50,52,55,56,57,58,59,60,62,63,64,65,
67,68,70,77,80,81,82,83,85,86,87,88,89,90,92,100,101,102,103,105,106,
107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,
124,125,126,127,128,129,130,131,134,138,139,141,142,143,144,145,156,
157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,
176,194,200)*/
--and aa2.cd_produto = 480
order by aa2.vl_estoque_final,
         aa2.cd_produto
