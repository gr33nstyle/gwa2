#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=tengu.ico
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "../../GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <ScrollBarsConstants.au3>
;Variables

Global $Kaineng = 194
Global $Kaineng2 = 817
Global $firstrun = True
Global $hero
Global $updated = 1

Global $nbFails = 0
Global $nbRuns = 0
Global $nbCitations = 0
Global $bRunning = False
Global $bInitialized = False
Global $bCanContinue = True

Global $render = True
Global $GWPID = -1

Global $xandra = "Xandra"
Global $miku = "Miku"


Global $skill_bar_justice = 1
Global $skill_bar_100b = 2
Global $skill_bar_exLimite = 3
Global $skill_bar_toubillon = 4
Global $skill_bar_stab = 5
Global $skill_bar_echap = 6
Global $skill_bar_EBON = 7
Global $skill_bar_sceau = 8

Global $Array_pscon[5] = [22269, 18345, 26784,30855,6375] ;put here the pcons you want to pickup and change the "3" to the amount of different items.

;Interface

Opt("GUIOnEventMode", True)

$GUI = GUICreate("Tengu Farm R/W 2.2 by Small", 310, 305)

$gSettings = GUICtrlCreateGroup("Settings", 5, 2, 190, 70)
$txtName = GUICtrlCreateCombo("", 20, 20, 160, 20)
GUICtrlSetData(-1, GetLoggedCharNames())
$disableGraph = GUICtrlCreateCheckbox("Disable Graphics", 20, 45)
$gStats = GUICtrlCreateGroup("Stats", 5, 75, 190, 75)
$lblCitations = GUICtrlCreateLabel("Commendations : ", 20, 93, 160, 20)
$stCitations = GUICtrlCreateLabel($nbCitations, 100, 93, 50, 20, $SS_CENTER)
Local $gold = GUICtrlCreateCheckbox("Golds", 200, 0)
Local $green = GUICtrlCreateCheckbox("Greens", 200, 20)
Local $pcons = GUICtrlCreateCheckbox("Pcons", 200, 40)
Local $Mesmers = GUICtrlCreateCheckbox("M", 260, 0)
Local $hm = GUICtrlCreateCheckbox("HM", 260, 20)

$gShields = GUICtrlCreateGroup("Shields", 5, 180, 280, 40)
Local $diamond = GUICtrlCreateCheckbox("Diamond", 10, 193)
Local $Iridescent = GUICtrlCreateCheckbox("Iridescend", 75, 193)
Local $bladed = GUICtrlCreateCheckbox("Bladed", 145, 193)
Local $spiked = GUICtrlCreateCheckbox("Spiked", 200, 193)

$gOther = GUICtrlCreateGroup("Other", 5, 220, 280, 80)
Local $jitte = GUICtrlCreateCheckbox("Jitte", 200, 233)
Local $dragon = GUICtrlCreateCheckbox("Dragon Staff", 75, 233)
Local $bo = GUICtrlCreateCheckbox("Bo Staff", 10, 233)
Local $Platinum = GUICtrlCreateCheckbox("Platinum Staff",10,273)
Local $shinobi = GUICtrlCreateCheckbox("Shinobi Blade",95,273)

$lblRuns = GUICtrlCreateLabel("Number of Runs : ", 20, 113, 160, 20)
$stRuns = GUICtrlCreateLabel("", 100, 113, 50, 20, $SS_CENTER)
GUICtrlSetData($stRuns, $nbRuns & "  (" & $nbFails & ")")
$bStart = GUICtrlCreateButton("Start", 5, 153, 190, 25, $WS_GROUP)
$StatusLabel = GUICtrlCreateEdit("", 200, 80, 110, 90, 2097220)
Local $cbxOnTop = GUICtrlCreateCheckbox("On Top", 125, 45)

GUISetState(@SW_SHOW)

GUICtrlSetOnEvent($bStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUICtrlSetOnEvent($disableGraph, "EventHandler")
GUICtrlSetOnEvent($cbxOnTop, "EventHandler")

;EventHandler


Do
	Sleep(100)
Until $bInitialized

While 1
	If $bRunning = True Then
		If GetMapID() <> $Kaineng And GetMapID() <> $Kaineng2 Then
			TravelTo($Kaineng)
			logFile("Travel To Kaineng")
		EndIf

		If $firstrun = True Then
			Sleep(100)
			$firstrun = False
		EndIf
		If $updated = 0 Then
			GUICtrlSetData($stRuns, $nbRuns & "  (" & $nbFails & ")")
			$updated = 1
			If $render = False Then
				EnableRendering()
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
				Sleep(Random(2000, 2500))
				DisableRendering()
				WinSetState(GetWindowHandle(), "", @SW_HIDE)
				ClearMemory()
			EndIf
		EndIf

		$bCanContinue = True

		logFile("Start run")
		$updated = 0
		DoJob()
	Else
		If $updated = 0 Then
			GUICtrlSetData($stRuns, $nbRuns & "  (" & $nbFails & ")")
			$updated = 1
			If $render = False Then
				EnableRendering()
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
				Sleep(Random(2000, 2500))
				DisableRendering()
				WinSetState(GetWindowHandle(), "", @SW_HIDE)
				ClearMemory()
			EndIf
			If $bRunning = False Then
				GUICtrlSetData($bStart, "Resume")
				GUICtrlSetState($bStart, $GUI_ENABLE)
				logFile("Bot stopped!")
			EndIf
		EndIf
		Sleep(100)
	EndIf
WEnd

Func EventHandler()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $bStart
			If $bRunning = True Then
				GUICtrlSetData($bStart, "Will pause after this run")
				GUICtrlSetState($bStart, $GUI_DISABLE)
				$bRunning = False
			ElseIf $bInitialized Then
				GUICtrlSetData($bStart, "Pause")
				$bRunning = True
			Else
				$bRunning = True
				GUICtrlSetData($bStart, "Initializing...")
				GUICtrlSetState($bStart, $GUI_DISABLE)
				GUICtrlSetState($txtName, $GUI_DISABLE)
;~ 				WinSetTitle($GUI, "", GUICtrlRead($txtName))
				If GUICtrlRead($txtName) = "" Then
					If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($txtName), True, True, False) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf
				GUICtrlSetData($bStart, "Pause")
				GUICtrlSetState($bStart, $GUI_ENABLE)
				WinSetTitle($GUI, "", GetCharname() & " - Tengubot")
				$bInitialized = True
				$GWPID = $mGWHwnd
			EndIf
		Case $disableGraph
			ClearMemory()
			TOGGLERENDERING()
			If $render = True Then
				$render = False
			Else
				$render = True
			EndIf
		Case $cbxOnTop
			WinSetOnTop($GUI, "", GUICtrlRead($cbxOnTop) == $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>EventHandler

Func DoJob()

	If GUICtrlRead($hm) = $GUI_CHECKED Then
		Switchmode(1)
	Else
		Switchmode(0)
	EndIf
	If CountFreeSlots() < 5 Then
		logFile("Going to Merchant")
		Merchant()
	EndIf

;~ 	If (Gold)>90000 then
;~ 		DepositGold()
;~ 	EndIf

	GoToQuest()
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
		$nbRuns += 1
	EndIf
	TravelTo($Kaineng)

EndFunc   ;==>DoJob

Func Merchant()
	GoToMerchant()
	Ident(1)
	Ident(2)
	Ident(3)
	Sell(1)
	Sell(2)
	Sell(3)
	DepositGold()
;~ 	StoreGoldies()
EndFunc   ;==>Merchant

Func GoToMerchant()
	Local $lMerchant = GetAgentByName("Natsuko [Merchant]")
	GoToNPC($lMerchant)
EndFunc   ;==>GoToMerchant

Func GoToQuest()
	Local $lMe, $coordsX, $coordsY


	$lMe = GetAgentByID(-2)
	$coordsX = DllStructGetData($lMe, 'X')
	$coordsY = DllStructGetData($lMe, 'Y')

	If - 1400 < $coordsX And $coordsX < -550 And - 2000 < $coordsY And $coordsY < -1100 Then
		MoveTo(1474, -1197, 0)
	EndIf
;~ 	If 2300 < $coordsX And $coordsX < 3000 And -4000 < $coordsY and $coordsY < -3500 Then
;~ 	ElseIf 2800 < $coordsX and $coordsX < 3500 And -1700 < $coordsY And $coordsY < -1100 Then
;~ 	ElseIf 2300 < $coordsX And $coordsX < 2800 And 300 < $coordsY And $coordsY < 1000 Then
EndFunc   ;==>GoToQuest

Func EnterQuest()
	Local $NPC = GetNearestNPCToCoords(2240, -1264)
	GoToNPC($NPC)
	Sleep(250)
	Dialog(0x00000084)
	Sleep(500)
	WaitMapLoading()
EndFunc   ;==>EnterQuest

Func PrepareToFight()
	Local $lDunko, $lMiku, $lVekk, $Me
	Local $lDeadLock, $lDeadLock2

	$lDunko = GetAgentByName($xandra)
    $lMiku = GetAgentByName($miku)
	$Me = GetAgentByID(-2)

    CommandAll(-5536, -4765)
	CommandHero(1,-6143,-5376)
	CommandHero(2,-5896,-5378)
	CommandHero(3,-6273,-4968)
	MoveTo(-6285, -5270)
	Sleep(3000)
	UseHeroSkill(1, 1)
	Sleep(1500)
	UseHeroSkill(1, 2)
	Sleep(200)
	UseHeroSkill(3, 8, $Me)
	Sleep(1500)
    UseHeroSkill(7, 8, $lMiku)
	Sleep(1000)
	UseHeroSkill(4, 8, $lDunko)
	Sleep(3000)
	UseHeroSkill(4, 8, $Me)
	Sleep(3000)
	UseHeroSkill(4, 8, $lMiku)
	Sleep(6000)
	UseHeroSkill(5, 7)
	Sleep(1000)

	CommandAll(-5830,-4966)
	CommandHero(1,-6143,-5376)
	CommandHero(2,-5896,-5378)
	CommandHero(3,-6273,-4968)

    Sleep(200)
	UseHeroSkill(1, 5, $Me)
	Sleep(5000)
	UseHeroSkill(1, 5, $lMiku)
	Sleep(1000)

	$lDeadLock = TimerInit()
	Do
		Sleep(10)
	Until GetNumberOfFoesInRangeOfAgent(-2, 4250) <> 0 Or TimerDiff($lDeadLock) > 5000

	UseSkillEx(7) ; On met une ward pour les copains
	UseSkillEx(2)
	UseHeroSkill(4, 1)
	$lDeadLock2 = TimerInit()
	Do
		Sleep(10)
	Until GetNumberOfFoesInRangeOfAgent(-2, 4250) > 3 Or TimerDiff($lDeadLock2) > 5000
EndFunc   ;==>PrepareToFight

Func Fight()
	Local $lMiku, $lMob
	Local $lDeadLock, $lDeadLock2

    Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku = GetAgentByName($miku)
		Attack($lMob)
		If GetSkillBarSkillRecharge(7) = 0 Then UseSkillEx(7)
	    If GetSkillBarSkillRecharge(1) = 0 Then UseSkillEx(1)
		If GetSkillBarSkillRecharge(3) = 0 Then UseSkillEx(3)
	    If GetSkillBarSkillRecharge(2) = 0 Then UseSkillEx(2)
	    If (GetSkillBarSkillRecharge(4) = 0) and (GetSkillbarSkillAdrenaline(4) >= 130) Then UseSkillEx(4)
	    PickUpLoot()
		HelpMiku($lMiku)
		Sleep(50)

		If GetisDead($lMiku) or GetIsDead(-2) Then $bCanContinue = False
    Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <= 3  Or $bCanContinue = False

	CancelAll()
	CancelHero(1)
	CancelHero(2)
	CancelHero(3)

	Do
		$lMob = GetNearestEnemyToAgent(-2)
		$lMiku = GetAgentByName($miku)
		Attack($lMob)
		If GetSkillBarSkillRecharge(7) = 0 Then UseSkillEx(7)
	    If GetSkillBarSkillRecharge(1) = 0 Then UseSkillEx(1)
		If GetSkillBarSkillRecharge(3) = 0 Then UseSkillEx(3)
	    If GetSkillBarSkillRecharge(2) = 0 Then UseSkillEx(2)
	    If (GetSkillBarSkillRecharge(4) = 0) and (GetSkillbarSkillAdrenaline(4) >= 130) Then UseSkillEx(4)
        PickUpLoot()
		HelpMiku($lMiku)
		Sleep(50)

		If GetisDead($lMiku) or GetIsDead(-2) Then $bCanContinue = False
    Until GetNumberOfFoesInRangeOfAgent(-2, 3000) <=2 Or $bCanContinue = False

    If $bCanContinue = True Then CommandAll(-6304,-5264)

	If $bCanContinue Then MoveTo(-5961, -5082)

    $lDeadLock2 = TimerInit()

    Do
	  Sleep(100)
    Until GetNumberOfFoesInRangeOfAgent(-2, 1600) = 0 or GetIsDead(-2) Or TimerDiff($lDeadLock2) > 25000

    Sleep(1000)
EndFunc   ;==>Fight


Func HelpMiku($aMiku)
	If DllStructGetData($aMiku, 'HP') < 0.4 Then
		UseHeroSkill(3, 4, $aMiku) ; Lien spi de Zhed
		UseHeroSkill(4, 6, $aMiku)
	EndIf
EndFunc   ;==>HelpMiku

Func GoToStairs()
	CommandAll(-6707, -5242)

	MoveTo(-4790, -3441)
	MoveTo(-4608, -2120)
	MoveTo(-4222, -1545)
	MoveTo(-4664, -672)
	MoveTo(-3825, 134)
	MoveTo(-3067, 633)
	MoveTo(-2663, 644)
	MoveTo(-2214, -334)
	MoveTo(-878, -1877)
	MoveTo(-770, -3052)
	MoveTo(-699, -3773)
	MoveTo(-1070, -4192, 0)
	Sleep(1000)
	UseSkillEx(5)

	CommandHero(3, -5798, -5272)
	logFile("@ stairs")
EndFunc   ;==>GoToStairs

Func Survive()
	Local $lDeadLock
	Local $lMe, $lNrj

	$lDeadLock = TimerInit()
	Do
		Sleep(250)
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) <> 0 Or TimerDiff($lDeadLock) > 60000

	$lDeadLock = TimerInit()
	Do
		$lMe = GetAgentByID(-2)
		If IsDllStruct(GetEffect(480)) Then UseHeroSkill(3, 1)

		If DllStructGetData($lMe, "HP") < 0.7 Then
			If IsRecharged($skill_bar_echap) Then UseSkillEx($skill_bar_echap)
		EndIf

		If IsRecharged($skill_bar_stab) Then UseSkillEx($skill_bar_stab)

		If IsRecharged($skill_bar_sceau) Then UseSkillEx($skill_bar_sceau)

	Until GetisDead(-2) Or GetNumberOfFoesInRangeOfAgentbis(-2, 200) = 60 Or TimerDiff($lDeadLock) > 45000

	Do
		$lNrj = GetEnergy(-2)
		Sleep(250)
	Until $lNrj > 15 Or GetIsDead(-2)

	logFile("Spiking")

	CommandHero(3, -6707, -5242)

	UseSkillEx($skill_bar_EBON)
	UseSkillEx($skill_bar_justice)

	Do
		$lNrj = GetEnergy(-2)
		Sleep(250)
	Until $lNrj > 10 Or GetIsDead(-2)

	UseSkillEx($skill_bar_100b)
	UseSkillEx($skill_bar_exLimite)

	Sleep(250)

	UseSkillEx($skill_bar_toubillon, GetNearestEnemyToAgent(-2))

	If GetIsDead(-2) Then
		$bCanContinue = False
		logFile("Fail at the end")
	EndIf

	Sleep(3000)
EndFunc   ;==>Survive

Func CanPickUp2($aitem)
	$ModelID = DllStructGetData(($aitem), 'ModelID')
	$ExtraID = DllStructGetData($aitem, "ExtraId")
	$lRarity = GetRarity($aitem)
	$t = DllStructGetData($aitem, 'Type')
	If $t = 20 Then
		Return True
	ElseIf $ModelID == 36985 Then
		$nbCitations += 1
		GUICtrlSetData($stCitations, $nbCitations)
		Return True
	ElseIf GUICtrlRead($gold) = $GUI_CHECKED Then
		If $lRarity = 2624 Then
			Return True ; gold items
		EndIf
	ElseIf GUICtrlRead($green) = $GUI_CHECKED Then
		If $lRarity = 2627 Then
			Return True ; green items
		EndIf
	ElseIf $ModelID = 28434 Then
		Return True
	ElseIf $lRarity = 2624 Then
		If GUICtrlRead($dragon) = $GUI_CHECKED Then
			If $ModelID = 736 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($bo) = $GUI_CHECKED Then
			If $ModelID = 735 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($bladed) = $GUI_CHECKED Then
			If $ModelID = 778 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($bladed) = $GUI_CHECKED Then
			If $ModelID = 777 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($spiked) = $GUI_CHECKED Then
			If $ModelID = 871 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($spiked) = $GUI_CHECKED Then
			If $ModelID = 872 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($jitte) = $GUI_CHECKED Then
			If $ModelID = 741 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($diamond) = $GUI_CHECKED Then
			If $ModelID = 2294 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($Iridescent) = $GUI_CHECKED Then
			If $ModelID = 2298 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($Iridescent) = $GUI_CHECKED Then
			If $ModelID = 2299 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($Iridescent) = $GUI_CHECKED Then
			If $ModelID = 2297 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($Platinum) = $GUI_CHECKED Then
			If $ModelID = 2316 Then
				Return True
			EndIf
		EndIf
		If GUICtrlRead($shinobi) = $GUI_CHECKED Then
			If $ModelID = 744 Then
				Return True
			EndIf
		EndIf
	ElseIf GUICtrlRead($pcons) = $GUI_CHECKED Then
		If CheckArrayPscon($ModelID) Then ; Pcons (line 45)
			Return True
		EndIf
	ElseIf $ModelID = 146 Then
		If $ExtraID = 10 Or $ExtraID = 12 Then
			Return False
		EndIf
		If $ModelID = 22751 Then
			Return True
		EndIf
	EndIf
EndFunc   ;==>CanPickUp2

Func StoreGoldies()
	Store(1, 20)
	Store(2, 5)
	Store(3, 10)
EndFunc   ;==>StoreGoldies

Func Store($bagIndex, $numOfSlots)
	For $i = 1 To $numOfSlots
		ConsoleWrite("Checking items: " & $bagIndex & ", " & $i & @CRLF)
		$aitem = GetItemBySlot($bagIndex, $i)
		$ModelID = DllStructGetData(($aitem), 'ModelID')
		$ExtraID = DllStructGetData($aitem, "ExtraId")
		$lRarity = GetRarity($aitem)
		If DllStructGetData($aitem, 'ID') <> 0 And $lRarity = 2624 Then
			Do
				For $bag = 8 To 16
					$slot = FindEmptySlot($bag)
					$slot = @extended
					If $slot <> 0 Then
						$FULL = False
						$nbag = $bag
						$nSlot = $slot
						ExitLoop 2; finding first empty $slot in $bag and jump out
					Else
						$FULL = True; no empty slots :(
						logFile("Chest is full")
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MoveItem($aitem, $nbag, $nSlot)
;~ 					ConsoleWrite("Gold item moved ...."& @CRLF)
				Sleep(Random(450, 550))
			EndIf
		EndIf
	Next
EndFunc   ;==>Store

Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return

	Local $lDeadLock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadLock) > $aTimeout)
	Sleep(50)
EndFunc   ;==>UseSkillEx

Func GetNumberOfFoesInRangeOfAgentbis($aAgent = -2, $aRange = 1250)
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
		$agenty = DllStructGetData($lAgent, 'Y')
		If $agenty < -4500 Then
			$lCount += 1
		EndIf
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next
	Return $lCount
EndFunc   ;==>GetNumberOfFoesInRangeOfAgentbis

Func logFile($msg)
	GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & $msg & @CRLF)
	_GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
	_GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc   ;==>logFile

Func INVENTORYCHECK()
	If CountInvSlots() < 3 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>INVENTORYCHECK
Func CountInvSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc   ;==>CountInvSlots
Func SECUREIDKIT()
	If FINDIDKIT() = 0 Then
		If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
			WITHDRAWGOLD(500)
			Sleep(Random(200, 300))
		EndIf
		Do
			BUYITEM(6, 1, 500)
			RNDSLEEP(500)
		Until FINDIDKIT() <> 0
		RNDSLEEP(500)
	EndIf
EndFunc   ;==>SECUREIDKIT
Func CANSELL($aitem)
	$Q = DllStructGetData($aitem, "quantity")
	$M = DllStructGetData($aitem, "ModelID")
	$R = GETRARITY($aitem)
	If $M = 146 Then ; teintures noires et blanches
		If DllStructGetData($aitem, "ExtraId") > 9 Then
			Return False
		Else
			Return True
		EndIf
	ElseIf $M = 22751 Then ; lockpicks
		Return False
	ElseIf $M = 735 And GUICtrlRead($bo) = $GUI_CHECKED Then ; Bo staff
		Return False
	ElseIf $M = 736 And GUICtrlRead($dragon) = $GUI_CHECKED Then ;Dragon Staff
		Return False
	ElseIf $M = 741 And GUICtrlRead($jitte) = $GUI_CHECKED Then ;Jitte
		Return False
	ElseIf $M = 777 And GUICtrlRead($bladed) = $GUI_CHECKED Then ;Bladed Shield Non Inscribable(str)
		Return False
	ElseIf $M = 778 And GUICtrlRead($bladed) = $GUI_CHECKED Then ;Bladed Shield Non Inscribable(tactics)
		Return False
	ElseIf $M = 871 And GUICtrlRead($spiked) = $GUI_CHECKED Then ;Spiked Targe Non Inscribable(str)
		Return False
	ElseIf $M = 872 And GUICtrlRead($spiked) = $GUI_CHECKED Then ;Spiked Targe Non Inscribable(tactics)
		Return False
	ElseIf $M = 2294 And GUICtrlRead($diamond) = $GUI_CHECKED Then ;Diamond
		Return False
	ElseIf $M = 2624 And GUICtrlRead($diamond) = $GUI_CHECKED Then ;Diamond
		Return False
	ElseIf $M = 2297 And GUICtrlRead($Iridescent) = $GUI_CHECKED Then ;Iri
		Return False
	ElseIf $M = 2298 And GUICtrlRead($Iridescent) = $GUI_CHECKED Then ;Iri
		Return False
	ElseIf $M = 2299 And GUICtrlRead($Iridescent) = $GUI_CHECKED Then ;Iri
		Return False
	ElseIf $M = 5899 Then ; necessaire d'id
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CANSELL

Func CountChestSlots()
	Local $bag
	Local $temp = 0
	For $i = 8 To 16
		$bag = GetBag($i)
		$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Next
	Return $temp
EndFunc   ;==>CountChestSlots

Func CountFreeSlots()
	Local $temp = 0
	Local $bag
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc   ;==>CountFreeSlots

Func Ident($bagIndex)
	For $i = 1 To $bagIndex
		Local $lBag = GetBag($i)
		For $ii = 1 To DllStructGetData($lBag, 'slots')
			If FindIDKit() = 0 Then
				If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
					WithdrawGold(500)
					Sleep(Random(200, 300))
				EndIf
				Do
					BuyIDKit()
					RndSleep(500)
				Until FindIDKit() <> 0
				RndSleep(500)
			EndIf
			$aitem = GetItemBySlot($i, $ii)
			If DllStructGetData($aitem, 'ID') = 0 Then ContinueLoop
			IdentifyItem($aitem)
			RndSleep(250)
		Next
	Next
EndFunc   ;==>Ident

Func Sell($bagIndex)
	$bag = GETBAG($bagIndex)
	$numOfSlots = DllStructGetData($bag, "slots")
	For $i = 1 To $numOfSlots
		logFile("Selling item: " & $bagIndex & ", " & $i)
		$aitem = GETITEMBYSLOT($bagIndex, $i)
		If DllStructGetData($aitem, "ID") = 0 Then ContinueLoop
		If CANSELL($aitem) Then
			SELLITEM($aitem)
		EndIf
		RNDSLEEP(250)
	Next
EndFunc   ;==>Sell

Func GONEARESTNPCTOCOORDS($X, $Y)
	Do
		RNDSLEEP(250)
		$GUY = GETNEARESTNPCTOCOORDS($X, $Y)
	Until DllStructGetData($GUY, "Id") <> 0
	CHANGETARGET($GUY)
	RNDSLEEP(250)
	GONPC($GUY)
	RNDSLEEP(250)
	Do
		RNDSLEEP(500)
		MOVETO(DllStructGetData($GUY, "X"), DllStructGetData($GUY, "Y"), 40)
		RNDSLEEP(500)
		GONPC($GUY)
		RNDSLEEP(250)
		$ME = GETAGENTBYID(-2)
	Until COMPUTEDISTANCE(DllStructGetData($ME, "X"), DllStructGetData($ME, "Y"), DllStructGetData($GUY, "X"), DllStructGetData($GUY, "Y")) < 250
	RNDSLEEP(1000)
EndFunc   ;==>GONEARESTNPCTOCOORDS

Func CheckArrayPscon($lModelID)
	For $p = 0 To (UBound($Array_pscon) - 1)
		If ($lModelID == $Array_pscon[$p]) Then Return True
	Next
EndFunc   ;==>CheckArrayPscon