/*INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0205020097', 'I', '01/10/2015');


INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0205020097', 'A', '01/10/2015');


   INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0205020097', 'H', '01/10/2015');


INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0409010596', 'I', '01/10/2015');


   INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0409010596', 'A', '01/10/2015');


   INSERT INTO Dbamv.Procedimento_Modalidade_Vigenc (cd_procedimento, tp_modalidade_atendimento, dt_validade_inicial)
VALUES ('0409010596', 'H', '01/10/2015');

commit;*/

--0409010596

select * from procedimento_sus_regra z where z.cd_procedimento in (0409010596) and cd_REgra in ('10008')--,'00049')
select * from regra_sus z1 where /*z1.ds_apelido_regra and*/ z1.cd_regra in ('00001','00004','00049','10008')--for update
