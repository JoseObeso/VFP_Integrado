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


TEXT TO lqry_ver_citas noshow
  declare @lc_consultorio varchar(6) = '5050' 
  declare @lc_medico  varchar(6) = 'LNH' 
  declare @lc_turno varchar(1) = 'M'
  declare @lnanio int = 2017
  declare @lnmes int = 12
  DECLARE @lndia int = 6
  declare @ln_minutos_consulta int = (select tiempo_n from [SIGSALUD].[dbo].[CONSULTORIO_PARAMETRO] where CONSULTORIO = @lc_consultorio and TURNO_CONSULTA = @lc_turno)
  declare @lc_horario_inicio varchar(6) = (select HORARIO_DE from [SIGSALUD].[dbo].[CONSULTORIO_PARAMETRO] where CONSULTORIO = @lc_consultorio and TURNO_CONSULTA = @lc_turno)
  SELECT @lc_horario_inicio AS HORA_INICIO, @ln_minutos_consulta as MINUTOS, CITA_ID, NUMERO, HORA, TURNO_CONSULTA FROM [SIGSALUD].[dbo].[CITA] WHERE CONSULTORIO = @lc_consultorio AND MEDICO =  @lc_medico AND TURNO_CONSULTA = @lc_turno
   and YEAR(fecha) = @lnanio and MONTH(fecha) = @lnmes  and DAY(fecha) = @lndia order by NUMERO 
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_citas,"tturno_citas")
SELECT tturno_citas
nr = RECCOUNT()
lchora_inicio = ALLTRIM(tturno_citas.HORA_INICIO)
lnminutos_intervalo = tturno_citas.minutos
lninicio_turno = 1
SCAN
   nturno = lninicio_turno
   lc_cita_id = ALLTRIM(tturno_citas.cita_id)
   lchoragrabar =  lchora_inicio
   lchora_inicio = substr(TTOC(CTOT(lchora_inicio) + lnminutos_intervalo*60),12,5)
   lcturno_grabar = PADL(ALLTRIM(STR(nturno)), 2, '0')
   TEXT TO lqry_grabar_turno_nro noshow
     UPDATE [SIGSALUD].[dbo].[CITA] SET numero = ?lcturno_grabar, hora = ?lchoragrabar  WHERE cita_id = ?lc_cita_id
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lqry_grabar_turno_nro)
   lninicio_turno = lninicio_turno +1
   cMensage = '...ORDENANDO....ESPERE UN MOMENTO.........' 
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN

cMensage = '...ORDENACION... FINALIZADA ..........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

