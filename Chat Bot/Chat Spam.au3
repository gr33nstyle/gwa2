#AutoIt3Wrapper_UseX64=n

#include "GWA2.au3"

Local $Character = InputBox("Spam Trade", "Name Here","","",300,150)
Global $Paused
HotKeySet("+s", "TogglePause") 	;Shift + s
HotKeySet("+t", "Terminate")	;Shift + t

Opt("TrayAutoPause", 0)
TraySetToolTip("GW Salvage Tool v" & " - " & $Character)

Initialize($Character, False, True)

While 1
Local $aMessage = 'WTB  war horns 4e / each!!! PM ME!!!' ;Message here
Local $aChannel = '$'		;Channel here
  SendChat($aMessage, $aChannel)
			Sleep(10000)	;10 seconds
		RndSleep(15000)		;15 seconds
WEnd

Func TogglePause()
    $Paused = Not $Paused
    While $Paused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip('Script is "Running"', 0, 0)
EndFunc   ;==>TogglePause

Func Terminate()
    Exit 0
EndFunc   ;==>Terminate

