/*select 

pr.cd_prestador,
pr.nm_prestador,
pr.ds_codigo_conselho,
decode(pr.sn_atuante,'P','Provisorio','S','Atuante','N','Eventual','R','Residente')tipo_participacao,
decode(pr.tp_situacao,'I','Inativo','A','Ativo')situacao,
--pr.dt_inativacao
pt.cd_multi_empresa
from 
*/
update 
prestador pr 
set pr.tp_situacao = 'I', pr.dt_inativacao = '21/06/2023'
where  pr.nm_prestador in ('ADAO ORLANDO CRESPO GON�ALVES' ,
'ADRIANA CARVALHO GALVAO' ,
'ADRIANA DURINGER JACQUES'  ,
'ADRIANA HELENA RAMOS FARO GULIAS'  ,
'ADRIANA MARIA BORGES POMBO'  ,
'ALCEMIR RODRIGUES MOREIRA' ,
'ALENUE NIQUINI RAMOS'  ,
'ALEXANDRE BASTOS RIBEIRO'  ,
'ALEXANDRE GALERA DE BITTENCOURT LOBO'  ,
'ALICE DO PRADO QUEIROZ'  ,
'ALUISIO WANDERLEY DA ROCHA FERREIRA' ,
'AMANDA FRANCELINO DE OLIVEIRA' ,
'ANA BEATRIZ WINTER TAVARES'  ,
'ANA CAROLINA GOMES DA SILVA DANIEL'  ,
'ANA CLAUDIA SEIDINGER' ,
'ANA LUISA QUINTELLA DO COUTO ALEIXO' ,
'ANA LUIZA RUSSO PIUZANA GOMES' ,
'ANA MARIA GALHEIGO DAMACENO' ,
'ANA MARIA SANTOS VIANA'  ,
'ANA PAULA CAIRES SCAPELLATO' ,
'ANA PAULA FRAMBACH SIM�O'  ,
'ANA PAULA SILVA MARTINS' ,
'ANDRE ASSIS RORIGUES'  ,
'ANDREA PAULA DE PAIVA' ,
'ANGELA MARIA PORTUGAL RIZZO' ,
'ANNA CAROLINE WAYAND MARTINS'  ,
'ANNA LAURA NACIF GARCIA' ,
'ANNIE HELENA BASTOS WILSON'  ,
'ANTONIO CLAUDIO DE BARROS PINTO' ,
'ANTONIO RAMIRES DE CARVALHO' ,
'ARMANDO PUIG FILHO'  ,
'ARTHUR VIEIRA DE MORAES WON HELD'  ,
'ARTUR PEZZI CHIMELLI'  ,
'AUGUSTO JOSE GOMES DE OLIVEIRA'  ,
'AUGUSTO OLAVO MARTINS XAVIER'  ,
'AURINO CESAR AGUIAR CHAVES'  ,
'BARBARA KERN NOEL' ,
'BERNARDO FREDERICO PORTUGAL GOMES' ,
'BERNARDO GUERCIO FAISCA' ,
'BERNARDO LISBOA GALVAO SANTOS' ,
'BERNARDO REIS GOMES' ,
'BRENO MARCONDES PENNA DA ROCHA'  ,
'BRUNA COSTA LEMOS SILVA DI NUBILA' ,
'BRUNA DANIELLA RODRIGUES'  ,
'BRUNO ALVIM CARVALHO ARAUJO' ,
'BRUNO ANDRADE SILVA' ,
'BRUNO CURY'  ,
'BRUNO DA SILVEIRA PATARO MOREIRA'  ,
'BRUNO DE OLIVEIRA SOUZA' ,
'BRUNO VOGAS LOMBA TAVARES' ,
'CAMILA BASTOS LAPA'  ,
'CAMILA COSTA BARBOSA'  ,
'CAMILA DE ALMEIDA SAMPAIO' ,
'CAMILA LEMOS ALBERNAZ' ,
'CAMILA MARIA DE BRITO VIEIRA'  ,
'CAMILA PENCINATO REMPTO' ,
'CAMILA PINOTTI DE AZEVEDO' ,
'CAMILA RESENDE DE PAULA' ,
'CAMILA VEIGA BARBOSA'  ,
'CARLOS ALBERTO BARBOSA JUNIOR' ,
'CARLOS EDUARDO PIRES HENRIQUES'  ,
'CARLOS HERMINIO DE SOUZA CARREIRO' ,
'CAROLINA DE MEDEIROS PEDROSA'  ,
'CAROLINA RAPOSO MANHAES' ,
'CAROLINA VERAS CONDE'  ,
'CAROLINE GUIMARAES LIPORACE' ,
'CAROLINE SILVEIRA' ,
'CAROLINY MORAES SILVA' ,
'CASSIA RAMOS COELHO' ,
'CESAR LUIZ DA SILVA GOMES' ,
'CID MOURA DUARTE'  ,
'CLAREANA VIANNEY TESCH DE OLIVEIRA'  ,
'CLARICE BARBOSA GARCIA MILOSKI'  ,
'CLARISSA MAGALHAES BARBOSA'  ,
'CLAUDIA AQUINO BALMANT'  ,
'CLAUDIA AQUINO BALMANT'  ,
'CLAUDIA CORREIA GORINI'  ,
'CLAUDIO SERGIO BATISTA'  ,
'CONRADO DE ALMEIDA FREITAS'  ,
'CRISTIANE BEDRAN MILITO' ,
'CRISTIANE MARTINS DO COUTO'  ,
'DANIEL FALCONE PERRUCI'  ,
'DANIEL SILVA DE OLIVEIRA'  ,
'DANIELA CONTAGE SICCARDI MENEZES'  ,
'DANIELA DA SILVA BRAGA'  ,
'DANIELE GUEDES ALLAN'  ,
'DANIELLE FABIANNE SOBRINHO DOS SANTOS' ,
'DANILO MICHEL BAIA SOUTO'  ,
'DEILTON DUARTE JUNIOR' ,
'DENIS DE MELO PINTO RANGEL'  ,
'DIEGO DE OLIVEIRA REGUETE' ,
'DIEGO SILVA FIGUEIREDO'  ,
'DINIZAR JOSE DE ARAUJO FILHO'  ,
'DIOGO FELIPE DOS SANTOS TOBIAS'  ,
'DIOGO VIEIRA DO AMARAL RODRIGUES'  ,
'DOUGLAS MELLO PAV�O' ,
'EDGAR MEGRE CARVALHO'  ,
'EDGARD ANTONIO SINDORF'  ,
'EDICELLI LOUREIRO SILVA RIBEIRO' ,
'EDUARDO HENRIQUE PEREIRA VIEIRA' ,
'EDUARDO MARCHON LEAO BURLAMAQUI CAMPOS'  ,
'ELDER EVARISTO PAIXAO DA SILVA'  ,
'ELISABETH DA SILVA'  ,
'ELISAMA QUEIROZ BAISCH'  ,
'EMANUEL DOS SANTOS DE ANDRADE' ,
'EMERSON LUIZ SENA DA SILVA'  ,
'FABIANA SANTOS PIERRE' ,
'FABIO SOARES SEGALL' ,
'FABRICIO OLIVEIRA FIRMINO' ,
'FELIPE MEDAUAR REIS DE ANDRADE MOREIRA'  ,
'FELIPE MOREIRA FERNANDES'  ,
'FELIPE SANCHEZ RIBEIRO'  ,
'FERNANDA BAENA SOBREIRA GOMES' ,
'FERNANDA GUIMARAES SABOYA' ,
'FERNANDA LIMA COSTA LIMONGE DE ALMEIDA'  ,
'FERNANDA LOPES SANTOS' ,
'FERNANDA VON SEEHAUSEN'  ,
'FERNANDA YACOUB DINIZ' ,
'FERNANDO ARAUJO MARTINS' ,
'FERNANDO CARNEIRO WERNECK' ,
'FERNANDO JOSE MACEDO MENDES' ,
'FERNANDO JOSE SANTOS DE PINA CABRAL' ,
'FERNANDO LUIZ MEDEIROS XAVIER RODRIGUES' ,
'FLAVIA CARULINE MARTINS RIBEIRO' ,
'FLAVIA DOS SANTOS OLIVEIRA'  ,
'FREDERICO CAVALHEIRO CANHOTO'  ,
'GABRIEL DIAS CONDEIXA' ,
'GABRIEL MOZZOCCO DE SANT ANNA' ,
'GABRIEL SOUZA DOS SANTOS'  ,
'GABRIEL TEIXEIRA BREGUNCE' ,
'GABRIEL VIEIRA MACHADO'  ,
'GABRIELA MONTEIRO BARBOZA' ,
'GIOVANNA CHIMELLI GOMES' ,
'GIOVANNA TARDELLI CORREA'  ,
'GRACIELLE CHRISTINE DO N OLIVEIRA' ,
'GUILHERME DE MACEDO OLIVEIRA'  ,
'GUILHERME GUERRA PINHEIRO DE FARIA'  ,
'GUSTAVO NUNES TELES' ,
'HELENA FERNANDES CASTELO BRANCO SILVA' ,
'HELIO SANCHEZ' ,
'HELOISA HELENA PORTUGAL RIZZO THOMAZ'  ,
'HENRIQUE CHAMARELLI DE BARROS' ,
'HENRIQUE DE PAULA COSTA AVILA' ,
'HENRIQUE SALLES BARBOSA' ,
'HUGO CORREA SCHIAVINI' ,
'HUGO DE CASTRO SABINO' ,
'INGRID CAMPOS MOURA' ,
'ISABELA FAVA FURTADO ALVIM'  ,
'ISABELA MARIA BARBOSA DE PAULA'  ,
'ISABELA SOARES FONTES HAACK MENDONCA'  ,
'ISABELLA MACHADO DA COSTA PINO'  ,
'ISMAR FERNANDES FILHO' ,
'JAIME CHARRET DA SILVA JUNIOR' ,
'JANINE BOMFIM MENDON�A'  ,
'JEFFERSON CAMILO DE SOUZA' ,
'JOANA COELHO MOREIRA'  ,
'JOAO ALBERTO CASTRO FAY NEVES' ,
'JOAO FREDERICO DE ARAUJO ALMEIDA'  ,
'JOAO LUCAS MATTOS SEPULVEDA' ,
'JOAO LUIZ SOARES MACHADO'  ,
'JOAO PAULO FRESTA DE MOURA'  ,
'JOAO PEDRO DE ARAUJO SIMOES CORREA'  ,
'JOAO ROBERTO GARCIA TARDIN'  ,
'JOAO SOBHI SALLOUM'  ,
'JOAO WERNECK DE CARVALHO FILHO'  ,
'JORGE LUIZ GONCALVES'  ,
'JOSE HILTON DE AGUIAR FILHO' ,
'JOSE LUIZ GUTIERREZ CESPEDES'  ,
'JULIA LAURA ABRUCEZE LUZ SOUZA'  ,
'JULIANA BORGES OLIVEIRA ALVES' ,
'JULIANA DE JESUS SOARES' ,
'JULIANA FIONDA GOES' ,
'JULIANA LEITE ALVES' ,
'JULIANA SALVINI B MARTINS DA FONSECA'  ,
'KARINA ELORD CASTRO RIBEIRO DA SILVEIRA' ,
'KERLEY KELLER' ,
'LAERTE ANDRADE VAZ DE MELO'  ,
'LARISSA DE ALENCASTRO CURADO'  ,
'LARISSA VIEIRA TAVARES DOS REIS' ,
'LAZARO ANTONIO FRANCISCO FERES'  ,
'LEANDRO EUGENIO POLIDO CARMO'  ,
'LEANDRO GOMES PEREIRA' ,
'LEANDRO TAVARES BARBOSA DE MATOS'  ,
'LEONAM LUCAS DE ARAUJO'  ,
'LEONARDO COELHO ROCHA' ,
'LEONARDO RIBEIRO CAMPOS' ,
'LEONARDO SECCHIN CANALE' ,
'LETICIA DE ARAUJO BARROZO' ,
'LETICIA JARDIM MANCEBO DE AZEVEDO' ,
'LETICIA THOME BARCELLOS' ,
'LIGYA MARINA LEITE PINTO DE CARVALHO'  ,
'LIVIA BITTENCOURT PASTANA' ,
'LORENA LOPES PINHEIRO DA SILVA'  ,
'LORENA SANTOS BARROS'  ,
'LOURENE AMORA DIAS MAGALHAES BASTOS BELO'  ,
'LUCIA REGINA DA COSTA VIEIRA DE MELO'  ,
'LUCIANA MAIA NICODEMUS'  ,
'LUCILIA SILVA DE OLIVEIRA CARVALHO'  ,
'LUDMILA FERREIRA REIS GRANJA'  ,
'LUIS ANTONIO OLIVEIRA FERREIRA'  ,
'LUIS CLAUDIO ABRAHAO BARBOSA'  ,
'LUIS CLAUDIO DOS SANTOS' ,
'LUIZ AUGUSTO MACIEL FONTES'  ,
'LUIZ EDUARDO CORREA LUGAO DE SOUSA'  ,
'LUIZA CEGALLA FERREIRA GOMES'  ,
'LUIZA DE LIMA BERETTA' ,
'LUIZA SANTIAGO COUTO'  ,
'LUKAS MADEIRA GUERRERO'  ,
'LUSIAME DE LIMA VALENCA BULL'  ,
'MAIARA CRISTINA FAZOLIN' ,
'MARCELA PAULA LOPES ANDOLFO' ,
'MARCELO ANDRE LUDWIG'  ,
'MARCELO DE MOURA CORTES' ,
'MARCIA FERREIRA DARODA'  ,
'MARCIA KAMAL DE AVELLAR' ,
'MARCIA MARIA FIONDA' ,
'MARCOS CINTRA SILVEIRA'  ,
'MARCOS EVANDRO RODRIGUES DE ALMEIDA' ,
'MARCOS HAIUT'  ,
'MARCUS VINICIUS TELES VENTURA' ,
'MARIA CAROLINA DA SILVA GASPAR'  ,
'MARIA CLARA CRUZ SOUZA'  ,
'MARIA CRISTINA DINIZ GONCALVES EZEQUIEL' ,
'MARIA DE FATIMA FRAN�A'  ,
'MARIA ISABEL SUTTER PESSURNO DE CARVALHO'  ,
'MARIA STRONGYLIS'  ,
'MARIANA DA SILVA MENDES' ,
'MARIANA FIGUEIREDO GONCALVES'  ,
'MARIANA MOREIRAO DE OLIVEIRA'  ,
'MARIANA REINES BELIVAQUA SULLAVAN' ,
'MARIANNA LEITE DE AVELLAR' ,
'MARIANNE SOUZA ALMEIDA MURUCI' ,
'MARILDA VARGAS FREITAS PLACIDO'  ,
'MARINA MAGALHAES NOVAES' ,
'MARIO CESAR QUEIROZ ALENCAR' ,
'MARIO MACIEIRA BARBOSA'  ,
'MARTA CRISTINA BARREIRO SALGADO' ,
'MATEUS MEDRADO LUZ'  ,
'MATHEUS FERNANDES NUNES' ,
'MATHEUS SERRA MARSCHHAUSEN'  ,
'MAURICIO BESKOW BAISCH'  ,
'MAURO AUGUSTO DE MELLO BRAGA'  ,
'MAYARA DOS SANTOS RAPOSO VASTI'  ,
'MICHELA ROCHA DE OLIVEIRA' ,
'MICHELE PALMEIRA DA SILVA' ,
'NATALIA DE OLIVEIRA DUARTE DINIZ'  ,
'NATALIA OLIVEIRA PASSOS' ,
'NATALIA QUINTELLA VAZ DA SILVA'  ,
'NATHALIA ALVES DE LIMA VENTURA'  ,
'NATHALIA MENEZES RAPOSO MATHIAS DA SILVA'  ,
'NAYARA CAIRES SCAPELLATO'  ,
'NERISSA DE SOUZA NOEL SALLES'  ,
'NILSON ARAUJO AREAS' ,
'NILSON ARAUJO DE OLIVEIRA JUNIOR'  ,
'OSWALDO LUIZ PIZZI'  ,
'PAULA COLI MENDES LIMA'  ,
'PAULO OTAVIO CAMPOS FERREIRA DE ALMEIDA' ,
'PAULO ROBERTO BRUM'  ,
'PEDRO DE ALBUQUERQUE BANDARRA' ,
'PEDRO GUIMARAES ROCHA LIMA'  ,
'PEDRO HENRIQUE FERREIRA DE AZEVEDO'  ,
'PEDRO HENRIQUE MIGUEL NUNES' ,
'PEDRO IVO ROMANI DE OLIVEIRA GON�ALVES'  ,
'PEDRO VICTOR DE LIMA LEITE E SILVA'  ,
'PRISCILA CARDOZO SANTOS' ,
'PRISCILA OLIVEIRA DA CONCEICAO'  ,
'RAFAEL AUGUSTO SOUSA'  ,
'RAFAEL MACHADO FURTADO PEREIRA'  ,
'RAFAEL VICENZO VALENTINI'  ,
'RAISSA FERREIRA GUIMARAES DIAS SOARES' ,
'REGINALDO MANUEL SOARES FARIA' ,
'RENAN CARUSO'  ,
'RENAN SALOMAO RODRIGUES' ,
'RENAN VITOR VIEIRA DUARTE' ,
'RENATA MARCOLINO NOGUEIRA' ,
'RENATA OLIVEIRA MAGALHAES' ,
'RENATA SILVA MARTINHO' ,
'RENATO MACARIO FERREIRA' ,
'RENATO MACIEL DE ARANTES'  ,
'RICARDO ALVES DE ANDRADE'  ,
'RICARDO AUGUSTO DE SOUZA'  ,
'RICARDO LUIZ LIMA ANDRADE' ,
'RITA DE CASSIA ARAUJO SERPA' ,
'ROBERTA VALADAO NEGRI' ,
'ROBERTO CAMPOS MEIRELLES'  ,
'ROBERTO MACHADO ARRIGONI'  ,
'ROBERTO SOICTI FURUGUEM' ,
'RODOLFO ERNESTO VASQUEZ SURIANO' ,
'RODOLFO VIEIRA HAACK'  ,
'RODRIGO DA SILVA ROCHA'  ,
'RODRIGO RENEE FERREIRA'  ,
'RONALDO CESAR PINTO GUEDES'  ,
'RONALDO COUTINHO ROCHA'  ,
'RONALDO GON�ALVES PEREIIRA'  ,
'RUBENS JOSE FRANCA BOMTEMPO' ,
'RUBENS SAMPAIO FRAGOSO BORGES SKRIVAN' ,
'SABRINA DE MIRANDA FALCAO CAMARA'  ,
'SAMARA CADDAH FURTADO' ,
'SAMARA DE OLIVEIRA DA CRUZ'  ,
'SAVIO HENRIQUE SERAFINI FIOROT'  ,
'SHIRLEY EDIANE RODRIGUES'  ,
'SIMONE REZENDE SANT ANNA ZYLBERSZTEJN' ,
'TAMYRES STEPHANE FONSECA MARIANO'  ,
'TATIANA LAURIA DOS SANTOS COSTA' ,
'TAYNARA ANTUNES DE CARVALHO' ,
'TELMA LIMA MARTINS'  ,
'THAIS KAMIL ABIZAID' ,
'THAMIRES AMARAL CARDOSO DOS SANTOS'  ,
'THIAGO DANTAS DE SOUZA BRANDAO'  ,
'THIAGO LOPES FIRMINO PINTO'  ,
'THIAGO SALGADO GON�ALVES'  ,
'THOMMAZ ANTONIO L B S CARDOSO MACHADO' ,
'ULLI KAIZE BARBOSA PIMENTEL' ,
'VICTHOR ARTHUR OLIVEIRA MATOS' ,
'VICTOR CARVALHO RAMOS PEREIRA' ,
'VICTOR DE SOUZA' ,
'VINICIUS AGIBERT DE SOUZA' ,
'VINICIUS LUCIO DE SOUSA' ,
'VINICIUS NICOLAO CAPACIA'  ,
'VIRGINIA MARIA COSTA FONSECA'  ,
'VITOR FERRER SANDRES MELO' ,
'VITOR GROPPO FELIPPE'  ,
'VITOR HUGO VIAN' ,
'VITORIA OLIVEIRA FIORINI'  ,
'VIVIANNE AMBROZIM BICAS' ,
'WANDER NICOLAU DE OLIVEIRA'  ,
'WANNESSA MARTINS DE ALMEIDA')
and PR.CD_PRESTADOR NOT IN (11054 ,
17909 ,
19462 ,
19462 ,
19462 ,
11068 ,
17923 ,
26024 ,
26024 ,
19514 ,
19514 ,
25408 ,
17936 ,
17936 ,
19756 ,
19756 ,
17958 ,
11069 ,
21561 ,
18776 ,
35737 ,
35737 ,
38510 ,
38510 ,
17976 ,
11071 ,
19268 ,
21247 ,
20178 ,
20178 ,
19222 ,
13141 ,
29854 ,
29854 ,
20381 ,
20381 ,
38861 ,
38861 ,
16823 ,
20190 ,
19520 ,
15312 ,
19520 ,
11422 ,
15312 ,
22040 ,
22040 ,
22040 ,
25505 ,
25505 ,
20461 ,
19148 ,
19148 ,
20461 ,
19821 ,
11375 ,
17329 ,
19067 ,
19936 ,
19936 ,
19604 ,
19604 ,
19379 ,
14331 ,
24639 ,
24639 ,
19807 ,
13614 ,
19261 ,
19261 ,
19362 ,
23550 ,
19263 ,
14830 ,
30850 ,
30850 ,
14306 ,
19889 ,
19609 ,
19609 ,
18838 ,
20818 ,
20316 ,
20481 ,
20316 ,
17386 ,
18135 ,
20272 ,
20272 ,
21550 ,
20158 ,
20158 ,
19063 ,
17423 ,
15142 ,
20065 ,
20322 ,
21526 ,
26949 ,
26949 ,
26949 ,
19627 ,
21308 ,
26614 ,
26614,
19523,
26025
 );
commit;
--and pr.tp_situacao = 'I'
--and tp.cd_multi_empresa in (4,10)
--;

--order by pr.nm_prestador


/*select * from atendime where cd_atendimento in (5064467,
5064510,
5064855,
5065313,
5066431,
5073923)*/
