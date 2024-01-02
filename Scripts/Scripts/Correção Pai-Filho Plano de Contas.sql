DECLARE
  TYPE rec_pl_contas IS RECORD
     (cd_reduzido      dbamv.plano_contas.cd_reduzido%TYPE,
      cd_contabil      dbamv.plano_contas.cd_contabil%TYPE,
      cd_grau_da_conta dbamv.plano_contas.cd_grau_da_conta%TYPE,      
      cd_reduzido_pai  dbamv.plano_contas.cd_reduzido_pai%TYPE);

  r_pl_contas         rec_pl_contas;
  v_cd_reduzido_pai   dbamv.plano_contas.cd_reduzido%TYPE;
  v_cd_contabil       dbamv.plano_contas.cd_contabil%TYPE;
  v_cd_grau_da_conta  dbamv.plano_contas.cd_grau_da_conta%TYPE;

  CURSOR c_multi_empresa IS
    SELECT cd_multi_empresa
      FROM dbamv.multi_empresas
     where cd_multi_empresa = 6;

  CURSOR c_plano_contas(v_cd_multi_empresa dbamv.plano_contas.cd_multi_empresa%TYPE) IS
    SELECT cd_reduzido
         , cd_contabil
         , cd_grau_da_conta
         , cd_reduzido_pai
      FROM dbamv.plano_contas   plano_contas
     WHERE cd_multi_empresa        = v_cd_multi_empresa;

  CURSOR c_conta_pai (v_cd_multi_empresa dbamv.plano_contas.cd_multi_empresa%TYPE) IS
    SELECT plano_contas.cd_reduzido  cd_reduzido
      FROM dbamv.plano_contas   plano_contas
     WHERE plano_contas.cd_multi_empresa = v_cd_multi_empresa
       AND plano_contas.cd_contabil      = v_cd_contabil;

BEGIN

  FOR c_multi_emp IN c_multi_empresa LOOP
    OPEN c_plano_contas(c_multi_emp.cd_multi_empresa);
    LOOP 
      FETCH c_plano_contas INTO r_pl_contas.cd_reduzido,r_pl_contas.cd_contabil,r_pl_contas.cd_grau_da_conta,r_pl_contas.cd_reduzido_pai;   	
      EXIT WHEN c_plano_contas%NOTFOUND OR
                c_plano_contas%NOTFOUND IS NULL;
      v_cd_grau_da_conta := 1;
      
      FOR v_cont IN 1..length(r_pl_contas.cd_contabil) LOOP
        IF INSTR(r_pl_contas.cd_contabil,'.',1,v_cont) <> 0  THEN
          v_cd_grau_da_conta := v_cd_grau_da_conta + 1;
        END IF;
      END LOOP;
      
      IF v_cd_grau_da_conta = 1 THEN
        UPDATE dbamv.plano_contas SET cd_reduzido_pai = null, cd_grau_da_conta = v_cd_grau_da_conta
         WHERE cd_reduzido = r_pl_contas.cd_reduzido
           And cd_multi_empresa = c_multi_emp.cd_multi_empresa;
      ELSE
        v_cd_contabil := substr(r_pl_contas.cd_contabil,1,instr(r_pl_contas.cd_contabil,'.',1,v_cd_grau_da_conta - 1) - 1);

        OPEN c_conta_pai(c_multi_emp.cd_multi_empresa);
        FETCH c_conta_pai INTO v_cd_reduzido_pai;
        IF c_conta_pai%NOTFOUND THEN
          CLOSE c_conta_pai;                 
        ELSE
          IF v_cd_grau_da_conta <> r_pl_contas.cd_grau_da_conta OR
             nvl(r_pl_contas.cd_reduzido_pai,-1) <> v_cd_reduzido_pai  THEN
            UPDATE dbamv.plano_contas SET cd_reduzido_pai = v_cd_reduzido_pai, cd_grau_da_conta = v_cd_grau_da_conta
             WHERE cd_reduzido = r_pl_contas.cd_reduzido
               And cd_multi_empresa = c_multi_emp.cd_multi_empresa;
          END IF;
          CLOSE c_conta_pai;
        END IF; 
      
      END IF; 
    
    END LOOP; 
    
    CLOSE c_plano_contas;
  
  END LOOP; 
  --COMMIT;

END;

