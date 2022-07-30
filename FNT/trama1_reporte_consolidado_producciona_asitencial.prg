* REPORTE CONSOLIDADO DE PRODUCCION ASISTENCIAL EN CONSULTA AMBULATORIA

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
      ?lcStringCnxLocal
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF



lc_fecha1 = '2017-09-01'
lc_fecha2 = '2017-09-31'
lcipress = '0000005947'
lcmes = '09' 
lcanio = '2017'
lcnombre_archivo = lcipress + '_' + lcmes + '_' + lcanio + '_' + 'TAB1'
* lcnombre_archivo + '.XLS'




TEXT TO lqry_obtener_pacientes_mes noshow
  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
  TRUNCATE TABLE [SIGSALUD].[dbo].[TMP_TR_ATEN]
  truncate table [SIGSALUD].[dbo].[TMP_TR_ATEN_M]
  truncate table [SIGSALUD].[dbo].[TMP_TR_ATEN_F]  
  SELECT PACIENTE, COUNT(PACIENTE) AS ATENCIONES FROM [SIGSALUD].[dbo].[ATENCIONC] WHERE FECHA BETWEEN @lcfecha1  AND @lcfecha2 AND ESTADO = '0' GROUP BY PACIENTE ORDER BY  COUNT(PACIENTE)
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_obtener_pacientes_mes,"tpacientes_mes") 
SELECT tpacientes_mes
lnr = STR(RECCOUNT())
GO top
SCAN
  lc_paciente = ALLTRIM(tpacientes_mes.paciente)
  TEXT TO lqry_revisar_atenciones noshow
    declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
    declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
    DECLARE @lidpaciente varchar(13) = ?lc_paciente
    declare @lnatencion int = 1
    declare @lc_sexo varchar(1) = (select top 1 case WHEN SEXO = 'M' THEN '1' WHEN SEXO = 'F' THEN '2' ELSE 'N' END FROM [SIGSALUD].[dbo].[ATENCIONC] where PACIENTE = @lidpaciente AND FECHA BETWEEN @lcfecha1  AND @lcfecha2)
    declare @ln_atm int = (SELECT COUNT(*)  FROM [SIGSALUD].[dbo].[ATENCIONC] A LEFT JOIN [SIGSALUD].[dbo].[MEDICO] B ON B.MEDICO = A.MEDICO  WHERE A.PACIENTE = @lidpaciente AND A.FECHA BETWEEN @lcfecha1  AND @lcfecha2 AND ABREVIATURA = 'MED')
    declare @ln_atnm int = (SELECT COUNT(*)  FROM [SIGSALUD].[dbo].[ATENCIONC] A LEFT JOIN [SIGSALUD].[dbo].[MEDICO] B ON B.MEDICO = A.MEDICO  WHERE A.PACIENTE = @lidpaciente AND A.FECHA BETWEEN @lcfecha1  AND @lcfecha2 AND ABREVIATURA <> 'MED')
    declare @lc_grupo_edad varchar(2) = (SELECT top 1 CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
     WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
       WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
          ELSE  'ND' END FROM [SIGSALUD].[dbo].[ATENCIONC] WHERE PACIENTE = @lidpaciente AND FECHA BETWEEN @lcfecha1  AND @lcfecha2)
       INSERT INTO [SIGSALUD].[dbo].[TMP_TR_ATEN]([SEXO_PACIENTE],[GRUPO_EDAD],[ATENCION_MEDICO],[ATENCION_NO_MEDICO],[ATENDIDO_POR_MES])
       select @lc_sexo as sexo_paciente, @lc_grupo_edad as grupo_edad, @ln_atm as atencion_medico, @ln_atnm as atencion_no_medico, @lnatencion as atendido_por_mes
  ENDTEXT
  lejecuta=SQLEXEC(gconecta,lqry_revisar_atenciones) 
  cMensage = '..DE UN TOTAL DE :  --> ' + lnr + ' ---> PROCESANDO PARA : ' + lc_paciente
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
ENDSCAN

** PROCESANDO PARA MASCULINO */
TEXT TO lqry_aten_m NOSHOW
  INSERT INTO [SIGSALUD].[dbo].[TMP_TR_ATEN_M]([sex],[grupo_edad],[atm],[atnm],[attm])
    select '1' as sex, grupo_edad, sum(atencion_medico) as atm, sum(atencion_no_medico) as atnm, count(atendido_por_mes) as attm from [SIGSALUD].[dbo].[TMP_TR_ATEN]
        where sexo_paciente = '1' group by grupo_edad order by convert(int, grupo_edad)   
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_aten_m) 

TEXT TO lqry_mostrar_m noshow
  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
  DECLARE @lt_tmp_at_ged table (grupo_edad varchar(2))
  insert @lt_tmp_at_ged
  SELECT CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
   WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
     WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
        ELSE  'ND' END as grupo_edad  FROM [SIGSALUD].[dbo].[ATENCIONC] where  FECHA BETWEEN @lcfecha1  AND @lcfecha2  and SEXO = 'M' order by edad
   SELECT grupo_edad, COUNT(grupo_edad) as atencion_mes from @lt_tmp_at_ged group by grupo_edad order by convert(int, grupo_edad)
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_mostrar_m, "tmes_m")    
SELECT tmes_m
GO top
SCAN
 lc_ged = ALLTRIM(tmes_m.grupo_edad)
 ln_at_mes = tmes_m.atencion_mes
 TEXT TO lqry_gd_m noshow
   UPDATE [SIGSALUD].[dbo].[TMP_TR_ATEN_M] SET attm = ?ln_at_mes WHERE grupo_edad = ?lc_ged
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lqry_gd_m)    
 cMensage = '...PROCESANDO MASCULINO......' 
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
ENDSCAN


** PROCESANDO PARA FEMENINO */
TEXT TO lqry_aten_f NOSHOW
  INSERT INTO [SIGSALUD].[dbo].[TMP_TR_ATEN_F]([sex],[grupo_edad],[atm],[atnm],[attm])
    select '2' as sex, grupo_edad, sum(atencion_medico) as atm, sum(atencion_no_medico) as atnm, count(atendido_por_mes) as attm from [SIGSALUD].[dbo].[TMP_TR_ATEN]
        where sexo_paciente = '2' group by grupo_edad order by convert(int, grupo_edad)   
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_aten_f) 

TEXT TO lqry_mostrar_f noshow
  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
  DECLARE @lt_tmp_at_ged table (grupo_edad varchar(2))
  insert @lt_tmp_at_ged
  SELECT CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
   WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
     WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
        ELSE  'ND' END as grupo_edad  FROM [SIGSALUD].[dbo].[ATENCIONC] where  FECHA BETWEEN @lcfecha1  AND @lcfecha2  and SEXO = 'F' order by edad
   SELECT grupo_edad, COUNT(grupo_edad) as atencion_mes from @lt_tmp_at_ged group by grupo_edad order by convert(int, grupo_edad)
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_mostrar_f, "tmes_f")    
SELECT tmes_f
GO top
SCAN
 lc_ged = ALLTRIM(tmes_f.grupo_edad)
 ln_at_mes = tmes_f.atencion_mes
 TEXT TO lqry_gd_f noshow
   UPDATE [SIGSALUD].[dbo].[TMP_TR_ATEN_F] SET attm = ?ln_at_mes WHERE grupo_edad = ?lc_ged
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lqry_gd_f)    
 cMensage = '...PROCESANDO FEMENINO......' 
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
ENDSCAN



TEXT TO lqry_uni NOSHOW
  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
  declare @lcanio_mes varchar(6) = (select substring(convert(varchar(10), @lcfecha1, 103),7,4)) + (select substring(convert(varchar(10), @lcfecha1, 103),4,2))
  declare @lccodigo_ipress varchar(8) = '00005947'
  SELECT @lcanio_mes as PERIODO, @lccodigo_ipress as IPRESS, @lccodigo_ipress as UGIPRESS, SEX as SEXO_PACIENTE, GRUPO_EDAD, atm as ATENCION_MEDICA, ATNM AS ATENCION_NO_MEDICOA, ATTM AS ATENCION_POR_MES FROM [SIGSALUD].[dbo].[TMP_TR_ATEN_M]
  UNION ALL
  SELECT @lcanio_mes as PERIODO, @lccodigo_ipress as IPRESS, @lccodigo_ipress as UGIPRESS, SEX as SEXO_PACIENTE, GRUPO_EDAD, atm as ATENCION_MEDICA, ATNM AS ATENCION_NO_MEDICOA, ATTM AS ATENCION_POR_MES FROM [SIGSALUD].[dbo].[TMP_TR_ATEN_F]
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_uni, "tunir_trama1") 
SELECT tunir_trama1     

lcnombre_archivo = ''

COPY TO 'D:\trama_consolidado_produccion_asistencial.xls' TYPE XLS




cMensage = '...FINALIZADO...' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
CLOSE DATABASES all






