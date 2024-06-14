---- INSERT NO PACOTE_EXCECAO -- CD_GRU_PRO
BEGIN
  FOR USUS IN
  (
   SELECT DISTINCT P.CD_PACOTE ,PF2.CD_GRU_PRO
 FROM DBAMV.PACOTE P
  LEFT JOIN (
        SELECT DISTINCT  PF.Cd_GRU_PRO
      FROM DBAMV.PRO_FAT PF 
    WHERE PF.CD_PRO_FAT IN ('00065674', '00065720', '00105580', '00120420', 
                            '00120422', '00130076', '00141915', '00150536', 
                            '00151248', '00159707', '00159710', '00167452', 
                            '00167453', '00170067', '00173972', '00173973', 
                            '00174976', '00243240', '00244879', '00253391', 
                            '00253400', '00277542', '00285082', '00289447',
                            '00292113', '00298938', '00301011', '00328062',
                            '02038464', '02038587', '02039913', '02039914', 
                            '02040262', '02042010', '09008279', '09014021', 
                            '09014149', '09018382', '09028962', '09035270', 
                            '09053239', '09060431', '09063034', '09073573', 
                            '09105569', '09105570', '09105572', '09105575',
                            '09105577', '09105579', '09105582', '09105614', 
                            '09105617', '09105625', '09105629', '09105765', 
                            '09105767', '09106423', '70343063', '79424538')
  
          
          ) PF2 ON PF2.CD_GRU_PRO = PF2.CD_GRU_PRO
 WHERE P.CD_MULTI_EMPRESA = 7
   AND P.DT_VIGENCIA_FINAL IS  NULL
     AND P.CD_CONVENIO IN (63, 28, 559, 212, 21, 26, 36, 27, 209, 62, 822, 401, 219, 211, 843)
    AND P.CD_PRO_FAT_PACOTE IN ('10000278', '10000346', '10000347', '10000348', '10000349', 
    '10000333', '10000334', '10000335', '10000341', '10000342', '10000343', '10000344', 
    '10000345', '10000338', '10000713', '10001914', '10001641', '10000805', '10000804', 
    '10000336', '10000337', '10000351', '10000350', '10000352', '10000353', '10000354')
    and not exists (select 'x' from dbamv.Pacote_Excecao  pcx where pcx.cd_pacote = p.cd_pacote and pcx.cd_gru_pro = pf2.cd_gru_pro)
  )
  LOOP
    BEGIN
      INSERT INTO dbamv.Pacote_Excecao (cd_pacote_excecao,cd_pacote, cd_gru_pro)
      VALUES (seq_pacote_excecao.nextval, USUS.cd_pacote, USUS.cd_gru_pro);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignora o erro e continua
    END;
  END LOOP;
END;  
/


---- INSERT NO PACOTE_EXCECAO - CD_PRO_FAT 
---- refere-se a outro pacote da operadora 8 
BEGIN
  FOR USUS IN
  (
   SELECT P.CD_PACOTE ,PF2.CD_PRO_FAT
 FROM DBAMV.PACOTE P
  LEFT JOIN (
        SELECT DISTINCT  PF.CD_PRO_FAT 
      FROM DBAMV.PRO_FAT PF 
      WHERE PF.CD_PRO_FAT IN ('00244880' /* ,'04075010'  ,'02038464'  ,'00289447'  ,'02042700'  ,
                              '00167453'  ,'00167452'  ,'09008279'  ,'00173973'  ,'00170067'  ,
                              '00141915'  ,'09014021'  ,'00065674'  ,'09014149'  ,'00244879'  ,
                              '09018382'  ,'00292113'  ,'09035270'  ,'00285082'  ,'00253391'  ,
                              '00298938'  ,'00151248'  ,'09053239'  ,'09060431'  ,'00277542'  ,
                              '09063034'  ,'00301011'  ,'09073573'  ,'00328062'  ,'09105570'  ,
                              '09105572'  ,'09105575'  ,'09105577'  ,'09105579'  ,'00105580'  ,
                              '09105582'  ,'09105614'  ,'00173972'  ,'09105617'  ,'00150536'  ,
                              '09105625'  ,'09105629'  ,'00120422'  ,'00174976'  ,'09105765'  ,
                              '00159710'  ,'09105767'  ,'00159707'  ,'00120420'  ,'02039913'  ,
                              '02039914'  ,'02040262'  ,'00243240'  ,'02042010'  ,'79424538' */ )        
          ) PF2 ON PF2.CD_PRO_FAT = PF2.CD_PRO_FAT
 WHERE P.CD_MULTI_EMPRESA = 7
   AND P.DT_VIGENCIA_FINAL IS  NULL
     AND P.CD_CONVENIO IN (8)
    AND P.CD_PRO_FAT_PACOTE IN ('10000276'/*,'10000278','10001233','10000277'*/)
    and not exists (select 'x' from dbamv.Pacote_Excecao  pcx where pcx.cd_pacote = p.cd_pacote and pcx.cd_pro_Fat = pf2.cd_pro_Fat)
  )
  LOOP
    BEGIN
      INSERT INTO dbamv.Pacote_Excecao (cd_pacote_excecao, cd_pacote, cd_pro_fat)
      VALUES (seq_pacote_excecao.nextval,USUS.cd_pacote, USUS.cd_pro_fat);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignora o erro e continua
    END;
  END LOOP;
END;  
/

---- INSERT NO PACOTE_EXCECAO - CD_PRO_FAT 
---- refere-se a outro pacote da operadora 8 onde temos um pacote com outra tratativa 

BEGIN
  FOR USUS IN
  (
   SELECT P.CD_PACOTE ,PF2.CD_PRO_FAT
 FROM DBAMV.PACOTE P
  LEFT JOIN (
        SELECT DISTINCT  PF.CD_PRO_FAT 
      FROM DBAMV.PRO_FAT PF 
      WHERE PF.CD_PRO_FAT IN ('00244880','04075010','02038464','00289447',
                             '02042700','00244880','04075010','02038464',
                             '00289447','02042700')
        
          ) PF2 ON PF2.CD_PRO_FAT = PF2.CD_PRO_FAT
 WHERE P.CD_MULTI_EMPRESA = 7
   AND P.DT_VIGENCIA_FINAL IS  NULL
     AND P.CD_CONVENIO IN (8)
    AND P.CD_PRO_FAT_PACOTE IN ('10000805')
    and not exists (select 'x' from dbamv.Pacote_Excecao  pcx where pcx.cd_pacote = p.cd_pacote and pcx.cd_pro_Fat = pf2.cd_pro_Fat)

  )
  LOOP
    BEGIN
      INSERT INTO dbamv.Pacote_Excecao (cd_pacote_excecao, cd_pacote, cd_pro_fat)
      VALUES (seq_pacote_excecao.nextval,USUS.cd_pacote, USUS.cd_pro_fat);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignora o erro e continua
    END;
  END LOOP;
END;  
/


---- INSERT NO PACOTE_EXCECAO_PROCEDIMENTO -- CD_PRO_FAT QUE ESTA INVINCULADO NO CD_GRU_PRO DA TABELA PACOTE_EXCECAO

BEGIN
  FOR USUS IN
  (
    SELECT DISTINCT PE.CD_PACOTE_EXCECAO, PF2.CD_PRO_FAT
    FROM DBAMV.PACOTE_EXCECAO PE
    LEFT JOIN DBAMV.PACOTE P ON P.CD_PACOTE = PE.CD_PACOTE
    LEFT JOIN DBAMV.PRO_FAT PF ON PF.CD_PRO_FAT = P.CD_PRO_FAT_PACOTE
    LEFT JOIN
    (
      SELECT PF.CD_PRO_FAT, PF.CD_GRU_PRO 
      FROM DBAMV.PRO_FAT PF 
      WHERE PF.CD_PRO_FAT IN ('00065674', '00065720', '00105580', '00120420', 
                              '00120422', '00130076', '00141915', '00150536', 
                              '00151248', '00159707', '00159710', '00167452', 
                              '00167453', '00170067', '00173972', '00173973', 
                              '00174976', '00243240', '00244879', '00253391', 
                              '00253400', '00277542', '00285082', '00289447',
                              '00292113', '00298938', '00301011', '00328062',
                              '02038464', '02038587', '02039913', '02039914', 
                              '02040262', '02042010', '09008279', '09014021', 
                              '09014149', '09018382', '09028962', '09035270', 
                              '09053239', '09060431', '09063034', '09073573', 
                              '09105569', '09105570', '09105572', '09105575',
                              '09105577', '09105579', '09105582', '09105614', 
                              '09105617', '09105625', '09105629', '09105765', 
                              '09105767', '09106423', '70343063', '79424538')
    ) PF2 ON PF2.CD_PRO_FAT = PF2.CD_PRO_FAT
    WHERE P.CD_MULTI_EMPRESA = 7
    AND P.DT_VIGENCIA_FINAL IS NULL
    AND P.CD_CONVENIO IN (63, 28, 559, 212, 21, 26, 36, 27, 209, 62, 822, 401, 219, 211, 843)
    AND P.CD_PRO_FAT_PACOTE IN ('10000278', '10000346', '10000347', '10000348', '10000349', 
    '10000333', '10000334', '10000335', '10000341', '10000342', '10000343', '10000344', 
    '10000345', '10000338', '10000713', '10001914', '10001641', '10000805', '10000804', 
    '10000336', '10000337', '10000351', '10000350', '10000352', '10000353', '10000354')
    AND PE.CD_GRU_PRO = PF2.CD_GRU_PRO
  )
  LOOP
    BEGIN
      INSERT INTO dbamv.Pacote_Excecao_Procedimento (cd_pacote_excecao, cd_pro_fat)
      VALUES (USUS.cd_pacote_excecao, USUS.cd_pro_fat);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL; -- Ignora o erro e continua
    END;
  END LOOP;
END;
/
