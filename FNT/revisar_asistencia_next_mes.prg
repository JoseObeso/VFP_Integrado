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
  
** Para Mes:
lanio = YEAR(DATE())  
lmes = MONTH(DATE())
  
TEXT TO lseleccionfijos noshow
  truncate table  [BDPERSONAL].[dbo].[REVISA_ASISTENCIA]
  SELECT  CODIGO,NOMBRE, CODHORA,HORING,HORSAL FROM V_MAESTRO WHERE CODHORA <> 'R' AND CODHORA <> 'N' AND SITUACION NOT IN ('02', '07', '08', '11') ORDER BY NOMBRE ASC
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lseleccionfijos, "tsele")
SELECT tsele
GO top
SCAN
   lcod = ALLTRIM(tsele.codigo)
   lnom = ALLTRIM(tsele.nombre)
   lcodhora = ALLTRIM(tsele.codhora)
   lhorai = tsele.horing
   lhoras = tsele.horsal
   * Verifica si tiene asistencia */
   cMensage = " ASISTENCIA PARA : " + ALLTRIM(lnom)
   _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
   text to lver noshow
     DECLARE @lcodigo varchar(20) = ?lcod
     DECLARE @lanio varchar(4) = ?lanio
     DECLARE @lmes varchar(2) = ?lmes
     SELECT CODIGO FROM ASISTENCIA WHERE Año=@lanio and mes = @lmes  AND CODIGO=@lcodigo 
   ENDTEXT
   lejecutagrabar = sqlexec(gconecta,lver, "tver")
   SELECT tver
   nasistencia = reccount()
   IF nasistencia = 0
      TEXT TO lasis noshow
         INSERT INTO [BDPERSONAL].[dbo].[REVISA_ASISTENCIA] (CODIGO, NOMBRE, TIENE_ASISTENCIA, FECHA, ESTADO, CODHORA)
              VALUES (?lcod, ?lnom, 'NO TIENE ASISTENCIA', GETDATE(),'0', ?lcodhora)
      ENDTEXT
     lejecutagrabar = sqlexec(gconecta,lasis)
   ELSE
      TEXT TO lasis noshow
         INSERT INTO [BDPERSONAL].[dbo].[REVISA_ASISTENCIA] (CODIGO, NOMBRE, TIENE_ASISTENCIA, FECHA, ESTADO, CODHORA)
              VALUES (?lcod, ?lnom, 'SI TIENE ASISTENCIA', GETDATE(),'1', ?lcodhora)
      ENDTEXT
     lejecutagrabar = sqlexec(gconecta,lasis)
   ENDIF

ENDSCAN


FUNCTION DiasDelMes(tdFecha)
  LOCAL ld
  ld = GOMONTH(lfechareferencia,1)
  RETURN DAY(ld - DAY(ld))
ENDFUNC

