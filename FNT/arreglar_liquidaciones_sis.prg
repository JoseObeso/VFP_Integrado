** Revsiar cuentas al detalle de liquidaciones *
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

lcfecha1 = '2016-08-01'
lcfecha2 = '2016-08-31'
lcestado = '2'
lcseguro = '02'

TEXT TO lver_items_sis noshow
  select CUENTAID, ITEM  from CUENTADET where CUENTAID in (select CUENTAID from CUENTA  where FECHA_APERTURA between CONVERT(datetime, '2016-06-01', 101) and CONVERT(datetime, '2017-03-20', 101) 
    and ESTADO in ('1', '2') and SEGURO = '01')  and substring(ITEM,1,1) = '5'
ENDTEXT
lejecutabusca = sqlexec(gconecta,lver_items_sis,"tsis")
SELECT tsis
lss = RECCOUNT() 
IF lss = 0
   cMensage = '...NO EXISTEN CUENTAS SIS CON TARIFARIOS ANTIGUOS...' 
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ELSE
GO TOP
SCAN
  lcuentaid = ALLTRIM(tsis.cuentaid)
  lcitem = ALLTRIM(tsis.item)
  TEXT TO lubicar_sis noshow
   select ITEM from V_PRECIO_SIS where CODCPT = (select CODCPT from ITEM where ITEM = ?lcitem) and substring(ITEM, 1,2) = '60' and ACTIVO = '7'
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lubicar_sis,"titem_sis")   
  SELECT titem_sis
  lnuevo_item = ALLTRIM(titem_sis.item)
  TEXT TO lgrabar_nuevo noshow
     update CUENTADET set ITEM = ?lnuevo_item where CUENTAID = ?lcuentaid and ITEM = ?lcitem
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lgrabar_nuevo)
  cMensage = '...ARREGLANDO ITEMS.....DE : '+lcitem + ' HACIA : ' +lnuevo_item
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN
cMensage = '...TODO CULMINADO...'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDIF
