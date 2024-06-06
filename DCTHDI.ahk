#Requires AutoHotkey v2.0
#SingleInstance force

; SetTimer WatchCursor, 100

WindowTitle := ""
WindowControl := ""
ClipboardCount := 0

WatchCursor()
{
    MouseGetPos , , &id, &control
    global WindowTitle 
    global WindowControl 
    WindowTitle := WinGetTitle(id)
    WindowControl := control
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

CheckIfIconIsSelected(){
    BackupClipboard := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    ClipWait 1

    Global ClipboardCount
    ClipboardCount := 0

    Loop Parse A_Clipboard, "`n", "`r"
    {
        ClipboardCount++
        if(ClipboardCount == 0)
            break
    }
    
    A_Clipboard := BackupClipboard 
    BackupClipboard := ""
}

~LButton::{
    if (A_PriorHotkey = A_ThisHotkey) and (A_TimeSincePriorHotkey < 250) {
        WatchCursor()
    }

	if (A_PriorHotkey = A_ThisHotkey) and (A_TimeSincePriorHotkey < 250 and WindowControl != "Edit1") and (WindowTitle == "" or WindowTitle == "Program Manager") {
		CheckIfIconIsSelected()
        if(ClipboardCount < 1){
            DesktopIcons()
        } else {
            return
        }
	} else {
		return
	}
}