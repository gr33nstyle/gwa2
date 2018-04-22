
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

Global $lastDistrict = -1
Global $Rendering = True

Global Const $MainGui = GUICreate("Skelefarm - Quest Acceptor", 172, 190)
	GUICtrlCreateLabel("Skelefarm - Quest Acceptor", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
		GUICtrlSetData(-1, GetLoggedCharNames())
   Global Const $cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 8, 48)
   Global Const $cbxOnTop = GUICtrlCreateCheckbox("Always On Top", 8, 68)
;~ 	GUICtrlCreateLabel("Runs:", 8, 92)
;~ 	Global Const $lblRunsCount = GUICtrlCreateLabel(0, 80, 92, 30)
;~ 	GUICtrlCreateLabel("Fails:", 8, 112)
;~ 	Global Const $lblFailsCount = GUICtrlCreateLabel(0, 80, 112, 30)
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("Start", 8, 162, 154, 25)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUICtrlSetOnEvent($cbxOnTop, "EventHandler")
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

Do
	Sleep(100)
Until $boolInitialized

If GetMapID() <> $LA_ID Then
	TravelTo($LA_ID)
EndIf

; abandon quest if we have it:
If DllStructGetData(GetQuestByID($EVERY_BIT_HELPS), "ID") <> 0 Then
	AbandonQuest($EVERY_BIT_HELPS)
	Sleep(GetPing()+100)
EndIf

While 1
	If $boolRunning Then

		; Gold check
		If GetGoldCharacter() > 95*1000 Then
			If GetGoldStorage() < 900*1000 Then
				DepositGold(GetGoldCharacter())
			Else
				MsgBox(0, "Full", "Sorry, you are too rich!")
				Exit
			EndIf
		EndIf

		; Inventory check / managment
		InventoryManagement()

		Out("Moving to the guy")
		MoveTo(5240, 9082) ; go close to the steward
		Local $Steward = GetNearestNPCToCoords(5332, 9048)
		Sleep(100)
		GoNPC($Steward)
		Sleep(300)
		Out("Accepting quest")
		AcceptQuest($EVERY_BIT_HELPS)
		Sleep(300)
		Out("Accepting reward")
		QuestReward($EVERY_BIT_HELPS)

		Sleep(300)
		Out("Zoning")
		Local $lDistrict = nextRandomDis()
		MoveMap($LA_ID, $lRegion[$lDistrict], 0, $lLanguage[$lDistrict])
		WaitMapLoading($LA_ID, 10*1000) ; zone, wait 2.5 sec at the end

	Else
		Sleep(100)
	EndIf
WEnd

Func InventoryManagement()
	Local $skele = GetItemByModelIDExtended($MODEL_ID_CAPTURED_SKELETON)

	If $skele[1] == 0 And $skele[2] == 0 Then
		MsgBox(0, "Done", "No more skeles to exchange")
		Exit
	EndIf

	If DllStructGetData($skele[0], 'Quantity') <= 2 Then
		Local $haveSome = False
		Local $curBag = $skele[1]
		Local $curSlot = $skele[2] + 1
		If $curSlot > DllStructGetData(GetBag($curBag), 'Slots') Then
			$curBag += 1
			$curSlot = 1
		EndIf
		While 1
			Local $next = GetItemByModelIDExtended($MODEL_ID_CAPTURED_SKELETON, $curBag, $curSlot)
			If $next[1] == 0 And $next[2] == 0 Then
				If $haveSome Then
					For $bag=$curBag To 4
						For $slot=$curSlot To DllStructGetData(GetBag($bag), 'Slots')
							If DllStructGetData(GetItemBySlot($bag, $slot), 'ModelID') == 0 Then
								MoveItem($skele[0], $bag, $slot)
								Return
							EndIf
						Next
					Next
				Else
					MsgBox(0, "Done", "Only "&DllStructGetData($skele[0], 'Quantity')&" left")
					Exit
				EndIf
			EndIf

			If DllStructGetData($next[0], 'Quantity') <= 248 Then
				MoveItem($skele[0], $next[1], $next[2])
				ExitLoop
			EndIf

			$curBag = $next[1]
			$curSlot = $next[2] + 1
			If $curSlot > DllStructGetData(GetBag($curBag), 'Slots') Then
				$curBag += 1
				$curSlot = 1
			EndIf
			$haveSome = True
		WEnd
	EndIf
EndFunc

; returns a 3-element array containing: The item struct, the bag where it is, the slot where it is.
Func GetItemByModelIDExtended($ModelID, $StartBag = 1, $StartSlot = 1)
	Local $retArr[3] = [False, 0, 0]
	For $bag = $StartBag To 4
		For $slot = $StartSlot To DllStructGetData(GetBag($bag), 'Slots')
			Local $item = GetItemBySlot($bag, $slot)
			If DllStructGetData($item, 'ModelID') == $ModelID Then
				$retArr[0] = $item
				$retArr[1] = $bag
				$retArr[2] = $slot
				Return $retArr
			EndIf
		Next
	Next
	Return $retArr
EndFunc

Func nextRandomDis()
	Local $tmp
	While 1
		$tmp = Random(1, 11, 1)
		If $tmp <> $lastDistrict Then
			$lastDistrict = $tmp
			Return $tmp
		EndIf
	WEnd
EndFunc

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cbxHideGW
			ClearMemory()
			ToggleRendering()
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "Resume")
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
		Case $cbxOnTop
			WinSetOnTop($MainGui, "", GUICtrlRead($cbxOnTop)==$GUI_CHECKED)
	EndSwitch
EndFunc

Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
	$Rendering = Not $Rendering
EndFunc

Func Out($aString)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
	GUICtrlSetData($lblLog, $timestamp & $aString)
EndFunc   ;==>Out
