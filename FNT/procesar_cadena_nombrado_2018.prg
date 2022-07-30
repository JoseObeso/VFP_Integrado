* Tener en cuenta los campos de la cadena que deben estar en VARCHAR(150), PARA QUE LOS PUEDA LEER EL SISTEMA *

PUBLIC gconecta
clear
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
  ?lcStringCnxLocal

ENDIF
 
TEXT TO lbusca noshow
  SELECT dni, nombre, LTRIM(RTRIM(SUBSTRING(programa_pptal,1,4))) + '.' + substring(activ_obra_accinv,1,8) + rtrim(secuencia) + '.' +  rtrim(substring(finalidad,1,110)) AS CADENA
      FROM [BDPERSONAL].[dbo].[CADENA_NOMBRADO_2018] ORDER BY NOMBRE       
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lbusca, "TNOM1")
SELECT TNOM1 && PARA CAMBIAR EN EL MAESTRO
GO top
SCAN
  ldni = ALLTRIM(tnom1.dni)
  lcadena = ALLTRIM(tnom1.cadena)
  lnombre = ALLTRIM(tnom1.nombre)
  
  TEXT TO lgrabacadena noshow
   declare @ldni varchar(13) = ?ldni
   update [BDPERSONAL].[dbo].[MAESTRO] set CADENA = (SELECT LTRIM(RTRIM(SUBSTRING(programa_pptal,1,4))) + '.' + substring(activ_obra_accinv,1,8) + rtrim(secuencia) + '.' +  rtrim(substring(finalidad,1,110)) AS CADENA
    FROM [BDPERSONAL].[dbo].[CADENA_NOMBRADO_2018] where dni =  @ldni) where maestro.dni =  @ldni 
   update [BDPERSONAL].[dbo].[GUARDIA_EFE] set CadenaFun = (SELECT LTRIM(RTRIM(SUBSTRING(programa_pptal,1,4))) + '.' + substring(activ_obra_accinv,1,8) + rtrim(secuencia) + '.' +  rtrim(substring(finalidad,1,110)) AS CADENA
    FROM [BDPERSONAL].[dbo].[CADENA_NOMBRADO_2018] where dni =  @ldni) where GUARDIA_EFE.PLAZA =  @ldni  AND GUARDIA_EFE.CODMES >= 4 AND GUARDIA_EFE.A�o = 2018
   update [BDPERSONAL].[dbo].[GUARDIA_PRG] set CadenaFun = (SELECT LTRIM(RTRIM(SUBSTRING(programa_pptal,1,4))) + '.' + substring(activ_obra_accinv,1,8) + rtrim(secuencia) + '.' +  rtrim(substring(finalidad,1,110)) AS CADENA
    FROM [BDPERSONAL].[dbo].[CADENA_NOMBRADO_2018] where dni =  @ldni) where GUARDIA_PRG.PLAZA =  @ldni  AND GUARDIA_PRG.CODMES >= 4 AND GUARDIA_PRG.A�o = 2018
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lgrabacadena)
 cMensage = "Para el Maestro.... " +lnombre
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
ENDSCAN

 cMensage = "PROCESO FINALIZADO.... " +lnombre
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
