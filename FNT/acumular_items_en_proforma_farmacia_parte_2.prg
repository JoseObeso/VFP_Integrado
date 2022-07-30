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
   TEXT TO lqry_ver_proformad noshow
     SELECT *  FROM  TRANSFERENCIAD WHERE TRANSFERENCIAID = ?lc_transfer
   ENDTEXT
   lejecutabusca = sqlexec(gconecta,lqry_ver_proformad,"tproford")  
   SELECT tproford
   GO top
   SCAN
      lcitem = ALLTRIM(tproford.item)
      lncanti = tproford.cantidad
      lnprecio = tproford.precio
      TEXT TO lqry_detalle noshow
        declare @lc_item varchar(10) = ?lcitem 
        DECLARE @ln_stock_antes int = (select top 1 saldo from kardex where item = @lc_item order by OPERACION)
        DECLARE @ln_canti int = ?lncanti
        DECLARE @lc_almacen varchar(2) = 'F'
        DECLARE @lnprecio NUMERIC (8,3) = ?lnprecio
        declare @lc_operacion char(9) = (select top 1 convert(int,  OPERACION)  from [SIGSALUD].[dbo].[KARDEX] order by OPERACION desc) + 1
        DECLARE @lnstock_item NUMERIC(18,2) = (select stock from [SIGSALUD].[dbo].[STOCK] where ITEM =  @lc_item   and  almacen =@lc_almacen)
        declare @lnsaldo NUMERIC(18,2) = @lnstock_item -  @ln_canti
        INSERT INTO [SIGSALUD].[dbo].[KARDEX]([ALMACEN],[ITEM],[FECHA],[TIPO_TRANSACCION],[IDTRANSACCION],[STOCK],[CANTIDAD],[SALDO],[PRECIO],[PROMEDIO],[LABORATORIO],[MARCA],[LOTE],
                     [REGISTRO],[FECHA_VENCIMIENTO],[OPERACION])
        values (@lc_almacen, @lc_item, getdate(), 'STR', '18000163', @ln_stock_antes, @ln_canti, @ln_stock_antes - @ln_canti, @lnprecio, '0', '', '', '', '', '', @lc_operacion)
        UPDATE [SIGSALUD].[dbo].[STOCK] SET Stock= @lnsaldo WHERE Item=@lc_item And Almacen=@lc_almacen
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_detalle)  
      IF lejecutabusca > 0
        cMensage = '... FARMACIA F - CONFORME ........' 
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      ELSE
        cMensage = '...FALLA EN FARMACIA F ......'
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      ENDIF

      TEXT TO lqry_detalle_c noshow
        declare @lc_item varchar(10) = ?lcitem 
        DECLARE @ln_stock_antes int = (select top 1 saldo from kardex where item = @lc_item order by OPERACION)
        DECLARE @ln_canti int = ?lncanti
        DECLARE @lc_almacen varchar(2) = 'C'
        DECLARE @lnprecio NUMERIC (8,3) = ?lnprecio
        declare @lc_operacion char(9) = (select top 1 convert(int,  OPERACION)  from [SIGSALUD].[dbo].[KARDEX] order by OPERACION desc) + 1
        DECLARE @lnstock_item NUMERIC(18,2) = (select stock from [SIGSALUD].[dbo].[STOCK] where ITEM =  @lc_item   and  almacen =@lc_almacen)
        declare @lnsaldo NUMERIC(18,2) = @lnstock_item +  @ln_canti
        INSERT INTO [SIGSALUD].[dbo].[KARDEX]([ALMACEN],[ITEM],[FECHA],[TIPO_TRANSACCION],[IDTRANSACCION],[STOCK],[CANTIDAD],[SALDO],[PRECIO],[PROMEDIO],[LABORATORIO],[MARCA],[LOTE],
                     [REGISTRO],[FECHA_VENCIMIENTO],[OPERACION])
        values (@lc_almacen, @lc_item, getdate(), 'ITR', '18000163', @ln_stock_antes, @ln_canti, @lnsaldo, @lnprecio, '0', '', '', '', '', '', @lc_operacion)
        UPDATE [SIGSALUD].[dbo].[STOCK] SET Stock= @lnsaldo WHERE Item=@lc_item And Almacen=@lc_almacen
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_detalle_C)  
      IF lejecutabusca > 0
        cMensage = '... FARMACIA C - CONFORME ........' 
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      ELSE
        cMensage = '...FALLA EN FARMACIA C ......'
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      ENDIF
      
   ENDSCAN



cMensage = '...ORDENACION... FINALIZADA ..........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

