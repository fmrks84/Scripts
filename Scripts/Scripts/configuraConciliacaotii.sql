/*
MV SISTEMAS
05/06/2009
--
Este Script Ativa a configura��o de gera��o dos dados conciliado p/ o retorno de glosa por conv�nio.
Caso a configura��o n�o seja feita automaticamente o script exibir� um log com quais conv�nios n�o foram configurados.
(p/ ser exibido esse log,tem que ser ativado o OUTPUT(ON) do navigator em caso do SQL TOOLS n�o � necess�rio ativar ,
 pois o mesmo j� vem ativo por default)
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
        dbms_output.put_line('o conv�nio-('||x.cd_convenio||') '||'N�O foi configurado automaticamente');
       end if;
    end loop;
    
    if nCont > 0 then
       dbms_output.put_line('os conv�nios listados acima possuem empresa(s) c/ a configura��o (Recebe Contas Detalhadas?) desativada');
    end if;
end;
