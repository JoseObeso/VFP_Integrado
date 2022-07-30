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
      ?lcStringCnxLocal
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF

cMensage = '...BUSCANDO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

 
TEXT TO lver_cpt noshow
  select ITEM, CODCPT, case when substring(codcpt,1,2) = '00' then SUBSTRING(codcpt, 3,3)
                          when substring(codcpt,1,1) = '0' then SUBSTRING(codcpt, 2,4) 
                          else codcpt  end as nvo_codcpt, NOMBRE, CLASIFICADOR from  item where SUBSTRING(item,1,1) = '5' and codcpt is not null and codcpt <> '' order by CODCPT asc
ENDTEXT
lejecutabusca = sqlexec(gconecta,lver_cpt,"tcpt")
SELECT tcpt
SCAN
  lccpt = ALLTRIM(tcpt.nvo_codcpt)
  lcclasificador = ALLTRIM(tcpt.clasificador)
  lcnombre = ALLTRIM(substr(tcpt.nombre,1,100))
  TEXT TO lactualiza noshow
    update ITEM set CLASIFICADOR = ?lcclasificador, agregar_cpt = 'A' where SUBSTRING(item,1,1) = '6' and CODCPT = ?lccpt
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lactualiza)
  cMensage = '...ACTUALIZANDO PARA : ' +lcnombre
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
ENDSCAN
cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lfinal noshow
  update ITEM  set agregar_cpt = 'N' WHERE SUBSTRING(item,1,1) = '6' and agregar_cpt is null 
ENDTEXT
lejecutabusca = sqlexec(gconecta,lfinal)  
