-- Inserir custo medio de produto manualmente isso quando ocorre uma transferencia de produto entre empresas e o mesmo nunca foi
-- movimentado na empresa destino.
   BEGIN dbamv.pkg_mv2000.atribui_empresa(1);END;
/
DECLARE

CURSOR c IS
SELECT DBAMV.SEQ_CUSTO_MEDIO.NEXTVAL FROM DUAL;

Wseq NUMBER;

BEGIN

OPEN c;
FETCH c INTO Wseq;
CLOSE c;


Insert Into dbamv.custo_medio
                        (cd_custo_medio
                        ,cd_produto
                        ,dt_custo
                        ,hr_entrada
                        ,qt_estoque_antes
                        ,vl_custo_medio_antes
                        ,qt_entrada
                        ,vl_entrada
                        ,vl_custo_medio
                        ,sn_atualiza_preco
                        ,sn_contagem
                        ,dh_custo_medio
                        ,cd_estoque
                        ,qt_estoque_antes_do_estoque
                        ,qt_entrada_emprestimo
                        ,cd_itmvto_estoque
                        ,cd_multi_empresa
                        )
                 Values ( Wseq
                        ,57962 --> Informe o codigo do produto
                        ,SYSDATE - 1
                        ,SYSDATE - 1
                        ,0
                        ,0
                        ,DECODE('E'
                               ,'ENTRADA', 0
                               ,ROUND(0, 4)
                               )
                        ,NVL(ROUND(01.058, 0), 0) --> Informe o valor do produto (Valor unitario) pois ´e a primeria movimentaçao para este produto nesta empresa.
                        ,DECODE('E'
                               ,'EMPRESTIMO', 0
                               ,NVL(ROUND(02.080, 0), 0) --> Informe o valor do produto (Valor unitario) pois ´e a primeria movimentaçao para este produto nesta empresa.
                               )
                        ,'N'
                        ,'N'
                        ,To_date(   TO_CHAR(SYSDATE - 1, 'dd/mm/yyyy')
                                 || ' '
                                 || TO_CHAR(SYSDATE - 1, 'hh24:mi:ss')
                                ,'dd/mm/yyyy hh24:mi:ss'
                                )
                        ,61  --> Estoque que esta recebendo o produto.
                        ,0
                        ,DECODE('E'
                               ,'EMPRESTIMO', ROUND(0, 4)
                               ,0
                               )
                        ,NULL
                        ,2  --> Empresa que esta recebendo o produto
                        );

END;
/
commit;
