
 TEXT TO lver_stock_farmacia_so NOSHOW
   declare @loperacion1 varchar(8) = '18039367'
   declare @loperacion2 varchar(8) = '18079844'
   declare @lcitemfar varchar(13) = '170132'
   select top 1 SALDO as STOCK_FARMACIA from [SIGSALUD].[dbo].[KARDEX] 
   where ITEM = @lcitemfar and ALMACEN = 'SO' and OPERACION between @loperacion1 and @loperacion2 order by operacion desc
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lver_stock_farmacia_so,"tstockfar_so") 
 SELECT tstockfar_so
 nf1_so = RECCOUNT()
 IF nf1_so = 0
   TEXT TO lver_sf2_so noshow
      declare @lcitemfar varchar(13) = '170132'
      declare @lfechainicio datetime = convert(datetime, ?lcfechainicio,101) +  CAST('00:00:00' AS DATETIME)
      select top 1 SALDO as STOCK_FARMACIA  from [SIGSALUD].[dbo].[KARDEX] where ITEM = @lcitemfar and ALMACEN = 'SO' AND FECHA < @lfechainicio order by operacion desc
   ENDTEXT
   lejecuta=SQLEXEC(gconecta,lver_sf2_so,"tsf2_so")
   SELECT tsf2_so
   nf2_so = RECCOUNT()
   IF nf2_so = 0
      litem_stock_farmacia_so = 0
   ELSE
      litem_stock_farmacia_so = tsf2_so.stock_farmacia
   ENDIF
 ELSE
   litem_stock_farmacia_so = tstockfar_so.stock_farmacia
 ENDIF
 ** Actualizar Stock Farmacia
 TEXT TO lactualiza_stock_farmacia_so noshow
     UPDATE [SIGSALUD].[dbo].[TMP_PRE_ICI] SET STOCK_SO = ?litem_stock_farmacia_so WHERE item = ?lcitem
 ENDTEXT
 lejecuta=SQLEXEC(gconecta,lactualiza_stock_farmacia_so)

*** FIN DE SO