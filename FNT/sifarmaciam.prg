*************************************************************************************************
********  SISTEMA  INFORMATICO  DE   REPORTE DE FARMACIA  ************************
*************************************************************************************************
****************    SIFARMACIA  ***************************************************************


PUBLIC gconecta, gctitulo, gcfecha, gchora, gctemporal, gcgraficos, lrecupera, lcempresa, lcdepartamento, lclogo, lcuser,;
       lcentidade, lcruce, lcdireccione, lcfonoe, lcunidade, lcrepresentantee, lclogoe, lccorreoe, lctitulo,   gcunidad, gndecimal, lcmenu

SET CENTURY ON
SET DATE TO ANSI
SET MESSAGE TO ""
 

*-- Cuando se ejecuta por Primera vez
IF FirsTime("sifarmaciam.exe")  = .t.

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
  * Variables Globales
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
  gcsistema = "SIFARMACIA"
  gctitulo = "SISTEMA INFORMATICO DE REPORTE DE FARMACIAS "
  gndecimal = 0
  * Asignacion de Titulos con Valores 
  _screen.Caption = gcsistema + " : " + gctitulo +  "  [FECHA : " + gcfecha + "] " + "  APLICACION : " + gcruta + "   SERVIDOR :   " + UPPER(x_Server)
  _screen.picture=gcgraficos + "wfondo.jpg"
  _screen.icon=gcgraficos  + "c1.ico"
  _Screen.AddProperty("lmostrar","")
  DO ambientador
  if !gconecta = 1 then 
	  MESSAGEBOX("NO EXISTE CONEXION: PARAMETROS INCORRECTOS/FALTANTES O PROBLEMAS CON LA RED DE DATOS  LAN/WAN",0,"VERIFIQUE LA RED O SERVIDOR")
	  QUIT
  ELSE
      ON SHUTDOWN CLEAR EVENTS
      DO FORM frmloginn
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
		SET DECIMAL TO 3
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


  
