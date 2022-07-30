************* APLICACION PARA MONITOREO DE ADMISION  ****
*****************************************************************************
PUBLIC gconecta, gctitulo, gcfecha, gchora, gctemporal, gcgraficos, lclogo, lcuser, lcruta, gcsistema, gctitulo,;
       gndecimal, lcmenu, gcdescripcion, gcnombrepc_user_red

SET CENTURY ON
SET DATE TO ANSI
SET MESSAGE TO ""

* REVISA LA EJECUCION POR PRIMERA VEZ 

IF FirsTime("madmision.exe")  = .t.
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
      lcStringCnxLocal = "Driver={SQL Server Native Client 10.0};" +  "SERVER=" + x_Server + ";" +  "UID=" + x_UID + ";" + "PWD=" + x_PWD + ";" + "DATABASE=" + x_DBaseName + ";"
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
      gcfecha = DTOC(DATE())
      gchora = TIME()
      lcruta = ADDBS(FULLPATH(CURDIR()))
      nnro = AT("FNT", lcruta)
      IF nnro <> 0
         gcgraficos = substr(lcruta,1,nnro-1) + "GRA\"
      ELSE
         gcgraficos = lcruta + "GRA\"
      ENDIF
      gcruta = lcruta       
      gcsistema = "SINTEGRADAS"
      gctitulo = "SISTEMA DE MONITOREO DE ADMISION "
      gndecimal = 0
      gcnombrepc_user_red = SYS(0)
      _screen.Caption = gcsistema + " : " + gctitulo +  "  [FECHA : " + gcfecha + "] " + "  APLICACION : " + gcruta + "   SERVIDOR :   " + UPPER(x_Server)
      _screen.picture=gcgraficos + "fondoadmision.jpg"
      _screen.icon=gcgraficos  + "adminicon2.ico"
      _Screen.AddProperty("lmostrar","")
      DO ambientador
      if !gconecta = 1 then 
      	  MESSAGEBOX("NO EXISTE CONEXION: PARAMETROS INCORRECTOS/FALTANTES O PROBLEMAS CON LA RED DE DATOS  LAN/WAN O CLAVE DE BD INCORRECTA",0,"VERIFIQUE LA RED O SERVIDOR")
          QUIT
      ELSE
         ON SHUTDOWN CLEAR EVENTS
         DO FORM frmloginad
         READ events
      ENDIF
      ON SHUTDOWN  
      DO ambientador
   ELSE
     MESSAGEBOX("NO EXISTE ARCHIVO DE PARAMETROS DE CONEXION",0,"VERIFIQUE LA EXISTENCIA DE ARCHIVOS Y LAS CLAVES")
     QUIT
 ENDIF

ELSE
    QUIT
ENDIF

********************************
	PROCEDURE ambientador
		_ASCIICOLS = 240
		SET BRSTATUS OFF
		SET COLOR TO
		SET CURSOR ON
		SET CARRY OFF
		SET CENTURY ON
		SET CLEAR ON
		SET CLOCK STATUS
		SET CONSOLE OFF
		SET DATE TO ANSI
		SET DECIMAL TO 1
		SET DELETED ON
		SET DEVICE TO SCREEN
		SET DEVELOPMENT ON
		SET ECHO OFF
		SET ESCAPE OFF
		SET EXCLUSIVE OFF
		SET EXACT OFF
		SET FIXED ON
		SET FULLPATH ON
		SET FUNCTION F2 TO ''
		SET FUNCTION F3 TO ''
		SET FUNCTION F4 TO ''
		SET FUNCTION F5 TO ''
		SET FUNCTION F6 TO ''
		SET FUNCTION F7 TO ''
		SET FUNCTION F8 TO ''
		SET FUNCTION F9 TO ''
		SET FUNCTION F10 TO ''
		SET HEADING OFF
		SET MOUSE ON
		SET MEMOWIDTH TO 240
		SET MULTILOCKS ON
		SET NOTIFY OFF
		SET OPTIMIZE ON
		SET PRINTER OFF
		SET PRINTER TO
		SET REPROCESS TO AUTOMATIC
		SET SAFETY OFF
		SET STATUS OFF
		SET STEP OFF
		SET STICKY ON
		SET SYSMENU OFF
		SET TALK OFF
		SET UNIQUE OFF
		SET VIEW OFF
		SET CLOCK STATUS
		SET COLLATE TO 'GENERAL'
		SET MESSAGE TO ""
		SET DATE TO dmy
	ENDPROC
  

PROCEDURE FirsTime
LPARAMETERS tcAppName
LOCAL lcMsg, lcAppName, lnMutexHandle, lnhWnd, llRetVal
lcMsg = ''
SET ASSERTS ON
IF EMPTY( NVL( tcAppName, '' ) )
   ASSERT .F. MESSAGE lcMsg
  RETURN 
ENDIF
lcAppName = UPPER( ALLTRIM( tcAppName ) ) + CHR( 0 )
DECLARE INTEGER CreateMutex IN WIN32API INTEGER lnAttributes, INTEGER lnOwner, STRING @lcAppName
DECLARE INTEGER GetProp IN WIN32API INTEGER lnhWnd, STRING @lcAppName
DECLARE INTEGER SetProp IN WIN32API INTEGER lnhWnd, STRING @lcAppName, INTEGER lnValue
DECLARE INTEGER CloseHandle IN WIN32API INTEGER lnMutexHandle
DECLARE INTEGER GetLastError IN WIN32API 
DECLARE INTEGER GetWindow IN USER32 INTEGER lnhWnd, INTEGER lnRelationship
DECLARE INTEGER GetDesktopWindow IN WIN32API 
DECLARE BringWindowToTop IN Win32APi INTEGER lnhWnd
DECLARE ShowWindow IN WIN32API INTEGER lnhWnd, INTEGER lnStyle
lnMutexHandle = CreateMutex( 0, 1, @lcAppName )
IF GetLastError() = 183
  lnhWnd = GetWindow( GetDesktopWindow(), 5 )
  DO WHILE lnhWnd > 0
     IF GetProp( lnhWnd, @lcAppName ) = 1
       BringWindowToTop( lnhWnd )
       ShowWindow( lnhWnd, 3 )
       EXIT
     ENDIF
     lnhWnd = GetWindow( lnhWnd, 2  )
  ENDDO
  CloseHandle( lnMutexHandle )
ELSE
  SetProp( _vfp.Hwnd, @lcAppName, 1)
  llRetVal = .T.
ENDIF
RETURN llRetVal
ENDPROC



FUNCTION EsFechaValida(tnDia, tnMes, tnAnio)
  RETURN ;
    VARTYPE(tnAnio) = "N" AND ;
    VARTYPE(tnMes) = "N" AND ;
    VARTYPE(tnDia) = "N" AND ;
    BETWEEN(tnAnio, 100, 9999) AND ;
    BETWEEN(tnMes, 1, 12) AND ;
    BETWEEN(tnDia, 1, 31) AND ;
    NOT EMPTY(DATE(tnAnio, tnMes, tnDia))
ENDFUNC


FUNCTION ObtenerHora(tn)
  lnHora = INT(tn)
  lnMin = INT((tn - lnHora) * 60)
RETURN TRANSFORM(lnHora, "@L 99")+ ":" + TRANSFORM(lnMin, "@L 99")



FUNCTION agregar_citas_horas_en_blanco()
  FOR RT = 1 TO lnbucle
    lcnumerocita = ALLTRIM(STR(lnnumeroinicial))
    cMensage = '........AGREGANDO CITA NRO. :  ' +lcnumerocita
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      TEXT TO lqry_agregar_citas noshow
         declare @lid_cita int = (select convert(int, MAX(CITA_ID)) + 1  as id_cita from CITA)
         DECLARE @ldfecha datetime = convert(datetime, ?lcfechadia, 101)
         declare @lchora char(6) = ?lchora
         declare @lcnumero varchar(3) = ?lcnumerocita
         declare @lcturno char(2) = ?lcturno
         declare @lcnombre varchar(60) = '                                                              '
         DECLARE @lcconsultorio varchar(8) = ?lcconsultorio
         declare @lcmedico varchar(4) = ?lcmedico
         INSERT INTO [SIGSALUD].[dbo].[CITA]([CITA_ID],[CONSULTORIO],[MEDICO],[FECHA_PROGRAMACION],[FECHA_OTORGA],[FECHA_PAGO],[FECHA_LIBRE],[FECHA],[HORA],[TURNO_CONSULTA],[TIPO_PACIENTE],[TIPO_CITA],[PACIENTE],[NOMBRE],[OBSERVACION],
           [PAGOID],[SEGURO],[ESTADO],[NUMERO],[HORA_OTORGA],[TIPO_SOLICITUD],[SITUACION],[USUARIO],[NUMATENCION],[USER_ELIMINACION],[FECHA_HORA_ELIMINACION])
                 VALUES (convert(char(9), @lid_cita), @lcconsultorio, @lcmedico, GETDATE() - 0.15, NULL, NULL, NULL, @ldfecha, @lchora, @lcturno, 'N', 'C', ' ', ' ', ' ', ' ','0','1', @lcnumero, @lcnombre, 'P', null, null, '0', null, null)
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_agregar_citas)
      lnnumeroinicial =   lnnumeroinicial  +1
  ENDFOR
  cMensage = '........TODO TERMINADO...'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDFUNC


FUNCTION agregar_citas_con_horas_m() 
  FOR RT = 1 TO lnbucle
    lcnumerocita = PADL(ALLTRIM(STR(lnnumeroinicial)), 2, '0')
    lhoragrabar =  lchora_inicio
    cMensage = '........AGREGANDO CITA NRO. :  ' +lcnumerocita
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      TEXT TO lqry_agregar_citas_horas noshow
         declare @lid_cita int = (select convert(int, MAX(CITA_ID)) + 1  as id_cita from CITA)
         DECLARE @ldfecha datetime = convert(datetime, ?lcfechadia, 101)
         declare @lchora char(6) = ?lhoragrabar
         declare @lcnumero varchar(3) = ?lcnumerocita
         declare @lcturno char(2) = ?lcturnom
         declare @lcnombre varchar(60) = '                                                              '
         DECLARE @lcconsultorio varchar(8) = ?lcconsultorio
         declare @lcmedico varchar(4) = ?lcmedico
         INSERT INTO [SIGSALUD].[dbo].[CITA]([CITA_ID],[CONSULTORIO],[MEDICO],[FECHA_PROGRAMACION],[FECHA_OTORGA],[FECHA_PAGO],[FECHA_LIBRE],[FECHA],[HORA],[TURNO_CONSULTA],[TIPO_PACIENTE],[TIPO_CITA],[PACIENTE],[NOMBRE],[OBSERVACION],
           [PAGOID],[SEGURO],[ESTADO],[NUMERO],[HORA_OTORGA],[TIPO_SOLICITUD],[SITUACION],[USUARIO],[NUMATENCION],[USER_ELIMINACION],[FECHA_HORA_ELIMINACION])
                 VALUES (convert(char(9), @lid_cita), @lcconsultorio, @lcmedico, GETDATE() - 0.15, NULL, NULL, NULL, @ldfecha, @lchora, @lcturno, 'N', 'C', ' ', ' ', ' ', ' ','0','1', @lcnumero, @lcnombre, 'P', null, null, '0', null, null)
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_agregar_citas_horas)
      lnnumeroinicial =   lnnumeroinicial  +1
      lchora_inicio = substr(TTOC(CTOT(lchora_inicio) + lchora_intervalo*60),12,5)
  ENDFOR
  cMensage = '........TODO TERMINADO...'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDFUNC



FUNCTION agregar_citas_con_horas_t() 
  FOR RT = 1 TO lnbucle
    lcnumerocita = PADL(ALLTRIM(STR(lnnumeroinicial)), 2, '0')
    lhoragrabar =  lchora_inicio
    cMensage = '........AGREGANDO CITA NRO. :  ' +lcnumerocita
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      TEXT TO lqry_agregar_citas_horas noshow
         declare @lid_cita int = (select convert(int, MAX(CITA_ID)) + 1  as id_cita from CITA)
         DECLARE @ldfecha datetime = convert(datetime, ?lcfechadia, 101)
         declare @lchora char(6) = ?lhoragrabar
         declare @lcnumero varchar(3) = ?lcnumerocita
         declare @lcturno char(2) = ?lcturnot
         declare @lcnombre varchar(60) = '                                                              '
         DECLARE @lcconsultorio varchar(8) = ?lcconsultorio
         declare @lcmedico varchar(4) = ?lcmedico
         INSERT INTO [SIGSALUD].[dbo].[CITA]([CITA_ID],[CONSULTORIO],[MEDICO],[FECHA_PROGRAMACION],[FECHA_OTORGA],[FECHA_PAGO],[FECHA_LIBRE],[FECHA],[HORA],[TURNO_CONSULTA],[TIPO_PACIENTE],[TIPO_CITA],[PACIENTE],[NOMBRE],[OBSERVACION],
           [PAGOID],[SEGURO],[ESTADO],[NUMERO],[HORA_OTORGA],[TIPO_SOLICITUD],[SITUACION],[USUARIO],[NUMATENCION],[USER_ELIMINACION],[FECHA_HORA_ELIMINACION])
                 VALUES (convert(char(9), @lid_cita), @lcconsultorio, @lcmedico, GETDATE() - 0.15, NULL, NULL, NULL, @ldfecha, @lchora, @lcturno, 'N', 'C', ' ', ' ', ' ', ' ','0','1', @lcnumero, @lcnombre, 'P', null, null, '0', null, null)
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_agregar_citas_horas)
      lnnumeroinicial =   lnnumeroinicial  +1
      lchora_inicio = substr(TTOC(CTOT(lchora_inicio) + lchora_intervalo*60),12,5)
  ENDFOR
  cMensage = '........TODO TERMINADO...'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDFUNC


FUNCTION agregar_citas_con_horas_i() 
  FOR RT = 1 TO lnbucle
    lcnumerocita = PADL(ALLTRIM(STR(lnnumeroinicial)), 2, '0')
    lhoragrabar =  lchora_inicio
    cMensage = '........AGREGANDO CITA NRO. :  ' +lcnumerocita
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      TEXT TO lqry_agregar_citas_horas noshow
         declare @lid_cita int = (select convert(int, MAX(CITA_ID)) + 1  as id_cita from CITA)
         DECLARE @ldfecha datetime = convert(datetime, ?lcfechadia, 101)
         declare @lchora char(6) = ?lhoragrabar
         declare @lcnumero varchar(3) = ?lcnumerocita
         declare @lcturno char(2) = ?lcturnoi
         declare @lcnombre varchar(60) = '                                                              '
         DECLARE @lcconsultorio varchar(8) = ?lcconsultorio
         declare @lcmedico varchar(4) = ?lcmedico
         INSERT INTO [SIGSALUD].[dbo].[CITA]([CITA_ID],[CONSULTORIO],[MEDICO],[FECHA_PROGRAMACION],[FECHA_OTORGA],[FECHA_PAGO],[FECHA_LIBRE],[FECHA],[HORA],[TURNO_CONSULTA],[TIPO_PACIENTE],[TIPO_CITA],[PACIENTE],[NOMBRE],[OBSERVACION],
           [PAGOID],[SEGURO],[ESTADO],[NUMERO],[HORA_OTORGA],[TIPO_SOLICITUD],[SITUACION],[USUARIO],[NUMATENCION],[USER_ELIMINACION],[FECHA_HORA_ELIMINACION])
                 VALUES (convert(char(9), @lid_cita), @lcconsultorio, @lcmedico, GETDATE() - 0.15, NULL, NULL, NULL, @ldfecha, @lchora, @lcturno, 'N', 'C', ' ', ' ', ' ', ' ','0','1', @lcnumero, @lcnombre, 'P', null, null, '0', null, null)
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_agregar_citas_horas)
      lnnumeroinicial =   lnnumeroinicial  +1
      lchora_inicio = substr(TTOC(CTOT(lchora_inicio) + lchora_intervalo*60),12,5)
  ENDFOR
  cMensage = '........TODO TERMINADO...'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDFUNC


FUNCTION Diferencia_AMD(tdIni, tdFin)
  LOCAL ldAux, lnAnio, lnMes, lnDia, lcRet
  *--- Fecha inicial siempre menor
  IF tdIni > tdFin
    ldAux = tdIni
    tdIni = tdFin
    tdFin = ldAux
  ENDIF
  lnAnio = YEAR(tdFin) - YEAR(tdIni)
  ldAux = GOMONTH(tdIni, 12 * lnAnio)
  *--- No cumplio el año aun
  IF ldAux > tdFin
    lnAnio = lnAnio - 1
  ENDIF
  lnMes = MONTH(tdFin) - MONTH(tdIni)
  IF lnMes < 0
    lnMes = lnMes + 12
  ENDIF
  lnDia = DAY(tdFin) - DAY(tdIni)
  IF lnDia < 0
    lnDia = lnDia + DiasDelMes(tdIni)
  ENDIF
  *--- Si el dia es mayor, no cumplio el mes
  IF (DAY(tdFin) < DAY(tdIni))
    IF lnMes = 0
      lnMes = 11
    ELSE
      lnMes = lnMes - 1
    ENDIF
  ENDIF
  lcRet = ALLTRIM(STR(lnAnio))+ "a" + PADL(ALLTRIM(STR(lnMes)), 2,'0')+ "m" +PADL(ALLTRIM(STR(lnDia)),2,'0')+ "d"
  RETURN lcRet
ENDFUNC 


FUNCTION DiasDelMes(tdFecha)
  LOCAL ld
  ld = GOMONTH(tdFecha,1)
  RETURN DAY(ld - DAY(ld))
ENDFUNC 