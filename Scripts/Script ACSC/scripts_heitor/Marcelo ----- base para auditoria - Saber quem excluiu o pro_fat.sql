/*MARCELO*/
select p.cd_produto, p.cd_pro_fat 
from produto p
where p.cd_produto in (38054,6347,35836,19548,68230,31981,52912,60433,38716,6752)

select r.cd_atendimento, r.cd_reg_fat from reg_fat r
where r.cd_atendimento in (2165710,2523246,2397254,2362138,2302411,2523246,2448652,2586196,2586196,2448652)

/*AT.2448652 - Produto 52912,6752 - Proced. Fat. 09052912,09006752 */

select cd_atendimento,cd_reg_fat from reg_fat
where cd_atendimento = 2448652

select r.cd_atendimento, r.cd_reg_fat, i.cd_gru_fat, i.cd_pro_fat, i.qt_lancamento from reg_fat r 
inner join itreg_fat i on (i.cd_reg_fat = r.cd_reg_fat)
where r.cd_atendimento = 2448652
and i.cd_pro_fat in ('09052912','09006752')

select a.cd_atendimento
      ,a.cd_reg_fat conta
      ,a.cd_gru_fat
      ,a.cd_pro_fat
      ,p.ds_pro_fat
      ,a.qt_lancamento_ant
      ,a.qt_lancamento
      ,a.dt_auditoria
      ,a.cd_motivo_auditoria
      ,m.ds_motivo_auditoria
      ,a.cd_usuario_aud 
      ,d.nm_usuario
from auditoria_conta a 
    ,motivo_auditoria m
    ,pro_fat p
    ,dbasgu.usuarios d
where a.cd_motivo_auditoria = m.cd_motivo_auditoria
and a.cd_usuario_aud = d.cd_usuario
and a.cd_pro_fat = p.cd_pro_fat
and a. cd_reg_fat in (272061,269094,270781,273827,276367,277660,272936,275083) 
and a.cd_pro_fat in ('09052912','09006752')
order by cd_pro_fat, dt_auditoria
;

/*AT.2165710 - Produto 38054 - Proced. Fat. 00082516*/
select cd_atendimento,cd_reg_fat from reg_fat
where cd_atendimento = 2165710

select r.cd_atendimento, r.cd_reg_fat, i.cd_gru_fat, i.cd_pro_fat, i.qt_lancamento from reg_fat r 
inner join itreg_fat i on (i.cd_reg_fat = r.cd_reg_fat)
where r.cd_atendimento = 2165710
and i.cd_pro_fat in ('00082516')

select a.cd_atendimento
      ,a.cd_reg_fat conta
      ,a.cd_gru_fat
      ,a.cd_pro_fat
      ,p.ds_pro_fat
      ,a.qt_lancamento_ant
      ,a.qt_lancamento
      ,a.dt_auditoria
      ,a.cd_motivo_auditoria
      ,m.ds_motivo_auditoria
      ,a.cd_usuario_aud 
      ,d.nm_usuario
from auditoria_conta a 
    ,motivo_auditoria m
    ,pro_fat p
    ,dbasgu.usuarios d
where a.cd_motivo_auditoria = m.cd_motivo_auditoria
and a.cd_usuario_aud = d.cd_usuario
and a.cd_pro_fat = p.cd_pro_fat
and a. cd_reg_fat in (236608,238295) 
and a.cd_pro_fat in ('00082516')
order by cd_pro_fat, dt_auditoria
;
