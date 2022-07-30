** permite agregar nuevos items en caso no existiera y modificar precio item sis *
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
      Sqlsetprop(0,"DispLogin" , 3 ) 
       * Asignacion de Variables con sus datos 
      gconecta=SQLSTRINGCONNECT(lcStringCnxLocal)
  ENDIF
?lcStringCnxLocal
cMensage = '...BUSCANDO.......' 
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

TEXT TO lvercpt noshow
  SELECT [nro], [cpt],[nombre],[sis], operacion, RTRIM(LTRIM(CONVERT(VARCHAR(20), CPT))) AS CODCPT  FROM [SIGSALUD].[dbo].[NTARIFA_JUNIO23] order by cpt desc   
ENDTEXT
lejecutabusca = sqlexec(gconecta,lvercpt,"tcpt")
SELECT tcpt
GO top
SCAN
  lccodcpt = ALLTRIM(tcpt.codcpt)
  lncpt = tcpt.cpt
  lcnombre = ALLTRIM(tcpt.nombre)
  lnprecio = tcpt.sis
  ** ver si existe
  TEXT TO lqry_existe_item noshow
     use sigsalud
     declare @lccodcpt varchar(13) = ?lccodcpt
     select CODCPT, * from ITEM where SUBSTRING(item,1,1) = '6' and codcpt = @lccodcpt
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lqry_existe_item,"tver_item")
  SELECT tver_item
  nexiste = RECCOUNT()
  IF nexiste = 0
        cMensage = '...ITEM NO EXISTE ...ES NUEVO...LO INGRESAREMOS...PAGANTES / SIS...' + lccodcpt 
        _Screen.Scalemode = 0
        Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
        TEXT TO lqry_nuevo_item noshow
          DECLARE @lcnuevo_item varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '1' ORDER BY ITEM  DESC)
          declare @lcnombre_item varchar(250) = ?lcnombre
          declare @lccodcpt varchar(13) = ?lccodcpt
          declare @lnprecioa  numeric(18,2) =  0
          INSERT INTO [SIGSALUD].[dbo].[ITEM] ([ITEM],[NOMBRE],[ABREVIATURA],[GRUPO_RECAUDACION],[CLASIFICADOR],[GRUPO_LIQUIDACION],[GRUPO_TARIFARIO],[PRESENTACION], [FAMILIA],[CLASE],[GENERICO],[LABORATORIO],
            [FRACCION],[INTERFASE1], [VARIABLE],[MODULO],[ACTIVO],[SYSINSERT],[SYSUPDATE],[SYSDELETE],[INTERFASE2],[PETITORIO],[STOCK],[STOCK_MINIMO],[ITEM_EXCLUSION],
                [ESTADO_A_CUENTA],[STOCK_CRITICO],[DISPONIBILIDAD],[APLICA_DSCTO],[PRESENTA],[CONCENTRA], [NOMBRECORTO],[CODCPT],[SECCION],[SUBSECCION],[REVISION],[agregar_cpt])
                     VALUES (@lcnuevo_item, @lcnombre_item, @lcnombre_item, '26', '1.3.3.4.1.99', '26', '0', '0', '0', '0', '0', '0', 1, '', 'N', 'CAJA', '1',  convert(varchar(10), getdate(), 103), '', '', '', 0, 0, 0, '', '4', 0, '', '', '0', '0', '', @lccodcpt, '', '', '', 'A')
          INSERT INTO [SIGSALUD].[dbo].[PRECIO]([ITEM],[FECHA],[PRECIOA],[PRECIOB],[PRECIOC],[PRECIOD],[PRECIOE],[PRECIOF],[PRECIOG],[PRECIOH],[PRECIOI],[PRECIOJ],[PRECIOK],[COSTO], [UTILIDAD], [PRECIOPUB],[DESCUENTO],[PRECIO],[HORA],[PRECIOX],[PROMEDIO],[SYSINSERT],[SYSUPDATE],[INGRESOID])
             VALUES (@lcnuevo_item, getdate(), @lnprecioa, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, '', 0,0, CONVERT(varchar(10), getdate(), 103), '', '')
             

           DECLARE @lcnuevo_item_sis varchar(8) = (SELECT top 1 CONVERT(int, item) + 1 as nuevo_item FROM ITEM WHERE SUBSTRING(ITEM,1,1) = '6' AND ACTIVO =  '7' ORDER BY ITEM  DESC)
           declare @lcnombre_item_sis varchar(250) = ?lcNombre
           declare @lccodcpt_sis varchar(13) = ?lccodcpt
           declare @lnpreciosis  numeric(18,2) =  ?lnprecio
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
            TEXT TO lqry_no_existe noshow
                     UPDATE [SIGSALUD].[dbo].[NTARIFA_JUNIO23]  SET operacion = 'NO' WHERE CPT = ?lncpt
            ENDTEXT
            lejecutabusca = sqlexec(gconecta,lqry_no_existe)    
         ELSE
            TEXT TO lqry_no_existe_y_fallo noshow
                     UPDATE [SIGSALUD].[dbo].[NTARIFA_JUNIO23]  SET operacion = 'NF' WHERE CPT = ?lncpt
            ENDTEXT
            lejecutabusca = sqlexec(gconecta,lqry_no_existe_y_fallo)    
         ENDIF
    
  ELSE
      TEXT TO lqry_modificar_precio_sis noshow  
         declare @lccodcpt varchar(50) = ?lccodcpt
         UPDATE PRECIO SET PRECIOE = ?lnprecio where ITEM  in (select item from ITEM where SUBSTRING(item,1,1) = '6' and ACTIVO = '7' and codcpt = @lccodcpt)
      ENDTEXT
      lejecutabusca = sqlexec(gconecta,lqry_modificar_precio_sis)    
      IF lejecutabusca > 0
         TEXT TO lqry_si_existe noshow
               UPDATE [SIGSALUD].[dbo].[NTARIFA_JUNIO23]  SET operacion = 'SI' WHERE CPT = ?lncpt
         ENDTEXT
         lejecutabusca = sqlexec(gconecta,lqry_si_existe)    
      ELSE
         TEXT TO lqry_si_existe_y_fallo noshow
               UPDATE [SIGSALUD].[dbo].[NTARIFA_JUNIO23]  SET operacion = 'SF' WHERE CPT = ?lncpt
         ENDTEXT
         lejecutabusca = sqlexec(gconecta,lqry_si_existe_y_fallo)    
      ENDIF
  ENDIF
  
  cMensage = '...PASANDO AL SIGUIENTE.......'
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

ENDSCAN
cMensage = '...FIN DE PROCESO CPT....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
