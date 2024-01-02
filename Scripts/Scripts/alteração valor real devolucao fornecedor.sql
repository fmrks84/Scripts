/*begin
  pkg_mv2000.Atribui_Empresa(2);
  end;*/

select *
  from /*dbamv.ent_pro e
       inner join*/ dbamv.itent_pro i /*on i.cd_ent_pro = e.cd_ent_pro*/
--where e.nr_documento = '000320994'
 where i.cd_itent_pro = 1102522
   for update
--37,56968221 vl_custo_real
--225,42 - vl_total_custo_real
;

select * from dbamv.documento_entrada d
where d.nr_documento = '000320994' 
for update;

select * from dbamv.dev_for d
where d.nr_documento = '000320994' --203,40 --225,42
for update;
