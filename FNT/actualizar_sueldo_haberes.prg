PUBLIC gconecta

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
  
TEXT TO lbusca noshow
   SELECT NRO, NOMBRE, CARGO, DNI, FECNAC, FECALT, MONTO FROM [BDPERSONAL].[dbo].[NUEVO_SUELDO] 
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lbusca, "TNOM")

SELECT TNOM
GO top
SCAN
 ldni = ALLTRIM(tnom.dni)
 lnombre = tnom.nombre
 lmonto = tnom.monto
 TEXT TO lgrabacadena noshow
      UPDATE maestro SET haber = ?lmonto WHERE maestro.dni = ?ldni
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lgrabacadena) 
 cMensage = ' ACTUALIZANDO SUELDO PARA  : ' + ALLTRIM(lnombre)
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
ENDSCAN


