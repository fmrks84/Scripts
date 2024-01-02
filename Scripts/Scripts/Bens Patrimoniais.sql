Select B.Cd_Bem, B.Ds_Plaqueta, B.Ds_Bem, B.Cd_Capitulo, I.Ds_Capitulo, B.Cd_Sub_Cap, O.Ds_Sub_Cap, B.Dt_Tombamento, B.Cd_Setor, S.Nm_Setor, B.Cd_Localidade, L.Ds_Localidade, B.Dt_Compra
                  From   Dbamv.Bens B, Dbamv.Localidade L, Dbamv.Setor S, Dbamv.Iob I, Dbamv.Sub_Iob O
                  Where  B.Cd_Setor         =   S.Cd_Setor
                  And    B.Cd_Localidade    =   L.Cd_Localidade
                  And    L.Cd_Setor         =   S.Cd_Setor
                  And    B.Cd_Multi_Empresa =   2
                  And    O.Cd_Sub_Cap       =   2
                  And    B.Cd_Capitulo      =   I.Cd_Capitulo
                  And    I.Cd_Capitulo      =   O.Cd_Capitulo
                  And    B.Cd_Sub_Cap       =   O.Cd_Sub_Cap
                  And    B.Cd_Capitulo      =   8
                  And    B.Dt_Baixa        Is Null

Order By B.Cd_Capitulo, B.Cd_Sub_Cap, B.Ds_Bem, S.Cd_Setor


                
                    
