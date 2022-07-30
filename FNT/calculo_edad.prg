CLEAR

naci = '04/01/1970'
atencion  = '23/10/2017'

ln_anio = VAL(SUBSTR(naci,7,4))
ln_mes = VAL(SUBSTR(naci,4,2))
ln_dia = VAL(SUBSTR(naci,1,2))



?Diferencia_AMD(DATE(ln_anio,ln_mes,ln_dia), CTOD(atencion))

FUNCTION Diferencia_AMD(tdIni, tdFin)
  LOCAL ldAux, lnAnio, lnMes, lnDia, lcRet
  *--- Fecha inicial siempre menor
  IF tdIni > tdFin
    ldAux = tdIni
    tdIni = tdFin
    tdFin = ldAux
  ENDIF
  lnAnio = YEAR(tdFin) - YEAR(tdIni)
  ldAux = GOMONTH(tdIni, 12 * lnAnio)
  *--- No cumplio el año aun
  IF ldAux > tdFin
    lnAnio = lnAnio - 1
  ENDIF
  lnMes = MONTH(tdFin) - MONTH(tdIni)
  IF lnMes < 0
    lnMes = lnMes + 12
  ENDIF
  lnDia = DAY(tdFin) - DAY(tdIni)
  IF lnDia < 0
    lnDia = lnDia + DiasDelMes(tdIni)
  ENDIF
  *--- Si el dia es mayor, no cumplio el mes
  IF (DAY(tdFin) < DAY(tdIni))
    IF lnMes = 0
      lnMes = 11
    ELSE
      lnMes = lnMes - 1
    ENDIF
  ENDIF
  lcRet = ALLTRIM(STR(lnAnio))+ "a" + PADL(ALLTRIM(STR(lnMes)), 2,'0')+ "m" +PADL(ALLTRIM(STR(lnDia)),2,'0')+ "d"
  RETURN lcRet
ENDFUNC 


FUNCTION DiasDelMes(tdFecha)
  LOCAL ld
  ld = GOMONTH(tdFecha,1)
  RETURN DAY(ld - DAY(ld))
ENDFUNC 