dia = 1
mes = 5
lanio = 2017

CLEAR

  lcdiaferiado = ALLTRIM(PADL(dia,2,'00'))
  lcmesferiado = ALLTRIM(PADL(lmes,2,'00'))
  lcanioferiado = ALLTRIM(STR(lanio))
  lcfecha_feriado = lcanioferiado + '-' + lcmesferiado + '-' + lcdiaferiado
  ?lcfecha_feriado