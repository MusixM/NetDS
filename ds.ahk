#Persistent
#SingleInstance, force
SetBatchLines, -1
#include, http/AHKhttp.ahk
#include http/AHKsock.ahk

try FileDelete, temp\*
try FileDelete, http\*.txt


FileAppend, 0, http/nombre.txt

try FileDelete, http/nombrecat.txt
FileAppend, 0, http/nombrecat.txt

Gui, fet:New, +Hwndft, Lecteur double ecran

Gui, add, Picture, vbraf x30 y30 h90 w-1 grafraichir, boutons/rafraichir.png
GuiControlGet, tpro, Pos, braf
Gui, add, Progress, vbarre x30 y10 w%tproW% cBlack, 0
Gui, add, Picture, x+20 y30 h90 w-1 gplus, boutons/plus.png
Gui, Font, s20, calibri
Gui, add, Button, vcrlb glancementhttp x+20 h90, Contrôle en réseau local
GuiControlGet, CRL, Pos, crlb

global posacrl := CRLX + CRLW + 20

Gui, Color, 0xFFFFFF
Gui, +resize
Gui, show, Maximize
WinGetPos,,, largfp, hautfp, Lecteur double ecran
hautfp := hautfp-150
Gui, princ1:New, +Hwndpri1 +parent%ft% -caption, Lecteur1
Gui, Color, 0xFFFFFF
Gui, Show, W%largfp% x0 y150 H%hautfp%


nbrv:=1
p:=1
cat := 0
hauteurf:=0

FileReadLine, ecranaa, parametres/parametres.txt, 2
Sysget, nombreecran, MonitorCount
if(ecranaa>nombreecran)
ecranaa:=nombreecran
Sysget, tailleecran, Monitor, %ecranaa%

global ehaut:= tailleecranbottom-tailleecrantop
global elarge:=tailleecranright-tailleecranleft
global positionx:=tailleecranleft+100
global positiony:=tailleecrantop+10

Gui, cm:New, +parent%ft% -caption, Controles
Gui, cm:Color, 0xFFFFFF
Gui, cm:Add, Picture, h90 w-1 gretirerimage x0 y0, boutons/retirerimage.png

Gui, cmv:New, +parent%ft% -caption, Controles
Gui, cmv:Color, 0xFFFFFF
Gui, cmv:Add, Picture, h90 w-1 gpause vpausecontinue x0 y0, boutons/pause.png
Gui, cmv:Add, Picture, h90 w-1 gpleinecran vipleinecran x+20 y0, boutons/pleinecran.png

gosub, rafraichir
return


rafraichir:
FileReadLine, chemin, parametres/parametres.txt, 1
if(chemin=0)
	return
ordre:=
compte:=0
Loop Files, %chemin%/*
	{
	ordre:= ordre A_LoopFileName "`n"
	compte := compte + 1
	}

FileRead, ncat, http/nombrecat.txt
if(ncat=0)
	{
	ncat:=1
	FileDelete, http/nombrecat.txt
	FileAppend, %ncat%, http/nombrecat.txt
	}
ncat:=1
Sort, ordre, N D`n
try FileDelete, http/alist%ncat%.txt
try Gui, auto:Destroy
try Gui, pre:Destroy
fc:=pri1
Gui, auto:New, -caption +parent%fc%, automatique
Gui, auto:Color, 0xFFFFFF
nbr:=0
WinGetPos,,, largfp,, Lecteur double ecran
comp:= 0
compte := 100/compte
tailletestW := 0
if(ordre="")
	{
	Try FileDelete, temp/0.txt
	hauteurf := 0
	gosub, ordrecat
	return
	}

FileAppend, Automatique`n, http/alist%ncat%.txt
Loop, parse, ordre, `n
	{
	nbr:=nbr+1
	GuiControl, fet:, barre, +%compte%
	

	comp:= tailletestW + comp + 10

	


	SplitPath, A_LoopField,,, ext
	if(ext="")
	break


	if(ext="mp4" or ext="mov" or ext="mkv" or ext="ogg")
		{
	pathImage:=chemin "\" A_LoopField

	FileAppend, %pathImage%`n, http/liste.txt
	FileAppend, %pathImage%`n, http/alist%ncat%.txt
	FileRead, nliste, http/nombre.txt
	nliste:=nliste+1
	try FileDelete, http/nombre.txt
	FileAppend, %nliste%, http/nombre.txt
	
	try FileDelete, http/num%ncat%.txt
	FileAppend, 1`n%nliste%`nAutomatique, http/num%ncat%.txt


		GuiControl, fet:, barre, +%compte%
	Gui, pre:add, Picture, x+10 h100 w-1 vpr%nbr%, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
	GuiControlGet, tailletest, pre:Pos, pr%nbr%

	comp:= tailletestW + comp + 10 + 20

	if(comp>=largfp)
		{
		Gui, add, Picture, x0 y+10 h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
		comp:= tailletestW + 10
		}
	else if(nbr=1)
	Gui, add, Picture, x0 h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
	else
	Gui, add, Picture, x%prochain% y%posfY% h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)

	Gui, add, Text, XP0 y+10 w%tailletestW% h16, %A_LoopField%

	GuiControlGet, posf, auto:Pos, av%nbrv%
	prochain := posfX + 10 + tailletestW
	cheav%nbrv%:=pathImage
	nbrv:=nbrv+1
	}
	else
		{
	Gui, pre:add, Picture, x+10 h100 w-1 vpr%nbr%, %chemin%\%A_LoopField%
	GuiControlGet, tailletest, pre:Pos, pr%nbr%


	FileAppend, %chemin%\%A_LoopField%`n, http/liste.txt
	FileAppend, %chemin%\%A_LoopField%`n, http/alist%ncat%.txt
	FileRead, nliste, http/nombre.txt
	nliste:=nliste+1
	try FileDelete, http/nombre.txt
	FileAppend, %nliste%, http/nombre.txt


	try FileDelete, http/num%ncat%.txt
	FileAppend, 1`n%nliste%`nAutomatique, http/num%ncat%.txt


	
	if(comp>=largfp)
		{
		Gui, add, Picture, x0 y+10 h100 w-1 vf%nbr% gafficher, %chemin%\%A_LoopField%
		comp:= tailletestW + 10
		}
	else if(nbr=1)
	Gui, add, Picture, x0 h100 w-1 vf%nbr% gafficher, %chemin%\%A_LoopField%
	else
	Gui, add, Picture, x%prochain% y%posfY% h100 w-1 vf%nbr% gafficher, %chemin%\%A_LoopField%

	Gui, add, Text, XP0 y+10 w%tailletestW% h16, %A_LoopField%

	GuiControlGet, posf, auto:Pos, f%nbr%
	prochain := posfX + 10 + tailletestW
	hauteurf := posfY + 126
	}
	
	}

try FileDelete, temp/0.txt
FileAppend, auto`n1`n0`n%hauteurf%, temp/0.txt
GuiControl, fet:, barre, 100
Gui, auto:show, y0 x30
GuiControl, fet:, barre, 0
FileRead, ncat, http/nombrecat.txt
gosub, ordrecat
return


plus:
Gui, nc:new,, Nom catégorie
Gui, Font, s30, calibri
Gui, Color, 0xFFFFFF
n:=cat+1
Gui, add, Edit, vnomcat, Catégorie %n%
Gui, Font, s20, calibri
Gui, add, Button, x+20 gplussuite, Valider
Gui, Show
return


plussuite:
Gui, submit

try Gui, nc:Destroy
FileSelectFile, ordre, M, C:\My Pictures,, Images ou vidéos (*.png; *.jpg; *.jpeg; *.ico; *.mp4; *.mov; *.mkv; *.ogg)
cat := cat + 1
gosub, plusfin
return

plusfin:
try Gui, %cat%:Destroy
try Gui, pre:Destroy
ph:=0
fc:=pri%p%
Gui, %cat%:New, -caption +parent%fc%, cat%cat%
Gui, %cat%:Color, 0xFFFFFF
Gui, Font, s25, calibri
Gui, add, Text, x0, %nomcat%
Gui, Font, s10, calibri
Gui, add, Picture, gsup x+20 h50 w-1 v%cat%, boutons/supprimer.png
nbr:=0
WinGetPos,,, largfp, hautfp, Lecteur
comp:= 0
compte:=0

FileRead, ncat, http/nombrecat.txt
ancat:= ncat
ncat:=ncat+1
try FileDelete, http/alist%ncat%.txt



FileDelete, http/nombrecat.txt
FileAppend, %ncat%, http/nombrecat.txt
FileReadLine, dlist, http/num%ancat%.txt, 2
FileRead, avantliste, http/liste.txt
FileRead, avantnliste, http/nombre.txt
dlist:=dlist+1

FileAppend, %nomcat%`n, http/alist%ncat%.txt
sup%cat% := "alist" ncat
Loop, parse, ordre, `n
	{
	compte := compte + 1
	}
compte := 100/compte
Loop, parse, ordre, `n
	{
	nbr:=nbr+1

	if(nbr=1)
		{
		chemin := A_LoopField
		continue
		}

	SplitPath, A_LoopField,,, ext

	if(ext="")
	break
	if(ext="mp4" or ext="mov" or ext="mkv" or ext="ogg")
		{
	pathImage:=chemin "\" A_LoopField

	FileAppend, %pathImage%`n, http/liste.txt
	FileAppend, %pathImage%`n, http/alist%ncat%.txt
	FileRead, nliste, http/nombre.txt
	nliste:=nliste+1
	try FileDelete, http/nombre.txt
	FileAppend, %nliste%, http/nombre.txt

	
	try FileDelete, http/num%ncat%.txt
	FileAppend, %dlist%`n%nliste%`n%nomcat%, http/num%ncat%.txt

		GuiControl, fet:, barre, +%compte%
	Gui, pre:add, Picture, x+10 h100 w-1 vpr%nbr%, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
	GuiControlGet, tailletest, pre:Pos, pr%nbr%

	comp:= tailletestW + comp + 10 + 20

	if(comp>=largfp)
		{
		Gui, add, Picture, x0 y+10 h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
		comp:= tailletestW + 10
		}
	else if(nbr=2)
	Gui, add, Picture, x0 h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)
	else
	Gui, add, Picture, x%prochain% y%posfY% h100 w-1 vav%nbrv% gafficherv, % "HBITMAP:" HBITMAPFromFile(pathImage, 400)

	Gui, add, Text, XP0 y+10 w%tailletestW% h16, %A_LoopField%

	GuiControlGet, posf, %cat%:Pos, av%nbrv%
	prochain := posfX + 10 + tailletestW
	hauteurfd%cat% := posfY + 126
	cheav%nbrv%:=pathImage
	nbrv:=nbrv+1
	}
	else
		{
	GuiControl, fet:, barre, +%compte%
	Gui, pre:add, Picture, x+10 h100 w-1 vpr%nbr%, %chemin%\%A_LoopField%
	GuiControlGet, tailletest, pre:Pos, pr%nbr%


	FileAppend, %chemin%\%A_LoopField%`n, http/liste.txt
	FileAppend, %chemin%\%A_LoopField%`n, http/alist%ncat%.txt
	FileRead, nliste, http/nombre.txt
	nliste:=nliste+1
	try FileDelete, http/nombre.txt
	FileAppend, %nliste%, http/nombre.txt


	try FileDelete, http/num%ncat%.txt
	FileAppend, %dlist%`n%nliste%`n%nomcat%, http/num%ncat%.txt

	comp:= tailletestW + comp + 10 + 20

	if(comp>=largfp)
		{
		Gui, add, Picture, x0 y+10 h100 w-1 va%nbr% gafficher, %chemin%\%A_LoopField%
		comp:= tailletestW + 10
		}
	else if(nbr=2)
	Gui, add, Picture, x0 h100 w-1 va%nbr% gafficher, %chemin%\%A_LoopField%
	else
	Gui, add, Picture, x%prochain% y%posfY% h100 w-1 va%nbr% gafficher, %chemin%\%A_LoopField%

	Gui, add, Text, XP0 y+10 w%tailletestW% h16, %A_LoopField%

	GuiControlGet, posf, %cat%:Pos, a%nbr%
	prochain := posfX + 10 + tailletestW
	hauteurfd%cat% := posfY + 126
	}
	}
GuiControl, fet:, barre, 100

ph:= 10 + hauteurf
hauteurf:=hauteurf+hauteurfd%cat%
if(hauteurf>=(hautfp-150))
	{
	p:=p+1
	Gui, princ%p%:New, +Hwndpri%p% +owner%ft% -caption, Lecteur%p%
	Gui, Color, 0xFFFFFF
	Gui, princ%p%:Show, W%largfp% x0 y150 H%hautfp%
	WinActivate, Lecteur%p%
	Gui, princ%p%: +parent%ft%
	num:=1
	try Gui, page:Destroy
	Gui, page:New, +parent%ft% -caption, pages
	Gui, page:Font, s18, calibri
	Gui, page:Color, 0xFFFFFF
	Loop %p%
		{
		
		Gui, page:Add, Text, x+13 gchoixpage, %num%
		num:=num+1
		}
	Gui, page:add, text, vafpa x+30, Page numéro : %p%
	Gui, page:Show, xcenter y70
	hauteurf:=0
	GuiControl, fet:, barre, 0

	FileRead, ncat, http/nombrecat.txt
	ancat:= ncat
	ncat:=ncat-1
	FileDelete, http/nombrecat.txt
	FileAppend, %ncat%, http/nombrecat.txt
	FileDelete, http/num%ancat%.txt
	FileDelete, http/liste.txt
	FileAppend, %avantliste%, http/liste.txt
	FileDelete, http/nombre.txt
	FileAppend, %avantnliste%, http/nombre.txt
	gosub, plusfin
	}
Gui, %cat%:show, y%ph% x30

try FileDelete, temp/%cat%.txt
FileAppend, %cat%`n%p%`n%ph%`n%hauteurf%, temp/%cat%.txt

GuiControl, fet:, barre, 0
return

choixpage:
GuiControlGet, pa, page:, %A_GuiControl%
Gui, princ%pa%: +parent%ft%
GuiControl, page:Text, afpa, Page numéro : %pa%
return

sup:
WinGetPos,,,, hautfp, Lecteur
GuiControlGet, ad, Name, %A_GuiControl%
Try Gui, %ad%:Destroy
try FileDelete, temp/%ad%.txt
add := sup%ad%
try FileDelete, http/%add%.txt
add := ad + 1
FileRead, nbca, http/nombrecat.txt
try FileDelete, http/nombrecat.txt
nbca := nbca - 1
FileAppend, %nbca%, http/nombrecat.txt
try FileDelete, http/num%add%.txt
gosub, ordrecat
return

ordrecat:
tour:=1
WinGetPos,,,, hautfp, Lecteur
hautfp := hautfp - 150
Loop, files, temp\*.txt
	{
	if(tour=1)
		{
		FileReadLine, catid, temp/%A_LoopFileName%, 1
		FileReadLine, catp, temp/%A_LoopFileName%, 2
		FileReadLine, catyd, temp/%A_LoopFileName%, 3
		FileReadLine, catyf, temp/%A_LoopFileName%, 4
		taille := catyf - catyd
		Gui, %catid%:Show, y0 x30
		Try, FileDelete, temp/%A_LoopFileName%
		FileAppend, %catid%`n%catp%`n%0%`n%taille%, temp/%A_LoopFileName%
		np := catp
		}
	else
		{
		FileReadLine, catid, temp/%A_LoopFileName%, 1
		FileReadLine, catp, temp/%A_LoopFileName%, 2
		FileReadLine, catyd, temp/%A_LoopFileName%, 3
		FileReadLine, catyf, temp/%A_LoopFileName%, 4
		taille := catyf - catyd
		if(taille<place)
			{
			fc := pri%np%
			Gui, %catid%:+parent%fc%
			Gui, %catid%:Show, y%acatyf% x30
			catyd := acatyf
			catyf := catyd + taille
			Try, FileDelete, temp/%A_LoopFileName%
			FileAppend, %catid%`n%np%`n%catyd%`n%catyf%, temp/%A_LoopFileName%
			}
		else
			{
			np := np + 1
			fc := pri%np%
			Gui, %catid%:+parent%fc%
			Gui, %catid%:Show, y0 x30
			catyd := 0
			catyf := catyd + taille
			Try, FileDelete, temp/%A_LoopFileName%
			FileAppend, %catid%`n%np%`n%catyd%`n%catyf%, temp/%A_LoopFileName%
			}
		}
	tour := tour + 1
	acatyd := catyd + 10
	acatyf := catyf + 10
	place := hautfp - acatyf
	hauteurf := acatyf
	p := np
	}
num:=1
	try Gui, page:Destroy
	Gui, page:New, +parent%ft% -caption, pages
	Gui, page:Font, s18, calibri
	Gui, page:Color, 0xFFFFFF
	Loop %p%
		{
		
		Gui, page:Add, Text, x+13 gchoixpage, %num%
		num:=num+1
		}
	Gui, page:add, text, vafpa x+30, Page numéro : %p%
	Gui, page:Show, xcenter y70

return

afficher:
try wmp.controls.stop
GuiControlGet, test,, %A_GuiControl%
try Gui, pre:Destroy
Try, Gui, ia:Destroy
Try, Gui, Wmp:Destroy
Try Gui, cmv:Hide
Gui, pre:New
Gui, pre:add, Picture, vimagetest w%elarge% h-1, %test%
GuiControlGet, pos, Pos, imagetest
try Gui, pre:Destroy

Gui, ia:New, +owner%ft% -caption, projection
Gui, ia:Color, Black
ilarge:=elarge-50
ihaut:=ehaut-50

if(posH>ehaut)
	{
	Gui, ia:Add, Picture, vfinal h%ihaut% w-1, %test%
	GuiControlGet, pos, Pos, final
	xpos:=(elarge-posW)/2
	ypos:=(ehaut-posH)/2
	GuiControl, Move, final, x%xpos% y%ypos%
	}
else
	{
	Gui, ia:Add, Picture, vfinal w%ilarge% h-1, %test%
	GuiControlGet, pos, Pos, final
	xpos:=(elarge-posW)/2
	ypos:=(ehaut-posH)/2
	GuiControl, Move, final, x%xpos% y%ypos%
	}

Gui, ia:Show, x%positionx% y%positiony% Maximize

Gui, cm:Show, y30 x%posacrl%

return


afficherv:
test:=
try wmp.controls.stop
GuiControlGet, test, Name, %A_GuiControl%
test:=che%test%
try Gui, pre:Destroy
Try, Gui, ia:Destroy
Try, Gui, Wmp:Destroy
Wmp:=
Gui Wmp: +LastFound -Resize -MaximizeBox +AlwaysOnTop -Sysmenu -Border -caption +hwndwmpf
Gui, Wmp:Color, Black
Gui Wmp: Add, ActiveX, vWmp, WMPLayer.OCX
Wmp.Url := test
Wmp.uimode := "none"

Gui, Wmp:show, x%positionx% y%positiony% Maximize, Wmp

Loop
	{
	if(Wmp.playstate=9)
		{
		continue
		}
	else
		break
	}

loop
	{
	if(Wmp.playstate=3)
		{
		Wmp.fullscreen := "true"
		break
		}
	else
		continue
	}


Gui, cm:Show, y30 x%posacrl%
posacm := posacrl + 100
Gui, cmv:Show, y30 x%posacm%
return


retirerimage:
try wmp.controls.stop
Try, Gui, ia:Destroy
Try, Gui, Wmp:Destroy
guicontrol,, pausecontinue, boutons\pause.PNG
Gui, cm:Hide
Gui, cmv:Hide
global bpause := "/boutons/pause.png"
return






HBITMAPFromFile(pathImage, size) {
    static IID_IShellItemImageFactory := "{bcc18b79-ba16-442f-80c4-8a59c30c463b}"
    VarSetCapacity(RIID_IShellItemImageFactory, 16)
    if DllCall("Ole32.dll\CLSIDFromString", "WStr", IID_IShellItemImageFactory, "Ptr", &RIID_IShellItemImageFactory)
        throw "GUID IShellItemImageFactory fail, last error: " A_LastError

    if DllCall("Shell32.dll\SHCreateItemFromParsingName"
        , "WStr", pathImage
        , "Ptr", 0
        , "Ptr", &RIID_IShellItemImageFactory
        , "Ptr*", IShellItemImageFactory)
        throw "SHCreateItemFromParsingName fail, last error: " A_LastError
	
    if DllCall(NumGet(NumGet(IShellItemImageFactory+0, 0, "Ptr"), 3 * A_PtrSize, "Ptr")
        , "Ptr", IShellItemImageFactory
        , "UInt64",  size
        , "UInt", 0x00000008 | 0x00000100 ; SIIGBF_THUMBNAILONLY | SIIGBF_SCALEUP
        , "Ptr*", hBitmap)
    {
        ObjRelease(IShellItemImageFactory)
        throw "IShellItemImageFactory::GetImage fail, last error: " A_LastError
    }

    ObjRelease(IShellItemImageFactory)

    return hBitmap ; caller deletes
}

DeleteObject(HGDIOBJ) {
    return DllCall("DeleteObject", "Ptr", HGDIOBJ)
}
return

lancementhttp:
Try FileDelete, http/url.txt
GuiControl, fet:, barre, 20
RunWait PowerShell.exe Get-NetAdapter -Name """*""" | clip,,hide
for x,y in strsplit(clipboard,"`r","`n")
	if InStr(y, "up") and !InStr(y, "disconnected")
		test := % trim(substr(y,1,26)," ")


IPC := % GetIPByAdaptor(test)

FileRead, nbhttp, http/nombre.txt
nbthttp:=1
try FileDelete, qr.png
try FileDelete, http/index.html
GuiControl, fet:, barre, 40
FileAppend,
(
<!DOCTYPE html>
  <html>
    <head>
  
      <title>Lecteur Double écran</title>
      <meta http-equiv="Content-Type" content="text/html; charset=ANSI">
    </head>
<style>
.cat{
display: block;
margin-top: 30px;
font-size: 55px;
font-family: calibri;
}

.cati{
display: inline-block;
margin-top: 30px;
font-size: 55px;
font-family: calibri;
}

.flo{
position: fixed;
left: 2`%;
bottom: 1`%;
background: white;
}
</style>
    <body style='margin-bottom: 60`%;'>
), http/index.html
FileRead, nbcathttp, http/nombrecat.txt

x := 1
try FileDelete, http/liste.txt
Loop, files, http\alist*.txt
	{
	FileReadLine, nomcat, http/%A_LoopFileName%, 1
	Fileread, contenu, http/%A_LoopFileName%


	FileAppend, 
	(
	`n<p class='cat'>%nomcat%</p>
	), http/index.html

tour := 1
	Loop, parse, contenu, `n
		{
		if(tour=1)
			{
			tour := 2
			continue
			}
		
		if(A_LoopField="")
			continue

		FileAppend, 
		(
		`n<img height='150' src='http://%IPC%:8000/images/%x%' onclick='fetch("http://%IPC%:8000/%x%", {method: "GET"});'/>
		), http/index.html
		FileAppend, %A_LoopField%`n, http/liste.txt

		x := x + 1
		}
	}


FileAppend,
(
`n<div class='flo'><img class='cati' height='200' src='http://%IPC%:8000/imre' onclick='fetch("http://%IPC%:8000/re", {method: "GET"});'>
<img class='cati' height='200' src='http://%IPC%:8000/impa' onclick='fetch("http://%IPC%:8000/pa", {method: "GET"});'>
<img class='cati' height='200' src='http://%IPC%:8000/impe' onclick='fetch("http://%IPC%:8000/pe", {method: "GET"});'>
</div></body>
    </html>
), http/index.html

GuiControl, fet:, barre, 45

paths := {}
Loop %nbhttp%
	{
	paths["/"nbthttp] := Func("image")
	paths["/images/"nbthttp] := Func("urlimage")
	nbthttp := nbthttp + 1
	}
paths["/imre"] := Func("urlretirer")
paths["/re"] := Func("Retirer")
paths["/pa"] := Func("Pause")
paths["/impa"] := Func("urlpause")
paths["/pe"] := Func("Plein")
paths["/impe"] := Func("urlplein")
paths["/"] := Func("Base")
server := new HttpServer()
server.LoadMimes(A_ScriptDir . "/mime.types")
server.SetPaths(paths)
server.Serve(8000)

global bpause := "/boutons/pause.png"

URLIP := "http://" IPC ":8000/"
FileAppend, %URLIP%, http/url.txt
sleep, 50
GuiControl, fet:, barre, 60
Run, qrcode.exe
GuiControl, fet:, barre, 70
Loop
	{
	if FileExist("qr.png")
	Break
	}
Gui, qrcode:New, +owner%ft%
Gui, qrcode:Color, 0xFFFFFF
Gui, qrcode:Font, s22, calibri
Gui, qrcode:Add, Text, w300 x8, Scannez le qr code ou recopiez l'url dans votre navigateur pour le controle à distance
GuiControl, fet:, barre, 100
Gui, qrcode:Add, Picture, w300 h300 x0, qr.png
Gui, qrcode:Add, Text, x8, %URLIP%
Gui, qrcode:Show
GuiControl, fet:, barre, 0
return

GetIPByAdaptor(adaptorName) {
    objWMIService := ComObjGet("winmgmts:{impersonationLevel = impersonate}!\\.\root\cimv2")
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID = '" adaptorName "'")._NewEnum, colItems[objItem]
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" objItem.InterfaceIndex "'")._NewEnum, colItems[objItem]
    Return objItem.IPAddress[0]
}

Base(ByRef req, ByRef res, ByRef server) {
   server.ServeFile(res, A_ScriptDir . "/http/index.html")
   res.status := 200
   try Gui, qrcode:Destroy
}

Retirer(ByRef req, ByRef res, ByRef server) {
    testhttp := req.path
    gosub, retirerimage
    server.ServeFile(res, A_ScriptDir . "/http/index.html")
    res.status := 200

}

Plein(ByRef req, ByRef res, ByRef server) {
    gosub, pleinecran
    server.ServeFile(res, A_ScriptDir . "/http/index.html")
    res.status := 200
}

urlplein(ByRef req, ByRef res, ByRef server) {
   server.ServeFile(res, A_ScriptDir . "/boutons/pleinecran.png")
   res.status := 200
}

Pause(ByRef req, ByRef res, ByRef server) {
    testhttp := req.path
    gosub, pause
    server.ServeFile(res, A_ScriptDir . "/http/index.html")
    res.status := 200

}

urlpause(ByRef req, ByRef res, ByRef server) {
   server.ServeFile(res, A_ScriptDir . bpause)
   res.status := 200
}

urlretirer(ByRef req, ByRef res, ByRef server) {
   server.ServeFile(res, A_ScriptDir . "/boutons/retirerimage.png")
   res.status := 200
}

urlimage(ByRef req, ByRef res, ByRef server) {
	im := req.path
	im:= StrReplace(im, "/images/", "")
	FileReadLine, che, http/liste.txt, %im%
	SplitPath, che,,, ext
	if(ext="mp4" or ext="mov" or ext="mkv" or ext="ogg")
		{
		GDIP("Startup")
		SavePicture(HBITMAPFromFile(che, 400), A_ScriptDir . "\tempimages\" im ".png")
		GDIP("Shutdown")
		che := A_ScriptDir . "\tempimages\" im ".png"
		}
	server.ServeFile(res, che)
	res.status := 200
}

image(ByRef req, ByRef res, ByRef server) {
    testhttp := req.path
    Suite(testhttp)
   server.ServeFile(res, A_ScriptDir . "/http/index.html")
   res.status := 200
}


Suite(testhttp) {
try Gui, tes:Destroy
test:= StrReplace(testhttp, "/", "")
FileReadLine, che, http/liste.txt, %test%
SplitPath, che,,, ext
if(ext="mp4" or ext="mov" or ext="mkv" or ext="ogg")
	{
	global Wmp:=
	try wmp.controls.stop
	test:=che
	try Gui, pre:Destroy
	Try, Gui, ia:Destroy
	Try, Gui, Wmp:Destroy
	Wmp:=
	Gui Wmp: +LastFound -Resize -MaximizeBox +AlwaysOnTop -Sysmenu -Border -caption +hwndwmpf
	Gui, Wmp:Color, Black
	Gui Wmp: Add, ActiveX, vWmp x0 y0 w%elarge% h%ehaut%, WMPLayer.OCX
	Wmp.Url := test
	Wmp.uimode := "none"
	Gui, Wmp:show, x%positionx% y%positiony% Maximize, Wmp
	loop
		{
		if(Wmp.playstate!=9)
			{
			continue
			}
		else
			{
			Break
			}
		}
	
		
	

	Gui, cm:Show, y30 x%posacrl%
	posacm := posacrl + 100
	Gui, cmv:Show, y30 x%posacm%
	}





else
	{
	test:=che
	static imagetest:=
	static final:=
	try wmp.controls.stop
	try Gui, pre:Destroy
	Try, Gui, ia:Destroy
	Try, Gui, Wmp:Destroy
	Try Gui, cmv:Hide
	Gui, pre:New
	Gui, pre:add, Picture, vimagetest w%elarge% h-1, %test%
	GuiControlGet, pos, Pos, imagetest
	try Gui, pre:Destroy
	
	Gui, ia:New, +owner%ft% -caption, projection
	Gui, ia:Color, Black
	ilarge:=elarge-50
	ihaut:=ehaut-50
	
	if(posH>ehaut)
		{
		Gui, ia:Add, Picture, vfinal h%ihaut% w-1, %test%
		GuiControlGet, pos, Pos, final
		xpos:=(elarge-posW)/2
		ypos:=(ehaut-posH)/2
		GuiControl, Move, final, x%xpos% y%ypos%
		}
	else
		{
		Gui, ia:Add, Picture, vfinal w%ilarge% h-1, %test%
		GuiControlGet, pos, Pos, final
		xpos:=(elarge-posW)/2
		ypos:=(ehaut-posH)/2
		GuiControl, Move, final, x%xpos% y%ypos%
		}
	
	Gui, ia:Show, x%positionx% y%positiony% Maximize
	
	Gui, cm:Show, y30 x%posacrl%
	
	}


}
return

F1::Reload

qrcodeGuiClose:
try Gui, qrcode:Destroy
return

fetGuiClose:
Try FileDelete, tempimages\*.png
Try FileDelete, http\*.txt
Try FileDelete, temp\*.txt
Try FileDelete, http\*.html
Try FileDelete, qr.png
ExitApp
return

#ifwinexist Wmp
pleinecran:
try Wmp.fullscreen := "true"
return

#ifwinexist Wmp
pause:
if(wmp.playstate=3)
{
wmp.controls.pause
wmpl.controls.pause
guicontrol,cmv:, pausecontinue, boutons\continue.PNG
global bpause := "/boutons/continue.png"
return
}
if(wmp.playstate=2)
{
wmp.controls.play
wml.controls.play
guicontrol,cmv:, pausecontinue, boutons\pause.PNG
global bpause := "/boutons/pause.png"
}
return

GDIP(C:="Startup") {                                      ; By SKAN on D293 @ bit.ly/2krOIc9
  Static SI:=Chr(!(VarSetCapacity(Si,24,0)>>16)), pToken:=0, hMod:=0, Res:=0, AOK:=0
  If (AOK := (C="Startup" and pToken=0) Or (C<>"Startup" and pToken<>0))  {
      If (C="Startup") {
               hMod := DllCall("LoadLibrary", "Str","gdiplus.dll", "Ptr")
               Res  := DllCall("gdiplus\GdiplusStartup", "PtrP",pToken, "Ptr",&SI, "UInt",0)
      } Else { 
               Res  := DllCall("gdiplus\GdiplusShutdown", "Ptr",pToken)
               DllCall("FreeLibrary", "Ptr",hMod),   hMod:=0,   pToken:=0
   }}  
Return (AOK ? !Res : Res:=0)    
}

SavePicture(hBM, sFile) {                                            ; By SKAN on D293 @ bit.ly/2krOIc9
Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
  E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
  E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
  NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
  E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
  E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
}



