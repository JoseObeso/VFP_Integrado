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

lc_fecha1 = '2017-08-01'
lc_fecha2 = '2017-08-31'

*!*	TEXT TO lqry_obtener_pacientes_mes noshow
*!*	  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
*!*	  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
*!*	  TRUNCATE TABLE [SIGSALUD].[dbo].[TMP_MOR_ATN]
*!*	  SELECT PACIENTE FROM ATENCIONC WHERE ID_CITA IN (SELECT ID_CITA FROM ATENCIOND WHERE ID_CITA IN (SELECT ID_CITA FROM ATENCIONC WHERE FECHA BETWEEN @lcfecha1  AND @lcfecha2) AND TIPODX = 'D' AND SUBSTRING(DX,1,1) NOT IN ('9', 'U', '5', '1')
*!*	  AND LEN(DX) <= 4 AND DX <> '' GROUP BY ID_CITA)
*!*	ENDTEXT
*!*	lejecuta=SQLEXEC(gconecta,lqry_obtener_pacientes_mes,"tpacientes_mes") 
*!*	SELECT tpacientes_mes
*!*	lnr = STR(RECCOUNT())
*!*	GO top
*!*	SCAN
*!*	  lc_paciente = ALLTRIM(tpacientes_mes.paciente)
*!*	  TEXT TO lqry_revisar_atenciones noshow
*!*	    declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
*!*	    declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
*!*	    DECLARE @lidpaciente varchar(13) = ?lc_paciente
*!*	    declare @lnatencion int = 1
*!*	    declare @lc_sexo varchar(1) = (select top 1 case WHEN SEXO = 'M' THEN '1' WHEN SEXO = 'F' THEN '2' ELSE 'N' END FROM [SIGSALUD].[dbo].[ATENCIONC] where PACIENTE = @lidpaciente AND FECHA BETWEEN @lcfecha1  AND @lcfecha2)
*!*	    declare @lc_grupo_edad varchar(2) = (SELECT top 1 CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
*!*	     WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
*!*	       WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
*!*	          ELSE  'ND' END FROM [SIGSALUD].[dbo].[ATENCIONC] WHERE PACIENTE = @lidpaciente AND FECHA BETWEEN @lcfecha1  AND @lcfecha2)
*!*	    DECLARE @lt_tmp_diag table (dx varchar(5))
*!*	    insert @lt_tmp_diag
*!*	    SELECT dx FROM ATENCIOND WHERE ID_CITA IN (select id_cita from ATENCIONC where PACIENTE = @lidpaciente and FECHA between @lcfecha1 and @lcfecha2) AND TIPODX = 'D' AND SUBSTRING(DX,1,1) NOT IN ('9', 'U', '5', '1')
*!*	    AND LEN(DX) <= 4 AND DX <> ''
*!*	    INSERT INTO [SIGSALUD].[dbo].[TMP_MOR_ATN]([sexo_paciente],[grupo_edad],[diagnostico_definitivo],[total_atendidos])
*!*	    select @lc_sexo as sexo_paciente, @lc_grupo_edad as grupo_edad, dx as diagnostico_definitivo, 1 as total_atendidos from @lt_tmp_diag
*!*	  ENDTEXT
*!*	  lejecuta=SQLEXEC(gconecta,lqry_revisar_atenciones) 
*!*	  cMensage = '..DE UN TOTAL DE :  --> ' + lnr + ' ---> PROCESANDO PARA : ' + lc_paciente
*!*	  _Screen.Scalemode = 0
*!*	  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
*!*	  
*!*	ENDSCAN




*!*	** PROCESANDO PARA MASCULINO */
	TEXT TO lqry_aten_m NOSHOW
	  TRUNCATE TABLE [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL]
	  INSERT INTO [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL]([SEXO_PAC],[GRUPO_EDAD],[DIAGNOSTICO_DEFINITIVO],[TOTAL_ATENDIDOS])
	  SELECT '1' AS SEXO_PAC, GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO, '1' AS TOTAL_ATENDIDOS   FROM [SIGSALUD].[dbo].[TMP_MOR_ATN] 
	     where sexo_paciente = '1'  GROUP BY GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO 
	     SELECT * FROM [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL]   ORDER BY SEXO_PAC, convert(int, grupo_edad)    
	ENDTEXT
	lejecuta=SQLEXEC(gconecta,lqry_aten_m, "tfin_m") 
	SELECT tfin_m
	GO top
	SCAN
	  lc_dx  = ALLTRIM(tfin_m.DIAGNOSTICO_DEFINITIVO)
	  lc_geda = ALLTRIM(tfin_m.grupo_edad)
	  TEXT TO lqry_ver_t1 noshow
	  	  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
	  	  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
	  	  declare @ldiax varchar(4) = ?lc_dx
	  	  DECLARE @lt_tmp_at_ged table (SEX VARCHAR(1), grupo_edad varchar(2))
	  	   insert @lt_tmp_at_ged
	  	   SELECT '1' AS SEX, CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
	  	        WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
	  	               WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
	  	                         ELSE  'ND' END FROM ATENCIONC WHERE sexo = 'M' and  FECHA between @lcfecha1 and @lcfecha2 AND ID_CITA IN (
	  	                        select ID_CITA from ATENCIOND where DX = ?lc_dx and TIPODX = 'D' AND ID_CITA IN (SELECT ID_CITA FROM ATENCIONC WHERE FECHA between @lcfecha1 and @lcfecha2))
	  	                        SELECT grupo_edad, COUNT(GRUPO_EDAD) AS ATN FROM @lt_tmp_at_ged GROUP BY GRUPO_EDAD
	  ENDTEXT
      lejecuta=SQLEXEC(gconecta,lqry_ver_t1, "tfin_m2") 
      SELECT tfin_m2
      GO top
       SCAN
        lc_gredad = ALLTRIM(tfin_m2.grupo_edad)
        ln_atn = tfin_m2.atn
        TEXT TO lqry_agregar_atn noshow
          UPDATE [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL] SET total_atendidos = ?ln_atn WHERE grupo_edad = ?lc_gredad and diagnostico_definitivo = ?lc_dx 
        ENDTEXT
        lejecuta=SQLEXEC(gconecta,lqry_agregar_atn) 
      ENDSCAN
      
   ENDSCAN
      
	

*!*	** PROCESANDO PARA FEMENINO */
	TEXT TO lqry_aten_f NOSHOW
	  TRUNCATE TABLE [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL_F]
	  INSERT INTO [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL_F]([SEXO_PAC],[GRUPO_EDAD],[DIAGNOSTICO_DEFINITIVO],[TOTAL_ATENDIDOS])
	  SELECT '2' AS SEXO_PAC, GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO, '1' AS TOTAL_ATENDIDOS   FROM [SIGSALUD].[dbo].[TMP_MOR_ATN] 
	     where sexo_paciente = '2'  GROUP BY GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO 
	     SELECT * FROM [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL_F]   ORDER BY SEXO_PAC, convert(int, grupo_edad)    
	ENDTEXT
	lejecuta=SQLEXEC(gconecta,lqry_aten_f, "tfin_f") 
	SELECT tfin_f
	GO top
	SCAN
	  lc_dx  = ALLTRIM(tfin_f.DIAGNOSTICO_DEFINITIVO)
	  lc_geda = ALLTRIM(tfin_f.grupo_edad)
	  TEXT TO lqry_ver_t2 noshow
	  	  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
	  	  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
	  	  declare @ldiax varchar(4) = ?lc_dx
	  	  DECLARE @lt_tmp_at_ged table (SEX VARCHAR(1), grupo_edad varchar(2))
	  	   insert @lt_tmp_at_ged
	  	   SELECT '2' AS SEX, CASE WHEN EDAD < 1 THEN '1' WHEN EDAD BETWEEN 1 AND 4 THEN '2' WHEN EDAD BETWEEN 5 AND 9 THEN '3' WHEN EDAD BETWEEN 10 AND 14 THEN '4' WHEN EDAD BETWEEN 15 AND 19 THEN '5' 
	  	        WHEN EDAD BETWEEN 20 AND 24 THEN '6' WHEN EDAD BETWEEN 25 AND 29 THEN '7' WHEN EDAD BETWEEN 30 AND 34 THEN '8' WHEN EDAD BETWEEN 35 AND 39 THEN '9' WHEN EDAD BETWEEN 40 AND 44 THEN '10'
	  	               WHEN EDAD BETWEEN 45 AND 49 THEN '11' WHEN EDAD BETWEEN 50 AND 54 THEN '12' WHEN EDAD BETWEEN 55 AND 59 THEN '13' WHEN EDAD BETWEEN 60 AND 64 THEN '14' WHEN EDAD >=65  THEN '15'
	  	                         ELSE  'ND' END FROM ATENCIONC WHERE sexo = 'F' and  FECHA between @lcfecha1 and @lcfecha2 AND ID_CITA IN (
	  	                        select ID_CITA from ATENCIOND where DX = ?lc_dx and TIPODX = 'D' AND ID_CITA IN (SELECT ID_CITA FROM ATENCIONC WHERE FECHA between @lcfecha1 and @lcfecha2))
	  	                        SELECT grupo_edad, COUNT(GRUPO_EDAD) AS ATN FROM @lt_tmp_at_ged GROUP BY GRUPO_EDAD
	  ENDTEXT
      lejecuta=SQLEXEC(gconecta,lqry_ver_t2, "tfin_m2_f") 
      SELECT tfin_m2_f
      GO top
       SCAN
        lc_gredad = ALLTRIM(tfin_m2_f.grupo_edad)
        ln_atn = tfin_m2_f.atn
        TEXT TO lqry_agregar_atn_f noshow
          UPDATE [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL_F] SET total_atendidos = ?ln_atn WHERE grupo_edad = ?lc_gredad and diagnostico_definitivo = ?lc_dx 
        ENDTEXT
        lejecuta=SQLEXEC(gconecta,lqry_agregar_atn_f) 
      ENDSCAN
      
   ENDSCAN
      

	TEXT TO lqry_uni NOSHOW
  declare @lcfecha1 datetime = convert(datetime, ?lc_fecha1, 101)
  declare @lcfecha2 datetime = convert(datetime, ?lc_fecha2, 101)
  declare @lcanio_mes varchar(6) = (select substring(convert(varchar(10), @lcfecha1, 103),7,4)) + (select substring(convert(varchar(10), @lcfecha1, 103),4,2))
  declare @lccodigo_ipress varchar(8) = '00005947'
  SELECT @lcanio_mes as PERIODO, @lccodigo_ipress as IPRESS, @lccodigo_ipress as UGIPRESS, SEXO_PAC as SEXO_PACIENTE, GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO, TOTAL_ATENDIDOS FROM [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL] 
  UNION ALL
  SELECT @lcanio_mes as PERIODO, @lccodigo_ipress as IPRESS, @lccodigo_ipress as UGIPRESS, SEXO_PAC as SEXO_PACIENTE, GRUPO_EDAD, DIAGNOSTICO_DEFINITIVO, TOTAL_ATENDIDOS FROM [SIGSALUD].[dbo].[TMP_MOR_ATN_TOTAL_F] 
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_uni, "tunir_trama1") 
SELECT tunir_trama1     
COPY TO 'D:\trama2_consolidado_morbilidad_consulta_ambulatoria.xls' TYPE XLS




cMensage = '...FINALIZADO...' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait    
CLOSE DATABASES all






