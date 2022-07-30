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
  
lo = NEWOBJECT("_CommonFolder",HOME(1)+"FFC\_System")
lcMD = lo.GetFolder(5)
lo = .Null.

TEXT TO lver_final noshow
 SELECT * FROM [SIGSALUD].[dbo].[TMP_PRE_ICI] ORDER BY NOMBRE_CLASE, NOMBRE ASC
ENDTEXT
lejecuta=SQLEXEC(gconecta,lver_final, "tfin")
SELECT tfin
nfin = RECCOUNT()
IF nfin = 0
   MESSAGEBOX("NO EXISTEN REGISTROS EN ESTE RANGO DE OPERACIONES Y FECHAS ...",1, "GRACIAS POR SU PREFERENCIA.....")
   RETURN .T.
ELSE
  cMensage = ' ...ARCHIVO EN EXCEL....UBICADO EN LA CARPETA : ' + lcMD + '.... PROCESO CULMINADO...VAMOS CON EL REPORTE......' 
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
  COPY TO lcMD + '\ARCHIVO_PRE_ICI_TOTAL.XLS' TYPE XLS
 * DO FOXYPREVIEWER.APP
 * _Screen.oFoxyPreviewer.cLanguage = "SPANISH"
 * REPORT FORM rpt_pre_ici.frx PREVIEW   
ENDIF
