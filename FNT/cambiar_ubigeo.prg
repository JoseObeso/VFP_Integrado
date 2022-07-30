CLEAR

**  cambiar ubigeo  *
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

cMensage = '...CAMBIAR UBIGEO...' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

 
TEXT TO lqy_ubicar_distro noshow
 select DISTRITO, DISTRITON  from PACIENTE
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqy_ubicar_distro,"tdistro")
SELECT tdistro
GO top
SCAN
   lcdistrito = tdistro.distrito
   lcdistriton = tdistro.DISTRITON
   TEXT TO lqry_distri noshow
    UPDATE paciente SET distrito = (SELECT ubigeoreniec FROM ubigeo WHERE ubigeo = ?lcdistrito) where distrito = ?lcdistrito
    UPDATE paciente SET distriton = (SELECT ubigeoreniec FROM ubigeo WHERE ubigeo = ?lcdistriton) where distriton = ?lcdistriton
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lqry_distri) 
   IF lejecutabusca > 0
     cMensage = '...DISTRITO........   ' +lcdistrito
     _Screen.Scalemode = 0
     Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ELSE
     cMensage = '...NO EJECUTADO....   ' +lcdistrito
     _Screen.Scalemode = 0
     Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ENDIF

ENDSCAN
cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

