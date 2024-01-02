--LAYOUT Padronizado em arquivo tipo TEXTO e formato ANSI:
--Posi��o  -  Descri��o
--01-08    -  C�digo do Procedimento
--09-68    -  Descri��o do Procedimento
--69-71    -  Auxiliares (n�mero)
--72-74    -  Porte (n�mero)
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
