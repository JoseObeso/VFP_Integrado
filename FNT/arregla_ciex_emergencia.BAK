** Revsiar cuentas al detalle de liquidaciones *
CLEAR
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

cMensage = '...BUSCANDO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

 
TEXT TO lobtener noshow
  SELECT [CODCPT],[NOMBRE],[CLASIFICADOR]  FROM [SIGSALUD].[dbo].[TARIFARIO_TOTAL]
ENDTEXT
lejecutabusca = sqlexec(gconecta,lobtener,"tobte")
SELECT tobte
GO top
SCAN
  lccpt2 = ALLTRIM(tobte.codcpt)
  lcclasificador2 = ALLTRIM(tobte.clasificador)
  lcnombre2 = ALLTRIM(substr(tobte.nombre,1,100))
  TEXT TO lgraba noshow
   update item set clasificador = (SELECT CLASIFICADOR FROM [SIGSALUD].[dbo].[TARIFARIO_TOTAL] where CODCPT = ?lccpt2), 
    agregar_cpt = 'A' where LTRIM(RTRIM(CODCPT)) = ?lccpt2
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lgraba)
  cMensage = '...ACTUALIZANDO PARA : ' +lcnombre2
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN
cMensage = '...FALTA EL FINAL.......'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lgraba2 noshow
update item set clasificador = (SELECT distinct CLASIFICADOR FROM [SIGSALUD].[dbo].[TARIFARIO_TOTAL] where CODCPT = '1320'), 
    agregar_cpt = 'A' where LTRIM(RTRIM(CODCPT)) in (SELECT distinct CODCPT FROM [SIGSALUD].[dbo].[TARIFARIO_TOTAL] where CODCPT = '1320')
  ENDTEXT
lejecutabusca = sqlexec(gconecta,lgraba2)
cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
