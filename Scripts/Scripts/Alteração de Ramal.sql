select cd_leito, ds_leito, nr_ramal 
from  dbamv.leito
where leito.nr_ramal is not null
and   leito.cd_unid_int in (select unid_int.cd_unid_int
                           from   dbamv.unid_int
                           where  unid_int.cd_setor in (select setor.cd_setor
                                                       from   dbamv.setor
                                                       where  setor.cd_multi_empresa = 2))
order by nr_ramal
