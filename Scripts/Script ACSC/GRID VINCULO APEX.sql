--- GRID NA TELA VINCULO DA CONTA --- 
select * from pro_Fat a
inner join gru_pro b on a.cd_gru_pro = b.cd_gru_pro 
where (a.sn_opme = 'S' or b.tp_gru_pro = 'OP')
and a.sn_ativo = 'S'/*cd_pro_fat in (
'00008035',
'00052714',
'00084030',
'00084030',
'00085023',
'00161517',
'00248913',
'00248913',
'00271542',
'00276028',
'00312188',
'70176256',
'70259119',
'70271305',
'70271305',
'70902860',
'71780416')
*/

