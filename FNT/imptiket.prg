*-*************************************************************************************
*-
*-
*-Procedimiento que Imprime un Ticket, mediante programacion  
*-Por: Jcahp
*-03-abril-2009
*-Este procedimiento con algunas modificaciones se puede usar para imprimir facturas,
*-notas, etc. etc. pero too dependerá de la lógica de cada programador.
*-Espero les sea de utilidad
*-Saludos Amigos Foxeros...!!! 
*-**************************************************************************************

*-----------------------------      EMPIEZA CODIFICACION

*-Las siguientes tres líneas de codigo es para abrir la Tabla de Ejemplo 
Clos All
Use Nota In 0 Exclusive
Sele Nota


*Se establece una Variable Local que Guarda el Nombre de la Impresora, en mi caso 
* para una Epson LX-300+ (en el caso de la miniprinter, establecer el ancho de columna a 40)
*-PRUEBEN ASIGNANDO EL NOMBRE DE LA IMPRESORA QUE TENGAN INSTALADA TIENE QUE SE UNA DE
*-MATRIZ DE PUNTOS


LCRUTA_IMPRESORA = "'EPSON_TMU'"   && El NOmbre o ruta de impresion puede estar
										 && guardado en un campo y puede ser
										 && en este caso local o en Red \\servidorimp\Tk		

SET CONSOLE OFF
SET PRINTER TO NAME &LCRUTA_IMPRESORA

*Establecemos variables con datos que imprimirá el Ticket, en algunos casos se comenta en otros no
*- ya que son obvios.. :D

*Se Establece la Configuración de Márgenes y otros valores del Documento
LNMARGEN_SUP = 2 && En mi caso uso ---> Doctos.MargenSup   
*LNMARGEN_IZQ = Doctos.MargenIzq  && en el Caso de miniprinter se omite el margen izquierdo
LNMARGEN_INF = 16  &&En mi caso uso ---->Doctos.MargenInf

*-La siguiente línea determina el tipo de documento y el folio que imprime, puede ser pasado como parametro
*LCDOCUMENTO  = ALLT(DOCTOS.TIPO)+"#"+ALLT(STR(LNFOLIO))
*-Pero como ejemplo, colocaremos un tipo y folio Estatito
LCDOCUMENTO  = "TK"+"#"+ALLT(STR(523))

*los números de columnas son: 40 para impresora de Tikets
*Si se imprime el Ticke para impresoras Epson LX-300+ en mi caso uso el ticket de 114mm y el ancho es de 80
*en este caso usaremos el ancho para una miniprinter.
LN_NCOL		 = 40  &&DOCTOS.COLUMNAS

LCFECHA 	 = DTOC(DATE())


*Se inicializa el codigo de Impresion de Tiket's
??? CHR(27)+CHR(48)+CHR(27)+CHR(67)+CHR(44)
???  CHR(18)+CHR(27)+CHR(77)+CHR(15)
???  CHR(27)+CHR(77)+CHR(20)

*Código para Abrir la Caja de Dinero.
??? CHR(27)+'p'+CHR(0)+CHR(40)+CHR(250)	

*Se imprime el margenSuperior
FOR I=1 TO 	LNMARGEN_SUP
	??? CHR(10)+CHR(13)
ENDFOR
	
*--------------------------------- ENCABEZADO DEL TIKET --------------------------------------
*-Acuerdense que la Variable LN_NCOL define el ancho del Ticket
*En Este caso colocaremos Datos estaticos, pero pueden contener campos de tablas donde guarden 
*-el nombre de la empresa, direccion, etc, etc. como la linea siguiente
*??? CHR(10)+CHR(13)+PADC(ALLT(Sistema.Empresa)  ,LN_NCOL)

*-Acontinuación Datos Estaticos.
??? CHR(10)+CHR(13)+PADC('EMPRESA INVALIDA S.A DE C.V',LN_NCOL)
??? CHR(10)+CHR(13)+PADC('AV. LOS LIRIOS NO. 326-A, COL. LOS LAURELES',LN_NCOL)
??? CHR(10)+CHR(13)+PADC('SAN CRISTOBAL DE LAS CASAS, CHIAPAS',LN_NCOL)
??? CHR(10)+CHR(13)+PADC("RFC: CLKI126598GH6",LN_NCOL)
??? CHR(10)+CHR(13)+PADC("TEL: 01-555-658-98-66",LN_NCOL)
??? CHR(10)+CHR(13)+PADC("PROP: JULIO CESAR A.",LN_NCOL)
*------------------------------ FIN DEL ENCABEZADO DEL TIKET ----------------------------------
	
*Se imprime la Fecha y el Folio del Documento en la Misma Fila
??? CHR(10)+CHR(13)+ALLT(LCFECHA)+PADL("DOC:"+LCDOCUMENTO,LN_NCOL-LEN(LCFECHA))

*Se imprime el nombre del Usuario o cajero
??? CHR(10)+CHR(13)+PADC("AUGUSTO HERNANDEZ",LN_NCOL)
	

*Se imprimen los datos de la nota.
??? CHR(10)+CHR(13)+PADR("NOM : NOMBRE DEL CLIENTE",LN_NCOL)
??? CHR(10)+CHR(13)+PADR("DIR : DIRECCION Y COLONIA DEL CLIENTE",LN_NCOL)
??? CHR(10)+CHR(13)+PADR("EST : ESTADO Y CIUDAD DEL CLIENTE",LN_NCOL)		
??? CHR(10)+CHR(13)+PADR("RFC : RFCRFCRFCRFC",LN_NCOL)
	
*Se Imprime el Encabezado del Tiket, para el Detalle de Artículos. y Una línea
??? CHR(10)+CHR(13)+"CANT       ARTICULO     PRECIO   IMPORTE"
??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)
??? CHR(10)+CHR(13)  


*-------------------------- CUERPO O DETALLE DE ARTICULOS DEL TIKET --------------------------------------

* Se Inicializan las Variables auxiliares para el calculo del subtotal, iva y total,  así como
LNSUBTOTAL  = 0		&&Variable que guarda el Subtotal
LNIVA 	    = 0		&&Variable que guarda el Importe de Iva
LNNUMARTIMP = 0		&&Variable que Guarda el número de artículos que se imprimen

LNSUBTOTALD = 0

*Se inicia el Bucle o ciclo de la impresion de los Artículos mientras no sea el Fin de Archivo
SELEC NOTA
GO TOP
DO WHILE !EOF()
	*Pasamos Descripcion,Modelo,Marca,Cantidad,Unidad,precio e importe a caracter
	lcD = ALLT(NOTA.DESCRIPCIO)+' '+ALLT(NOTA.MODELO)+' '+ALLT(NOTA.MARCA)
	lcDes = Allt(Str(NOTA.CANTIDAD,6,2))+' '+NOTA.UNIDAD+' '+lcD
	lcImp = TRANS(NOTA.PRECIO,'999999.99')+' '+TRANS(NOTA.IMPORTE,'999999.99')

	*-Funcion que Determina si se imprime en una o varias líneas (está mas abajo).	
	*Para cmo  parametro:
	*    	lcDes = Cantidad+Unidad+Descripcion 
	*-		LN_NCOL =  Ancho del Ticket
	*-		lcImp = Precio + Importe  ya convertidos a Caracter y concatenados.
	ImpVarLin(lcDes,LN_NCOL,lcImp)

	*-Avanzamos al Siguiente Registro
	SELE NOTA
	SKIP
ENDDO
*--------------------------------- FIN DEL CUERPO DEL TIKET --------------------------------------

*-Calculamos el TotalSinDesc, TotalConDes, Subtotal e Iva
Wait Window 'Calculando Importes...!' NoWait
Sele Nota
Calculate Sum(Importe)All To lnNeto

	
*--------------------------------- PIE DEL TIKET --------------------------------------
*Imprimimos una línea a la derecha
??? CHR(10)+CHR(13)+PADL('----------------',LN_NCOL)  

??? CHR(10)+CHR(13)+PADL('TOTAL: '+Allt(Str(lnNeto,10,2)),LN_NCOL)

??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)

??? CHR(10)+CHR(13)+PADC('*GRACIAS POR SU PREFERENCIA*',LN_NCOL)

??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)

*--------------------------------- FIN DEL PIE DEL TIKET --------------------------------------

	
*-Se imprime el margen Inferior, está definido arriba
FOR I=1 TO LNMARGEN_INF
	??? CHR(10)+CHR(13)
ENDFOR



*Terminamos la IMpresion
CLOSE PRINT
SET CONSOLE ON
SET PRINTER TO


*NOTA: Esperemos que les sea de UTILIDAD   Saludos..  





*-Funcion que Toma la Descripcion, y el Importe y se imprime en el número de líneas
* que sea necesario, lo determina el ancho de columna del ticket
Function ImpVarLin(mcTexto,mnCol,mcImporte)
	nLen=Len(mcTexto)
	If nLen<=mnCol-20 Then
		??? chr(10)+chr(13)+mcTexto
		???         chr(13)+PadL(mcImporte,mnCol)
	Else
		lcAuxCad = ''
		*-Valores para la Cadena Inicial
		nIni = 1
		nFin = mnCol-1
		Do While !Empty(mcTexto)
			lcCadena = SubStr(mcTexto,nIni,nFin)
			*-Cadena Restante
			lcAuxCad = SubStr(mcTexto,nFin+1,nLen)
			??? chr(10)+chr(13)+lcCadena
			*Ahora mcTexto Vale la Cadena Restante.
			mcTexto = lcAuxCad
			*nLen Vale la Longitud de Cadena Restante.
			nLen=Len(mcTexto)
		EndDo
		nLen = Len(lcCadena)
		If nLen<=mnCol-20  Then
			???         chr(13)+PadL(mcImporte,mnCol-nLen)
		Else
			??? Chr(10)+chr(13)+PadL(mcImporte,mnCol)
		EndIf
	EndIf
EndFunc 



