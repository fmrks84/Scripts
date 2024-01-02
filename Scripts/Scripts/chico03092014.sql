declare
  nSeqIt    number;
  nSeq      number;
  n         number;
begin
  --
  select max(id)   into nSeqIt    from dbamv.tiss_itguia_out;

  n := nSeqIt;
  --
  for lp in 1..n+10 loop
    select DBAMV.seq_tiss_itguia.nextval  into nSeq from sys.dual;
  end loop;
  --
end;
/
