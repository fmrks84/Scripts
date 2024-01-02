select * from dbamv.pw_documento_clinico p
where p.cd_atendimento = 1598981
for update;

select * from dbamv.pre_med p
inner join dbamv.itpre_med i on i.cd_pre_med = p.cd_pre_med
where p.cd_pre_med = 7144576;

select * from dbamv.hritpre_med h
where h.cd_itpre_med = 55975298
for update
