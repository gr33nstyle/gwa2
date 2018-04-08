#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "GWA2.au3"

#Region BotGlobals
Global $RARITY_Gold = 2624, $RARITY_Green = 2627
Global $Firstrun = True
#endRegion

#Region GUIGlobals
Global $GUITitle = "Dragon Moss Farmer 3.0"
Global $NewGUITitle
Global $boolrun = False
Global $WeakCounter = 0
Global $Sec = 0
Global $Min = 0
Global $Hour = 0
Global $Runs = 0
Global $GoodRuns = 0
Global $BadRuns = 0
Global $keep_Shields = False
Global $keep_Swords = False
Global $keep_Axes = False
Global $Rendering = True
#endRegion

#Region GUI
Opt("GUIOnEventMode", 1)
$cGUI = GUICreate($GUITitle & "Dragon Moss Farmer 3.0", 389, 200, 341, 397)
$gMain = GUICtrlCreateGroup("Main", 0, 0, 201, 81)
$cCharname = GUICtrlCreateCombo("", 8, 16, 185, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, GetLoggedCharNames())
GUICtrlSetBkColor(-1, 0xFCFCFC)
$bStart = GUICtrlCreateButton("Start", 8, 40, 186, 33)
$bPause = GUICtrlCreateButton("Pause", 0, 0, 1, 1)
GUICtrlSetState($bPause,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$gOpt = GUICtrlCreateGroup("Store", 208, 80, 89, 113)
$select_Shields = GUICtrlCreateCheckbox("Shields", 216, 96, 75, 17)
$select_Swords = GUICtrlCreateCheckbox("Swords", 216, 120, 75, 17)
$select_Axes = GUICtrlCreateCheckbox("Axes", 216, 144, 75, 17)
$cbxHideGW = GUICtrlCreateCheckbox("Disable Rendering", 216, 168, 75, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$gAction = GUICtrlCreateGroup("Current Action", 0, 88, 201, 97)
$lAction = GUICtrlCreateLabel("Waiting...", 8, 104, 189, 72, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lTime = GUICtrlCreateLabel("00:00:00", 208, 8, 175, 57, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
$gStats = GUICtrlCreateGroup("Stats", 304, 80, 81, 113)
$cRuns = GUICtrlCreateLabel("Runs:", 312, 96, 32, 17)
$lRuns = GUICtrlCreateLabel("0", 352, 96, 18, 17)
$cWins = GUICtrlCreateLabel("Wins:", 312, 128, 31, 17)
GUICtrlSetColor(-1, 0x00FF00)
$lWins = GUICtrlCreateLabel("0", 352, 128, 26, 17)
GUICtrlSetColor(-1, 0x00FF00)
$cFails = GUICtrlCreateLabel("Fails", 312, 160, 25, 17)
GUICtrlSetColor(-1, 0xFF0000)
$lFails = GUICtrlCreateLabel("0", 352, 160, 10, 17)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlSetOnEvent($bStart, "GUIHandler")
GUICtrlSetOnEvent($bPause, "GUIHandler")
GUICtrlSetOnEvent($cbxHideGW, "GUIHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIHandler")

GUISetState(@SW_SHOW)

While 1

If $boolrun = False Then
   upd("Paused")
   While $boolRun = False
	  sleep(100)
   WEnd
EndIf

   main()
WEnd

While $boolRun = False
   sleep(100)
WEnd
#EndRegion GUI

#Region Main
Func Main()

If $FirstRun Then
   upd("Going to outpost")
   If GetMapID() <> 349 Then travelTo(349)

    upd("Loading Skills")
	ClearAttributes()
    LoadSkillTemplate("OgcTcZ/85BAozOgNwJIAA3JcAA")

    GoOutside()
	upd("Preparing fast way out")
    MoveTo(-11097, 19483)
    MoveTo(-11220, 19839)
   Do
	   Move(-11343, 20195)
	   Sleep(100)
   Until WaitMapLoading(349)

   $FirstRun = False
EndIf

If CountSlots() < 6 Then
    upd("Inventory")
    Inventory(4)
EndIf

GoOutside()

upd("Moving to farm spot")
If GetMapID() = 195 Then
    UseSkillEx(4,-2)
    MoveTo(-8477, 18580)
    MoveTo(-7878, 18196)
    MoveTo(-6908, 17541)

    Do
	   Move(-4900, 15647)
	   Sleep(100)
    Until GetNumberOfFoesInRangeOfAgent(-2,1300) > 0

    upd("Casting Enchants")
    UseSkillEx(2,-2)
    UseSkillEx(3,-2)
    UseSkillEx(5,-2)

    upd("Aggroing")
    Do
	   Move(-4900, 15647)
    Until GetNumberOfFoesInRangeOfAgent(-2,1050) > 8
EndIf

upd("Balling")
If GetIsLiving(-2) Then MoveTo(-6336, 18153)
If GetIsLiving(-2) Then TolSleep(1000)
If GetIsLiving(-2) Then MoveTo(-6528, 18465)
If GetIsLiving(-2) Then TolSleep(500)
If GetIsLiving(-2) Then MoveTo(-6528, 18528)
If GetIsLiving(-2) Then UseSkillEx(4,-2)

upd("Waiting Sf Cooldown")
If ((GetIsLiving(-2)) and (GetSkillbarSkillRecharge(2) > 0)) Then
   Do
	  Sleep(100)
   Until GetSkillbarSkillRecharge(2) = 0 or GetIsDead(-2)
EndIf
If GetIsLiving(-2) Then UseSkillEx(2,-2)

upd("Killing")
If GetIsLiving(-2) Then UseSkillEx(7,GetNearestAgentToCoords(-6057, 17106))
Do
	Sleep(100)
Until GetDistance(-2,GetNearestAgentToCoords(-6057, 17106)) < 160 or GetIsDead(-2)

If GetIsLiving(-2) Then UseSkillEx(8,-2)
If GetIsDead(-2) Then OmgTheyKilledKennyYouBastards()

Do
	Sleep(250)
Until GetNumberOfFoesInRangeOfAgent(-2,160) < 3 or GetIsDead(-2)
If GetIsDead(-2) Then OmgTheyKilledKennyYouBastards()

upd("Looting")
If GetIsLiving(-2) Then
    Sleep(100)
    PickUpLoot()
	GUIUpdate()
	upd("Going back to town")
    ReturnOutpost()
	ClearMemory()
	Main()
EndIf
EndFunc	;=>Main
#endRegion Main

#Region GUIFuncs
Func GUIHandler()
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
		WinSetTitle($GUITitle, "",GetCharname() & " - " & $GUITitle)
		$boolrun = True
		EnsureEnglish(True)
		GUICtrlSetState($bPause,$GUI_ENABLE)
		GUICtrlSetState($bStart,$GUI_DISABLE)
		AdlibRegister("TimeUpdater",1000)

	Case $bPause
		$boolrun = False
		GUICtrlSetState($bPause,$GUI_DISABLE)
		GUICtrlSetState($bStart,$GUI_ENABLE)
		AdlibUnRegister("TimeUpdater")
		Reset()

    Case $cbxHideGW
			ClearMemory()
			ToggleRendering()

	Case $GUI_EVENT_CLOSE
		Exit
EndSwitch
EndFunc	;=> GUIHandler

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
EndFunc ;=> ToggleRendering

Func Reset()
   $WeakCounter = 0
   $Sec = 0
   $Min = 0
   $Hour = 0
   $Runs = 0
   $GoodRuns = 0
   $BadRuns = 0
   GUICtrlSetData($lTime,"00:00:00")
   GUICtrlSetData($lRuns,"0")
   GUICtrlSetData($lWins,"0")
   GUICtrlSetData($lFails,"0")
EndFunc	;=> Reset

Func GUIUpdate()
	$Runs += 1
	$GoodRuns += 1
	GUICtrlSetData($lRuns,$Runs)
	GUICtrlSetData($lWins,$GoodRuns)
EndFunc	;=> GUIUpdate

Func TimeUpdater()
	$WeakCounter += 1

	$Sec += 1
	If $Sec = 60 Then
		$Min += 1
		$Sec = $Sec - 60
	EndIf

	If $Min = 60 Then
		$Hour += 1
		$Min = $Min - 60
	EndIf

	If $Sec < 10 Then
		$L_Sec = "0" & $Sec
	Else
		$L_Sec = $Sec
	EndIf

	If $Min < 10 Then
		$L_Min = "0" & $Min
	Else
		$L_Min = $Min
	EndIf

	If $Hour < 10 Then
		$L_Hour = "0" & $Hour
	Else
		$L_Hour = $Hour
	EndIf

	GUICtrlSetData($lTime, $L_Hour & ":" & $L_Min & ":" & $L_Sec)
EndFunc	;=> TimeUpdater

Func Upd($msg)
GUICtrlSetData($lAction,$msg)
EndFunc	;=> Upd
#endRegion GUIFuncs#

#Region Botfuncs
Func ReturnOutpost()
	Resign()
	pingSleep(3000)
	ReturnToOutpost()
	Do
	   Sleep(100)
    Until WaitMapLoading(349)
EndFunc	;=> ReturnOutpost

Func UseSkillEx($aSkillSlot, $aTarget)
	$tDeadlock = TimerInit()
	USESKILL($aSkillSlot, $aTarget)
	Do
	   Sleep(50)
	   If GetIsDead(-2) = True Then
		    OmgTheyKilledKennyYouBastards()
	   EndIf
    Until GetSkillBarSkillRecharge($aSkillSlot) <> 0 Or TimerDiff($tDeadlock) > 6000
EndFunc	;=> UseSkillEx

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
EndFunc	;=> GetNumberOfFoesInRangeOfAgent

Func GoOutside()
	upd("Going Outside")
	SwitchMode(1)
    Do
		Move(-11172, -23105)
		Sleep(100)
	Until WaitMapLoading(195)
EndFunc	;=> GoOutside

Func PingSleep($time)
	Sleep($time + GetPing())
EndFunc	;=> PingSleep

Func PickUpLoot()
	Local $lMe
	Local $lBlockedTimer
	Local $lBlockedCount = 0
	Local $lItemExists = True
	Local $Distance

	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then
		   OmgTheyKilledKennyYouBastards()
	    EndIf
		$lAgent = GetAgentByID($i)
		If Not GetIsMovable($lAgent) Then ContinueLoop
	    $lDistance = GetDistance($lAgent)
	    If $lDistance > 2000 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		If CanPickup($lItem) Then
		   Upd("Picking Up Loot")
			Do
				If GetDistance($lAgent) > 150 Then Move(DllStructGetData($lAgent, 'X'), DllStructGetData($lAgent, 'Y'), 100)
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
				Until Not $lItemExists Or TimerDiff($lBlockedTimer) > Random(500, 1000, 1)
				If $lItemExists Then $lBlockedCount += 1
			Until Not $lItemExists Or $lBlockedCount > 5
		EndIf
	Next
EndFunc	;=> PickUpLoot

Func OmgTheyKilledKennyYouBastards()
	    $Runs += 1
	    $BadRuns += 1
	    GUICtrlSetData($lRuns,$Runs)
	    GUICtrlSetData($lFails,$BadRuns)
		ReturnOutpost()
		ClearMemory()
		main()
EndFunc	;=> OmgTheyKilledKennyYouBastards

Func CanPickUp($aitem)
	$m = DllStructGetData($aitem, 'ModelID')
	$type = DllStructGetData($aitem, 'Type')
	$r = GetRarity($aitem)
	If $r = $RARITY_Gold Or $r = $RARITY_Green Then ; all Gold/Green
	    Return True
	  EndIf
	If $m = 146 Then ;Dyes/Lockpicks
		$e = DllStructGetData($aItem, 'ExtraID')
	  If $e = 10 Or $e = 12 Then ; Black, White
			Return True
		 Else
			Return False
	  EndIf
	ElseIf $m = 22751 Then ;Lockpicks
		Return True
    ElseIf ($m = 2511) And (GetGoldCharacter() < 98980) Then ;Goldcoins
		Return True
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return True
	ElseIf $m = 819 Or $m = 934 Or $m = 956 Then ; Dragon Roots/Plant Fibers/Spiritwood Planks
		Return True
    ElseIf $m = 868 Or $m = 904 Or $m = 906 Or $m = 934 Or $m = 957 Then; Bramble Longbow/Flatbow/Hornbow/Recurvebow/Shortbow --- Yeah, Bramble Recurvebow and Plant Fibers Model ID is the same
	    Return True
    ElseIf $m = 910 Or $m = 5585 Or $m = 6049 Or $m = 6368 Or $m = 6369 Or $m = 6370 Or $m = 6375 Or $m = 6376 Or $m = 21488 Or $m = 21489 Or $m = 21491 Or $m = 21492 Or $m = 21809 Or $m = 21810 Or $m = 21812 Or $m = 21813 Or $m = 22190 Or $m = 22191 Or $m = 22269 Or $m = 22644 Or $m = 22752 Or $m = 24593 Or $m = 24862 Or $m = 26784 Or $m = 28433 Or $m = 28434 Or $m = 28435 Or $m = 28436 Or $m = 29436 Or $m = 30855 Or $m = 31151 Or $m = 31152 Or $m = 31153 Or $m = 35121 Or $m = 35124 Or $m = 37765 Then
;910=Hunters Ales, 5585=Dwarven Ale, 6049=Witchs Brews, 6368=Ghost-in-a-box, 6369=Squash Serum, 6370=Peppermint Candy Cane, 6375=Eggnogs, 6376=Snowman Summoner, 21488=Wintergreen Candy Cane, 21489=Rainbow Candy Cane, 21491=Wintersday Gift, 21492=Fruitcakes, 21809=Rocket, 21810=Champagne Popper, 21812=?, 21813=Sparkers, 22190=Shamrock Ale, 22191=Four Leaf Clover , 22269=Birthday Cupcake, 22644=Chocolate Bunny, 22752=Golden Egg, 24593=Aged Dwarven Ale, 24862=Powerstone of Courage, 26784=Honeycomb, 28433=Pumpkin Cookie, 28434=Trick or Treat Bag, 28435=Hard Apple Cider, 28436=Pumpkin Pie, 29436=Crate of Fireworks, 30855=Bottle of Grog, 31151=Blue Rock Candy, 31152=Green Rock Candy, 31153=Red Rock Candy, 35121=War Supplies, 35124=?, 37765=Wayfarer's Mark
	    Return True
	Else
		Return False
	EndIf
EndFunc	;=> CanPickUp
#endRegion Botfuncs

#Region Inventory
Func Inventory($aBags = 4)
    upd("Travelling to Guild Hall")
    TravelGH()
	upd("Going to Xunlai Chest")
    $Xunlai = GetAgentByName('Xunlai Chest')
    GoToNPC($Xunlai)
	sleep(500)
	upd("Going to Merchant")
	$Merch = GetAgentByName('Merchant')
    GoToNPC($Merch)

#Region CheckGUI
   If GUICtrlRead($select_Shields) = 1 Then
	  $keep_Shields = True
   Else
	  $keep_Shields = False
   EndIf

   If GUICtrlRead($select_Swords) = 1 Then
	  $keep_Swords = True
   Else
	  $keep_Swords = False
   EndIf

   If GUICtrlRead($select_Axes) = 1 Then
	  $keep_Axes = True
   Else
	  $keep_Axes = False
   EndIf
#endRegion

	For $i = 1 to $aBags
	   Ident($i)
    Next

	For $i = 1 to $aBags
	   Salvage($i)
    Next

    If GetPlantCount() > 250 Then
	     StorePlants(1, 20)
		 StorePlants(2, 5)
		 StorePlants(3, 10)
		 StorePlants(4, 10)
    EndIf

    If GetSpiritCount() > 250 Then
	     StoreSpirits(1, 20)
		 StoreSpirits(2, 5)
		 StoreSpirits(3, 10)
		 StoreSpirits(4, 10)
    EndIf

    If $keep_Shields = True Then
	   StoreShields(1, 20)
	   StoreShields(2, 5)
	   StoreShields(3, 10)
	   StoreShields(4, 10)
    EndIf

    If $keep_Swords = True Then
	   StoreSwords(1, 20)
	   StoreSwords(2, 5)
	   StoreSwords(3, 10)
	   StoreSwords(4, 10)
    EndIf

	If $keep_Axes = True Then
	   StoreAxes(1, 20)
	   StoreAxes(2, 5)
	   StoreAxes(3, 10)
	   StoreAxes(4, 10)
    EndIf

	For $i = 1 to $aBags
	   Sell($i)
    Next

	DepositGold(GetGoldCharacter())
	LeaveGH()
EndFunc	;=> Inventory

Func Ident($BAGINDEX)
	Local $bag
	Local $I
	Local $AITEM
	$BAG = GETBAG($BAGINDEX)
	upd("Identifying")
	For $I = 1 To DllStructGetData($BAG, "slots")
		If FINDIDKIT() = 0 Then
			If GETGOLDCHARACTER() < 500 And GETGOLDSTORAGE() > 499 Then
				WITHDRAWGOLD(500)
				Sleep(GetPing()+500)
			EndIf
			Local $J = 0
			Do
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
EndFunc	;=> Ident

Func Salvage($lBag)
	  Local $aBag
	  If Not IsDllStruct($lBag) Then $aBag = GetBag($lBag)
	  Local $lItem
	  Local $lSalvageType
	  Local $lSalvageCount
	  upd("Salvaging")
	  For $i = 1 To DllStructGetData($aBag, 'Slots')

			   $lItem = GetItemBySlot($aBag, $i)

			   SalvageKit()

			$q = DllStructGetData($lItem, 'Quantity')
			$t = DllStructGetData($lItem, 'Type')
			$m = DllStructGetData($lItem, 'ModelID')

			   If (DllStructGetData($lItem, 'ID') == 0) Then ContinueLoop

		 If $m = 868  Or $m = 904 Or $m = 906 Or ($t = 5 and $m = 934) Or $m = 957 Then
			   If $q >= 1 Then
						For $j = 1 To $q

							  SalvageKit()

							  StartSalvage($lItem)
							  Sleep(GetPing() + Random(1000, 1500, 1))

							  SalvageMaterials()

							  While (GetPing() > 1250)
									   RndSleep(250)
							  WEnd

							  Local $lDeadlock = TimerInit()
							  Local $bItem
							  Do
									   Sleep(300)
									   $bItem = GetItemBySlot($aBag, $i)
									   If (TimerDiff($lDeadlock) > 20000) Then ExitLoop
							  Until (DllStructGetData($bItem, 'Quantity') = $q - $j)
						Next
			   EndIf
			   EndIf
	  Next
	  Return True
EndFunc	;=> Salvage

Func SalvageKit()
   If FindSalvageKit() = 0 Then
	  If GetGoldCharacter() < 100 Then
		 WithdrawGold(100)
		 RndSleep(2000)
	  EndIf
	  BuyItem(2, 1, 100)
	  RndSleep(1000)
   EndIf
EndFunc	;=> SalvageKit

Func GetPlantCount()
	Local $AAMOUNTPlant
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 934 Then
				$AAMOUNTPlant += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTPlant
EndFunc	;=> GetPlantCount

 Func StorePlants($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	upd("Storing Plant Fibers")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
	    $a = DllStructGetData($aItem, "Quantity")

	  If $m = 934 and $a = 250 Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc	;=> Store Plants

Func GetSpiritCount()
	Local $AAMOUNTSpirit
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 956 Then
				$AAMOUNTSpirit += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSpirit
EndFunc	;=> GetSpiritCount

Func StoreSpirits($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	upd("Storing Spiritwood Planks")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)
        $a = DllStructGetData($aItem, "Quantity")

	  If  $m = 956 and $a = 250 Then

		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc	;=> StoreSpirits

Func StoreShields($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	upd("Storing Items")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)

	    If  $t = 24 and $r = $R_Gold Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc	;=> StoreShields

Func StoreSwords($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	upd("Storing Items")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)

	    If $t = 27 and $r = $R_Gold Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc	;=> StoreSwords

Func StoreAxes($BAGINDEX, $NUMOFSLOTS)
    Local $R_GOLD = 2624
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	upd("Storing Items")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$m = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		$t = DllStructGetData($AITEM, "Type")
		$r = GetRarity($aItem)

	    If $t =  2 and $r = $R_Gold Then
		   Do
				For $BAG = 8 To 16
					$SLOT = FINDEMPTYSLOT($BAG)
					$SLOT = @extended
					If $SLOT <> 0 Then
						$FULL = False
						$NSLOT = $SLOT
						ExitLoop 2
					Else
						$FULL = True
					EndIf
					Sleep(400)
				Next
			Until $FULL = True
			If $FULL = False Then
				MOVEITEM($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc	;=> StoreAxes

Func FindEmptySlot($BAGINDEX)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GETBAG($BAGINDEX), "Slots")
		Sleep(40)
		$LITEMINFO = GETITEMBYSLOT($BAGINDEX, $ASLOT)
		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc	;=> FindEmptySlot

Func Sell($Bagindex)
	Local $AITEM
	Local $BAG = GETBAG($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc	;=> Sell

Func CanSell($lItem)
   Local $R_Gold = 2624
	$t = DllStructGetData($lItem, 'type')
    $m = DllStructGetData($lItem, 'ModelID')
    $r = DllStructGetData($lItem, 'Rarity')

Switch $t
   Case 24 ;Shields
	   If $r = $R_Gold Then
		  Return False
	   Else
		  Return True
	   EndIf

   Case 30 ;Trophys -> Dragon Root
	   Return False

   Case Else
	   If  $m = 22751  or $m = 146 or $m = 819 Or $m = 934 or $m = 956 Then
		  Return False ;Lockpicks & Dyes & Plant Fibers & Spiritwood Planks
	   Else
		  Return True
	   EndIf
EndSwitch
EndFunc	;=> CanSell

Func CountSlots()
	Local $FreeSlots = 0, $lBag, $aBag
	For $aBag = 1 To 4
		$lBag = GetBag($aBag)
		$FreeSlots += DllStructGetData($lBag, 'slots') - DllStructGetData($lBag, 'ItemsCount')
	Next
	Return $FreeSlots
EndFunc	;=> CountSlots

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
EndFunc	;=> GoNearestNPCToCoords
#endRegion Inventory