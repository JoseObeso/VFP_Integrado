clear
** Revisar las horas del turno ma�ana y tarde ******
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
cMensage = '...INICIANDO PROCESO.............' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

*!*	CONSULTORIO
**
 
  
  
*2022  
**
lcons = '2022'
lminutos_consulta = 10

	** PARA LAS FECHAS DE DICIEMBRE 
	fecha_inicial = '01/01/2017'
	FOR ltime = 0 TO 30
	    lfecha = CTOD(fecha_inicial) + ltime
	    lcfechabuscar = DTOC(lfecha)
	    cMensage = '...T R A B A J A N D O ---   TURNO MA�ANA ..........., para fecha : ' +lcfechabuscar  + '..... consultorio : ' +lcons
	    _Screen.Scalemode = 0
	    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
	    
	    * para la ma�ana **
	    lhorainicio_parametro = '8' 
	    TEXT TO lcita noshow
	     select TOP 1 * from cita where TURNO_CONSULTA = 'M' and CONSULTORIO = ?lcons and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) order by fecha_programacion asc
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
	     select * from cita where TURNO_CONSULTA = 'M' and CONSULTORIO = ?lcons and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) AND cita_id <>?lidcita  order by FECHA_PROGRAMACION  asc
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita2,"tcita2")
	   SELECT tcita2
	   GO top
	   lhoracalculo = CTOT(lhoragrabar) + lminutos_consulta*60
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
	     lhoracalculo = CTOT(nhor) + lminutos_consulta*60
	   ENDSCAN
	 CLOSE DATABASES ALL
	 cMensage = '...........FIN DE PROCESO TURNO MA�ANA.........., para fecha : ' +lcfechabuscar  + '.... consultorio : ' +lcons
	    _Screen.Scalemode = 0
	    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


	cMensage = '...T R A B A J A N D O ---   TURNO TARDE.........' +lcfechabuscar   + 'consultorio : ' +lcons
	_Screen.Scalemode = 0
	Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


	** para la TARDE **
	lhorainicio_parametro = '14' 

	   TEXT TO lcita noshow
	     select TOP 1 * from cita where TURNO_CONSULTA = 'T' and CONSULTORIO = ?lcons and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) order by fecha_programacion asc
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
	     select * from cita where TURNO_CONSULTA = 'T' and CONSULTORIO = ?lcons and FECHA = CONVERT(datetime, ?lcfechabuscar, 103) AND cita_id <>?lidcita  order by FECHA_PROGRAMACION  asc
	   ENDTEXT
	   lejecutabusca = sqlexec(gconecta,lcita2,"tcita2")
	   SELECT tcita2
	   GO top
	   lhoracalculo = CTOT(lhoragrabar) + lminutos_consulta*60
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
	     lhoracalculo = CTOT(nhor) + lminutos_consulta*60
	   ENDSCAN
	 
	cMensage = '...........FIN DE PROCESO TURNO TARDE......para fecha :....' +lcfechabuscar  + '   .. consultorio : ' +lcons
	_Screen.Scalemode = 0
	Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
   ENDFOR


 



cMensage = '........TODO TERMINADO...'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


