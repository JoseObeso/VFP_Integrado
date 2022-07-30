lcFile=GetFile("notas.txt")
IF !EMPTY(LCFILE)
o = CREATEOBJECT("Shell.Application")
o.ShellExecute("notepad.exe", '&lcFILE', "", "open", 1)
ENDIF