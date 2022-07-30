
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



lcfecha_inicio = '2017-09-01'
lcfecha_final = '2017-09-30'
lcipress = '00005947'
lcmes = '09' 
lcanio = '2017'
lcnombre_archivotxt = 'D:\' + lcipress + '_' + lcmes + '_' + lcanio + '_' + 'TAC2.TXT'

TEXT TO lqry_uni NOSHOW
	  declare @lcfecha1 datetime = convert(datetime, ?lcfecha_inicio, 101)
	  declare @lcfecha2 datetime = convert(datetime, ?lcfecha_final, 101)
	  declare @lcanio_mes varchar(6) = (select substring(convert(varchar(10), @lcfecha1, 103),7,4)) + (select substring(convert(varchar(10), @lcfecha1, 103),4,2))
	  declare @lccodigo_ipress varchar(8) = ?lcipress
	  SELECT @lcanio_mes as PERIODO, @lccodigo_ipress as IPRESS, @lccodigo_ipress as UGIPRESS, SEXO as SEXO_PACIENTE, GRUPO_EDAD, 
	  case when len(diagnostico_emergencia) = 3 then rtrim(DIAGNOSTICO_EMERGENCIA) + '.X' else DIAGNOSTICO_EMERGENCIA
	  end AS DIAGNOSTICO_EMERGENCIA, TOTAL_ATENDIDOS FROM [SIGSALUD].[dbo].[TMP_TRAMA_PRE_C2]
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_uni, "tunir_trama1_c2") 
SELECT tunir_trama1_c2
 COPY TO &lcnombre_archivo  TYPE XLS
 GO top
 Set alternate to &lcnombre_archivotxt
 set alternate on 
 SCAN
??ALLTRIM(tunir_trama1_c2.periodo)+"|"+ALLTRIM(tunir_trama1_c2.ipress)+"|"+ALLTRIM(tunir_trama1_c2.ugipress)+"|"+ALLTRIM(tunir_trama1_c2.sexo_paciente)+"|"+ALLTRIM(tunir_trama1_c2.grupo_edad)+"|"+ALLTRIM(tunir_trama1_c2.DIAGNOSTICO_EMERGENCIA)+"|"+ALLTRIM(STR(tunir_trama1_c2.total_atendidos))
?
 ENDSCAN
 set alternate off 
  
  
  
  
  	  
