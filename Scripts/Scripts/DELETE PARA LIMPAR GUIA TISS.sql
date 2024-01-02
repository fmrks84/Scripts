------------------------------ Guia por Atendimento---------------------------------

SELECT * From DBAMV.TISS_NR_GUIA Where CD_REG_FAT IN (237516)
Delete From DBAMV.TISS_NR_GUIA Where CD_ATENDIMENTO in (226932,228440,229343)
Select *  From ItReg_Fat Where Cd_Reg_Fat IN ( 282018,282019) AND TP_PAGAMENTO = 'P'
SELECT VL_ATO, VL_NOTA, VL_LIQUIDO  FROM ITLAN_MED WHERE CD_REG_FAT = 277407

SELECT * FROM DBAMV.TISS_NR_GUIA WHERE CD_ATENDIMENTO = 

-------------------------------Guia por Conta----------------------------------------- Hospitalar

Select CD_PRO_FAT, QT_LANCAMENTO, CD_REG_FAT, NR_GUIA_ENVIO, CD_MULTI_EMPRESA From DBAMV.itreg_fat Where CD_REG_FAT in (269550,269551) and cd_gru_fat in (6) and tp_pagamento <> 'C' order by 2

Select nr_guia, nr_folha, nr_linha, cd_pro_fat From DBAMV.TISS_NR_GUIA Where CD_REG_FAT in (269550,269551) and tp_guia = 'SP' order by 1,2

Delete From DBAMV.TISS_NR_GUIA Where CD_REG_FAT in (274372,275440)


Select * From DBAMV.TISS_NR_GUIA Where CD_atendimento in (50277,50819,52478,50513,50477,51845,47824,50072,53669
                                                         ,49705,51992,52142,52450,51057,51561,51833,33331,49835
                                                         ,52299,52400,49809,52207,51297,52526,50603,50166,50557
                                                         ,50226,53827,50810,53153,50387,50235,54275,51742,50831
                                                         ,51153,49274,45158,49951,51202,52093,48388,51890,52152)




Delete  From DBAMV.TISS_NR_GUIA Where CD_atendimento in (50277,50819,52478,50513,50477,51845,47824,50072,53669
                                                         ,49705,51992,52142,52450,51057,51561,51833,33331,49835
                                                         ,52299,52400,49809,52207,51297,52526,50603,50166,50557
                                                         ,50226,53827,50810,53153,50387,50235,54275,51742,50831
                                                         ,51153,49274,45158,49951,51202,52093,48388,51890,52152)
And cd_multi_empresa = 5






COMMIT

                   ---- Externos e Ambulatoriais

Select * From DBAMV.TISS_NR_GUIA Where CD_REG_AMB = 42308
Delete From DBAMV.TISS_NR_GUIA Where CD_REG_AMB = 42308

                    --- Procedimentos

SELECT * From DBAMV.TISS_NR_GUIA Where CD_REG_FAT = 48262 And CD_PRO_FAT = 51010194 And TP_GUIA = 'SP'

COMMIT


