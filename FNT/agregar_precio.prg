PUBLIC gconecta

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
  


TEXT TO lver noshow
  SELECT [CODIGO_MED], [NOM_MEDICAM], [STOCK], [COSTO]  FROM [SIGSALUD].[dbo].[STOCK_AGREGAR_PRECIO]
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lver, "tver")
SELECT tver
GO top
SCAN
 lidver = ALLTRIM(tver.codigo_med)
 TEXT TO lprecio noshow
   select top 1 PRECIO from INGRESOD
    where ingresoid = (select top 1 ingresoid from INGRESOC where INGRESOID in (select ingresoid from INGRESOD  where ITEM = (select ITEM from ITEM  
    where SUBSTRING(item, 1,2) = '17' and  INTERFASE2 = ?lidver)) order by FECHA desc) 
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lprecio, "tpre")
 SELECT tpre
 lpre = tpre.precio
 TEXT TO lagregar noshow
   UPDATE [SIGSALUD].[dbo].[STOCK_AGREGAR_PRECIO]  SET COSTO = ?lpre WHERE codigo_med = ?lidver
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lagregar)
 WAIT windows "agregando....." nowait
ENDSCAN






