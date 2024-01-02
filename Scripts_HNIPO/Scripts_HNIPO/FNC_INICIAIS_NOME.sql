create or replace function FNC_HNB_INICIAIS_NOME(P_NOME in varchar)
  return varchar2 is
  vchNomeAux      varchar2(100);
  vchIniciaisNome varchar2(10);
  vchRN           varchar2(3);
begin
  --P_NOME:= 'GERSON DE OLIVEIRA REIS';

  vchIniciaisNome := '';

  vchNomeAux := replace(P_NOME, ' DE ', ' ');
  vchNomeAux := replace(vchNomeAux, ' DAS ', ' ');
  vchNomeAux := replace(vchNomeAux, ' DA ', ' ');
  vchNomeAux := replace(vchNomeAux, ' E ', ' ');
  vchNomeAux := replace(vchNomeAux, ' DO ', ' ');
  vchNomeAux := replace(vchNomeAux, ' DOS ', ' ');
  vchNomeAux := replace(vchNomeAux, ' DI ', ' ');

  if substr(vchNomeAux, 1, 2) = 'RN' then
    vchNomeAux := replace(vchNomeAux, 'RN ', '');
    vchRN      := 'RN ';
  else
    vchRN := '';
  end if;

  --dbms_output.put_line(vchNomeAux);

  while vchNomeAux > ' ' loop
    vchIniciaisNome := vchIniciaisNome || substr(vchNomeAux, 1, 1);
    vchNomeAux      := substr(vchNomeAux,
                              instr(vchNomeAux || ' ', ' ') + 1,
                              length(vchNomeAux));
    --dbms_output.put_line(vchNomeAux);
  end loop;

  vchIniciaisNome := vchRN || vchIniciaisNome;

  return(vchIniciaisNome);
end FNC_HNB_INICIAIS_NOME;
