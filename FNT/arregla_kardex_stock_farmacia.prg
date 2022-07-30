PUBLIC gconecta
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
  gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
ENDIF
  

cMensage = ' INICIANDO PROCESO PARA : '
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

TEXT TO laddkardex noshow
  select operacion, ITEM, stock, SALDO, FECHA    from KARDEX where IDTRANSACCION = '16000154' and ALMACEN = 'F' and TIPO_TRANSACCION <> 'IDE' 
ENDTEXT
lejecutagrabar = sqlexec(gconecta,laddkardex, "tkar")
SELECT tkar
GO top
n = 1
SCAN
    lope = tkar.operacion
    lit = ALLTRIM(tkar.item)
    lsal = tkar.stock
    TEXT TO st1 noshow
      UPDATE stock SET stock = ?lsal WHERE item = ?lit AND almacen = 'F'
    ENDTEXT 
    lejecutagrabar = sqlexec(gconecta,st1)    
    
    
    TEXT TO kardex1 noshow
     select * from KARDEX where OPERACION >= ?lope and item = ?lit 
    ENDTEXT
    lejecutagrabar = sqlexec(gconecta,kardex1, "k1")
    SELECT k1 
    GO top
    SCAN
      nopera = k1.operacion
      ltipo = k1.tipo_transaccion
      lncantidad = k1.cantidad
      lnsaldo = k1.saldo
      TEXT TO leer1 noshow
        SELECT * FROM stock WHERE item = ?lit AND almacen = 'F'
      ENDTEXT
      lejecutagrabar = sqlexec(gconecta,leer1, "ts1")        
      SELECT ts1
      lnstock  = ts1.stock
      IF ALLTRIM(ltipo) = 'IAN' OR ALLTRIM(ltipo) = 'ITR' OR ALLTRIM(ltipo) = 'IDE'
          lnnsaldo =   lnstock  + lncantidad
      ELSE
          lnnsaldo =   lnstock  - lncantidad
      ENDIF
      TEXT TO lactualiza noshow
           UPDATE KARDEX SET stock = ?lnstock, saldo = ?lnnsaldo WHERE operacion = ?nopera
      ENDTEXT
      lejecutagrabar = sqlexec(gconecta,lactualiza)
      TEXT TO lultimo5 noshow
          declare @litem varchar(10) = ?lit
          declare @lalmacen varchar(1) = 'F'
          declare @lnnsaldox int = ?lnnsaldo
          update stock set STOCK = @lnnsaldox where ITEM = @litem AND ALMACEN = 'F'
      ENDTEXT
      lejecutagrabar = sqlexec(gconecta,lultimo5)
    ENDSCAN
   
   ***** fin
     n = n + 1
     ?n
 
 ENDSCAN
 

 

cMensage = ' TODO TERMINO  ' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
 


 
    
     
