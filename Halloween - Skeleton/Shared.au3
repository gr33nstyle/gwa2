
#include-once
#include "../GWA2.au3"
#include "Constants.au3"

Global $boolRunning = False
Global $boolInitialized = False
Global $Rendering = True

Global Const $USED_CITY = $CHANTRY_ID
Global Const $POSITION_NEAR_AVATAR = $POSITION_NEAR_AVATAR_CHANTRY
Global Const $POSITION_AVATAR = $POSITION_AVATAR_CHANTRY
Global Const $MODELID_AVATAR_OF_GRENTH = $MODELID_AVATAR_OF_GRENTH_NORMAL

Global $runs = 0
Global $fails = 0

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			If $boolRunning Then
				GUICtrlSetData($btnStart, "Will pause after this run")
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

		Case $cbxHideGW
			ClearMemory()
			ToggleRendering()

		Case $cbxOnTop
			WinSetOnTop($MainGui, "", GUICtrlRead($cbxOnTop)==$GUI_CHECKED)

		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

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

Func MapCheck()
	If GetMapID() <> $USED_CITY Then
		Out("Travelling to ToA")
		TravelTo($USED_CITY)
	EndIf
EndFunc   ;==>MapCheck

Func PickUpLoot()
    Local $lAgent
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True

	For $i = 1 To GetMaxAgents()
		$lMe = GetAgentByID(-2)
		If DllStructGetData($lMe, 'HP') <= 0.0 Then Return -1
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		If Not GetCanPickUp($lAgent) Then ContinueLoop
		Local $lItem = GetItemByAgentID($i)
		If CanPickUp($lItem) Then
			Out("Picking up " & GetAgentName($lAgent))
			Do
;~ 				If GetDistance($lItem) > 150 Then Move(DllStructGetData($lItem, 'X'), DllStructGetData($lItem, 'Y'), 100)
				PickUpItem($lItem)
				Sleep(GetPing())
				Do
					Sleep(100)
					$lMe = GetAgentByID(-2)
				Until DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0
				$lBlockedTimer = TimerInit()
				Do
					Sleep(3)
					$lItemExists = IsDllStruct(GetAgentByID($i))
				Until Not $lItemExists Or TimerDiff($lBlockedTimer) > Random(5000, 7500, 1)
				If $lItemExists Then $lBlockedCount += 1
			Until Not $lItemExists Or $lBlockedCount > 5
		EndIf
	Next
EndFunc   ;==>PickUpLoot

Func CanPickUp($aItem)
	Local $m = DllStructGetData($aItem, 'ModelID')
	Local $c = DllStructGetData($aItem, 'ExtraID')
	If ($m == 146 And ($c == 10 Or $c == 12 )) Then ;Black and White Dye
		Return True
	ElseIf $m == 3746 Or $m == 930 Then ;UW Scrolls and Ectos
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func GetCallerID()
	; for some reasons sometimes it does not work. So just do the whole thing multiple times.
	For $i=1 To 3
		Local $lAgentArray = GetAgentArray(0xDB)
		For $i = 1 To $lAgentArray[0]
			If DllStructGetData($lAgentArray[$i], 'Secondary') == $PROF_MONK Then
				Return DllStructGetData($lAgentArray[$i], 'ID')
			EndIf
		Next
	Next
	WriteChat("ERROR - CANNOT FIND LEADER - TELL SOMEONE ABOUT IT")
	Return -1
EndFunc

Func GetSkeleID()
	; for some reasons sometimes it does not work. So just do the whole thing multiple times.
	For $i=1 To 3
		Local $lAgentArray = GetAgentArray(0xDB)
		Local $lMe = GetAgentByID(-2)
		Local $lSkeleID = -1
		Local $lClosestSkeleDistance = 25000000 ; 25000000 = compass distance^2, skele will be less than that.
		For $i = 1 To $lAgentArray[0]
			If DllStructGetData($lAgentArray[$i], 'PlayerNumber') == $MODELID_SKELETON_OF_DHUUM Then
				Local $lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
				If $lDistance < $lClosestSkeleDistance Then ; we found a closer skele
					$lSkeleID = DllStructGetData($lAgentArray[$i], "ID")
					$lClosestSkeleDistance = $lDistance
				EndIf
			EndIf
		Next
		If $lSkeleID > 0 Then Return $lSkeleID
		Sleep(1500)
	Next
	If $lSkeleID == -1 Then WriteChat("ERROR - CANNOT FIND SKELE - TELL SOMEONE ABOUT IT")
	Return $lSkeleID
EndFunc

Func WaitForPartyWipe()
	Local $lDeadlock = TimerInit()
	Local $everyoneDead
	Do
		Sleep(1000) ; sleep 1 sec
		$everyoneDead = True
		Local $lParty = GetParty()
		For $i=1 To $lParty[0]
			If Not GetIsDead($lParty[$i]) Then
				$everyoneDead = False
			EndIf
		Next

		If TimerDiff($lDeadlock) > 10*1000 Then Resign() ; make sure we resigned

		If TimerDiff($lDeadlock) > 15*1000 Then ExitLoop ; something very bad happened.
	Until $everyoneDead == True
EndFunc

Func UpdateStatistics()
	$runs += 1
	GUICtrlSetData($lblRunsCount, $runs)
	GUICtrlSetData($lblFailsCount, $fails)
EndFunc

Func WaitMapLoadingNoDeadlock($aMapID = 0, $aSleep = 1500)
	Local $lMapLoading

	InitMapLoad()

	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
	Until $lMapLoading <> 2 And GetMapIsLoaded() And (GetMapID() == $aMapID Or $aMapID == 0)

	RndSleep($aSleep)

	Return True
EndFunc   ;==>WaitMapLoading
