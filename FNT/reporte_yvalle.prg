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


TEXT TO lqry_ver_reporte noshow
    declare @lfechainicial varchar(10) = '2017-01-01'
 declare @lfechafinal varchar(10) = '2017-06-30'
 declare @lc_lista_de_grupo_de_recaudacion  table (grupo varchar(2));    insert @lc_lista_de_grupo_de_recaudacion(grupo) 
                 values('17'), ('04'), ('06'), ('02')
 SELECT  CONVERT(VARCHAR(10), a.FECHA_REGISTRO,103) AS FECHA_DE_PAGO, CONVERT(VARCHAR(5), CONVERT(TIME(7), a.FECHA_REGISTRO)) AS HORA_DE_PAGO, B.HISTORIA,  A.NOMBRE, A.CONSULTORIO AS UPS, ITEM_NOMBRE AS CONCEPTO_DE_PAGO, TOTAL AS TOTAL_BOLETA from V_Boleta_Grupo A  
      LEFT JOIN PACIENTE B ON A.PACIENTE = B.PACIENTE
        WHERE a.Fecha between convert(datetime, @lfechainicial, 101) and convert(datetime,@lfechafinal,101)
      and a.GRUPO_RECAUDACION IN (SELECT grupo FROM @lc_lista_de_grupo_de_recaudacion) ORDER BY A.FECHA_REGISTRO asc
ENDTEXT
lejecuta=SQLEXEC(gconecta,lqry_ver_reporte,"tresu") 
*SELECT tresu
*COPY to d:\reporte_excel TYPE XLS




DO FOXYPREVIEWER.APP
_Screen.oFoxyPreviewer.cLanguage = "SPANISH"
REPORT FORM reporte_yvalle.frx PREVIEW   




