PUBLIC gconecta, lmesx, lanio

** Leer del INI
Archivo_ = FILE(".\bd.ini") 
IF Archivo_ = .T. 
   N_Cadena = ALLTRIM(FILETOSTR(".\bd.ini")) 
   x_Server = ALLTRIM(SUBSTR(N_Cadena,1,(ATC(CHR(13),N_Cadena,1) - 1))) 
   N_Cadena = ALLTRIM(RIGHT(N_Cadena,LEN(N_Cadena) - ( ATC(CHR(13),N_Cadena,1) + 1 ))) 
   x_UID =    ALLTRIM(SUBSTR(N_Cadena,1,(ATC(CHR(13),N_Cadena,1) - 1))) 
   N_Cadena = ALLTRIM(RIGHT(N_Cadena,LEN(N_Cadena) - ( ATC(CHR(13),N_Cadena,1) + 1 ))) 
   x_PWD =    ALLTRIM(SUBSTR(N_Cadena,1,(ATC(CHR(13),N_Cadena,1) - 1))) 
   N_Cadena = ALLTRIM(RIGHT(N_Cadena,LEN(N_Cadena) - ( ATC(CHR(13),N_Cadena,1) + 1 ))) 
   x_Change = CHRTRAN(N_Cadena,CHR(13),"*") 
   x_DBaseName = Substr(x_Change,1,ATC("*",x_Change,1)-1) 
   lcStringCnxLocal = "Driver={SQL Server Native Client 10.0};" + ; 
          "SERVER=" + x_Server + ";" + ; 
          "UID=" + x_UID + ";" + ; 
          "PWD=" + x_PWD + ";" + ; 
          "DATABASE=" + x_DBaseName + ";"
  Sqlsetprop(0,"DispLogin" , 3 ) 
  gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
ENDIF
  
lanio = 2017
lmes = 1
lmesx = '1'
xsituacion = '02'

cMensage = " TRABAJANDO ASISTENCIA................"
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait


TEXT TO lduplicado noshow
  Alter Table asistencia
  add idpersonal integer identity
  select * from ASISTENCIA where MES = ?lmes and AÑO = ?lanio order by codigo, dia, mes, año asc
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lduplicado, "tdupli")

SELECT tdupli
GO top
SCAN
 lid = tdupli.idpersonal
 ldia = tdupli.dia
 lanio = tdupli.año
 lcodigo = tdupli.codigo
 TEXT TO lverdupli noshow
    select * from ASISTENCIA where codigo = ?lcodigo and dia = ?ldia and MES = ?lmes and AÑO = ?lanio order by idpersonal asc
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lverdupli, "tdupli2")
 SELECT tdupli2
 x = RECCOUNT()
 IF x > 1
  TEXT TO lverdupli2 noshow
     delete from asistencia where idpersonal not in (select MIN(idpersonal) as idpersonal from ASISTENCIA where codigo = ?lcodigo and dia = ?ldia and MES = ?lmes and AÑO = ?lanio) and codigo = ?lcodigo and dia = ?ldia and MES = ?lmes and AÑO = ?lanio 
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lverdupli2)
 cMensage = " PARA ESTE CODIGO : " + lcodigo + "  --  SE ENCUENTRA REPETIDO 3 VECES "
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
 ELSE
   cMensage = " PARA ESTE CODIGO : " + lcodigo + "  --  NO EXISTE REPETICION --- "
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
 ENDIF
ENDSCAN

cMensage = " PROCESO TERMINADO "
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait


TEXT TO lelim noshow
  Alter Table asistencia
  Drop Column idpersonal
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lelim)

 