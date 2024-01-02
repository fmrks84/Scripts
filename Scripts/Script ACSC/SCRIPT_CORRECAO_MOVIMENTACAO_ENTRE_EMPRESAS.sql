select cd_multi_empresa, cd_atendimento
from atendime
where cd_atendimento in 
(4532057)--(4905377,4905636,4906190,4914786,4914193,4910159,4911160)--Empresa 4
order by 2
--(4908175,1910758,4910857,4911449,4912165,4912356,4912493,4912656,4912751,4912910,4913483)
;



select  p.cd_protocolo_doc,
        it.cd_atendimento,
        p.cd_setor,
        s.nm_setor,
        s.cd_multi_empresa,
        p.cd_setor_destino,
        s2.nm_setor nm_setor_destino,
        s2.cd_multi_empresa,
     --  s2.cd_multi_empresa,
        p.dt_envio,
        p.nm_usuario_envio,
        it.dt_recebimento,
        u.NM_USUARIO
from protocolo_doc p
inner join it_protocolo_doc it on (p.cd_protocolo_doc = it.cd_protocolo_doc)
inner join setor s on (s.cd_setor = p.cd_setor)
inner join setor s2 on (s2.cd_setor = p.cd_setor_destino)
inner join dbasgu.vw_usuarios u on u.CD_USUARIO = p.nm_usuario_envio
where it.cd_atendimento in (4532057)--(4905377,4905636,4906190,4914786,4914193,4910159)
--and p.cd_setor_destino in (3294)
order by 7 desc
;


3729 - FATURAMENTO SUS - 3733
1074 - SPP SERV DE PRONT DO PACIENTE - 85
select * from setor where  cd_multi_empresa = 7 --and --cd_Setor in (3729,1043,1074,3727) order by 2
select * from setor where  cd_Setor in (3735) order by 2

update protocolo_doc x set x.cd_setor = 37  where x.cd_setor = 798 and x.cd_protocolo_doc = 3368977;
update protocolo_doc x set x.Cd_Setor_Destino = 3733 where x.cd_setor_destino = 3714 and x.cd_protocolo_doc = 3368977;
commit


--update protocolo_doc x set x.Cd_Setor = 17 where x.cd_setor = 3097 and x.cd_protocolo_doc = 2846546

update protocolo_doc u set u.cd_setor = 151, u.cd_setor_destino = 3733 
where u.cd_protocolo_doc in 
(select uu.cd_protocolo_doc from it_protocolo_doc uu where uu.cd_atendimento in (4913790)
)


select * from it_protocolo_doc uu where uu.cd_protocolo_doc = 3341134-- uu.cd_atendimento = 4913790;
select * from protocolo_doc ux where  ux.cd_protocolo_doc = 3341134-- ux.cd_atendimento = 4911160


-- log movimentacoes
select 
protocolo_doc.cd_setor,
ste.nm_setor,
protocolo_doc.dt_envio,
protocolo_doc.nm_usuario_envio,
protocolo_doc.cd_setor_destino,
stef.nm_setor,
it_protocolo_doc.dt_recebimento,
it_protocolo_doc.nm_usuario_recebimento,
--it_protocolo_doc.ds_observacao,
protocolo_doc.ds_observacao

from 
it_protocolo_doc ,
protocolo_doc ,
setor ste,
setor stef
where it_protocolo_doc.cd_protocolo_doc =  protocolo_doc.cd_protocolo_doc
and protocolo_doc.cd_setor = ste.cd_setor
and protocolo_doc.cd_setor_destino = stef.cd_setor
and it_protocolo_doc.cd_atendimento = 4532057
and it_protocolo_doc.cd_documento_prot = 1 
order by protocolo_doc.dt_envio

