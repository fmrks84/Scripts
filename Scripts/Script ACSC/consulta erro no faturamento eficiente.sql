SELECT  atendime.cd_multi_empresa,
        atendime.cd_atendimento,
        atendime.cd_paciente,
        paciente.nm_paciente,
        paciente.nr_cpf cpf,
        paciente.nr_identidade rg,
        atendime.cd_convenio,
        convenio.nm_convenio,
        atendime.cd_con_pla,
        con_pla.ds_con_pla,
        atendime.cd_sub_plano,
        sub_plano.ds_sub_plano,
      --  ensemble.fnc_data_hora(atendime.dt_atendimento, atendime.hr_atendimento) dh_atendimento,
        decode(tp_atendimento,'I','INTERNACAO','U','PRONTO_SOCORRO','E','EXAMES','A','CONSULTA')tp_Atendimento,
        atendime.cd_multi_empresa cd_prestador,
        multi_empresas.ds_multi_empresa nm_prestador,
        atendime.nr_carteira,
        atendime.dt_validade,
     --   ensemble.fnc_data_hora(atendime.dt_alta, atendime.hr_alta) dh_alta,
        case when atendime.tp_atendimento = 'I' then 'INTERNACAO' when atendime.tp_atendimento in ('U','E') then 'SADT' WHEN atendime.tp_atendimento in ('C','A') then 'CONSULTA' END tp_guia,
        case when atendime.tp_carater_internacao in ('E',null) then 'ELETIVO' else 'URGENCIA_EMERGENCIA'end carater_Atendimento,
        case when atendime.cd_tipo_internacao in (1,3) then 'CLINICA'
             when atendime.cd_tipo_internacao in (2,4,26,27,28,29,32) then 'CIRURGICA'
             when atendime.cd_tipo_internacao in (31) then 'OBSTETRICA' end tp_internacao,
        case when atendime.cd_tip_acom in (3,4,61) then 'HOSPITAL_DIA' else 'HOSPITALAR' end regime_Internacao,
        case when (SYSDATE - paciente.dt_nascimento) <= 28 then 'TRUE' else 'false' end atendimento_RN,
        atendime.cd_multi_empresa,
        atendime.cd_guia,
        ori_ate.cd_ori_ate||' - '||ori_ate.ds_ori_ate OrigemAtendimento
   FROM dbamv.atendime,
        dbamv.paciente,
        dbamv.prestador,
        dbamv.convenio,
        dbamv.con_pla,
        dbamv.sub_plano,
        dbamv.multi_empresas,
        dbamv.ori_ate
WHERE convenio.tp_convenio = 'C'
  AND atendime.cd_convenio = convenio.cd_convenio
  AND paciente.cd_paciente = atendime.cd_paciente
  AND prestador.cd_prestador = atendime.cd_prestador
  AND convenio.cd_convenio = con_pla.cd_convenio
  AND con_pla.cd_convenio = sub_plano.cd_convenio(+)
  AND con_pla.cd_con_pla = sub_plano.cd_con_pla(+)
  AND atendime.cd_sub_plano = sub_plano.cd_sub_plano(+)
  AND atendime.cd_con_pla = con_pla.cd_con_pla
  and atendime.cd_multi_empresa = multi_empresas.cd_multi_empresa
  and ori_ate.cd_ori_ate = atendime.cd_ori_ate
  and atendime.cd_convenio IN (152, 154, 170, 180, 156, 377, 185, 8, 9, 53, 12, 5, 13, 41, 48, 7, 641, 22, 73, 70, 80, 88, 104, 68, 69, 72, 98, 100)
  and atendime.cd_atendimento in (3218310
,3218117
,3218806
,3218178
,3218358
,3218608
,3218565
,3218072
,3218077
,3218693
,3218573
,3218501
,3218114
,3218805
,3218304
,3218295
,3218027
,3218359
,3218123
,3218384
,3218801
,3218566
,3218417
,3218190
,3218349
,3218426
,3218224
,3218058
,3218757
,3218042
,3218508
,3218388
,3218156
,3218055
,3218028)
/*(3218042,
3218058,
3218072,
3218077,
3218117,
3218190,
3218224,
3218295,
3218359,
3218384,
3218417,
3218426,
3218501,
3218508,
3218565,
3218566,
3218573,
3218693,
3218801,
3218805
)
*/
;

select 
y.cd_convenio||' - '||
y.nm_convenio,
x.cd_multi_empresa
from 
empresa_convenio x
inner join convenio y on y.cd_convenio = x.cd_convenio
where x.cd_convenio in
(152, 154, 170, 180, 156, 377, 185, 8, 9, 53, 12, 5, 13, 41, 48, 7, 641, 22, 73, 70, 80, 88, 104, 68, 69, 72, 98, 100) 
and x.cd_multi_empresa = 7
order by x.cd_multi_empresa

;
select 
y.cd_convenio,
y.nm_convenio,
x.cd_multi_empresa
from 
empresa_convenio x
inner join convenio y on y.cd_convenio = x.cd_convenio
where y.sn_ativo = 'S'
AND X.SN_ATIVO = 'S'
AND Y.TP_CONVENIO = 'C'
--(152, 154, 170, 180, 156, 377, 185, 8, 9, 53, 12, 5, 13, 41, 48, 7, 641, 22, 73, 70, 80, 88, 104, 68, 69, 72, 98, 100) 
--and x.cd_multi_empresa = 4
--order by x.cd_convenio

/*(3218310
,3218117
,3218806
,3218178
,3218358
,3218608
,3218565
,3218072
,3218077
,3218693
,3218573
,3218501
,3218114
,3218805
,3218304
,3218295
,3218027
,3218359
,3218123
,3218384
,3218801
,3218566
,3218417
,3218190
,3218349
,3218426
,3218224
,3218058
,3218757
,3218042
,3218508
,3218388
,3218156
,3218055
,3218028)
*/
