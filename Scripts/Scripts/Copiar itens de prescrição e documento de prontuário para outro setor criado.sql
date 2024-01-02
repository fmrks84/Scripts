declare
  cursor c_doc_setor is
    select cd_documento, cd_unid_int
      from dbamv.documento_setor
     where cd_setor = 132;
begin
  for r_doc in c_doc_setor
  loop
    insert into dbamv.documento_setor
      (cd_documento, cd_setor, cd_documento_setor, cd_unid_int)
    values
      (r_doc.cd_documento,
       486,
       dbamv.seq_documento_setor.nextval,
       r_doc.cd_unid_int);
  end loop;
end;

select * from dbamv.documento_setor where cd_setor = 486

update dbamv.documento_setor 
set cd_unid_int = 48
where cd_setor = 486

--------------------------------------------------------------------------------------------
select * from dbamv.tip_presc_setor where cd_setor = 132 and cd_multi_empresa = 2 

declare
  cursor c_tip_presc is
    select *
      from dbamv.tip_presc_setor
     where cd_setor = 132
       and cd_multi_empresa = 2;
begin
  for r_tip_presc in c_tip_presc
  loop
    insert into dbamv.tip_presc_setor
      (cd_tip_presc, cd_setor, cd_multi_empresa)
    values
      (r_tip_presc.cd_tip_presc, 486, r_tip_presc.cd_multi_empresa);
  end loop;
end;
