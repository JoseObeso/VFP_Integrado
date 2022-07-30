CLEAR

**  Agregar cpt chavez *
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
  select * FROM dbo.CPT_AGREGAR ORDER BY sCOD_CPT ASC
ENDTEXT
lejecutabusca = sqlexec(gconecta,lver_cpt,"tcpt")
SELECT tcpt
SCAN
  lidcodcpt = ALLTRIM(tcpt.scod_cpt)
  lcdes = ALLTRIM(substr(tcpt.sdesc_cpt,1,180))
  lcsexo = ALLTRIM(tcpt.ssexo)
  lcmin_edad = tcpt.nmin_edad
  lcmin_tipo = ALLTRIM(tcpt.smin_tipo)
  lcmax_edad = tcpt.nmax_edad
  lcmax_tipo = ALLTRIM(tcpt.smax_tipo)
  lcest = ALLTRIM(tcpt.sest)
  lcclase = ALLTRIM(tcpt.sclase)
  TEXT TO lcbusca_ciex noshow
    SELECT * FROM CIEXHIS WHERE CODIGO = ?lidcodcpt
  ENDTEXT
  lejecutabusca = sqlexec(gconecta,lcbusca_ciex,"tbus")
  SELECT tbus
  lnbus = RECCOUNT() 
  IF lnbus > 0
     TEXT TO lc_agregar_marca_existe noshow
          UPDATE dbo.CPT_AGREGAR SET sagrego = 'E' WHERE sCOD_CPT = ?lidcodcpt
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lc_agregar_marca_existe)
     cMensage = '...CPT, YA EXISTE...AGREGANDO MARCA..........' 
     _Screen.Scalemode = 0
     Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
     
  ELSE
     TEXT TO lcagregar_nuevo noshow
        declare @lidcodord int = (select top 1 CODORD + 1 from CIEXHIS where CODORD <> 90000 order by CODORD desc)
        INSERT INTO [SIGSALUD].[dbo].[CIEXHIS]([CODORD],[CODIGO],[NOMBRE],[SEXO],[MIN_EDAD],[MIN_TIPO],[MAX_EDAD],[MAX_TIPO],[EST],[CLASE])
             VALUES (@lidcodord, ?lidcodcpt, ?lcdes, ?lcsexo, ?lcmin_edad, ?lcmin_tipo, ?lcmax_edad, ?lcmax_tipo, ?lcest, ?lcclase)
     ENDTEXT
     lejecutabusca = sqlexec(gconecta,lcagregar_nuevo)
     IF lejecutabusca > 0
         TEXT TO lc_agregar_marca_nuevo noshow
           UPDATE dbo.CPT_AGREGAR SET sagrego = 'A' WHERE sCOD_CPT = ?lidcodcpt
         ENDTEXT
         lejecutabusca = sqlexec(gconecta,lc_agregar_marca_nuevo)     
         ?lejecutabusca
         cMensage = '...CPT..AGREGADO....'
         _Screen.Scalemode = 0
         Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
    ELSE
         TEXT TO lc_agregar_marca_nuevo noshow
           UPDATE dbo.CPT_AGREGAR SET sagrego = 'N' WHERE sCOD_CPT = ?lidcodcpt
         ENDTEXT
         lejecutabusca = sqlexec(gconecta,lc_agregar_marca_nuevo)     
         cMensage = '...CPT..NOS EGRABO CORRECTAMENTE......'
         _Screen.Scalemode = 0
         Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
    ENDIF
         
  ENDIF
  cMensage = '...ACTUALIZANDO PARA : ' +lidcodcpt
  _Screen.Scalemode = 0
  Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
  
ENDSCAN
cMensage = '...PROCESO FINALIZADO....'
_Screen.Scalemode = 0
Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  

