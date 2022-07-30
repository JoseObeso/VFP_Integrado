*Blocks.prg
tic = createobject('frm')
tic.addobject('LOGIC','LOGIC')
for I = 1 to 64 step 1
 cmd = "cmdbk" + allt(str(i))
 tic.addobject(cmd,"cmdback")
endfor
=fillrand()
for I = 1 to 64 step 1
 cmd = "cmdtp" + allt(str(i))
 tic.addobject(cmd,"cmdtop")
endfor
tic.addobject("txt1","text1")
tic.addobject("txt2","text1")
tic.addobject("capt","capt")
tic.addobject("play1","capt1")
tic.addobject("play2","capt2")
=alignobj()
tic.autocenter = .T.
tic.show
on shutdown quit
Read Events

Define Class Frm As Form
 procedure init
  thisform.maxbutton = .F.
  thisform.minbutton = .F.
  thisform.width = 550
  thisform.height = 480
  thisform.caption = "Blocks"
 Endproc
 PROCEDURE UNLOAD
  Clear Events
 ENDPROC
Enddefine

PROCEDURE ALIGNOBJ
Private lnleft,lntop, lnrow, lncol
lnROW  = 1 
lnCOL  = 1
lnLEFT = 1
lntop = 1
For I = 1 to 64 Step 1
 AC = "tic.cmdtp"+ALLT(STR(I))
 lnLEFT = lnLEFT + 55
 &ac..left = lnLEFT
 &ac..top = lnTOP
 AC1 = "tic.cmdbk"+ALLT(STR(I))
 &ac1..left = lnLEFT
 &ac1..top = lnTOP
 lnCOL = lnCOL + 1
 IF Inlist(I,8,16,24,32,40,48,56)
  lnROW = lnROW + 1
  lnCOL = 1
  lnLEFT = 1
  lntop = lntop+ 55
 ENDIF
Endfor
lnleft = 20
lntop = lntop + 50
tic.play1.top = lntop
tic.play1.left = lnleft
tic.play2.top = lntop
tic.play2.left = lnleft + 120
lntop = lntop + 20
tic.txt1.left = lnleft
tic.txt1.top = lntop
tic.txt2.left = lnleft + 120
tic.txt2.top = lntop
tic.capt.left = lnleft + 300
tic.capt.top = lntop
Rele lnleft,lntop
Return

Define class LOGIC As Custom 
noofclick = 0
objval = ""
player1 = 0
player2 = 0
pla1 = .t.
pla2 = .f.
chkobj = ""
Enddefine
Define Class CMDtop As CommandButton
 Caption = ""
 visible = .t.
 backcolor = RGB(0,0,0)
 Forecolor = RGB(255,255,255)
 Fontsize = 25
 fontname = "Comic Sans MS"
 Visible = .t.
 width = 50
 Height = 50
 Borderstyle = 1
 PROCEDURE Click
  this.visible = .f.
  nm = substr(this.name,6)
  newnm = "tic.cmdbk" + nm + ".visible"
  newnval = "tic.cmdbk" + nm + ".value"
  newnobj = "cmdtp" + nm
  &newnm = .t.
  If tic.logic.noofclick = 0
   tic.logic.noofclick = 1
   tic.logic.objval = &newnval
   tic.logic.chkobj = newnobj
  Else
   tic.logic.noofclick = 2
   if tic.logic.objval # &newnval
    =inkey(.6,"h")
    obj_btn1 = tic.logic.chkobj
    obj_no1  = substr(obj_btn1,6)
    cmd = "tic.cmdtp" + obj_no1 + ".visible"
    &cmd = .t.
    obj_btn2 = newnobj
    obj_no2  = substr(obj_btn2,6)
    cmd = "tic.cmdtp" + obj_no2 + ".visible"
    &cmd = .t.
   Else
    if tic.logic.pla1 = .t.
     tic.logic.player1 = tic.logic.player1 + 1
     tic.txt1.value = tic.logic.player1
    Else
     tic.logic.player2 = tic.logic.player2 + 1
     tic.txt2.value = tic.logic.player2
    Endif
   Endif
   if tic.logic.pla1 = .t.
    tic.logic.pla1 = .f.
    tic.logic.pla2 = .t.
    tic.capt.caption = "Jugador 2 Turno"
   Else
    tic.logic.pla1 = .t.
    tic.logic.pla2 = .f.
    tic.capt.caption = "Jugador 1 Turno"
   Endif
   tic.logic.objval = ""
   tic.logic.noofclick = 0
  Endif
 Endproc
Enddefine

Define Class CMDback As TextBox
 Enabled = .f.
 visible = .f.
 backcolor = RGB(0,0,0)
 Forecolor = RGB(255,255,255)
 Fontsize = 25
 fontname = "Wingdings"
 Visible = .t.
 width = 50
 Height = 50
 Borderstyle = 1
Enddefine

Define Class text1 As TextBox
 Enabled = .f.
 Visible = .t.
 fontname = "Comic Sans MS"
 fontbold = .t.
Enddefine

Define Class capt As Label
 Enabled = .f.
 Visible = .t.
 fontname = "Comic Sans MS"
 caption = "Jugador 1 Turno"
Enddefine

Define Class capt1 As Label
 Enabled = .f.
 Visible = .t.
 fontname = "Comic Sans MS"
 caption = "Jugador 1"
Enddefine

Define Class capt2 As Label
 Enabled = .f.
 Visible = .t.
 fontname = "Comic Sans MS"
 caption = "Jugador 2"
Enddefine

Procedure fillrand
private m.var
For I = 90 to 121
 for j = 1 to 2
  do while .t.
   m.var = ceil(rand()*64)
   nm = "tic.cmdbk" + allt(str(m.var)) + ".value"
   if empty(&nm)
    &nm = chr(i)
    exit
   Endif
  Enddo
 endfor
Endfor
EndProc