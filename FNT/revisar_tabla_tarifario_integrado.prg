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

cMensage = '...INICIANDO PROCESO........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


TEXT TO lqry_ver_cpt1 noshow
  TRUNCATE TABLE [SIGSALUD].[dbo].[TARIFARIO_INTEGRADO_TOTAL]  
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_cpt1)

TEXT TO lqry_ver_cpt noshow
  SELECT [NRO],[CPT],[DESCRIPCION],[PRECIO_SIS],[RESOLUCION]  FROM [SIGSALUD].[dbo].[TARIFARIO_INTEGRADO] ORDER BY CPT ASC
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_cpt,"tver_cpt")
SELECT tver_cpt
GO top
SCAN
  lccpt = ALLTRIM(tver_cpt.cpt)
  TEXT TO lqry_grabar_nuevo noshow
    INSERT INTO [SIGSALUD].[dbo].[TARIFARIO_INTEGRADO_TOTAL] ([CPT],[DESCRIPCION],[PRECIO_SIS],[RESOLUCION])
     SELECT top 1 [CPT],upper([DESCRIPCION]) as DESCRIPCION,[PRECIO_SIS],[RESOLUCION] FROM [SIGSALUD].[dbo].[TARIFARIO_INTEGRADO] WHERE CPT = ?lccpt order by precio_sis desc
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_grabar_nuevo)
  cMensage = '...GRABANDO NUEVO CPT ....' + lccpt
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN

cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

