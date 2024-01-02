CREATE OR REPLACE FUNCTION dbamv.fnc_ffcv_url_nfe (nCdNotaFiscal NUMBER, vUrlEntrada varchar2) RETURN VARCHAR2 is
  /* Autor: Diego Costa
   * Data: 03/08/2016
   * Objetivo: Essa função tem por objetivo substiituir marcações de texto, na URL de consulta de NFe, por valores.
   *           A URL com parâmetro deve ser configurada tela de configurações da nota fiscal. Lá será definida a url
   *           de consulta do espelho da nota fiscal eletrônica.
   *
   *           A rotina identifica as marcações, extrai o nome de campos da tabela de nota fiscal, executa a consulta
   *           de valores desses campos e substitui na string da url.
   *
   *           Os marcadores [#MV#_ e _#MV#], delimitam o ínício e o fim do valor do campo, semelhante a abertura de tags
   *           de um xml.
   *
   *           É possível colocar funções de sql, na informação do campo, como replace, to_date ou substr. É preciso ficar atendo
   *           as aspas simples, utilizadas nessas funções, pois pode torna a string da rul inválida, perante avaliação do banco Oracle.
   *
   *           Exemplo:
   *            urlEntrada: https://notacarioca.rio.gov.br/contribuinte/notaprint.aspx?nf=[#MV#_NR_NOTA_FISCAL_NFE_#MV#]&inscricao=83674&verificacao=[#MV#_replace(CD_VERIFICACAO_NFE, ''-'', '''')_#MV#]&returnurl=..%2fDocumentos%2fverificacao.aspx
   *            urlSaida: https://notacarioca.rio.gov.br/contribuinte/notaprint.aspx?nf=20126&inscricao=83674&verificacao=CV9K76PZ&returnurl=..%2fDocumentos%2fverificacao.aspx
   *
   *            No exemplo acima, a rotina identificou o campo NR_NOTA_FISCAL_NFE e replace(CD_VERIFICACAO_NFE, '-', ''), e substituiu pelo valor encontrado na base.
   *
   * Parâmetros: nCdNotaFiscal - Código da nota fiscal que precisa ser identificada a url de consulta
   *             vUrlEntrada - URL com parâmetros que precisam ser substituídos.
   *
   * Limitação: Essa função só substitui campos e valores obtidos na tela de nota fiscal. Caso a url tenha informações da empresa, como a IM, o valor deve ser fixado diretamente na
   *            url de entrada, visto que a parametrização já é realizada por empresa.
   */
  delimitadorInicical VARCHAR2(6) := '[#MV#_';
  delimitadorFinal VARCHAR2(6) := '_#MV#]';
  url VARCHAR2(8000) := '';
  urlAux VARCHAR2(8000);
  vCampo varchar2(1000);
  vValorCampo varchar2(32000);
  nPosInicial NUMBER;
  nPosFinal NUMBER;
  nQtdCaracteres NUMBER;
BEGIN
  IF Length(vUrlEntrada) > 0 THEN
    urlAux := vUrlEntrada;
    url := vUrlEntrada;
    WHILE (InStr(urlAux, delimitadorInicical) > 0 ) LOOP
      nPosInicial := 0;
      nPosFinal := 0;
      nQtdCaracteres := 0;
      nPosInicial := InStr(urlAux, delimitadorInicical) + 6;
      nPosFinal := InStr(urlAux, delimitadorFinal);
      nQtdCaracteres := nPosFinal - nPosInicial;
      vCampo := SubStr(urlAux, nPosInicial, nQtdCaracteres);
      execute IMMEDIATE 'select '||vCampo||' from dbamv.nota_fiscal where cd_nota_fiscal = '||nCdNotaFiscal INTO vValorCampo;
      url := REPLACE(url, delimitadorInicical || vCampo || delimitadorFinal, vValorCampo);
      urlAux := SubStr(urlAux, (nPosFinal + 6), Length(urlAux));
    END LOOP;
  END IF;
  RETURN url;
EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20999, 'Erro ao formatar URL de consulta de espelho da nota fiscal. Verifique se a URL configurada nos parâmetros da Nota Fiscal, está corretamente definida.' || Chr(10) || 'Erro: ' || SQLERRM);
END;
/

GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO dbacp WITH GRANT OPTION;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO dbaportal WITH GRANT OPTION;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO dbaps;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO dbasgu;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO mv2000;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO mvbike;
GRANT EXECUTE ON dbamv.fnc_ffcv_url_nfe TO mvintegra;
