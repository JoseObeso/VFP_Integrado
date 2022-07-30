
fecha = '22/12/2017'
lcfecha = ALLTRIM(fecha)
lndiafecha = VAL(SUBSTR(lcfecha,1,2))
lnmesfecha = VAL(SUBSTR(lcfecha,4,2))
lnaniofecha = VAL(SUBSTR(lcfecha,7,4))


?lndiafecha
?lnmesfecha
?lnaniofecha



