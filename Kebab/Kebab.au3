#include-once
#include "../GWA2.au3"
#include "Inventory.au3"
#include <GUIConstantsEx.au3> ;for GUI stuff
#include <WindowsConstants.au3> ;for $SS_CENTER
#include <StaticConstants.au3> ;for $WS_GROUP
#include <ComboConstants.au3> ;for Combo Constant
#include <GuiEdit.au3>

#region Constant
	Global const $OUTPOST = 425
	Global const $ZONE = 384
 	Global const $COORD_EXIT_X = -15000
	Global const $COORD_EXIT_Y = 9000
	Global const $BUILD = "Owhi8pi8g58mE7KnjjZ2APgA"
#endregion
#region Global Variable
	Global $boolRun = False
	Global $firstRun = True
	Global $run = 0
	Global $runFail = 0
	Global $runWin = 0
#endregion
Opt("GUIOnEventMode", 1)

#region GUI
$GUI = GUICreate("Bot Kebab", 270, 235, 200, 180)

$lblStatus = GUICtrlCreateLabel("", 7, 176, 256, 17, $SS_CENTER)
$lblName = GUICtrlCreateLabel("Character Name:", 8, 32, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$lblRuns = GUICtrlCreateLabel("Total Runs: 0", 115, 9, 132, 17, $SS_CENTER)

$btnStart = GUICtrlCreateButton("Start", 7, 202, 256, 25, $WS_GROUP)
GUICtrlSetOnEvent($btnStart, "EventHandler")

$cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 10, 8, 105, 17)
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")

$txtName = GUICtrlCreateCombo("", 100, 32, 150, 17)
		GUICtrlSetData(-1, GetLoggedCharNames())

GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler") ;DONE
GUISetState(@SW_SHOW)

#endregion
While 1
	Sleep(250)
	If $boolRun Then
		If mainLoop() Then
			$runWin += 1
		Else
			$runFail += 1
		EndIf
	Else
		$run = 0
		$firstRun = True
		GUICtrlSetState($btnStart,$GUI_ENABLE)
		GUICtrlSetData($btnStart, "Start")
	EndIf
WEnd

Func EventHandler()
	Switch(@GUI_CtrlId)
		case $btnStart
			If $boolRun = False Then
			    Initialize(GUICtrlRead($txtName), True, True)
				GUICtrlSetData($btnStart, "Stop")
				GUICtrlSetState($txtName, $GUI_DISABLE)
				$boolRun = True
			Else
				GUICtrlSetData($btnStart, "Bot will halt after this run")
				GUICtrlSetState($btnStart,$GUI_DISABLE)
				$boolRun = False
			 EndIf
		case $cbxHideGW
			If GUICtrlRead($cbxHideGW) = 1 Then
				DisableRendering()
				AdlibRegister("ClearMemory", 20000)
				WinSetState(GetWindowHandle(), "", @SW_HIDE)
			Else
				EnableRendering()
				AdlibUnRegister("ClearMemory")
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
			EndIf
		case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
EndFunc

#region botCode
Func mainLoop()
	GUICtrlSetData($lblRuns, "Total Runs: " & $run)
	If $firstRun Then firstRun()
    goOutside()
	If Not useSkillEx(7) Then Return False
	If Not runToNextPosition(-14645, 8198) Then Return False
	CommandAll(-16760, 5486)
	If Not useSkillEx(8) Then Return False
	If Not runToNextPosition(-13616, 8409) Then Return False
	If Not runToNextPosition(-12010, 10584) Then Return False
	If Not runToNextPosition(-10646, 10847) Then Return False
	If Not runToNextPosition(-8828, 11882) Then Return False
	Do
		sleep(400)
		If GetDistance(GetNearestEnemyToAgent(-2)) > 156 Then
			SendChat("stuck", '/')
		EndIf
    Until getNumberOfMobsInArea(500) = getNumberOfMobsInArea(1250)
	If Not killMobs() Then Return False
	returnOutpost()
	$run += 1
EndFunc

Func killMobs()
	Upd('Kill Mobs')
	  If GetIsDead(-2) Then
	   returnOutpost()
	   Return False
	  EndIf
    If Not useSkillEx(1) Then Return False
	If Not useSkillEx(3) Then Return False
	Do
		If GetSkillbarSkillRecharge(7) = 0 Then
			If Not useSkillEx(7) Then Return False
		EndIf
		Sleep(50)
	 Until GetSkillbarSkillRecharge(3) = 0
	TargetNearestEnemy()
    If Not useSkillEx(5, GetNearestEnemyToAgent(-2)) Then Return False ;Geisterriss
	If Not useSkillEx(6) Then Return False ;Geist abzapfen
	If Not useSkillEx(2) Then Return False
	If Not useSkillEx(3) Then Return False
    pingSleep(1000)
    TargetNearestAlly()
    If Not useSkillEx(4, -1) Then Return False
    Do
	  Sleep(50)
    Until GetSkillbarSkillRecharge(2) = 0
    If Not useSkillEx(2) Then Return False
	If Not useSkillEx(3) Then Return False
	pingSleep(500)
	DropBundle()
	pingSleep(500)
	Local $defaultStruct = getDefaultStructConfig()
	If Not pickUpLoot($defaultStruct[9], $defaultStruct[10], $defaultStruct[11]) Then Return False
	Return True
EndFunc

Func goOutside()
	Upd("Going Outside")
	Do
		move($COORD_EXIT_X, $COORD_EXIT_Y)
		RndSleep(100)
	Until WaitMapLoading($ZONE)
	Return True
EndFunc

Func useSkillEx($skill, $target = -2)
	Local $tDeadlock = TimerInit()
	Useskill($skill, $target)
	Do
		Sleep(50)
		;If TimerDiff($tDeadlock) > 6000 Then Return False
    If GetIsDead(-2) Then
	   returnOutpost()
	   Return False
    EndIf
	Until GetSkillBarSkillRecharge($skill) <> 0 Or TimerDiff($tDeadlock) > 6000
	Sleep(GetPing() + 250)
	Return True
EndFunc

Func getNumberOfMobsInArea($range = 1250, $agent = -2)
	Local $tmp, $dist
	Local $count = 0
	If Not IsDllStruct($agent) Then $agent = GetAgentByID($agent)
	For $i = 1 To GetMaxAgents()
		$tmp = GetAgentByID($i)
		$dist = GetDistance($agent, $tmp)
		If $dist > $range Then ContinueLoop
		If BitAND(DllStructGetData($tmp, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($tmp, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($tmp, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($tmp, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($tmp, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$count += 1
	Next
	Return $count
EndFunc

Func runToNextPosition($coordX, $coordY, $random = 50)
	MoveTo($coordX, $coordY, $random)
	If GetIsDead(-2) Then
	   returnOutpost()
	   Return False
    EndIf
	Return True
EndFunc

Func Upd($text)
	GUICtrlSetData($lblStatus, $text)
EndFunc

Func travel($mapID)
	TravelTo($mapID)
	pingSleep(1000)
EndFunc

Func returnOutpost()
	Resign()
	pingSleep(3000)
	ReturnToOutpost()
	WaitMapLoading($OUTPOST)
EndFunc

Func firstRun()
	If GetMapID() <> $OUTPOST Then travelTo($OUTPOST)
    SwitchMode(0)
	LoadSkillTemplate($BUILD)
	AddHero(6)
	$firstRun = False
EndFunc
#endregion

Func pingSleep($delay = 0)
   Sleep(getPing() + $delay)
EndFunc