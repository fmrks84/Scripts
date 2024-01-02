select * from ped_lab where cd_atendimento = 165024

select cd_registro_documento, cd_documento, ds_layout, nm_usuario
 from registro_documento where cd_atendimento = 165024 and cd_documento = 267

delete from registro_documento where cd_atendimento = 165024 and cd_documento = 267

delete from registro_resposta where cd_registro_documento in (59707,59577,59578,59388)




select cd_documento, cd_registro_documento from documento

CD_REGISTRO_DOCUMENTO, cd_documento, ds_layout, nm_usuario
