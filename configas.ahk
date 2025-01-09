FileSelectFolder, dossier, C:\My Pictures, 3, Choisissez un dossier d'images à charger automatiquement au démarrage de l'application


if(dossier="")
dossier:=0


Sysget, nombre, MonitorCount

Gui, pri:new,, Disposition
Gui, pri:Font, s15, Calibri
Gui, pri:add, Text,, Sur quel écran souhaitez vous afficher les médias ?
Gui, pri:Show

num:=1
Loop %nombre%
	{
	Sysget, coord, Monitor, %num%
	Gui, %num%:Font, s70, Calibri
	posx:= coordleft+1
	posy:=coordtop+1
	Gui, %num%: -caption
	Gui, %num%:Add, Button, x0 y0 w300 h300 gchoix, %num%
	Gui, %num%:Show, x%posx% y%posy% w300 h300
	num:=num+1
	}
return
choix:
GuiControlGet, ecran,, %A_GuiControl%
Try, FileDelete, parametres/parametres.txt
FileAppend, %dossier%`n%ecran%, parametres/parametres.txt
ExitApp
return