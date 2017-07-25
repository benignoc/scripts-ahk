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