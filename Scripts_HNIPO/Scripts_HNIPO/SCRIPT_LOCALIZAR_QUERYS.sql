select dbms_lob.substr(ds_sql,4000,1)
from dbacp.portlet_sql
where dbms_lob.substr(ds_sql,4000,1) like '%SELECT%CD_REGISTRO_DOCUMENTO%CD_DOCUMENTO%FROM%(SELECT CD_REGISTRO_DOCUMENTO,%' 

--dbms_lob.substr(i.lo_valor,3999,1)"PERGUNTA_RESPONDIDA",

select dbms_lob.substr(x.lo_valor,4000,1)
from editor_registro_campo X
where dbms_lob.substr(x.lo_valor,4000,1) like '%SELECT%CD_REGISTRO_DOCUMENTO%CD_DOCUMENTO%FROM%(SELECT CD_REGISTRO_DOCUMENTO,%'

SELECT * FROM EDITOR_CAMPO X WHERE X.DS_IDENTIFICADOR = 'DS_ESPEC_FICHAA'

SELECT * FROM EDITOR_PROPRIEDADE WHERE CD_PROPRIEDADE = 4


SELECT * FROM ALL_TAB_COLUMNS AL WHERE AL.column_name = 'CD_PROPRIEDADE'


SELECT dbms_lob.substr(lo_valor,4000,1) 
FROM EDITOR_CAMPO_PROP_VAL
WHERE dbms_lob.substr(lo_valor,4000,1) like '%CD_REGISTRO_DOCUMENTO%'


