--LAYOUT Padronizado em arquivo tipo TEXTO e formato ANSI:
--Posição  -  Descrição
--01-08    -  Código do Procedimento
--09-68    -  Descrição do Procedimento
--69-71    -  Auxiliares (número)
--72-74    -  Porte (número)
--75-85    -  Valor 1 (formato 999999,9999)
--86-96    -  Valor 2 (formato 999999,9999)

select lpad(B.cd_pro_fat,8)procedimentos,
      rpad(b.ds_pro_fat,59)codigo_procedimento,
       lpad('1',2)auxiliares,
       lpad('1',2)porte,
       lpad('1111.00',10.2)valor_1,
       lpad('1111.00',10.2)valor_2
       from pro_fat b 
where B.cd_pro_fat = '56020031'



'
