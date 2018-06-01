#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Knuckles.ico
#AutoIt3Wrapper_Outfile=Kilroy.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include "../GWA2.au3"
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

AutoItSetOption("TrayIconDebug", 1);

#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.0
	GWA2 version: 3.6.9 Modified
	Author:         Ext3h

	Notes for the leechers:
	The best class for this bot is Warrior. I have used this for all classes.
	I like Brawler insignias, Recovery, Restoration and Clarity Runes also.

	Script Function modified by savsuds:
	- Sells Gold Scrolls
	- Stores Iron when a stack is full
	- Buys Ectos when gold is > 90k and storage is full
	- Stores event items when a full stack
	- Stores Some golds (Greater Summit Axe any req)
	- Stores Runes with certain runes inside of them (Survivor, Blessed, Centurion, Shaman, Windwalker, etc)
	- Uses Alcohol, Party, Sweets only in towns until title is maxed
	- Uses Pies once per run if in inventory (Global $usePumpkin = True should be changed to False if you want this disabled)
	- Uses Scroll of the Lightbringer once per run if in inventory 13 July 2015
	- Shortened the WaitforLoad()
	- Added Stopping once Rank 5 Deldrimor title is reached option in the GUI *removed 13 July 2015
	- Added a check box for store iron 13 July 2015
	- Disabled rendering added
	- Revised the GUI a bit to remove a ton of options.

	Added by Ralle1976:
	- Level your heroes while you bot Kilroy. It checks your heroes level and adds them to your party before accepting the quest reward.

Issues remaining:
	* Not implemented yet

Future additions to consider:
	- Speed Rush option

#ce ----------------------------------------------------------------------------

; The bot will cast left to right when recharges, adrenaline, and energy allow
; Change the next line to your skill energy costs
Global $intSkillEnergy[8] = [0, 0, 0, 0, 0, 0, 0, 0]
; Change the next line to your skill adrenaline costs
Global $intAdrenaline[8] = [0, 0, 0, 4, 10, 7, 0, 0]

Global $intSkillPriority[8] = [5, 6, 4, 3, 2, 1]

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

Global $ModelsAlcohol[100] = [910, 5585, 6049, 6375, 22190, 24593, 28435, 30855, 35124, 36682]
Global $ModelSweetOutpost[100] = [36681, 21812, 21492, 22644]
Global $ModelsSweetPve[100] = [22752, 22269, 28436, 31151, 31152, 31153, 28433]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813, 29543, 36683]

Global $Array_pscon[19]=[$ITEM_ID_GLACIAL_STONES, $ITEM_ID_TOTS, $ITEM_ID_GOLDEN_EGGS, $ITEM_ID_BUNNIES, $ITEM_ID_GROG, $ITEM_ID_CLOVER, $ITEM_ID_PIE, $ITEM_ID_CIDER, $ITEM_ID_POPPERS, $ITEM_ID_ROCKETS, $ITEM_ID_CUPCAKES, $ITEM_ID_SPARKLER, $ITEM_ID_HONEYCOMB, $ITEM_ID_VICTORY_TOKEN, $ITEM_ID_LUNAR_TOKEN, $ITEM_ID_HUNTERS_ALE, $ITEM_ID_LUNAR_TOKENS, $ITEM_ID_KRYTAN_BRANDY, $ITEM_ID_BLUE_DRINK]

Global $General_Items_Array[6] = [2989, 2991, 2992, 5899, 5900, 22751]

Global $Array_Store_ModelIDs[77] = [910, 2513, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 36682 _ ; Alcohol
		, 21492, 21812, 22269, 22644, 22752, 28436, 36681 _ ; FruitCake, Blue Drink, Cupcake, Bunnies, Eggs, Pie, Delicious Cake
		, 6376, 21809, 21810, 21813, 36683 _ ; Party Spam
		, 6370, 21488, 21489, 22191, 26784, 28433 _ ; DP Removals
		, 15837, 21490, 30648, 31020 _ ; Tonics
		, 556, 18345, 21491, 37765, 21833, 28433, 28434, 460 _ ; CC Shards, Victory Token, Wayfarer, Lunar Tokens, ToTs, Emblems
		, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533] ; All Materials

Global $pconsPumpkinPie_slot[2]
Global $scrollsLightbringer_slot[2]
Global $usePumpkin = True ; set it on true and he use it
Global $useLightbringer = True ; set to true and he use it
Global $ITEM_ID_PUMPKINPIE = 28436
Global Const $ITEM_ID_Scroll_of_the_Lightbringer = 21233

#Region ModelID's
;~ Axe
Global $GreaterSummitAxe = 2213
;~ Shields
Global $OakenAegis = 2414
Global $ShieldoftheLion = 1888
Global $EquineAegisCommand = 2409
Global $EquineAegisTactics = 2410
Global $EbonhandAegis = 2408
Global $SummitWarlordTactics = 2417
;~ Hammers
Global $RubyMaul = 2274; not in array
;~ Bows
Global $DragonHornbow = 1760
Global $MaplewoodLongbow = 2037

Global $Array_Weapon_ModelID[9][2] = [ _
									[$OakenAegis, 16], _
									[$ShieldoftheLion, 16], _
									[$EquineAegisCommand, 16], _
									[$EquineAegisTactics, 16], _
									[$EbonhandAegis, 16], _
									[$DragonHornbow, 28], _
									[$MaplewoodLongbow, 28], _
									[$GreaterSummitAxe, 28], _
									[$SummitWarlordTactics, 16]]
#EndRegion ModelID's

Global $Hero_Base_Array[][] = [ _
[13, False, 0], _
['Norgu', False, 1], _;1
['Goren', False, 2], _;2
['Tahlkora', False, 3], _;3
['Meister  der Gerüchte', False, 4], _;4
['Akolythin Jin', False, 5], _;5
['Koss', False, 6], _;6
['Dunkoro', False, 7], _;7
['Akolyth Sousuke', False, 8], _;8
['Melonni', False, 9], _;9
['Zhed Schattenhuf', False, 10], _;10
['Margrid die Listige', False, 12], _;12
['Zenmai', False, 13], _;13
['Olias', False, 14]];14

EnsureEnglish(1)
Opt("GUIOnEventMode", 1)
Global $boolRun = False
Global $boolSellDyes = True
Global $boolDrinkBeer = True
Global $boolEatSweets = True
Global $boolParty = True
Global $StoreIron = False
; Global $DeldrimorRank5 = False
; Global $SurvivorRank3 = False
Global $boolSalvageWeapons = True
Global $intStarted = -1
Global $intRuns = 0
Global $RenderingEnabled = True
Global Const $savsuds_Is_Cool = True

Global $townGunnar = 644
Global $areaLair = 704
Global $enemyID = 0
Global $kilroyID
Global $meID
Global $tSwitchtarget
Global $tLastTarget, $tRun, $tBlock

Global $RunProf
Global $giveup = False

$cGUI = GUICreate("Punch-Out Extravaganza!", 270, 150)
$lblName = GUICtrlCreateLabel("Character Name:", 8, 8, 80, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$cCharname = GUICtrlCreateCombo("", 105, 4, 150, 20)
InitSetCharnames()
$storingIron = GUICtrlCreateCheckbox("Store Iron", 8, 28, 110, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 135, 28, 110, 17)
	GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
$lblR2D2 = GUICtrlCreateLabel("Deldrimor:", 8, 48, 130, 17)
$lblRuns = GUICtrlCreateLabel("-", 140, 48, 100, 17, $SS_CENTER)
$lblR3D3 = GUICtrlCreateLabel("Survivor:", 8, 68, 130, 17)
$lblRuns2 = GUICtrlCreateLabel("-", 140, 68, 100, 17, $SS_CENTER)

$lblStatus = GUICtrlCreateLabel("Ready to begin", 8, 88, 256, 17, $SS_CENTER)
$btnStart = GUICtrlCreateButton("Start", 7, 108, 256, 25, $WS_GROUP)

GUICtrlSetOnEvent($btnStart, "EventHandler")
GUICtrlSetOnEvent($storingIron, "EventHandler")
; GUICtrlSetOnEvent($cbxSurvivor, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")

Global $RARITY_White = 2621, $RARITY_Blue = 2623, $RARITY_Purple = 2626, $RARITY_Gold = 2624, $RARITY_Green = 2627

GUISetState(@SW_SHOW)

Func EventHandler()
	Switch (@GUI_CtrlId)
		Case $btnStart
			$boolRun = Not $boolRun
			If $boolRun Then
				If GUICtrlRead($cCharname) = "" Then
					If Initialize(ProcessExists("gw.exe")) = False Then
						MsgBox(0, "Error", "Guild Wars it not running.")
						Exit
					EndIf
				Else
					If Initialize(GUICtrlRead($cCharname)) = False Then
						MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
						Exit
					EndIf
				EndIf

				GUICtrlSetData($btnStart, "Pause")
				GUICtrlSetState($cCharname, $GUI_DISABLE)

			Else
				GUICtrlSetData($btnStart, "BOT WILL HALT AFTER THIS RUN")
				GUICtrlSetState($btnStart, $GUI_DISABLE)
			EndIf
		Case $storingIron
			If GUICtrlRead($storingIron) = 1 Then
				$StoreIron = True
			Else
				$StoreIron = False
			EndIf
		Case $GUI_EVENT_CLOSE
			If $RenderingEnabled = False Then
				EnableRendering()
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
			EndIf
			Exit
	EndSwitch
EndFunc   ;==>EventHandler
#Region Bot Functions



While 1
	Sleep(100)
	If $boolRun Then
		; To set up the GUI stats at the start and before each run
		GUICtrlSetData($lblRuns, GetDeldrimorTitle())
		GUICtrlSetData($lblRuns2, GetSurvivorTitle())

		If GetMapID() <> $townGunnar Then
			TravelTo($townGunnar)
		EndIf

		If CountSlots() < 20 Then
			IDAndSell()
		EndIf

		If InventoryCheck() Then
			$boolRun = False
			Update("Bot stopped, low inventory space")
			GUICtrlSetData($btnStart, "Start")
			GUICtrlSetState($txtName, $GUI_ENABLE)
			GUICtrlSetState($btnStart, $GUI_ENABLE)

			If ProcessExists($mGWHwnd) Then
				ProcessClose($mGWHwnd)
;			If ProcessExists("Gw.exe") Then
;				ProcessClose("Gw.exe")
				MsgBox(0, "", "Bot stopped, low inventory space")
				Exit
			EndIf
		EndIf

		GoOutside()

		$tRun = TimerInit()
		AdlibRegister("DeathCheck", 1000)
		Do
			Sleep(200)
			$kilroyID = DllStructGetData(GetNearestNPCToAgent(-2), 'Id')
		Until $kilroyID <> 0
		$meID = -2
		$giveup = False
		$tLastTarget = TimerInit()
		Fight()
		AdlibUnRegister("DeathCheck")

		Update("Returning to town")
		PingSleep(1000)
		If GetMapID() <> $townGunnar Then
			TravelTo($townGunnar)
			WaitForLoad()
		EndIf
		; These are here to get you the spam titles until they are maxed.
		If GetDrunkardTitle() < 10000 Then
			Sleep(200)
			UseItems($ModelsAlcohol)
		EndIf

		If GetSweetTitle() < 10000 Then
			Sleep(200)
			UseItems($ModelSweetOutpost)
		EndIf

		If GetPartyTitle() < 10000 Then
			Sleep(200)
			UseItems($ModelsParty)
		EndIf
		; In case you selected Stop at Rank 5, this will make sure it enables the GW screen on exit
;		If $DeldrimorRank5 And GetDeldrimorTitle() >= 26000 Then
;			EnableRendering()
;			WinSetState(GetWindowHandle(), "", @SW_SHOW)
;			Exit
;		EndIf

		Update("Grabbing Heroes")

		Local $lHeroes = GetAllNonLevel20HeroIDs()
		For $i = 1 to $lHeroes[0]
			AddHero($lHeroes[$i])
			Sleep(Random(500,1000,1))
		Next

		Update("Turning in quest")
		GoNearestNPCToCoords(17341, -4796)
		Sleep(GetPing()+500)
		QuestReward(856)
		Sleep(GetPing()+500)

		If Not $boolRun Then
			Update("Bot was paused")
			GUICtrlSetData($btnStart, "Start")
			GUICtrlSetState($btnStart, $GUI_ENABLE)
			GUICtrlSetState($cCharname, $GUI_ENABLE)
		EndIf
		AbandonQuest(856)
		Sleep(GetPing()+500)

		KickAllHeroes()
		Sleep(GetPing()+500)

		DistrictChange()

		Clearmemory()
		_PurgeHook()
	EndIf
WEnd

Func GoOutside()
	Update("Leaving town")
	GoNearestNPCToCoords(17341, -4796)
	Sleep(GetPing()+500)
	AcceptQuest(856)
	Sleep(GetPing()+500)
	Dialog(0x85)
	Sleep(GetPing()+500)
	Do
		WaitForLoad()
	Until GetMapID() = $areaLair
	pconsScanInventory()
	Sleep(GetPing()+500)
	UsePumpkinPie()
	Sleep(GetPing()+500)
	SetDisplayedTitle(0x27) ; Displays your Deldrimor title
	Sleep(GetPing()+500)
EndFunc   ;==>GoOutside

Func DeathCheck()
	If $giveup Then
		Return
	EndIf
	$Me = GetAgentByID(-2)
	If DllStructGetData($Me, 'MaxEnergy') >= 60 Then
		ConsoleWrite("Got deadlocked, giving up" & @CRLF)
		GiveUp()
		Return
	EndIf
	If TimerDiff($tLastTarget) > 60 * 1000 Or TimerDiff($tRun) > 10 * 60 * 1000 Then
		ConsoleWrite("Got deadlocked, giving up" & @CRLF)
		GiveUp()
		Return
	EndIf
	If GetmapID() <> $areaLair Then
		ConsoleWrite("Got kicked out of area, giving up" & @CRLF)
		GiveUp()
		Return
	EndIf
	While DllStructGetData($Me, "EnergyPercent") < 1.0
		UseSkill(8, $enemyID)
		RndSleep(100)
		$Me = GetAgentByID(-2)
	WEnd
EndFunc   ;==>DeathCheck

Func GiveUp()
	If $giveup = False Then
		$giveup = True
		AdlibUnRegister("DeathCheck")
	EndIf
EndFunc

Func SelectTarget()
	$target = GetCurrentTarget()
	$Me = GetAgentByID(-2)
	If $target <> 0 And DllStructGetData($target, 'Type') = 219 _
			And DllStructGetData($target, 'Allegiance') = 3 And GetIsDead($target) = 0 Then
		If TimerDiff($tSwitchtarget) < 1000 Or GetDistance($Me, $target) < 100 Then
			Return DllStructGetData($target, 'Id')
		Else
			ConsoleWrite("Switching target, out of range!" & @CRLF)
		EndIf
	EndIf
	$tSwitchtarget = TimerInit()
	Update("Looking for items")
	PickupItems(1000)
	Update("Selecting new target")
	$kilroy = GetAgentById($kilroyID)
	If GetIsDead($kilroy) Then
		$target = GetNearestEnemyToAgent($meID)
		ConsoleWrite("Kilroy is dead! Roaming!" & @CRLF)
	Else
		$target = GetAgentByID(GetTarget($kilroy))
		If $target = 0 Or GetIsDead($target) Or DllStructGetData($target, 'Allegiance') <> 3 Then
			$possibletarget = GetNearestEnemyToAgent($kilroy)
			If GetDistance($possibletarget, $kilroy) < 1250 Then
				ConsoleWrite("Roaming!" & @CRLF)
				$target = $possibletarget
			EndIf
		Else
			ConsoleWrite("Trying to copy target!" & @CRLF)
		EndIf
	EndIf
	If GetIsBoss($target) Then
		;It's a boss, lets search for minions first!
		$possibletarget = GetNearestEnemyToAgent($target)
		If $possibletarget <> 0 And GetDistance($possibletarget, $kilroy) < 1250 Then
			ConsoleWrite("Retargeting to minion!" & @CRLF)
			$target = $possibletarget
		EndIf
	EndIf
	If $target <> 0 And GetIsDead($target) = 0 Then
		$targetId = DllStructGetData($target, 'Id')
		Update("Attacking " & $targetId)
		ChangeTarget($target)
		Sleep(GetPing())
		Attack($target)
		Return $targetId
	EndIf
EndFunc   ;==>SelectTarget

Func Fight()
	Update("Fighting!")
	Do
		$enemyID = SelectTarget()
		While $enemyID <> 0 And Not $giveup
			$tLastTarget = TimerInit()
			$target = GetAgentByID($enemyID)
			$targetHP = DllStructGetData($target, 'HP')
			$shouldblock = GetIsCasting($target) And GetDistance($target, -2) < 200

			$skillbar = GetSkillbar()
			$useSkill = -1
			If DllStructGetData($skillbar, 'Id7') <> 0 And DllStructGetData($skillbar, 'Recharge7') = 0 Then
				$useSkill = 7; Finisher
			ElseIf TimerDiff($tBlock) > 1000 And DllStructGetData(GetEffect(485), 'SkillID') == 0 And DllStructGetData($skillbar, 'Recharge1') == 0 Then
				$useSkill = 1; Block
				$tBlock = TimerInit()
			ElseIf $shouldblock And DllStructGetData($skillbar, 'Recharge3') = 0 Then
				$useSkill = 3; Interrupt
				CancelAction(); No point in interrupting, if it would come to late
			ElseIf DllStructGetData($skillbar, 'AdrenalineA5') >= 10 * 25 And DllStructGetData($skillbar, 'Recharge5') == 0 Then
				$useSkill = 5; Uppercut
			ElseIf DllStructGetData($skillbar, 'AdrenalineA6') >= 7 * 25 And DllStructGetData($skillbar, 'Recharge6') == 0 Then
				$useSkill = 6; Headbutt
			ElseIf DllStructGetData($skillbar, 'AdrenalineA4') >= 4 * 25 And DllStructGetData($skillbar, 'Recharge4') == 0 Then
				$useSkill = 4; Hook
			Else
				$useSkill = 2
			EndIf
			If $useSkill <> -1 Then
				UseSkill($useSkill, $target)
			EndIf

			Sleep(200)
			$enemyID = SelectTarget()
		WEnd
		Update("Following Kilroy " & $kilroyID)
		RndSleep(GetPing())
		$kilroy = GetAgentById($kilroyID)
		Move(DllStructGetData($kilroy, 'X'), DllStructGetData($kilroy, 'Y'), 400)
		RndSleep(500)
	Until $giveup Or DoChest() Or GetMapID() <> $areaLair
EndFunc   ;==>Fight

Func DoChest() ;~ End Chest after quest is done
	Sleep(GetPing())
	$chest = GetNearestSignpostToCoords(13275, -16039)
	If $chest <> 0 And DllStructGetData($chest, 'Type') = 512 And GetDistance2(13275, -16039, $chest) < 100 Then
		ConsoleWrite("Found Chest" & @CRLF)
		GoToSignpost($chest)
		OpenChest()
		Sleep(Random(700, 900))
		PickUpItems()
		Sleep(Random(700, 900))
		Return True
	EndIf
	ChangeTarget(0)
	Sleep(GetPing())
	Return False
EndFunc   ;==>DoChest
#EndRegion Bot Functions

#Region Inventory
Func IDAndSell()
	If GetGoldCharacter() > 80000 Then
		Update("Depositing gold")
		DepositGold(70000)
		Sleep(GetPing()+500)
	EndIf

	Update("Storing golds")
	StoreGolds()

	Update("Cleaning inventory")
	RndSleep(1000)
	MoveToEx(17822, -7520, 0)
	GoNearestNPCToCoords(17664, -7724)

	$i = 0;
	Do
		If FindIDKit() = 0 Then
			If GetGoldCharacter() < 100 And GetGoldStorage() > 99 Then
				WithdrawGold(100)
				Sleep(GetPIng()+250)
			EndIf
			BuyIDKit()
			Do
				Sleep(200)
			Until FindIDKit() <> 0
		EndIf
		Ident()
		Sleep(GetPing())
		$i += 1
	Until FindIDKit() <> 0 Or $i > 4

	StoreRunes()
	Sleep(GetPing()+500)

	Do
		If FindCheapSalvageKit() = 0 Then
			If GetGoldCharacter() < 100 And GetGoldStorage() > 99 Then
				WithdrawGold(100)
				Sleep(GetPIng()+250)
			EndIf
			BuyItem(2, 1, 100)
			Do
				Sleep(200)
			Until FindCheapSalvageKit() <> 0
		EndIf
		Salvage()
		Sleep(GetPing())
		$i += 1
	Until FindCheapSalvageKit() <> 0 Or $i > 100

	Sell()

	Update("Selling materials")
	MoveToEx(18693, -7445, 0)
	MoveToEx(18694, -7804, 0)
	GoNearestNPCToCoords(18695, -7902)

	SellMaterials(1)
	SellMaterials(2)
	SellMaterials(3)
	SellMaterials(4)

	StoreItems()

	If FindDye() <> 0 Then
		Update("Selling dye")
		MoveToEx(19315, -7087, 0)
		MoveToEx(19460, -7247, 0)
		GoNearestNPCToCoords(19530, -7327)
		SellColors(1)
		SellColors(2)
		SellColors(3)
		SellColors(4)
	EndIf

	If FindScroll() <> 0 Then
		Update("Selling Scrolls")
		MoveToEx(17867, -6371, 0)
		MoveToEx(17830, -6185, 0)
		GoNearestNPCToCoords(17811, -6071)
		SellScrolls(1)
		SellScrolls(2)
		SellScrolls(3)
		SellScrolls(4)
	EndIf

	If GetGoldCharacter() > 90000 Then
		Update("Buying Ectos")
		MoveToEx(18978, -7765, 0)
		MoveToEx(19000, -8270, 0)
		GoNearestNPCToCoords(18764, -8031)
		; Charcoal = 922, Claw = 23, Linen = 926, Damask = 927, Silk = 928, Ecto = 930, Eye = 931
		; Fang = 932, Diamong = 935, Onyx = 936, Ruby = 937, Sapphire = 938, Vial = 939, Fur = 941
		; Leather Sqaure = 942, Elonian Leather = 943, Ink = 944, Shard = 945, Steel = 948,
		; Deldrimor Steel = 950, Parchment = 951, Vellum= 952, Spiritwood = 956, Amber = 6532, Jade = 6533
		Local $MatID = 930
		TraderRequest($MatID)
		Sleep(GetPing()+1000)
		While GetGoldCharacter() > 20*1000
			TraderRequest($MatID)
			Sleep(GetPing()+100)
			TraderBuy()
		WEnd
	EndIf
EndFunc   ;==>IDAndSell

Func Ident()
	Local $aitem, $lBag
	For $i = 1 To 4
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$aitem = GetItemBySlot($lBag, $j)
			If FindIDKit() = 0 Then
				If GetGoldCharacter() < 100 And GetGoldStorage() > 99 Then
					WithdrawGold(100)
					Sleep(GetPing()+250)
				EndIf
				Local $K = 0
				Do
					BuyItem(5, 1, 100)
					Sleep(GetPing()+250)
					$K = $K + 1
				Until FindIDKit() <> 0 Or $K = 3
				If $K = 3 Then ExitLoop
				Sleep(GetPing()+250)
			EndIf
			If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
			Update("Identifying item: " & $I & ", " & $j)
			If CanIdentify($aitem) Then
				IdentifyItem($AITEM)
				Sleep(GetPing()+250)
			EndIf
		Next
	Next
EndFunc

Func CanIdentify($aItem)
	Local $m = DllStructGetData($aitem, "ModelID")
	Local $r = GetRarity($aitem)
	Switch $r
		Case $Rarity_Gold, $Rarity_Purple, $Rarity_Blue
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>CanSell

Func Sell()
	Local $aitem, $lBag
	For $i = 1 To 4
		$lBag = Getbag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$aitem = GetItemBySlot($lBag, $j)
			If DllStructGetData($aitem, "ID") = 0 Then ContinueLoop
			If CanSell($aitem) Then
				SellItem($aitem)
				Sleep(GetPing()+250)
			EndIf
		Next
	Next
EndFunc

Func CanSell($aitem)
	Local $r
	Local $m = DllStructGetData($aitem, "ModelID")
	Local $consumables[100] = [22752, 22269, 28436, 31152, 31151, 31153, 35121, 28433, 26784, 6370, 21488, 21489, 22191, 24862, 21492, _
			22644, 30855, 6375, 22190, 6049, 910, 28435, 6369, 21809, 21810, 21813, 6376, 6368, 29436, 21491, 28434, 35124, 36682, _
			21812, 21809, 21813, 21810]

	If $m = 0 Then
		Return False
	EndIf
	$r = GetRarity($aitem)
	If $r = $Rarity_Gold Then ; gold items
		If $m = 5594 Or $m = 5595 Or $m = 5611 Or $m = 21233 Then ; Gold Scrolls
			Return False
		Else
			Return True
		EndIf
	ElseIf $m = 5594 Or $m = 5595 Or $m = 5611 Then
		Return False
	ElseIf $m > 921 And $m < 956 Then ;Materials
		Return False
	ElseIf $m = 6532 Or $m = 6533 Then ;Materials
		Return False
	ElseIf $m > 21785 And $m < 21806 Then ;Elite/Normal Tomes
		Return False
	ElseIf $m = 146 Or $m = 22751 Then ;Dyes/Lockpicks
		Return False
	ElseIf $m = 2991 Or $m = 2992 Or $m = 2989 Or $m = 5899 Then ; Kits
		Return False
	ElseIf $m = 24593 Or $m = 5585 Then ; Aged Dwarven Ale and Dwarven Ale
		Return False
	ElseIf $m = 24897 Then ;Brass Knuckles
		Return False
	ElseIf _ArraySearch($consumables, $m) <> -1 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CanSell

Func SellMaterials($bagIndex)
	Local $materials[11] = [921, 925, 929, 933, 934, 940, 946, 948, 953, 954, 955]
	Local $materials1[10] = [921, 925, 929, 933, 934, 940, 946, 953, 954, 955]
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	If $StoreIron = True Then
		For $I = 1 To $numOfSlots
			$item = GetItemBySlot($bagIndex, $I)
			If DllStructGetData($item, 'ID') <> 0 And _ArraySearch($materials1, DllStructGetData($item, 'ModelID')) <> -1 Then
				Local $quantity = DllStructGetData($item, 'quantity')
				For $x = 1 To $quantity / 10
					If GetGoldCharacter() > 90000 Then
						DepositGold(70000)
					EndIf
					TraderRequestSell($item)
					TraderSell()
					$item = GetItemBySlot($bagIndex, $I)
				Next
			EndIf
		Next

	EndIf
	If $StoreIron = False Then
		For $I = 1 To $numOfSlots
			$item = GetItemBySlot($bagIndex, $I)
			If DllStructGetData($item, 'ID') <> 0 And _ArraySearch($materials, DllStructGetData($item, 'ModelID')) <> -1 Then
				Local $quantity = DllStructGetData($item, 'quantity')
				For $x = 1 To $quantity / 10
					If GetGoldCharacter() > 90000 Then
						DepositGold(70000)
					EndIf
					TraderRequestSell($item)
					TraderSell()
					$item = GetItemBySlot($bagIndex, $I)
				Next
			EndIf
		Next
	EndIf
EndFunc   ;==>Sell

Func FindDye()
	Local $lItem
	For $I = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($I), 'Slots')
			$lItem = GetItemBySlot($I, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 146
					Return $lItem
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return 0
EndFunc   ;==>Find Dyes

Func SellColors($bagIndex)
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	For $I = 1 To $numOfSlots
		$item = GetItemBySlot($bagIndex, $I)
		If DllStructGetData($item, 'ID') <> 0 And DllStructGetData($item, 'ModelID') = 146 Then
			Local $quantity = DllStructGetData($item, 'quantity')
			For $x = 1 To $quantity
				If GetGoldCharacter() > 90000 Then
					DepositGold(70000)
				EndIf
				TraderRequestSell($item)
				TraderSell()
				$item = GetItemBySlot($bagIndex, $I)
			Next
		EndIf
	Next
EndFunc   ;==>Sell

Func FindScroll()
	Local $lItem
	For $I = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($I), 'Slots')
			$lItem = GetItemBySlot($I, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 5594
					Return $lItem
				Case 5595
					Return $lItem
				Case 5611
					Return $lItem
;				Case 21233
;					Return $lItem
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return 0
EndFunc   ;==>Find Scrolls

Func SellScrolls($bagIndex)
	Local $scrolls[100] = [5594, 5595, 5611]
	$bag = GetBag($bagIndex)
	$numOfSlots = DllStructGetData($bag, 'slots')
	For $I = 1 To $numOfSlots
		$item = GetItemBySlot($bagIndex, $I)
		If DllStructGetData($item, 'ID') <> 0 And _ArraySearch($scrolls, DllStructGetData($item, 'ModelID')) <> -1 Then
			Local $quantity = DllStructGetData($item, 'quantity')
			For $x = 1 To $quantity
				If GetGoldCharacter() > 90000 Then
					DepositGold(70000)
				EndIf
				TraderRequestSell($item)
				TraderSell()
				$item = GetItemBySlot($bagIndex, $I)
			Next
		EndIf
	Next
EndFunc   ;==>Sell

Func InventoryCheck()
	$temp = CountSlots()
	If $temp < 5 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>InventoryCheck
#EndRegion Inventory

#Region Salvage
;~ Description: Returns item ID of salvage kit in inventory.
Func FindCheapSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2992
					If DllStructGetData($lItem, 'Value') / 2 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc   ;==>FindSalvageKit

Func Salvage()
	Local $lItem
	Local $quantity
	For $I = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($I), 'Slots')
			$lItem = GetItemBySlot($I, $j)
			Update("Salvaging item: " & $I & ", " & $j)
			If CanSalvage($lItem) Then
				$quantity = DllStructGetData($lItem, 'quantity')
				For $x = 1 To $quantity
					$salvagekit = FindCheapSalvageKit()
					If $salvagekit = 0 Then
						Return
					EndIf
					$oldvalue = DllStructGetData(GetItemByItemID($salvagekit), 'Value')
					Update("Salvaging item: " & $I & ", " & $j)
					StartSalvage2($lItem, True)
					Do
						Sleep(200)
					Until FindCheapSalvageKit() <> $salvagekit Or DllStructGetData(GetItemByItemID($salvagekit), 'Value') <> $oldvalue
					$lItem = GetItemBySlot($I, $j)
					Sleep(GetPing())
				Next
			EndIf
		Next
	Next
EndFunc

Func CanSalvage($item)
	If DllStructGetData($item, 'ModelID') = 0 Then Return False
	If $boolSalvageWeapons Then
		Local $salvageable[100] = [539, 1118, 1121, 1123, 2184, 2185, 27044, 27047]
		$item_requirement = GetItemReq($item)
		$item_attribute = GetItemAttribute($item)
		If GETRARITY($item) <> $RARITY_White And GETRARITY($item) <> $RARITY_Blue Then
			Return False
		ElseIf _ArraySearch($salvageable, DllStructGetData($item, 'ModelID')) <> -1 Then
			Return True
		ElseIf $item_attribute >= 17 And $item_attribute <= 21 Then ; Warrior weapons
			Return True
		ElseIf $item_attribute >= 37 And $item_attribute <= 40 Then ; Paragon weapons
			Return True
		ElseIf $item_attribute = 29 Or $item_attribute = 41 Then ; Dagger Scythe
			Return True
		EndIf
		Return False
	Else
		Return DllStructGetData($item, 'ModelID') == 27044
	EndIf
EndFunc

;~ Description: Starts a salvaging session of an item.
Func StartSalvage2($aItem, $aCheap = false)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x690]
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
EndFunc   ;==>StartSalvage
#EndRegion Salvage

#Region Store
Func StoreItems()
	Local $AITEM, $M, $Q, $lBag, $SLOT, $FULL, $NSLOT
	For $i = 1 To 4
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
		   $AITEM = GetItemBySlot($lBag, $j)
		   If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		   $M = DllStructGetData($AITEM, "ModelID")
		   $Q = DllStructGetData($AITEM, "quantity")
		   For $z = 0 To (UBound($Array_Store_ModelIDs) -1)
			  If (($M == $Array_Store_ModelIDs[$z]) And ($Q = 250)) Then
				  Do
					  For $BAG = 8 To 12
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
		 Next
	Next
EndFunc ;~ Includes event items broken down by type

Func StoreGolds()
	Local $AITEM, $lItem, $M, $Q, $R, $lBag, $SLOT, $FULL, $NSLOT
	For $i = 1 To 4
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
		   $AITEM = GetItemBySlot($lBag, $j)
		   If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		   $M = DllStructGetData($AITEM, "ModelID")
		   $R = GetRarity($litem)
			If $R = 2624 And $m = 2213 Then
				Do
					For $BAG = 8 To 12
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
	Next
EndFunc ;~ UNID golds

Func StoreRunes()
	Local $aitem, $lBag, $slot, $full, $nSlot
	For $i = 1 To 4
		$lbag = Getbag($i)
		For $j = 1 To DllStructGetData($lBag, "slots")
			$aitem = GetItemBySlot($lBag, $j)
			If DllStructGetData($aitem, "ID") = 0 Then ContinueLoop
			If CanStoreRunes($aitem) Then
				Do
					For $bag = 8 To 12
						$slot = FindEmptySlot($bag)
						$slot = @extended
						If $slot <> 0 Then
							$full = False
							$nSlot = $slot
							ExitLoop 2
						Else
							$full = True
						EndIf
						Sleep(400)
					Next
				Until $full = True
				If $full = False Then
					MoveItem($aitem, $bag, $nSlot)
					Sleep(GetPing()+250)
				EndIf
			EndIf
		Next
	Next
EndFunc

Func CanStoreRunes($aitem)
	Local $m = DllStructGetData($aitem, "ModelID")
	Local $t = DllStructGetData($aitem, "Type")
	Local $q = DllStructGetData($aitem, "Quantity")
	Local $r = GetRarity($aitem)
	Local $ModStruct = GetModStruct($aitem)
	Local $MinorVigor = StringInStr($ModStruct, "C202E827", 0, 1)
	Local $MajorVigor = StringInStr($ModStruct, "C202E927", 0, 1)
	Local $SupVigor = StringInStr($ModStruct, "C202EA27", 0, 1)
	Local $Vitae = StringInStr($ModStruct, "000A4823", 0, 1)
;	Local $Attunement = StringInStr($ModStruct, "0200D822", 0, 1)
	Local $Survivor = StringInStr($ModStruct, "0005D826", 0, 1)
	Local $Blessed = StringInStr($ModStruct, "E9010824", 0, 1)
	Local $Sentinel = StringInStr($ModStruct, "FB010824", 0, 1)
	Local $MinorScythe = StringInStr($ModStruct, "0129E821", 0, 1)
	Local $MinorDivine = StringInStr($ModStruct, "0110E821", 0, 1)
	Local $MinorDeath = StringInStr($ModStruct, "0105E821", 0, 1)
	Local $SupDeath = StringInStr($ModStruct, "0305E8217901", 0, 1)
	Local $MinorSoulReaping = StringInStr($ModStruct, "0106E821", 0, 1)
	Local $MinorFastCasting = StringInStr($ModStruct, "0100E821", 0, 1)
	Local $MinorInspiration = StringInStr($ModStruct, "0103E821", 0, 1)
	Local $MinorEnergyStorage = StringInStr($ModStruct, "010CE821", 0, 1)
	Local $MinorSpawning = StringInStr($ModStruct, "0124E821", 0, 1)
	Local $WindWalker = StringInStr($ModStruct, "02020824", 0, 1)
	Local $Shaman = StringInStr($ModStruct, "04020824", 0, 1)
	Local $Centurion = StringInStr($ModStruct, "07020824", 0, 1)
	Switch $r
		Case $Rarity_Gold, $Rarity_Purple, $Rarity_Blue
			If ($SupVigor > 0) Or ($MajorVigor > 0) Or ($MinorVigor > 0) Then ; Health Runes
				Return True
;			ElseIf ($SupDeath > 0) Or ($MinorSoulReaping > 0) Then ; Necro Runes
;				Return True
			ElseIf ($SupDeath > 0) Then ; Necro Runes
				Return True
;			ElseIf ($Survivor > 0) Or ($Sentinel > 0) Or ($WindWalker > 0) Or ($Shaman > 0) Or ($Centurion > 0) Then ; Insignias
;				Return True
			ElseIf ($WindWalker > 0) Or ($Shaman > 0) Then ; Insignias
				Return True
;			ElseIf ($MinorScythe > 0) Or ($MinorDivine > 0) Or ($MinorFastCasting > 0) Or ($MinorInspiration > 0) Or ($MinorEnergyStorage > 0) Or ($MinorSpawning > 0) Then
;				Return True
			ElseIf ($MinorScythe > 0) Or ($MinorFastCasting > 0) Or ($MinorSpawning > 0) Or ($MinorSoulReaping > 0) Then
				Return True
			Else
				Return False
			EndIf
		Case Else ; $Rarity_White
			Return False
	Endswitch
EndFunc
#EndRegion Store

#Region Pcons
Func UsePumpkinPie()
	pconsScanInventory()
	Sleep(GetPing()+200)
	If $usePumpkin Then
		If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
			If $pconsPumpkinPie_slot[0] > 0 And $pconsPumpkinPie_slot[1] > 0 Then
				If DllStructGetData(GetItemBySlot($pconsPumpkinPie_slot[0], $pconsPumpkinPie_slot[1]), "ModelID") == $ITEM_ID_PUMPKINPIE Then
					UseItemBySlot($pconsPumpkinPie_slot[0], $pconsPumpkinPie_slot[1])
				EndIf
			EndIf
		EndIf
	EndIf
	Sleep(GetPing()+500)
	If $useLightbringer Then
		If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
			If $scrollsLightbringer_slot[0] > 0 And $scrollsLightbringer_slot[1] > 0 Then
				If DllStructGetData(GetItemBySlot($scrollsLightbringer_slot[0], $scrollsLightbringer_slot[1]), "ModelID") == $ITEM_ID_Scroll_of_the_Lightbringer Then
					UseItemBySlot($scrollsLightbringer_slot[0], $scrollsLightbringer_slot[1])
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

;~ This searches the bags for the specific pcon you wish to use.
Func pconsScanInventory()
	Local $bag
	Local $size
	Local $slot
	Local $item
	Local $ModelID
	$pconsPumpkinPie_slot[0] = $pconsPumpkinPie_slot[1] = 0
	$scrollsLightbringer_slot[0] = $scrollsLightbringer_slot[1] = 0
	For $bag = 1 To 4 Step 1
		If $bag == 1 Then $size = 20
		If $bag == 2 Then $size = 5
		If $bag == 3 Then $size = 10
		If $bag == 4 Then $size = 10
		For $slot = 1 To $size Step 1
			$item = GetItemBySlot($bag, $slot)
			$ModelID = DllStructGetData($item, "ModelID")
			Switch $ModelID
				Case 0
					ContinueLoop
				Case $ITEM_ID_PUMPKINPIE
					$pconsPumpkinPie_slot[0] = $bag
					$pconsPumpkinPie_slot[1] = $slot
				Case $ITEM_ID_Scroll_of_the_Lightbringer
					$scrollsLightbringer_slot[0] = $bag
					$scrollsLightbringer_slot[1] = $slot
			EndSwitch
		Next
	Next
EndFunc   ;==>pconsScanInventory

Func UseItemBySlot($aBag, $aSlot)
	Local $item = GetItemBySlot($aBag, $aSlot)
	Return SendPacket(0x8, 0x78, DllStructGetData($item, "ID"))
EndFunc

Func arrayContains($array, $item)
	For $i = 1 To $array[0]
		If $array[$i] == $item Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>arrayContains
#EndRegion Pcons

#Region Other Functions
Func SurvivorRank($Survivor = 1)
	Switch $Survivor
		Case 1
			Return 140600
		Case 2
			Return 587500
		Case 3
			Return 1337500
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>Rank

;~ Func SetDisplayedTitle($aTitle = 0)
;~ 	If $aTitle Then
;~ 		Return SendPacket(0x8, 0x51, $aTitle)
;~ 	Else
;~ 		Return SendPacket(0x4, 0x52)
;~ 	EndIf
;~ EndFunc   ;==>SetDisplayedTitle

Func lif($cond, $ret, $ret2 = "")
	If $cond Then Return $ret
	Return $ret2
EndFunc   ;==>lif

Func UpdatePosition()
	$LAGENTARRAY = GETAGENTARRAY(219)
	For $I = 1 To $LAGENTARRAY[0]
		ConsoleWrite($LAGENTARRAY[$I] & @CRLF)
	Next
EndFunc   ;==>UpdatePosition

Func Update($text)
	GUICtrlSetData($lblStatus, $text)
	ConsoleWrite($text & @CRLF)
EndFunc   ;==>Update

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
EndFunc   ;==>CountSlots

Func FindEmptySlot($bagIndex)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GETBAG($BAGINDEX), "Slots")
		Sleep(40)
		ConsoleWrite("Checking: " & $BAGINDEX & ", " & $ASLOT & @CRLF)
		$LITEMINFO = GETITEMBYSLOT($BAGINDEX, $ASLOT)
		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			ConsoleWrite($BAGINDEX & ", " & $ASLOT & "  <-Empty! " & @CRLF)
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc

Func UseItems($modellist)
	RndSleep(GetPing()+300)
	Local $lItem
	Local $quantity
	For $I = 1 To 4
		For $j = 1 To DllStructGetData(GetBag($I), 'Slots')
			$lItem = GetItemBySlot($I, $j)
			If DllStructGetData($lItem, 'ModelID') <> 0 And _ArraySearch($modellist, DllStructGetData($lItem, 'ModelID')) <> -1 Then
				For $x = 1 To DllStructGetData($lItem, 'quantity')
					UseItem($lItem)
					RndSleep(100)
				Next
			EndIf
		Next
	Next
EndFunc

Func GoNearestNPCToCoords($x, $y)
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	MoveEx(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 0)
	RndSleep(500)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		MoveEx(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 0)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc   ;==>GoNearestNPCToCoords

Func WaitForLoad($s = "Loading map")
	Update($s)
	Do
		Sleep(200)
	Until DllStructGetData(GetAgentByID(-2), 'X') <> 0 Or DllStructGetData(GetAgentByID(-2), 'Y') <> 0
	Sleep(GetPing()+2000)
	Update("Load complete")
EndFunc   ;==>WaitForLoad

Func MoveEx($x, $y, $random = 150)
	Move($x, $y, $random)
EndFunc   ;==>MoveEx

Func MoveToEx($x, $y, $random = 150)
	MoveTo($x, $y, $random)
EndFunc   ;==>MoveToEx

Func PickupItems($fMaxDistance = 1012)
	Local $iItemsPicked = 0
	Local $aItemID, $lNearestDistance, $lDistance
	$tDeadlock = TimerInit()
	Do
		$aitem = GetNearestItemToAgent(-2)
		$lDistance = @extended
		$aItemID = DllStructGetData($aitem, 'ID')
		If $aItemID = 0 Or $lDistance > $fMaxDistance Or TimerDiff($tDeadlock) > 3000 Then ExitLoop
		PickUpItem($aitem)
		$tDeadlock2 = TimerInit()
		Do
			Sleep(100)
		Until DllStructGetData(GetAgentById($aItemID), 'ID') = 0 Or TimerDiff($tDeadlock2) > 1000
		$iItemsPicked += 1
	Until CountSlots() = 0
EndFunc   ;==>PickupItems

Func PingSleep($msExtra = 0)
	$ping = GetPing()
	Sleep($ping + $msExtra)
EndFunc   ;==>PingSleep

Func DistrictChange($AZONEID = 0, $AUSEDISTRICTS = 7)
	Local $REGION[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $LANGUAGE[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $random, $OLD_REGION, $OLD_LANGUAGE
	If $AZONEID = 0 Then $AZONEID = GetMapID()
	$OLD_REGION = GetRegion()
	$OLD_LANGUAGE = GetLanguage()
	Do
		$random = Random(0, $AUSEDISTRICTS - 1, 1)
	Until $LANGUAGE[$random] <> $OLD_LANGUAGE
	$REGION = $REGION[$random]
	$LANGUAGE = $LANGUAGE[$random]
	MoveMap($AZONEID, $REGION, 0, $LANGUAGE)
	Return WaitMapLoading($AZONEID)
EndFunc   ;==>DISTRICTCHANGE

Func InitSetCharnames()
	Local $lWinList = ProcessList("gw.exe")
	Local $CharName[1]
	Local $CharacterName
	If $lWinList[0][0] = 0 Then
		$lWinList = ProcessList("gw mc.exe")
		If $lWinList[0][0] = 0 Then
			MsgBox(16, "Initialization", "Cannot find any running Guild Wars!")
			Exit
		EndIf
	EndIf
	For $i = 1 To $lWinList[0][0]
		MemoryOpen($lWinList[$i][1])
		If $mGWProcHandle Then
			$CharacterName = ScanForCharname2()
			If IsString($CharacterName) Then
				ReDim $CharName[UBound($CharName) + 1]
				$CharName[$i] = $CharacterName
			EndIf
		EndIf
		$mGWProcHandle = 0
	Next
	GUICtrlSetData($cCharname, _ArrayToString($CharName, "|"), $CharName[1])
EndFunc   ;==>InitSetCharnames

Func ScanForCharname2()
	Local $lCharNameCode = BinaryToString('0x90909066C705')
	Local $lCurrentSearchAddress = 0x00401000
	Local $lMBI[7], $lMBIBuffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
	Local $lSearch, $lTmpMemData, $lTmpAddress, $lTmpBuffer = DllStructCreate('ptr'), $i

	While $lCurrentSearchAddress < 0x00900000
		Local $lMBI[7]
		DllCall($mKernelHandle, 'int', 'VirtualQueryEx', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lMBIBuffer), 'int', DllStructGetSize($lMBIBuffer))
		For $i = 0 To 6
			$lMBI[$i] = StringStripWS(DllStructGetData($lMBIBuffer, ($i + 1)), 3)
		Next

		If $lMBI[4] = 4096 Then
			Local $lBuffer = DllStructCreate('byte[' & $lMBI[3] & ']')
			DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lCurrentSearchAddress, 'ptr', DllStructGetPtr($lBuffer), 'int', DllStructGetSize($lBuffer), 'int', '')

			$lTmpMemData = DllStructGetData($lBuffer, 1)
			$lTmpMemData = BinaryToString($lTmpMemData)

			$lSearch = StringInStr($lTmpMemData, $lCharNameCode, 2)
			If $lSearch > 0 Then
				$lTmpAddress = $lCurrentSearchAddress + $lSearch - 1
				DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $lTmpAddress + 0x6, 'ptr', DllStructGetPtr($lTmpBuffer), 'int', DllStructGetSize($lTmpBuffer), 'int', '')
				$mCharname = DllStructGetData($lTmpBuffer, 1)
				Return GetCharname()
			Else
				Return False ;Without this the Character Listing will Hang
			EndIf

			$lCurrentSearchAddress += $lMBI[3]
		EndIf
	WEnd

	Return False
EndFunc   ;==>ScanForCharname2

;~ Description: Toggle rendering and also hide or show the gw window
Func ToggleRendering()
	If $RenderingEnabled Then
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		$RenderingEnabled = False
	Else
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
		$RenderingEnabled = True
	EndIf
EndFunc   ;==>ToggleRendering

Func _PurgeHook()
	ToggleRendering()
	Sleep(Random(2000,2500))
	ToggleRendering()
EndFunc   ;==>_PurgeHook

;~ Description: Returns the distance between two agents.
Func GetDistance2($aX1, $aY1, $aAgent2 = -2)
	If IsDllStruct($aAgent2) = 0 Then $aAgent2 = GetAgentByID($aAgent2)
	Return Sqrt(($aX1 - DllStructGetData($aAgent2, 'X')) ^ 2 + ($aY1 - DllStructGetData($aAgent2, 'Y')) ^ 2)
EndFunc   ;==>GetDistance

Func Add_Only_Hero_With_LVL_Under_20(Byref $_Array, $MaxHero = 7)
	For $i = 1 To $_Array[0][0]
        If GetHeroCount() == $MaxHero Then ExitLoop
			If Not $_Array[$i][1] Then
                SendPacket(0x8, 0x17, $_Array[$i][2])
                Sleep(GetPing() + 750)
                Local $herNumberCount = GetHeroCount()
                Local $heroLvL = GetHeroLvL_HN($herNumberCount)
                If $heroLvL = 20 Then
                        $_Array[$i][1] = True ;mean this Hero is LVL 20 ingnore it in the next check
                        SendPacket(0x8, 0x18, $_Array[$i][2])
                        Sleep(GetPing() + 500)
                        ContinueLoop
                Endif
			EndIf
	Next
EndFunc

Func GetHeroLvL_HN($aHeroNumber = 0);over Hero Number 1 to 7
        Local $lOffset[6] = [0, 0x18, 0x4C, 0x54, 0x24, 0x18 * ($aHeroNumber - 1) + 20]
        Local $lBuffer = MemoryReadPtr($mBasePointer, $lOffset)
        Return $lBuffer[1]
EndFunc

Func GetAllNonLevel20HeroIDs()
	Static Local $lHeroStruct = DllStructCreate('DWORD Id;DWORD unk;DWORD level')
	Static Local $lOffsets[4] = [0,0x18,0x2C]
   	$lOffsets[3] = 0x59C
	Local $lHeroCount = MemoryReadPtr($mBasePointer,$lOffsets)
	$lOffsets[3] = 0x594
	Local $lHeroBase = MemoryReadPtr($mBasePointer,$lOffsets)
	Local $lRet[$lHeroCount[1] + 1]

	For $i = 0 to $lHeroCount[1] - 1
		MemoryReadToStruct($lHeroBase[1] + (0x78 * $i),$lHeroStruct)
		If DllStructGetData($lHeroStruct,'level') < 20 Then
			$lRet[0] += 1
			$lRet[$lRet[0]] = DllStructGetData($lHeroStruct,'Id')
		EndIf
	Next
	ReDim $lRet[$lRet[0] + 1]
	Return $lRet
EndFunc

Func MemoryReadToStruct($aAddress, ByRef $aStructbuffer)
   Return DllCall($mKernelHandle, 'int', 'ReadProcessMemory', 'int', $mGWProcHandle, 'int', $aAddress, 'ptr', DllStructGetPtr($aStructbuffer), 'int', DllStructGetSize($aStructbuffer), 'int', '')
EndFunc   ;==>MemoryReadStruct
#EndRegion Other Functions