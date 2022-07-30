lcfechadia = '2017-07-21'
lnnumeroinicial=1
lnnumerofinal=20
lcturno = 'M'
lcconsultorio = '1021'
lcmedico = 'HCM'
lchora_inicio = '08:00'
lchora_fina = '12:00'
lchora_intervalo = 15
lchora_en_blanco = 1
lnbucle = lnnumerofinal - lnnumeroinicial + 1

clear
 FOR RT = 1 TO lnbucle
   lchoragrabar =  lchora_inicio
   lchora_inicio = substr(TTOC(CTOT(lchora_inicio) + lchora_intervalo*60),12,5)
   
   ?lchoragrabar 
   
 ENDFOR
  
  
