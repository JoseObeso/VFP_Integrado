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

TEXT TO lvercuenta noshow
  USE SIGSALUD 
  truncate table tmp_cta_rev
  INSERT INTO [SIGSALUD].[dbo].[TMP_CTA_REV]([cuentaid], [estado], [importe])
  select cuentaid, estado, importe from CUENTA WHERE fecha_apertura between convert(datetime, ?lcfecha1, 101) AND  convert(datetime, ?lcfecha2, 101) AND estado = ?lcestado AND seguro = ?lcseguro order by FECHA_APERTURA desc
  select cuentaid, estado, importe from [SIGSALUD].[dbo].[TMP_CTA_REV]
ENDTEXT
lejecutabusca = sqlexec(gconecta,lvercuenta,"tcta")
?lejecutabusca 
SELECT tcta
lnr = RECCOUNT() 
IF lnr = 0
   cMensage = '...NO EXISTEN CUENTAS EN ESTE RANGO DE FECHAS...' 
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ELSE
GO TOP
SCAN
  lidcta = ALLTRIM(tcta.cuentaid)
  lntotal = tcta.importe
  TEXT TO lbusca noshow
     select case when SUM(TOTAL) is null then 0 else SUM(TOTAL) end  AS TOTAL from CUENTADET where CUENTAID = ?lidcta
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lbusca,"tctadet")
  SELECT tctadet
  lntotaldet = tctadet.total
  IF lntotal =  lntotaldet
    TEXT TO llimpiar noshow
      DELETE FROM [SIGSALUD].[dbo].[TMP_CTA_REV] WHERE cuentaid = ?lidcta
    ENDTEXT
    lejecutabusca = sqlexec(gconecta,llimpiar)
  ENDIF
  cMensage = '...COMPARANDO CUENTAS : ' +lidcta
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN

ENDIF
