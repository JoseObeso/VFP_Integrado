PUBLIC lctitulo, lcsubtitulo
CLEAR

**  Agregar CIE  *
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

cMensage = '...PRODUCTIVIDAD PROFESIONALES MEDICOS ....' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

lcfecha1 = '2017-08-01'
lcfecha2 = '2017-08-31'
lctitulo = "RELACION DE ATENCIONES DE MEDICOS EN CONSULTORIOS, EMERGENCIAS, HOSPITALIZACION"
lcsubtitulo  = " AGOSTO DEL 2017"
TEXT TO lqry_medicos noshow
  declare @lcfecha1 datetime = convert(datetime, ?lcfecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lcfecha2, 101)
  TRUNCATE TABLE [SIGSALUD].[dbo].[TMP_SERVICIOS_ATENCIONES]
  select A.CODIGO, A.IdServDepartUnid, B.Nombre as servicio, C.DNI_ACTUAL, D.DNI, D.MEDICO, C.NOMBRE AS NOMBRE_MEDICO  from [BDPERSONAL].[dbo].[ASISTENCIA]  A 
  LEFT JOIN [BDPERSONAL].[dbo].[ServicioDepartUnidad] B ON A.IdServDepartUnid = B.IdServDepartUnid 
  LEFT JOIN [BDPERSONAL].[dbo].[MAESTRO] C ON C.CODIGO = A.CODIGO LEFT JOIN [SIGSALUD].[dbo].[MEDICO] D ON D.DNI = C.DNI_ACTUAL
   where A.AÑO = YEAR(@lcfecha1) AND A.MES = MONTH(@lcfecha1) AND A.IdServDepartUnid NOT IN (2, 3, 4, 8, 11, 12, 13, 15, 21, 22, 23, 24, 25, 26, 27, 28, 42, 51, 52, 58, 59, 60, 61, 65, 66, 67,
   68, 69, 70, 71, 72, 74, 75, 76, 78, 80, 81, 82, 83, 86, 87, 88, 93, 109, 110, 111, 113, 118) AND A.IdServDepartUnid IS NOT NULL AND  D.DNI IS NOT NULL 
   GROUP BY A.CODIGO, A.IdServDepartUnid, B.Nombre, C.DNI_ACTUAL, C.NOMBRE, D.DNI, D.MEDICO, C.NOMBRE  ORDER BY B.NOMBRE, C.NOMBRE   ASC
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_medicos,"trelacion")
SELECT trelacion
GO top
SCAN
  lcservicio = ALLTRIM(trelacion.servicio)
  lcmedico = ALLTRIM(trelacion.medico)
  lcnombre_medico = ALLTRIM(trelacion.nombre_medico)
  lcservicio = ALLTRIM(trelacion.servicio)
  TEXT TO lqry_atenciones NOSHOW 
    declare @lcfecha1 datetime = convert(datetime, ?lcfecha1, 101)
    declare @lcfecha2 datetime = convert(datetime, ?lcfecha2, 101)
    DECLARE @lcmedico varchar(3) = ?lcmedico
    declare @lcnombre_medico varchar(250) =  ?lcnombre_medico
    declare @lc_servicio varchar(200) = ?lcservicio
	INSERT INTO [SIGSALUD].[dbo].[TMP_SERVICIOS_ATENCIONES]([SERVICIO],[MEDICO],[TIPO_ATENCION],[ATENCIONES])
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO, 'CONSULTORIOS' AS TIPO_ATENCION,  COUNT(FECHA) AS ATENCIONES from 
	[SIGSALUD].[dbo].[ATENCIONC] where FECHA between @lcfecha1 and @lcfecha2 and medico = @lcmedico
	UNION ALL
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'EMERGENCIA - ATENCION' AS TIPO_ATENCION, COUNT(EMERGENCIA_ID) AS ATENCIONES    from [SIGSALUD].[dbo].[EMERGENCIA]
	 where FECHA between @lcfecha1 and @lcfecha2  AND QUIEN_ATIENDE = @lcmedico
	UNION ALL
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'EMERGENCIA - EVOLUCION' AS TIPO_ATENCION, COUNT(EMERGENCIA_ID) AS ATENCIONES
	 FROM [SIGSALUD].[dbo].[EMERGENCIA_DET_WEB]  where FECHA between @lcfecha1 and @lcfecha2 AND  PROFESIONAL = @lcmedico
	UNION ALL 
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'HOSPITALIZACION - RECIBE' AS TIPO_ATENCION, COUNT(HOSPITALIZACION_ID) AS ATENCIONES from [SIGSALUD].[dbo].[HOSPITALIZACION]  where FECHA1 between @lcfecha1 and @lcfecha2 and RESPONSABLE1 = @lcmedico 
	union all
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'HOSPITALIZACION - ATIENDE' AS TIPO_ATENCION, COUNT(HOSPITALIZACION_ID) AS ATENCIONES from [SIGSALUD].[dbo].[HOSPITALIZACION] where FECHA3 between @lcfecha1 and @lcfecha2 and RESPONSABLE3 = @lcmedico 
	union all
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'HOSPITALIZACION - ATIENDE' AS TIPO_ATENCION, COUNT(HOSPITALIZACION_ID) AS ATENCIONES from [SIGSALUD].[dbo].[HOSPITALIZACION] where FECHA4 between @lcfecha1 and @lcfecha2 and RESPONSABLE4 = @lcmedico 
	union all 
	select @lc_servicio as SERVICIO, @lcnombre_medico  AS MEDICO,  'HOSPITALIZACION - DE ALTA' AS TIPO_ATENCION, COUNT(HOSPITALIZACION_ID) AS ATENCIONES from [SIGSALUD].[dbo].[HOSPITALIZACION] where FECHA1 between @lcfecha1 and @lcfecha2 and RESPONSABLE51 = @lcmedico  
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_atenciones)
  cMensage = '...PROCESANDO ATENCIONES PARA : ' +lcnombre_medico 
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN

TEXT TO lqry_ver_resultado noshow
  SELECT 'X' as INDICADOR, [SERVICIO],[MEDICO],[TIPO_ATENCION],[ATENCIONES]  FROM [SIGSALUD].[dbo].[TMP_SERVICIOS_ATENCIONES]
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_ver_resultado, "tver_resul")
SELECT tver_resul
nr = RECCOUNT()
IF nr > 0
  cMensage = '...GENERANDO REPORTES........'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  DO FOXYPREVIEWER.APP
  _Screen.oFoxyPreviewer.cLanguage = "SPANISH"
  REPORT FORM reporte_pro_medicos.frx PREVIEW  
ELSE

cMensage = '...NO EXISTEN ATENCIONES......'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


ENDIF







