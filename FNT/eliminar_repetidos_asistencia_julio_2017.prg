PUBLIC gconecta, lmesx, lanio
clear
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
ENDIF
?lcStringCnxLocal

lnanio = 2017
lnmes = 7
lcfecha = '2017-07-01'
cMensage = " TRABAJANDO ASISTENCIA................"
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait


TEXT TO lqry_generar_duplicados NOSHOW 
 declare @fecha datetime
 declare @ndias as int 
 set @fecha = ?lcfecha
 declare @fecha_dia_uno date = DATEADD(day, -datepart(day, @fecha) +1, @fecha)
 set @ndias = (select DATEDIFF(dd, @fecha_dia_uno, DATEADD(mm, 1, @fecha_dia_uno))) 
 select CODIGO, COUNT(codigo) as cnt from [BDPERSONAL].[dbo].[ASISTENCIA]
  where MES = ?lnmes and AÑO = ?lnanio  group by CODIGO having  COUNT(codigo) > @ndias order by COUNT(codigo) desc
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lqry_generar_duplicados, "tdupli")
SELECT tdupli
nd = RECCOUNT()
IF nd > 0
 cMensage = " ... SE ENCONTRO DUPLICADOS...TRABAJANDO....."
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
 SCAN
  lccodigo = ALLTRIM(tdupli.codigo)
  TEXT TO lqry_resolver noshow
    select distinct * into asistencia_dupli from [BDPERSONAL].[dbo].[ASISTENCIA] where CODIGO = ?lccodigo and MES = ?lnmes  and AÑO = ?lnanio order by DIA asc
    delete from [BDPERSONAL].[dbo].[ASISTENCIA] where CODIGO = ?lccodigo and MES = ?lnmes  and AÑO = ?lnanio
    insert into [BDPERSONAL].[dbo].[ASISTENCIA]
    select * from asistencia_dupli
    DROP TABLE asistencia_dupli
  ENDTEXT
  lejecutagrabar = sqlexec(gconecta,lqry_resolver)
  IF lejecutagrabar > 0
   cMensage = " ... CONFORME..."  + lccodigo
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
  ELSE
     cMensage = " ... ERROR..."
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
  ENDIF
 ENDSCAN
ELSE
 cMensage = " ... NO EXISTEN DUPLICADOS EN ESTA FECHA................."
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
ENDIF

cMensage = " ... PROCESO CULMINADO...TODO...OK..."
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

