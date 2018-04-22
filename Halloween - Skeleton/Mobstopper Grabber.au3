
#NoTrayIcon
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "GWA2.au3"
#include "Constants.au3"

Opt("MustDeclareVars", True) 	; have to declare variables with either Local or Global.
Opt("GUIOnEventMode", True)		; enable gui on event mode

Global $boolInitialized = False
Global $boolRunning = False


Global Const $MainGui = GUICreate("Skelefarm - Mobgrabber", 172, 190)
	GUICtrlCreateLabel("Skelefarm - Mobstopper Grabber", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
		GUICtrlSetData(-1, GetLoggedCharNames())
;~ 	GUICtrlCreateLabel("Runs:", 8, 92)
;~ 	Global Const $lblRunsCount = GUICtrlCreateLabel(0, 80, 92, 30)
;~ 	GUICtrlCreateLabel("Fails:", 8, 112)
;~ 	Global Const $lblFailsCount = GUICtrlCreateLabel(0, 80, 112, 30)
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("Start", 8, 162, 154, 25)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

If GetMapID() <> $LA_ID Then
	TravelTo($LA_ID)
EndIf

MoveTo(5240, 9082) ; go close to the steward

Global $Steward = GetNearestNPCToCoords(5332, 9048)
GoNPC($Steward)

Sleep(250)

; abandon quest if we have it:
If DllStructGetData(GetQuestByID($EVERY_BIT_HELPS), "ID") <> 0 Then
	AbandonQuest($EVERY_BIT_HELPS)
	Sleep(GetPing()+100)
EndIf

While 1
	If $boolRunning Then
		AcceptQuest($EVERY_BIT_HELPS)
		Sleep(GetPing()+10)
		AbandonQuest($EVERY_BIT_HELPS)
		Sleep(GetPing()+10)
	Else
		Sleep(250)
	EndIf
WEnd

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				$boolRunning = False
			ElseIf $boolInitialized Then
				GUICtrlSetData($btnStart, "Pause")
				$boolRunning = True
			Else
				$boolRunning = True
				GUICtrlSetData($btnStart, "Initializing...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				GUICtrlSetState($inputCharName, $GUI_DISABLE)
				WinSetTitle($MainGui, "", GUICtrlRead($inputCharName))
				If GUICtrlRead($inputCharName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, False, False) = False Then	; don't need string logs or event system
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($inputCharName), True, False, False) = False Then ; don't need string logs or event system
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($btnStart, "Pause")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				$boolInitialized = True
			EndIf

	EndSwitch
EndFunc
