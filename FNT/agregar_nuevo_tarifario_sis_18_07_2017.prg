CLEAR
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

cMensage = '...INICIANDO PROCESO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lqry_obtener_item noshow
     SELECT * FROM dbo.TABLA_SIS_NUEVO
ENDTEXT
lejecutabusca = sqlexec(gconecta,lqry_obtener_item,"t_item")
SELECT t_item
GO top
SCAN
    lc_codcpt = ALLTRIM(t_item.cpt)
    lc_nombre = ALLTRIM(t_item.descripcion)
    ln_precio_sis = t_item.precio_sis
    
    TEXT TO lqry_ver_cpt noshow
       DECLARE @lccodcpt varchar(13) = ?lc_codcpt
       SELECT CODCPT, ITEM, NOMBRE, ACTIVO FROM [SIGSALUD].[dbo].[ITEM] WHERE SUBSTRING(ITEM, 1,1) = '6' AND ACTIVO = '7' and CODCPT = @lccodcpt
    ENDTEXT
    lejecutabusca = sqlexec(gconecta,lqry_ver_cpt,"t_ver_item")
    SELECT t_ver_item 
    nitem = reccount()
    IF nitem > 0 
       TEXT TO lqry_modificar noshow
         DECLARE @lccodcpt varchar(13) = ?lc_codcpt
         declare @lnpreciosis numeric(9,2) 
         declare @lcdescripcion varchar(255) 
         set @lnpreciosis = (select PRECIO_SIS from [SIGSALUD].[dbo].[TABLA_SIS_NUEVO] where CPT = @lccodcpt)
         set @lcdescripcion = (select DESCRIPCION  from [SIGSALUD].[dbo].[TABLA_SIS_NUEVO] where CPT = @lccodcpt)
         update [SIGSALUD].[dbo].[PRECIO] set PRECIOE = @lnpreciosis where ITEM in (SELECT ITEM FROM ITEM WHERE SUBSTRING(ITEM, 1,1) = '6' AND ACTIVO = '7' and CODCPT = @lccodcpt)
         Update [SIGSALUD].[dbo].[ITEM]  set NOMBRE = @lcdescripcion where ITEM in (SELECT ITEM FROM ITEM WHERE SUBSTRING(ITEM, 1,1) = '6' AND ACTIVO = '7' and CODCPT = @lccodcpt)
         update [SIGSALUD].[dbo].[TABLA_SIS_NUEVO] set tipo_grabacion = 'M' WHERE CPT = @lccodcpt
       ENDTEXT
       lejecutabusca = sqlexec(gconecta,lqry_modificar) 
       IF lejecutabusca > 0
         cMensage = '.......GRABACION CORRECTA............' + lc_codcpt
         _Screen.Scalemode = 0
         Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
       ELSE
         cMensage = '......GRABACION INCORRECTA..........' 
         _Screen.Scalemode = 0
         Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
       ENDIF
       
    ELSE
        cMensage = '...ITEM NO EXISTE ...ES NUEVO...LO INGRESAREMOS...PAGANTES / SIS...' +lc_codcpt
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        
        TEXT TO lqry_nuevo_item noshow
          DECLARE @lcnuevo_item varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '1' ORDER BY ITEM  DESC)
          declare @lcnombre_item varchar(250) = ?lc_nombre
          declare @lccodcpt varchar(13) = ?lc_codcpt
          declare @lnprecioa  numeric(18,2) =  0
          
          INSERT INTO [SIGSALUD].[dbo].[ITEM] ([ITEM],[NOMBRE],[ABREVIATURA],[GRUPO_RECAUDACION],[CLASIFICADOR],[GRUPO_LIQUIDACION],[GRUPO_TARIFARIO],[PRESENTACION], [FAMILIA],[CLASE],[GENERICO],[LABORATORIO],
            [FRACCION],[INTERFASE1], [VARIABLE],[MODULO],[ACTIVO],[SYSINSERT],[SYSUPDATE],[SYSDELETE],[INTERFASE2],[PETITORIO],[STOCK],[STOCK_MINIMO],[ITEM_EXCLUSION],
                [ESTADO_A_CUENTA],[STOCK_CRITICO],[DISPONIBILIDAD],[APLICA_DSCTO],[PRESENTA],[CONCENTRA], [NOMBRECORTO],[CODCPT],[SECCION],[SUBSECCION],[REVISION],[agregar_cpt])
                     VALUES (@lcnuevo_item, @lcnombre_item, @lcnombre_item, '26', '1.3.3.4.1.99', '26', '0', '0', '0', '0', '0', '0', 1, '', 'N', 'CAJA', '1',  convert(varchar(10), getdate(), 103), '', '', '', 0, 0, 0, '', '4', 0, '', '', '0', '0', '', @lccodcpt, '', '', '', 'A')
                     
          INSERT INTO [SIGSALUD].[dbo].[PRECIO]([ITEM],[FECHA],[PRECIOA],[PRECIOB],[PRECIOC],[PRECIOD],[PRECIOE],[PRECIOF],[PRECIOG],[PRECIOH],[PRECIOI],[PRECIOJ],[PRECIOK],[COSTO], [UTILIDAD], [PRECIOPUB],[DESCUENTO],[PRECIO],[HORA],[PRECIOX],[PROMEDIO],[SYSINSERT],[SYSUPDATE],[INGRESOID])
             VALUES (@lcnuevo_item, getdate(), @lnprecioa, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, '', 0,0, CONVERT(varchar(10), getdate(), 103), '', '')
             
           
           DECLARE @lcnuevo_item_sis varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '7' ORDER BY ITEM  DESC)
           declare @lcnombre_item_sis varchar(250) = ?lc_nombre
           declare @lccodcpt_sis varchar(13) = ?lc_codcpt
           declare @lnpreciosis  numeric(18,2) =  ?ln_precio_sis
           declare @lnpreciosoat  numeric(18,2) =  0
           
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
               update [SIGSALUD].[dbo].[TABLA_SIS_NUEVO] set tipo_grabacion = 'A' WHERE CPT = ?lc_codcpt
            ENDTEXT
            lejecuta = sqlexec(gconecta,lqry_marcar_tarifario_nuevo)  
         ELSE
            TEXT TO lqry_marcar_tarifario_nuevo_fallo noshow
               update [SIGSALUD].[dbo].[TABLA_SIS_NUEVO] set tipo_grabacion = 'F' WHERE CPT = ?lc_codcpt
            ENDTEXT
            lejecuta = sqlexec(gconecta,lqry_marcar_tarifario_nuevo_fallo)  
         ENDIF
    ENDIF
    
    
ENDSCAN


cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  


 
