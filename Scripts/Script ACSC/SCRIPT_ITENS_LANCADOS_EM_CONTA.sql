with notas as(
select a.cd_atendimento,
       case when b.tp_atendimento = 'I' then 'Internado'
            when b.tp_atendimento = 'E' then 'Externo'
            when b.tp_atendimento = 'U' then 'Urgencia'
            when b.tp_atendimento = 'A' then 'Ambulatorio'
            end tp_atendimento,
       c.cd_paciente,
       c.nm_paciente,
       a.Cd_Reg_Fat,
       a.cd_reg_amb,
       a.vl_total_nota from nota_fiscal a 
 inner join atendime b on b.cd_atendimento = a.cd_atendimento
 inner join paciente c on c.cd_paciente = b.cd_paciente
 where a.nr_id_nota_fiscal in ('101646','101655','101713','101877',
'103640','103776','103811','103878','105023','105402','105412','105500',
'105504','105672','105946','107759','109653','109712','111012','111148',
'112599','112922','113500','113807','113858','114038','114061','114455',
'118171','118187','118190','118193','118194','118200','118202','118206',
'118208','118210','118215','118218','118220','118221','118222','118295',
'120550','120551','120599','120756','120764','120768','121331','122508',
'122511','122546','123049','123054','123055','123057','123061','123064',
'123078','123080','123081','123095','123097','123098','123125','123219',
'123641','123677','123684','123706','123709','123717','123726','123888',
'123904','123933','123935','123944','123951','123956','124131','124134',
'124135','124137','124172','124176','124179','124189','124193','124199',
'124503','124542','124567','124569','124624','124625','124641','124657',
'124956','125172','125193','125217','125539','86691','90658','91140','91205',
'91487','92252','92927','95936','96021','98895')
and a.cd_convenio = 40 
order by c.nm_paciente
)

select 
nfx.tp_atendimento,
nfx.cd_atendimento,
nfx.nm_paciente,
nfx.cd_Reg_amb conta,
iramb.cd_pro_fat,
pf.ds_pro_fat,
iramb.qt_lancamento,
iramb.vl_unitario,
iramb.Vl_Total_Conta
from 
dbamv.itreg_amb iramb 
inner join dbamv.notas nfx on nfx.cd_atendimento = iramb.cd_atendimento
and nfx.cd_reg_amb = iramb.cd_reg_amb
and iramb.sn_pertence_pacote = 'N'
inner join dbamv.pro_fat pf on pf.cd_pro_fat = iramb.cd_pro_fat 
where 1 = 1 --iramb.cd_reg_amb = 4991185 

union all 

select 
nfx.tp_atendimento,
nfx.cd_atendimento,
nfx.nm_paciente,
nfx.cd_reg_fat conta,
irf.cd_pro_fat,
pfx.ds_pro_fat,
irf.qt_lancamento,
irf.vl_unitario,
irf.Vl_Total_Conta
from 
dbamv.itreg_fat irf
inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join dbamv.notas nfx on nfx.cd_atendimento = rf.cd_atendimento
and nfx.cd_Reg_Fat = irf.cd_reg_fat
and irf.sn_pertence_pacote = 'N'
inner join dbamv.pro_fat pfx on pfx.cd_pro_fat = irf.cd_pro_fat 
where 1 = 1 --irf.cd_reg_fat = 665312
order by nm_paciente, conta
