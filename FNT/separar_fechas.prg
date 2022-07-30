* fecha de salida
clear
tfe = '2018-01-26'

lnvarchar_10_fecha_emergencia = IIF(at('-', tfe)> 0, CTOD(tfe), '1')
?lnvarchar_10_fecha_emergencia 


*  lc_nueva_fecha_anio = 
