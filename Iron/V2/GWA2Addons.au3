;~ Version 1.0

#include-once

#include <GWA2.au3>

#include <Math.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>

If @AutoItX64 Then
	MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
	Exit
EndIf

#cs already in the big GWA2
#Region Declarations

Local $mKernelHandle
Local $mGWProcHandle
Local $mGWHwnd
Local $mMemory
Local $mLabels[1][2]
Local $mBase = 0x00DE0000
Local $mASMString, $mASMSize, $mASMCodeOffset

Local $mGUI = GUICreate('GWA²'), $mSkillActivate, $mSkillCancel, $mSkillComplete, $mChatReceive, $mLoadFinished
Local $mSkillLogStruct = DllStructCreate('dword;dword;dword;float')
Local $mSkillLogStructPtr = DllStructGetPtr($mSkillLogStruct)
Local $mChatLogStruct = DllStructCreate('dword;wchar[256]')
Local $mChatLogStructPtr = DllStructGetPtr($mChatLogStruct)
GUIRegisterMsg(0x501, 'Event')

Local $mQueueCounter, $mQueueSize, $mQueueBase
Local $mTargetLogBase
Local $mStringLogBase
Local $mSkillBase
Local $mEnsureEnglish
Local $mMyID, $mCurrentTarget
Local $mAgentBase
Local $mBasePointer
Local $mRegion, $mLanguage
Local $mPing
Local $mCharname
Local $mMapID
Local $mMaxAgents
Local $mMapLoading
Local $mMapIsLoaded
Local $mLoggedIn
Local $mStringHandlerPtr
Local $mWriteChatSender
Local $mTraderQuoteID, $mTraderCostID, $mTraderCostValue
Local $mSkillTimer
Local $mBuildNumber
Local $mZoomStill, $mZoomMoving
Local $mDisableRendering
Local $mAgentCopyCount
Local $mAgentCopyBase

Local $mUseStringLog
Local $mUseEventSystem

;<-- change player status
Global $mCurrentStatus
Global $mChangeStatus = DllStructCreate('ptr;dword')
Global $mChangeStatusPtr = DllStructGetPtr($mChangeStatus)
;change player status -->

#EndRegion Declarations

#ce

Func RndTravel($aMapID, ByRef $DisArrayCheckboxes)
	If GetMapLoading() == 2 Then Disconnected()
	;returns true if successful
	If GetMapID() = $aMapID And GetMapLoading() = 0 Then Return True
	Local $Region[0]
	Local $Language[0]
	If GUICtrlRead($DisArrayCheckboxes[0]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 0)
		_ArrayAdd($Language, 0)
	EndIf ;America
	If GUICtrlRead($DisArrayCheckboxes[1]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 4294967294)
		_ArrayAdd($Language, 0)
	EndIf ;Int
	If GUICtrlRead($DisArrayCheckboxes[2]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 0)
	EndIf ;Eu - En
	If GUICtrlRead($DisArrayCheckboxes[3]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 2)
	EndIf ;Eu - Fr
	If GUICtrlRead($DisArrayCheckboxes[4]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 3)
	EndIf ;Eu - Ge
	If GUICtrlRead($DisArrayCheckboxes[5]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 4)
	EndIf ;Eu - It
	If GUICtrlRead($DisArrayCheckboxes[6]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 5)
	EndIf ;Eu - Sp
	If GUICtrlRead($DisArrayCheckboxes[7]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 9)
	EndIf ;Eu - Po
	If GUICtrlRead($DisArrayCheckboxes[8]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 2)
		_ArrayAdd($Language, 10)
	EndIf ;Eu - Ru
	If GUICtrlRead($DisArrayCheckboxes[9]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 1)
		_ArrayAdd($Language, 0)
	EndIf ;Asia - ko
	If GUICtrlRead($DisArrayCheckboxes[10]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 3)
		_ArrayAdd($Language, 0)
	EndIf ;Asia - ch
	If GUICtrlRead($DisArrayCheckboxes[11]) == $GUI_CHECKED Then
		_ArrayAdd($Region, 4)
		_ArrayAdd($Language, 0)
	EndIf ;Asia - ja
	If UBound($Region) Then
		Local $Random = Random(0, UBound($Region) - 1, 1)
		MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	Else
		MoveMap($aMapID, GetRegion(), 0, GetLanguage())
	EndIf
	Return _WaitMapLoadingSwitchMode($aMapID)
EndFunc

;~ Description: Returns is a skill is recharged.
Func IsRecharged($lSkill)
	Return GetSkillbarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged

;~Description: Use a skill and wait for it to be used.
Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	Local $Skill = GetSkillByID(GetSkillbarSkillID($lSkill, 0))
	Local $Energy = StringReplace(StringReplace(StringReplace(StringMid(DllStructGetData($Skill, 'Unknown4'), 6, 1), 'C', '25'), 'B', '15'), 'A', '10')
	If GetEnergy(-2) < $Energy Then Return
	Local $lAftercast = DllStructGetData($Skill, 'Aftercast')
	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
	Sleep($lAftercast * 1000)
EndFunc   ;==>UseSkillEx

#cs already in the big GWA2
#Region Online Status
;<-- change player status
;~ Description: Change online status. 0 = Offline, 1 = Online, 2 = Do not disturb, 3 = Away
Func SetPlayerStatus($iStatus)
	If (($iStatus >= 0 And $iStatus <= 3) And (GetPlayerStatus() <> $iStatus)) Then
		DllStructSetData($mChangeStatus, 2, $iStatus)

		Enqueue($mChangeStatusPtr, 8)
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SetPlayerStatus

Func GetPlayerStatus()
	Return MemoryRead($mCurrentStatus)
EndFunc   ;==>GetPlayerStatus
;<-- change player status
#EndRegion Online Status
#ce

Func Disconnected()
	Out("Disconnected!")
	Out("Attempting to reconnect.")
	ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Sleep(1500)
	If Not GetMapLoading() <> 2 And Not GetAgentExists(-2) Then ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Local $lcheck = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(20)
		$lcheck = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $lcheck Or TimerDiff($lDeadlock) > 12000
	If $lcheck = False Then
		Out("Failed to Reconnect!")
		Out("Retrying...")
		ControlSend(GetWindowHandle(), "", "", "{Enter}")
		$lDeadlock = TimerInit()
		Do
			Sleep(20)
			$lcheck = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $lcheck Or TimerDiff($lDeadlock) > 30000
		If $lcheck = False Then
			Out("Could not reconnect!")
			Out("Exiting.")
			Return False
		EndIf
	EndIf
	Out("Reconnected!")
	Sleep(2000)
	SetPlayerStatus($PlayerStatus)
	Return True
EndFunc   ;==>Disconnected

;~ Description: INTERNAL USE ONLY
Func _arg($x,$y)
;~ 	Local Const $PI = 3.141592653589793
	Local $myAngle = _Degree(ATan($y/$x))
	If $x >= 0 And $y < 0 Then $myAngle += 360
	If $x < 0 Then $myAngle += 180

;~ 	If $offset
	Return $myAngle
EndFunc   ;--->_arg

Func getAngleAtA($aAgent = -2, $bAgent = -1)
	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
	If Not IsDllStruct($bAgent) Then $bAgent = GetAgentByID($bAgent)
	Local $deltaX = DllStructGetData($bAgent,'X') - DllStructGetData($aAgent,'X')
	Local $deltaY = DllStructGetData($bAgent,'Y') - DllStructGetData($aAgent,'Y')
;~ 	consolewrite('Angle: '&  _arg($deltaX,$deltaY) & @CRLF)
	Return _arg($deltaX,$deltaY)
EndFunc

#cs already in the big GWA2
Func GetPartySize()
	Local $lSize = 0, $lReturn
	Local $lOffset[5] = [0, 0x18, 0x4C, 0x54, 0]
	For $i = 0 To 2
		$lOffset[4] = $i * 0x10 + 0xC
		$lReturn = MemoryReadPtr($mBasePointer, $lOffset)
		$lSize += $lReturn[1]
	Next
	Return $lSize
EndFunc   ;==>GetPartySize

; Returns number of that specific item
Func CountInventoryItem($ItemID)
	Local $count = 0
	Local $lItemInfo
	For $i = 1 To 4
		For $j = 0 To DllStructGetData(GetBag($i), 'Slots') - 1
			$lItemInfo = GetItemBySlot($i, $j)
			If DllStructGetData($lItemInfo, 'ModelID') = $ItemID Then $count += DllStructGetData($lItemInfo, 'quantity')
		Next
	Next
	Return $count
EndFunc   ;==>CountInventoryItem
#ce

;~ Description: Returns item ID of salvage kit in inventory and Xulai
Func FindNextSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case $Salvage_Kit_Expert_ID
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
;~ 						ConsoleWrite(@CRLF & "-----------FindNextSalvageKit  expert quantity: " & DllStructGetData($lItem, 'quantity'))
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case $Salvage_Kit_Superior_ID
;~ 					ConsoleWrite(@CRLF & "-----------FindNextSalvageKit  Superio quantity: " & DllStructGetData($lItem, 'quantity'))
					If DllStructGetData($lItem, 'Value') / 10 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 10
					EndIf
				Case $Salvage_Kit_ID
;~ 					ConsoleWrite(@CRLF & "-----------FindNextSalvageKit  normal quantity: " & DllStructGetData($lItem, 'quantity'))
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
;~ 	ConsoleWrite('ID: ' & $lKit & @TAB)
;~ 	ConsoleWrite('Value: ' & $lUses & @CRLF)
	Return $lKit
EndFunc   ;==>FindSalvageKit

;~ Description: count all salvage kit value in inventory.
Func CountSalvageKit()
	Local $lItem
	Local $lUses = 0
	Local $tabNr = getTabNrByName("BagsTab")
	For $i = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
				$lItem = GetItemBySlot($i, $j)
				Switch DllStructGetData($lItem, 'ModelID')
					Case $Salvage_Kit_Expert_ID
							$lUses += DllStructGetData($lItem, 'Value') / 8
					Case $Salvage_Kit_Superior_ID
							$lUses += DllStructGetData($lItem, 'Value') / 10
					Case $Salvage_Kit_ID
							$lUses += DllStructGetData($lItem, 'Value') / 2
					Case Else
						ContinueLoop
				EndSwitch
		Next
		EndIf
	Next

	If GetMapLoading() = 0 Then
		For $i = 8 To 16 ;do not count the mats register!!!!!
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
				$lItem = GetItemBySlot($i, $j)
				Switch DllStructGetData($lItem, 'ModelID')
					Case $Salvage_Kit_Expert_ID
							$lUses += DllStructGetData($lItem, 'Value') / 8
					Case $Salvage_Kit_Superior_ID
							$lUses += DllStructGetData($lItem, 'Value') / 10
					Case $Salvage_Kit_ID
							$lUses += DllStructGetData($lItem, 'Value') / 2
					Case Else
						ContinueLoop
				EndSwitch
				Next
			EndIf
		Next
	EndIf


	Return $lUses
EndFunc   ;==>FindSalvageKit

;~ Description: count all ident kit value in inventory.
Func CountIDKit()
	Local $lItem
	Local $Value = 0
	Local $tabNr = getTabNrByName("BagsTab")
	For $i = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
			For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
				$lItem = GetItemBySlot($i, $j)
				Switch DllStructGetData($lItem, 'ModelID')
					Case 2989 ;normal slavage kit
						$Value += DllStructGetData($lItem, 'Value') / 2
					Case 5899 ;high salvage kit
						$Value += Round(DllStructGetData($lItem, 'Value') / 2.5)
					Case Else
						ContinueLoop
				EndSwitch
			Next
		EndIf
	Next

	If GetMapLoading() = 0 Then
		For $i = 8 To 16 ;do not count the mats register!!!!!
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
					$lItem = GetItemBySlot($i, $j)
					Switch DllStructGetData($lItem, 'ModelID')
						Case 2989 ;normal slavage kit
							$Value += DllStructGetData($lItem, 'Value') / 2
						Case 5899 ;high salvage kit
							$Value += Round(DllStructGetData($lItem, 'Value') / 2.5)
						Case Else
							ContinueLoop
					EndSwitch
				Next
			EndIf
		Next
	EndIf
	Return $Value
EndFunc   ;==>CountIDKit

;~ Description: Wait for map to load. Returns true if successful.
;~ changed RndSleepTime at the End (orignial = 2500)
Func _WaitMapLoadingSwitchMode($aMapID = 0, $aDeadlock = 18000)
;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after map is loaded.
	Local $lMapLoading
	Local $lDeadlock = TimerInit()

	InitMapLoad()

	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
		If $lMapLoading == 2 Then $lDeadlock = TimerInit()
		If TimerDiff($lDeadlock) > $aDeadlock And $aDeadlock > 0 Then Return False
	Until $lMapLoading <> 2 And GetMapIsLoaded() And (GetMapID() = $aMapID Or $aMapID = 0)

	RndSleep(1500)
	_updatePlayerStatus()
;~ 	SwitchMode($HmOrNm)

;~ 	ConsoleWrite(@CRLF & "!GetMapLoading() " & GetMapLoading()) ---> Area = 1 Loading = 2 City = 0
	If GetMapLoading() = 0 Then
		ConsoleWrite(@CRLF & "! This is a City" & @CRLF)
		SwitchMode($HmOrNm)
	ElseIf GetMapLoading() = 1 Then
		ConsoleWrite(@CRLF & "! This is a Area" & @CRLF)
	EndIf
	Return True
EndFunc   ;==>WaitMapLoading

;~ GetMapLoading
;~ If GetMapLoading() == 2 Then Disconnected()

Func _CountFreeSlots()
	Local $FreeSlots, $Slots
	Local $tabNr = getTabNrByName("BagsTab")
	For $BAGINDEX = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$BAGINDEX) Then
			$Slots += DllStructGetData(GetBag($BAGINDEX), 'Slots')
			$Slots -= DllStructGetData(GetBag($BAGINDEX), 'ItemsCount')
		EndIf
	Next
	Return $Slots
EndFunc   ;==>_CountFreeSlots

;~ Description: Move to a location and wait until you reach it.
;~ add If GetMapLoading() == 2 Then Disconnected()
Func _MoveTo($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
;~ 	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY, 0)

	Do
		Sleep(100)
		If GetMapLoading() == 2 Then Disconnected()
		If GetMapLoading() <> 1 Then Return False ;--> Not in exporable Area
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

;~ 		$lMapLoadingOld = $lMapLoading
;~ 		$lMapLoading = GetMapLoading()
;~ 		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 25 Or $lBlocked > 14
	Return True
EndFunc   ;==>_MoveTo

;~ Description: Move to a location and wait until you reach it.
;~ add If GetMapLoading() == 2 Then Disconnected()
;~ returns instantly when party danger is above $AggroCount
Func _MoveToAggroEnemy($aX, $aY, $AggroCount, ByRef $ArrayOfEnemyIDs, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY, 0)

;~ 	For $j = 0 To 2
;~ 		For $i = 1 To 3
;~ 			ConsoleWrite(@CRLF & "- AgentID " &$j & " " & $i & " " &  $lAgentGroup[$j][$i])
;~ 		Next
;~ 	Next
;~ 	ConsoleWrite(@CRLF )
	Do
		Sleep(100)
		If GetMapLoading() == 2 Then Disconnected()
		If GetMapLoading() <> 1 Then Return False ;--> Not in exporable Area
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then ExitLoop

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then ExitLoop

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
		EndIf
		If GetAgentDanger($lMe, $ArrayOfEnemyIDs) >= $AggroCount Then
			ConsoleWrite(@CRLF & "! _MoveToAggroEnemy GetAgentDanger " &  GetAgentDanger($lMe, $ArrayOfEnemyIDs) & @TAB & GetAgentDanger($lMe, GetAgentArray(0xDB)))
		Else
			ConsoleWrite(@CRLF & "# _MoveToAggroEnemy GetAgentDanger " &  GetAgentDanger($lMe, $ArrayOfEnemyIDs) & @TAB & GetAgentDanger($lMe, GetAgentArray(0xDB)))
		EndIf
	Until GetAgentDanger($lMe, $ArrayOfEnemyIDs) >= $AggroCount Or ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 25 Or $lBlocked > 14
;~ 	ConsoleWrite(@CRLF)
	Return True
EndFunc   ;==>_MoveToAggroEnemy

Func GetNearestEnemyToCoords($aX,$aY)
Local $lNearestAgent, $lNearestDistance = 100000000
	Local $lDistance
	Local $lAgent, $lAgentArray = GetAgentArray(0xDB)

	For $i = 1 To $lAgentArray[0]
		$lAgent = $lAgentArray[$i]
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop


		$lDistance = ($aX - DllStructGetData($lAgent, 'X')) ^ 2 + ($aY - DllStructGetData($lAgent, 'Y')) ^ 2
		If $lDistance < $lNearestDistance Then
			$lNearestAgent = $lAgent
			$lNearestDistance = $lDistance
		EndIf
	Next

	SetExtended(Sqrt($lNearestDistance))
	Return $lNearestAgent
EndFunc   ;==>GetNearestEnemyToCoords

Func isMaterial($aItem)
	Local $Type = DllStructGetData(($aItem), 'Type')
	Local $ModelID = DllStructGetData($aItem,"ItemID")
;~ 	If $ModelID = 921 Or $ModelID = 953 Or $ModelID = 946 Or $ModelID = 934 Or $ModelID = 926 Or $ModelID = 930 Or $ModelID = 923 Or $ModelID = 937 Or $ModelID = 936 Or $ModelID = 939	Or $ModelID = 956 Or $ModelID = 948 Or $ModelID = 954 Or $ModelID = 955 Or $ModelID = 933 Or $ModelID = 927 Or $ModelID = 949 Or $ModelID = 931 Or $ModelID = 938 Or $ModelID = 922 Or $ModelID = 942 Or $ModelID = 951 Or $ModelID = 6532 Or $ModelID = 940 Or $ModelID = 925 Or $ModelID = 929 Or $ModelID = 941 Or $ModelID = 950 Or $ModelID = 932 Or $ModelID = 935 Or $ModelID = 945 Or $ModelID = 943 Or $ModelID = 952 Or $ModelID = 6533 Or $ModelID = 921 Or $ModelID = 921 Then
		If $Type = 11 Then Return True
;~ 	EndIf
	Return False
EndFunc

; Returns number of that specific item
Func CountInventoryItem($ItemID)
   Local $count = 0
   Local $lItemInfo
   For $i = 1 To 4
	   ;changed the -1 to count all Slots
	  For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
		 $lItemInfo = GetItemBySlot($i, $j)
		 If DllStructGetData($lItemInfo, 'ModelID') = $ItemID Then $count += DllStructGetData($lItemInfo, 'quantity')
	  Next
   Next
   Return $count
EndFunc   ;==>CountInventoryItem

; Returns number of that specific item
Func CountInventoryChestItemByID($ItemID)
   Local $count = 0
   Local $aItem
   Local $tabNr = getTabNrByName("BagsTab")

   For $i = 1 To 4
	   ;changed the -1 to count all Slots
	 If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
			$aItem = GetItemBySlot($i, $j)
			If DllStructGetData($aItem, 'ModelID') = $ItemID Then $count += DllStructGetData($aItem, 'quantity')
		Next
	EndIf
	Next

	If GetMapLoading() = 0 Then
		For $i = 8 To 16 ;do not count the mats register!!!!!
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
					$aItem = GetItemBySlot($i, $j)
					If DllStructGetData($aItem, 'ModelID') = $ItemID Then $count += DllStructGetData($aItem, 'quantity')
				Next
			EndIf
		Next
   EndIf

   Return $count

EndFunc   ;==>CountInventoryChestItemByID

Func CountInventoryChestIronItems()
   Local $count = 0
   Local $aItem
   Local $tabNr = getTabNrByName("BagsTab")

   For $i = 1 To 4
	   ;changed the -1 to count all Slots
	 If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
			$aItem = GetItemBySlot($i, $j)
			If IsIronItem($aItem) Then $count += DllStructGetData($aItem, 'quantity')
		Next
	EndIf
	Next

	If GetMapLoading() = 0 Then
		For $i = 8 To 16 ;do not count the mats register!!!!!
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
					$aItem = GetItemBySlot($i, $j)
					If IsIronItem($aItem) Then $count += DllStructGetData($aItem, 'quantity')
				Next
			EndIf
		Next
   EndIf

   Return $count

EndFunc   ;==>CountInventoryChestIronItems


; Returns number of that specific item
Func CountInventory_ChestMaterial($ItemID, $Inv = True , $Chest = False)
	Local $count = 0
	Local $aItem

	If $Inv Then
		Local $tabNr = getTabNrByName("BagsTab")
		For $i = 1 To 4
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
					$aItem = GetItemBySlot($i, $j)
					Local $nextItemID = DllStructGetData($aItem, 'ModelID')
					If $nextItemID = $ItemID And isMaterial($aItem) Then
						$count += DllStructGetData($aItem, 'quantity')
					EndIf
				Next
			EndIf
		Next
	EndIf
	If GetMapLoading() = 0 Then
		If $Chest Then
			Local $tabNr = getTabNrByName("BagsTab")
			For $i = 8 To 16 ;do not count the mats register!!!!!
				If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
					For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
						$aItem = GetItemBySlot($i, $j)
						If DllStructGetData($aItem, 'ModelID') = $ItemID And isMaterial(GetItemByItemID($aItem)) Then
							$count += DllStructGetData($aItem, 'quantity')
						EndIf
					Next
				EndIf
			Next
		EndIf
	EndIf
	Return $count
EndFunc   ;==>CountInventoryItem

Func CountInventory_ChestFreeSlots($Inv = True , $Chest = False)
	Local $count = 0
	Local $aItem

	If $Inv Then
		Local $tabNr = getTabNrByName("BagsTab")
		For $i = 1 To 4
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
				For $j = 1 To DllStructGetData(GetBag($i), 'Slots') ;- 1
					$aItem = GetItemBySlot($i, $j)
					If DllStructGetData($aItem, 'ID') = 0 Then $count += 1
				Next
			EndIf
		Next
	EndIf
	If GetMapLoading() = 0 Then
		If $Chest Then
			Local $tabNr = getTabNrByName("BagsTab")
			For $i = 8 To 16 ;do not count the mats register!!!!!
				If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i-3) Then
					For $j = 1 To DllStructGetData(GetBag($i), 'Slots') ;- 1
						$aItem = GetItemBySlot($i, $j)
						If DllStructGetData($aItem, 'ID') = 0 Then $count += 1
					Next
				EndIf
			Next
		EndIf
		Return $count
	EndIf
EndFunc   ;==>Count Free Slots


Func CountMaterialInv($MaterialID)
	Local $count = 0
	Local $aItem
	Local $tabNr = getTabNrByName("BagsTab")
	For $i = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
			For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
				$aItem = GetItemBySlot($i, $j)
				If $MaterialID <> DllStructGetData($aItem, "ModelID") Then ContinueLoop
				If isMaterial($aItem) Then $count += DllStructGetData($aItem, 'quantity')
			Next
		EndIf
	Next
	Return $count
EndFunc

Func CountBrambleInv()
	Local $count = 0
	Local $aItem
	Local $tabNr = getTabNrByName("BagsTab")
	For $i = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
			For $j = 1 To DllStructGetData(GetBag($i), 'Slots') ;- 1
				$aItem = GetItemBySlot($i, $j)
				If IsBrambleBow($aItem) Then $count += 1
			Next
		EndIf
	Next
	Return $count
EndFunc

;~ Description: Returns the distance between a agent and X,Y coordinate
Func GetDistanceCoordsToAgent($X, $Y , $aAgent1 = -1)
	If IsDllStruct($aAgent1) = 0 Then $aAgent1 = GetAgentByID($aAgent1)
	Return Sqrt((DllStructGetData($aAgent1, 'X') - $X) ^ 2 + (DllStructGetData($aAgent1, 'Y') - $Y) ^ 2)
EndFunc   ;==>GetDistanceCoordsToAgent

;~ Description: Returns item ID of ID kit in inventory.
Func _FindIDKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2989
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 2
					EndIf
				Case 5899
					If DllStructGetData($lItem, 'Value') / 2.5 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = Round(DllStructGetData($lItem, 'Value') / 2.5)
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc   ;==>FindIDKit

#cs already in the big GWA2
;~ Description: Use a skill and wait for it to be used.
Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	Local $Skill = GetSkillByID(GetSkillbarSkillID($lSkill, 0))
	Local $Energy = StringReplace(StringReplace(StringReplace(StringMid(DllStructGetData($Skill, 'Unknown4'), 6, 1), 'C', '25'), 'B', '15'), 'A', '10')
	If GetEnergy(-2) < $Energy Then Return
	Local $lAftercast = DllStructGetData($Skill, 'Aftercast')
	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
	Sleep($lAftercast * 1000)
EndFunc   ;==>UseSkillEx

;~ Description: Returns is a skill is recharged.
Func IsRecharged($lSkill)
	Return GetSkillbarSkillRecharge($lSkill) == 0
EndFunc   ;==>IsRecharged
#ce