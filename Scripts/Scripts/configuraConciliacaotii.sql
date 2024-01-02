/*
MV SISTEMAS
05/06/2009
--
Este Script Ativa a configuração de geração dos dados conciliado p/ o retorno de glosa por convênio.
Caso a configuração não seja feita automaticamente o script exibirá um log com quais convênios não foram configurados.
(p/ ser exibido esse log,tem que ser ativado o OUTPUT(ON) do navigator em caso do SQL TOOLS não é necessário ativar ,
 pois o mesmo já vem ativo por default)
*/
declare

bEntrouValidacao boolean := false;
nCont number:=0;
begin
    for x in (Select * from dbamv.convenio_conf_tiss) loop
       bEntrouValidacao := false;
       for y in (select distinct cd_convenio from dbamv.empresa_convenio where cd_Convenio = x.cd_convenio
                  and sn_recebe_detalhado_ffcv = 'N') loop
           bEntrouValidacao := true;
           nCont := nCont + 1;
       end loop;
       
       if not bEntrouValidacao  then
            update dbamv.convenio set sn_importa_glosa_receb = 'S' where cd_Convenio = x.cd_Convenio;
            commit;
       else
        dbms_output.put_line('o convênio-('||x.cd_convenio||') '||'NÃO foi configurado automaticamente');
       end if;
    end loop;
    
    if nCont > 0 then
       dbms_output.put_line('os convênios listados acima possuem empresa(s) c/ a configuração (Recebe Contas Detalhadas?) desativada');
    end if;
end;
