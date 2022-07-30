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
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF
?lcStringCnxLocal
cMensage = '...BUSCANDO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lvercpt noshow
    SELECT ITEM, CODCPT, NOMBRE FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '1' ORDER BY NOMBRE ASC
ENDTEXT
lejecutabusca = sqlexec(gconecta,lvercpt,"tcpt")
SELECT tcpt
GO top
n = 1
SCAN
  lcpt = ALLTRIM(tcpt.codcpt)
  lcnombre = ALLTRIM(tcpt.nombre)
  TEXT TO lbuscar noshow
    SELECT codigo FROM ciexhis WHERE LTRIM(RTRIM(codigo)) = ?lcpt
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lbuscar,"tbus")  
  nbus = RECCOUNT()
  IF nbus > 0
    TEXT TO lver_update noshow
       update CIEXHIS set NOMBRE = SUBSTRING(?lcnombre, 1,180) WHERE codigo = ?lcpt
    ENDTEXT
    lejecutabusca = sqlexec(gconecta,lver_update)  
    TEXT TO rev NOSHOW
        UPDATE ITEM SET REVISION = 'M' WHERE CODCPT = ?lcpt AND SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '1'
    ENDTEXT
    lejecutabusca2 = sqlexec(gconecta,rev)
      ?'-----------------------------'    
    ?'SE MODIFICO : ' +lcnombre
  ELSE
   TEXT TO lgrabar noshow
      declare @lcodord int
      set @lcodord = (SELECT max(codord) + 1  FROM CIEXHIS where substring(convert(varchar(6), codord),1,1) = 1)
      INSERT INTO [SIGSALUD].[dbo].[CIEXHIS]([CODORD],[CODIGO],[NOMBRE],[SEXO],[MIN_EDAD],[MIN_TIPO],[MAX_EDAD],[MAX_TIPO],[EST],[CLASE],[CODCAT])
          VALUES (@lcodord, ?lcpt, SUBSTRING(?lcnombre, 1,180), '', 1, 'D', 99, 'A', 'A', '4', 'X')
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lgrabar)
   IF lejecutabusca > 0
      TEXT TO rev NOSHOW
        UPDATE ITEM SET REVISION = 'G' WHERE CODCPT = ?lcpt AND SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '1'
      ENDTEXT
      lejecutabusca2 = sqlexec(gconecta,rev)
      ?'-----------------------------'      
      ?'SE GRABO : ' +lcnombre
   ELSE
      TEXT TO rev1 NOSHOW
        UPDATE ITEM SET REVISION = 'N' WHERE CODCPT = ?lcpt AND SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '1'
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,rev1)
      ?'-----------------------------'
      ?'NO SE GRABO... : ' +lcnombre
   ENDIF
   WAIT windows "Actualizando CPT :  " +SUBSTR(lcnombre,1,180) nowait
  ENDIF
  n = n +1 
  ?n
ENDSCAN
  cMensage = '...FIN DE ACTUALIZACION CPT....'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  ?'TERMINO PROCESAMIENTO'
  

