----------------------------------------Guias Principais-----------------------------------------------------------------------
select * from dbamv.atendime
where cd_convenio in (27)
and tp_atendimento IN ('U', 'E')
and Cd_Multi_empresa = 1
and Nr_guia_envio_principal is not null
and nr_guia_envio_principal like '7712%'

update dbamv.atendime
set nr_guia_envio_principal = null
where cd_convenio in (27)
and tp_atendimento IN ('U', 'E')
and Cd_Multi_empresa = 1
and Nr_guia_envio_principal is not null
and nr_guia_envio_principal like '7712%'


SELECT * FROM GUIA
where cd_convenio in (342)
and cd_atendimento in
            (select atendime.cd_atendimento
              from atendime,itreg_amb, reg_amb
               where atendime.cd_multi_empresa = 1
                and atendime.cd_atendimento = itreg_amb.cd_atendimento
                and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
                and tp_atendimento IN ('U', 'E'))
and nr_guia is not null
and tp_guia <> 'I'
and nr_guia like '342%'
order by nr_guia desc

update guia
set nr_guia = null
where cd_convenio in (342)
and cd_atendimento in
            (select atendime.cd_atendimento
              from atendime, itreg_amb, reg_amb
               where atendime.cd_multi_empresa = 1
                and atendime.cd_atendimento = itreg_amb.cd_atendimento
                and reg_amb.cd_reg_amb = itreg_amb.cd_reg_amb
                and tp_atendimento IN ('U', 'E'))
and nr_guia is not null
and tp_guia <> 'I'
and nr_guia like '342%'
order by nr_guia desc


-------------------------------Trocar a empresa e rodar uma vez para cada empresa-------------------------------------------
Begin
  Pkg_Mv2000.Atribui_Empresa(2);
End;



----------------------Limpar as Guias Tiss por Convênios, Empresas e Numeros de Guias--------
DELETE From Tiss_Nr_Guia
  Where Cd_Reg_Amb in (
                      Select Cd_Reg_Amb
                       From Reg_Amb
                       Where cd_convenio in (342)
--                       And Cd_Remessa = 7730
                       And Cd_Multi_Empresa = 1)
And nr_guia like '342%'

--------------------------------- Faixa de Guias -------------------------------------------------
select * from dbamv.faixa_guia_convenio where cd_convenio = 342 order by nr_inicial

select * from dbamv.item_faixa_guia_convenio
where cd_faixa_guia =1173
order by nr_sequencia desc

---------------------------------Limpar as Guias por Atendimentos------------------------------

SELECT * From DBAMV.TISS_NR_GUIA Where CD_ATENDIMENTO = 149558 --AND CD_PRO_FAT = '00010014'

SELECT NR_GUIA_ENVIO fROM ITREG_FAT WHERE CD_REG_FAT = 135430

update DBAMV.TISS_NR_GUIA set nr_guia = '1937129' where nr_guia = '1941245' --and cd_atendimento = 102621
Delete From DBAMV.TISS_NR_GUIA Where CD_ATENDIMENTO = 123226


SELECT Nr_Guia , Nr_Guia_Principal, Cd_Pro_Fat From DBAMV.TISS_NR_GUIA
Where Nr_Guia In ('1937193')--,'1939942','1939943','1937191','1937192','1937193','1937162','1937163','1939311','1977134','1937135')
Order By Nr_Guia

SELECT Cd_Reg_Amb, Cd_Pro_Fat, Nr_Guia_Envio  From dbamv.ItReg_Amb Where Cd_Reg_Amb = 75302
Where Nr_Guia_Envio In ('1939941','1939942','1939943','1937191','1937192','1937193','1937162','1937163','1939311','1977134','1937135')
Order By Nr_Guia_Envio

Update dbamv.ItReg_Amb Set Nr_Guia_Envio = '23320687' Where Cd_Reg_Amb = 75302


update DBAMV.TISS_NR_GUIA set nr_guia = '1937140' where nr_guia = '1950139'
update itreg_fat set nr_guia_envio = '1937140' where nr_guia_envio = '1950139'


----------------------------------

select cd_atendimento, nr_guia, tp_guia
from guia where tp_guia = 'I'
and cd_atendimento in (110592,111878,10901,110574,110987,111303,111141,110945,112016,111686,111655,111385,110819,110408,111451,109901)

SELECT NR_GUIA_ENVIO_PRINCIPAL FROM ATENDIME WHERE CD_ATENDIMENTO = 112165
