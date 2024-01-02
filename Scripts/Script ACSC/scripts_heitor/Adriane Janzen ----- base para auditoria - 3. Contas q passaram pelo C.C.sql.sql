--Referências: CSSJ / Contas de Internação faturadas de janeiro a abril de 2020 / somente Convênios
--3)  Relação de atendimentos e contas que tenham a informação do Tempo anestésico (início e fim da anestesia), Tempo de sala (entrada e saída de sala) e a Taxa de sala cirúrgica, porte anestésico faturado e taxa por uso/sessão de sala cirúrgica faturada (relação abaixo). 
CD_PRO_FAT  DS_PRO_FAT
60023104  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 1
60023112  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 2
60023120  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 3
60023139  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 4
60023147  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 5
60023155  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 6
60023163  TAXA DE SALA CIRURGICA, PORTE ANESTESICO 7
60023066  TAXA POR USO/SESSAO DE SALA CIRURGICA, CIRURGIA PEQUENA
60023058  TAXA POR USO/SESSAO DE SALA CIRURGICA, CIRURGIA MEDIA
60023040  TAXA POR USO/SESSAO DE SALA CIRURGICA, CIRURGIA GRANDE
60023031  TAXA POR USO/SESSAO DE SALA CIRURGICA, CIRURGIA ESPECIAL
---------------

select r.cd_Atendimento, r.cd_reg_Fat conta, c.nm_convenio, to_char(f.dt_competencia,'mm/yyyy')competencia, r.vl_total_conta,
i.cd_pro_Fat, p.ds_pro_Fat, i.qt_lancamento, i.vl_unitario, i.vl_total_conta vl_total, s.nm_setor, a.dt_inicio_anestesia, a.dt_fim_anestesia,
a.dt_inicio_cirurgia, a.dt_fim_cirurgia
from reg_Fat r, itreg_Fat i, pro_Fat p, convenio c, setor s, remessa_fatura rf, fatura f, aviso_cirurgia a
where r.cd_reg_fat = i.cd_reg_Fat
and   i.cd_pro_fat = p.cd_pro_fat
and   r.cd_convenio = c.cd_convenio
and   i.cd_setor_produziu = s.cd_setor
and   r.cd_remessa = rf.cd_remessa
and   rf.cd_fatura = f.cd_fatura
and   i.cd_mvto = a.cd_aviso_cirurgia(+)
and   r.cd_multi_empresa = 3
and   c.tp_convenio = 'C'
and   i.sn_pertence_pacote = 'N'
and   f.dt_competencia between '01/01/2020' and '30/04/2020'
and   r.cd_reg_fat in (Select cd_reg_Fat from itreg_fat where tp_mvto = 'Cirurgia')
and   r.cd_reg_Fat in (select cd_reg_Fat from itreg_Fat where cd_pro_fat in ('60023104','60023112','60023120','60023139','60023147',
'60023155','60023163','60023066','60023058','60023040','60023031'))
order by 4,2
