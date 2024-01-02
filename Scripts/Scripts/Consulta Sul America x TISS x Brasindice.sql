--07013354
--0766075


--begin  dbamv.pkg_mv2000.atribui_empresa(1); end;

select 
dbamv.pkg_ffcv_tiss_pii.fnc_conf('SN_UTILIZA_APR_PROCED',3,NULL)
,
dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc(   'D',
                                                      --
                                                      null,null,null,
                                                      3,
                                                      'I',
                                                      '07013354', --'07003201', --'07013354',
                                                      null, --??pncdsetor,
                                                      --
                                                      1 ) descricao
,dbamv.pkg_ffcv_tiss_pii.fnc_traduz_proc(   'C',
                                                      --
                                                      null,null,null,
                                                      3,
                                                      'I',
                                                      '07013354', --'07003201', --'07013354',
                                                      null, --??pncdsetor,
                                                      --
                                                      1 )codigo
                                                      
from dual

