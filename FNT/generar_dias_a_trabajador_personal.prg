PUBLIC gconecta, lmesx, lanio
CLEAR
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
  ?lcStringCnxLocal
  gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
ENDIF
  
lanio = 2017
lmes = 5
lmesx = '5'

lccodigo = '084119'
lctipo_horario = 'M1'
lchora_entrada = '08:00:00'
lchora_salida = '14:00:00'



*lccodigo = '084429' - ALEXANDRA
*lctipo_horario = 'M4'
*lchora_entrada = '08:00:00'
*lchora_salida = '15:15:00'

* CODIGO : 084119
* M1
*08:00:00
*14:00:00


cMensage = " CALCULANDO LA CANTIDAD DE DIAS DEL MES SELECCIONADO "
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

lndias = DiasDelMes(DATE(lanio,lmes,1))
lcnombre_del_pc = SYS(0)

* Limpiando el horario *
TEXT TO lqry_limpiar_asistencia noshow
      USE BDPERSONAL
	  DELETE FROM asistencia WHERE codigo = ?lccodigo AND mes = ?lmes AND a�o = ?lanio
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_limpiar_asistencia) 

FOR dia  = 1 TO lndias
    lcfechadia = ALLTRIM(STR(dia)) + '/' + ALLTRIM(STR(lmes)) + '/' + ALLTRIM(STR(lanio))
    nombre_dia = ALLTRIM(CDOW(CTOD(lcfechadia)))
    
    
    
    IF nombre_dia = 'Saturday' OR nombre_dia = 'Sunday'
       lcasignahorario = 'D'
       lchora_entrada_asigna = '00:00:00'
       lchora_salida_asigna = '00:00:00'
    ELSE
       lcasignahorario = 'M4'
       lchora_entrada_asigna = lchora_entrada
       lchora_salida_asigna = lchora_salida
    ENDIF
    
     ** verifica si es feriado **
       lcdiaferiado = ALLTRIM(PADL(dia,2,'00'))
       lcmesferiado = ALLTRIM(PADL(lmes,2,'00'))
       lcanioferiado = ALLTRIM(STR(lanio))
       lcfecha_feriado = lcanioferiado + '-' + lcmesferiado + '-' + lcdiaferiado
       TEXT TO lqry_ver_feriado noshow
         SELECT diafer FROM [BDPERSONAL].[dbo].[T_Feriados] where diafer = convert(datetime, ?lcfecha_feriado, 101)
       ENDTEXT
       lejecutabusca = sqlexec(gconecta,lqry_ver_feriado, "tfer") 
       SELECT tfer
       nfer = RECCOUNT()
       IF nfer > 0
          lcasignahorario = 'D'
          lchora_entrada_asigna = '00:00:00'
          lchora_salida_asigna = '00:00:00'
          ?'SE ENCONTRO UN FERIADO ' +lcfecha_feriado
       ENDIF
   
    TEXT TO lqry_graba_asistencia noshow
	         INSERT INTO [BDPERSONAL].[dbo].[ASISTENCIA]([CODIGO],[CODACT],[DIA],[MES],[A�O],[TIPO],[HORAI],[HORAS],[HORA_PRG],[OBSERVACION],[FALTA],[TARDANZA],[PERMISO],[INDICADOR],[SITUACION])
	          VALUES (?lccodigo, ?lcasignahorario, ?dia, ?lmes, ?lanio, 'F',convert(TIME(0), ?lchora_entrada_asigna), convert(TIME(0), ?lchora_salida_asigna), 'D',' . ', 0, 0,0,4,'')
    ENDTEXT
        lejecutabusca = sqlexec(gconecta,lqry_graba_asistencia) 
        IF lejecutabusca > 0
           ?'EN EL PC :'+lcnombre_del_pc + '  --- SE EJECUTO CORRECTAMENTE EL DIA : '+ STR(dia)
        ELSE
           ?'FALLA EL DIA : '+ STR(dia)
        ENDIF
ENDFOR

** asignacion de feriados ***


****  fin de asignacion de feriados ******





 






















*------------------------------------------------
* FUNCTION DiasDelMes(dFecha)
*------------------------------------------------
* Retorna los d�as de un mes.
*------------------------------------------------
FUNCTION DiasDelMes(dFecha)
  LOCAL ld
  ld = GOMONTH(dFecha,1)
  RETURN DAY(ld - DAY(ld))
ENDFUNC
