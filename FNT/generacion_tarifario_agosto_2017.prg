CLEAR

**  
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

cMensage = '...BUSCANDO..ITEMS.....' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


TEXT TO lqry_buscar_items noshow
  use SIGSALUD
  TRUNCATE TABLE  [SIGSALUD].[dbo].[TARIFARIO_AGOSTO_2017]
  select codcpt, COUNT(codcpt) as cnt from item where substring(ITEM,1,1) = '6'  group by CODCPT order by COUNT(codcpt) desc
ENDTEXT
lejecuta = sqlexec(gconecta,lqry_buscar_items, "titems")
SELECT titems
GO top
SCAN
  lc_codcpt = ALLTRIM(titems.codcpt)
  TEXT TO lqry_nombre_item NOSHOW
    select nombre from ITEM where substring(ITEM,1,1) = '6' and codcpt = ?lc_codcpt and ACTIVO = '1'
  ENDTEXT
  lejecuta = sqlexec(gconecta,lqry_nombre_item, "tver_nombre")
  SELECT tver_nombre
  lc_nombre = alltrim(tver_nombre.nombre)
 
  TEXT TO lqry_ver_pagante noshow
    select PRECIOA from PRECIO  where ITEM in (select item from ITEM where substring(ITEM,1,1) = '6' and codcpt = ?lc_codcpt and ACTIVO = '1')
  ENDTEXT
  lejecuta = sqlexec(gconecta,lqry_ver_pagante, "tprecioa")
  SELECT tprecioa
  lnprecioa = tprecioa.precioa
  
  
  TEXT TO lqry_ver_sis_soat noshow
    select PRECIOE, PRECIOH from PRECIO  where ITEM in (select item from ITEM where substring(ITEM,1,1) = '6' and codcpt = ?lc_codcpt and ACTIVO = '7')
  ENDTEXT
  lejecuta = sqlexec(gconecta,lqry_ver_sis_soat, "tpreciosis")
  SELECT tpreciosis
  lnpreciosis = tpreciosis.precioe
  lnpreciosoat = tpreciosis.precioh
  
  TEXT TO lqry_agregar noshow
       INSERT INTO [SIGSALUD].[dbo].[TARIFARIO_AGOSTO_2017]([CPT],[NOMBRE],[PRECIO_PAGANTE],[PRECIO_SIS],[PRECIO_SOAT])
       VALUES (?lc_codcpt, ?lc_nombre, ?lnprecioa, ?lnpreciosis, ?lnpreciosoat) 
  ENDTEXT
  lejecuta = sqlexec(gconecta,lqry_agregar)     
  IF lejecuta > 0
    cMensage = '...SE AGREGO CORRECTAMENTE....' +lc_codcpt
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  ELSE
    cMensage = '...FALLA EN AGREGAR....'
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  ENDIF
  
  
ENDSCAN
 
  
    

