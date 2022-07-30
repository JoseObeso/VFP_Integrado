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

cMensage = '...INICIANDO SUBIDA DE MARCAS RELOG DIA 08/02 EN LA TARDE...' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

 
TEXT TO lqry_marcas_relog  noshow
   select codigo, convert(datetime, convert(date, fecha), 101) as fecha,  convert(nvarchar(8), fecha, 108) as  hora, '1' as relog
    from [BDPERSONAL].[dbo].[ASISTENCIA08022018]  where fecha >  CONVERT(datetime, '2018-02-02', 101) + CAST('15:35:42' AS DATETIME)
 ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_marcas_relog,"trelog")
SELECT trelog
GO top
SCAN
   lccodigo = trelog.codigo
   lcfecha = trelog.fecha
   lchora = trelog.hora
   TEXT TO lqry_registrar_en_relog noshow
      declare @lid_relog int = (select MAX(idrelog) + 1 from [BDPERSONAL].[dbo].[RELOGDIGI] )
      declare @codigo int = ?lccodigo
      DECLARE @ldfecha datetime = ?lcfecha
      DECLARE @lnhora  varchar(8) = ?lchora
      INSERT INTO [BDPERSONAL].[dbo].[RELOGDIGI]([IdRelog],[Codigo],[Fecha],[Hora],[Relog])
         VALUES (@lid_relog, @codigo, @ldfecha, @lnhora, '1')
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lqry_registrar_en_relog)
   cMensage = '...ACTUALIZANDO PARA : ' +STR(lccodigo)
   _Screen.Scalemode = 0
   Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN
cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

