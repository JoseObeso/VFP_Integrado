** GENERACION DE TARIFARIO MARZO 2017 *

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
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF

cMensage = '...BUSCANDO TABLAS.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lqry_listar_tarifario noshow
   USE SIGSALUD 
   SELECT CODCPT, NOMBRE, PRECIOA, PRECIOSIS, PRECIOSOAT, COMENTARIO  FROM dbo.TARIFARIO_ABRIL_2017
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_listar_tarifario,"ttari")
SELECT ttari
GO top
SCAN
  lcCodCPT = ALLTRIM(ttari.codcpt)
  lcNombreNuevo = ALLTRIM(substr(ttari.nombre,1,250))
  lnPrecioa = ttari.precioa
  lnPrecioSis = ttari.preciosis
  lnPrecioSoat = ttari.preciosoat
  
  * Ubicando item '
  cMensage = '...UBICANDO ITEM..........' +lcCodCPT
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
 
  TEXT TO lqry_si_existe noshow
    declare @lccodcpt varchar(13) = ?lcCodCPT
    SELECT * FROM ITEM WHERE CODCPT = @lccodcpt AND SUBSTRING(item, 1,1) = '6'
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_si_existe,"texiste")
  SELECT texiste
  lnexiste = RECCOUNT()
  IF lnexiste > 0
      cMensage = '...ENCONTRADO..........' +lcCodCPT
     _Screen.Scalemode = 0
      Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
    * PARA PAGANTE *  
     TEXT TO lqry_item_encontrado noshow
      declare @lccodcpt varchar(13) = ?lcCodCPT 
       SELECT * FROM ITEM WHERE CODCPT = @lccodcpt AND SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '1'
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lqry_item_encontrado,"texiste_pagante")  
     SELECT texiste_pagante
     lcitem_encontrado = ALLTRIM(texiste_pagante.item)
     TEXT TO lqry_cambiar_precio noshow
          UPDATE PRECIO SET PRECIOA = ?lnPrecioa, SYSUPDATE = CONVERT(VARCHAR(10), GETDATE(), 103) WHERE ITEM =  ?lcitem_encontrado
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lqry_cambiar_precio)  
     IF lejecutabusca > 0
        cMensage = '...GRABANDO MODIFICADO.........' +lcCodCPT
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        
        TEXT TO lqry_confirma_cambio noshow
          UPDATE ITEM SET  agregar_cpt = 'M', NOMBRE = ?lcNombreNuevo, ABREVIATURA = ?lcNombreNuevo,  sysupdate = CONVERT(VARCHAR(10), GETDATE(), 103)   WHERE ITEM =  ?lcitem_encontrado
        ENDTEXT
        lejecutabusca = sqlexec(gconecta,lqry_confirma_cambio)  
      ELSE
      
        cMensage = '...FALLO MODIFICACION .....' +lcCodCPT
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      
        TEXT TO lqry_confirma_cambio_fallo noshow
          UPDATE ITEM SET  agregar_cpt = 'F'  WHERE ITEM =  ?lcitem_encontrado
        ENDTEXT
        lejecutabusca = sqlexec(gconecta,lqry_confirma_cambio_fallo)  
      ENDIF
      
    * PARA SIS *  
     TEXT TO lqry_item_encontrado_sis noshow
      declare @lccodcpt varchar(13) = ?lcCodCPT 
       SELECT * FROM ITEM WHERE CODCPT = @lccodcpt AND SUBSTRING(ITEM,1,1) = '6' AND ACTIVO = '7'
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lqry_item_encontrado_sis,"texiste_sis")  
     SELECT texiste_sis
     lcitem_encontrado_sis = ALLTRIM(texiste_sis.item)
     TEXT TO lqry_cambiar_precio_sis noshow
          UPDATE PRECIO SET PRECIOE = ?lnPrecioSis, PRECIOH = ?lnPrecioSoat, SYSUPDATE = CONVERT(VARCHAR(10), GETDATE(), 103) WHERE ITEM = ?lcitem_encontrado_sis
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lqry_cambiar_precio_sis)  
     IF lejecutabusca > 0
        cMensage = '...GRABANDO MODIFICADO SIS.........' +lcCodCPT
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        
        TEXT TO lqry_confirma_cambio_sis noshow
          UPDATE ITEM SET  agregar_cpt = 'M', sysupdate = CONVERT(VARCHAR(10), GETDATE(), 103)   WHERE ITEM =  ?lcitem_encontrado_sis
        ENDTEXT
        lejecutabusca = sqlexec(gconecta,lqry_confirma_cambio_sis)  
      ELSE
        cMensage = '...FALLO MODIFICACION SIS.....' +lcCodCPT
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
      
        TEXT TO lqry_confirma_cambio_fallo_sis noshow
          UPDATE ITEM SET  agregar_cpt = 'F'  WHERE ITEM =  ?lcitem_encontrado_sis
        ENDTEXT
        lejecutabusca = sqlexec(gconecta,lqry_confirma_cambio_fallo_sis)  
      ENDIF
      
  ELSE
        cMensage = '...ITEM NO EXISTE ...ES NUEVO...LO INGRESAREMOS...PAGANTES / SIS...' +lcCodCPT
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        
        TEXT TO lqry_nuevo_item noshow
          DECLARE @lcnuevo_item varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '1' ORDER BY ITEM  DESC)
          declare @lcnombre_item varchar(250) = ?lcNombreNuevo
          declare @lccodcpt varchar(13) = ?lcCodCPT
          declare @lnprecioa  numeric(18,2) =  ?lnPrecioa
          
          INSERT INTO [SIGSALUD].[dbo].[ITEM] ([ITEM],[NOMBRE],[ABREVIATURA],[GRUPO_RECAUDACION],[CLASIFICADOR],[GRUPO_LIQUIDACION],[GRUPO_TARIFARIO],[PRESENTACION], [FAMILIA],[CLASE],[GENERICO],[LABORATORIO],
            [FRACCION],[INTERFASE1], [VARIABLE],[MODULO],[ACTIVO],[SYSINSERT],[SYSUPDATE],[SYSDELETE],[INTERFASE2],[PETITORIO],[STOCK],[STOCK_MINIMO],[ITEM_EXCLUSION],
                [ESTADO_A_CUENTA],[STOCK_CRITICO],[DISPONIBILIDAD],[APLICA_DSCTO],[PRESENTA],[CONCENTRA], [NOMBRECORTO],[CODCPT],[SECCION],[SUBSECCION],[REVISION],[agregar_cpt])
                     VALUES (@lcnuevo_item, @lcnombre_item, @lcnombre_item, '26', '1.3.3.4.1.99', '26', '0', '0', '0', '0', '0', '0', 1, '', 'N', 'CAJA', '1',  convert(varchar(10), getdate(), 103), '', '', '', 0, 0, 0, '', '4', 0, '', '', '0', '0', '', @lccodcpt, '', '', '', 'A')
                     
          INSERT INTO [SIGSALUD].[dbo].[PRECIO]([ITEM],[FECHA],[PRECIOA],[PRECIOB],[PRECIOC],[PRECIOD],[PRECIOE],[PRECIOF],[PRECIOG],[PRECIOH],[PRECIOI],[PRECIOJ],[PRECIOK],[COSTO], [UTILIDAD], [PRECIOPUB],[DESCUENTO],[PRECIO],[HORA],[PRECIOX],[PROMEDIO],[SYSINSERT],[SYSUPDATE],[INGRESOID])
             VALUES (@lcnuevo_item, getdate(), @lnprecioa, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, '', 0,0, CONVERT(varchar(10), getdate(), 103), '', '')
             
           
           DECLARE @lcnuevo_item_sis varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '7' ORDER BY ITEM  DESC)
           declare @lcnombre_item_sis varchar(250) = ?lcNombreNuevo
           declare @lccodcpt_sis varchar(13) = ?lcCodCPT
           declare @lnpreciosis  numeric(18,2) =  ?lnPrecioSis
           declare @lnpreciosoat  numeric(18,2) =  ?lnPrecioSoat
           
           INSERT INTO [SIGSALUD].[dbo].[ITEM] ([ITEM],[NOMBRE],[ABREVIATURA],[GRUPO_RECAUDACION],[CLASIFICADOR],[GRUPO_LIQUIDACION],[GRUPO_TARIFARIO],[PRESENTACION], [FAMILIA],[CLASE],[GENERICO],[LABORATORIO],
             [FRACCION],[INTERFASE1], [VARIABLE],[MODULO],[ACTIVO],[SYSINSERT],[SYSUPDATE],[SYSDELETE],[INTERFASE2],[PETITORIO],[STOCK],[STOCK_MINIMO],[ITEM_EXCLUSION],
                 [ESTADO_A_CUENTA],[STOCK_CRITICO],[DISPONIBILIDAD],[APLICA_DSCTO],[PRESENTA],[CONCENTRA], [NOMBRECORTO],[CODCPT],[SECCION],[SUBSECCION],[REVISION],[agregar_cpt])
                      VALUES (@lcnuevo_item_sis, @lcnombre_item_sis, @lcnombre_item_sis, '26', '1.3.3.4.1.99', '26', '0', '0', '0', '0', '0', '0', 1, '', 'N', 'CAJA', '7',  convert(varchar(10), getdate(), 103), '', '', '', 0, 0, 0, '', '4', 0, '', '', '0', '0', '', @lccodcpt_sis, '', '', '', 'A')
                      
           INSERT INTO [SIGSALUD].[dbo].[PRECIO]([ITEM],[FECHA],[PRECIOA],[PRECIOB],[PRECIOC],[PRECIOD],[PRECIOE],[PRECIOF],[PRECIOG],[PRECIOH],[PRECIOI],[PRECIOJ],[PRECIOK],[COSTO], [UTILIDAD],
               [PRECIOPUB],[DESCUENTO],[PRECIO],[HORA],[PRECIOX],[PROMEDIO],[SYSINSERT],[SYSUPDATE],[INGRESOID])
                 VALUES (@lcnuevo_item_sis, getdate(), 0, 0,0,0,@lnpreciosis,0,0,@lnpreciosoat,0,0,0,0,0,0,0,0, '', 0,0, CONVERT(varchar(10), getdate(), 103), '', '')
         ENDTEXT
         lejecuta_nuevo = sqlexec(gconecta,lqry_nuevo_item)  
         IF lejecuta_nuevo > 0
            TEXT TO lqry_marcar_tarifario_nuevo noshow
              UPDATE  dbo.TARIFARIO_ABRIL_2017 SET PROCESO = '1 - NUEVO REGISTRO Y GRABO OK ' WHERE CODCPT = ?lcCodCPT
            ENDTEXT
            lejecuta = sqlexec(gconecta,lqry_marcar_tarifario_nuevo)  
         ELSE
            TEXT TO lqry_marcar_tarifario_nuevo_fallo noshow
              UPDATE  dbo.TARIFARIO_ABRIL_2017 SET PROCESO = '2 - FALLO REGISTRO Y NO GRABO ' WHERE CODCPT = ?lcCodCPT
            ENDTEXT
            lejecuta = sqlexec(gconecta,lqry_marcar_tarifario_nuevo_fallo)  
         ENDIF

   ENDIF
        cMensage = '...PASEMOS AL SIGUIENTE .....' 
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        
ENDSCAN

cMensage = '...INCIANDO CALCULO....' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lqry_actualizar_pagantes noshow
  UPDATE PRECIO SET PRECIOB = PRECIOA-PRECIOA*0.3, PRECIOC = PRECIOA-PRECIOA*0.5, PRECIOD = PRECIOA-PRECIOA, PRECIOE = 0, PRECIOF = PRECIOA, PRECIOG = PRECIOA,
    PRECIOH = 0, PRECIOI = PRECIOA, PRECIOJ = PRECIOA, PRECIOK = PRECIOA WHERE item in (SELECT ITEM FROM ITEM WHERE ACTIVO = '1' AND SUBSTRING(ITEM,1,1) = '6')
ENDTEXT
lejecuta = sqlexec(gconecta,lqry_actualizar_pagantes)  


TEXT TO lqry_actualizar_items_sis noshow
  UPDATE PRECIO SET PRECIOA = 0, PRECIOB = 0, PRECIOC = 0, PRECIOD = 0, PRECIOF = 0, PRECIOG = 0, PRECIOI = 0, PRECIOJ = 0, PRECIOK = 0
     WHERE item in (SELECT ITEM FROM ITEM WHERE ACTIVO = '7' AND SUBSTRING(ITEM,1,1) = '6')
ENDTEXT
lejecuta = sqlexec(gconecta,lqry_actualizar_items_sis)  

cMensage = '...PROCESO TERMINADO FINALMENTE.........' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

