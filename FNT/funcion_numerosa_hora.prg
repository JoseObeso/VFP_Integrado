CLEAR
ln = 95
IF ln = 0
  lcresultado = ""
ELSE
  lnhora = ln/60
  ctiempo_estimado = ObtenerHora(lnhora)
  lcresultado = IIF(lnhora>24, STR(INT((lnhora/ 24))) + " DIA ", IIF(ln<60, STR(ln) + " MINUTOS", ctiempo_estimado  + " HORA"))
ENDIF
  
?lcresultado


FUNCTION ObtenerHora(tn)
  lnHora = INT(tn)
  lnMin = INT((tn - lnHora) * 60)
RETURN TRANSFORM(lnHora)+ ":" + TRANSFORM(lnMin, "@L 99")
