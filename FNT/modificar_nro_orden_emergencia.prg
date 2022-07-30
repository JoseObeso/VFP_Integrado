clear
** Revisar las horas del turno mañana y tarde ******
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
      lcStringCnxLocal = "Driver={SQL Server Native Client 10.0};" +  "SERVER=" + x_Server + ";" +  "UID=" + x_UID + ";" + "PWD=" + x_PWD + ";" + "DATABASE=" + x_DBaseName + ";"
      ?lcStringCnxLocal
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF
  
cMensage = '...INICIANDO PROCESO.............' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

ln_numero_inicial = 0
TEXT TO lqry_ver_orden noshow
  select EMERGENCIA_ID, orden from [SIGSALUD].[dbo].[EMERGENCIA] 
  where fecha =  CONVERT(datetime, '2018-01-08', 101) order by EMERGENCIA_ID 
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_orden, "torden")
SELECT torden
GO top
SCAN
   lid = ALLTRIM(torden.emergencia_id)
   lnro = ln_numero_inicial
   lc_nuevo_numero = PADL(ALLTRIM(STR(lnro + 1)), 3, '0')
   TEXT TO lc_update noshow
     UPDATE [SIGSALUD].[dbo].[EMERGENCIA]  SET orden = ?lc_nuevo_numero WHERE EMERGENCIA_ID = ?lid
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lc_update)  
   IF lejecutabusca> 0
      cMensage = '...GRABACION OK ............' 
      _Screen.Scalemode = 0
      Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ELSE
      cMensage = '...ERROR DE GRABACION.............' 
      _Screen.Scalemode = 0
      Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ENDIF
   ln_numero_inicial = ln_numero_inicial + 1
ENDSCAN
      cMensage = '...TODO TERMINO...........' 
      _Screen.Scalemode = 0
      Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
