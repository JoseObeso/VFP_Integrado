CLEAR
lcturno = 'MT'
IF  AT('M', lcturno) > 0 
    cMensage = '...PROCESANDO TURNO MAÑANA... '
     _Screen.Scalemode = 0
     Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
     lcturno = 'M'
     lnnumeroinicial=1
     lchora_inicio = '08:00'
     lchora_fina = '12:30'
     ?lcturno
ENDIF

IF AT('T', lcturno) >0  THEN 
      cMensage = '...TURNO TARDE'
    _Screen.Scalemode = 0
    Wait Window cMensage At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len(cMensage)/2) nowait  
    lcturno = 'T'
    lnnumeroinicial=1
    lchora_inicio = '14:00'
    lchora_fina = '18:30'
    ?lcturno
ENDIF

