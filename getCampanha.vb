'*****  FUNÇÃO BUSCA CAMPANHA CLARO AQUISIÇÃO
'*****  15/07/2020
'*****  getCampanha(mailing)
'*****  Vinicios Falqueiro

Function getCampanha(mailing As String) As String

'condicional, que atraves do começo do nome da base retorna qual ação faz parte


'Aquisição

If Left(mailing, 2) = "AD" Then
getCampanha = "AGV"

ElseIf Left(mailing, 7) = "homolog" Then
getCampanha = "AGV"

ElseIf Left(mailing, 15) = "Claro_Aqso_NENO" Then
getCampanha = "AGV"

ElseIf Left(mailing, 10) = "Claro_Aqso" Then
getCampanha = "VOZ"

ElseIf Left(mailing, 13) = "Claro_Revenda" Then
getCampanha = "VOZ"

ElseIf Left(mailing, 17) = "Mailing_Expert_A" Then
getCampanha = "AGV"

ElseIf Left(mailing, 17) = "mailing_expert_A_" Then
getCampanha = "AGV"

ElseIf Left(mailing, 17) = "Mailing_Expert_AS" Then
getCampanha = "SB"

ElseIf Left(mailing, 17) = "Maling_Expert_SB_" Then
getCampanha = "SB"

ElseIf Left(mailing, 17) = "Mailing_Expert_Se" Then
getCampanha = "AS"

ElseIf Left(mailing, 17) = "MAILING_INDICACAO" Then
getCampanha = "AS"

ElseIf Left(mailing, 19) = "Mailing_Expert_7_SS" Then
getCampanha = "AS"

ElseIf Left(mailing, 8) = "CADASTRO" Then
getCampanha = "VOZ"

ElseIf Left(mailing, 14) = "Mailing_Expert" Then
getCampanha = "AGV"

'Migração

ElseIf Left(mailing, 10) = "Claro_Bom2" Then
getCampanha = "Bom_Novo"


ElseIf Left(mailing, 10) = "Claro_Cor_" Then
getCampanha = "Claro_Coringa"

ElseIf Left(mailing, 10) = "Claro_TLV2" Then
getCampanha = "Migração_Novo"

ElseIf Left(mailing, 10) = "Claro_Q12_" Then
getCampanha = "Q1_Novo"


'caso mailing mude para nome não definido, retorna #N/D"

Else
getCampanha = "#N/D"
End If

End Function
