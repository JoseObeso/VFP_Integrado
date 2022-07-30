** programa que permite incrementar correlativamente los numeros

*!*	CLEAR
*!*	CLOSE DATABASES all
*!*	USE c:\apl\ctr\mprueba.dbf EXCLUSIVE
*!*	ZAP
*!*	PACK
*!*	CLOSE DATABASES all
*!*	USE c:\apl\ctr\mprueba.dbf EXCLUSIVE
*!*	xnro=reccount()
*!*	CLOSE DATABASES all
*!*	FOR xnro = 1 TO 7963 
*!*	        xnro=xnro 
*!*	        xcodigo=padl(allt(str(xnro)),10,"0")
*!*	        insert into c:/apl/ctr/mprueba (idprueba);
*!*	        VALUES (xcodigo)
*!*	        WAIT windows "---> Registro --> :   " + xcodigo nowait
*!*	ENDFOR
*!*	USE c:\apl\ctr\mprueba.dbf EXCLUSIVE
*!*	BROWSE
*!*	CLOSE DATABASES all

* actualiza los datos en mespacio

USE c:\apl\ctr\mespacio 
GO TOP
brow
STORE 1 TO CONTADOR
SCAN
 STORE padl(allt(str(CONTADOR)),10,"0") TO A
 REPLACE mespacio.nrespacio WITH A
 STORE CONTADOR+1 TO CONTADOR
 WAIT windows "---> Registro --> :   " + A nowait
ENDSCAN
CLOSE DATABASES all

USE c:\apl\ctr\mespacio exclu
BROWSE
CLOSE DATABASES all
