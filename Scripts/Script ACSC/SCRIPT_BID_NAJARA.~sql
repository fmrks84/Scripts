------ CONVENIO ------
WITH proft AS (
select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
pf.ds_unidade
from dbamv.pro_Fat pf where pf.cd_pro_fat in 
('40808122', '40808130', '40808149', '30911044', '40813720', '40813568', '30911117', '40808041', '40813029', '40809161', '40809170', '23999980', 
'40813436', '40813460', '40813525', '40813452', '40902110', '40813479', '40813410', '40813487', '40814157', '40808190', '40809170', '40809170',
 '40809170', '40809170', '40809170', '40809170', '40813410', '40902048', '40808025', '40808017', '40808017', '40801128', '40803104', '40803104', 
 '40801101', '40803066', '40803066', '40804038', '40804038', '40803023', '40804020', '40801110', '40804011', '40803082', '40803082', '40804100', 
 '40804100', '40801128', '40803040', '40803040', '40802019', '40802027', '40802035', '40802043', '40802086', '40802060', '40802051', '40802035', 
 '40802094', '40803031', '40803031', '40803090', '40803090', '40804046', '40804046', '40801012', '40801020', '40801039', '40804119', '40803058', 
 '40803058', '40806030', '40803015', '40806049', '40802116', '40801209', '40803147', '40804054', '40804054', '40804054', '40804054', '40804054', 
 '40804054', '40804062', '40804054', '40805077', '40801110', '40803120', '40803120', '40803120', '40803120', '40803139', '40801047', '40801080', 
 '40805069', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', 
 '40803074', '40803074', '40801055', '40801098', '40801098', '40804127', '40804062', '40804097', '40804097', '40804097', '40804097', '40804097', 
 '40804097', '40804097', '40804097', '40804070', '40804070', '40803112', '40803112', '40804038', '40804038', '40804038', '40804038', '40804038', 
 '40804038', '40804038', '40804038', '40804038', '40804038', '40802078', '40801063', '40805018', '40805026', '40805042', '40805034', '40804089', 
 '40804089', '40804089', '40804089', '40804089', '40804089', '40813444', '40806103', '40806081', '40806057', '40809056', '40807029', '40806065', 
 '40807053', '41101340', '41101340', '41101332', '41101332', '41101510', '41101510', '41101553', '41101553', '41101553', '41101596', '41101596', 
 '41101618', '41101618', '41101499', '41101510', '41101537', '41101545', '41101545', '41101537', '41101545', '41101600', '41101561', '41101561', 
 '41101529', '41101529', '41101626', '41101359', '41101359', '41101359', '41101170', '41101170', '41101170', '41101170', '41101170', '41101170', 
 '31602258', '41101251', '41101251', '41101308', '41101308', '41101103', '41101316', '41101278', '41101278', '41101030', '41101219', '41101251', 
 '41101251', '41101316', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101316', '41101316', 
 '41101286', '41101286', '41101316', '41101316', '41101014', '41101014', '41101634', '41101456', '41101251', '41101251', '41101065', '41101090',
 '41101197', '41101235', '41101022', '41101316', '41101316', '41101316', '41101316', '41101480', '41101260', '41101260', '41101260', '41101260', 
 '41101251', '41101251', '41101316', '41101316', '41101316', '41101316', '41101073', '41101014', '41101081', '41101014', '41101308', '41101308', 
 '41101308', '41101308', '41101189', '41101189', '41101200', '41101057', '41101294', '41101294', '41101294', '41101294', '41101111', '41101243',
 '41101243', '41101189', '41101189', '41101316', '41101316', '41101316', '41101316', '41101278', '41101278', '41101278', '41101316', '41101260', 
 '41101260', '41101090', '41101014', '41101022', '41101022', '41101120', '41101120', '41101316', '41101316', '41101316', '41101359', '41101448',
 '41101138', '41101146', '41101138', '41001184', '41001184', '41001176', '41001176', '41001435', '41001435', '41001370', '41001370', '41001478',
 '41001478', '41001478', '41001494', '41001494', '41001494', '41001451', '41001451', '41001397', '41001397', '41001419', '41001419', '41001516', 
 '41001516', '41001230', '41001400', '41001400', '41001443', '41001443', '41001389', '41001389', '41001460', '41001400', '41001400', '41001427', 
 '41001427', '41001524', '41001486', '41001486', '41001508', '41001508', '41001508', '41001508', '41001150', '41001125', '41001125', '41001125', 
 '41001125', '41001150', '41001010', '41001036', '41001044', '41001079', '41001109', '41001109', '41001095', '41001095', '41001095', '31602274',
 '41001150', '41001150', '41001150', '41001150', '41001141', '41001044', '41001117', '41001150', '41001150', '41001125', '41001125', '41001125', 
 '41001125', '41001125', '41001125', '41001125', '41001125', '41001087', '41001141', '41001141', '41001150', '41001150', '41001150', '41001141',
 '41001141', '41001010', '41001010', '41001141', '41001141', '41001141', '41001141', '41001141', '41001036', '41001010', '41001141', '41001141', 
 '41001273', '41001150', '41001150', '41001028', '41001028', '41001281', '41001141', '41001141', '41001141', '41001010', '41001010', '41001028',
 '41001150', '41001150', '41001117', '41001117', '41001150', '41001150', '41001060', '41001060', '41001150', '41001141', '41001141', '41001141', 
 '41001206', '41001141', '41001141', '41001141', '41001036', '41001079', '41001079', '41001141', '41001141', '41001362', '40901130', '40901181', 
 '40901173', '40901130', '40901122', '40901220', '40901220', '40901211', '40901769', '40901211', '40901211', '40901203', '40901220', '40901220', 
 '40901220', '40901220', '40901211', '40901211', '40901220', '40901220', '40901220', '40901220', '40901220', '40901220', '40901203', '40901220', 
 '40901220', '40901211', '40901220', '40901220', '40901203', '40901033', '40901211', '40901211', '40901211', '40902056', '40901220', '40901220', 
 '40901211', '40901114', '40901220', '40901220', '40901238', '40901297', '40901220', '40901220', '40901017', '40901203', '40901211', '40901211', 
 '40901211', '40901211', '40901211', '40901211', '40901220', '40901220', '40901181', '40901181', '40901203', '40901220', '40901220', '40901211', 
 '40901750', '40901335', '40902048', '40901220', '40901220', '40901220', '40901220', '40901220', '40901220', '40901211', '40901211', '40901211', 
 '40901211', '40901211', '40901130', '40901220', '40901220', '40901203', '40901203', '40901041', '40901041', '40901220', '40901220', '40901610', 
 '40901300', '40901319', '40901300', '40901211', '40901211', '40901386', '40901386', '40901394', '40901408', '40901475', '40901475', '40901459', 
 '40901459', '40901408', '40901416', '40901360', '40901386', '40901386', '40901386', '40901386', '40902064', '40901386', '40901386', '40901386', 
 '40901386', '40901386', '40901386', '40901386', '40901602', '40901386', '40901351', '40901360', '40901378', '40901432', '40901408', '40901483', 
 '40901483', '40901467', '40901467', '40901246'))

select 
procedimento,
nvl(sum(janeiro),0)vol_janeiro,
nvl(sum(fevereiro),0)vol_fevereiro,
nvl(sum(marco),0)vol_marco,
nvl(sum(abril),0)vol_abril,
nvl(sum(maio),0)vol_maio,
nvl(sum(junho),0)vol_junho,
nvl(sum(julho),0)vol_julho,
nvl(sum(agosto),0)vol_agosto,
nvl(sum(setembro),0)vol_setembro,
nvl(sum(outubro),0)vol_outubro,
nvl(sum(novembro),0)vol_novembro,
nvl(sum(dezembro),0)vol_dezembro,
sum(qt_lancamento)total_lancamento,
sum(vl_total)vl_total,
round((sum(vl_total) / sum(qt_lancamento)),2)ticket_medio

from
(
select 
econv.cd_multi_empresa casa,
pf.cd_pro_fat||' - '||pf.ds_pro_Fat procedimento,
case when to_char(irf.dt_lancamento,'mm') = 01 then SUM(irf.qt_lancamento) end JANEIRO,
case when to_char(irf.dt_lancamento,'mm') = 02 then SUM(irf.qt_lancamento) end FEVEREIRO,  
  case when to_char(irf.dt_lancamento,'mm') = 03 then SUM(irf.qt_lancamento) end MARCO,
  case when to_char(irf.dt_lancamento,'mm') = 04 then SUM(irf.qt_lancamento) end ABRIL,  
    case when to_char(irf.dt_lancamento,'mm') = 05 then SUM(irf.qt_lancamento) end MAIO,
      case when to_char(irf.dt_lancamento,'mm') = 06 then SUM(irf.qt_lancamento) end JUNHO,
        case when to_char(irf.dt_lancamento,'mm') = 07 then SUM(irf.qt_lancamento) end JULHO,
          case when to_char(irf.dt_lancamento,'mm') = 08 then SUM(irf.qt_lancamento) end AGOSTO,
            case when to_char(irf.dt_lancamento,'mm') = 09 then SUM(irf.qt_lancamento) end SETEMBRO,
              case when to_char(irf.dt_lancamento,'mm') = 10 then SUM(irf.qt_lancamento) end OUTUBRO,
                case when to_char(irf.dt_lancamento,'mm') = 11 then SUM(irf.qt_lancamento) end NOVEMBRO,
                  case when to_char(irf.dt_lancamento,'mm') = 12 then SUM(irf.qt_lancamento) end DEZEMBRO,
                   
irf.qt_lancamento,
irf.vl_total_Conta vl_total
from 
dbamv.itreg_fat irf 
inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join convenio conv on conv.cd_convenio = rf.cd_convenio and conv.tp_convenio = 'C'
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
and econv.cd_multi_empresa = 7 
inner join proft pf on pf.cd_pro_fat = irf.cd_pro_fat
where to_date(irf.dt_lancamento,'DD/MM/RRRR') between '01/01/2022' and '31/12/2022'
AND RF.SN_FECHADA = 'S'
AND RF.CD_REMESSA IS NOT NULL
and IRF.SN_PERTENCE_PACOTE = 'N'
group by 
econv.cd_multi_empresa,
pf.cd_pro_fat,
pf.ds_pro_Fat,
irf.dt_lancamento,
irf.qt_lancamento,
irf.vl_total_Conta 

union 

select 
econvx.cd_multi_empresa casa,
pfz.cd_pro_fat||' - '||pfz.ds_pro_fat procedimento,
case when to_char(iramb.hr_lancamento,'mm') = 01 then SUM(iramb.qt_lancamento) end JANEIRO,
case when to_char(iramb.hr_lancamento,'mm') = 02 then SUM(iramb.qt_lancamento) end FEVEREIRO,  
  case when to_char(iramb.hr_lancamento,'mm') = 03 then SUM(iramb.qt_lancamento) end MARCO,
  case when to_char(iramb.hr_lancamento,'mm') = 04 then SUM(iramb.qt_lancamento) end ABRIL,  
    case when to_char(iramb.hr_lancamento,'mm') = 05 then SUM(iramb.qt_lancamento) end MAIO,
      case when to_char(iramb.hr_lancamento,'mm') = 06 then SUM(iramb.qt_lancamento) end JUNHO,
        case when to_char(iramb.hr_lancamento,'mm') = 07 then SUM(iramb.qt_lancamento) end JULHO,
          case when to_char(iramb.hr_lancamento,'mm') = 08 then SUM(iramb.qt_lancamento) end AGOSTO,
            case when to_char(iramb.hr_lancamento,'mm') = 09 then SUM(iramb.qt_lancamento) end SETEMBRO,
              case when to_char(iramb.hr_lancamento,'mm') = 10 then SUM(iramb.qt_lancamento) end OUTUBRO,
                case when to_char(iramb.hr_lancamento,'mm') = 11 then SUM(iramb.qt_lancamento) end NOVEMBRO,
                  case when to_char(iramb.hr_lancamento,'mm') = 12 then SUM(iramb.qt_lancamento) end DEZEMBRO,
iramb.qt_lancamento,
iramb.vl_total_conta

from 
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join convenio convx on convx.cd_convenio = ramb.cd_convenio and convx.tp_convenio = 'C'
inner join empresa_convenio econvx on econvx.cd_convenio = convx.cd_convenio 
and econvx.cd_multi_empresa = 7 
inner join proft pfz on pfz.cd_pro_fat = iramb.cd_pro_fat
where to_date(iramb.hr_lancamento,'DD/MM/RRRR') between '01/01/2022' and '31/12/2022'
and iramb.sn_fechada = 'S'
and ramb.cd_remessa is not null 
group by 
econvx.cd_multi_empresa,
pfz.cd_pro_fat,
pfz.ds_pro_Fat,
iramb.hr_lancamento,
iramb.qt_lancamento,
iramb.vl_total_Conta 

)group by procedimento
order by 1 

;
------ PARTICULAR  --------
WITH proftx AS (
select 
pf.cd_pro_fat,
pf.ds_pro_fat,
pf.cd_gru_pro,
pf.ds_unidade
from dbamv.pro_Fat pf where pf.cd_pro_fat in 
('40808122', '40808130', '40808149', '30911044', '40813720', '40813568', '30911117', '40808041', '40813029', '40809161', '40809170', '23999980', 
'40813436', '40813460', '40813525', '40813452', '40902110', '40813479', '40813410', '40813487', '40814157', '40808190', '40809170', '40809170',
 '40809170', '40809170', '40809170', '40809170', '40813410', '40902048', '40808025', '40808017', '40808017', '40801128', '40803104', '40803104', 
 '40801101', '40803066', '40803066', '40804038', '40804038', '40803023', '40804020', '40801110', '40804011', '40803082', '40803082', '40804100', 
 '40804100', '40801128', '40803040', '40803040', '40802019', '40802027', '40802035', '40802043', '40802086', '40802060', '40802051', '40802035', 
 '40802094', '40803031', '40803031', '40803090', '40803090', '40804046', '40804046', '40801012', '40801020', '40801039', '40804119', '40803058', 
 '40803058', '40806030', '40803015', '40806049', '40802116', '40801209', '40803147', '40804054', '40804054', '40804054', '40804054', '40804054', 
 '40804054', '40804062', '40804054', '40805077', '40801110', '40803120', '40803120', '40803120', '40803120', '40803139', '40801047', '40801080', 
 '40805069', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', '40803074', 
 '40803074', '40803074', '40801055', '40801098', '40801098', '40804127', '40804062', '40804097', '40804097', '40804097', '40804097', '40804097', 
 '40804097', '40804097', '40804097', '40804070', '40804070', '40803112', '40803112', '40804038', '40804038', '40804038', '40804038', '40804038', 
 '40804038', '40804038', '40804038', '40804038', '40804038', '40802078', '40801063', '40805018', '40805026', '40805042', '40805034', '40804089', 
 '40804089', '40804089', '40804089', '40804089', '40804089', '40813444', '40806103', '40806081', '40806057', '40809056', '40807029', '40806065', 
 '40807053', '41101340', '41101340', '41101332', '41101332', '41101510', '41101510', '41101553', '41101553', '41101553', '41101596', '41101596', 
 '41101618', '41101618', '41101499', '41101510', '41101537', '41101545', '41101545', '41101537', '41101545', '41101600', '41101561', '41101561', 
 '41101529', '41101529', '41101626', '41101359', '41101359', '41101359', '41101170', '41101170', '41101170', '41101170', '41101170', '41101170', 
 '31602258', '41101251', '41101251', '41101308', '41101308', '41101103', '41101316', '41101278', '41101278', '41101030', '41101219', '41101251', 
 '41101251', '41101316', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101227', '41101316', '41101316', 
 '41101286', '41101286', '41101316', '41101316', '41101014', '41101014', '41101634', '41101456', '41101251', '41101251', '41101065', '41101090',
 '41101197', '41101235', '41101022', '41101316', '41101316', '41101316', '41101316', '41101480', '41101260', '41101260', '41101260', '41101260', 
 '41101251', '41101251', '41101316', '41101316', '41101316', '41101316', '41101073', '41101014', '41101081', '41101014', '41101308', '41101308', 
 '41101308', '41101308', '41101189', '41101189', '41101200', '41101057', '41101294', '41101294', '41101294', '41101294', '41101111', '41101243',
 '41101243', '41101189', '41101189', '41101316', '41101316', '41101316', '41101316', '41101278', '41101278', '41101278', '41101316', '41101260', 
 '41101260', '41101090', '41101014', '41101022', '41101022', '41101120', '41101120', '41101316', '41101316', '41101316', '41101359', '41101448',
 '41101138', '41101146', '41101138', '41001184', '41001184', '41001176', '41001176', '41001435', '41001435', '41001370', '41001370', '41001478',
 '41001478', '41001478', '41001494', '41001494', '41001494', '41001451', '41001451', '41001397', '41001397', '41001419', '41001419', '41001516', 
 '41001516', '41001230', '41001400', '41001400', '41001443', '41001443', '41001389', '41001389', '41001460', '41001400', '41001400', '41001427', 
 '41001427', '41001524', '41001486', '41001486', '41001508', '41001508', '41001508', '41001508', '41001150', '41001125', '41001125', '41001125', 
 '41001125', '41001150', '41001010', '41001036', '41001044', '41001079', '41001109', '41001109', '41001095', '41001095', '41001095', '31602274',
 '41001150', '41001150', '41001150', '41001150', '41001141', '41001044', '41001117', '41001150', '41001150', '41001125', '41001125', '41001125', 
 '41001125', '41001125', '41001125', '41001125', '41001125', '41001087', '41001141', '41001141', '41001150', '41001150', '41001150', '41001141',
 '41001141', '41001010', '41001010', '41001141', '41001141', '41001141', '41001141', '41001141', '41001036', '41001010', '41001141', '41001141', 
 '41001273', '41001150', '41001150', '41001028', '41001028', '41001281', '41001141', '41001141', '41001141', '41001010', '41001010', '41001028',
 '41001150', '41001150', '41001117', '41001117', '41001150', '41001150', '41001060', '41001060', '41001150', '41001141', '41001141', '41001141', 
 '41001206', '41001141', '41001141', '41001141', '41001036', '41001079', '41001079', '41001141', '41001141', '41001362', '40901130', '40901181', 
 '40901173', '40901130', '40901122', '40901220', '40901220', '40901211', '40901769', '40901211', '40901211', '40901203', '40901220', '40901220', 
 '40901220', '40901220', '40901211', '40901211', '40901220', '40901220', '40901220', '40901220', '40901220', '40901220', '40901203', '40901220', 
 '40901220', '40901211', '40901220', '40901220', '40901203', '40901033', '40901211', '40901211', '40901211', '40902056', '40901220', '40901220', 
 '40901211', '40901114', '40901220', '40901220', '40901238', '40901297', '40901220', '40901220', '40901017', '40901203', '40901211', '40901211', 
 '40901211', '40901211', '40901211', '40901211', '40901220', '40901220', '40901181', '40901181', '40901203', '40901220', '40901220', '40901211', 
 '40901750', '40901335', '40902048', '40901220', '40901220', '40901220', '40901220', '40901220', '40901220', '40901211', '40901211', '40901211', 
 '40901211', '40901211', '40901130', '40901220', '40901220', '40901203', '40901203', '40901041', '40901041', '40901220', '40901220', '40901610', 
 '40901300', '40901319', '40901300', '40901211', '40901211', '40901386', '40901386', '40901394', '40901408', '40901475', '40901475', '40901459', 
 '40901459', '40901408', '40901416', '40901360', '40901386', '40901386', '40901386', '40901386', '40902064', '40901386', '40901386', '40901386', 
 '40901386', '40901386', '40901386', '40901386', '40901602', '40901386', '40901351', '40901360', '40901378', '40901432', '40901408', '40901483', 
 '40901483', '40901467', '40901467', '40901246'))
----- OPERADORAS --------
select 
procedimento,
nvl(sum(janeiro),0)vol_janeiro,
nvl(sum(fevereiro),0)vol_fevereiro,
nvl(sum(marco),0)vol_marco,
nvl(sum(abril),0)vol_abril,
nvl(sum(maio),0)vol_maio,
nvl(sum(junho),0)vol_junho,
nvl(sum(julho),0)vol_julho,
nvl(sum(agosto),0)vol_agosto,
nvl(sum(setembro),0)vol_setembro,
nvl(sum(outubro),0)vol_outubro,
nvl(sum(novembro),0)vol_novembro,
nvl(sum(dezembro),0)vol_dezembro,
sum(qt_lancamento)total_lancamento,
sum(vl_total)vl_total,
round((sum(vl_total) / sum(qt_lancamento)),2)ticket_medio

from
(
select 
econv.cd_multi_empresa casa,
pfx.cd_pro_fat||' - '||pfx.ds_pro_Fat procedimento,
case when to_char(irf.dt_lancamento,'mm') = 01 then SUM(irf.qt_lancamento) end JANEIRO,
case when to_char(irf.dt_lancamento,'mm') = 02 then SUM(irf.qt_lancamento) end FEVEREIRO,  
  case when to_char(irf.dt_lancamento,'mm') = 03 then SUM(irf.qt_lancamento) end MARCO,
  case when to_char(irf.dt_lancamento,'mm') = 04 then SUM(irf.qt_lancamento) end ABRIL,  
    case when to_char(irf.dt_lancamento,'mm') = 05 then SUM(irf.qt_lancamento) end MAIO,
      case when to_char(irf.dt_lancamento,'mm') = 06 then SUM(irf.qt_lancamento) end JUNHO,
        case when to_char(irf.dt_lancamento,'mm') = 07 then SUM(irf.qt_lancamento) end JULHO,
          case when to_char(irf.dt_lancamento,'mm') = 08 then SUM(irf.qt_lancamento) end AGOSTO,
            case when to_char(irf.dt_lancamento,'mm') = 09 then SUM(irf.qt_lancamento) end SETEMBRO,
              case when to_char(irf.dt_lancamento,'mm') = 10 then SUM(irf.qt_lancamento) end OUTUBRO,
                case when to_char(irf.dt_lancamento,'mm') = 11 then SUM(irf.qt_lancamento) end NOVEMBRO,
                  case when to_char(irf.dt_lancamento,'mm') = 12 then SUM(irf.qt_lancamento) end DEZEMBRO,
                   
irf.qt_lancamento,
irf.vl_total_Conta vl_total
from 
dbamv.itreg_fat irf 
inner join dbamv.reg_fat rf on rf.cd_reg_fat = irf.cd_reg_fat
inner join convenio conv on conv.cd_convenio = rf.cd_convenio and conv.tp_convenio = 'P'
inner join empresa_convenio econv on econv.cd_convenio = conv.cd_convenio
and econv.cd_multi_empresa = 7 
inner join proftx pfx on pfx.cd_pro_fat = irf.cd_pro_fat
where to_date(irf.dt_lancamento,'DD/MM/RRRR') between '01/01/2022' and '31/12/2022'
AND RF.SN_FECHADA = 'S'
AND RF.CD_REMESSA IS NOT NULL
and IRF.SN_PERTENCE_PACOTE = 'N'
group by 
econv.cd_multi_empresa,
pfx.cd_pro_fat,
pfx.ds_pro_Fat,
irf.dt_lancamento,
irf.qt_lancamento,
irf.vl_total_Conta 

union 

select 
econvx.cd_multi_empresa casa,
pfxx.cd_pro_fat||' - '||pfxx.ds_pro_fat procedimento,
case when to_char(iramb.hr_lancamento,'mm') = 01 then SUM(iramb.qt_lancamento) end JANEIRO,
case when to_char(iramb.hr_lancamento,'mm') = 02 then SUM(iramb.qt_lancamento) end FEVEREIRO,  
  case when to_char(iramb.hr_lancamento,'mm') = 03 then SUM(iramb.qt_lancamento) end MARCO,
  case when to_char(iramb.hr_lancamento,'mm') = 04 then SUM(iramb.qt_lancamento) end ABRIL,  
    case when to_char(iramb.hr_lancamento,'mm') = 05 then SUM(iramb.qt_lancamento) end MAIO,
      case when to_char(iramb.hr_lancamento,'mm') = 06 then SUM(iramb.qt_lancamento) end JUNHO,
        case when to_char(iramb.hr_lancamento,'mm') = 07 then SUM(iramb.qt_lancamento) end JULHO,
          case when to_char(iramb.hr_lancamento,'mm') = 08 then SUM(iramb.qt_lancamento) end AGOSTO,
            case when to_char(iramb.hr_lancamento,'mm') = 09 then SUM(iramb.qt_lancamento) end SETEMBRO,
              case when to_char(iramb.hr_lancamento,'mm') = 10 then SUM(iramb.qt_lancamento) end OUTUBRO,
                case when to_char(iramb.hr_lancamento,'mm') = 11 then SUM(iramb.qt_lancamento) end NOVEMBRO,
                  case when to_char(iramb.hr_lancamento,'mm') = 12 then SUM(iramb.qt_lancamento) end DEZEMBRO,
iramb.qt_lancamento,
iramb.vl_total_conta

from 
dbamv.reg_amb ramb 
inner join dbamv.itreg_amb iramb on iramb.cd_reg_amb = ramb.cd_reg_amb
inner join convenio convx on convx.cd_convenio = ramb.cd_convenio and convx.tp_convenio = 'P'
inner join empresa_convenio econvx on econvx.cd_convenio = convx.cd_convenio 
and econvx.cd_multi_empresa = 7 
inner join proftx pfxx on pfxx.cd_pro_fat = iramb.cd_pro_fat
where to_date(iramb.hr_lancamento,'DD/MM/RRRR') between '01/01/2022' and '31/12/2022'
and iramb.sn_fechada = 'S'
and iramb.sn_pertence_pacote = 'N'
and ramb.cd_remessa is not null 
group by 
econvx.cd_multi_empresa,
pfxx.cd_pro_fat,
pfxx.ds_pro_Fat,
iramb.hr_lancamento,
iramb.qt_lancamento,
iramb.vl_total_Conta 

)group by procedimento
order by 1 

