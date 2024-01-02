--- convenio que geram nota fiscal por paciente --
select a.cd_convenio, a.cd_multi_empresa, a.sn_gera_nf_conv_paciente from dbamv.empresa_convenio a 
where a.cd_multi_empresa = 5
and a.sn_gera_nf_conv_paciente = 'S'
--and a.cd_convenio in (5,6,7,9,11,21,27,28,32,39,300,301,302,309,321,322,327,330,332,334,339,342,350,353,354,392,394,408,414)
for update 
--order by a.cd_convenio ;

------  chave onde será informado o dado do intermediário

select * from dbamv.configuracao b 
where b.chave = 'DS_CONVENIOS_INTERMEDIARIOS'
and b.cd_multi_empresa = 5
for update ;


---- chave onde informa o codigo do serviço prestado
select c.chave, c. valor , c.cd_multi_empresa from dbamv.configuracao c
where c.chave = 'COD_SERV_NFE_EMP';

/*-- CONVENIOS QUE GERAM NF POR PACIENTE EMPRESA 5
(5,6,7,9,11,21,27,28,32,39,300,301,302,309,318,321,322,327,330,332,334,339,342,350,353,354,392,394,408,414)
*/

select z.cd_convenio, z.nm_convenio from dbamv.convenio z where z.cd_convenio in (5,6,7,11,28,32,300,301,309,318,322,327,330,339,392,408,414)
