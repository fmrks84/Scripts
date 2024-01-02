BEGIN
 --DBAMV.PKG_MV2000.ATRIBUI_EMPRESA(8);

  FOR R IN ( SELECT PCA.CD_REDUZIDO, 
                    PCA.CD_CONTABIL,
                    PCB.CD_REDUZIDO CD_REDUZIDO_PAI,
                    PCB.CD_CONTABIL CD_CONTABIL_PAI
                    
                    
               FROM DBAMV.PLANO_CONTAS PCA,
                    DBAMV.PLANO_CONTAS PCB
               WHERE SUBSTR( PCA.CD_CONTABIL, 1, INSTR(PCA.CD_CONTABIL, '.', -1 )-1) = PCB.CD_CONTABIL 
               AND PCA.CD_MULTI_EMPRESA = 10
               AND PCB.CD_MULTI_EMPRESA = 10
               ORDER BY PCA.CD_CONTABIL) LOOP

 
     UPDATE DBAMV.PLANO_CONTAS
        SET CD_REDUZIDO_PAI = R.CD_REDUZIDO_PAI
        WHERE CD_REDUZIDO = R.CD_REDUZIDO
        AND CD_MULTI_EMPRESA = 10;
  END LOOP;

END;


/*delete from dbamv.plano_contas
where plano_Contas.Cd_Multi_Empresa in (7,8,10) 
--order by 2 



select * from all_constraints
where constraint_name LIKE 'CC_PLANO_FK' -- NATUREZA CONTABIL 

select * from all_constraints
where constraint_name LIKE 'PU_PLANO_FK' --- USUARIO X PLANO DE CONTAS ,

delete from dbamv.plano_usuario_multi_empresa b where b.cd_multi_empresa in  (7,8,10)
*/
