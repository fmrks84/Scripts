Select  Cd_Atendimento
       ,Cd_Ori_Ate
       ,Cd_Paciente
From Atendime
Where Cd_Ori_Ate = 22
And Cd_Multi_Empresa = 3
And Cd_Paciente In (Select Cd_Paciente
                      From Same
                      Where Cd_Cad_Same = 34)
                      

Update Atendime
Set Cd_Ori_Ate = 22
Where Cd_Ori_Ate = 18
And Cd_Multi_Empresa = 3
And Cd_Paciente In (Select Cd_Paciente
                      From Same
                      Where Cd_Cad_Same = 34)


Commit



select * from same where cd_paciente = 9675
select * from same where cd_paciente = 9538
select * from ori_ate order by cd_ori_ate
select * from atendime where cd_ori_ate = 18 
