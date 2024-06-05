#Requires AutoHotkey v2.0
#SingleInstance force

SetTimer WatchCursor, 100

WindowTitle := ""

WatchCursor()
{
    MouseGetPos , , &id, &control
    ; ToolTip
    ; (
    ;     "ahk_id " id "
    ;     ahk_class " WinGetClass(id) "
    ;     " WinGetTitle(id) "
    ;     Control: " control
    ; )
    WindowTitle := WinGetTitle(id)
}

DesktopIcons( Show:=-1 )
{
    Local hProgman := WinExist("ahk_class WorkerW", "FolderView") ? WinExist()
                   :  WinExist("ahk_class Progman", "FolderView")

    Local hShellDefView := DllCall("user32.dll\GetWindow", "ptr",hProgman,      "int",5, "ptr")
    Local hSysListView  := DllCall("user32.dll\GetWindow", "ptr",hShellDefView, "int",5, "ptr")

    If ( DllCall("user32.dll\IsWindowVisible", "ptr",hSysListView) != Show )
         DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "ptr",0x111, "ptr",0x7402, "ptr",0)
}



~LButton::{
	if (A_PriorHotkey = A_ThisHotkey) and (A_TimeSincePriorHotkey < 400 and WindowTitle == "") {
		DesktopIcons()
	} else {
		return
	}
}