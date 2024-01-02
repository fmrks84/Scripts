select * from mov_int z where z.cd_atendimento = 2767721;
select * from atendime where cd_atendimento = 2633550
select * from leito where cd_leito in (2623,538)

select a.cd_reg_fat ,
       a.cd_convenio,
       a.cd_con_pla,
       a.cd_tip_acom,
       b.cd_pro_fat,
       c.ds_pro_fat,
       b.cd_gru_fat,
       b.dt_lancamento,
       b.hr_lancamento,
       b.tp_mvto ,
       b.sn_pertence_pacote,
       b.cd_conta_pacote
        
       from reg_Fat a
inner join itreg_Fat b on a.cd_reg_fat = b.cd_reg_fat
inner join pro_Fat c on c.cd_pro_fat = b.cd_pro_fat
where a.cd_atendimento = 2767721
and a.cd_reg_fat =307127-- 309239--308890
--and b.cd_pro_fat = 60001038
and b.cd_gru_fat = 1
order by b.hr_lancamento;

--select * from conta_pacote where cd_conta_pacote in (1100998,1100999,1101000,1101001,1101002,1101003)

select * from pacote where cd_pacote in (12365,12368);


begin
  pkg_mv2000.Atribui_Empresa(7);
  end;
  
  begin dbamv.diaria_automatica(61,
								  307127,
									sysdate,
									1);
end;


---select * from proibicao where cd_pro_fat = '60001038' and cd_convenio = 53 and cd_con_pla = 11
