#cs ----------------------------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Stitched together by:         none1234
		 massive credits to maverick, 4d1 (http://www.gamerevision.com/showthread.php?2120-GWA%B2-LDoA-Bot)
		 lots of credit to jcaulton, tormiasz, cocophobia, starsoverstars, and the gwa2 crew

____Directions____________________________________________________________________________________

		1. make a pretty character in prophecies campaign
		2. skip cutscene
		3. run bot

____Notes_________________________________________________________________________________________

		-if farmer hamnet quest NOT available bot will hang.
			-> restart bot on farmer hamnet quest day and it will run as normal

		-to save time bot will NOT complete secondary prof quests, choose secondary profession, or
		 unlock all primary skills.

				-> if you want specific functionality, use JCAULTON's vanq autobot creator & insert a
				   new func into profpaths.au3.

					-> place a call for that func anywhere appopriate (suggested places are after
					   "Profession0" in Bot1 or in the "VirginVanguard" check

		-preferred skillbar setup for lvl 10-20:
			1 - regen
			2 - spam damage
			3 - aoe damage
			4 - damage
			5 - heal
			6 - heal
			7 - degen/damage

		-bot has capability to autoload templates, see template code function @ bottom of script

____Issues________________________________________________________________________________________

		-Lag during lvls 1-2
			-> if a quest is skipped to due to lag, recreate char & rerun script.
		-Render on main GUI
			-> use render from systray if you want to hide gw



#ce -----------------------------------------------------------------------------------------------


#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <GUIConstantsEx.au3> ;for GUI stuff
#include <WindowsConstants.au3> ;for $SS_CENTER
#include <StaticConstants.au3> ;for $WS_GROUP
#include <ComboConstants.au3>
#include <TabConstants.au3>
#include <Array.au3>
#include "GWA2.au3"
#include <Timers.au3>
#include "profpaths.au3"

#region Globals
Global Const $MapAscalon = 148
Global Const $MapAshford = 164
Global Const $MapFoiblesFair = 165
Global $CharName
Global $boolInitialized = False
Global $boolRun = False
Global $boolIgneous = True ; Change that to True if you want to use igneous stone and put the stone in 1st backpack slot
Global $boolSurvivor = False ; Change that to True if you want to try and get survivor - not perfect
Global $boolLoot = True    ; Change that to True if you want to pick up weapons appropriate for your profession
Global $Rendering = True   ; leave this alone, change via gui or systray
Global $RunOnce = True
Global $Rurik = True
Global $VanguardVirgin = True
Global $intRuns = 0
Global $intDeaths = 0
Global $intExperience = 0
Global $intXP = -1
Global $proRuns = 5
Global $GOLD
Global $EXP
Global $lPlayer
Global $level
Global $StartingLevel
Global $lvlprogbar
Global $experienceleft
Global $MyMaxHP
Global $FREAKOUT = False

Global $ModelIgneous = 30847

Global $ModelIE = 1402
Global $ModelBR = 7764
Global $ModelBF = 7763
Global $ModelSQ = 1423
Global $ModelRB = 1387
Global $qFarmer = 1185	;quest ID for "Vanguard Bounty Farmer Hamnet"?

#endregion Globals

#region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate("Proph Char v1.0", 270, 280, 200, 180)
Local $logged_chars = GetLoggedCharNames()
Local $lblName = GUICtrlCreateLabel("Character Name:", 8, 34, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
Global $txtName = GUICtrlCreateCombo("", 105, 34, 150, 20, $SS_CENTER)
   If ($logged_chars == "") Then
	  GUICtrlSetState(-1, $GUI_DISABLE)
   Else
	  GUICtrlSetData(-1, $logged_chars, StringSplit($logged_chars, "|", 2)[0])
   EndIf
Global $cbxigneous = GUICtrlCreateCheckbox("Use Igneous", 8, 8, 110, 17)
   If $boolIgneous Then GUICtrlSetState(-1, $GUI_CHECKED)
Global $cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 135, 8, 110, 17)
   If Not $Rendering Then GUICtrlSetState(-1, $GUI_CHECKED)
$lblR2D2 = GUICtrlCreateLabel("Total Runs:", 8, 60, 130, 17)
$lblRuns = GUICtrlCreateLabel("-", 140, 60, 100, 17, $SS_CENTER)
$lblCash = GUICtrlCreateLabel("Total Gold On Player:", 8, 84, 130, 17)
$lblGold = GUICtrlCreateLabel($GOLD, 140, 84, 100, 17, $SS_CENTER)
$lblXP = GUICtrlCreateLabel("Total Experience:", 8, 108, 130, 17)
$lblExperience = GUICtrlCreateLabel($EXP, 140, 108, 100, 17, $SS_CENTER)
$lblLvl = GUICtrlCreateLabel("Character Level:", 8, 128, 130, 17)
$lblLevel = GUICtrlCreateLabel($level, 140, 128, 100, 17, $SS_CENTER)
$statexpleft = GUICtrlCreateLabel("XP Left until next Level:", 8, 148, 140, 17)
$lblexpleft = GUICtrlCreateLabel($experienceleft, 140, 148, 100, 17, $SS_CENTER)
$lvlbar = GUICtrlCreateProgress(8, 195, 256, 10)
$lblpercent = GUICtrlCreateLabel("Percent:" , 8, 176, 100, 17)
$percent = GUICtrlCreateLabel(Round($lvlprogbar,1) & "%", 144, 176, 100, 17, $SS_CENTER)
$lblStatus = GUICtrlCreateLabel("Ready to begin", 8, 219, 256, 17, $SS_CENTER)
Global $btnStart = GUICtrlCreateButton("load Character", 7, 242, 256, 25, $WS_GROUP)
GUICtrlSetData($lvlbar, $lvlprogbar)

GUICtrlSetOnEvent($cbxigneous, "EventHandler")
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

GUISetState(@SW_SHOW)

;Opt("TrayMenuMode", 3)
;Opt("TrayAutoPause", 0)
;Opt("TrayOnEventMode", 1)

#NoTrayIcon ; no tray icon
;TraySetIcon(@ScriptDir & "\xp.ico")
;	TraySetToolTip($CharName & " level " & $level & @CRLF & "0 runs.")
;	$cbxHideGW = TrayCreateItem("Change Render")
;		TrayItemSetOnEvent(-1, "TrayHandler")
Do
   Sleep(500)
Until $boolRun
Main()

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			If Not $boolInitialized Then
				If initialize(GUICtrlRead($txtName), True, True, True) Then
				   	  $CharName = GetCharname()
				   	  GUICtrlSetState($txtName, $gui_disable)
				   	  If GUICtrlRead($txtName) == "" Then GUICtrlSetData($txtName, $CharName, $CharName)
				   	  WinSetTitle($cGUI, "", "GW: Tut-leveling - " & $CharName)
				   	  GUICtrlSetState($cbxigneous, $gui_enable)
				   	  GUICtrlSetState($cbxHideGW, $gui_enable)
				   	  GUICtrlSetData($btnstart, "Start Bot")
					  $MyMaxHP = gethealth()
					  $lPlayer = GetAgentByID(-2)
					  $GOLD = GetGoldCharacter()
					  $EXP = GetExperience()
					  $StartingLevel = GetLevel()
					  $level = GetLevel()
					  $lvlprogbar = BarUpdate(1)
					  $experienceleft = BarUpdate(2)
					  ToggleLanguage()
					  $boolInitialized = True
				   	  Return True
				Else
				   	  MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
				   	  Return False
				EndIf
			EndIf
			$boolRun = Not $boolRun
			If $boolRun Then
				GUICtrlSetData($btnStart, "Starting...")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
				If GUICtrlRead($cbxHideGW) = 1 Then ToggleRendering()

				GUICtrlSetData($btnStart, "Stop")
				GUICtrlSetState($btnStart, $GUI_ENABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
			Else
				GUICtrlSetData($btnStart, "Continue")
;				GUICtrlSetState($txtName, $GUI_ENABLE)
			EndIf
		Case $cbxHideGW
			If $mGWProcHandle <> 0 Then ToggleRendering()
		Case $cbxigneous
			$boolIgneous = Not $boolIgneous
		Case $GUI_EVENT_CLOSE
			If Not $Rendering Then ToggleRendering()
			ToggleLanguage()
			Exit
	EndSwitch
EndFunc   ;==>EventHandler

Func Update($text)
	GUICtrlSetData($lblStatus, $text)
EndFunc   ;==>Update

Func ToggleRendering()
	If $Rendering Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		$Rendering = False
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
		$Rendering = True
	EndIf
EndFunc   ;==>ToggleRendering
#endregion GUI

#region Main
Func Main()
	While 1
		Switch GetLevel()
			Case 1
				Update("Welcome to Ascalon")
				PingSleep(200)
				If $boolRun Then
					If GetMapID() <> $MapAscalon Then RndTravel($MapAscalon)
						$boolRun = True
					If $RunOnce = True Then
						CloseAllPanels()
						ToggleQuestWindow()
						$RunOnce = False
					EndIf
						Bot1()
				GUICtrlSetData($lblRuns, $intRuns & " (" & $intDeaths & ")")
				Refresh()
				Update("Stats Updated")
				PingSleep(500)
			EndIf
			Case 2 to 9
				PingSleep(200)
				If $boolRun Then
					Update("Map Check")
					If GetMapID() <> $MapAscalon Then RndTravel($MapAscalon)
						$boolRun = True
					If $Rurik = True Then
						$intRuns = 0
						CloseAllPanels()
						ToggleQuestWindow()
						$Rurik = False
					EndIf
						Bot2()
				GUICtrlSetData($lblRuns, $intRuns & " (" & $intDeaths & ")")
				Refresh()
				Update("Stats Updated")
				PingSleep(500)
				EndIf
			Case 10 to 20
				PingSleep(200)
				If $boolRun Then
					If GetMapID() <> $MapFoiblesFair Then RndTravel($MapFoiblesFair)
						$boolRun = True
					If $VanguardVirgin = True Then
						CloseAllPanels()
						ToggleQuestWindow()
						LevelTenPrep()
						SetSkillbar()
						$VanguardVirgin = False
					EndIf
						Bot3()
				GUICtrlSetData($lblRuns, $intRuns & " (" & $intDeaths & ")")
				Refresh()
				Update("Stats Updated")
				PingSleep(500)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Main

#endregion Main

#region Bots
Func Bot1()
	If GetMapID() <> 148 Then ;Ascalon City outpost
		TravelTo(148)
		SwitchMode(1)
		RndSleep(250)
	EndIf
	LevelZero()
	Switch GetHeroProfession(0)
		Case 1 ; warrior
			Warrior0()
		Case 2 ; ranger
			Ranger0()
		Case 3 ; monk
			Monk0()
		Case 4 ; necromancer
			Necromancer0()
		Case 5 ; mesmer
			Mesmer0()
		Case 6 ; elementalist
			Elementalist0()
	EndSwitch
EndFunc ; end lvl 0-2

Func Bot2()  ;  charr at the gates farm
	Update("Quest Check...")
		sleep(200)
		If GetQuestById(46)<>0 = False Then
			Update("Quest not taken, grabbing")
			MoveTo(5930, 10680, 20)
				GoNearestNPCToCoords(5700, 10650)
			PingSleep(200)
				AcceptQuest(46)
			PingSleep(200)
				Update("Waiting for quest acceptance...")
			Do
				Sleep(100)
			Until GetQuestById(46) <> 0
				Update("Quest accepted, continuing")
				MoveTo(7670, 10570, 20)
		EndIf
	Update("Quest complete?")
		sleep(200)
		If GetQuestState(3, 46) = True Then
			Update("Quest completed, ditching")
				RandomBreak(.95, 10000, 15513)
			AbandonQuest(46)
				Update("Refreshing quest")
			MoveTo(5930, 10680, 20)
				GoNearestNPCToCoords(5700, 10650)
			PingSleep(200)
				AcceptQuest(46)
			PingSleep(200)
				Update("Waiting for quest acceptance...")
			Do
				Sleep(100)
			Until GetQuestById(46) <> 0
				Update("Quest accepted, continuing")
				MoveTo(7670, 10570, 20)
		EndIf
	PingSleep(1000)
	Update("Going outside")
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		WaitMapLoading()
	PingSleep(2000)
		If $boolIgneous Then
			UseIgneousSummonStone()
			PingSleep(500)
		EndIf
	If GetQuestState(3, 46) = True Then
		Return
	EndIf
		MoveTo(6220, 4470, 30)
			PingSleep(2000)
		Update("Going to the gate")
			PingSleep(200)
		MoveTo(3180, 6468, 30)
			PingSleep(200)
		MoveTo(360, 6575, 30)
			PingSleep(200)
		MoveTo(-3140, 9610, 30)
			PingSleep(200)
		MoveTo(-3640, 10930, 30)
			Update("Waiting for Rurik to kill mobs")
			PingSleep(3000)
		If GetIsDead(-2) Then $intDeaths += 1
			MoveTo(-4870, 11470, 30)
		$lDeadlock = TimerInit()
		Do
			If GetIsDead(-2) Then $intDeaths += 1
			If $boolSurvivor = True Then SurvivorCheck()
			PingSleep(200)
				If TimerDiff($lDeadlock) > 100000 Then
					update("Time limit reached!")
				EndIf
		Until GetNumberOfFoesInRangeOfAgent(-2, 2000) = 1 Or TimerDiff($lDeadlock) > 100000 or $FREAKOUT = True; >2 min
			If $FREAKOUT <> False Then RndTravel($MapAscalon)
			PingSleep(200)
		RndTravel($MapAscalon)
EndFunc ; end lvl 2-10

Func Bot3()  ;  vanguard bandit farm
	Local $aAgent
PingSleep(1000)
	$MyMaxHP = gethealth()
;RandomBreak()
Update("Going outside")
RandomPath(260, 8120, 630, 7270, 30, 1, 4, -1)
WaitMapLoading()
PingSleep(2000)
If $boolIgneous Then
	Update("Summoning Fire Imp")
	UseIgneousSummonStone()
	PingSleep(500)
EndIf
MoveTo(1972, 5920)
ChangeTarget(GetAgentByName("Ice Elemental"))
	Sleep(500)
	$aAgent = GetAgentByID(-1)
	$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
	$agent_distance = Round(GetDistance($aAgent))
		If $agent_model_id = $ModelIE AND $agent_distance < 1500 Then
			PingSleep(100)
			ActionInteract()
			PingSleep(50)
			Update("Killing Elemental")
			While GetAgentExists(-1) ; Killing Elemental
				If GetSkillBarSkillRecharge(2, 0) = 0 Then
					update("Killing Elemental - skill 2 spam")
					UseSkill(2, -1) ; Flare
					PingSleep(200)
				EndIf
			WEnd
		PickUpLoot()
		PingSleep()
		update("recharging pull skill")
			Do
				Sleep(20)
			Until GetSkillBarSkillRecharge(2,0) = 0
		EndIf
Update("Aggroing bandits")
MoveToMobs(2617, 3687)
	TargetNearestEnemy()
		PingSleep()
	Attack(-1)
		PingSleep(10)
	UseSkill(2, -1); pull
		Pingsleep(750) ; cast time
	Update("Pulling to npc")
	MoveTo(2200, 5800)
		PingSleep(1000) ; let npc agro
			Local $killdeadlock = TimerInit()
			Local $killdeadlock_diff = timerdiff($killdeadlock)
			Local $killdeadlock_exit = 100000
		Switch GetLevel()
			Case 18
				$killdeadlock_exit = 120000
			Case 19
				$killdeadlock_exit = 120000
			Case 20
				$killdeadlock_exit = 120000
			Case Else
				Local $killdeadlock_exit = 100000
		EndSwitch
	Do
		Switch GetLevel()
			Case 18 To 20
				Update("Killing Countdown - " & 120000-Round($killdeadlock_diff) & ".")
			Case Else
				Update("Killing Countdown -  " & 100000-Round($killdeadlock_diff) & ".")
		EndSwitch
		TargetNearestEnemy()
			PingSleep()
		Attack(-1)
			PingSleep(50)
		CastSpells()
			PingSleep(50)
			$killdeadlock_diff=TimerDiff($killdeadlock)
Until GetNumberOfFoesInRangeOfAgent(-2) = 0 or $killdeadlock_diff > $killdeadlock_exit Or $FREAKOUT = True
	If $FREAKOUT <> True Then PickUpLoot()
Update("Traveling back")
	If $FREAKOUT <> False Then Update("FREAK OUT!")
RndTravel($MapFoiblesFair) ; Reduces detectability, I used only EU districts, but u can change that.
EndFunc; end lvl 10-20
#endregion Bots


#region Funcs
Func CastSpells()

Local $MyCurrentHP
Local $Enchant


$MyCurrentHP = gethealth(-2)

SurvivorCheck()
	If $FREAKOUT = False And $MyCurrentHP < ($MyMaxHP * .65) Then
		update("low on hp, healing")
			If GetSkillBarSkillRecharge(5, 0) = 0 Then UseSkillEx(5, -1) ; Ether feast or other heal spell
		PingSleep()
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And $MyCurrentHP < ($MyMaxHP * .85) Then
		update("begin regen skill")
			If GetSkillBarSkillRecharge(1, 0) = 0 Then
				$Enchant = getisenchanted(-2)
				Select
					Case $Enchant = False
						update("begin regen skill: casting")
						UseSkillEx(1, -1) ; begin regen heal -- healing breeze
						PingSleep()
					Case $Enchant = True
						update("begin regen skill: already enchanted")
				EndSelect
			EndIf
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And GetSkillBarSkillRecharge(2, 0) = 0 Then
		ActionInteract()
		UseSkillEx(2, -1) ; Flare
		PingSleep()
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And Not GetIsMoving(-1) Then
		Switch GetHeroProfession(0) ; aoe check
			Case 3 ; monk
				$aAgent = GetAgentByID(-1)
				$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
					If $agent_model_id = $ModelBR Then
						If GetSkillBarSkillRecharge(3, 0) = 0 Then UseSkillEx(3, -1) ; Fire storm only on immobile targets, i.e. fire bandit or melee bandit that has stopped moving
						PingSleep()
					EndIf
			Case 6 ; ele
				If GetSkillBarSkillRecharge(3, 0) = 0 Then UseSkillEx(3, -1) ; Fire storm only on immobile targets, i.e. fire bandit or melee bandit that has stopped moving
				PingSleep()
		EndSwitch
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And GetSkillBarSkillRecharge(4, 0) = 0 Then
		UseSkillEx(4, -1) ; damage
		PingSleep()
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And GetSkillBarSkillRecharge(7, 0) = 0 Then
		UseSkillEx(7, -1) ; degen
		PingSleep()
	EndIf
SurvivorCheck()
	If $FREAKOUT = False And $MyCurrentHP < ($MyMaxHP * .65) Then
		If GetSkillBarSkillRecharge(6, 0) = 0 Then UseSkillEx(6, -1) ; orison
		PingSleep()
	EndIf
SurvivorCheck()
EndFunc   ;==>CastSpells

Func SurvivorCheck()
		Local $MyCurrentHP
		$MyCurrentHP = gethealth(-2)

	If $boolSurvivor = True And ($MyCurrentHP < ($MyMaxHP * .3)) Then
		$FREAKOUT = True
	ElseIf $boolSurvivor = True And ($MyCurrentHP > ($MyMaxHP * .3)) Then
		$FREAKOUT = False
	Else
		$FREAKOUT = False
	EndIf
EndFunc

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	If $ping > 350 Then ; To deal with larger pings
		Sleep(Random(200, 300, 1) + $msExtra)
	Else
		Sleep($ping + $msExtra)
	EndIf
EndFunc   ;==>PingSleep

Func RandomBreak($percent = .95, $min = 10000, $max = 60000)
	If Random() > $percent Then
		Update("Performing a random break")
		PingSleep(Random($min, $max))
		Update("Resuming")
	EndIf
EndFunc   ;==>RandomBreak

; This func creates a random path for exiting outposts. It needs the coords of a spot
; in front of the exit-portal and the coords of a spot outside the portal for exiting.
; You may need to play around with the $aRandom to see which number fits you best.
Func RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY, $aRandom = 50, $StopsMin = 1, $StopsMax = 5, $NumberOfStops = -1) ; do not change $NumberOfStops

	If $NumberOfStops = -1 Then $NumberOfStops = Random($StopsMin, $StopsMax, 1)

	Local $lAgent = GetAgentByID(-2)
	Local $MyPosX = DllStructGetData($lAgent, 'X')
	Local $MyPosY = DllStructGetData($lAgent, 'Y')
	Local $Distance = ComputeDistance($MyPosX, $MyPosY, $PortalPosX, $PortalPosY)

	If $NumberOfStops = 0 Or $Distance < 200 Then
		MoveTo($PortalPosX, $PortalPosY, (2 * $aRandom)) ; Made this last spot a bit broader
		Move($OutPosX + Random(-$aRandom, $aRandom, 1), $OutPosY + Random(-$aRandom, $aRandom, 1))
	Else
		Local $m = Random(0, 1)
		Local $n = $NumberOfStops - $m
		Local $StepX = (($m * $PortalPosX) + ($n * $MyPosX)) / ($m + $n)
		Local $StepY = (($m * $PortalPosY) + ($n * $MyPosY)) / ($m + $n)

		MoveTo($StepX, $StepY, $aRandom)
		RandomPath($PortalPosX, $PortalPosY, $OutPosX, $OutPosY,  $aRandom, $StopsMin, $StopsMax, $NumberOfStops - 1)
	EndIf
EndFunc

Func RndTravel($aMapID)
	Local $UseDistricts = 4 ; 7=eu-only, 8=eu+us, 9=eu+us+int, 12=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 0, -2, 1, 3, 4]
	Local $Language[11] = [4, 5, 9, 10, 0, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	WaitMapLoading($aMapID, 30000)
	PingSleep(3000)
EndFunc   ;==>RndTravel




Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
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

EndFunc   ;==>GetNumberOfFoesInRangeOfAgent


Func PickUpLoot()
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True
		update("Looking for loots")
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
		If Not GetCanPickUp($lAgent) Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
			Do
				If GetDistance($lItem) > 150 Then Move(DllStructGetData($lItem, 'X'), DllStructGetData($lItem, 'Y'), 100)
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

Func GetLevel()

	Local $myXP = GetExperience()

	Select
		Case $myXP < 2000
			Return 1
		Case $myXP >= 2000 And $myXP < 4600
			Return 2
		Case $myXP >= 4600 And $myXP < 7800
			Return 3
		Case $myXP >= 7800 And $myXP < 11600
			Return 4
		Case $myXP >= 11600 And $myXP < 16000
			Return 5
		Case $myXP >= 16000 And $myXP < 21000
			Return 6
		Case $myXP >= 21000 And $myXP < 26600
			Return 7
		Case $myXP >= 26600 And $myXP < 32800
			Return 8
		Case $myXP >= 32800 And $myXP < 39600
			Return 9
		Case $myXP >= 39600 And $myXP < 47000
			Return 10
		Case $myXP >= 47000 And $myXP < 55000
			Return 11
		Case $myXP >= 55000 And $myXP < 63600
			Return 12
		Case $myXP >= 63600 And $myXP < 72800
			Return 13
		Case $myXP >= 72800 And $myXP < 82600
			Return 14
		Case $myXP >= 82600 And $myXP < 93000
			Return 15
		Case $myXP >= 93000 And $myXP < 104000
			Return 16
		Case $myXP >= 104000 And $myXP < 115600
			Return 17
		Case $myXP >= 115600 And $myXP < 127800
			Return 18
		Case $myXP >= 127800 And $myXP < 140600
			Return 19
		Case $myXP >= 140600
			Return 20
	EndSelect
EndFunc   ;==>GetLevel

Func BarUpdate($booltoggle)

	Local $getlvl, $progbar, $prog, $expleft

	$getlvl = GetLevel()

	;set up values depending on level
	If $getlvl = 1 Then
		$bar0 = 0
		$bar100 = 2000
	EndIf

	If $getlvl = 2 Then
		$bar0 = 2000
		$bar100 = 4600
	EndIf

	If $getlvl = 3 Then
		$bar0 = 4600
		$bar100 = 7800
	EndIf

	If $getlvl = 4 Then
		$bar0 = 7800
		$bar100 = 11600
	EndIf

	If $getlvl = 5 Then
		$bar0 = 11600
		$bar100 = 16000
	EndIf

	If $getlvl = 6 Then
		$bar0 = 16000
		$bar100 = 21000
	EndIf

	If $getlvl = 7 Then
		$bar0 = 21000
		$bar100 = 26600
	EndIf

	If $getlvl = 8 Then
		$bar0 = 26600
		$bar100 = 32800
	EndIf

	If $getlvl = 9 Then
		$bar0 = 32800
		$bar100 = 39600
	EndIf

	If $getlvl = 10 Then
		$bar0 = 39600
		$bar100 = 47000
	EndIf

	If $getlvl = 11 Then
		$bar0 = 47000
		$bar100 = 55000
	EndIf

	If $getlvl = 12 Then
		$bar0 = 55000
		$bar100 = 63600
	EndIf

	If $getlvl = 13 Then
		$bar0 = 63600
		$bar100 = 72800
	EndIf

	If $getlvl = 14 Then
		$bar0 = 72800
		$bar100 = 82600
	EndIf

	If $getlvl = 15 Then
		$bar0 = 82600
		$bar100 = 93000
	EndIf

	If $getlvl = 16 Then
		$bar0 = 93000
		$bar100 = 104000
	EndIf

	If $getlvl = 17 Then
		$bar0 = 104000
		$bar100 = 115600
	EndIf

	If $getlvl = 18 Then
		$bar0 = 115600
		$bar100 = 127800
	EndIf

	If $getlvl = 19 Then
		$bar0 = 127800
		$bar100 = 140600
	EndIf

	If $getlvl = 20 Then
		$progbar = 100
		$bar0 = 0
		$bar100 = 0
	EndIf

	;Start The Percentage Equation

	If $progbar = 100 Then
		Sleep(100)
	Else
		$progbar = (GetExperience() - $bar0) / ($bar100 - $bar0) * 100
	EndIf

	$expleft = ($bar100 - $bar0) - (GetExperience() - $bar0)

;What are we giving back?
If $booltoggle = 1 Then
	Return $progbar
ElseIf $booltoggle = 2 AND GetLevel() <> 20 Then
	Return $expleft
Else
	Return 666
EndIf

EndFunc

Func Refresh()
	Local $lAgent = GetAgentByID(-2)
	$GOLD = GetGoldCharacter()
	$EXP = GetExperience()

	$level = GetLevel()
	$intRuns += 1
	$lvlprogbar = BarUpdate(1)
	$experienceleft = BarUpdate(2)
	Sleep(100)

	If $StartingLevel < $level Then ; ==== adjust skills as we afk level
		Update("Distributing new Attribute points")
		SetSkillbar()
		$StartingLevel = $level
	EndIf

	GuiCtrlSetData($percent, Round($lvlprogbar,1) & "%")
	GUICtrlSetData($lvlbar, $lvlprogbar)
	GUICtrlSetData($lblRuns, $intRuns)
	GUICtrlSetData($lblGold, $GOLD)
	GUICtrlSetData($lblExperience, $EXP)
	GUICtrlSetData($lblexpleft, $experienceleft)
	GUICtrlSetData($lblLevel, $level)

	TraySetToolTip($CharName & " level " & $level & @CRLF & $intRuns & " runs."& @CRLF & Round($lvlprogbar,1) & "% til level " & $level+1)
EndFunc   ;==>Refresh


Func CanPickUp($aitem)
	$m = DllStructGetData($aitem, 'ModelID')
	$e = DllStructGetData($aItem, 'ExtraID') 		; 2=blue, 3=green, 4=purple, 5=red, 6=yellow, 7=brown, 8=orange, 9=silver, 10=BLACK, 11=gray, 12=WHITE, 13=pink
	$w = DllStructGetData($aitem, 'WeaponType') 	; 1=bow, 2=axe, 3=hammer, 7=sword, 9=chaos, 10=dark, 11=earth, 12=lightning, 13=fire, 14=holy
	$t = DllStructGetData($aitem, 'type')  			; 2 = axe, 3 = hammer, 7 = sword, 10-14 = focus, 22 = wand, 24 = shield, 26 = staff
	$r = GetRarity($aitem)							; 2621=white, 2623=blue, 2626=purple, 2624=gold
	$p = GetHeroProfession(0)
		Switch $boolLoot
			Case False
				If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
					Return True
				ElseIf $m = 146 Or $m = 427 OR $m = 424 or $m = 431 Or $m = 2566 Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone, SHIMMERING SCALE
					Return True
				Else
					Return False
				EndIf
			Case True
				Switch GetHeroProfession(0)
					Case 1 ; warrior
						update("Can a hamstorm use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431  Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
								If $e = 10 Or $e = 12 Then ; Black, White   ------comment out this line if you want all dye colors
									Return True
									EndIf
						ElseIf $t = 2 Or $t = 3 or $t = 7 or $t = 24 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
					Case 2 ; ranger
						update("Can a bowbear use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431  Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
							If $e = 10 Or $e = 12 Then ; Black, White-----comment out this line if you want all dye colors
							Return True
							EndIf
						ElseIf $w = 1 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
					Case 3 ; monk
						update("Can a healer use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431  Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
							If $e = 10 Or $e = 12 Then ; Black, White-----comment out this line if you want all dye colors
							Return True
							EndIf
						ElseIf $t = 10 or $t = 11 or $t = 12 or $t = 13 or $t = 14 or $t = 22 or $t = 24 or $t = 26 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
					Case 4 ; necromancer
						update("Can a necro use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431  Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
							If $e = 10 Or $e = 12 Then ; Black, White-----comment out this line if you want all dye colors
							Return True
							EndIf
						ElseIf $t = 10 or $t = 11 or $t = 12 or $t = 13 or $t = 14 or $t = 22 or $t = 24 or $t = 26 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
					Case 5 ; mesmer
						update("Can a ruptbot use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431  Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
							If $e = 10 Or $e = 12 Then ; Black, White-----comment out this line if you want all dye colors
							Return True
							EndIf
						ElseIf $t = 10 or $t = 11 or $t = 12 or $t = 13 or $t = 14 or $t = 22 or $t = 24 or $t = 26 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
					Case 6 ; elementalist
						update("Can a flagger use this?")
						If $m == 835 Or $m == 933 Or $m == 921 Or $m == 28434 OR $m = 28435 Or $m = 556 Or $m = 28436 Or $m == 30648  Or $m == 30855 Or $m = 2511 Or $m = 37765 Or $m = 6375 Or $m = 21492 Or $m = 6376 Then
							Return True
						ElseIf $m = 427 OR $m = 424 or $m = 431 Or $m = 2566 Then ;Dyes/Worn belts; icy lodestone, enchanted lodestone, SHIMMMERING SCALE
							Return True
						ElseIf $m = 146 Then ;Dyes
							$e = DllStructGetData($aItem, 'ExtraID')
							If $e = 10 Or $e = 12 Then ; Black, White-----comment out this line if you want all dye colors
							Return True
							EndIf
						ElseIf $t = 10 or $t = 11 or $t = 12 or $t = 13 or $t = 14 or $t = 22 or $t = 24 or $t = 26 Then ;appropriate weapons
							If $r <> 2621 Then ; check for blues/purps cause big damage!
								Return True
								EndIf
						Else
							Return False
						EndIf
				EndSwitch
		EndSwitch
EndFunc   ;==>CanPickUp

Func MoveToMobs($aX,$aY)
Do
	Move($aX,$aY)
	Sleep(100)
Until GetNumberOfFoesInRangeOfAgent(-2,1100) > 0
EndFunc

Func TrayHandler()
	Switch (@TRAY_ID)
		Case $cbxHideGW
				ToggleRendering()
		EndSwitch
EndFunc   ;==>TrayHandler

Func GetQuestState($state, $QuestID) ; $state -> 1 = active, 3 = completed
	$strucQuest = GetQuestByID($QuestID)
	$hasState = DllStructGetData($strucQuest,"LogState")
	If $hasState = $state Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func GoNearestNPCToCoords($x, $y)
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

; Finds NPC nearest given coords and talks to him/her
Func GoToNPCNearestCoords($x, $y)
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
EndFunc   ;==>GoToNPCNearestCoords

Func SetSkillbar()
	Update("Loading skillbar")
		Switch GetHeroProfession(0)
			Case 1 ; warrior
				Switch GetLevel()
					Case 10
						LoadSkillTemplate("OQATED6VrIA+FwAAAAAAaFA",0)
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
			Case 2 ; ranger
				Switch GetLevel()
					Case 10
						LoadSkillTemplate("OgATcDclvw3KGAAAAAAAAAA",0)
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
			Case 3 ; monk
				Switch GetLevel()
					Case 10
						LoadSkillTemplate("OwAT0K3BjAk87eoMjAAAAAA",0)
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
			Case 4 ; necromancer
				Switch GetLevel()
					Case 10
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
			Case 5 ; mesmer
				Switch GetLevel()
					Case 10
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
			Case 6 ; elementalist
				Switch GetLevel()
					Case 10
					Case 11
					Case 12
					Case 13
					Case 14
					Case 15
					Case 16
					Case 17
					Case 18
					Case 19
				EndSwitch
	EndSwitch
 EndFunc

 Func UseIgneousSummonStone()
   For $i = 1 To 4	;bags
	  For $j = 0 To DllStructGetData(GetBag($i), 'Slots') - 1	;slots
		 $lItemInfo = GetItemBySlot($i, $j)
		 If DllStructGetData($lItemInfo, 'ModelID') == $ModelIgneous Then
			UseItem($lItemInfo)
			Return True
		 EndIf
	  Next
   Next
   Return False
 EndFunc
#endregion Funcs