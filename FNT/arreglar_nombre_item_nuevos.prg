** permite agregar nuevos items en caso no existiera y modificar precio item sis *
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
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF
?lcStringCnxLocal
cMensage = '...BUSCANDO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lvercpt noshow
  SELECT *, convert(varchar(250), nombre) as item_nuevo, RTRIM(LTRIM(CONVERT(VARCHAR(20), CPT))) AS CODCPT  FROM [SIGSALUD].[dbo].[NTARIFA_JUNIO23] where operacion = 'NO' 
ENDTEXT
lejecutabusca = sqlexec(gconecta,lvercpt,"tcpt")
SELECT tcpt
GO top
SCAN
  lccodcpt = ALLTRIM(tcpt.codcpt)
  lncpt = tcpt.cpt
  lcnombre = ALLTRIM(tcpt.item_nuevo)
  lnprecio = tcpt.sis
  ** ver si existe
  TEXT TO lqry_existe_item noshow
     use sigsalud
     declare @lccodcpt varchar(13) = ?lccodcpt
     update ITEM set NOMBRE = ?lcnombre, ABREVIATURA = ?lcnombre where CODCPT = @lccodcpt
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_existe_item)
  IF lejecutabusca>0
   ?'conforme'
  ELSE
   ? 'no grabo'
  ENDIF
   

ENDSCAN


cMensage = '...FIN DE PROCESO CPT....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
?'terminado'
