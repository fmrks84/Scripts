select 
b.cd_atendimento,
a.cd_convenio||' - '||d.nm_convenio nm_convenio,
a.cd_cirurgia||' - '||c.ds_cirurgia ds_cirurgia,
b.dt_aviso_cirurgia,
b.cd_aviso_cirurgia,
to_char(b.dt_inicio_anestesia, 'DD/MM/YYYY hh24:mi')HR_INICIO_ANEST,
to_char(b.dt_fim_anestesia, 'DD/MM/YYYY hh24:mi')HR_FIM_ANEST,
trunc( 24* (b.dt_fim_anestesia - b.dt_inicio_anestesia))||':'||
trunc( mod(mod(b.dt_fim_anestesia -  b.dt_inicio_anestesia,1)*24,1)*60 )HORA_MINUTOS
--24 * (to_date(dt_fim_anestesia, 'DD-MM-YYYY hh24:mi') - to_date(dt_inicio_anestesia, 'DD-MM-YYYY hh24:mi')) as diff_hours

--24 * (to_date(to_char(dt_fim_anestesia, 'YYYY-MM-DD hh24:mi'), 'YYYY-MM-DD hh24:mi') - to_date(to_char(dt_inicio_anestesia, 'YYYY-MM-DD hh24:mi'), 'YYYY-MM-DD hh24:mi')) as diff_hours
--(trunc( 24 * mod(b.dt_fim_anestesia - b.dt_inicio_anestesia,1))||':'||(mod(mod(b.dt_fim_anestesia - b.dt_inicio_anestesia,1)*24,1)*60 ))TEMPO_ANESTESIA

from cirurgia_aviso a
inner join aviso_cirurgia b on b.cd_aviso_cirurgia = a.cd_aviso_cirurgia
inner join cirurgia c on c.cd_cirurgia = a.cd_cirurgia
inner join convenio d on d.cd_convenio = a.cd_convenio
where b.tp_situacao = 'R'
--and trunc(b.dt_realizacao) between '01/01/2021' and sysdate  -- definir a data dos lan�amentos 
--and c.cd_cirurgia = 1858  -- definir se dever� somente realizar o inicio dos teste em um codigo de cirurgia
and a.cd_aviso_cirurgia in (156685)
--and b.cd_multi_empresa = 4 -- quais empresas ?
;

--- tabela de cirurgias 
--select * from cirurgia cir where cir.sn_ativo = 'S';

---- tabela para lan�amentos em conta 
--- OBS: LAN�AMENTO DEVE SER NA CONTA QUE CORRESPONDE A DATA QUE FOI INSERIDO O INICIO E FIM DA ANESTESIA
--- EXEMPLO: dt_inicio_anestesia,dt_fim_anestesia  dentro do periodo da conta  reg_Fat.dt_inicio, reg_fat.dt_final
select 
reg_fat.cd_reg_fat,
reg_fat.dt_inicio,
reg_fat.dt_final
from
reg_Fat 
where cd_atendimento = 2273001;--cd_reg_fat = 249579;
--and sn_fechada = 'N' ;

------
select 
itreg_fat.cd_gru_fat, -- manter o grupo_faturamento:3
itreg_fat.cd_pro_fat, --(60011335,600004894,60028572) --AO SER FINALIZADO A CONFIRMA��O DA CIRUGIA LAN�AR 1 ITEM DE CADA NA CONTA 
to_Date(itreg_fat.dt_lancamento,'DD/MM/YYYY')dt_lancamento, -- dever� ser igual dt_fim_anestesia
itreg_fat.hr_lancamento, -- dever� ser igual dt_fim_anestesia
itreg_Fat.Qt_Lancamento, -- quando HORA_MINUTOS > 1H:30MIN LAN�AR +1 PRO_FAT DE CADA 
itreg_fat.cd_setor_produziu, -- COLOCAR DEFAULT SETOR:1162
itreg_fat.Cd_Setor           -- COLOCAR DEFAULT SETOR:1162

from itreg_fat 
where itreg_Fat.Cd_Gru_Fat = 3
and itreg_fat.cd_pro_fat in ('60011335','600004894','60028572')
and itreg_Fat.Cd_Reg_Fat = 249579
;

select * from setor where cd_setor = 1162;
