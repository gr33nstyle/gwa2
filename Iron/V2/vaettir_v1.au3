#cs
#################################
#                               #
#          Vaettir Bot          #
#                               #
#           by gigi             #
#                               #
#################################
#ce
#cs
Version Notes
v1: - Once per hour bot Enables Rendering so the Game can do its Memory Management
#ce

#RequireAdmin
#NoTrayIcon

#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

; ==== Constants ====
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH
Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

Global Const $MAP_ID_BJORA = 482
Global Const $MAP_ID_JAGA = 546
Global Const $MAP_ID_LONGEYE = 650

Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335

Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621

Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_ID_KIT = 2989

Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_WHITEDYE = 12

Global Const $ITEM_ID_GLACIAL_STONES = 27047
Global Const $ITEM_ID_TOTS = 28434
Global Const $ITEM_ID_GOLDEN_EGGS = 22752
Global Const $ITEM_ID_BUNNIES = 22644
Global Const $ITEM_ID_GROG = 30855
Global Const $ITEM_ID_CLOVER = 22191
Global Const $ITEM_ID_PIE = 28436
Global Const $ITEM_ID_CIDER = 28435
Global Const $ITEM_ID_POPPERS = 21810
Global Const $ITEM_ID_ROCKETS = 21809
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_SPARKLER = 21813
Global Const $ITEM_ID_HONEYCOMB = 26784
Global Const $ITEM_ID_VICTORY_TOKEN = 18345
Global Const $ITEM_ID_LUNAR_TOKEN = 21833
Global Const $ITEM_ID_HUNTERS_ALE = 910
Global Const $ITEM_ID_LUNAR_TOKENS = 28433
Global Const $ITEM_ID_KRYTAN_BRANDY = 35124
Global Const $ITEM_ID_BLUE_DRINK = 21812
Global Const $ITEM_ID_GHOST_IN_A_BOX = 6368
Global Const $ITEM_ID_SHAMROCK_ALE = 22190

; ================== CONFIGURATION ==================
; Edit the following two lines to count a particular item in the interface
Global Const $EventItemModelID = $ITEM_ID_CUPCAKES
Global Const $EventItemName = "Cupcake" ; just for the interface.

; True or false to load the list of logged in characters or not
Global Const $doLoadLoggedChars = True
; ================ END CONFIGURATION ================

; ==== Bot global variables ====
Global $EventItemCount = 0
Global $RenderingEnabled = True
Global $RunCount = 0
Global $FailCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()

; ==== Build ====
Global Const $SkillBarTemplate = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"
; declare skill numbers to make the code WAY more readable (UseSkill($sf) is better than UseSkill(2))
Global Const $paradox = 1
Global Const $sf = 2
Global Const $shroud = 3
Global Const $wayofperf = 4
Global Const $hos = 5
Global Const $wastrel = 6
Global Const $echo = 7
Global Const $channeling = 8
; Store skills energy cost
Global $skillCost[9]
$skillCost[$paradox] = 15
$skillCost[$sf] = 5
$skillCost[$shroud] = 10
$skillCost[$wayofperf] = 5
$skillCost[$hos] = 5
$skillCost[$wastrel] = 5
$skillCost[$echo] = 15
$skillCost[$channeling] = 5

; ==== GUI ====
Global Const $mainGui = GUICreate("Vaettir Bot", 149, 187)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input
If $doLoadLoggedChars Then
	$Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
		GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
GUICtrlCreateLabel($EventItemName, 8, 35, 70, 17)
Global Const $EventItemLabel = GUICtrlCreateLabel($EventItemCount, 80, 35, 50, 17)
GUICtrlCreateLabel("Runs:", 8, 65, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 65, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 80, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 80, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 98, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 37)
GUISetState(@SW_SHOW)

;~ Description: Handles the button presses
Func GuiButtonHandler()
	If $BotRunning Then
		GUICtrlSetData($Button, "Will pause after this run")
		GUICtrlSetState($Button, $GUI_DISABLE)
		$BotRunning = False
	ElseIf $BotInitialized Then
		GUICtrlSetData($Button, "Pause")
		$BotRunning = True
	Else
		Out("Initializing")
		Local $CharName = GUICtrlRead($Input)
		If $CharName=="" Then
			If Initialize(ProcessExists("gw.exe")) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "VBot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc

Out("Waiting for input")
While Not $BotRunning
	Sleep(500)
WEnd

; load template if we're in town
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($SkillBarTemplate)

While True
	If GetMapID() <> $MAP_ID_JAGA Then RunThere()

	If GetIsDead(-2) Then ContinueLoop

	While 1	; can change this into something like While CountFreeSlots() > 1

		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(500)
			WEnd
		EndIf

		CombatLoop()
		If Mod($RunCount, 15) == 0 And GUICtrlRead($Checkbox) == $GUI_CHECKED Then
			EnableRendering()
			WinSetState(GetWindowHandle(), "", @SW_SHOW)
			RndSleep(10000)
			ClearMemory()
			DisableRendering()
			WinSetState(GetWindowHandle(), "", @SW_HIDE)
		EndIf
	WEnd
WEnd

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine
Func RunThere()
	If GetMapID() <> $MAP_ID_LONGEYE Then
		Out("Travelling to longeye")
		TravelTo($MAP_ID_LONGEYE)
	EndIf

	SwitchMode(1)

	Out("Exiting Outpost")
	Move(-26472, 16217)
	WaitMapLoading($MAP_ID_BJORA)
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
	WaitMapLoading($MAP_ID_JAGA)
EndFunc

; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()
	;If Not $RenderingEnabled Then ClearMemory()

	If GetNornTitle() < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
		RndSleep(1000)
	EndIf

	Out("Moving to aggro left")
	MoveTo(13501, -20925)
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
	MoveAggroing(8982, -20576)

	Out("Waiting for left ball")
	WaitFor(12*1000)

	If GetDistance()<1000 Then
		UseSkillEx($hos, -1)
	Else
		UseSkillEx($hos, -2)
	EndIf

	WaitFor(6000)

	TargetNearestEnemy()

	Out("Moving to aggro right")
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

	Out("Waiting for right ball")
	WaitFor(15*1000)

	If GetDistance()<1000 Then
		UseSkillEx($hos, -1)
	Else
		UseSkillEx($hos, -2)
	EndIf

	WaitFor(5000)

	Out("Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)

	Out("Killing")
	Kill()

	WaitFor(1200)

	Out("Looting")
	PickUpLoot()

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	Out("Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

	While GetIsDead(-2)
		Out("Waiting for res")
		Sleep(5500)
	WEnd

	Move(15865, -20531)
	WaitMapLoading($MAP_ID_BJORA)
	RndSleep(1000)

	;MoveTo(-19968, 5564)
	Move(-20076,  5580, 30)
	RndSleep(3000)
	WaitMapLoading($MAP_ID_JAGA)
	RndSleep(1000)
EndFunc

;~ Description: use whatever skills you need to keep yourself alive.
; Take agent array as param to more effectively react to the environment (mobs)
Func StayAlive(Const ByRef $lAgentArray)
	If IsRecharged($sf) Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
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

	If IsRecharged($shroud) Then
		If $lSpellCastCount > 0 And DllStructGetData(GetEffect($SKILL_ID_SHROUD), "SkillID") == 0 Then
			UseSkillEx($shroud)
		ElseIf DllStructGetData($lMe, "HP") < 0.6 Then
			UseSkillEx($shroud)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($shroud)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($wayofperf) Then
		If DllStructGetData($lMe, "HP") < 0.5 Then
			UseSkillEx($wayofperf)
		ElseIf $lAdjCount > 20 Then
			UseSkillEx($wayofperf)
		EndIf
	EndIf

	UseSF($lProximityCount)

	If IsRecharged($channeling) Then
		If $lAreaCount > 5 And GetEffectTimeRemaining($SKILL_ID_CHANNELING) < 2000 Then
			UseSkillEx($channeling)
		EndIf
	EndIf

	UseSF($lProximityCount)
EndFunc

;~ Description: Uses sf if there's anything close and if its recharged
Func UseSF($lProximityCount)
	If IsRecharged($sf) And $lProximityCount > 0 Then
		UseSkillEx($paradox)
		UseSkillEx($sf)
	EndIf
EndFunc

;~ Description: Move to destX, destY, while staying alive vs vaettirs
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $lHosCount
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)

	Do
		RndSleep(50)

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
			ElseIf IsRecharged($hos) Then
				If $lHosCount==0 And GetDistance() < 1000 Then
					UseSkillEx($hos, -1)
				Else
					UseSkillEx($hos, -2)
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
					RndSleep(GetPing())
					If GetDistance() > 1100 Then ; we werent stuck, but target broke aggro. select a new one.
						TargetNearestEnemy()
					EndIf
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

;~ Description: Move to destX, destY. This is to be used in the run from across Bjora
Func MoveRunning($lDestX, $lDestY)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lTgt
	Local $lBlocked

	Move($lDestX, $lDestY)

	Do
		RndSleep(500)

		TargetNearestEnemy()
		$lMe = GetAgentByID(-2)
		$lTgt = GetAgentByID(-1)

		If GetIsDead($lMe) Then Return False

		If GetDistance($lMe, $lTgt) < 1300 And GetEnergy($lMe)>20 And IsRecharged($paradox) And IsRecharged($sf) Then
			UseSkillEx($paradox)
			UseSkillEx($sf)
		EndIf

		If DllStructGetData($lMe, "HP") < 0.9 And GetEnergy($lMe) > 10 And IsRecharged($shroud) Then UseSkillEx($shroud)

		If DllStructGetData($lMe, "HP") < 0.5 And GetDistance($lMe, $lTgt) < 500 And GetEnergy($lMe) > 5 And IsRecharged($hos) Then UseSkillEx($hos, -1)

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			Move($lDestX, $lDestY)
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 250
	Return True
EndFunc

;~ Description: Waits until all foes are in range (useless comment ftw)
Func WaitUntilAllFoesAreInRange($lRange)
	Local $lAgentArray
	Local $lAdjCount, $lSpellCastCount
	Local $lMe
	Local $lDistance
	Local $lShouldExit = False
	While Not $lShouldExit
		Sleep(100)
		$lMe = GetAgentByID(-2)
		If GetIsDead($lMe) Then Return
		$lAgentArray = GetAgentArray(0xDB)
		StayAlive($lAgentArray)
		$lShouldExit = False
		For $i=1 To $lAgentArray[0]
			$lDistance = GetPseudoDistance($lMe, $lAgentArray[$i])
			If $lDistance < $RANGE_SPELLCAST_2 And $lDistance > $lRange^2 Then
				$lShouldExit = True
				ExitLoop
			EndIf
		Next
	WEnd
EndFunc

;~ Description: Wait and stay alive at the same time (like Sleep(..), but without the letting yourself die part)
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

;~ Description: BOOOOOOOOOOOOOOOOOM
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
		If GetSkillbarSkillRecharge($sf) > 5000 And GetSkillbarSkillID($echo)==$SKILL_ID_ARCHANE_ECHO Then
			If IsRecharged($wastrel) And IsRecharged($echo) Then
				UseSkillEx($echo)
				UseSkillEx($wastrel, GetGoodTarget($lAgentArray))
				$lAgentArray = GetAgentArray(0xDB)
			EndIf
		EndIf

		UseSF(True)

		; Use wastrel if possible
		If IsRecharged($wastrel) Then
			UseSkillEx($wastrel, GetGoodTarget($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
		EndIf

		UseSF(True)

		; Use echoed wastrel if possible
		If IsRecharged($echo) And GetSkillbarSkillID($echo)==$SKILL_ID_WASTREL_DEMISE Then
			UseSkillEx($echo, GetGoodTarget($lAgentArray))
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

; Returns a good target for watrels
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

; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $skillCost[$lSkill] Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func GoNearestNPCToCoords($x, $y)
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords

;~ Description: standard pickup function, only modified to increment a custom counter when taking stuff with a particular ModelID
Func PickUpLoot()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd

			; special event item count
			If DllStructGetData($lItem, "ModelID")==$EventItemModelID Then
				$EventItemCount+=1
				GUICtrlSetData($EventItemLabel, $EventItemCount)
			EndIf
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $lRarity = GetRarity($aItem)
	If $lModelID == 2511 And GetGoldCharacter() < 99000 Then Return True	; gold coins (only pick if character has less than 99k in inventory)
	;If $lModelID > 21785 And $lModelID < 21806 Then Return True	; Elite/Normal Tomes
	If $lModelID == $ITEM_ID_DYES Then	; if dye
		Switch DllStructGetData($aItem, "ExtraID")
			Case $ITEM_EXTRAID_BLACKDYE, $ITEM_EXTRAID_WHITEDYE ; only pick white and black ones
				Return True
			Case Else
				Return False
		EndSwitch
	EndIf
	If $lRarity == $RARITY_GOLD 			Then Return False		; gold items
	If $lModelID == $ITEM_ID_LOCKPICKS 		Then Return True ; Lockpicks
	If $lModelID == $ITEM_ID_GLACIAL_STONES Then Return True	; glacial stones
	; ==== Pcons ====
	If $lModelID == $ITEM_ID_TOTS 			Then Return True
	If $lModelID == $ITEM_ID_GOLDEN_EGGS 	Then Return True
	If $lModelID == $ITEM_ID_BUNNIES 		Then Return True
	If $lModelID == $ITEM_ID_GROG 			Then Return True
	If $lModelID == $ITEM_ID_CLOVER 		Then Return True
	If $lModelID == $ITEM_ID_PIE			Then Return True
	If $lModelID == $ITEM_ID_CIDER			Then Return True
	If $lModelID == $ITEM_ID_POPPERS		Then Return True
	If $lModelID == $ITEM_ID_ROCKETS		Then Return True
	If $lModelID == $ITEM_ID_CUPCAKES		Then Return True
	If $lModelID == $ITEM_ID_SPARKLER		Then Return True
	If $lModelID == $ITEM_ID_HONEYCOMB		Then Return True
	If $lModelID == $ITEM_ID_VICTORY_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKEN	Then Return True
	If $lModelID == $ITEM_ID_HUNTERS_ALE	Then Return True
	If $lModelID == $ITEM_ID_LUNAR_TOKENS	Then Return True
	If $lModelID == $ITEM_ID_KRYTAN_BRANDY	Then Return True
	If $lModelID == $ITEM_ID_BLUE_DRINK		Then Return True
    If $lModelID == $ITEM_ID_GHOST_IN_A_BOX Then Return True
	If $lModelID == $ITEM_ID_SHAMROCK_ALE	Then Return True
	; If you want to pick up more stuff add it here
	Return False
EndFunc   ;==>CanPickUp

; I don't actually use this. I'm pretty sure it's buggy, but feel free to play with it.
Func CountSlots($aNumBags = 4)
	Local $lFreeSlots = 0
	Local $lBagSlots = 0
	For $i = 1 To $aNumBags
		$lBagSlots = DllStructGetData(GetBag($i), 'slots')
		$lFreeSlots += $lBagSlots
		For $slot = 1 To $lBagSlots
			If DllStructGetData(GetItemBySlot($i, $slot), 'ModelID') <> 0 Then
				$lFreeSlots -= 1
			EndIf
		Next
	Next
	Return $lFreeSlots
EndFunc   ;==>CountSlots

;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	$RenderingEnabled = Not $RenderingEnabled
	If $RenderingEnabled Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering

;~ Description: Print to console with timestamp
Func Out($msg)
	GUICtrlSetData($StatusLabel, "["&@HOUR&":"&@MIN&"]"&$msg)
EndFunc

;~ Description: guess what?
Func _exit()
	Exit
EndFunc