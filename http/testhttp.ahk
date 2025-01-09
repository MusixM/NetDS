#Persistent
#SingleInstance, force
SetBatchLines, -1

FileRead, nb, nombre.txt
nbt:=1
paths := {}
Loop %nb%
	{
	paths["/"nbt] := Func("image")
	nbt := nbt + 1
	}
paths["/re"] := Func("Retirer")
server := new HttpServer()
server.LoadMimes(A_ScriptDir . "/mime.types")
server.SetPaths(paths)
server.Serve(8000)
return

image(ByRef req, ByRef res) {
    response.SetBodyText("Test")
    res.status := 200
    test := req.path
    Suite(test)
}

Suite(test) {
try Gui, tes:Destroy
test:= StrReplace(test, "/", "")
Gui, tes:Add, text,, %test%
Gui, tes:Show
}

#include, AHKhttp.ahk
#include AHKsock.ahk

F1::Reload