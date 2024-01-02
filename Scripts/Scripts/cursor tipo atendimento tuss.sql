create or replace function fnc_hmsj_tipo_atendimento_tuss(pCdAtendimento in varchar2)
 return varchar2 is

 cursor c_atendime is
 select tp_atendimento_tiss
 from dbamv.tb_atendime
 where cd_atendimento = pCdAtendimento
 ;
--
vcd_tp_atendimento dbamv.atendime.tp_atendimento_tiss%type;
--
begin
--
open  c_atendime;
fetch c_atendime into vcd_tp_atendimento;
close c_atendime;
--
if vcd_tp_atendimento = 04 then
  return 11;
  elsif vcd_tp_atendimento = null then
  return 07;
  else
  return pCdAtendimento;
  end if;
end;


---select dbamv.fnc_hmsj_tipo_atendimento_tuss(:par1) from dual
