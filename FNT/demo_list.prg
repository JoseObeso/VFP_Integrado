PUBLIC oform1
oform1=CREATEOBJECT("form1")
oform1.Show
RETURN
DEFINE CLASS form1 AS form
    Top = 0
    Left = 0
    Height = 238
    Width = 468
    DoCreate = .T.
    Caption = "Form1"
    Name = "Form1"
   ADD OBJECT list1 AS listbox WITH ;
        RowSourceType = 9, ;
        RowSource = "P_list", ;
        Height = 181, ;
        Left = 60, ;
        Top = 24, ;
        Width = 265, ;
        Name = "List1"
    PROCEDURE Load
        PUBLIC P_list
        DEFINE POPUP P_list
        DEFINE BAR 1 OF P_LIST ;
          PROMPT "Item number 1 of the list";
          FONT "Tahoma",14 style "BI";
          COLOR , RGB(255,255,255,192,0,0)
        DEFINE BAR 2 OF P_LIST ;
          PROMPT "Item number 2 of the list";
          FONT "Tahoma",11 style "B"
        DEFINE BAR 3 OF P_LIST ;
          PROMPT "Item number 3 of the list";
          FONT "Arial",9 style "B";
           COLOR , RGB(255,255,255,192,255,0)
    ENDPROC
ENDDEFINE