SELECT 
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto,
--b.vl_total,
count(*)
FROM 
TIP_PRESC A 
inner join  val_pro b on b.cd_pro_fat = a.cd_pro_fat
WHERE A.SN_ATIVO = 'S'
and a.cd_produto is null
and a.cd_exa_lab is null
and a.cd_exa_rx is null
GROUP BY
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto
--b.vl_total
HAVING COUNT(a.ds_tip_presc) = 2

union all

SELECT 
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto,
--b.vl_total,
count(*)
FROM 
TIP_PRESC A 
inner join  val_pro b on b.cd_pro_fat = a.cd_pro_fat
inner join  exa_lab c on c.cd_exa_lab = a.cd_exa_lab
                     and c.cd_pro_fat = b.cd_pro_fat
WHERE A.SN_ATIVO = 'S'
--and a.cd_produto is null
and a.cd_exa_lab is not null
--and a.cd_exa_rx is null
--and a.cd_pro_fat is null
and a.cd_pro_fat is not null
GROUP BY
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto
--b.vl_total
HAVING COUNT(a.ds_tip_presc) = 2

union all

SELECT 
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto,
--b.vl_total,
count(*)
FROM 
TIP_PRESC A 
inner join  val_pro b on b.cd_pro_fat = a.cd_pro_fat
inner join  exa_rx c on c.cd_exa_rx = a.cd_exa_rx
                     and c.exa_rx_cd_pro_fat = b.cd_pro_fat
WHERE A.SN_ATIVO = 'S'
--and a.cd_produto is null
--and a.cd_exa_lab is null
and a.cd_exa_rx is not null
--and a.cd_pro_fat is null
and a.cd_pro_fat is not null
GROUP BY
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto
--b.vl_total
HAVING COUNT(a.ds_tip_presc) = 2

union all

SELECT 
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto,
--b.vl_total,
count(*)
FROM 
TIP_PRESC A 
inner join  val_pro b on b.cd_pro_fat = a.cd_pro_fat
inner join  produto c on c.cd_produto = a.cd_produto
                      and c.cd_pro_fat = b.cd_pro_fat
WHERE A.SN_ATIVO = 'S'
and a.cd_produto is not null
--and a.cd_exa_lab is null
--and a.cd_exa_rx is not null
--and a.cd_pro_fat is null
--and a.cd_pro_fat is not null
GROUP BY
a.ds_tip_presc,
b.cd_pro_fat,
a.cd_exa_lab,
a.cd_exa_rx,
a.cd_produto
--b.vl_total
HAVING COUNT(a.ds_tip_presc) = 2;
--select * from tip_presc u where u.ds_tip_presc = 'Suplemento'
