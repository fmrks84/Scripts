CREATE OR REPLACE TRIGGER dbamv.catch_errors
  after servererror on database
declare
  sql_text ora_name_list_t;
  msg_ varchar2(4000) := null;
  stmt_ varchar2(4000) := null;
begin

  for depth in 1 .. ora_server_error_depth loop
  msg_ := msg_ || ora_server_error_msg(depth);
  end loop;

  for i in 1 .. ora_sql_txt(sql_text) loop
  stmt_ := SubStr(stmt_ || sql_text(i), 1, 4000);
  end loop;

  insert into
  caught_errors (dt , username ,msg ,stmt )
  values (sysdate, ora_login_user,msg_,stmt_);
end;
commit ;


