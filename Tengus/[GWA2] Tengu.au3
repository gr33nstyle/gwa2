#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Danylia

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;global variables;

Global $build = "OgEUQrqeVsSXF9F8E7g+GMH5iBAA"; +1+2 wilderness survivial, +1 expertise, +50hp, 2*+10hp, 5*brawlers insignia

Global $RARITY_Gold = 2624
Global $RARITY_Green = 2627

Global $nbFails = 0
Global $nbRuns = 0
Global $nbCommendation = 0
Global $boolrun = False
Global $bInitialized = False
Global $bCanContinue = True
Global $firstrun = True

Global $rendering = True
Global $gwpid = -1

Global $miku = "Miku"

;gui;

Opt("GUIOnEventMode", True)

$GUI = GUICreate("Tengu", 200, 165)

$gSettings = GUICtrlCreateGroup("Settings", 5, 2, 190, 70)
$cCharname = GUICtrlCreateCombo("", 20, 20, 160, 20)
		   GUICtrlSetData(-1, GetLoggedCharNames())
$disableGraph = GUICtrlCreateCheckbox("Disable Graphics", 20, 45)
$gStats = GUICtrlCreateGroup("Stats", 5, 75, 190, 60)
$lblCommendation = GUICtrlCreateLabel("Commendations : ", 20, 93, 160, 20)
$stCommendation = GUICtrlCreateLabel($nbCommendation, 100, 93, 50, 20, $SS_CENTER)
$lblRuns = GUICtrlCreateLabel("Runs : ", 20, 113, 160, 20)
$stRuns = GUICtrlCreateLabel("", 100, 113, 50, 20, $SS_CENTER)
$bStart = GUICtrlCreateButton("Start", 5, 138, 190, 25, $WS_GROUP)

GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($bStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlSetOnEvent($disableGraph, "EventHandler")

Do
   Sleep(100)
Until $bInitialized

While 1
	GUICtrlSetData($stRuns, $nbRuns & "  (" & $nbFails & ")")

	$bCanContinue = True
	If Mod($nbRuns, 20) = 11 And $rendering = false Then
	  ToggleRendering()
	  Sleep(5000)
	  ClearMemory()
	  ToggleRendering()
   EndIf


	logFile("Start run")
	main()
WEnd

Func EventHandler()
Switch (@GUI_CtrlId)
	Case $bStart
	  If GUICtrlRead($cCharname) = "" Then
          If Initialize(ProcessExists("gw.exe"), True, True, True) = False Then
             MsgBox(0,"Error!", "Guild Wars is not running!")
             Exit
          EndIf
	  Else
        Initialize(GUICtrlRead($cCharname),True,True,True)
      EndIf
		$boolrun = True
		$bInitialized = True
		EnsureEnglish(True)
		GUICtrlSetState($bStart,$GUI_DISABLE)

    Case $disableGraph
			ClearMemory()
			ToggleRendering()

	Case $GUI_EVENT_CLOSE
		Exit
EndSwitch
EndFunc	;=> GUIHandler

;main and subfuncs;

Func main()
    If CountSlots() <= 5 Then Inventory()
    If GetMapID() <> 194 And GetMapID() <> 817 Then
	   TravelTo(194)
	EndIf
	EnterQuest()
	PrepareToFight()
	Fight()

	If $bCanContinue Then
		GoToStairs()
	Else
		logFile("Fail at Miku")
	EndIf

	If $bCanContinue Then Survive()
	If $bCanContinue Then PickUpLoot()

	If $bCanContinue Then
		$nbRuns += 1
	Else
		$nbFails += 1
	EndIf

	_PURGEHOOK()
EndFunc

Func EnterQuest()
    Local $lMe = GetAgentById(-2)
    Local $DistancetoEasternSpawnpoint = ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), 3045, -1515)
    Local $DistancetoNorthernSpawnpoint = ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), 2726, 579)
    Local $DistancetoWesternSpawnpoint = ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), -1004, -1538)

	If ($DistancetoWesternSpawnpoint < $DistancetoEasternSpawnpoint) and ($DistancetoWesternSpawnpoint < $DistancetoNorthernSpawnpoint) Then
	   MoveTo(1476, -1203)
    EndIf

    GoToNPC(GetNearestNPCToCoords(2240,-1264))
	Sleep(250)
	Dialog(0x00000084)
	Sleep(500)
	WaitMapLoading()
EndFunc

Func PrepareToFight()
	Local $lMiku
	Local $lDeadLock

	$lMiku = GetAgentByName($miku)

    CommandAll(-5830,-4966)
	CommandHero(1,-6143,-5376)
	CommandHero(2,-5896,-5378)
	CommandHero(3,-6273,-4968)

	MoveTo(-6305,-5264, 10)
;	UseItem(GetItemBySlot(4, 7)) makes groups break

	UseHeroSkill(6,8,-2)
	UseHeroSkill(7,8,$lMiku)
	UseHeroSkill(3,8,$lMiku)
	Sleep(15000)
	UseHeroSkill(1,1)
	Sleep(2000)
	UseHeroSkill(1,5,$lMiku)
	UseHeroSkill(5, 7)
	Sleep(2000)
	UseHeroSkill(1,5,-2)

	Do
		Sleep(250)
    Until GetNumberOfFoesInRangeOfAgent(-2, 2000) > 0
EndFunc

Func Fight()
	Local $lMiku, $lMob
	Local $lDeadLock, $lDeadLock2

    UseSkillEx(7)
	UseSkillEx(2)

	Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku = GetAgentByName($miku)
		Attack($lMob)
		If GetSkillBarSkillRecharge(7) = 0 Then UseSkillEx(7)
	    If GetSkillBarSkillRecharge(1) = 0 Then UseSkillEx(1)
		If GetSkillBarSkillRecharge(3) = 0 Then UseSkillEx(3)
	    If GetSkillBarSkillRecharge(2) = 0 Then UseSkillEx(2)
	    If (GetSkillBarSkillRecharge(4) = 0) and (GetSkillbarSkillAdrenaline(4) >= 130) Then UseSkillEx(4)

		HelpMiku($lMiku)
		Sleep(50)

		If GetisDead($lMiku) or GetIsDead(-2) Then $bCanContinue = False
    Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <= 3 Or $bCanContinue = False

    If $bCanContinue = True Then CancelAll()
    If $bCanContinue = True Then CancelHero(1)
    If $bCanContinue = True Then CancelHero(2)
    If $bCanContinue = True Then CancelHero(3)

	Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku = GetAgentByName($miku)
		Attack($lMob)
		If GetSkillBarSkillRecharge(7) = 0 Then UseSkillEx(7)
	    If GetSkillBarSkillRecharge(1) = 0 Then UseSkillEx(1)
		If GetSkillBarSkillRecharge(3) = 0 Then UseSkillEx(3)
	    If GetSkillBarSkillRecharge(2) = 0 Then UseSkillEx(2)
		If (GetSkillBarSkillRecharge(4) = 0) and (GetSkillbarSkillAdrenaline(4) >= 130) Then UseSkillEx(4)

		HelpMiku($lMiku)
		Sleep(50)

		If GetisDead($lMiku) or GetIsDead(-2) Then $bCanContinue = False
    Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <= 2 Or $bCanContinue = False

    If $bCanContinue = True Then CommandAll(-6304,-5264)

	If $bCanContinue Then MoveTo(-5961, -5082)

    ;$lDeadLock2 = TimerInit()

    Do
	  Sleep(100)
    Until GetNumberOfFoesInRangeOfAgent(-2, 1600) = 0 or GetIsDead(-2) ;Or TimerDiff($lDeadLock2) > 25000

    Sleep(1000)

EndFunc

Func HelpMiku($aMiku)
    If ((DllStructGetData($aMiku, 'HP') < 0.6) and (DllStructGetData($aMiku, 'HP') > 0.4)) Then
	  UseHeroSkill(3, 4, $aMiku)
	  Sleep(1000)
	EndIf
    If DllStructGetData($aMiku, 'HP') < 0.4 Then
	  UseHeroSkill(3, 7, $aMiku)
	  Sleep(1000)
	  UseHeroSkill(3, 4, $aMiku)
	  Sleep(1000)
    EndIf
EndFunc

Func GoToStairs()
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then CommandAll(-6707, -5242)
    If GetIsDead(-2) Then $bCanContinue = False
    If $bCanContinue = True Then MoveTo(-4754, -3336)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo(-4188, -1517)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo(-4716, -620)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo(-2219, -154)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo(-819, -2808)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo(-668, -3780)
    If GetIsDead(-2) Then $bCanContinue = False
	If $bCanContinue = True Then MoveTo( -1070, -4192, 0)
EndFunc

Func Survive()
    Local $lDeadLock
    Local $lMe, $lNrj

    $lDeadLock = TimerInit()

    Do
	    If GetSkillbarSkillRecharge(5) > 2000 and GetSkillbarSkillRecharge(8) > 2000 Then UseSkillEx(6)
        If IsRecharged(5) Then UseSkillEx(5)
	    If DllStructGetData(GetAgentByID(-2), "HP") < 0.8 Then UseHeroSkill(7, 1)
        If IsRecharged(8) Then UseSkillEx(8)
	    If DllStructGetData(GetAgentByID(-2), "HP") < 0.8 Then UseHeroSkill(7, 1)
    Until GetNumberOfFoesInRangeOfAgent(-2, 200) <> 0 Or TimerDiff($lDeadLock) > 60000 Or GetisDead(-2)

    $lDeadLock = TimerInit()

	Do
        If DllStructGetData(GetAgentByID(-2), "HP") < 0.8 Then UseHeroSkill(7, 1)
		If GetSkillbarSkillRecharge(5) > 2000 and GetSkillbarSkillRecharge(8) > 2000 Then UseSkillEx(6)
        If IsRecharged(5) Then UseSkillEx(5)
	    If DllStructGetData(GetAgentByID(-2), "HP") < 0.8 Then UseHeroSkill(7, 1)
        If IsRecharged(8) Then UseSkillEx(8)
    Until GetisDead(-2) Or GetNumberOfFoesInRangeOfAgentYcheck(-2, 200) = 60 or TimerDiff($lDeadLock) > 45000 or DllStructGetData(GetAgentByID(-2), "HP") < 0.4

    Do
        $lNrj = GetEnergy(-2)
		If IsRecharged(8) Then UseSkillEx(8)
        Sleep(250)
    Until $lNrj >= 25 Or GetIsDead(-2)

    UseSkillEx(7)
    UseSkillEx(1)
    UseSkillEx(2)
    UseSkillEx(3)
    UseSkillEx(4, GetNearestEnemyToAgent(-2))

    If GetIsDead(-2) Then
        $bCanContinue = False
        logFile("Fail at the end")
    EndIf

    UseHeroSkill(7, 1)
    Sleep(3000)
EndFunc

;combat;
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
 EndFunc

 Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)
   Sleep(50)
EndFunc

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

 Func GetNumberOfFoesInRangeOfAgentYcheck($aAgent = -2, $aRange = 1250)
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
		$agenty=DllStructGetData($lAgent, 'Y')
		if $agenty <-4500 Then
			$lCount += 1
		EndIf
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next
	Return $lCount
EndFunc

;inventory management;

Func PickUpLoot()
	Local $lAgent
	Local $aitem
	Local $lDeadlock
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
		$aitem = GetItemByAgentID($i)
		If CanPickUp($aitem) Then
			PickUpItem($aitem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				Sleep(100)
				If GetIsDead(-2) Then Return
				If TimerDiff($lDeadlock) > 10000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc   ;==>PickUpLoot

Func CanPickUp($aitem)
	$m = DllStructGetData($aitem, 'ModelID')
	$t = DllStructGetData($AITEM, "Type")
	$r = GetRarity($aitem)
    If $m == 36985 Then ;ministerial commendation
		$nbCommendation += 1
		GUICtrlSetData($stCommendation, $nbCommendation)
        Return True
 	ElseIf $r = $RARITY_Gold and $t = 24 Then
 		Return True
	ElseIf $M = 146 Then
		If DllStructGetData($AITEM, "ExtraId") = 10 or DllStructGetData($AITEM, "ExtraId") = 12 Then
	    Return True
    ElseIf $m = 22751 Then ;lockpicks
		Return True
    Else
	    Return False
	EndIf
	EndIf
EndFunc

Func CountSlots()
	Local $FreeSlots = 0, $lBag, $aBag
	For $aBag = 1 To 4
		$lBag = GetBag($aBag)
		$FreeSlots += DllStructGetData($lBag, 'slots') - DllStructGetData($lBag, 'ItemsCount')
	Next
	Return $FreeSlots
 EndFunc	;=> CountSlots

 Func Inventory($aBags = 4)
    TravelGH()
    $Xunlai = GetAgentByName('Xunlai Chest')
    GoToNPC($Xunlai)
	sleep(500)
	$Merch = GetAgentByName('Merchant')
    GoToNPC($Merch)
	For $i = 1 to $aBags
	   Ident($i)
    Next
    StoreShields(1, 20)
	StoreShields(2, 5)
	StoreShields(3, 10)
	StoreShields(4, 10)
    DepositGold(GetGoldCharacter())
	LeaveGH()
EndFunc	;=> Inventory

Func Ident($BAGINDEX)
	Local $bag
	Local $I
	Local $aitem
	$bag = getbag($bagindex)
	For $I = 1 To DllStructGetData($BAG, "slots")
		If findidkit() = 0 Then
			If getgoldcharacter() < 500 And getgoldstorage() > (500 - getgoldcharacter()) Then
				withdrawgold(500 - getgoldcharacter())
				Sleep(GetPing() + 500)
			EndIf
			Local $J = 0
			Do
				BuyItem(6, 1, 500)
				Sleep(GetPing() + 500)
				$J = $J + 1
			Until findidkit() <> 0 Or $J = 3
			If $J = 3 Then ExitLoop
			Sleep(GetPing() + 500)
		EndIf
		$aitem = getitembyslot($bagindex, $I)
		If DllStructGetData($aitem, "ID") = 0 Then ContinueLoop
		identifyitem($aitem)
		Sleep(GetPing() + 500)
	Next
 EndFunc	;=> Ident

 Func StoreShields($BAGINDEX, $NUMOFSLOTS)
    Local $r_gold = 2624
	Local $aitem
	Local $M
	Local $Q
	Local $bag
	Local $slot
	Local $full
	Local $nslot
	For $I = 1 To $numofslots
		$aitem = getitembyslot($bagindex, $I)
		If DllStructGetData($aitem, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($aitem, "ModelID")
		$Q = DllStructGetData($aitem, "quantity")
		$t = DllStructGetData($aitem, "Type")
		$r = GetRarity($aitem)

	    If  $t = 24 and $r = $r_gold Then
		   Do
				For $bag = 8 To 16
					$slot = findemptyslot($bag)
					$slot = @extended
					If $slot <> 0 Then
						$full = False
						$nslot = $slot
						ExitLoop 2
					Else
						$full = True
					EndIf
					Sleep(400)
				Next
			Until $full = True
			If $full = False Then
				moveitem($aitem, $bag, $nslot)
				Sleep(GetPing() + 500)
			EndIf
		EndIf
	Next
 EndFunc	;=> StoreShields

 Func FindEmptySlot($bagindex)
	Local $liteminfo, $aslot
	For $aslot = 1 To DllStructGetData(getbag($bagindex), "Slots")
		Sleep(40)
		$liteminfo = getitembyslot($bagindex, $aslot)
		If DllStructGetData($liteminfo, "ID") = 0 Then
			SetExtended($aslot)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc	;=> FindEmptySlot

;memory;

Func TOGGLERENDERING()
	If $RENDERING Then
		DISABLERENDERING()
		$RENDERING = False
		Sleep(Random(1000, 3000))
		_REDUCEMEMORY()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
;~ 		AdlibRegister("_ReduceMemory", 20000)
	Else
;~ 		AdlibUnRegister("_ReduceMemory")
		ENABLERENDERING()
		$RENDERING = True
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
EndFunc

Func DISABLEREND()
	DISABLERENDERING()
	$RENDERING = False
	Sleep(Random(1000, 3000))
	_REDUCEMEMORY()
	AdlibRegister("_ReduceMemory", 20000)
EndFunc

Func _REDUCEMEMORY()
	If $GWPID <> -1 Then
		Local $AI_HANDLE = DllCall("kernel32.dll", "int", "OpenProcess", "int", 2035711, "int", False, "int", $GWPID)
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $AI_HANDLE[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $AI_HANDLE[0])
	Else
		Local $AI_RETURN = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $AI_RETURN[0]
EndFunc

Func _PURGEHOOK()
	TOGGLERENDERING()
	Sleep(Random(2000, 2500))
	TOGGLERENDERING()
EndFunc

 Func logFile($string)
	Local $timestamp = "[" & @HOUR & ":" & @MIN & "] "
    $file = FileOpen("log - " & GUICtrlRead($cCharname) & ".txt", 1)
	Sleep(250)
	FileWrite($file, $timestamp & $string & @CRLF)
    FileClose($file)
EndFunc