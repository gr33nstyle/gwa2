;*****************************************
;Pahnai-Salad.au3 by Alexander
;Erstellt mit ISN AutoIt Studio v. 1.02
;*****************************************
#include "../GWA2.au3"
#include "Forms\GUI.isf"
#include <Date.au3>
#include <Array.au3>

#RequireAdmin
#NoTrayIcon

#Region Globals
; CONSTANTS
Global Const $MAP_ID_PLAINS_OF_JARIN = 430
Global Const $MAP_ID_KAMADAN = 449
Global Const $SKILL_TEMPLATE = "Owpj8NjcKT6PLi3lTQAAAAAAAAA"

Global Const $CRITICAl_EYE = 1
Global Const $WAY_OF_THE_MASTER = 2
Global Const $DWARVEN_STABILITY = 3
Global Const $DASH = 4
Global Const $skillCost[] = [5, 5, 5, 5, 0, 0, 0, 0]

Global Const $ITEM_ID_IBOGA_PETALS = 19183
Global Const $IBOGA_ID = 4384

Global Const $FarmSpotsX[] = [15500, 13250, 15000, 14000, 15500, 9850, 9250, 6750, 6600, 5200, 4350]
Global Const $FarmSpotsY[] = [1000, 1800, 3300, 7000, 8300, 13750, 15500, 16900, 14500, 14250, 15550]

; GLOBALS
Global $Rendering = True
Global $characterName
Global $Running = False
Global $Initialized = False
Global $RunsTotal = 0
Global $RunsSuccess = 0
Global $RunsFail = 0
Global $IbogaPetals = 0
; END GLOBALS
#EndRegion
Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)

GUISetState(@SW_SHOW)
GUISetIcon("Images/SaladIcon.ico")
main()

#Region Functions
; Func main()
; @param: none
; main function with loop
; @return: void
Func main()
	Out("Bot started!")
	While True
		If $Running Then
			If Not $Initialized Then
				_Initialize(GUICtrlRead($guiCharSelect))
			EndIf
			If $Initialized Then
				If $RunsTotal == 0 Or GetMapID() <> $MAP_ID_KAMADAN Then
				Setup()
				EndIf
				If farmPetals() = True Then
					$RunsSuccess = $RunsSuccess + 1;
				Else
					Out("Run Failed")
					$RunsFail = $RunsFail + 1;
				EndIf
				$RunsTotal = $RunsTotal + 1
				returnOutpost();
				StatsUpdate()
			EndIf
			If Mod($RunsTotal, 10) = 7 Then _PurgeHook()
		EndIf
		Sleep(5000)
	Wend
EndFunc

; Func Setup()
; @param: none
; does stuff to setup the first run or if you resume and
; the bot is not in kamadan
; @return: void
Func Setup()
	TravelTo($MAP_ID_KAMADAN)
	WaitMapLoading($MAP_ID_KAMADAN)
	LoadSkillTemplate($SKILL_TEMPLATE)
	SwitchMode(0)
	fastWayOut()
EndFunc

; Func fastWayOut()
; @param: none
; prepares a better spawn
; @return: void
Func fastWayOut()
	Out("Preparing FastWayOut...")
	moveTo(-8250, 14500)
	Do
		Move(-9300, 17000)
	Until WaitMapLoading($MAP_ID_PLAINS_OF_JARIN)
	Out("Loaded Plains of Jarin")
	Do
		Move(18380, -1600)
	Until WaitMapLoading($MAP_ID_KAMADAN)
	Out("Loaded Kamadan")
	Out("Preparing completed!")
EndFunc

; Func farmPetals()
; @param: none
; function that is farming the ibogas
; @return: boolean returns true if the run was a success, returns false if it failed
Func farmPetals()

	Local $Continue = True
	Local $Spot

	Out("Starting run #" & $RunsTotal+1)
	Out("Exiting town")
	Do
		Move(-9300, 17000)
	Until WaitMapLoading($MAP_ID_PLAINS_OF_JARIN)

	For $Spot = 0 To 10 Step 1
		$Continue = farmSpot($Spot, $FarmSpotsX[$Spot], $FarmSpotsY[$Spot])
		If Not $Continue Then
			Out("Farm Spot " & $spot + 1 & "Failed")
			Return False
		EndIf
	Next

	Return True
EndFunc

; Func farmSpot($spot, $xpos, $ypos)
; @param: $spot:int number of the spot -1,
;         $xpos:int position of the Player,
;         $ypos:int same
; runs to the farmspot and kills Ibogas in range.
; @return: boolean returns true if the bot farms the spot with success
;          false if the bot failed through dying or something else
Func farmSpot($spot, $xpos, $ypos)
	Local $Continue = True
	Out("Moving to #" & $spot + 1 & " spot")
	$Continue = MoveAggroing($xpos, $ypos)
	If Not $Continue Then
		Out("Moving Failed")
		Return False
	EndIf
	Out("Killing")
	$Continue = KillIbogas()
	If Not $Continue Then
		Out("Killing Failed")
		Return False
	EndIf
	_PickupLoot()
	Return True
EndFunc

; Func KillIbogas($range = 1300,  $pTimeout = 90000)
; @param: none
; function to kill the Ibogas around you
; @return: boolean returns true if no problem happened and
;          false if the player died or something else gone wrong
Func KillIbogas($range = 1300,  $pTimeout = 90000)
	Local $TimeoutTimer = TimerInit()
	Do
		If IsRecharged($CRITICAl_EYE) Then UseSkillEx($CRITICAl_EYE)
		If IsRecharged($WAY_OF_THE_MASTER) Then UseSkillEx($WAY_OF_THE_MASTER)
		Attack(GetNearestEnemyToAgent(-2))
		Sleep(2000)
	Until GetNumberOfFoesInRangeOfAgent(-2, 1300) = 0 Or GetIsDead(-2) Or TimerDiff($TimeoutTimer) > $pTimeout

	Local $Fail = GetIsDead(-2) Or TimerDiff($TimeoutTimer) > $pTimeout
	Return Not $Fail
EndFunc

; Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
; @param: $lSkill:int Skill to use,
;         $lTgt:int The Target of the skill,
;         $aTimeout:int Timeout to cast the skill
; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
; @return: void
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

; Func IsRecharged($lSkill)
; @param: $lSkill:int Skill to check
; Checks if skill given (by number in bar) is recharged.
; @return: returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

; Func GetNumberOfFoesInRangeOfAgent($aAgent, $aRange)
; @param: $aAgent:int the Agent to count from,
;         $aRange:int the Range to count the Foes in.
; Counts Foes in the Targets Range.
; @return: Returns the number of Foes in the Agent's Range
Func GetNumberOfFoesInRangeOfAgent($aAgent, $aRange)
	Local $lAgent, $lDistance
	Local $lCount = 0

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next

	Return $lCount
EndFunc

; Func _PickupLoot()
; @param: none
; function that picks up all the Iboga Petals
; @return: void
Func _PickupLoot()
	Local $me, $agent, $distance, $lItem
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		Local $agent = GetAgentByID($i)
		If Not GetIsMovable($agent) Then ContinueLoop
		$distance = GetDistance($agent)
	    If $distance > 2000 Then ContinueLoop
		$lItem = GetItemByAgentID($i)

		If canPickupItem($lItem) Then
			If $distance > 150 Then MoveTo(DllStructGetData($agent, 'X'), DllStructGetData($agent, 'Y'), 100)
			PickUpItem($lItem)
			sleep(GetPing() + 250)
		EndIf
	Next
	Return True
EndFunc

; Func canPickupItem()
; @param: $Item:int agent of the item to check
; tests if we should pick up the item
; @return: boolean returns true if the item should be picked up,
;          false if we don't want it
Func canPickupItem($Item)
	Local $lModelId = DllStructGetData($Item, "ModelID")
	Switch $lModelId
		Case $ITEM_ID_IBOGA_PETALS
			$IbogaPetals = $IbogaPetals + 1
			Return True
		Case Else
			Return False
	EndSwitch
	Return False
EndFunc

; Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
; @param: $lDestX:int Destination to move,
;         $lDestY:int same,
;         $lRandom:int size of the area to move to
; moves to target location with anti stuck and maintains dash
; @return: returns true if successful moved, false if the bot died or another error occurred
Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return False

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $ChatStuckTimer
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)
	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False
	    If TimerDiff($stuckTimer) > 90000 Then Return False

		MaintainDash()

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then

			$lBlocked += 1
			If $lBlocked < 4 Then
				Move($lDestX, $lDestY, $lRandom)
			Elseif $lBlocked < 8 then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			EndIf


		elseIf $lBlocked > 0 Then

			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
			EndIf
			$lBlocked = 0
			TargetNearestEnemy()
			sleep(1000)
			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

; Func MaintainDash()
; @param: none
; maintains Dwarven Stability and Dash while running
; @return: void
Func MaintainDash()
	If IsRecharged($DWARVEN_STABILITY) Then
		If GetEffect(2423) = 0 Or GetEffectTimeRemaining(2423) < 3000 Then
			UseSkillEx($DWARVEN_STABILITY)
		EndIf
	EndIf
	If IsRecharged($DASH) Then UseSkill($DASH, -2)
EndFunc

; Func returnOutpost()
; @param: none
; resign and loading back to Kamadan
; @return: void
Func returnOutpost()
	Out("Returning to Kamadan")
	Resign()
	Sleep(GetPing() + 3000)
	ReturnToOutpost()
	WaitMapLoading($MAP_ID_KAMADAN)
EndFunc

; Func _ToggleRendering()
; @param: none
; toggles the rendering state
; @return: void
Func _ToggleRendering()
   If $rendering Then
		DisableRendering()
		$Rendering = False
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
	Else
		EnableRendering()
		$Rendering = True
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
EndFunc

; Func _DisableRendering()
; @param:
; disables the rendering
; @return:
Func _DisableRendering()
   DisableRendering()
   ClearMemory()
   WinSetState($mGWHwnd, "", @SW_HIDE)
   $Rendering = False
EndFunc

; Func _EnableRendering()
; @param:
; enables the rendering
; @return:
Func _EnableRendering()
   WinSetState($mGWHwnd, "", @SW_SHOW)
   EnableRendering()
   $Rendering = True
EndFunc

; Func _PurgeHook()
; @param:
; enables and disables rendering to free up some memory
; @return:
Func _PurgeHook()
	_ToggleRendering()
	Sleep(Random(2000, 3000))
	_ToggleRendering()
EndFunc

; Func guiStartButton()
; @param: none
; toggle function for $guiStartButton
; @return: void
Func guiStartButton()
	If $Running Then
		$Running = False
		GUICtrlSetData($guiStartButton, "Resume")
	Else
		$Running = True
		GUICtrlSetData($guiStartButton, "Pause")
	EndIf
EndFunc

; Func guiRenderingButton()
; @param: none
; toggle function for $guiRenderingButton
; @return: void
Func guiRenderingButton()
	_ToggleRendering()
EndFunc

; Func _Initialize($pCharacterName)
; @param: $pCharacterName:String the actual Charactername of the to initialized gw process
; function to initialize the bot with the gw process and to change some parts of the gui afterwards if
; it's a success. else it will show a msgbox with the error. (Copy Pasta of Vivec)
; @return: void
Func _Initialize($pCharacterName)
	If Initialize($pCharacterName) Then
		$characterName = $pCharacterName
		GUICtrlSetState($guiCharSelect, $GUI_DISABLE)
		GUICtrlSetState($guiRenderingButton, $GUI_ENABLE)
		GUICtrlSetData($guiStartButton, "Pause")
		Out("Initialized")
		WinSetTitle($GUI, "", $characterName & " - Pahnai Bot")
		$Initialized = True
	Else
		MsgBox(0, "Error Initializing", "Error while initializing with character name " & $pCharacterName)
	EndIf
EndFunc

; Func Out($message)
; @param: $message:String the message to print in the console-log
; prints messages with a timestemp in the console-log
; @return: void
Func Out($message)
	Local $Time = _NowTime(5)
	Local $LogOutput = "[" & $Time & "] " & $message & @CRLF
	Local $iEnd = StringLen(GUICtrlRead($guiMsgOut))
	GUICtrlSetData($guiMsgOut, $LogOutput, 1)
EndFunc

; Func StatsUpdate()
; @param: none
; updates the stats of the GUI
; @return: void
Func StatsUpdate()
	GUICtrlSetData($guiFailedRuns, $RunsFail)
	GUICtrlSetData($guiSuccessRuns, $RunsSuccess)
	GUICtrlSetData($guiIbogaPetals, $IbogaPetals)
EndFunc

; Func _Exit()
; @param: none
; Wrapper function to call Exit for the $GUI_EVENT_CLOSE event of the GUI
; @return: void
Func _Exit()
	Exit
EndFunc

#EndRegion