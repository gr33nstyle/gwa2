#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=notused\Wattetier2.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs

___________changelog___________

#ce


#include <GWA2.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Math.au3>

#include <Gui.au3>
#include <GlobalConstants.au3>
#include <GWA2Addons.au3>
#include <Inventory.au3>


Opt("GUIOnEventMode", True)
;~ Opt("GUICloseOnESC", False)
Opt("TrayIconHide", 1)
Opt("MustDeclareVars", True)


Func _Initialize()
	$CharName = GUICtrlRead($CharInput)
	If $CharName == "" Then
		If Initialize(ProcessExists("gw.exe"), True, True) = False Then
			MsgBox(0, "Error", "Guild Wars is not running.")
			Exit
		EndIf
		$CharName = GetCharname()
	Else
		If Initialize($CharName, True, True) = False Then
			MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '" & $CharName & "'.")
			Exit
		EndIf
	EndIf
	$HWND = GetWindowHandle()
	GUICtrlSetState($RenderingBox, $GUI_ENABLE)
	GUISwitch($CharNameTabHWND)
	GUICtrlDelete($CharInput)
	Global $CharLable = GUICtrlCreateLabel($CharName,0,0,120,25,BitOR($ss_center, $ss_centerimage),0)
	GUICtrlSetFont(-1, 11, 400, 0, "Segoe Marker")
;~ 	GUICtrlSetBkColor(-1,0)
	GUISwitch($MainGUI)

;~ 	GUICtrlSetState($StartButton, $GUI_DISABLE)
	GUICtrlSetData($StartButton, "Pause")
	WinSetTitle($MainGUI, "", $CharName & " - " & "Fiber " & $Version)
	$TotalTimer = TimerInit()
	$BotInitialized = True
	loadIni()
	EnsureEnglish(True)
	SetPlayerStatus($PlayerStatus)
	Out("Initialized")
	ConsoleWrite(@CRLF & "> Initialized" & @CRLF)
;~ 	Sleep(500)
;~ 	ConsoleWrite(@CRLF)
;~ 		For $BAGINDEX = 1 To 3
;~ 			Local $AITEM
;~ 			Local $BAG = GETBAG($BAGINDEX)
;~ 			Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
;~ 			For $I = 1 To $NUMOFSLOTS
;~ 				$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
;~ 				ConsoleWrite(@CRLF & $i & @TAB )
;~ 				ConsoleWrite("ModelID" & @TAB & DllStructGetData($aitem, "ModelID"))
;~ 				ConsoleWrite(@TAB &"ExtraID" & @TAB & DllStructGetData($aitem, "ExtraID"))
;~ 			Next
;~ 		Next



;~ test()
EndFunc

Func AutoStart()
	Local $AutoStart = IniRead($IniPath, "AutoStart", "Enabled", False)
	$CharName = IniRead($IniPath, "AutoStart", "Name", "")
	IniWrite($IniPath, "AutoStart", "Enabled", False)
	IniWrite($IniPath, "AutoStart", "Name", "")
	If $AutoStart == True Then
		GUICtrlSetData($CharInput, $CharName)
		OUT($CharName)
		OUT("AutoStart")
		ConsoleWrite(@CRLF & "!AutoStarting  " & $AutoStart & "   CharName " & $CharName)
		If Not $BotInitialized Then
			$AverageTimer = TimerInit()
			_Initialize()
			$BotRunning = True
			updateTotalTime()
			AdlibRegister("updateTotalTime", 60 * 1000)
			SetMaxMemory()
			GUICtrlSetData($StartButton, "Pause")
		EndIf
		GUICtrlSetState($RenderingBox,$GUI_CHECKED)
		ToggleRendering(False)
		_hideAllTabs()
		$MinimizedTabs = True
		Return True
	EndIf
	Return False
EndFunc

#Region Loops
AutoStart()

If Not $BotRunning Then
			_GUICtrlEdit_AppendText($GLOGBOX,"[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & "Bot is paused")
;~ 			GUICtrlSetState($StartButton, $GUI_ENABLE)
;~ 			GUICtrlSetData($StartButton, "Start")
;~ 			GUICtrlSetOnEvent($StartButton, "StartTabEventHandler")
			_GUICtrlEdit_AppendText($GLOGBOX,@CRLF &"  Right click to minimize GUI")
			While Not $BotInitialized
				Sleep(100)
			WEnd
			OUT("Let's Ramboo")

			Local $PlayerStatus = IniRead($IniPath, $CharName, "PlayerStatus", 1)
			SetPlayerStatus($PlayerStatus) ;1 = online
			Switch $PlayerStatus
				Case 0
					out("I' m offline now")
					If GUICtrlRead($PlayerStatusLable) <> "Offline" Then GUICtrlSetData($PlayerStatusLable,"Offline")
				Case 1
					out("I' ll be online")
					If GUICtrlRead($PlayerStatusLable) <> "Online" Then GUICtrlSetData($PlayerStatusLable,"Online")
				Case 2
					out("Do not disturb" & $CharName)
					If GUICtrlRead($PlayerStatusLable) <> "Do not disturb " Then GUICtrlSetData($PlayerStatusLable,"Do not disturb")
				Case 3
					out("I' m away")
					If GUICtrlRead($PlayerStatusLable) <> "Away" Then GUICtrlSetData($PlayerStatusLable,"Away")
			EndSwitch
EndIf

For $i = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots'); - 1
			Local $aItem = GetItemBySlot($i, $j)
			ConsoleWrite(@CRLF & $i & " " & $j & @TAB & "Type " & DllStructGetData($aItem, 'Type'))
		Next
Next

While Not $BotRunning
	Sleep(100)
	autoSalvage()
WEnd


SetPlayerStatus($PlayerStatus)
If GetMapID() <> $MAP_ID_USING_AREA Then
;~ 	ConsoleWrite("-running to Jaga, ")
	TravelTo($MAP_ID_USING_CITY)
	LoadSkillTemplate($template)
	Sleep(GetPing()*3 + 500)
	;~ MsgBox(0,0,"$WEAPON_SLOT_USING")
	;~ ChangeWeaponSet($WEAPON_SLOT_USING)
	;~ Sleep(GetPing()*3 + 500)
	;~ MsgBox(0,0,"LeaveGroup")
	If GetPartySize() > 1 Then LeaveGroup()
	Sleep(GetPing()*3 + 500)
	;~ MsgBox(0,0,"$HmOrNm")
	SwitchMode($HmOrNm)
EndIf

;~ MsgBox(0,0,"template")

While True
   Global $Me = GetAgentByID(-2)

	While _CountFreeSlots() > 2
		If Not $BotRunning Then
			If GUICtrlRead($useGhCheckbox) == $GUI_CHECKED Then TravelGH()
			Out("Bot is paused")
			$BotShouldPause = False
			GUICtrlSetState($StartButton, $GUI_ENABLE)
			GUICtrlSetData($StartButton, "Start")
;~ 			GUICtrlSetOnEvent($StartButton, "StartTabEventHandler")
			While Not $BotRunning
				Sleep(100)
;~ 				Local $firstItem = GetItemBySlot(1, 1)
;~ 				ConsoleWrite(@CRLF & "! FirstItem: ID: " & DllStructGetData($firstItem, "ModelID") &@TAB & "Type: " & DllStructGetData($firstItem, "Type"))
				autoSalvage()
			WEnd
			$AverageTimer = TimerInit()
			updateTotalTime()
		EndIf
		Main()
	WEnd
;~ 	GoToNPC(GetAgentByName('Xunlai Chest'))
;~ 	moveItemsToChest()
	Local $Merchant = Merchant()
	If $Merchant = False Then
		out("I am full, take care!")
		GoToNPC(findXunlai())
		$BotRunning = False
		GUICtrlSetData($StartButton, "Start")
		While Not $BotRunning
			Sleep(100)
			autoSalvage()
		WEnd
	Else
		MoveTo($SpawnPointUsingGateX, $SpawnPointUsingGateY)
	EndIf


WEnd
#EndRegion Loops

#cs
Func SetUpFastWay()
	If GetMapID() <> $MAP_ID_USING_CITY Then RndTravel($MAP_ID_USING_CITY, $DistrictCheckboxes)
	Out("Setting up resign")
	Local $SpawnPoint1X = 1265
	Local $SpawnPoint1Y = -291
	Local $SpawnPoint2X = 1500  ;at NPCs
	Local $SpawnPoint2Y = 834
	Local $Me = GetAgentByID(-2)
	Local $X = DllStructGetData($Me, 'X')
	Local $Y = DllStructGetData($Me, 'Y')
;~ 		ConsoleWrite('Start east of the stairs' & @CRLF)
		If $X > 800 Then MoveTo(480, 18)
		MoveTo($SpawnPointUsingGateX, $SpawnPointUsingGateY)
		Move($TriggerUsingGateX, $TriggerUsingGateY,5)
	_WaitMapLoadingSwitchMode($MAP_ID_USING_AREA)
	Sleep(getping())
	UseSkillEx($Skill_DwarvenStab)
	Move(20351, 9300)
	UseSkillEx($Skill_Renewal)
	UseSkillEx($Skill_PiousHaste)
	Sleep(2000)
	_WaitMapLoadingSwitchMode($MAP_ID_USING_CITY)
	Out("Rdy to resign")
	Return True
EndFunc
#ce

; _______ Main _______
Func Main()
	ConsoleWrite("-goingOutside, ")
	If GetMapID() <> $MAP_ID_USING_AREA Then
		ConsoleWrite("-running to Jaga, ")
		RunThere()
	EndIf

	If GetIsDead(-2) Then Return False
	If GetMorale() = -60 Then Return False
	$AverageTimer = TimerInit()
	CombatLoop()

;~ 	BackToTown()
;~ 	moveItemsToChest()
	UpdateStats()
EndFunc

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine ;by gigi
Func RunThere()
	If GetMapID() <> $MAP_ID_USING_CITY Then
		Out("Travelling to longeye")
		TravelTo($MAP_ID_USING_CITY)
	EndIf

	SwitchMode(1)
	Merchant()
	Out("Exiting Outpost")
	Move(-26472, 16217)
	_WaitMapLoadingSwitchMode($MAP_ID_BJORA)
	; UseItem(GetItemByItemID($ITEM_ID_CUPCAKES))

	Out("Running to Jaga")
	If Not MoveRunning(15003.8, -16598.1) 	Then Return
	If Not MoveRunning(15003.8, -16598.1) 	Then Return
	If Not MoveRunning(12699.5, -14589.8) 	Then Return
	If Not MoveRunning(11628,   -13867.9) 	Then Return
	If Not MoveRunning(10891.5, -12989.5) 	Then Return
	If Not MoveRunning(10517.5, -11229.5) 	Then Return
	If Not MoveRunning(10209.1, -9973.1)  	Then Return
	If Not MoveRunning(9296.5,  -8811.5)  	Then Return
	If Not MoveRunning(7815.6,  -7967.1)  	Then Return
	If Not MoveRunning(6266.7,  -6328.5)  	Then Return
	If Not MoveRunning(4940,    -4655.4)  	Then Return
	If Not MoveRunning(3867.8,  -2397.6)  	Then Return
	If Not MoveRunning(2279.6,  -1331.9)  	Then Return
	If Not MoveRunning(7.2,     -1072.6)  	Then Return
	If Not MoveRunning(7.2,     -1072.6)  	Then Return
	If Not MoveRunning(-1752.7, -1209)    	Then Return
	If Not MoveRunning(-3596.9, -1671.8)  	Then Return
	If Not MoveRunning(-5386.6, -1526.4)  	Then Return
	If Not MoveRunning(-6904.2, -283.2)   	Then Return
	If Not MoveRunning(-7711.6, 364.9)    	Then Return
	If Not MoveRunning(-9537.8, 1265.4)   	Then Return
	If Not MoveRunning(-11141.2,857.4)    	Then Return
	If Not MoveRunning(-12730.7,371.5)    	Then Return
	If Not MoveRunning(-13379,  40.5)     	Then Return
	If Not MoveRunning(-14925.7,1099.6)   	Then Return
	If Not MoveRunning(-16183.3,2753)     	Then Return
	If Not MoveRunning(-17803.8,4439.4)   	Then Return
	If Not MoveRunning(-18852.2,5290.9)   	Then Return
	If Not MoveRunning(-19250,  5431)     	Then Return
	If Not MoveRunning(-19968, 5564) 		Then Return

	Move(-20076,  5580, 30)
	_WaitMapLoadingSwitchMode($MAP_ID_USING_AREA)
EndFunc

; Description: This is pretty much all, take bounty, do left, do right, kill, rezone ;by gigi
Func CombatLoop()
	;If Not $RenderingEnabled Then ClearMemory()

	If GetNornTitle() < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
		WaitFor(1000)
	EndIf

	ConsoleWrite(@CRLF & "Moving to aggro left")
;~ 	MoveTo(13501, -20925)
	MoveTo(13172, -22137)
	TargetNearestEnemy()
	MoveAggroing(12496, -22600)
	MoveAggroing(11375, -22761)
	MoveAggroing(10925, -23466)
	MoveAggroing(10917, -24311)
	MoveAggroing(9910, -24599)
	MoveAggroing(8995, -23177)
	MoveAggroing(8307, -23187)
	MoveAggroing(8213, -22829)
	MoveAggroing(8307, -23187)
	MoveAggroing(8213, -22829)
	MoveAggroing(8740, -22475)
	MoveAggroing(8880, -21384)
	MoveAggroing(8684, -20833)
	MoveAggroing(8982, -20776)

	ConsoleWrite(@CRLF & "Waiting for left ball")
	WaitUntilAllFoesAreInRange(550,15000)
	If GetDistance()<1000 Then
		UseSkillEx($Skill_Hos, -1)
	Else
		UseSkillEx($Skill_Hos, -2)
	EndIf
	Sleep(getping())
	WaitUntilAllFoesAreInRange(380,5000,$RANGE_SPELLCAST-100)
	SalvageSleep(1000)

	TargetNearestEnemy()

	ConsoleWrite(@CRLF & "Moving to aggro right")
	MoveAggroing(10196, -20124)
	MoveAggroing(9976, -18338)
	MoveAggroing(11316, -18056)
	MoveAggroing(10392, -17512)
	MoveAggroing(10114, -16948)
	MoveAggroing(10729, -16273)
	MoveAggroing(10810, -15058)
	MoveAggroing(11120, -15105)
	MoveAggroing(11670, -15457)
	MoveAggroing(12604, -15320)
	TargetNearestEnemy()
	MoveAggroing(12476, -16157)

	ConsoleWrite(@CRLF & "Waiting for right ball")

	WaitUntilAllFoesAreInRange(550,15000)
	If GetDistance()<1000 Then
		UseSkillEx($Skill_Hos, -1)
	Else
		UseSkillEx($Skill_Hos, -2)
	EndIf
	Sleep(getping())
	WaitUntilAllFoesAreInRange(380,5000)
	SalvageSleep(1000)

	ConsoleWrite(@CRLF & "Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)

	ConsoleWrite(@CRLF & "Killing")
	Kill()

	WaitFor(300)

	ConsoleWrite(@CRLF & "Looting")
	PickUpLoot()

	If Not GetIsDead(-2) Then $SucessfulLastRun = True

	ConsoleWrite(@CRLF & "Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

	While GetIsDead(-2)
		ConsoleWrite(@CRLF & "Waiting for res")
		Sleep(5500)
	WEnd

	Move(15865, -20531)
	_WaitMapLoadingSwitchMode($MAP_ID_BJORA)

	;MoveTo(-19968, 5564)
	Move(-20076,  5580, 30)
	Sleep(2500)
	_WaitMapLoadingSwitchMode($MAP_ID_USING_AREA)
	Out("Finished round")
EndFunc

;~ Description: use whatever skills you need to keep yourself alive. ;by gigi
; Take agent array as param to more effectively react to the environment (mobs)
Func StayAlive(Const ByRef $lAgentArray)
	If GetDistanceOfNearestEnemy() < 1600 Then
		If IsRecharged($Skill_Sf) Then
			UseSkillEx($Skill_paradox)
			UseSkillEx($Skill_Sf)
		EndIf
	EndIf

	Local $lMe = GetAgentByID(-2)
	Local $lEnergy = GetEnergy($lMe)
	Local $lAdjCount, $lAreaCount, $lSpellCastCount, $lProximityCount
	Local $lDistance
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
		If $lDistance < 1200*1200 Then
			$lProximityCount += 1
			If $lDistance < $RANGE_SPELLCAST_2 Then
				$lSpellCastCount += 1
				If $lDistance < $RANGE_AREA_2 Then
					$lAreaCount += 1
					If $lDistance < $RANGE_ADJACENT_2 Then
						$lAdjCount += 1
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	UseSF($lProximityCount)

	If IsRecharged($Skill_Shroud) Then
		If $lSpellCastCount > 0 And DllStructGetData(GetEffect($Skill_ID_Shroud), "SkillID") == 0 Then
			UseSkillEx($Skill_Shroud)
		ElseIf DllStructGetData($lMe, "HP") < 0.6 Then
			UseSkillEx($Skill_Shroud)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($Skill_Shroud)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($Skill_WayOfPerf) Then
		If DllStructGetData($lMe, "HP") < 0.5 Then
			UseSkillEx($Skill_WayOfPerf)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($Skill_WayOfPerf)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($Skill_Channeling) Then
		If $lAreaCount > 5 And GetEffectTimeRemaining($Skill_ID_Channeling) < 2000 Then
			UseSkillEx($Skill_Channeling)
		EndIf
	EndIf

	UseSF($lProximityCount)
EndFunc

;~ Description: Uses sf if there's anything close and if its recharged ;by gigi
Func UseSF($lProximityCount)
	If IsRecharged($Skill_Sf) And $lProximityCount > 0 Then
		UseSkillEx($Skill_paradox)
		UseSkillEx($Skill_Sf)
	EndIf
EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs ;by gigi
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		Sleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False

		StayAlive($lAgentArray)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			If $lHosCount > 6 Then
				Do	; suicide
					Sleep(100)
				Until GetIsDead(-2)
				Return False
			EndIf

			$lBlocked += 1
			If $lBlocked < 5 Then
				Move($lDestX, $lDestY, $lRandom)
			ElseIf $lBlocked < 10 Then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			ElseIf IsRecharged($Skill_Hos) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					UseSkillEx($Skill_Hos, -1)
				Else
					UseSkillEx($Skill_Hos, -2)
				EndIf
				$lBlocked = 0
				$lHosCount += 1
			EndIf
		Else
			If $lBlocked > 0 Then
				If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
				EndIf
				$lBlocked = 0
				$lHosCount = 0
			EndIf

			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					Sleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but target broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf
		If  ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) > 1100 Then autoSalvage()
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora ;by gigi
Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked

	Move($lDestX, $lDestY)

	Do
		WaitFor(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False

		If GetDistance($lMe, $lTgt) < 1300 And GetEnergy($lMe)>20 And IsRecharged($Skill_paradox) And IsRecharged($Skill_Sf) Then
			UseSkillEx($Skill_paradox)
			UseSkillEx($Skill_Sf)
		EndIf

		If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($Skill_Shroud) Then UseSkillEx($Skill_Shroud)

		If DllStructGetData($lMe, "HP") < 0.5 And GetDistance($lMe, $lTgt) < 500 And GetEnergy($lMe) > 5 And IsRecharged($Skill_Hos) Then UseSkillEx($Skill_Hos, -1)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc

;~ Description: Waits until all foes are in range (useless comment ftw) ;by gigi
Func WaitUntilAllFoesAreInRange($lRange = 400, $timeOut = 10*1000, $EnemyInMaxRange = $RANGE_SPELLCAST+200)
	Local $lAgentArray
	Local $lAdjCount, $lSpellCastCount
	Local $lMe
	Local $lDistance
	Local $lShouldExit = False
	Local $timeOutTimer = TimerInit()
	Local $aAgent
	Do
;~ 		Sleep(100)
		autoSalvage()
		$lMe = GetAgentByID(-2)
		If GetIsDead($lMe) Then Return
		If GetMapLoading() == 2 Then Disconnected()
		Local $lAgent, $lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
		If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
		Local $AgendDistanceArray[$lAgentArray[0]+1][2]
		For $i = 0 to UBound($AgendDistanceArray)-1
			$AgendDistanceArray[$i][0] = $lAgentArray[$i]
			$AgendDistanceArray[$i][1] = 0
		Next
		For $i = 1 To UBound($lAgentArray) -1
			$lAgent = $lAgentArray[$i]
			If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
			If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
			If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
			If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
			If GetDistance($lAgent) < $EnemyInMaxRange Then
				$AgendDistanceArray[$i][1] = GetDistance($lAgent)
			EndIf
		Next
		_ArraySort($AgendDistanceArray  ,1,1,0,1)
;~ 		_ArrayDisplay($AgendDistanceArray)
		ConsoleWrite(@CRLF & "-Ball Last Enemy Distance: " & Round($AgendDistanceArray[1][1])& @TAB & StringTrimRight(Round(TimerDiff($timeOutTimer),-3),3) & "sec")
		If $AgendDistanceArray[1][1] < $lRange Then
			ConsoleWrite(@CRLF & "!Ball True Last Enemy Distance: " & Round($AgendDistanceArray[1][1])& @TAB & StringTrimRight(Round(TimerDiff($timeOutTimer),-3),3) & "sec")
			$lShouldExit = True
		EndIf

	Until $lShouldExit Or TimerDiff($timeOutTimer) > $timeOut
	ConsoleWrite(@CRLF)


EndFunc

;~ Description: Waits until all foes are in range (useless comment ftw) ;by gigi
Func GetDistanceOfNearestEnemy($EnemyInMaxRange = $RANGE_COMPASS)
	Local $Distance = 99999
	If GetMapLoading() <> 1 Then Return
	Local $lAgent, $lAgentArray = GetAgentArray(0xDB)
	Local $AgendDistanceArray[$lAgentArray[0]+1][2]
	For $i = 0 to UBound($AgendDistanceArray)-1
		$AgendDistanceArray[$i][0] = $lAgentArray[$i]
		$AgendDistanceArray[$i][1] = $Distance
	Next
	For $i = 1 To UBound($lAgentArray) -1
		$lAgent = $lAgentArray[$i]
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		Local $lDistance = GetDistance($lAgent)
		If $lDistance < $EnemyInMaxRange Then $AgendDistanceArray[$i][1] = $lDistance
	Next
	_ArraySort($AgendDistanceArray ,0,1,0,1)
;~ 	ConsoleWrite(@CRLF & ">GetDistanceOfNearestEnemy: " & Round($AgendDistanceArray[1][1]))
	Return $AgendDistanceArray[1][1]
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part) ;by gigi
Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
	Local $lAgentArray
	Local $lTimer = TimerInit()
	Do
		Sleep(100)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
	Until TimerDiff($lTimer) > $lMs
EndFunc

;~ Description: BOOOOOOOOOOOOOOOOOM ;by gigi
Func Kill()
	If GetIsDead(-2) Then Return

	Local $lAgentArray
	Local $lDeadlock = TimerInit()

	TargetNearestEnemy()
	Sleep(100)
	Local $lTargetID = GetCurrentTargetID()

	While GetAgentExists($lTargetID) And DllStructGetData(GetAgentByID($lTargetID), "HP") > 0
		Sleep(50)
		If GetIsDead(-2) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)

		; Use echo if possible
		If GetSkillbarSkillRecharge($Skill_Sf) > 5000 And GetSkillbarSkillID($Skill_Echo)==$Skill_ID_Echo Then
			If IsRecharged($Skill_Wastrel) And IsRecharged($Skill_Echo) Then
				UseSkillEx($Skill_Echo)
				UseSkillEx($Skill_Wastrel, GetGoodTarget($lAgentArray))
				$lAgentArray = GetAgentArray(0xDB)
			EndIf
		EndIf

		UseSF(True)

		; Use wastrel if possible
		If IsRecharged($Skill_Wastrel) Then
			UseSkillEx($Skill_Wastrel, GetGoodTarget($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
		EndIf

		UseSF(True)

		; Use echoed wastrel if possible
		If IsRecharged($Skill_Echo) And GetSkillbarSkillID($Skill_Echo)==$Skill_ID_Wastrel Then
			UseSkillEx($Skill_Echo, GetGoodTarget($lAgentArray))
		EndIf

		; Check if target has ran away
		If GetDistance(-2, $lTargetID) > $RANGE_EARSHOT Then
			TargetNearestEnemy()
			Sleep(GetPing()+100)
			If GetAgentExists(-1) And DllStructGetData(GetAgentByID(-1), "HP") > 0 And GetDistance(-2, -1) < $RANGE_AREA Then
				$lTargetID = GetCurrentTargetID()
			Else
				ExitLoop
			EndIf
		EndIf

		If TimerDiff($lDeadlock) > 60 * 1000 Then ExitLoop
	WEnd
EndFunc

; Returns a good target for watrels ;by gigi
; Takes the agent array as returned by GetAgentArray(..)
Func GetGoodTarget(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > $RANGE_NEARBY Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

#cs
Func goingOutside()
	If GetMapID() <> $MAP_ID_USING_CITY Then RndTravel($MAP_ID_USING_CITY, $DistrictCheckboxes)
	Global $Me = GetAgentByID(-2)
	If ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'),3170.85 ,2212.31 ) < 750 Then ; standing at merchant
		MoveTo(480, 18)
		MoveTo($SpawnPointUsingGateX, $SpawnPointUsingGateY)
	ElseIf ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $SpawnPointUsingGateX, $SpawnPointUsingGateY) > 750 Then
		SetUpFastWay()
		If Not $BotRunning Then Return
	EndIf
	$AverageTimer = TimerInit()
	Move($TriggerUsingGateX, $TriggerUsingGateY, 20)
	Sleep(1000)
	_WaitMapLoadingSwitchMode($MAP_ID_USING_AREA)
	If GetMapLoading() = 0 Then Return False ;--> City
EndFunc
#ce

#cs
Func RunToKillSpot()
	Local $myMatModelID = getMatIDByName('Bone')
	Local $curentMatAmount = CountInventory_ChestMaterial($myMatModelID)

;~ 	Local $me = GetAgentByID()
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
	;start at 18691  11381
	;jump1
;~ 	ConsoleWrite(@CRLF & '1. Moverun' & @CRLF)
	If (GetEffectTimeRemaining($Skill_ID_Vos) = 0) Then UseSkillEx($Skill_Vos,-2)
	MoveRun(18308,11647)
;~ 	ConsoleWrite(@CRLF & 'TargetNearestEnemy()' & @CRLF)
	TargetNearestEnemy()
;~ 	Sleep(getping())
	TargetNextEnemy()
;~ 	Sleep(getping())
	TargetNextEnemy()
	Sleep(getping()+400)
;~ 	ConsoleWrite('jump1 Distance = ' & GetDistance() & @CRLF)
	If 650 < GetDistance() And GetDistance() < 2550 Then
		If (GetEffectTimeRemaining($Skill_ID_SandShards) = 0) Then UseSkillEx($Skill_SandShards,-2)
		If 106 < getAngleAtA() And getAngleAtA() < 175 Then UseSkillEx($Skill_DC,-1)
	EndIf
	Sleep(1250)
	kill(800)
	;zur 2. Gruppe
	MoveRun(15105, 13262,50,False,True) ;vor brücke
	If GetEffectTimeRemaining($Skill_ID_SandShards) = 0 Then UseSkillEx($Skill_SandShards,-2)
;~ 	MoveRun(12656, 13545,30,True,True) ;ende brücke
	MoveRun(12304, 13753,30,True,True)

	;=== kill group 2 ===
	If (GetEffectTimeRemaining($Skill_ID_Vos) = 0) And (GetEffectTimeRemaining($Skill_ID_Renewal) = 0) Then
			UseSkillEx($Skill_Vos,-2)
			UseSkillEx($Skill_Renewal,-2)
	EndIf
	TargetNearestEnemy()
	Sleep(getping()+250)
	Local $nextEnemy = GetAgentByID(-1)
	Local $nextX = DllStructGetData($nextEnemy,"X") + 400
	Local $nextY = DllStructGetData($nextEnemy,"Y") + 500
	;XX
	;11674.21
	;10927.21
	;YY
	;14673.89
	;13298.89
	ConsoleWrite(@CRLF & "- NextX " & Round($nextX) & @TAB & "- NextY "& Round($nextY))
	If  10400 < $nextX And $nextX < 11700 And 13300 < $nextY  And $nextY < 15100 Then
		ConsoleWrite(@TAB & "- Spot in rect -> dynamic moveTo" & @CRLF)
		MoveRun($nextX, $nextY, 20, False, False)
	Else
		MoveRun(11172.75,14195.38,20)
	EndIf

	If (GetEffectTimeRemaining($Skill_ID_Vos) = 0) Then UseSkillEx($Skill_Vos,-2)
	Sleep(1500)
	kill(800)

	;=== go to group 3 ===
;~ 	MoveRun(12304, 13753,30,True,True)
	If GetSkillbarSkillRecharge($Skill_ID_Renewal) = 0 Then UseSkillEx($Skill_Renewal,-2)
	MoveRun(10855, 17032,30,True,True) ;before gate
	If GetSkillbarSkillRecharge($Skill_SandShards) = 0 Then UseSkillEx($Skill_SandShards,-2)
	MoveRun(10038.25, 18615.12,30,True,True) ; behind gate
;~ 	MoveRun(8971, 19298,50,True) ; Kurve 1
	TargetNearestEnemy()
	TargetNextEnemy()
	TargetNextEnemy()
	Sleep(getping()+100)
;~ 	ConsoleWrite('jump2 Distance = ' & GetDistance() & @CRLF)
	If 650 < GetDistance() And GetDistance() < 2550 Then
;~ 		Sleep(2999) ;good to test stuck funktion - do not jump
		If 90 < getAngleAtA() And getAngleAtA() < 200 Then UseSkillEx($Skill_DC,-1)
	EndIf
	If (GetEffectTimeRemaining($Skill_ID_Vos) = 0) Then UseSkillEx($Skill_Vos,-2)
	Sleep(600)
	kill(800)
;~ 	MoveRun(7896, 18858,50,True) ; kurve 2
	;zur 4. Grupp
	MoveRun(4762, 17082,50,False,True) ;ende rezz schrein
	MoveRun(1501, 16191,30,True,True)
;~ 	If GetSkillbarSkillRecharge($Skill_Vos) = 0 Then UseSkillEx($Skill_Vos)
	Moverun(971,15826)
	Moverun(762,15521,70)
	MoveRun(702,15000,90)
	Kill(800,False)

	ConsoleWrite(@CRLF & ">add " & (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount) & " Bone")
	$BoneCount += (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount)
	GUICtrlSetData($BoneCountLable,$BoneCount)

EndFunc
#ce

#cs
Func KillRectangle()
	Local $myMatModelID = getMatIDByName('Bone')
	Local $curentMatAmount = CountInventory_ChestMaterial($myMatModelID)

	Local $me = GetAgentByID(-2)
	If GetMapLoading() == 2 Then Disconnected()
	If GetIsDead(-2) Then Return
	If GetMapID() == $MAP_ID_Jokanur Then Return
	Sleep(getping())
	MoveRun(1498, 14045)
;~ 	GetFarthestEnemyToAgent_Number_Agent_Dist_Lvl(4,-2,2000,2)
	If GetSkillbarSkillRecharge($Skill_Vos) = 0 Then UseSkillEx($Skill_Vos)
	MoveTo(2400-50, 14297,30)
	If GetSkillbarSkillRecharge($Skill_Force) = 0 Then UseSkillEx($Skill_Force)
	GetFarthestEnemyToAgent_Number_Agent_Dist_Lvl(4,-2,2000,2)
	Sleep(getping())
	UseSkillEx($Skill_DC,-1)
	Sleep(getping())
	UseSkillEx($Skill_Renewal,-2)
	Sleep(getping()+100)
	ChangeWeaponSet($WEAPON_SLOT_SCYTHE)
	Sleep(getping()+100)
	While GetNumberOfLvlXSkalsInRangeOfAgent(-2,1300) > 0
		If GetMapLoading() == 2 Then Disconnected()
		If GetIsDead(-2) Then Return
		TargetNearestEnemy()
		Sleep(getping())
		attack(-1)
		If GetEffectTimeRemaining($Skill_ID_Vos)  = 0 Then UseSkillEx($Skill_Vos)
		If GetEffectTimeRemaining($Skill_ID_SandShards)  = 0 Then UseSkillEx($Skill_SandShards)
		If GetSkillbarSkillRecharge($Skill_Force) = 0 Then
			UseSkillEx($Skill_Force)
;~ 			If GetSkillbarSkillRecharge($Skill_Eremite) = 0 Then UseSkillEx($Skill_Eremite,-1)
		EndIf
		If GetSkillbarSkillRecharge($Skill_Renewal) = 0 Then UseSkillEx($Skill_Renewal)
	WEnd
	CancelAction()
	Sleep(getping())
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
	Sleep(getping())
	ConsoleWrite("pickup, ")
;~ 	PickUpLoot()
	$SucessfulLastRun = True

	ConsoleWrite(@CRLF & ">add " & (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount) & " Bone")
	$BoneCount += (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount)
	GUICtrlSetData($BoneCountLable,$BoneCount)


EndFunc
#ce

#cs
Func Kill($killrange = 1200, $useVOS = True)
	If	GetNumberOfFoesInRangeOfAgent(-2,$killrange) = 0 Then Return
	If GetMapLoading() == 2 Then Disconnected()
	If GetIsDead(-2) Then Return
	If GetMapID() == $MAP_ID_Jokanur Then Return
	Local $Me = GetAgentByID(-2)
	Sleep(getping()+100)
	ChangeWeaponSet($WEAPON_SLOT_SCYTHE)
	Sleep(getping())
	If GetNumberOfFoesInRangeOfAgent(-2,$killrange) > 1 And GetEffectTimeRemaining($Skill_ID_SandShards) = 0 And GetSkillbarSkillRecharge($Skill_SandShards) = 0 Then UseSkillEx($Skill_SandShards,-2)
	Sleep(getping())
	While GetNumberOfFoesInRangeOfAgent(-2,$killrange) > 0
		If GetMapLoading() == 2 Then Disconnected()
		If GetIsDead(-2) Then Return
		TargetNearestEnemy()   ;very slow if stuck
		If DllStructGetData($Me, "HP") < 0.4 And GetSkillbarSkillRecharge($Skill_DC) = 0 Then UseSkillEx($Skill_DC)
		If GetNumberOfFoesInRangeOfAgent(-2,$killrange) > 1 And GetEffectTimeRemaining($Skill_ID_SandShards) = 0 And GetSkillbarSkillRecharge($Skill_SandShards) = 0 Then UseSkillEx($Skill_SandShards,-2)
		If (GetEffectTimeRemaining($Skill_ID_Vos) = 0) And $useVOS Then UseSkillEx($Skill_Vos,-2)
		If GetSkillbarSkillRecharge($Skill_Force) = 0 Then
			UseSkillEx($Skill_Force)
			If (GetSkillbarSkillRecharge($Skill_Eremite) = 0) And (GetEffectTimeRemaining($Skill_ID_Force) > 0) Then
				UseSkillEx($Skill_Eremite,-1)
			EndIf
		EndIf
		Sleep(getping())
		Attack(-1)
	WEnd
	Sleep(getping())
	CancelAction()
	Sleep(100)
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
	Sleep(getping())
	PickUpLoot()
EndFunc
#ce

#cs
Func killIfStuck($lDestX,$lDestY,$lRandom = 50)
	ConsoleWrite(@CRLF & @TAB & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " &'_________killIfStuck_________')
   ConsoleWrite(@CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " &'$lDestX ' & $lDestX & @TAB & '$lDestY ' & $lDestY & @TAB & '$lRandom ' & $lRandom & @CRLF)

	If GetMapLoading() == 2 Then Disconnected()
	If GetIsDead(-2) Then Return

	Local $lBlocked = 0
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

;~ 	ConsoleWrite('Me: MoveX = ' & DllStructGetData(GetAgentByID(-2), 'MoveX') & @TAB)
;~ 	ConsoleWrite('MoveY = ' & DllStructGetData(GetAgentByID(-2), 'MoveY') & @TAB)
;~ 	ConsoleWrite('$lBlocked = ' & $lBlocked & @CRLF)
	Do
		Sleep(100)
		Local $Me = GetAgentByID(-2)
		ConsoleWrite(@TAB & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " &'HP: ' & Round(DllStructGetData($Me, "HP"),2) & @TAB)
		ConsoleWrite("ComputeDistance(...) " & Round(ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $lDestX, $lDestY),2)& @TAB)
		ConsoleWrite("MoveX " & Round(DllStructGetData($Me, 'MoveX')) & @TAB &  'MoveY ' & Round(DllStructGetData($Me, 'MoveX')) & @CRLF)

		If DllStructGetData($Me, 'MoveX') == 0 And DllStructGetData($Me, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY, $lRandom)
		EndIf
;~ 		ConsoleWrite('Me: MoveX = ' & DllStructGetData($Me, 'MoveX') & @TAB)
;~ 		ConsoleWrite('MoveY = ' & DllStructGetData($Me, 'MoveY') & @TAB)
;~ 		ConsoleWrite('$lBlocked = ' & $lBlocked & @CRLF)
		If $lBlocked > 5 Then

			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				ConsoleWrite('/Stuck, ')
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()

				$lBlocked = 0
			EndIf
			ConsoleWrite(' I WILL KILL NOW!!! ' & @CRLF)
			Kill(400)
		EndIf
		If GetMapLoading() == 2 Then Disconnected()
		If GetIsDead(-2) Then Return
		Sleep(getping())
		_runFast()
		Move($lDestX, $lDestY, $lRandom)

	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $lDestX, $lDestY) < 600

EndFunc
#ce

#cs
Func Setup()
   If GetMapID() <> $MAP_ID_Jokanur Then
	  Out("Travelling to Jokanur")
	  RndTravel($MAP_ID_Jokanur, $DistrictCheckboxes)
;~ 	  ConsoleWrite('_WaitMapLoadingSwitchMode($MAP_ID_Jokanur)....  ')
;~ 	  _WaitMapLoadingSwitchMode($MAP_ID_Jokanur)
;~ 	  ConsoleWrite('loaded' & @CRLF)
	EndIf
	Out("Loading skillbar")
	LoadSkillTemplate($template)
	LeaveGroup()
	SwitchMode($HmOrNm)
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
	Sleep(GetPing() + 500)
	Local $Me = GetAgentByID(-2)
	Local $X = DllStructGetData($Me, 'X')
	Local $Y = DllStructGetData($Me, 'Y')
	If ComputeDistance($X, $Y, $SpawnPoint0X, $SpawnPoint0Y) > 750 Then
		SetUpFastWay()
	EndIf
	Out("Setup done")
EndFunc
#ce

#cs
Func _runFast()
	If GetMapLoading() == 2 Then Disconnected()
	If GetIsDead(-2) Then Return
	Local $Me = GetAgentByID(-2)
;~ 	Sleep(getping())
	If IsRecharged($Skill_Renewal) And GetEffectTimeRemaining($Skill_ID_Renewal) <= 1000 Then UseSkillEx($Skill_Renewal)
;~ 	If GetSkillbarSkillRecharge($Skill_Dash) == 0 And GetEffectTimeRemaining($Skill_ID_PiousHaste) == 0 Then
;~ 		UseSkillEx($Skill_Dash)
;~ 		Sleep(GetPing()+100)
;~ 	EndIf
	If GetSkillbarSkillRecharge($Skill_PiousHaste) == 0 Then
		If GetEffectTimeRemaining($Skill_ID_DwarvenStab) < 100 Then UseSkillEx($Skill_DwarvenStab)
		Sleep(getping()/5)
		UseSkillEx($Skill_PiousHaste)
	EndIf
EndFunc
#ce

#cs
Func MoveRun($DestX, $DestY, $_Random = 50,$shouldKillIFStuck = True, $shouldSalvage = False)
   Local $Me = GetAgentByID(-2), $lBlocked = 0
   Move($DestX, $DestY, $_Random)
;~    Sleep(getping())
	Do
		If TimerDiff($AverageTimer) > 3*60*1000 Then resign() ;need only 2min for a run
		If GetMapLoading() == 2 Then Disconnected()
		If GetIsDead(-2) Then Return
		If GetMapID() == $MAP_ID_Jokanur Then Return

		Local $Me = GetAgentByID(-2)
		;running skills
		_runFast()
		;überlebens skills

		; use a timer to avoid spamming /stuck
		If DllStructGetData($Me, "HP") < 0.6 And TimerDiff($ChatStuckTimer) > 6000 Then
				ConsoleWrite(@CRLF & 'send /Stuck' & @CRLF)
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
		EndIf

		If DllStructGetData($Me, 'MoveX') == 0 And DllStructGetData($Me, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($DestX, $DestY, $_Random)
			Sleep(getping()+100)
		EndIf

		If $lBlocked > 5 Then

			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				ConsoleWrite('/Stuck, ')
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()

				$lBlocked = 0
			EndIf
			ConsoleWrite(' I WILL KILL NOW!!! ' & @CRLF)
			If $shouldKillIFStuck Then Kill(500)
		EndIf


		If  ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) > 1100 Then autoSalvage()

;~ 		Sleep(GetPing())
;~ 		ConsoleWrite( 'Me: ' & DllStructGetData($Me, 'X') & ',' & DllStructGetData($Me, 'Y')& @TAB)
;~ 		ConsoleWrite( ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) & @CRLF )
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) < 250
EndFunc
#ce

#cs
Func Gather()
;	$template = "OgcTcZ885RgpzOgsShzzB5E6AA"
	Local  $lMe = GetAgentByID(-2)
	Local $aDMossArray[2]
	Local $myMatModelID = getMatIDByName('Plant_Fiber')
	Local $curentFiberAmount = CountInventory_ChestMaterial($myMatModelID)
	$aDMossArray[0] = 1
	UseSkill($Skill_ZHaste, -2)
	Move(-8396,18497,20)

	autoSalvage()
	Sleep(700)
;~ 	Sleep(1000)
	If GetMapLoading() <> 1 Then Return False
	UseSkillEx($Skill_Return,GetNearestNPCToAgent(-2))
	Local $IAmAKurzick = (GetKurzickFaction() > GetLuxonFaction())
	If (GUICtrlRead($getBlessingCheckbox) == $GUI_CHECKED) And $IAmAKurzick Then
		getBlessing()
		For $i = 1 To 16 ;4sec
			Move(-6243, 17180, 5)
			Sleep(250)
		Next
	ElseIf Not $IAmAKurzick Then
		WriteChat("Hey, run with more Kurzick Faction!", $CharName)
		MoveTo(-7972, 18290, 5)
		Move(-6243, 17180, 5)
		Sleep(3200)
;~ 		Sleep(4000)
	Else
		Move(-6243, 17180, 5)
		autoSalvage()
		Sleep(3700)
;~ 		Sleep(4000)

	EndIf
	Move(-6243, 17180, 5)
	If Not getDragonMossGroups() Then Return False

	autoSalvage()
	Sleep(700)
;~ 	Sleep(1000)

	$aDMossArray[1] = GetAgentByID(getNearestDMoss(True,False,False))
	Local $DMossPos[2] = [DllStructGetData($aDMossArray[1],"X"),  DllStructGetData($aDMossArray[1],"Y")]
	$myDistance1 = GetDistance(getNearestDMoss(True,False,False))
	ConsoleWrite(@CRLF & ">Distance1: " & Round($myDistance1))
	ConsoleWrite(@TAB & "x: " &  Round($DMossPos[0])  & "  y: " &  Round($DMossPos[1]))
	If $myDistance1 < 1700 Then
		UseSkillEx($Skill_Shroud, -2)
		Move(-6243, 17180, 2)
	EndIf
	Sleep(300)
	$aDMossArray[1] = GetAgentByID(getNearestDMoss(True,False,False))
	$myDistance2 = GetDistance(getNearestDMoss(True,True,False))
	ConsoleWrite(@CRLF & ">Distance2: " & Round($myDistance2))
	ConsoleWrite(@TAB & "x: " &  Round(DllStructGetData($aDMossArray[1],"X"))  & "  y: " &  Round(DllStructGetData($aDMossArray[1],"Y")))
	If $myDistance2 < 1600 Then  ; failed one with 1520 cause pulling aggro while casting sf
		UseSkill($Skill_SQ, -2)
		UseSkillEx($Skill_SF, -2)
	EndIf

	If Not _MoveTo(-6243, 17180, 1) Then Return False  ; standing at Killspot
	If GetSkillBarSkillRecharge($Skill_Shroud) = 0 Then
		UseSkill($Skill_Shroud, -2)
		Sleep(500)
	EndIf
	If GetSkillBarSkillRecharge($Skill_SQ) = 0 Then UseSkill($Skill_SQ, -2)
	If GetSkillBarSkillRecharge($Skill_SF) = 0 Then UseSkillEx($Skill_SF, -2)
	Sleep(50)
	UseSkill($Skill_Soh, -2)

	Move(-5208, 15835,20)
	Sleep(1200)
	$aDMossArray[1] = GetAgentByID(getNearestDMoss(True,True,False))
	$myDistance3 = GetDistance(getNearestDMoss(True,True,False, -6200, 15800))
	ConsoleWrite(@CRLF & ">Distance3: " & Round($myDistance3) )
	ConsoleWrite(@TAB & "x: " &  Round(DllStructGetData($aDMossArray[1],"X")) & "  y: " &  Round(DllStructGetData($aDMossArray[1],"Y")) & @CRLF)

	Local $DMossPos[2] = [DllStructGetData($aDMossArray[1],"X"),  DllStructGetData($aDMossArray[1],"Y")]
	If ($DMossPos[0] < -5100 And $DMossPos[1] < 16100) Or $myDistance3 < 1300 Then
;~ 		ConsoleWrite(@CRLF & "-----------shoultMove  X:  " & @TAB & ($DMossPos[0]-180) & @TAB & "Y:  " & @TAB & ($DMossPos[1]-125))
		Local $DMossPos2[2] = [($DMossPos[0]-300), ($DMossPos[1]-225)]
		If $DMossPos2[0] > -5100 And $DMossPos2[1] > 16100 Then
			$DMossPos2[0] = -5400
			$DMossPos2[1] = 15875
		EndIf
		Local $EnemyArray = GetAgentArray(0xDB)
		If Not _MoveToAggroEnemy($DMossPos2[0], $DMossPos2[1], 9 , $EnemyArray,  10) Then Return False
		$aDMossArray[1] = GetAgentByID(getNearestDMoss(False,False,True, -3583, 15566))
		Local $DMossPos[2] = [DllStructGetData($aDMossArray[1],"X"),  DllStructGetData($aDMossArray[1],"Y")]
;~ 		ConsoleWrite(@CRLF & "------Final  X: " & Round($DMossPos[0]) & @TAB & "Y:  " & Round($DMossPos[1]) )
		Move($DMossPos[0], ($DMossPos[1]) , 10) ;now go back
		Local $aggrodeadlock = TimerInit()
		Do
			If GetMapLoading() == 2 Then Disconnected()
			If GetMapLoading() == 0 Then Return False
			$lMe = GetAgentByID(-2)
			If GetIsDead($lMe) Then ExitLoop
			Sleep(100)
;~ 			ConsoleWrite(@CRLF & @TAB & "GetADanger  " &  GetAgentDanger($lMe, $aDMossArray) & @TAB & "dist:  " & Round(GetDistance(getNearestDMoss(False,False,True)),2))
		Until GetAgentDanger($lMe, $aDMossArray) > 8 Or GetDistance(getNearestDMoss(False,False,True)) < 990 Or TimerDiff($aggrodeadlock) > 5000

;~ 		_MoveToAggroEnemy($DMossPos2[0], $DMossPos2[1], 9,$EnemyArray, 10) ; -> go back if got more than 2 groups
		If DllStructGetData($lMe,"X") > $DMossPos2[0] Or DllStructGetData($lMe,"Y") < $DMossPos2[1] Then
;~ 			out("me_X " & Round(DllStructGetData($lMe,"X")))
;~ 			out("me_Y " & Round(DllStructGetData($lMe,"Y")))
;~ 			out("DMP2_X " & Round($DMossPos2[0]))
;~ 			out("DMP2_X " & Round($DMossPos2[1]))
			If Not _MoveTo($DMossPos2[0], $DMossPos2[1], 10) Then Return False
		EndIf
	Else
		$aDMossArray[1] = GetAgentByID(getNearestDMoss(False,False,True))

		Local $DMossPos[2] = [DllStructGetData($aDMossArray[1],"X"),  DllStructGetData($aDMossArray[1],"Y")]
		Move($DMossPos[0], $DMossPos[1] + 100, 10) ;now go back
		Local $aggrodeadlock = TimerInit()
		Do
			If GetMapLoading() == 2 Then Disconnected()
			$lMe = GetAgentByID(-2)
			If GetIsDead($lMe) Then ExitLoop
			Sleep(100)
;~ 			ConsoleWrite(@CRLF & @TAB &@TAB & "GetAgentDanger  " &  GetAgentDanger($lMe, $aDMossArray) & @TAB & "dist:  " &GetDistance($aDMossArray[1]) )
		Until GetAgentDanger($lMe, $aDMossArray) > 8 Or GetDistance($aDMossArray[1]) < 990 Or TimerDiff($aggrodeadlock) > 5000
	EndIf

	;secnd pullpoint for a better ball
;~ 	MoveAggroing(-6559, 18389, 5) ;big step ;worse than medium step
;~ 	MoveAggroing(-6580, 18471, 5) ;medium step ;worse than small step
	If Not MoveAggroing(-6605, 18547, 5) Then Return False ;small step
	WaitFor(300)
	If Not MoveAggroing(-6622, 18622, 5) Then Return False
	WaitFor(500)
	$FiberDropsCount += (CountInventory_ChestMaterial($myMatModelID) - $curentFiberAmount)
	GUICtrlSetData($FiberDropsCountLable,$FiberDropsCount)

EndFunc
#ce

#cs
Func Kill()
	If GetIsDead(-2) Then Return
	If GetMapLoading() == 0 Then Return False ;--> City
	UseSkill($Skill_Whirling, -2)
	Sleep(GetPing()+50)
	Local $Me = GetAgentByID(-2)
	Local $myMatModelID = getMatIDByName('Plant_Fiber')
	Local $curentFiberAmount = CountInventory_ChestMaterial($myMatModelID)
	If ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), -6243, 17180) > 50 Then
		_MoveTo(-6243, 17180, 2)
	EndIf

	If GetEffectTimeRemaining(826) >= 4200 Then
		UseSkillEx($Skill_Winnowing)
	ElseIf GetEffectTimeRemaining(826) < 4200 Then
		Do
			If TimerDiff($AverageTimer) > 2*60*1000 Then resign()
			Sleep(50)
			If GetIsDead(-2) Then Return
		Until GetSkillBarSkillRecharge($Skill_SF) = 0
		UseSkillEx($Skill_SF)
		UseSkillEx($Skill_Winnowing)
	EndIf
	Sleep(GetPing())
	$Me = GetAgentByID(-2)

;~ 	TargetNearestEnemy()
	Local $lTargetID = GetCurrentTargetID()
	Local $Deadlock = TimerInit()
	Sleep(200 + GetPing())
	Local $killCount = 0
	Local $killedArray[3][4]
	Local $lowestHp = 1
	While $killCount < 12
		If GetIsDead(-2) Then Return
		LastSF()
;~ 		autoSalvage()
		For $j = 0 to 2
			For $i = 0 to 3
				If Not $killedArray[$j][$i] Then
					If DllStructGetData(GetAgentByID($lAgentGroup[$j][$i]), "HP") < $lowestHp Then
						$lowestHp = DllStructGetData(GetAgentByID($lAgentGroup[$j][$i]), "HP")
					EndIf
					If GetIsDead($lAgentGroup[$j][$i]) Then
						$killedArray[$j][$i] = True
						$killCount += 1
						$lowestHp = 1
					EndIf
				EndIf
			Next
		Next
;~ 		ConsoleWrite(@CRLF & "---------$lowestHp------- " & Round($lowestHp,3) & @TAB & $killCount&  @CRLF)
		If TimerDiff($Deadlock) > 15*1000 Then ExitLoop
;~ 			resign()
;~ 			Sleep(3000)
;~ 		EndIf
		If $killCount >= 7 And $lowestHp > 0.2 Then ExitLoop
		Sleep(250)
	WEnd
	Sleep(GetPing()+350)
	$FiberDropsCount += (CountInventory_ChestMaterial($myMatModelID) - $curentFiberAmount)
	GUICtrlSetData($FiberDropsCountLable,$FiberDropsCount)
EndFunc
#ce

Func PickUpLoot($Range = 1350)
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $j = 1 To 2
		For $i = 1 To GetMaxAgents()
			If GetIsDead(-2) Then Return
			$lAgent = GetAgentByID($i)
			If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
			If GetDistance($lAgent) > $Range Then ContinueLoop
			$lItem = GetItemByAgentID($i)
			Local $lAgentArray = GetAgentArray(0xDB)
			StayAlive($lAgentArray)
			If CanPickup($lItem) Then
				PickUpItem($lItem)
				$lDeadlock = TimerInit()
;~ 				If TimerDiff($AverageTimer) > 3*60*1000 Then resign() ;only need 2min for a run
				While GetAgentExists($i)
					Sleep(100)
					If GetIsDead($Me) Then Return
					If TimerDiff($lDeadlock) > 3000 Then ExitLoop
				WEnd
			EndIf
		Next
	Next
;~ 	If Not $SucessfulLastRun  Then $SucessfulLastRun = True
EndFunc   ;==>PickUpLoot

Func BackToTown()
	If GetMapID() == $MAP_ID_USING_AREA Then
		Resign()
		Sleep(GetPing()*2+3300)
		ReturnToOutpost()
		Sleep(1000)
		If Not _WaitMapLoadingSwitchMode($MAP_ID_USING_CITY) Then RndTravel($MAP_ID_USING_CITY, $DistrictCheckboxes)
	EndIf
EndFunc

; _______ EndMain _______
#cs
Func getBlessing()
	If GetMapLoading() == 0 Then Return False ;--> City
	If GetGoldCharacter() > 99 And  GetKurzickFaction() < GetMaxKurzickFaction() Then
;~ 		Local $Priest = GetNearestNPCToAgent()
		GoNPC(GetNearestNPCToAgent(-2))
		Sleep(GetPing()*2+100)
		Dialog(0x85)
		Sleep(GetPing()*2+100)
		Dialog(0x86)
		addToPlatinCount(-100)
		Return True
	Else
		Return False
	EndIf
EndFunc
#ce

#cs
Func MoveAggroing($lDestX, $lDestY, $lRandom = 20)
	If GetIsDead(-2) Then Return
	If GetMapLoading() == 2 Then Disconnected()
	If GetMapLoading() == 0 Then Return False ;--> City
	Local $lMe, $lAgentArray, $lBlocked
	Local $stuckTimer = TimerInit()


	Move($lDestX, $lDestY, $lRandom)

	Do
		Sleep(100)


		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY, $lRandom)
		EndIf

		If $lBlocked > 5 Then
			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
				MoveBackward(1)
				Sleep(500)
				MoveBackward(0)
				StrafeRight(1)
				Sleep(1500)
				StrafeRight(0)
				$lBlocked = 0
			EndIf
		EndIf

		Sleep(GetPing()+100)

		$lMe = GetAgentByID(-2)

		If GetIsDead($lMe) Then Return

		StayAlive()

		Move($lDestX, $lDestY, $lRandom)
		Local $myX = DllStructGetData($lMe, 'X')
		Local $myY = DllStructGetData($lMe, 'Y')
		Local $Distance = Sqrt(($myX - $lDestX)^2 + ($myY - $lDestY)^2)
		ConsoleWrite(@CRLF & "-Distance " & Round($Distance))
		If $Distance > 800 Then
			ConsoleWrite(@TAB & " -> autosalvage")
			Sleep(GetPing())
			autoSalvage()
		EndIf
		ConsoleWrite(@TAB & "(#__#)GetAgentDanger " & @TAB & GetAgentDanger($lMe, GetAgentArray(0xDB)))

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	ConsoleWrite(@CRLF)
	Return True
EndFunc

Func LastSF()
	If GetIsDead($Me) Then Return False

	If IsRecharged($Skill_SF) And GetEffectTimeRemaining(826) < 1300 Then
		UseSkillEx($Skill_SF)
	 EndIf
	 Return True
EndFunc

Func StayAlive()
	If GetIsDead($Me) Then Return

	If IsRecharged($Skill_SF) And GetEffectTimeRemaining(826) < 1000 Then
		UseSkillEx($Skill_SF)
	EndIf
EndFunc

Func WaitFor($lMs)
	If GetIsDead(-2) Then Return
;~ 	If GetMapLoading() == 2 Then Disconnected()
	Local $lAgentArray
	Local $lTimer = TimerInit()
	Do
		Sleep(100)
		If GetIsDead(-2) Then Return
		StayAlive()
	Until TimerDiff($lTimer) > $lMs
EndFunc

Func GoodShield($lModelID, $lRarity)
   If $lModelID == $ITEM_ID_ECHOVALD And $lRarity == $RARITY_GOLD Then Return True
   Return False
EndFunc
#ce

Func Merchant()
	Local $MerchantTimer = TimerInit()
	If GetMapLoading() == 2 Then Disconnected()
;~ 	If GetMapLoading() <> 0 Then Return False
	Out("== Merchant ==")
	If GUICtrlRead($useGhCheckbox) == $GUI_CHECKED Then
		TravelGH()
	Else
		If GetMapID() <> $MAP_ID_USING_CITY Then RndTravel($MAP_ID_USING_CITY, $DistrictCheckboxes)
	EndIf
	GoToMerchant()
	Out("Identifying Items")
	_Ident()
	Out("Depositing Gold")
	DepositGold()
	Out("Selling Items")
	_Sell()
;~ 	_DonateFaction()
;~ 	#cs
	Local $tabNr = getTabNrByName("SalvageTab")
	If $SalvageRunning Then
		out("Buy KITs to run")
		countItems()
		Local $FreeInvSlots = _CountFreeSlots()
		Local $GDIIndex = 1 ;Iron Items
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
			If $FreeInvSlots > 25 Then
				If $SalvageCount < 300 Then
					Local $Quantity = 12 - Int($SalvageCount/25)
					If GetGoldCharacter() < $Quantity * 100 AND GetGoldStorage() >$Quantity * 100 Then
							WithdrawGold($Quantity * 100)
							Sleep(500)
					EndIf
					If GetGoldCharacter() >= $Quantity * 100 Then
						out("Buy " & $Quantity & " Salvage")
						BuySalvageKit($Quantity)
						addToPlatinCount($Quantity * -100)
						Sleep(500)
						countItems()
					EndIf
				EndIf
				If $IdentCount < 100 Then
					Local $Quantity = 1
					If GetGoldCharacter() < $Quantity * 500 AND GetGoldStorage() >$Quantity * 500 Then
							WithdrawGold($Quantity * 500)
							Sleep(500)
					EndIf
					If GetGoldCharacter() >= $Quantity * 500 Then
						out("Buy " & $Quantity & " IdKit")
						BuyIdentKit($Quantity)
						addToPlatinCount($Quantity * -500)
						Sleep(500)
						countItems()
					EndIf
				EndIf
			EndIf
		EndIf
		Local $GDIIndex = 5 ;Skale_Teeth
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
			If $FreeInvSlots > 20 Then
				If $SalvageCount < 10 Then
					BuySalvageKit()
					out("Buy 1 Salvage")
					addToPlatinCount(-100)
					Sleep(500)
					countItems()
				EndIf
				If $SalvageCount < 250 Then
					Local $Quantity = 10 - Int($SalvageCount/25)
					If GetGoldCharacter() < $Quantity * 100 AND GetGoldStorage() >$Quantity * 100 Then
							WithdrawGold($Quantity * 100)
							Sleep(500)
					EndIf
					If GetGoldCharacter() >= $Quantity * 100 Then
						out("Buy " & $Quantity & " Salvage")
						BuySalvageKit($Quantity)
						addToPlatinCount($Quantity * -100)
						Sleep(500)
						countItems()
					EndIf
				EndIf
			EndIf
		EndIf
		Local $GDIIndex = 6 ;Skale_Claw
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
			If $FreeInvSlots > 20 Then
				If $SalvageCount < 10 Then
					out("Buy 1 Salvage")
					BuySalvageKit()
					addToPlatinCount(-100)
					Sleep(500)
					countItems()
				EndIf
				If $SalvageCount < 100 Then
					Local $Quantity = 4 - Int($SalvageCount/25)
					If GetGoldCharacter() < $Quantity * 100 AND GetGoldStorage() >$Quantity * 100 Then
							WithdrawGold($Quantity * 100)
							Sleep(500)
					EndIf
					If GetGoldCharacter() >= $Quantity * 100 Then
						out("Buy " & $Quantity & " Salvage")
						BuySalvageKit($Quantity)
						addToPlatinCount($Quantity * -100)
						Sleep(500)
						countItems()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If GetMapID() <> $MAP_ID_USING_CITY Then
		RndTravel($MAP_ID_USING_CITY, $DistrictCheckboxes)
;~ 		SetUpFastWay()
	Else
		MoveTo(480, 18)
		MoveTo($SpawnPointUsingGateX, $SpawnPointUsingGateY)
	EndIf
	moveItemsToChest()
;~ 	#ce
	out("Merch Time: " & Round(TimerDiff($MerchantTimer)/1000) & "sec")
	If _CountFreeSlots() <= 2 Then Return False
	Return True
EndFunc

Func GoToMerchant()
	Local $lMerchant
	If GetMapID() = $MAP_ID_USING_CITY Then
;~ 		Global $Me = GetAgentByID(-2)
		MoveTo(-23227.42, 14889.28)
		$lMerchant = GetAgentByName("Merchant")
;~ 		$lMerchant = GetNearestAgentToCoords(-10610, -20520)
	Else
		$lMerchant = GetAgentByName("Merchant")
	EndIf
	GoToNPC($lMerchant)
EndFunc

#cs
Func _DonateFaction()
	If GetKurzickFaction() > 5000 And GUICtrlRead($getBlessingCheckbox) == $GUI_CHECKED Then
		Out("donate faction")
		If GetMapID() == $MAP_ID_USING_CITY Then TravelGH()  ; should travel to House zu Heltzer if not use gh
		Local $NPC = GetAgentByName("Bureaucrat")
		If IsDllStruct($NPC) Then
			GoToNPC($NPC)
			Sleep(200)
			For $i = 1 To Int(GetKurzickFaction()/5000)
				DonateFaction("k")
				Sleep(200)
			Next
		EndIf
	EndIf
EndFunc
#ce

Func GoNearestNPCToCoords($aX, $aY)
	Local $NPC
	_MoveTo($aX, $aY)
	$NPC = GetNearestNPCToCoords($aX, $aY)
	Do
		Sleep(250)
		GoNPC($NPC)
	Until GetDistance($NPC, -2) < 250
	Sleep(500)
EndFunc

#cs
Func ValEquipReturnTrue($aItem)
   Local $ModStruct = GetModStruct($aItem)
   Local $lModelID = DllStructGetData($aItem, 'ModelID')
   Local $WeaponType = DllStructGetData($aItem, 'Type')
   If IsWandFocusShield($WeaponType) Then
	  If HasTwoUsefulMods($ModStruct) Then Return True
   EndIf
EndFunc
#ce

#cs
Func IsWandFocusShield($WeaponType)
   If $WeaponType == 22 Then Return True
   If $WeaponType == 12 Then Return True
   If $WeaponType == 24 Then Return True
EndFunc

Func HasTwoUsefulMods($ModStruct)
   Local $UsefulMods = 0
   Local $aModStrings[159] = ["05320823", "0500F822", "0F00D822", "000A0822", "000AA823", "00140828", "00130828", "0A0018A1", "0A0318A1", "0A0B18A1", "0A0518A1", "0A0418A1", "0A0118A1", "0A0218A1", "02008820", "0200A820", "05147820", "05009821", "000AA823", "00142828", "00132828", "0100E820", "000AA823", "00142828", "00132828", "002D6823", "002C6823", "002B6823", "002D8823", "002C8823", "002B8823", "001E4823", "001D4823", "001C4823", "14011824", "13011824", "14021824", "13021824", "14031824", "13031824", "14041824", "13041824", "14051824", "13051824", "14061824", "13061824", "14071824", "13071824", "14081824", "13081824", "14091824", "13091824", "140A1824", "130A1824", "140B1824", "130B1824", "140D1824", "130D1824", "140E1824", "130E1824", "140F1824", "130F1824", "14101824", "13101824", "14201824", "13201824", "14211824", "13211824", "14221824", "13221824", "14241824", "13241824", "0A004821", "0A014821", "0A024821", "0A034821", "0A044821", "0A054821", "0A064821", "0A074821", "0A084821", "0A094821", "0A0A4821", "01131822", "02131822", "03131822", "04131822", "05131822", "06131822", "07131822", "08131822", "09131822", "0A131822", "0B131822", "0D131822", "0E131822", "0F131822", "10131822", "20131822", "21131822", "22131822", "24131822", "01139823", "02139823", "03139823", "04139823", "05139823", "06139823", "07139823", "08139823", "09139823", "0A139823", "0B139823", "0D139823", "0E139823", "0F139823", "10139823", "20139823", "21139823", "22139823", "24139823"]
   Local $NumMods = 158
   For $i = 0 to $NumMods
	  Local $ModStr = StringInStr($ModStruct, $aModStrings[$i], 0, 1);
	  If ($ModStr <= 0) Then
		 $UsefulMods += 1
	  EndIf
   Next
   If $UsefulMods == 2 Then Return True
EndFunc

Func getDragonMossGroups()
	;1. big plant beside soh spot
	;2. 4900 coords east from priest
	;3. down in the wood
	Local $LookingForGroupSpot[3][2] = [[-6340,16710],[-3952, 16225],[-5348,14677]]
	Local $lDistance = 0
	Local $nextAgent
	Local $DMossCount = 0
;~ 	Local $count = 0
	Local $lAgentArray = GetAgentArray(0xDB)

	For $j = 0 To 2
		Local $AgentDistanceIDArray[$lAgentArray[0]+1][2]
		For $i = 0 to UBound($AgentDistanceIDArray) -1
			 $AgentDistanceIDArray[$i][0] = 999999
		Next
		For $i = 1 To $lAgentArray[0]
			Local $lAgent = $lAgentArray[$i]
			Local $lAgentID = DllStructGetData($lAgent, 'ID')
			If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
			If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
			If GetAgentName($lAgent) <> "Dragon Moss" Then ContinueLoop

;~ 			$count += 1
;~ 			ConsoleWrite(@CRLF & "jupjupihey   " & $count & @TAB & "$lAgentID  " & $lAgentID & @TAB & "dist  " &  Round(ComputeDistance(DllStructGetData($lAgent, 'X'), DllStructGetData($lAgent, 'Y'),$LookingForGroupSpot[$j][0],$LookingForGroupSpot[$j][1])))
			If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
			If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
			$AgentDistanceIDArray[$i][1] = $lAgentID
			$AgentDistanceIDArray[$i][0] = ComputeDistance(DllStructGetData($lAgent, 'X'), DllStructGetData($lAgent, 'Y'),$LookingForGroupSpot[$j][0],$LookingForGroupSpot[$j][1])
			ConsoleWrite(@CRLF & "!" & $i & @TAB & "Distance " & Round($AgentDistanceIDArray[$i][0]))
			ConsoleWrite(@TAB & " Team = " & DllStructGetData($lAgent, "Team") & "(" & DllStructGetData(GetAgentByID(-2), "Team") & ")" )
			ConsoleWrite(@TAB & "Allegiance = " & DllStructGetData($lAgent, "Allegiance") & "(" & DllStructGetData(GetAgentByID(-2), "Allegiance") & ")")
;~ 			ConsoleWrite(@TAB & "Effect 0x0010 = " & BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010))

		Next
		_ArraySort($AgentDistanceIDArray)
;~ 		_ArrayDisplay($AgentDistanceIDArray)
		If $lAgentArray[0] <= 12 Then Return False
		For $i = 0 to 3
			$lAgentGroup[$j][$i]= $AgentDistanceIDArray[$i][1]
		Next
	Next
	Return True
;~ 	_ArrayDisplay($lAgentGroup)
EndFunc

Func getNearestDMoss($group1 = True, $group2 = True, $group3 = True, $X = 0, $Y = 0)
	Local $lDistance = 9999
	Local $JAgent, $IAgent
	If $X = 0 And $Y = 0 Then
		$X = DllStructGetData(GetAgentByID(-2),"X")
		$Y = DllStructGetData(GetAgentByID(-2),"Y")
	EndIf

	If $group1 Then
		Local $j = 0
;~ 		ConsoleWrite(@CRLF & "!Group____" & ($j+1))
		For $i = 1 To 3
;~ 			ConsoleWrite(@TAB & "Team = " & DllStructGetData($lAgentGroup[$j][$i], "Team") & @TAB & "Allegiance = " & DllStructGetData($lAgentGroup[$j][$i], "Allegiance"))
			If $lDistance > GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i]) Then
					$lDistance = GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i])
					$JAgent = $j
					$IAgent = $i
			EndIf
		Next
	EndIf
	If $group2 Then
		Local $j = 1
;~ 		ConsoleWrite(@CRLF & "!Group____" & ($j+1))
		For $i = 1 To 3
;~ 			ConsoleWrite(@TAB & "Team = " & DllStructGetData($lAgentGroup[$j][$i], "Team") & @TAB & "Allegiance = " & DllStructGetData($lAgentGroup[$j][$i], "Allegiance"))
			If $lDistance > GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i]) Then
					$lDistance = GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i])
					$JAgent = $j
					$IAgent = $i
			EndIf
		Next
	EndIf
	If $group3 Then
		Local $j = 2
;~ 		ConsoleWrite(@CRLF & "!Group____" & ($j+1))
		For $i = 1 To 3
;~ 			ConsoleWrite(@TAB & "Team = " & DllStructGetData($lAgentGroup[$j][$i], "Team") & @TAB & "Allegiance = " & DllStructGetData($lAgentGroup[$j][$i], "Allegiance"))
			If $lDistance > GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i]) Then
					$lDistance = GetDistanceCoordsToAgent($X, $Y, $lAgentGroup[$j][$i])
					$JAgent = $j
					$IAgent = $i
			EndIf
		Next
	EndIf
;~ 	CallTarget($lAgentGroup[$JAgent][$IAgent])
	Return $lAgentGroup[$JAgent][$IAgent]
EndFunc

Func GetNearestEnemy_MovingDirection($movingDirection, $randomAngle = 40)

	Local $SwitchAngle = False
	;to avoid 0° - 360° gab
	If $movingDirection <= 90 And $movingDirection >= 0 Then
		$movingDirection += 180
		$SwitchAngle = True
	EndIf
	If $movingDirection <= 360 And $movingDirection >= 270 Then
		$movingDirection -= 180
		$SwitchAngle = True
	EndIf

	If GetMapLoading() == 2 Then Disconnected()
	Local $lAgent, $lAgentArray = GetAgentArray(0xDB)

	Local $iAgentCount = 0
	Local $lDistance = 0
	Local $nextAgent
;~ 	Local $Me = GetAgentByID(-2)
;~ 	Local $MeX = DllStructGetData($Me, 'X')
;~ 	Local $MeY = DllStructGetData($Me, 'Y')
;~ 	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
	Local $AgendDistanceArray[$lAgentArray[0]+1][2]

	For $i = 0 to UBound($AgendDistanceArray)-1
		$AgendDistanceArray[$i][0] = $lAgentArray[$i]
		$AgendDistanceArray[$i][1] = 0
	Next
	For $i = 1 To UBound($lAgentArray) -1
		$lAgent = $lAgentArray[$i]
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If GetAgentName($lAgent) <> "Dragon Moss" Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		Local $Angle = _arg(DllStructGetData($lAgent, 'moveX'),DllStructGetData($lAgent, 'moveY'))
		If $SwitchAngle Then
			If $Angle <= 90 And $Angle >= 0 Then
				$Angle += 180
			EndIf
			If $Angle <= 360 And $Angle >= 270 Then
				$Angle -= 180
			EndIf
		EndIf
		ConsoleWrite(@crlf	 & "$movingDirection" & @tab & $movingDirection& @TAB &"$Angle" & @tab & Round($Angle) & "Abs" & @TAB &  Round(Abs($movingDirection - $Angle)) & @TAB & $randomAngle/2)
		If Abs($movingDirection - $Angle) >= $randomAngle/2 Then ContinueLoop
		If $lDistance = 0 Or $lDistance > GetDistance($lAgent) Then
			$lDistance = GetDistance($lAgent)
			$iAgentCount += 1
			$nextAgent = $lAgent
		EndIf
	Next
	ConsoleWrite(@CRLF & "switch " & $SwitchAngle & @TAB & "$movingDirection" & @tab & $movingDirection & @tab &"$iAgentCount " & $iAgentCount)
	If $lDistance <> 0 Then
		Return $lAgent
	Else
		Return -2
	EndIf
EndFunc
#ce

;~ Func _Exit()
;~ 	If Not $RenderingEnabled Then ToggleRendering()
;~ 	Exit
;~ EndFunc