/*select * from rb_field;
select * from rb_folder;
select * from rb_item;
select * from rb_join;
select * from rb_table;*/

select 
*
from 
rb_folder b
inner join rb_item c on b.cd_id_folder = c.cd_id_folder
inner join cat_reports d on d.cd_modulo = c.cd_modulo
where d.cd_report = 55--c.cd_id_item = 1560
order by 2


--select * from all_tab_columns a where a.COLUMN_NAME like '%CD_ID_FOLDER%'
