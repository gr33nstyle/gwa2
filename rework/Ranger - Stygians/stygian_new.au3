#Region About
;~ Thanks for GWA2
;~ This was tested with:
;~ 		Full Windwalker Insignias
;~ 		+4 Beast Mastery
;~ 		490 Health; 46 Energy
;~		This build: OgUUI4hZ3rQLB3UyAmArMQH0l0kA
;~
;~
;~ Func HowToUseThisProgram()
;~ 		Start Guild Wars
;~ 		Log onto your Ranger
;~ 		Equip a Staff
;~ 		Run the bot
;~ 		If one instance of Guild Wars is open Then
;~    		Click Start
;~ 		ElseIf multiple instances of Guild Wars are open Then
;~      	Select the character you want from the dropdown menu
;~ 			Click Start
;~ 		EndIf
;~ EndFunc
#EndRegion About

#include <ButtonConstants.au3>
#include <GWA2.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#NoTrayIcon


#Region Declarations
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Global Const $WEAPON_SLOT_SCYTHE = 1
Global Const $WEAPON_SLOT_STAFF = 2
Global $Runs = 0
Global $TotalKilledEnemy = 0
Global $Fails = 0
Global $Drops = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $TotalSeconds = 0
Global $Seconds = 0
Global $Minutes = 0
Global $Hours = 0
Global $MerchOpened = False
Global $HWND
#EndRegion Declarations

#Region ItemID's
Global $Array_pscon[39]=[910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, 21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]
#EndRegion


#Region GUI
$Gui = GUICreate("Stygian Farmer", 299, 214, -1, -1)
$CharInput = GUICtrlCreateCombo("", 6, 6, 103, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
   GUICtrlSetData(-1, GetLoggedCharNames())
$StartButton = GUICtrlCreateButton("Start", 5, 186, 105, 23)
   GUICtrlSetOnEvent(-1, "GuiButtonHandler")
$RunsLabel = GUICtrlCreateLabel("Runs:", 6, 31, 31, 17)
$RunsCount = GUICtrlCreateLabel("0", 34, 31, 75, 17, $SS_RIGHT)
$FailsLabel = GUICtrlCreateLabel("Fails:", 6, 50, 31, 17)
$FailsCount = GUICtrlCreateLabel("0", 30, 50, 79, 17, $SS_RIGHT)
$DropsLabel = GUICtrlCreateLabel("Stygians:", 6, 69, 76, 17)
$DropsCount = GUICtrlCreateLabel("0", 82, 69, 27, 17, $SS_RIGHT)
$AvgTimeLabel = GUICtrlCreateLabel("Average time:", 6, 88, 65, 17)
$AvgTimeCount = GUICtrlCreateLabel("-", 71, 88, 38, 17, $SS_RIGHT)
$DropRateLabel = GUICtrlCreateLabel("DropRate:", 6, 108, 65, 17)
$DropRateCount = GUICtrlCreateLabel("-", 71, 108, 38, 17, $SS_RIGHT)
$TotTimeLabel = GUICtrlCreateLabel("Total time:", 6, 127, 49, 17)
$TotTimeCount = GUICtrlCreateLabel("-", 55, 127, 54, 17, $SS_RIGHT)
$StatusLabel = GUICtrlCreateEdit("", 115, 6, 178, 202, 2097220)
$PickUpGoldies = GUICtrlCreateCheckbox("PickUp Goldies", 6, 144, 103, 17)
$StoreUpgrades = GUICtrlCreateCheckbox("Keep Upgrades", 6, 164, 103, 17)
   GUICtrlSetState($PickUpGoldies, $GUI_CHECKED)
   GUICtrlSetState($StoreUpgrades, $GUI_CHECKED)
$RenderingBox = GUICtrlCreateCheckbox("Disable Rendering", 6, 124, 103, 17)
   GUICtrlSetOnEvent(-1, "ToggleRendering")
   GUICtrlSetState($RenderingBox, $GUI_DISABLE)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetState(@SW_SHOW)
#EndRegion GUI

#Region Loops
Out("Ready.")
While Not $BotRunning
   Sleep(100)
WEnd

AdlibRegister("TimeUpdater", 1000)

Setup()

While 1

   While (CountSlots() > 3)
	  If Not $BotRunning Then
		 Out("Bot is paused.")
		 GUICtrlSetState($StartButton, $GUI_ENABLE)
		 GUICtrlSetData($StartButton, "Start")
		 GUICtrlSetOnEvent($StartButton, "GuiButtonHandler")
		 While Not $BotRunning
			Sleep(500)
		 WEnd
	  EndIf
		MainLoop()
	WEnd

   If (CountSlots() < 4) Then
	  If Not $BotRunning Then
		 Out("Bot is paused.")
		 GUICtrlSetState($StartButton, $GUI_ENABLE)
		 GUICtrlSetData($StartButton, "Start")
		 GUICtrlSetOnEvent($StartButton, "GuiButtonHandler")
		 While Not $BotRunning
			Sleep(500)
		 WEnd
	  EndIf
	  SellTheStuff()
   EndIf

WEnd
#EndRegion Loops

#Region Functions
Func GuiButtonHandler()
   If $BotRunning Then
	  Out("Will pause after this run.")
	  GUICtrlSetData($StartButton, "force pause NOW")
	  GUICtrlSetOnEvent($StartButton, "Resign")
	  ;GUICtrlSetState($StartButton, $GUI_DISABLE)
	  $BotRunning = False
   ElseIf $BotInitialized Then
	  GUICtrlSetData($StartButton, "Pause")
	  $BotRunning = True
   Else
	  Out("Initializing...")
	  Local $CharName = GUICtrlRead($CharInput)
	  If $CharName == "" Then
		 If Initialize(ProcessExists("gw.exe"), True, True) = False Then
			   MsgBox(0, "Error", "Guild Wars is not running.")
			   Exit
		 EndIf
	  Else
		 If Initialize($CharName, True, True) = False Then
			   MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '" & $CharName & "'")
			   Exit
		 EndIf
	  EndIf
	  EndIf
EndFunc

Func Setup()
   If GetMapID() == 474 And GetMapLoading() = 1 Then
	  Out("Travel to Outpost.")
	  RndTravel(474)
;	  WaitInstanceType(0)
   ElseIf GetMapID() <> 474 Then
	  Out("Travel to Outpost.")
	  RndTravel(474)
	  WaitMapLoading(474)
   EndIf
   Out("Loading skillbar.")
   LoadSkillTemplate("OgUUI4hZ3rQLB3UyAmArMQH0l0kA")
   LeaveGroup()
   SwitchMode(1)
   RndSleep(500)
EndFunc

Func Zone()
   If GetMapLoading() == 2 Then Disconnected()
   Local $Me = GetAgentByID(-2)
   Local $X = DllStructGetData($Me, 'X')
   Local $Y = DllStructGetData($Me, 'Y')
   If ComputeDistance($X, $Y, 7436, -11894) < 750 Then
	  MoveTo(6430, -14437)
	  MoveTo(7025, -15297)
	  MoveTo(3515, -18096)
	  MoveTo(-692, -18606)
	  MoveTo(-1057, -19762)
	  Move(-1300, -20350)
	  WaitInstanceType(1)
	  Return
   EndIf
   If ComputeDistance($X, $Y, 4787, -13863) < 750 Then
	  MoveTo(6430, -14437)
	  MoveTo(7025, -15297)
	  MoveTo(3515, -18096)
	  MoveTo(-692, -18606)
	  MoveTo(-1057, -19762)
	  Move(-1300, -20350)
	  WaitInstanceType(1)
	  Return
   EndIf
   If ComputeDistance($X, $Y, 5851, -16924) < 750 Then
	  MoveTo(3515, -18096)
	  MoveTo(-692, -18606)
	  MoveTo(-1057, -19762)
	  Move(-1300, -20350)
	  WaitInstanceType(1)
	  Return
   EndIf
   MoveTo(7025, -15297)
   MoveTo(3515, -18096)
   MoveTo(-692, -18606)
   MoveTo(-1057, -19762)
   Move(-1300, -20350)
   WaitInstanceType(1)
EndFunc

Func MainLoop()
   Local $EnemysThisRun = 0
   Zone()

   Out("Running to Quest Dude")
   MoveRun(2982, -10306)
   ;--Wait in Front of Grp

   Sleep(GetPing()+15000)

   GoNearestNPCToCoords(7190, -9110)
   AcceptQuest(742)
   If GetLightbringerTitle() < 50000 Then
	  Out("Get Anguish Hunt")
	  GoNearestNPCToCoords(7309, -8902)
	  Dialog(0x00000085)
   EndIf
   Sleep(Random(900,1100))

   Out("Run Save Spot")
   MoveRun(9743, -8112)
   MoveTo(9737, -7814, 1)
   Sleep(Random(14900,15100))
   MoveRun(12321, -9958)
   MoveRun(12955, -9918)
   MoveTo(13085, -9797, 1)
   Sleep(Random(400,600))

   Out("Setting EOE")
   UseSkillEx(6)
   Sleep(3500)
   TargetNearestAlly()

   Out("Pulling Hungers")
   MoveRun(12538, -9859)
   MoveRun(9089, -9167)
   MoveRun(8716, -9314)
   MoveTo(8631, -9370, 1) ;~ take aggro
   MoveRun(10488, -8938)
   Sleep(Random(350,450))
   MoveRun(11584, -9195)
   Sleep(Random(350,450))
   MoveRun(12249, -9618)
   MoveTo(12509, -9794, 1)
   Sleep(Random(1900,2100)) ;~Wait for settle
   UseSkillEx(7, -1)
   MoveTo(13085, -9797, 1)

   Out("Wait for Settle")
   WaitForSettle(2500, 200)
   $EnemysThisRun += GetNumberOfFoesInRangeOfAgent(-2, 200)
   Out("Settled")

   Out("Killing Hungers")
   Kill()

   Out("Run Save Spot")
   MoveRun(9743, -8112)
   MoveTo(9737, -7814, 1)
   Sleep(Random(19400,19600))
   MoveRun(12321, -9958)
   MoveRun(12955, -9918)
   MoveTo(13085, -9797, 1)
   Sleep(Random(400,600))

   Out("Setting EOE")
   UseSkillEx(6)
   Sleep(GetPing()+3000)

   Out("Looting")
   MoveTo(13020, -9906, 50)
   PickUpLoot()
   Sleep(Random(400,600))
   TargetNearestAlly()

   Out("Pulling Mixed Group")
   MoveRun(12538, -9859)
   MoveRun(9089, -9167)
   MoveRun(8759, -9312)
   MoveTo(8631, -9370, 1) ;~ take aggro
   MoveRun2(10488, -8938)
   Sleep(Random(80,120))
   MoveRun2(11584, -9195)
   Sleep(Random(80,120))
   MoveRun2(12320, -9672)
   MoveTo(12509, -9794, 1)
   Sleep(Random(190,210)) ;~Wait for settle
   UseSkillEx(7, -1)
   MoveTo(13085, -9797, 1)

   Out("Wait for Settle")
   WaitForSettle(2500, 200)
   $EnemysThisRun += GetNumberOfFoesInRangeOfAgent(-2, 200)
   $TotalKilledEnemy += $EnemysThisRun
   Out("Settled")

   Out("Killing Mixed Group")
   Kill2()

   Out("Looting")
   MoveTo(13020, -9906, 50)
   PickUpLoot()


;~ 	  Statistics
   If GetIsDead(-2) Then
	  If $EnemysThisRun <= 15 Then
		 $Fails += 1
		 Out("I'm dead.")
		 GUICtrlSetData($FailsCount,$Fails)
	  EndIf
	  GUICtrlSetData($DropRateCount,DropRate())
   Else
	  $Runs += 1
	  Out("Completed in " & GetTime() & ".")
	  GUICtrlSetData($RunsCount,$Runs)
	  GUICtrlSetData($AvgTimeCount,AvgTime())
	  GUICtrlSetData($DropRateCount,DropRate())
   EndIf

   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then ClearMemory()

   TravelOutpost()

EndFunc

Func TravelOutpost()
   If GetMapID() == 474 And GetMapLoading() = 1 Then
	  Out("Travel to Outpost.")
	  RndTravel(474)
	  WaitInstanceType(0)
   EndIf
   SwitchMode(1)
   RndSleep(500)
EndFunc

Func MoveRun($DestX, $DestY)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $Me, $Angle
   Local $Blocked = 0

   If IsRecharged(5) Then UseSkillEx(5, -2)
   Move($DestX, $DestY)
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  $Me = GetAgentByID(-2)
	  If GetIsDead(-2) Then Return

	  If IsRecharged(5) Then UseSkillEx(5, -2)
	  If (DllStructGetData($Me, 'MoveX') == 0 Or DllStructGetData($Me, 'MoveY') == 0) Then
		 $Blocked += 1
		 If $Blocked <= 5 Then
			Move($DestX, $DestY)
		 ElseIf $Blocked > 5 AND $Blocked <= 25 Then
			$Me = GetAgentByID(-2)
			$X = Round(DllStructGetData($Me, 'X'), 2)
			$Y = Round(DllStructGetData($Me, 'Y'), 2)
			Out("Blocked at Position: " & $X & ":" & $Y & ". Try to unstuck.")
			$Angle += 40
			Move(DllStructGetData($Me, 'X')+300*sin($Angle), DllStructGetData($Me, 'Y')+300*cos($Angle))
			Sleep(2000)
			Move($DestX, $DestY)
		 Else
			TravelOutpost()
		 EndIf
	  EndIF
	  RndSleep(250)
   Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) < 250
EndFunc

Func MoveRun2($DestX, $DestY)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $Me, $Angle
   Local $Blocked = 0

   If IsRecharged(5) Then UseSkillEx(5, -2)
   If IsRecharged(8) Then UseSkillEx(8, -2)
   Move($DestX, $DestY)
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  $Me = GetAgentByID(-2)
	  If GetIsDead(-2) Then Return

	  If IsRecharged(5) Then UseSkillEx(5, -2)
	  If IsRecharged(8) Then UseSkillEx(8, -2)
	  If (DllStructGetData($Me, 'MoveX') == 0 Or DllStructGetData($Me, 'MoveY') == 0) Then
		 $Blocked += 1
		 If $Blocked <= 5 Then
			Move($DestX, $DestY)
		 ElseIf $Blocked > 5 AND $Blocked <= 10 Then
			$Me = GetAgentByID(-2)
			$X = Round(DllStructGetData($Me, 'X'), 2)
			$Y = Round(DllStructGetData($Me, 'Y'), 2)
			Out("Blocked at Position: " & $X & ":" & $Y & ". Try to unstuck.")
			$Angle += 40
			Move(DllStructGetData($Me, 'X')+300*sin($Angle), DllStructGetData($Me, 'Y')+300*cos($Angle))
			Sleep(2000)
			Move($DestX, $DestY)
		 Else
			TravelOutpost()
		 EndIf
	  EndIF
	  RndSleep(250)
   Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), $DestX, $DestY) < 250
EndFunc

Func Kill()
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $alreadyused = False

   Local $lAgentArray
   Local $lDeadlock = TimerInit()

   TargetNearestEnemy()
   Sleep(100)
   Local $lTargetID = GetCurrentTargetID()

   If IsRecharged(4) Then UseSkillEx(4, -2)

   While GetNumberOfFoesInRangeOfAgent(-2, 1500) > 0
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  $lAgentArray = GetAgentArray(0xDB)

	  If GetEffectTimeRemaining(38) <= 2000 Then UseSkillEx(4, -2)

;~ 	  Use EoE if needed
	  If IsRecharged(6) And GetEffectTimeRemaining(464) < 7500 Then
		 UseSkill(6, -2)
		 Sleep(6000)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Echo + Wastrels Demise
	  If IsRecharged(1) And GetSkillbarSkillID(1) == 75 And $alreadyused = False Then
		 If IsRecharged(2) And IsRecharged(1) Then
			$target = GetGoodTarget($lAgentArray)
			UseSkillEx(1)
			UseSkillEx(2, GetGoodTarget($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
			$alreadyused = True
		 EndIf
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Wastrels Worry
	  If IsRecharged(3) Then
		 UseSkillEx(3, GetGoodTarget($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use echoed Wastrels Demise
	  If IsRecharged(1) And GetSkillbarSkillID(1) == 1335 Then
		 UseSkillEx(1, GetGoodTarget($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Wastrels Demise
	  If IsRecharged(2) Then
		 UseSkillEx(2, GetGoodTarget($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

	  If TimerDiff($lDeadlock) > 180 * 1000 Then Return

   WEnd
EndFunc

Func Kill2()
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return

   Local $lAgentArray
   Local $lDeadlock = TimerInit()
   Local $alreadyused = False

   TargetNearestEnemy()
   Sleep(100)
   Local $lTargetID = GetCurrentTargetID()

   If IsRecharged(4) Then UseSkillEx(4, -2)

   While GetNumberOfFoesInRangeOfAgent(-2, 1500) > 0
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  $lAgentArray = GetAgentArray(0xDB)

	  If GetEffectTimeRemaining(38) <= 2000 Then UseSkillEx(4, -2)

;~ 	  Use EoE if needed
	  If IsRecharged(6) And GetEffectTimeRemaining(464) < 7500 Then
		 UseSkill(6, -2)
		 Sleep(6000)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Echo + Wastrels Demise
	  If IsRecharged(1) And GetSkillbarSkillID(1) == 75 And $alreadyused = False Then
		 If IsRecharged(2) And IsRecharged(1) Then
			UseSkillEx(1)
			UseSkillEx(2, GetGoodTarget2($lAgentArray))
			$lAgentArray = GetAgentArray(0xDB)
			$alreadyused = True
		 EndIf
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Wastrels Worry
	  If IsRecharged(3) Then
		 UseSkillEx(3, GetGoodTarget2($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use echoed Wastrels Demise
	  If IsRecharged(1) And GetSkillbarSkillID(1) == 1335 Then
		 UseSkillEx(1, GetGoodTarget2($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

;~ 	  Use Wastrels Demise
	  If IsRecharged(2) Then
		 UseSkillEx(2, GetGoodTarget2($lAgentArray))
		 $lAgentArray = GetAgentArray(0xDB)
	  EndIf

;~ 	  If they run away: wait
	  If GetNumberOfFoesInRangeOfAgent(-2, 200) > 0 Then
		 WaitForSettle(2500, 200)
	  Else
		 Return
	  EndIf

	  If TimerDiff($lDeadlock) > 180 * 1000 Then Return

   WEnd
EndFunc

Func GetGoodTarget(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If Not GetIsEnchanted($lAgentArray[$i]) Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > 200 Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

Func GetGoodTarget2(Const ByRef $lAgentArray)
	Local $lMe = GetAgentByID(-2)
	For $i=1 To $lAgentArray[0]
		If DllStructGetData($lAgentArray[$i], "Allegiance") <> 0x3 Then ContinueLoop
		If DllStructGetData($lAgentArray[$i], "HP") <= 0 Then ContinueLoop
		If GetHasHex($lAgentArray[$i]) Then ContinueLoop
		If GetDistance($lMe, $lAgentArray[$i]) > 200 Then ContinueLoop
		Return DllStructGetData($lAgentArray[$i], "ID")
	Next
EndFunc

Func WaitForSettle($FarRange,$CloseRange,$Timeout = 10000)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $Target
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.4 Then Return
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until GetNumberOfFoesInRangeOfAgent(-2,900) > 0 Or (TimerDiff($Deadlock) > $Timeout)
   Local $Deadlock = TimerInit()
   Do
	  If GetMapLoading() == 2 Then Disconnected()
	  If GetIsDead(-2) Then Return
	  If DllStructGetData(GetAgentByID(-2), "HP") < 0.4 Then Return
	  Sleep(50)
	  $Target = GetFarthestEnemyToAgent(-2,$FarRange)
   Until (GetDistance(-2, $Target) < $CloseRange) Or (TimerDiff($Deadlock) > $Timeout)
EndFunc

Func GetFarthestEnemyToAgent($aAgent = -2, $aDistance = 1250)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $lFarthestAgent, $lFarthestDistance = 0
   Local $lDistance, $lAgent, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  $lDistance = GetDistance($lAgent)
	  If $lDistance > $lFarthestDistance And $lDistance < $aDistance Then
		 $lFarthestAgent = $lAgent
		 $lFarthestDistance = $lDistance
	  EndIf
   Next
   Return $lFarthestAgent
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent = -2, $aRange = 1250)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $lAgent, $lDistance
   Local $lCount = 0, $lAgentArray = GetAgentArray(0xDB)
   If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)
   For $i = 1 To $lAgentArray[0]
	  $lAgent = $lAgentArray[$i]
	  If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
	  If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
	  If GetDistance($lAgent) > $aRange Then ContinueLoop
	  $lCount += 1
   Next
   Return $lCount
EndFunc

Func GetItemCountByID($ID)
   If GetMapLoading() == 2 Then Disconnected()
   Local $Item
   Local $Quantity = 0
   For $Bag = 1 to 4
	  For $Slot = 1 to DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag,$Slot)
		 If DllStructGetData($Item,'ModelID') = $ID Then
			$Quantity += DllStructGetData($Item, 'Quantity')
		 EndIf
	  Next
   Next
   Return $Quantity
EndFunc

Func PickUpLoot()
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $lMe
   Local $lBlockedTimer
   Local $lBlockedCount = 0
   Local $lItemExists = True
   For $i = 1 To GetMaxAgents()
	  If GetMapLoading() == 2 Then Disconnected()
	  $lMe = GetAgentByID(-2)
	  If DllStructGetData($lMe, 'HP') <= 0.0 Then Return
	  $lAgent = GetAgentByID($i)
	  If Not GetIsMovable($lAgent) Then ContinueLoop
	  If Not GetCanPickUp($lAgent) Then ContinueLoop
	  $lItem = GetItemByAgentID($i)
	  If CanPickUp($lItem) Then
		 Do
			If GetMapLoading() == 2 Then Disconnected()
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
EndFunc

Func CanPickUp($lItem)
   If GetMapLoading() == 2 Then Disconnected()
   If GetMapLoading() == 0 Then Return
   If GetIsDead(-2) Then Return
   Local $Quantity
   Local $ModelID = DllStructGetData($lItem, 'ModelID')
   Local $ExtraID = DllStructGetData($lItem, 'ExtraID')
   Local $Type = DllStructGetData($lItem, 'Type')
   Local $rarity = GetRarity($lItem)

;~    Stygian Gems
   If $ModelID = 21129 Then
	  $Drops += DllStructGetData($lItem, 'Quantity')
	  GUICtrlSetData($DropsCount,$Drops)
	  Return True
   EndIf

;~    For $i = 0 To 38 Step +1
;~ 	  If $ModelID = $Array_pscon[i] Then Return True
;~    Next

   If $ModelID = 22191 Or $ModelID = 22190 Then Return True ; Shamrock Ales and Four-Leav Clover

;~    Necro, Warrior, Derv Tomes
   If $ModelID = 21798 OR $ModelID = 21801 OR $ModelID = 21803 Then Return True

;~    Dyes
   If $ModelID = 146 And ($ExtraID = 10 Or $ExtraID = 12) Then Return True

;~    Money
   If $ModelID == 2511 And GetGoldCharacter() < 99000 Then Return True

   If CountFreeSlots() < 4 Then Return False

;~    Goldies
   If _IsChecked($PickUpGoldies) Then
	  If $rarity == 2624 Then Return True
   EndIf

   Return False
EndFunc

Func SellTheStuff()
   If GetMapID() <> 474 And GetMapLoading() <> 0 Then Return
   Local $Me = GetAgentByID(-2)
   Local $X = DllStructGetData($Me, 'X')
   Local $Y = DllStructGetData($Me, 'Y')
   If ComputeDistance($X, $Y, 7436, -11894) < 750 Then
	  MoveTo(6430, -14437)
	  Return
   EndIf
   If ComputeDistance($X, $Y, 4787, -13863) < 750 Then
	  MoveTo(6430, -14437)
   EndIf
   If ComputeDistance($X, $Y, 5851, -16924) < 750 Then
	  Return
   EndIf
   MoveTo(5133, -13571)

;~    gotomerchant
   Local $aMerchName = "Dahn"
   Local $lMerch = GetAgentByName($aMerchName)
   If IsDllStruct($lMerch)Then
	  Out("Going to " & $aMerchName)
	  GoToNPC($lMerch)
	  RndSleep(Random(3000, 4200))
   EndIf

   Out("Identifying")
   Ident(1)
   Ident(2)
   Ident(3)
;  Ident(4)

   Out("Selling")
   Sell(1)
   Sell(2)
   Sell(3)
;  Sell(4)

   If GetGoldCharacter() > 90000 Then
	  Out("Depositing Gold")
	  DepositGold()
   EndIf

   MoveTo(5133, -13571)
   MoveTo(6430, -14437)
   MoveTo(7025, -15297)
   MoveTo(5851, -16924)

EndFunc

Func SalvageStuff()
   If GetMapLoading() == 2 Then Disconnected()
   $MerchOpened = False
   Local $Item
   Local $Quantity
   For $Bag = 1 To 4
	  If GetMapLoading() == 2 Then Disconnected()
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 If GetMapLoading() == 2 Then Disconnected()
		 $Item = GetItemBySlot($Bag, $Slot)
		 If CanSalvage($Item) Then
			$Quantity = DllStructGetData($Item, 'Quantity')
			For $i = 1 To $Quantity
			   If GetMapLoading() == 2 Then Disconnected()
			   If FindCheapSalvageKit() = 0 Then BuySalvageKit()
			   StartSalvage1($Item, True)
			   Do
				  Sleep(10)
			   Until DllStructGetData(GetItemBySlot($Bag, $Slot), 'Quantity') = $Quantity - $i
			   $Item = GetItemBySlot($Bag, $Slot)
			Next
		 EndIf
	  Next
   Next
EndFunc

Func Ident($BAGINDEX)
	Local $bag
	Local $I
	Local $AITEM
	$BAG = GETBAG($BAGINDEX)
	For $I = 1 To DllStructGetData($BAG, "slots")
		If FINDIDKIT() = 0 Then
			If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
				WITHDRAWGOLD(500)
				Sleep(GetPing()+500)
			EndIf
			Local $J = 0
			Do
				Local $aMerchName = "Dahn"
			    Local $lMerch = GetAgentByName($aMerchName)
			    GoNPC($lMerch)
			    BuyItem(6, 1, 500)
				Sleep(GetPing()+500)
				$J = $J + 1
			Until FINDIDKIT() <> 0 Or $J = 3
			If $J = 3 Then ExitLoop
			Sleep(GetPing()+500)
		EndIf
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		IDENTIFYITEM($AITEM)
		Sleep(GetPing()+500)
	Next
EndFunc

Func Sell($BAGINDEX)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		Out("Selling item: " & $BAGINDEX & ", " & $I)
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func GetStygianGemCount()
	Local $AAMOUNTStygianGem
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 21129 Then
				$AAMOUNTStygianGem += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTStygianGem
EndFunc   ; Counts Stygian Gems in your Inventory

Func CanSell($aItem)
   Local $LMODELID = DllStructGetData($aitem, "ModelID")
   Local $LRARITY = GetRarity($aitem)

   Local $ModStruct = GetModStruct($aitem)

;~    Shield Upgrades
   Local $45HPEnch = StringInStr($ModStruct, "002D6823", 0, 1)

;~    Q9 Domi Stuff
   Local $Q9Domi = StringInStr($ModStruct, "09029827", 0, 1)
   Local $Focus = StringInStr($ModStruct, "060CC867", 0, 1)
   Local $Zepter = StringInStr($ModStruct, "0B16A8A7", 0, 1)
   Local $15EneMinus1 = StringInStr($ModStruct, "0F00D822", 0, 1)
   Local $20_20_1 = StringInStr($ModStruct, "00142828", 0, 1)
   Local $20_20_2 = StringInStr($ModStruct, "00140828", 0, 1)

   If $LMODELID == 146 Then
	  Switch DllStructGetData($aitem, "ExtraID")
		 Case 10, 12
			Return False
		 Case Else
			Return True
	  EndSwitch
   EndIf

   Switch $LRARITY
	  Case 2624 ;Rarity Gold
		 If _IsChecked($StoreUpgrades) Then
			If ($Q9Domi > 0) Then
			   If ($Focus > 0) OR ($Zepter > 0) Then
				  Return False
			   Else
				  Return True
			   EndIf
			ElseIf ($15EneMinus1 > 0) Or ($20_20_1 > 0) Or ($20_20_2 > 0) Then
			   Return False
			ElseIf ($45HPEnch > 0) Then
			   Return False
			Else
			   Return True
			EndIf
		 Else
			Return True
		 EndIf
	  Case 2626, 2623 ;Rarity Purple, Blue
		 Return True
	  Case Else ; $Rarity_White
		 Return True
	Endswitch

	Return True
EndFunc   ;==>CanSell

Func StartSalvage1($aItem, $aCheap = false)
   If GetMapLoading() == 2 Then Disconnected()
   Local $lOffset[4] = [0, 0x18, 0x2C, 0x62C]
   Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)
   If IsDllStruct($aItem) = 0 Then
	  Local $lItemID = $aItem
   Else
	  Local $lItemID = DllStructGetData($aItem, 'ID')
   EndIf
   If $aCheap Then
	  Local $lSalvageKit = FindCheapSalvageKit()
   Else
	  Local $lSalvageKit = FindSalvageKit()
   EndIf
   If $lSalvageKit = 0 Then Return
   DllStructSetData($mSalvage, 2, $lItemID)
   DllStructSetData($mSalvage, 3, $lSalvageKit)
   DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])
   Enqueue($mSalvagePtr, 16)
EndFunc

Func CanSalvage($Item)
   If DllStructGetData($Item, 'ModelID') == 835 Then Return True
   Return False
EndFunc

Func FindCheapSalvageKit()
   If GetMapLoading() == 2 Then Disconnected()
   Local $Item
   Local $Kit = 0
   Local $Uses = 101
   For $Bag = 1 To 16
	  For $Slot = 1 To DllStructGetData(GetBag($Bag), 'Slots')
		 $Item = GetItemBySlot($Bag, $Slot)
		 Switch DllStructGetData($Item, 'ModelID')
			Case 2992
			   If DllStructGetData($Item, 'Value')/2 < $Uses Then
				  $Kit = DllStructGetData($Item, 'ID')
				  $Uses = DllStructGetData($Item, 'Value')/8
			   EndIf
			Case Else
			   ContinueLoop
		 EndSwitch
	  Next
   Next
   Return $Kit
EndFunc

;Func BuySalvageKit()
;   WithdrawGold(100)
;   GoToMerch()
;   RndSleep(500)
;   BuyItem(2, 1, 100)
;   Sleep(1500)
;   If FindCheapSalvageKit() = 0 Then BuySalvageKit()
;EndFunc
;~~~~~~~~~> Function included in GWA2 on 22.05.2018

Func GoToMerch()
   If GetMapLoading() == 2 Then Disconnected()
   If $MerchOpened = False Then
	  Local $Me = GetAgentByID(-2)
	  Local $X = DllStructGetData($Me, 'X')
	  Local $Y = DllStructGetData($Me, 'Y')
	  If ComputeDistance($X, $Y, 18383, 11202) < 750 Then
		 MoveTo(17715, 11773)
		 MoveTo(17174, 12403)
	  EndIf
	  If ComputeDistance($X, $Y, 18786, 9415) < 750 Then
		 MoveTo(17684, 10568)
		 MoveTo(17174, 12403)
	  EndIf
	  If ComputeDistance($X, $Y, 16669, 11862) < 750 Then
		 MoveTo(17174, 12403)
	  EndIf
	  TargetNearestAlly()
	  ActionInteract()
	  $MerchOpened = True
   EndIf
EndFunc

Func GetTime()
   Local $Time = GetInstanceUpTime()
   Local $Seconds = Floor($Time/1000)
   Local $Minutes = Floor($Seconds/60)
   Local $Hours = Floor($Minutes/60)
   Local $Second = $Seconds - $Minutes*60
   Local $Minute = $Minutes - $Hours*60
   If $Hours = 0 Then
	  If $Second < 10 Then $InstTime = $Minute&':0'&$Second
	  If $Second >= 10 Then $InstTime = $Minute&':'&$Second
   ElseIf $Hours <> 0 Then
	  If $Minutes < 10 Then
		 If $Second < 10 Then $InstTime = $Hours&':0'&$Minute&':0'&$Second
		 If $Second >= 10 Then $InstTime = $Hours&':0'&$Minute&':'&$Second
	  ElseIf $Minutes >= 10 Then
		 If $Second < 10 Then $InstTime = $Hours&':'&$Minute&':0'&$Second
		 If $Second >= 10 Then $InstTime = $Hours&':'&$Minute&':'&$Second
	  EndIf
   EndIf
   Return $InstTime
EndFunc

Func AvgTime()
   Local $Time = GetInstanceUpTime()
   Local $Seconds = Floor($Time/1000)
   $TotalSeconds += $Seconds
   Local $AvgSeconds = Floor($TotalSeconds/$Runs)
   Local $Minutes = Floor($AvgSeconds/60)
   Local $Hours = Floor($Minutes/60)
   Local $Second = $AvgSeconds - $Minutes*60
   Local $Minute = $Minutes - $Hours*60
   If $Hours = 0 Then
	  If $Second < 10 Then $AvgTime = $Minute&':0'&$Second
	  If $Second >= 10 Then $AvgTime = $Minute&':'&$Second
   ElseIf $Hours <> 0 Then
	  If $Minutes < 10 Then
		 If $Second < 10 Then $AvgTime = $Hours&':0'&$Minute&':0'&$Second
		 If $Second >= 10 Then $AvgTime = $Hours&':0'&$Minute&':'&$Second
	  ElseIf $Minutes >= 10 Then
		 If $Second < 10 Then $AvgTime = $Hours&':'&$Minute&':0'&$Second
		 If $Second >= 10 Then $AvgTime = $Hours&':'&$Minute&':'&$Second
	  EndIf
   EndIf
   Return $AvgTime
EndFunc

Func DropRate()
   If $Drops > 0 Then
	  $aRate = Round($Drops / $TotalKilledEnemy, 3)*100
	  Return $aRate & "%"
   Else
	  Return "-"
   EndIf
EndFunc

Func TimeUpdater()
	$Seconds += 1
	If $Seconds = 60 Then
		$Minutes += 1
		$Seconds = $Seconds - 60
	EndIf
	If $Minutes = 60 Then
		$Hours += 1
		$Minutes = $Minutes - 60
	EndIf
	If $Seconds < 10 Then
		$L_Sec = "0" & $Seconds
	Else
		$L_Sec = $Seconds
	EndIf
	If $Minutes < 10 Then
		$L_Min = "0" & $Minutes
	Else
		$L_Min = $Minutes
	EndIf
	If $Hours < 10 Then
		$L_Hour = "0" & $Hours
	Else
		$L_Hour = $Hours
	EndIf
	GUICtrlSetData($TotTimeCount, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc


Func Out($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func Update($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func _exit()
   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
	  Sleep(500)
   EndIf
   Exit
EndFunc

Func UseSkillEx($lSkill, $lTgt = -2, $aTimeout = 3000)
    If GetIsDead(-2) Then Return
    If Not IsRecharged($lSkill) Then Return
    Local $Skill = GetSkillByID(GetSkillBarSkillID($lSkill, 0))
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

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func CountFreeSlots($NumOfBags = 4)
   Local $FreeSlots, $Slots

   For $Bag = 1 to $NumOfBags
	  $Slots += DllStructGetData(GetBag($Bag), 'Slots')
	  $Slots -= DllStructGetData(GetBag($Bag), 'ItemsCount')
   Next

   Return $Slots
EndFunc

Func CountSlots()
	Local $bag
	Local $temp = 0
	$bag = GetBag(1)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(2)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(3)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(4)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in your Imventory

Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu, 8=eu+int, 11=all(incl. asia)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	WaitMapLoading($aMapID, 30000)
	Sleep(GetPing()+3000)
EndFunc   ;==>RndTravel

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func GoNearestNPCToCoords($x, $y)
    If GetMapLoading() == 2 Then Disconnected()
    If GetMapLoading() == 0 Then Return
    If GetIsDead(-2) Then Return
	Local $guy, $Me
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	If IsRecharged(5) Then UseSkillEx(5, -2)
	GoNPC($guy)
	RndSleep(250)
	Do
	    If GetMapLoading() == 2 Then Disconnected()
	    If GetMapLoading() == 0 Then Return
	    If GetIsDead(-2) Then Return
	    If IsRecharged(5) Then UseSkillEx(5, -2)
		RndSleep(500)
		Move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 40)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords

Func WaitInstanceType($aInstanceType = 0, $aDeadlock = 15000)
;~ 	Waits $aDeadlock for load to start, and $aDeadLock for agent to load after instance type is true.
	Local $lMapLoading
	Local $lDeadlock = TimerInit()

	InitMapLoad()

	Do
		Sleep(200)
		$lMapLoading = GetMapLoading()
		If $lMapLoading == 2 Then $lDeadlock = TimerInit()
		If TimerDiff($lDeadlock) > $aDeadlock And $aDeadlock > 0 Then Return False
	Until $lMapLoading <> 2 And $lMapLoading == $aInstanceType And GetMapIsLoaded()

	RndSleep(5000)

	Return True
EndFunc   ;==>WaitInstanceType


Func ToggleRendering()
   If GUICtrlRead($RenderingBox) == $GUI_UNCHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
   Else
	  DisableRendering()
	  WinSetState($HWND, "", @SW_HIDE)
   EndIf
   Return True
EndFunc

Func Out($msg)
   GUICtrlSetData($StatusLabel, GUICtrlRead($StatusLabel) & "[" & @HOUR & ":" & @MIN & "]" & " " & $msg & @CRLF)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_SCROLLCARET)
   _GUICtrlEdit_Scroll($StatusLabel, $SB_LINEUP)
EndFunc

Func _exit()
   If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
	  EnableRendering()
	  WinSetState($HWND, "", @SW_SHOW)
	  Sleep(500)
   EndIf
   Exit
EndFunc
#EndRegion Functions