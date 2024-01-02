select * from tiss_sol_guia where cd_prestador_sol = 333

Update tiss_sol_guia
Set            cd_prestador_sol = 333
             , nm_prestador =  'FRANCO LOEB CHAZAN'
             , cd_cgc_cpf = '17439971833'
             , cd_cpf = '17439971833'
             , ds_codigo_conselho = '72419'
             , nm_prestador_contratado = 'FRANCO LOEB CHAZAN'
Where cd_prestador_sol = '748' 




commit
