select 
a.cd_atendimento,
b.dt_producao dt_criacao_conta,
c.nm_usuario usuario_Criacao_conta,
b.cd_reg_fat conta,
b.cd_pro_fat cod_procedimento,
c.cd_pre_med cod_presc_medica,
f.cd_prestador||' - '||g.nm_prestador nm_prestador,
f.hr_pre_med hr_prescricao,
c.hr_pedido,
b.dt_lancamento dt_lancamento_conta,
b.cd_mvto nr_pedido,
decode(e.tp_proibicao,'NA','NÃO AUTORIZADO')PROIBICAO_PROCED

from 
reg_Fat a 
inner join itreg_Fat b on b.cd_reg_fat = a.cd_reg_fat
inner join ped_Rx c on c.cd_ped_rx = b.cd_mvto 
inner join atendime d on d.cd_atendimento = a.cd_atendimento
inner join proibicao e on e.cd_pro_fat = b.cd_pro_fat
                       and e.cd_convenio = c.cd_convenio
                       and e.tp_atendimento = d.tp_atendimento
                       and c.cd_con_pla = e.cd_con_pla
inner join pre_med f on f.cd_pre_med = c.cd_pre_med
inner join prestador g on g.cd_prestador = f.cd_prestador
where a.cd_atendimento = 4292241
and b.cd_pro_fat = 41001362
---a.cd_reg_fat = 479515

/*;

select * from ped_rx x where x.cd_ped_rx = 2316439;
select * from proibicao where cd_convenio = 104 and cd_pro_fat = '41001362' and cd_con_pla = 13*/
