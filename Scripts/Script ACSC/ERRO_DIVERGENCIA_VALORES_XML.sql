select * from atendime where cd_atendimento = 4743169;

select * from reg_fat where cd_remessa = 349761
select * from itreg_fat where cd_reg_fat = 524723 and id_it_envio = 369792756
select * from tiss_guia x where x.cd_atendimento = 4743169;
select * from tiss_guia a where a.cd_reg_fat = 524723;
select to_number (b.vl_unitario,'999999.99'),
       to_number(b.vl_total,'999999.99'),
       (to_number (b.vl_unitario,'999999.99') / 2)
 from tiss_itguia b where b.id_pai = 25423699
 
 select/* b.qt_realizada,
        b.vl_percentual_multipla,
        to_number(b.vl_unitario,'9999999.99'),
        to_number(b.vl_total,'9999999.99'),
        case when b.vl_percentual_multipla = '0.50' then (to_number(b.vl_unitario,'9999999.99') / 2)
        else to_number(b.vl_unitario,'9999999.99')
        end total_G,
        case when b.qt_realizada >= 1 then (to_number(b.vl_unitario,'9999999.99') * b.qt_realizada)--total_s
        end total_s*/
        *
 from tiss_itguia b where b.id_pai = 25423699
 
 
 
 select bb.qt_lancamento, bb.vl_unitario, to_number(c.vl_unitario,'999999.99'), bb.vl_total_conta,  c.vl_total from itreg_fat bb
 inner join tiss_itguia_out c on bb.id_it_envio = c.id
 where cd_reg_fat = 524723 
 and bb.vl_unitario <> to_number(c.vl_unitario,'999999.99')
 
 select 
 bb1.qt_lancamento,
 bb1.vl_unitario,
 d.vl_unitario,
 d.vl_total,
 bb1.vl_total_conta
 from 
 itreg_Fat bb1 
 inner join tiss_itguia d on d.id = bb1.id_it_envio
 where cd_reg_Fat = 524723
 
 select 
 from 
 itreg_fat bb2
 inner join tiss_it
 --and id_it_envio = 369792756
 --select * from tiss_itguia_out c 
-- where c.id_pai = 25423699 and c.id = 369792756
