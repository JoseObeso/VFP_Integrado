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
  
cMensage = '...INICIANDO PROCESO.............' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
?DATE()
?TIME()
SET HOURS TO 24
lcfechadia = '2018-01-30'
?lcfechadia
lcturno = 'M'
?lcturno


lcconsultorio = '1031'
lcmedico = 'SVS'
?lcmedico
* NRO DE CITAS
lnnumeroinicial=1
lnnumerofinal=16




IF lcturno = 'M'
  lchora_inicio = '08:00'
  lchora_fina = '12:30'
ELSE
  lchora_inicio = '14:00'
  lchora_fina = '18:30'
ENDIF
  
lchora_intervalo = 15
lchora_en_blanco = 1
lnbucle = lnnumerofinal - lnnumeroinicial + 1
* cero (0) hora en blanco
* Uno (1) debe ir la hora 

IF  lchora_en_blanco = 0
      lchora = ''
      agregar_citas_horas_en_blanco()
ELSE
     agregar_citas_con_horas() 
ENDIF

** Funciones definidas
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


FUNCTION agregar_citas_con_horas() 
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
         declare @lcturno char(2) = ?lcturno
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

 




  


