clear
** Revisar las horas del turno mañana y tarde ******
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
  
cMensage = '...INICIANDO PROCESO.............' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lqry_ver_emer NOSHOW
  declare @lnmes int = 12
  declare @lnanio int = 2017
  select convert(datetime, a.fecha_ing, 103) + b.HORA as fecha_hora, fecha_atencion,
  CONVERT(VARCHAR(5), convert(time, (convert(datetime, a.fecha_ing, 103) + b.HORA  +  CAST('00:10:00' AS DATETIME)))) as hora_calculo_final,
   a.EMERGENCIA_ID, a.estado, a.ciex1, a.fecha, fecha_ing, HORA_ING, b.hora as hora_enfermera, a.HORA_SAL, fecha_salida from [SIGSALUD].[dbo].[EMERGENCIA] A
    LEFT JOIN  [SIGSALUD].[dbo].[EMERGENCIA_DET_WEB]  B on a.EMERGENCIA_ID = b.EMERGENCIA_ID
       where month(a.fecha) = @lnmes and year(a.fecha) = @lnanio and HORA_ING is null and B.TIPO_PROCESO = 'P06'
          and  a.CIEX1 <> '0' 
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_emer, "tver_emer")
SELECT tver_emer
GO top
SCAN
  lc_emergencia_id = ALLTRIM(tver_emer.emergencia_id)
  lc_hora_calculo_final = ALLTRIM(tver_emer.hora_calculo_final)
  
  TEXT TO lqry_actualizar noshow
    UPDATE [SIGSALUD].[dbo].[EMERGENCIA] SET hora_ing = ?lc_hora_calculo_final  WHERE emergencia_id = ?lc_emergencia_id
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_actualizar)
  IF lejecutabusca > 0
    cMensage = '...GRABACION OK.............' 
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  ELSE
    cMensage = '...INCORRECTO............' 
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  ENDIF
 
ENDSCAN


