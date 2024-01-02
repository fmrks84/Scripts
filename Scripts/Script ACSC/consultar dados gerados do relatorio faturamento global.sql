select 
b1.cd_ori_ate,
sum(a.vl_total_conta)
from 
dbamv.itreg_amb a
inner join reg_amb b on b.cd_reg_amb = a.cd_reg_amb
inner join atendime b1 on b1.cd_atendimento = a.cd_atendimento
where b1.cd_ori_ate in (143,145,421,581,150,149,141) 
--a.Cd_Setor = 1363
--and a.sn_fechada = 'N'
and trunc(a.hr_lancamento) between '01/03/2021' and '01/03/2021'
group by b1.cd_ori_ate
order by sum(a.vl_total_conta) desc 

-- QUIMIOTERAPICO ??
;

select 
sum(b1.vl_total_conta)
from 
dbamv.itreg_fat a1
inner join reg_fat b1 on b1.cd_reg_fat = a1.cd_reg_fat
inner join atendime atd on atd.cd_atendimento = b1.cd_atendimento
where a1.cd_pro_Fat in ('90184050',
'90184076',
'90184114',
'90184106',
'90321790',
'90343115',
'90184580',
'90184599',
'90294432',
'90348737',
'90348729',
'90321766',
'90331796',
'90349075',
'90144473',
'90144457',
'90144384',
'90144376',
'90144350',
'90232321',
'90144333',
'90144481',
'90144490',
'90144546',
'90144562',
'90144554',
'90380738',
'90380720',
'90359550',
'90035593',
'90298080',
'90035593',
'90255143',
'90230280',
'90230299',
'90016815',
'90016807',
'00023427',
'00025501',
'90330510',
'90191730',
'90172655',
'90172663',
'90330595',
'90029925',
'90031130',
'90254627',
'90254635',
'00039353',
'90184106',
'90184114',
'90107250',
'90221044',
'90195620',
'90144350',
'90232321',
'90002040',
'90030630',
'90030621',
'90144333',
'90034988',
'90382897',
'90160266',
'90160282',
'90020294',
'90020294',
'90020308',
'90144376',
'90144368',
'90002083',
'90030729',
'90144384',
'90144406',
'90002113',
'90130529',
'90144414',
'90228308',
'90131371',
'90091221',
'02008406',
'90144562',
'90144554',
'90067576',
'90091230',
'00071340',
'02008425',
'90131738',
'90131770',
'90184491',
'90184483',
'90002156',
'90051319',
'90144686',
'90191510',
'90292464',
'90002164',
'90051327',
'90144694',
'90191528',
'90355962',
'90133820',
'90039297',
'90133846',
'90355954',
'90039300',
'90002172',
'90343980',
'90130880',
'90215478',
'90265670',
'90130898',
'90215460',
'90251180',
'90343972',
'90265700',
'90047117',
'90090870',
'90094794',
'90099389',
'90124979',
'90124979',
'90124979',
'90254619',
'90254619',
'90344138',
'90105699',
'90227190',
'90227190',
'90068351',
'90068360',
'90214838',
'90194497',
'90071719',
'90389700',
'90194497',
'90194497',
'90194527',
'90071727',
'90389719',
'90194527',
'90194527',
'90339703',
'90126963',
'90126963',
'90126963',
'90213815',
'90030850',
'90344030',
'90203160',
'90174348',
'90174348',
'90174348',
'90242017',
'90346386',
'90219040',
'90126580',
'90031423',
'90126580',
'90144473',
'90002300',
'90144457',
'90144490',
'90144481',
'90068742',
'90144651',
'90015835',
'90015835',
'90311221',
'90020189',
'90268920',
'90087976',
'90031989',
'90020537',
'90031989',
'90069544',
'90235851',
'90144503',
'90002440',
'90144538',
'90203275',
'90132858',
'90144546',
'90172620',
'90172620',
'90172620',
'90172620',
'90173392',
'90241975',
'90145119',
'90331770',
'90331796',
'90267648',
'90267664',
'90051114',
'90267656',
'90267672',
'90184580',
'90184580',
'90184599',
'90184599',
'90144295',
'90291980',
'90215346',
'90049900',
'90049896',
'90254953',
'90214277',
'90184050',
'90184076',
'90089111',
'90215508',
'90106997',
'90076907',
'90221079',
'90221052',
'90030168',
'90130537',
'90250648',
'90250630',
'90250435',
'90294432',
'90321766',
'90321758',
'90105915',
'90218973',
'90218973',
'90291891',
'90002180',
'90292618',
'02034053',
'90265513',
'90255224',
'90321790',
'90330595',
'90276582',
'90298047',
'02034879',
'90282213',
'90348729',
'90404777',
'90343115',
'90349075',
'90348737',
'90357507',
'90359550',
'90342038',
'90380720',
'90380738',
'90346394',
'90383818',
'90076915',
'90330641',
'90218574',
'90070003',
'90382293',
'90382307',
'90363183',
'90288963',
'90288963',
'00077844',
'90068750',
'90416783',
'90359550',
'00039353',
'90107250',
'90221044',
'90195620',
'90034988',
'90030664',
'90030680',
'90002105',
'90130545',
'90228308',
'90002156',
'90051319',
'90144686',
'90191510',
'90292464',
'90002164',
'90051327',
'90144694',
'90191528',
'90344189',
'90344138',
'90144317',
'90144325',
'90105699',
'90144236',
'90144651',
'90068980',
'90020367',
'90087976',
'90144538',
'90069919',
'90241983',
'90267648',
'90267664',
'90051114',
'90267656',
'90267672',
'90144295',
'90035879',
'90214277',
'90184050',
'90184076',
'90089111',
'90250648',
'90250630',
'90294432',
'90321766',
'90321758',
'90255224',
'90298047',
'02034879',
'90282213',
'90348729',
'90349075',
'90348737',
'90380720',
'90380738',
'90383818',
'00299141',
'90288963',
'90144236',
'90426053')
and atd.cd_ori_ate = 361
and atd.cd_multi_empresa = 10
and trunc(a1.hr_lancamento) between '01/02/2021' and '02/02/2021'

