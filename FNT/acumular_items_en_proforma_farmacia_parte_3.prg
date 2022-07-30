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



   lc_transfer = '18000163' 
   TEXT TO lqry_ver_items noshow
      SELECT * FROM  TRANSFERENCIAD WHERE TRANSFERENCIAID = '18000163' 
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lqry_ver_items,"titems")     
   SELECT titems
   GO top
   SCAN
     lc_itemf = ALLTRIM(titems.item)
     lncanti = titems.cantidad
     TEXT TO lqry_update noshow
       DECLARE @lc_item VARCHAR(13) = ?lc_itemf
       declare @lc_transfer varchar(20) = '18000163' 
       declare @ln_stock int = ?lncanti
       update KARDEX set stock = @ln_stock, SALDO = @ln_stock - CANTIDAD  where ITEM = @lc_item and IDTRANSACCION  = @lc_transfer AND ALMACEN = 'F' 
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lqry_update)
   ENDSCAN


cMensage = '...operacion FINALIZADA ..........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

