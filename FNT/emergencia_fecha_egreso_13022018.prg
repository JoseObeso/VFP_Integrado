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
  
SET HOURS TO 24
cMensage = '...INICIANDO PROCESO.............' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
TEXT TO lqry_ver_todo_emergencia  noshow
  declare @lnmes int = 3
  declare @lnanio int = 2018
  select emergencia_id, fecha_salida, fecha_sal,
     CASe when CHARINDEX('-', fecha_sal) > 0 then convert(datetime, fecha_sal, 101)
      when fecha_sal is null    then ''
        when fecha_sal = '__/__/__  '    then ''
          else fecha_sal end as nueva_fecha_sal  from  [SIGSALUD].[dbo].[EMERGENCIA] where MONTH(fecha) = @lnmes and YEAR(fecha) = @lnanio
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_todo_emergencia,"tveremer")
SELECT tveremer
ne = reccount()
GO top
SCAN
  lid_emergencia = ALLTRIM(tveremer.emergencia_id)
  lnvarchar_10_fecha_emergencia = TTOC(tveremer.nueva_fecha_sal)
  lnvarcharnueva_fecha = substr(ALLTRIM(lnvarchar_10_fecha_emergencia),1,2) + '/' + substr(ALLTRIM(lnvarchar_10_fecha_emergencia),4,2) + '/' + substr(ALLTRIM(lnvarchar_10_fecha_emergencia),7,4)
  TEXT TO lqry_actualizar noshow
       UPDATE  [SIGSALUD].[dbo].[EMERGENCIA]  SET fecha_sal = ?lnvarcharnueva_fecha WHERE emergencia_id = ?lid_emergencia
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_actualizar)   
  IF lejecutabusca > 0
    cMensage = '........GRABACION OK :....' +  lnvarcharnueva_fecha
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  
  ELSE
    cMensage = '........ERROR DE GRABACION: ..' +lnvarcharnueva_fecha
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
    ?lnvarcharnueva_fecha
  
  ENDIF
ENDSCAN
cMensage = '........TODO TERMINADO...'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


