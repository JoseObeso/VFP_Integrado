clear
** Revsiar cuentas al detalle de liquidaciones *
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
  ENDIF
SET HOURS TO 24
cMensage = '...T R A B A J A N D O ---   TURNO MAÑANA ...........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  



1011  
1012  
1013  
1014  
1015  
1016  
1017  
1019  
1020  
1022  
1027  
1028  
1029  
1031  
1032  
1033  
2021  
2022  
2024  
2027  
2028  
3031  
4041  
4042  
4044  
4046  
4092  
5010  
5011  
5030  
5040  
5050  
5060  
5061  
5070  
5080  
5090  
6081  
6082  
6083  




TEXT TO lqry noshow
  select CONSULTORIO from CITA  where FECHA between CONVERT(datetime, '2016-12-01', 101) and  CONVERT(datetime, '2016-12-31', 101)    group by CONSULTORIO ORDER BY CONSULTORIO ASC
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry, "tconsulx")
SELECT tconsulx
GO top
scan
 lnconsulx = ALLTRIM(tconsulx.CONSULTORIO)
 ntrata()  
 SELECT tconsulx again
ENDSCAN





PROCEDURE ntrata
	** PARA LAS FECHAS DE DICIEMBRE 
	fecha_inicial = '01/12/2016'
	FOR ltime = 0 TO 30
	    lfecha = CTOD(fecha_inicial) + ltime
	    lcfechabuscar = DTOC(lfecha)
	    cMensage = '...T R A B A J A N D O ---   TURNO MAÑANA ..........., para fecha : ' +lcfechabuscar  + '..... consultorio : ' + lnconsulx 
	    _Screen.Scalemode = 0
	    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
	    
	    * para la mañana **
	    lhorainicio_parametro = '8' 
	    TEXT TO lcita noshow
	     select TOP 1 * from cita where TURNO_CONSULTA = 'M' and CONSULTORIO in () and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) order by fecha_programacion asc
	    ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita,"tcit")
	   SELECT tcit
	   GO top
	   lidcita = ALLTRIM(tcit.cita_id)
	   lhorainicio = CTOT(lhorainicio_parametro)
	   lhoragrabar = ALLTRIM(substr(ttoc(lhorainicio), 12, 5))
	   TEXT TO lgrab noshow
	      UPDATE cita SET hora = ?lhoragrabar WHERE cita_id = ?lidcita
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lgrab)  
	   
	   TEXT TO lcita2 noshow
	     select * from cita where TURNO_CONSULTA = 'M' and CONSULTORIO = ?lnconsulx and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) AND cita_id <>?lidcita  order by FECHA_PROGRAMACION  asc
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita2,"tcita2")
	   SELECT tcita2
	   GO top
	   lhoracalculo = CTOT(lhoragrabar) + 15*60
	   SCAN
	      lidcitan = ALLTRIM(tcita2.cita_id)
	      lhoragrabar =  ALLTRIM(substr(ttoc(lhoracalculo), 12, 5))
	      TEXT TO lgrab noshow
	         UPDATE cita SET hora = ?lhoragrabar WHERE cita_id = ?lidcitan
	      ENDTEXT
	      lejecutabusca = sqlexec(gconecta,lgrab)  
	     TEXT TO lobt noshow
	       SELECT hora FROM cita WHERE cita_id = ?lidcitan
	     ENDTEXT
	     lejecutabusca = sqlexec(gconecta,lobt, "thor")    
	     SELECT thor
	     nhor = thor.hora
	     lhoracalculo = CTOT(nhor) + 15*60
	   ENDSCAN
	 CLOSE DATABASES ALL
	 cMensage = '...........FIN DE PROCESO TURNO MAÑANA.........., para fecha : ' +lcfechabuscar  + '.... consultorio : ' +lnconsulx 
	    _Screen.Scalemode = 0
	    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


	cMensage = '...T R A B A J A N D O ---   TURNO TARDE.........' +lcfechabuscar   + 'consultorio : ' +lnconsulx 
	_Screen.Scalemode = 0
	Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


	** para la TARDE **
	lhorainicio_parametrot = '14' 

	   TEXT TO lcita noshow
	     select TOP 1 * from cita where TURNO_CONSULTA = 'T' and CONSULTORIO = ?lnconsulx and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) order by fecha_programacion asc
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita,"tcit")
	   SELECT tcit
	   GO top
	   lidcita = ALLTRIM(tcit.cita_id)
	   lhorainicio = CTOT(lhorainicio_parametrot)
	   lhoragrabar = ALLTRIM(substr(ttoc(lhorainicio), 12, 5))
	   TEXT TO lgrab noshow
	      UPDATE cita SET hora = ?lhoragrabar WHERE cita_id = ?lidcita
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lgrab)  
	   
	   TEXT TO lcita2 noshow
	     select * from cita where TURNO_CONSULTA = 'T' and CONSULTORIO = ?lnconsulx and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) AND cita_id <>?lidcita  order by FECHA_PROGRAMACION  asc
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita2,"tcita2")
	   SELECT tcita2
	   GO top
	   lhoracalculo = CTOT(lhoragrabar) + 15*60
	   SCAN
	      lidcitan = ALLTRIM(tcita2.cita_id)
	      lhoragrabar =  ALLTRIM(substr(ttoc(lhoracalculo), 12, 5))
	      TEXT TO lgrab noshow
	         UPDATE cita SET hora = ?lhoragrabar WHERE cita_id = ?lidcitan
	      ENDTEXT
	      lejecutabusca = sqlexec(gconecta,lgrab)  
	     TEXT TO lobt noshow
	       SELECT hora FROM cita WHERE cita_id = ?lidcitan
	     ENDTEXT
	     lejecutabusca = sqlexec(gconecta,lobt, "thor")    
	     SELECT thor
	     nhor = thor.hora
	     lhoracalculo = CTOT(nhor) + 15*60
	   ENDSCAN
	 
	cMensage = '...........FIN DE PROCESO TURNO TARDE......para fecha :....' +lcfechabuscar  + '   .. consultorio : ' +lnconsulx 
	_Screen.Scalemode = 0
	Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ENDFOR


ENDPROC



cMensage = '........TODO TERMINADO...'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


