; Function to Toggle minimize of a window
ToggleWinMinimize(TheWindowTitle)
{
    SetTitleMatchMode,2
    DetectHiddenWindows, Off
    IfWinActive, %TheWindowTitle%
    {
        WinMinimize, %TheWindowTitle%
    }
    Else
    {
        IfWinExist, %TheWindowTitle%
        {
        WinGet, winid, ID, %TheWindowTitle%
        DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
        }
    }
    Return
}
; GOTO and MINIMIZE Windows
#+w::ToggleWinMinimize("Google Chrome")
#+e::ToggleWinMinimize("Visual Studio Code")

; ALT WINDOWS DRAG
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; by The How-To Geek
; http://www.howtogeek.com 

Alt & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return

; HIDE ALL OTHER WINDOWS
#+h::
#SingleInstance,Force
SetWinDelay,0

If WinNotExist,ahk_id %id%
	WinRestore,A

WinGet,id,ID,A
WinGet,style,Style,ahk_id %id%
If (style & 0x20000)
{
	WinGet,winid_,List,,,Program Manager
	Loop,%winid_% 
	{
		StringTrimRight,winid,winid_%A_Index%,0
		If id=%winid%
			Continue

		WinGet,style,Style,ahk_id %winid%
		If (style & 0x20000)
		{
			WinGet,state,MinMax,ahk_id %winid%,
			If state=-1
				Continue

			WinGetClass,class,ahk_id %winid%
			If class=Shell_TrayWnd
				Continue

			IfWinExist,ahk_id %winid%
				WinMinimize,ahk_id %winid%
		}
  }
}
return

; Copy text to search at google
^+c::
{
    Send, ^c
    Sleep 50
    Run, http://www.google.com/search?q=%clipboard%
    Return
}