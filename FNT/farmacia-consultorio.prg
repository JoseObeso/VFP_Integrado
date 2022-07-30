THISFORM.COMMAND6.ENABLED=.F.
lfecha =  ALLTRIM(thisform.text6.Value)
litem =  lcitem
lalmacen = 'F'
* agregar el datos que figura en stock, no en saldo
lsaldoinicial = thisform.text8.Value


cMensage = ' INICIANDO PROCESO PARA : ' + litem 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

TEXT TO laddkardex noshow
    Alter Table KARDEX add idkardex integer identity 
ENDTEXT
* lejecutagrabar = sqlexec(gconecta,laddkardex)

TEXT TO lultimo3 noshow
  declare @litem varchar(10) = ?litem
  declare @lalmacen varchar(1) = ?lalmacen
  declare @lsaldoinicial int = ?lsaldoinicial 
  update stock set STOCK = @lsaldoinicial where ITEM = @litem AND ALMACEN = @lalmacen
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lultimo3)

TEXT TO lbusca noshow
  declare @lfecha datetime = convert(datetime, ?lfecha,101)
  declare @litem varchar(10) = ?litem
  declare @lalmacen varchar(1) = ?lalmacen
  select * from KARDEX where  ITEM = @litem and fecha >= @lfecha AND ALMACEN = @lalmacen order by FECHA asc
ENDTEXT
lejecutagrabar = sqlexec(gconecta,lbusca, "tkar")
cMensage = ' AHORA EXAMINAMOS KARDEX PARA : ' + litem 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

SELECT tkar
GO top
SCAN
   lidkar = tkar.operacion
   lstock = tkar.stock
   lncantidad = tkar.cantidad
   lnsaldo = tkar.saldo
   ltipotra= ALLTRIM(tkar.tipo_transaccion)
   lfecha = tkar.fecha
   TEXT TO lbuscastockx noshow
     declare @litem varchar(10) = ?litem
     declare @lalmacen varchar(1) = ?lalmacen
     select STOCK from stock where ITEM = @litem AND ALMACEN = @lalmacen  
   ENDTEXT
   lejecutagrabar = sqlexec(gconecta,lbuscastockx, "tst")
   lnstock = tst.stock
   IF ALLTRIM(ltipotra) = 'IAN' OR ALLTRIM(ltipotra) = 'ITR' OR ALLTRIM(ltipotra) = 'IDE' OR ALLTRIM(ltipotra) = 'IC1' OR ALLTRIM(ltipotra) = 'IC2' OR ALLTRIM(ltipotra) = 'IC3' OR ALLTRIM(ltipotra) = 'ICJ'  OR ALLTRIM(ltipotra) = 'ICO' OR ALLTRIM(ltipotra) = 'IDO' OR ALLTRIM(ltipotra) = 'IIN' OR ALLTRIM(ltipotra) = 'IPP' OR ALLTRIM(ltipotra) = 'IPR' OR ALLTRIM(ltipotra) = 'ITP'
       lnnsaldo =   lnstock  + lncantidad
   ELSE
       lnnsaldo =   lnstock  - lncantidad
   ENDIF
 TEXT TO lactualiza noshow
   UPDATE KARDEX SET stock = ?lnstock, saldo = ?lnnsaldo WHERE operacion = ?lidkar
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lactualiza)
 
 TEXT TO lultimo5 noshow
  declare @litem varchar(10) = ?litem
  declare @lalmacen varchar(1) = ?lalmacen
  declare @lnnsaldox int = ?lnnsaldo
  update stock set STOCK = @lnnsaldox where ITEM = @litem AND ALMACEN = @lalmacen  
 ENDTEXT
 lejecutagrabar = sqlexec(gconecta,lultimo5)
 cMensage = ' PROCESANDO ITEM : ' + litem  + ' FECHA : '  + DTOC(lfecha)  + ' TIPO DE TRANSACCION : ' + ltipotra
 _Screen.Scalemode = 0
 Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait
ENDSCAN

TEXT TO lelimidkardex noshow
   Alter Table kardex  Drop Column idkardex 
ENDTEXT
* lejecutagrabar = sqlexec(gconecta,lelimidkardex)


thisform.ver_stock()
 TEXT TO lbuscar noshow
     select REPLACE(CONVERT(varchar(10), FECHA, 102),'.', '-') AS FECHA1, ALMACEN, FECHA, TIPO_TRANSACCION, IDTRANSACCION, STOCK, CANTIDAD, SALDO, OPERACION from KARDEX where ITEM = ?lcitem  AND ALMACEN = 'F' order by FECHA desc
  ENDTEXT
 lejecuta=SQLEXEC(gconecta,lbuscar,"tbusca") 
 SELECT tbusca
 WITH thisform.list1
     .ColumnCount = 8
     .BoundColumn = 1 
     .ColumnWidths="50, 150, 50, 80, 80, 90,90,90"
     .rowsource="tbusca.almacen, fecha, tipo_transaccion, IDTRANSACCION, STOCK, CANTIDAD, SALDO, OPERACION"
     .rowsourcetype= 2
 ENDWITH
   
   

cMensage = ' SE TERMINO PROCESO PARA : ' + litem 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait

wait window 'FIN...' NOWAIT
