#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\Vivec\Pictures\bot_v.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
#################################
#                               #
#          Vaettir Bot          #
#                               #
#           by gigi             #
#                               #
#################################

The Following mods were added:
	- Autodetect what Guild Hall you are in
	- Buy rare materials finally fixed also added Amber and Jade
	- Deleted quantity or price. It buys until gold on character is <20k
	- Updated lists of items in game
	- Deleted a bunch of Counting/Displaying specific drops ** still working on the bugs in that
	- Skaldish helped fix my Array for Chest, Merchant, RareTrader. I messed up what Ralle sent me.
	- Changed naming structure for Towns, Explorables, Guild Halls
	- Added a check box for Store UNID golds.

#ce


#include "GWA2.au3"
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GuiEdit.au3>
Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

; ==== Constants ====
Global Enum $DIFFICULTY_NORMAL, $DIFFICULTY_HARD
Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH

Global Const $MAP_ID_Bjora = 482
Global Const $MAP_ID_Jaga = 546
Global Const $Town_ID_Longeye = 650
Global Const $Town_ID_Sifhalla = 643
Global Const $Town_ID_Great_Temple_of_Balthazar = 248

#Region Global Items
Global Const $RARITY_Gold = 2624
Global Const $RARITY_Purple = 2626
Global Const $RARITY_Blue = 2623
Global Const $RARITY_White = 2621

;~ All Weapon mods
Global $Weapon_Mod_Array[25] = [893, 894, 895, 896, 897, 905, 906, 907, 908, 909, 6323, 6331, 15540, 15541, 15542, 15543, 15544, 15551, 15552, 15553, 15554, 15555, 17059, 19122, 19123]

;~ General Items
Global $General_Items_Array[6] = [2989, 2991, 2992, 5899, 5900, 22751]
Global Const $ITEM_ID_Lockpicks = 22751

;~ Dyes
Global Const $ITEM_ID_Dyes = 146
Global Const $ITEM_ExtraID_BlackDye = 10
Global Const $ITEM_ExtraID_WhiteDye = 12

;~ Alcohol
Global $Alcohol_Array[19] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $OnePoint_Alcohol_Array[11] = [910, 5585, 6049, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 28435]
Global $ThreePoint_Alcohol_Array[7] = [2513, 6366, 24593, 30855, 31145, 31146, 35124]
Global $FiftyPoint_Alcohol_Array[1] = [36682]

;~ Party
Global $Spam_Party_Array[5] = [6376, 21809, 21810, 21813, 36683]

;~ Sweets
Global $Spam_Sweet_Array[6] = [21492, 21812, 22269, 22644, 22752, 28436]

;~ Tonics
Global $Tonic_Party_Array[4] = [15837, 21490, 30648, 31020]

;~ DR Removal
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]

;~ Special Drops
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]

;~ Stupid Drops that I am not using, but in here in case you want these to add these to the CanPickUp and collect in your chest
Global $Map_Piece_Array[4] = [24629, 24630, 24631, 24632]

;~ Stackable Trophies
Global $Stackable_Trophies_Array[1] = [27047]
Global Const $ITEM_ID_Glacial_Stones = 27047

;~ Materials
Global $All_Materials_Array[36] = [921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]
Global $Common_Materials_Array[11] = [921, 925, 929, 933, 934, 940, 946, 948, 953, 954, 955]
Global $Rare_Materials_Array[25] = [922, 923, 926, 927, 928, 930, 931, 932, 935, 936, 937, 938, 939, 941, 942, 943, 944, 945, 949, 950, 951, 952, 956, 6532, 6533]

;~ Tomes
Global $All_Tomes_Array[20] = [21796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 21805, 21786, 21787, 21788, 21789, 21790, 21791, 21792, 21793, 21794, 21795]
Global Const $ITEM_ID_Mesmer_Tome = 21797

;~ Arrays for the title spamming (Not inside this version of the bot, but at least the arrays are made for you)
Global $ModelsAlcohol[100] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $ModelSweetOutpost[100] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]
Global $ModelsSweetPve[100] = [22269, 22644, 28431, 28432, 28436]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813]
;910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682,    21812, ;soda
Global $Array_pscon[39]=[ 6376, 21809, 21810, 21813, 36683, 21492, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]

#Region Global MatsPic´s And ModelID´Select
Global $PIC_MATS[26][2] = [["Fur Square", 941],["Bolt of Linen", 926],["Bolt of Damask", 927],["Bolt of Silk", 928],["Glob of Ectoplasm", 930],["Steel of Ignot", 949],["Deldrimor Steel Ingot", 950],["Monstrous Claws", 923],["Monstrous Eye", 931],["Monstrous Fangs", 932],["Rubies", 937],["Sapphires", 938],["Diamonds", 935],["Onyx Gemstones", 936],["Lumps of Charcoal", 922],["Obsidian Shard", 945],["Tempered Glass Vial", 939],["Leather Squares", 942],["Elonian Leather Square", 943],["Vial of Ink", 944],["Rolls of Parchment", 951],["Rolls of Vellum", 952],["Spiritwood Planks", 956],["Amber Chunk", 6532],["Jadeite Shard", 6533]]
#EndRegion Global MatsPic´s And ModelID´Select

Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

#EndRegion Global Items

#Region Guild Hall Globals
;~ Prophecies
Global $GH_ID_Warriors_Isle = 4
Global $GH_ID_Hunters_Isle = 5
Global $GH_ID_Wizards_Isle = 6
Global $GH_ID_Burning_Isle = 52
Global $GH_ID_Frozen_Isle = 176
Global $GH_ID_Nomads_Isle = 177
Global $GH_ID_Druids_Isle = 178
Global $GH_ID_Isle_Of_The_Dead = 179
;~ Factions
Global $GH_ID_Isle_Of_Weeping_Stone = 275
Global $GH_ID_Isle_Of_Jade = 276
Global $GH_ID_Imperial_Isle = 359
Global $GH_ID_Isle_Of_Meditation = 360
;~ Nightfall
Global $GH_ID_Uncharted_Isle = 529
Global $GH_ID_Isle_Of_Wurms = 530
Global $GH_ID_Corrupted_Isle = 537
Global $GH_ID_Isle_Of_Solitude = 538

Global $WarriorsIsle = False
Global $HuntersIsle = False
Global $WizardsIsle = False
Global $BurningIsle = False
Global $FrozenIsle = False
Global $NomadsIsle = False
Global $DruidsIsle = False
Global $IsleOfTheDead = False
Global $IsleOfWeepingStone = False
Global $IsleOfJade = False
Global $ImperialIsle = False
Global $IsleOfMeditation = False
Global $UnchartedIsle = False
Global $IsleOfWurms = False
Global $CorruptedIsle = False
Global $IsleOfSolitude = False
#EndRegion Guild Hall Globals

; ================== CONFIGURATION ==================
; True or false to load the list of logged in characters or not
Global Const $doLoadLoggedChars = True
; ================ END CONFIGURATION ================

; ==== Bot global variables ====
Global $RenderingEnabled = True
Global $PickUpAll = True
Global $PickUpMapPieces = False
Global $PickUpTomes = False
Global $StoreUNIDGolds = False
Global $RunCount = 0
Global $FailCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()

Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

;~ Any pcons you want to use during a run
Global $pconsCupcake_slot[2]
Global $useCupcake = True ; set it on true and he use it

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
;~ Skill IDs
Global Const $SKILL_ID_SHROUD = 1031
Global Const $SKILL_ID_CHANNELING = 38
Global Const $SKILL_ID_ARCHANE_ECHO = 75
Global Const $SKILL_ID_WASTREL_DEMISE = 1335

#Region GUI
Global $MATID, $RAREMATSBUY = False, $mFoundChest = False, $mFoundMerch = False, $Bags = 4, $PICKUP_GOLDS = False
Global $SELECT_MAT = "Fur Square|Bolt of Linen|Bolt of Damask|Bolt of Silk|Glob of Ectoplasm|Steel of Ignot|Deldrimor Steel Ingot|Monstrous Claws|Monstrous Eye|Monstrous Fangs|Rubies|Sapphires|Diamonds|Onyx Gemstones|Lumps of Charcoal|Obsidian Shard|Tempered Glass Vial|Leather Squares|Elonian Leather Square|Vial of Ink|Rolls of Parchment|Rolls of Vellum|Spiritwood Planks|Amber Chunk|Jadeite Shard"
Global $SELECT_TOWN = "Longeye's Ledge|Sifhalla"
Global $LONGEYE = False
Global $SIFHALLA = False

Global Const $mainGui = GUICreate("Vaettir Bot", 375, 275)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Global $Input
If $doLoadLoggedChars Then
	$Input = GUICtrlCreateCombo("", 8, 8, 129, 21)
		GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Input = GUICtrlCreateInput("character name", 8, 8, 129, 21)
EndIf
Global $LOCATION = GUICtrlCreateCombo("Location", 8, 35, 125, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlCreateLabel("Runs:", 8, 65, 70, 17)
Global Const $RunsLabel = GUICtrlCreateLabel($RunCount, 80, 65, 50, 17)
GUICtrlCreateLabel("Fails:", 8, 80, 70, 17)
Global Const $FailsLabel = GUICtrlCreateLabel($FailCount, 80, 80, 50, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 98, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)
GUICtrlCreateLabel("Select Rare Mats", 8, 155, 100, 17)
Global $SELECTMAT = GUICtrlCreateCombo("Rare Mats", 8, 175, 125,  25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))

Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 225, 240, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)
Global Const $Leeching = GUICtrlCreateCheckbox("Leech Bot Present", 8, 253, 110, 17)
Global Const $MapPieces = GUICtrlCreateCheckbox("Map Pieces", 8, 228, 75, 17)
Global Const $Tomes = GUICtrlCreateCheckbox("Mesmer Tomes", 8, 203, 90, 17)
Global Const $StoreGolds = GUICtrlCreateCheckbox("Store Golds", 240, 253, 90, 17)
GUICtrlSetData($LOCATION, $SELECT_TOWN)
GUICtrlSetData($SELECTMAT, $SELECT_MAT)
GUICtrlSetOnEvent($SELECTMAT, "START_STOP")

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
			;If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
			If Initialize(ProcessExists("gw.exe"), True) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			;If Initialize($CharName, True, True, False) = False Then
			If Initialize($CharName, True) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Leeching, $GUI_ENABLE)
		GUICtrlSetState($MapPieces, $GUI_ENABLE)
		GUICtrlSetState($Tomes, $GUI_ENABLE)
		GUICtrlSetState($StoreGolds, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "VBot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Func START_STOP()
	Switch (@GUI_CtrlId)
		Case $SELECTMAT
			MatSwitcher()
	EndSwitch
EndFunc   ;==>START_STOP

Out("Waiting for input")

While Not $BotRunning
	Sleep(100)
WEnd

; load template if we're in town
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($SkillBarTemplate)

While True
	If GUICtrlRead($LOCATION, "") == "Longeye's Ledge" Then
		$LONGEYE = True
	ElseIf GUICtrlRead($LOCATION, "") == "Sifhalla" Then
		$SIFHALLA = True
	EndIf
	If $SIFHALLA Then MapS()
	If $LONGEYE Then MapL()
	If $SIFHALLA Then RunThereSifhalla()
	If $LONGEYE Then RunThereLongeyes()
	If (GetIsDead(-2)==True) Then ContinueLoop

	If GUICtrlRead($Leeching) = 1 Then
		$PickUpAll = False
	Else
		$PickUpAll = False
	EndIf

	If GUICtrlRead($MapPieces) = 1 Then
		$PickUpMapPieces = True
	Else
		$PickUpMapPieces = False
	EndIf

	If GUICtrlRead($Tomes) = 1 Then
		$PickUpTomes = True
	Else
		$PickUpTomes = False
	EndIf

	If GUICtrlRead($StoreGolds) = 1 Then
		$StoreUNIDGolds = True
	Else
		$StoreUNIDGolds = False
	EndIf

	While (CountSlots() > 4)
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		CombatLoop()
	WEnd

	If (CountSlots() < 5) Then
		If Not $BotRunning Then
			Out("Bot Paused")
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetData($Button, "Start")
			While Not $BotRunning
				Sleep(100)
			WEnd
		EndIf
		Inventory()
	EndIf
WEnd

Func MapL()
;~ Checks if you are already in Longeye's Ledge, if not then you travel to Longeye's Ledge
	If GetMapID() <> $Town_ID_Longeye Then
		Out("Travelling to longeye")
		RndTravel($Town_ID_Longeye)
	EndIf
;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	Move(-26472, 16217)
	WaitMapLoading($MAP_ID_Bjora)

;~ Scans your bags for Cupcakes and uses one to make the run faster.
	pconsScanInventory()
	Sleep(GetPing()+500)
	UseCupcake()
	Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
	SetDisplayedTitle(0x29)
	Sleep(GetPing()+500)
EndFunc

Func MapS()
;~ Checks if you are already in Sifhalla, if not then you travel to Sifhalla
	If (GetMapID() <> $Town_ID_Sifhalla) Then
		Out("Travelling to Sifhalla")
		RndTravel($Town_ID_Sifhalla)
	EndIf
;~ Hardmode
	SwitchMode(1)

	Out("Exiting Outpost")
	MoveTo(16197, 22825)
	Move(16800, 22867)
	WaitMapLoading($MAP_ID_Jaga)

;~ Scans your bags for Cupcakes and uses one to make the run faster.
	pconsScanInventory()
	Sleep(GetPing()+500)
	UseCupcake()
	Sleep(GetPing()+500)
;~ Displays your Norn Title for the Health boost.
	SetDisplayedTitle(0x29)
	Sleep(GetPing()+500)
EndFunc

;~ Description: zones to longeye if we're not there, and travel to Jaga Moraine
Func RunThereLongeyes()
	Out("Running to farm spot")
	DIM $array_Longeyes[31][3] = [ _
										[1, 15003.8, -16598.1], _
										[1, 15003.8, -16598.1], _
										[1, 12699.5, -14589.8], _
										[1, 11628,   -13867.9], _
										[1, 10891.5, -12989.5], _
										[1, 10517.5, -11229.5], _
										[1, 10209.1, -9973.1], _
										[1, 9296.5,  -8811.5], _
										[1, 7815.6,  -7967.1], _
										[1, 6266.7,  -6328.5], _
										[1, 4940,    -4655.4], _
										[1, 3867.8,  -2397.6], _
										[1, 2279.6,  -1331.9], _
										[1, 7.2,     -1072.6], _
										[1, 7.2,     -1072.6], _
										[1, -1752.7, -1209], _
										[1, -3596.9, -1671.8], _
										[1, -5386.6, -1526.4], _
										[1, -6904.2, -283.2], _
										[1, -7711.6, 364.9], _
										[1, -9537.8, 1265.4], _
										[1, -11141.2,857.4], _
										[1, -12730.7,371.5], _
										[1, -13379,  40.5], _
										[1, -14925.7,1099.6], _
										[1, -16183.3,2753], _
										[1, -17803.8,4439.4], _
										[1, -18852.2,5290.9], _
										[1, -19250,  5431], _
										[1, -19968, 5564], _
										[2, -20076,  5580]]
	Out("Running to Jaga")
	For $i = 0 To (UBound($array_Longeyes) -1)
		If ($array_Longeyes[$i][0]==1)Then
			If Not MoveRunning($array_Longeyes[$i][1], $array_Longeyes[$i][2])Then ExitLoop
		EndIf
		If ($array_Longeyes[$i][0]==2)Then
			Move($array_Longeyes[$i][1], $array_Longeyes[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
		EndIf
	Next
EndFunc

Func RunThereSifhalla()
	Out("Running to farm spot")
	DIM $array_Sifhalla[31][3] = [ _
								[1, -11059,	-23401], _
								[1, -8524,	-21590], _
								[1, -8870,	-21818], _
								[1, -6979,	-21705], _
								[1, -4144,	-25480], _
								[1, -456,	-25575], _
								[1, 2362,	-23315], _
								[1, 1877,	-21862], _
								[1, 914,	-21159], _
								[1, 1303,	-18593], _
								[1, 2092,	-16943], _
								[1, 2909,	-15487], _
								[1, 2757,	-13745], _
								[1, 1280,	-11243], _
								[1, -217,	-10112], _
								[1, -1201,	-8855], _
								[1, -2022,	-8535], _
								[1, -2383,	-7170], _
								[1, -332,	-5391], _
								[1, 1726,	-5463], _
								[1, 3465,	-5999], _
								[1, 4130,	-8139], _
								[1, 5170,	-9609], _
								[1, 7922,	-11222], _
								[1, 9600,	-11614], _
								[1, 11818,	-13547], _
								[1, 12911,	-15538], _
								[1, 14199,	-18786], _
								[1, 15201,	-20293], _
								[2, 15865, -20531], _
								[3, -20076,  5580]]

	For $i = 0 To (UBound($array_Sifhalla) -1)
		If ($array_Sifhalla[$i][0]==1)Then
			If Not MoveRunning($array_Sifhalla[$i][1], $array_Sifhalla[$i][2])Then ExitLoop
		EndIf
		If ($array_Sifhalla[$i][0]==2)Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_BJORA)
		EndIf
		If ($array_Sifhalla[$i][0]==3)Then
			Move($array_Sifhalla[$i][1], $array_Sifhalla[$i][2], 30)
			WaitMapLoading($MAP_ID_JAGA)
		EndIf
	Next
EndFunc

; Description: This is pretty much all, take bounty, do left, do right, kill, rezone
Func CombatLoop()
;~ 	If Not $RenderingEnabled Then ClearMemory()

	If GetNornTitle() < 160000 Then
		Out("Taking Blessing")
		GoNearestNPCToCoords(13318, -20826)
		Dialog(132)
	EndIf
	SendChat("It is killing time")
	DisplayCounts()

	Sleep(GetPing()+2000)

	Out("Moving to aggro left")
	MoveTo(13501, -20925)
	MoveTo(13172, -22137)
	TargetNearestEnemy()
	MoveAggroing(12496, -22600, 150)
	MoveAggroing(11375, -22761, 150)
	MoveAggroing(10925, -23466, 150)
	MoveAggroing(10917, -24311, 150)
	MoveAggroing(9910, -24599, 150)
	MoveAggroing(8995, -23177, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8307, -23187, 150)
	MoveAggroing(8213, -22829, 150)
	MoveAggroing(8740, -22475, 150)
	MoveAggroing(8880, -21384, 150)
	MoveAggroing(8684, -20833, 150)
	MoveAggroing(8982, -20576, 150)

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
	MoveAggroing(10196, -20124, 150)
	MoveAggroing(9976, -18338, 150)
	MoveAggroing(11316, -18056, 150)
	MoveAggroing(10392, -17512, 150)
	MoveAggroing(10114, -16948, 150)
	MoveAggroing(10729, -16273, 150)
	MoveAggroing(10810, -15058, 150)
	MoveAggroing(11120, -15105, 150)
	MoveAggroing(11670, -15457, 150)
	MoveAggroing(12604, -15320, 150)
	TargetNearestEnemy()
	MoveAggroing(12476, -16157)

	;Out("Waiting for right ball")
	WaitFor(15*1000)

	If GetDistance()<1000 Then
		UseSkillEx($hos, -1)
	Else
		UseSkillEx($hos, -2)
	EndIf

	WaitFor(5000)

	;Out("Blocking enemies in spot")
	MoveAggroing(12920, -17032, 30)
	MoveAggroing(12847, -17136, 30)
	MoveAggroing(12720, -17222, 30)
	WaitFor(300)
	MoveAggroing(12617, -17273, 30)
	WaitFor(300)
	MoveAggroing(12518, -17305, 20)
	WaitFor(300)
	MoveAggroing(12445, -17327, 10)

	;Out("Killing")
	Kill()

	WaitFor(1200)

	;Out("Looting")
	PickUpLoot()

	If GetIsDead(-2) Then
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	;Out("Zoning")
	MoveAggroing(12289, -17700)
	MoveAggroing(15318, -20351)

	While GetIsDead(-2)
		Out("Waiting for res")
		Sleep(1000)
	WEnd

	Move(15865, -20531)
	WaitMapLoading($MAP_ID_BJORA)

	MoveTo(-19968, 5564)
	Move(-20076,  5580, 30)

	WaitMapLoading($MAP_ID_JAGA)

;~ 	ClearMemory()
;~ 	_PurgeHook()
   If Mod($RunCount, 11) = 10 Then
	  _PurgeHook()
   EndIf
EndFunc

Func _PurgeHook()
	ToggleRendering()
	Sleep(Random(2000,2500))
	ToggleRendering()
EndFunc   ;==>_PurgeHook

#CS
Description: use whatever skills you need to keep yourself alive.
Take agent array as param to more effectively react to the environment (mobs)
#CE
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
		EndIf
	Next
EndFunc   ;==>PickUpLoot

; Checks if should pick up the given item. Returns True or False
Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If ($lRarity == $RARITY_Gold And $PickUpAll == True) Then ; gold items
		Return True
	ElseIf (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	ElseIf ($lModelID == $ITEM_ID_Mesmer_Tome) And ($PickUpTomes = True) Then
		Return True	; Mesmer Tomes
	ElseIf ($lModelID == $ITEM_ID_Dyes) Then	; if dye
		If (($aExtraID == $ITEM_ExtraID_BlackDye) Or ($aExtraID == $ITEM_ExtraID_WhiteDye))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf($lModelID == $ITEM_ID_Lockpicks)Then
		Return True ; Lockpicks
	ElseIf($lModelID == $ITEM_ID_Glacial_Stones)Then
		Return True ; glacial stones
	ElseIf CheckArrayPscon($lModelID)Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf CheckArrayMapPieces($lModelID) And ($PickUpMapPieces = True) Then ; ==== Map Pieces ====
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func CheckArea($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA

Func Disconnected()
	Out("Disconnected!")
	Out("Attempting to reconnect.")
	ControlSend(GetWindowHandle(), "", "", "{Enter}")
	Local $LCHECK = False
	Local $lDeadlock = TimerInit()
	Do
		Sleep(200)
		$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
	Until $LCHECK Or TimerDiff($lDeadlock) > 60000
	If $LCHECK = False Then
		Out("Failed to Reconnect!")
		Out("Retrying.")
		ControlSend(GetWindowHandle(), "", "", "{Enter}")
		$lDeadlock = TimerInit()
		Do
			Sleep(200)
			$LCHECK = GetMapLoading() <> 2 And GetAgentExists(-2)
		Until $LCHECK Or TimerDiff($lDeadlock) > 60000
		If $LCHECK = False Then
			Out("Could not reconnect!")
			Out("Exiting.")
			Exit 1
		EndIf
	EndIf
	Out("Reconnected!")
	Sleep(8000)
EndFunc   ;==>DISCONNECTED

Func MatSwitcher()
	$RAREMATSBUY = False
	Out("$RareMatsBuy" & $RAREMATSBUY)
	For $i = 0 To UBound($PIC_MATS) - 1
		If (GUICtrlRead($SELECTMAT, "") == $PIC_MATS[$i][0]) Then
			$MATID = $PIC_MATS[$i][1]
			$RAREMATSBUY = True
			Out("$RareMatsBuy" & $RAREMATSBUY)
			Out("You Select - " & $PIC_MATS[$i][0])
			Out("Mat Model ID == " & "" & $MATID)
		EndIf
	Next
EndFunc   ;==>MATSWITCHER

Func CheckGold()
	Local $GCHARACTER = GetGoldCharacter()
	Local $GSTORAGE = GetGoldStorage()
	Local $GDIFFERENCE = ($GSTORAGE - $GCHARACTER)
	If $GCHARACTER <= 1000 Then
		Switch $GSTORAGE
			Case 100000 To 1000000
				WithdrawGold(100000 - $GCHARACTER)
				Sleep(500 + 3 * GetPing())
			Case 1 To 99999
				WithdrawGold($GDIFFERENCE)
				Sleep(500 + 3 * GetPing())
			Case 0
				Out("Out of cash, beginning farm")
				Return False
		EndSwitch
	EndIf
	Return True
EndFunc   ;==>CHECKGOLD

#Region Inventory
#CS

#CE
Func Inventory()
	Out("Travel to Guild Hall")
	TravelGH()
	WaitMapLoading()

	Out("Checking Guild Hall")
	CheckGuildHall()

	Chest()

	If GetGoldCharacter() > 90000 Then
		Out("Depositing Gold")
		DepositGold()
	EndIf

	Out("Storing Stuff")
	StoreItems()
	StoreMaterials()
	StoreMods()

	If $StoreUNIDGolds Then
		StoreUNIDGolds()
	EndIf

	StoreWeapons()

	Merchant()

	Out("Identifying")
	Ident(1)
	Ident(2)
	Ident(3)
	Ident(4)

	Out("Selling")
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

	If GetGoldCharacter() > 90000 Then
		Out("Depositing Gold")
		DepositGold()
	EndIf

	Sleep(GetPing()+1000)

	If GetGoldCharacter() > 90000 Then
		Out("Buying Rare Materials")
		RareMaterialTrader()
	EndIf

	LeaveGH()
	WaitMapLoading()
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

Func CanSell($aItem)
	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $LRARITY = GetRarity($aitem)
	Local $Requirement = GetItemReq($aItem)
	If $LRARITY == $RARITY_Gold Then
		Return True
	EndIf
	If $LRARITY == $RARITY_Purple Then
		Return True
	EndIf
;~ Leaving Blues and Whites as false for now. Going to make it salvage them at some point in the future. It does not currently pick up whites or blues
	If $LRARITY == $RARITY_Blue Then
		Return False
	EndIf
	If $LRARITY == $RARITY_White Then
		Return False
	EndIf
	If $LMODELID == $ITEM_ID_Dyes Then
		Switch DllStructGetData($aitem, "ExtraID")
			Case $ITEM_ExtraID_BlackDye, $ITEM_ExtraID_WhiteDye
				Return False
			Case Else
				Return True
		EndSwitch
	EndIf
	If CheckArrayTomes($lModelID)					Then Return False
	If CheckArrayMaterials($lModelID)				Then Return False
	; All weapon mods
	If CheckArrayWeaponMods($lModelID)				Then Return False
	; ==== General ====
	If CheckArrayGeneralItems($lModelID)			Then Return False ; Lockpicks, Kits
	If $lModelID == $ITEM_ID_Glacial_Stones 		Then Return False
	If CheckArrayPscon($lModelID)					Then Return False
	; ==== Stupid Drops =
	If CheckArrayMapPieces($lModelID)				Then Return False
	Return True
EndFunc   ;==>CanSell

#Region Arrays
Func CheckArrayPscon($lModelID)
	For $p = 0 To (UBound($Array_pscon) -1)
		If ($lModelID == $Array_pscon[$p]) Then Return True
	Next
EndFunc

Func CheckArrayGeneralItems($lModelID)
	For $p = 0 To (UBound($General_Items_Array) -1)
		If ($lModelID == $General_Items_Array[$p]) Then Return True
	Next
EndFunc

Func CheckArrayWeaponMods($lModelID)
	For $p = 0 To (UBound($Weapon_Mod_Array) -1)
		If ($lModelID == $Weapon_Mod_Array[$p]) Then Return True
	Next
EndFunc

Func CheckArrayTomes($lModelID)
	For $p = 0 To (UBound($All_Tomes_Array) -1)
		If ($lModelID == $All_Tomes_Array[$p]) Then Return True
	Next
EndFunc

Func CheckArrayMaterials($lModelID)
	For $p = 0 To (UBound($All_Materials_Array) -1)
		If ($lModelID == $All_Materials_Array[$p]) Then Return True
	Next
EndFunc

Func CheckArrayMapPieces($lModelID)
	For $p = 0 To (UBound($Map_Piece_Array) -1)
		If ($lModelID == $Map_Piece_Array[$p]) Then Return True
	Next
EndFunc
#EndRegion Arrays

#Region Checking Guild Hall
;~ Checks to see which Guild Hall you are in and the spawn point
Func CheckGuildHall()
	If GetMapID() == $GH_ID_Warriors_Isle Then
		$WarriorsIsle = True
		Out("Warrior's Isle")
	EndIf
	If GetMapID() == $GH_ID_Hunters_Isle Then
		$HuntersIsle = True
		Out("Hunter's Isle")
	EndIf
	If GetMapID() == $GH_ID_Wizards_Isle Then
		$WizardsIsle = True
		Out("Wizard's Isle")
	EndIf
	If GetMapID() == $GH_ID_Burning_Isle Then
		$BurningIsle = True
		Out("Burning Isle")
	EndIf
	If GetMapID() == $GH_ID_Frozen_Isle Then
		$FrozenIsle = True
		Out("Frozen Isle")
	EndIf
	If GetMapID() == $GH_ID_Nomads_Isle Then
		$NomadsIsle = True
		Out("Nomad's Isle")
	EndIf
	If GetMapID() == $GH_ID_Druids_Isle Then
		$DruidsIsle = True
		Out("Druid's Isle")
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_The_Dead Then
		$IsleOfTheDead = True
		Out("Isle of the Dead")
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_Weeping_Stone Then
		$IsleOfWeepingStone = True
		Out("Isle of Weeping Stone")
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_Jade Then
		$IsleOfJade = True
		Out("Isle of Jade")
	EndIf
	If GetMapID() == $GH_ID_Imperial_Isle Then
		$ImperialIsle = True
		Out("Imperial Isle")
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_Meditation Then
		$IsleOfMeditation = True
		Out("Isle of Meditation")
	EndIf
	If GetMapID() == $GH_ID_Uncharted_Isle Then
		$UnchartedIsle = True
		Out("Uncharted Isle")
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_Wurms Then
		$IsleOfWurms = True
		Out("Isle of Wurms")
		If $IsleOfWurms = True Then
			CheckIsleOfWurms()
		EndIf
	EndIf
	If GetMapID() == $GH_ID_Corrupted_Isle Then
		$CorruptedIsle = True
		Out("Corrupted Isle")
		If $CorruptedIsle = True Then
			CheckCorruptedIsle()
		EndIf
	EndIf
	If GetMapID() == $GH_ID_Isle_Of_Solitude Then
		$IsleOfSolitude = True
		Out("Isle of Solitude")
	EndIf
EndFunc ;~ Check Guild halls

;~ If there is a missing Guild Hall from the below listing, it is because there is only 1 spawn point in that Guild Hall
Func CheckIsleOfWurms()
	If CheckArea(8682, 2265) Then
		OUT("Start Point 1")
		If Waypoint1() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CheckArea(6697, 3631) Then
		OUT("Start Point 2")
		If Waypoint2() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CheckArea(6716, 2929) Then
		OUT("Start Point 3")
		If Waypoint3() Then
			Return True
		Else
			Return False
		EndIf
	Else
		OUT("Where the fuck am I?")
		Return False
	EndIf
EndFunc

Func CheckCorruptedIsle()
	If CheckArea(-4830, 5985) Then
		OUT("Start Point 1")
		If Waypoint4() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CheckArea(-3778, 6214) Then
		OUT("Start Point 2")
		If Waypoint5() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CheckArea(-5209, 4468) Then
		OUT("Start Point 3")
		If Waypoint6() Then
			Return True
		Else
			Return False
		EndIf
	Else
		OUT("Where the fuck am I?")
		Return False
	EndIf
EndFunc

Func Waypoint1()
	MoveTo(8263, 2971)
EndFunc

Func Waypoint2()
	MoveTo(7086, 2983)
	MoveTo(8263, 2971)
EndFunc

Func Waypoint3()
	MoveTo(8263, 2971)
EndFunc

Func Waypoint4()
	MoveTo(-4830, 5985)
EndFunc

Func Waypoint5()
	MoveTo(-3778, 6214)
EndFunc

Func Waypoint6()
	MoveTo(-4352, 5232)
EndFunc

Func Chest()
	Dim $Waypoints_by_XunlaiChest[16][3] = [ _
			[$BurningIsle, -5285, -2545], _
			[$DruidsIsle, -1792, 5444], _
			[$FrozenIsle, -115, 3775], _
			[$HuntersIsle, 4855, 7527], _
			[$IsleOfTheDead, -4562, -1525], _
			[$NomadsIsle, 4630, 4580], _
			[$WarriorsIsle, 4224, 7006], _
			[$WizardsIsle, 4858, 9446], _
			[$ImperialIsle, 2184, 13125], _
			[$IsleOfJade, 8614, 2660], _
			[$IsleOfMeditation, -726, 7630], _
			[$IsleOfWeepingStone, -1573, 7303], _
			[$CorruptedIsle, -4868, 5998], _
			[$IsleOfSolitude, 4478, 3055], _
			[$IsleOfWurms, 8586, 3603], _
			[$UnchartedIsle, 4522, -4451]]
	For $i = 0 To (UBound($Waypoints_by_XunlaiChest) - 1)
		If ($Waypoints_by_XunlaiChest[$i][0] == True) Then
			Do
				GenericRandomPath($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2], Random(60, 80, 2))
			Until CheckArea($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2])
		EndIf
	Next
	Local $aChestName = "Xunlai Chest"
	Local $lChest = GetAgentByName($aChestName)
	If IsDllStruct($lChest)Then
		Out("Going to " & $aChestName)
		GoToNPC($lChest)
		RndSleep(Random(3000, 4200))
	EndIf
EndFunc ;~ Xunlai Chest

Func Merchant()
	Dim $Waypoints_by_Merchant[29][3] = [ _
			[$BurningIsle, -4439, -2088], _
			[$BurningIsle, -4772, -362], _
			[$BurningIsle, -3637, 1088], _
			[$BurningIsle, -2506, 988], _
			[$DruidsIsle, -2037, 2964], _
			[$FrozenIsle, 99, 2660], _
			[$FrozenIsle, 71, 834], _
			[$FrozenIsle, -299, 79], _
			[$HuntersIsle, 5156, 7789], _
			[$HuntersIsle, 4416, 5656], _
			[$IsleOfTheDead, -4066, -1203], _
			[$NomadsIsle, 5129, 4748], _
			[$WarriorsIsle, 4159, 8540], _
			[$WarriorsIsle, 5575, 9054], _
			[$WizardsIsle, 4288, 8263], _
			[$WizardsIsle, 3583, 9040], _
			[$ImperialIsle, 1415, 12448], _
			[$ImperialIsle, 1746, 11516], _
			[$IsleOfJade, 8825, 3384], _
			[$IsleOfJade, 10142, 3116], _
			[$IsleOfMeditation, -331, 8084], _
			[$IsleOfMeditation, -1745, 8681], _
			[$IsleOfMeditation, -2197, 8076], _
			[$IsleOfWeepingStone, -3095, 8535], _
			[$IsleOfWeepingStone, -3988, 7588], _
			[$CorruptedIsle, -4670, 5630], _
			[$IsleOfSolitude, 2970, 1532], _
			[$IsleOfWurms, 8284, 3578], _
			[$UnchartedIsle, 1503, -2830]]
	For $i = 0 To (UBound($Waypoints_by_Merchant) - 1)
		If ($Waypoints_by_Merchant[$i][0] == True) Then
			Do
				GenericRandomPath($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2], Random(60, 80, 2))
			Until CheckArea($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2])
		EndIf
	Next
	Local $aMerchName = "Merchant"
	Local $lMerch = GetAgentByName($aMerchName)
	If IsDllStruct($lMerch)Then
		Out("Going to " & $aMerchName)
		GoToNPC($lMerch)
		RndSleep(Random(3000, 4200))
	EndIf
EndFunc ;~ Merchant

Func RareMaterialTrader()
	Dim $Waypoints_by_RareMatTrader[36][3] = [ _
			[$BurningIsle, -3793, 1069], _
			[$BurningIsle, -2798, -74], _
			[$DruidsIsle, -989, 4493], _
			[$FrozenIsle, 71, 834], _
			[$FrozenIsle, 99, 2660], _
			[$FrozenIsle, -385, 3254], _
			[$FrozenIsle, -983, 3195], _
			[$HuntersIsle, 3267, 6557], _
			[$IsleOfTheDead, -3415, -1658], _
			[$NomadsIsle, 1930, 4129], _
			[$NomadsIsle, 462, 4094], _
			[$WarriorsIsle, 4108, 8404], _
			[$WarriorsIsle, 3403, 6583], _
			[$WarriorsIsle, 3415, 5617], _
			[$WizardsIsle, 3610, 9619], _
			[$ImperialIsle, 759, 11465], _
			[$IsleOfJade, 8919, 3459], _
			[$IsleOfJade, 6789, 2781], _
			[$IsleOfJade, 6566, 2248], _
			[$IsleOfMeditation, -2197, 8076], _
			[$IsleOfMeditation, -1745, 8681], _
			[$IsleOfMeditation, -331, 8084], _
			[$IsleOfMeditation, 422, 8769], _
			[$IsleOfMeditation, 549, 9531], _
			[$IsleOfWeepingStone, -3988, 7588], _
			[$IsleOfWeepingStone, -3095, 8535], _
			[$IsleOfWeepingStone, -2431, 7946], _
			[$IsleOfWeepingStone, -1618, 8797], _
			[$CorruptedIsle, -4424, 5645], _
			[$CorruptedIsle, -4443, 4679], _
			[$IsleOfSolitude, 3172, 3728], _
			[$IsleOfSolitude, 3221, 4789], _
			[$IsleOfSolitude, 3745, 4542], _
			[$IsleOfWurms, 8353, 2995], _
			[$IsleOfWurms, 6708, 3093], _
			[$UnchartedIsle, 2530, -2403]]
	For $i = 0 To (UBound($Waypoints_by_RareMatTrader) - 1)
		If ($Waypoints_by_RareMatTrader[$i][0] == True) Then
			Do
				GenericRandomPath($Waypoints_by_RareMatTrader[$i][1], $Waypoints_by_RareMatTrader[$i][2], Random(60, 80, 2))
			Until CheckArea($Waypoints_by_RareMatTrader[$i][1], $Waypoints_by_RareMatTrader[$i][2])
		EndIf
	Next
	Local $lRareTrader = "Rare Material Trader"
	Local $lRare = GetAgentByName($lRareTrader)
	If IsDllStruct($lRare)Then
		Out("Going to " & $lRareTrader)
		GoToNPC($lRare)
		RndSleep(Random(3000, 4200))
	EndIf
	;~This section does the buying
	TraderRequest($MATID)
	Sleep(500 + 3 * GetPing())
	While GetGoldCharacter() > 20*1000
		TraderRequest($MATID)
		Sleep(500 + 3 * GetPing())
		TraderBuy()
	WEnd
EndFunc   ;~ Rare Material trader
#EndRegion Checking Guild Hall

#CS
	If GetHoneyCombCount() > 49 Then

#CE

#Region Display/Counting Things
#CS
Each section can be commented out entirely or each individual line. Basically put here for reference and use.

I put the Display > 0 so that it won't list everything. Better for each event I think.

CountSlots and CountSlotsChest are used by the Storage and the bot to know how much it can put in there
and when to start an inventory cycle.

GetxxxxxxCount() are to count what is in your Inventory at that time. Say if you want to track each of these items
either by the Message display or a section of your GUI.

Does Not track how many you put in the storage chest!!!
#CE
Func DisplayCounts()
;	Standard Vaettir Drops excluding Map Pieces
	Local $CurrentGold = GetGoldCharacter()
	Local $GlacialStones = GetGlacialStoneCount()
	Local $MesmerTomes = GetMesmerTomeCount()
	Local $Lockpicks = GetLockpickCount()
	Local $BlackDye = GetBlackDyeCount()
	Local $WhiteDye = GetWhiteDyeCount()
;	Event Items
	Local $AgedDwarvenAle = GetAgedDwarvenAleCount()
	Local $AgedHuntersAle = GetAgedHuntersAleCount()
	Local $BattleIslandIcedTea = GetIcedTeaCount()
	Local $BirthdayCupcake = GetBirthdayCupcakeCount()
	Local $CandyCaneShards = GetCandyCaneShards()
	Local $GoldenEgg = GetGoldenEggCount()
	Local $Grog = GetBottleOfGrogCount()
	Local $HoneyCombs = GetHoneyCombCount()
	Local $KrytanBrandy = GetKrytanBrandyCount()
	Local $PartyBeacon = GetPartyBeaconCount()
	Local $PumpkinPies = GetPumpkinPieCount()
	Local $SpikedEggnog = GetSpikedEggnogCount()
	Local $TrickOrTreats = GetTrickOrTreatCount()
	Local $VictoryToken = GetVictoryTokenCount()
	Local $WayfarerMark = GetWayfarerMarkCount()
;	RareMaterials
	Local $EctoCount = GetEctoCount()
	Local $ObShardCount = GetObsidianShardCount()
	Local $FurCount = GetFurCount()
	Local $LinenCount = GetLinenCount()
	Local $DamaskCount = GetDamaskCount()
	Local $SilkCount = GetSilkCount()
	Local $SteelCount = GetSteelCount()
	Local $DSteelCount = GetDeldSteelCount()
	Local $MonClawCount = GetMonClawCount()
	Local $MonEyeCount = GetMonEyeCount()
	Local $MonFangCount = GetMonFangCount()
	Local $RubyCount = GetRubyCount()
	Local $SapphireCount = GetSapphireCount()
	Local $DiamondCount = GetDiamondCount()
	Local $OnyxCount = GetOnyxCount()
	Local $CharcoalCount = GetCharcoalCount()
	Local $GlassVialCount = GetGlassVialCount()
	Local $LeatherCount = GetLeatherCount()
	Local $ElonLeatherCount = GetElonLeatherCount()
	Local $VialInkCount = GetVialInkCount()
	Local $ParchmentCount = GetParchmentCount()
	Local $VellumCount = GetVellumCount()
	Local $SpiritwoodCount = GetSpiritwoodCount()
	Local $AmberCount = GetAmberCount()
	Local $JadeCount = GetJadeCount()
;	Standard Vaettir Drops excluding Map Pieces
	If GetGoldCharacter() > 0 Then
		Out("Current Gold:" & $CurrentGold)
	ElseIf GetGlacialStoneCount() > 0 Then
		Out("Glacial Conut:" & $GlacialStones)
	ElseIf GetMesmerTomeCount() > 0 Then
		Out("Mesmer Tomes:" & $MesmerTomes)
	ElseIf GetLockpickCount() > 0 Then
		Out ("Lockpicks:" & $Lockpicks)
	ElseIf GetBlackDyeCount() > 0 Then
		Out ("Black Dyes:" & $BlackDye)
	ElseIf GetWhiteDyeCount() > 0 Then
		Out ("White Dyes:" & $WhiteDye)
	EndIf
;	Rare Materials
	If GetFurCount() > 0 Then
		Out ("Fur Squares:" & $FurCount)
	ElseIf GetLinenCount() > 0 Then
		Out ("Linen:" & $LinenCount)
	ElseIf GetDamaskCount() > 0 Then
		Out ("Damask:" & $DamaskCount)
	ElseIf GetSilkCount() > 0 Then
		Out ("Silk:" & $SilkCount)
	ElseIf GetEctoCount() > 0 Then
		Out("Ecto Count:" & $EctoCount)
	ElseIf GetSteelCount() > 0 Then
		Out ("Steel:" & $SteelCount)
	ElseIf GetDeldSteelCount() > 0 Then
		Out ("Deldrimor Steel:" & $DSteelCount)
	ElseIf GetMonClawCount() > 0 Then
		Out ("Monstrous Claw:" & $MonClawCount)
	ElseIf GetMonEyeCount() > 0 Then
		Out ("Monstrous Eye:" & $MonEyeCount)
	ElseIf GetMonFangCount() > 0 Then
		Out ("Monstrous Fang:" & $MonFangCount)
	ElseIf GetRubyCount() > 0 Then
		Out ("Ruby:" & $RubyCount)
	ElseIf GetSapphireCount() > 0 Then
		Out ("Sapphire:" & $SapphireCount)
	ElseIf GetDiamondCount() > 0 Then
		Out ("Diamond:" & $DiamondCount)
	ElseIf GetOnyxCount() > 0 Then
		Out ("Onyx:" & $OnyxCount)
	ElseIf GetCharcoalCount() > 0 Then
		Out ("Charcoal:" & $CharcoalCount)
	ElseIf GetObsidianShardCount() > 0 Then
		Out("Obby Count:" & $ObShardCount)
	ElseIf GetGlassVialCount() > 0 Then
		Out ("Glass Vial:" & $GlassVialCount)
	ElseIf GetLeatherCount() > 0 Then
		Out ("Leather Square:" & $LeatherCount)
	ElseIf GetElonLeatherCount() > 0 Then
		Out ("Elonian Leather:" & $ElonLeatherCount)
	ElseIf GetVialInkCount() > 0 Then
		Out ("Vials of Ink:" & $VialInkCount)
	ElseIf GetParchmentCount() > 0 Then
		Out ("Parchment:" & $ParchmentCount)
	ElseIf GetVellumCount() > 0 Then
		Out ("Vellum:" & $VellumCount)
	ElseIf GetSpiritwoodCount() > 0 Then
		Out ("Spiritwood Planks:" & $SpiritwoodCount)
	ElseIf GetAmberCount() > 0 Then
		Out ("Amber:" & $AmberCount)
	ElseIf GetSpiritwoodCount() > 0 Then
		Out ("Jade:" & $JadeCount)
	EndIf
;	Event Items
	If GetAgedDwarvenAleCount() > 0 Then
		Out("Aged Dwarven Ale:" & $AgedDwarvenAle)
	ElseIf GetAgedHuntersAleCount() > 0 Then
		Out("Aged Hunter's Ale:" & $AgedHuntersAle)
	ElseIf GetIcedTeaCount() > 0 Then
		Out("Iced Tea:" & $BattleIslandIcedTea)
	ElseIf GetBirthdayCupcakeCount() > 0 Then
		Out("Cupcakes:" & $BirthdayCupcake)
	ElseIf GetCandyCaneShards() > 0 Then
		Out("CC Shards:" & $CandyCaneShards)
	ElseIf GetGoldenEggCount() > 0 Then
		Out("Golden Eggs:" & $GoldenEgg)
	ElseIf GetBottleOfGrogCount() > 0 Then
		Out("Grog Arrr:" & $Grog)
	ElseIf GetHoneyCombCount() > 0 Then
		Out("Honeycombs:" & $HoneyCombs)
	ElseIf GetKrytanBrandyCount() > 0 Then
		Out("Krytan Brandy:" & $KrytanBrandy)
	ElseIf GetPartyBeaconCount() > 0 Then
		Out("Jesus Beams:" & $PartyBeacon)
	ElseIf GetPumpkinPieCount() > 0 Then
		Out("Pumpkin Pies:" & $PumpkinPies)
	ElseIf GetSpikedEggnogCount() > 0 Then
		Out("Spiked Eggnog:" & $SpikedEggnog)
	ElseIf GetTrickOrTreatCount() > 0 Then
		Out("ToTs:" & $TrickOrTreats)
	ElseIf GetVictoryTokenCount() > 0 Then
		Out("Victory Tokens:" & $VictoryToken)
	ElseIf GetWayfarerMarkCount() > 0 Then
		Out("Wayfarer Marks:" & $WayfarerMark)
	ElseIf GetYuletideTonicCount() > 0 Then
		Out("Yuletide Tonics:" & $YuletideTonic)
	EndIf
EndFunc

;	Standard Vaettir Drops excluding Map Pieces
Func GetGlacialStoneCount()
	Local $AAMOUNTGlacialStone
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 27047 Then
				$AAMOUNTGlacialStone += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGlacialStone
EndFunc   ; Counts Glacial Stones in your Inventory

Func GetMesmerTomeCount()
	Local $AAMOUNTMesmerTomes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 21797 Then
				$AAMOUNTMesmerTomes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMesmerTomes
EndFunc   ; Counts Mesmer Tomes in your Inventory

Func GetLockpickCount()
	Local $AAMOUNTLockPick
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 22751 Then
				$AAMOUNTLockPick += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLockPick
EndFunc   ; Counts Lockpicks in your Inventory

Func GetBlackDyeCount()
	Local $AAMOUNTBlackDyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 146 Then
				If DllStructGetData($aitem, "ExtraID") == 10 Then
					$AAMOUNTBlackDyes += DllStructGetData($aItem, "Quantity")
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBlackDyes
EndFunc   ; Counts Black Dyes in your Inventory

Func GetWhiteDyeCount()
	Local $AAMOUNTWhiteDyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 146 Then
				If DllStructGetData($aitem, "ExtraID") == 12 Then
					$AAMOUNTWhiteDyes += DllStructGetData($aItem, "Quantity")
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTWhiteDyes
EndFunc   ; Counts White Dyes in your Inventory

;	Rare Materials
Func GetFurCount()
	Local $AAMOUNTFurSquares
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 941 Then
				$AAMOUNTFurSquares += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTFurSquares
EndFunc   ; Counts Fur Squares in your Inventory

Func GetLinenCount()
	Local $AAMOUNTLinen
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 926 Then
				$AAMOUNTLinen += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLinen
EndFunc   ; Counts Linen in your Inventory

Func GetDamaskCount()
	Local $AAMOUNTDamask
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 927 Then
				$AAMOUNTDamask += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDamask
EndFunc   ; Counts Damask in your Inventory

Func GetSilkCount()
	Local $AAMOUNTSilk
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 928 Then
				$AAMOUNTSilk += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSilk
EndFunc   ; Counts Silk in your Inventory

Func GetEctoCount()
	Local $AAMOUNTEctos
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 930 Then
				$AAMOUNTEctos += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTEctos
EndFunc   ; Counts Ectos in your Inventory

Func GetSteelCount()
	Local $AAMOUNTSteel
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 949 Then
				$AAMOUNTSteel += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSteel
EndFunc   ; Counts Steel in your Inventory

Func GetDeldSteelCount()
	Local $AAMOUNTDelSteel
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 950 Then
				$AAMOUNTDelSteel += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDelSteel
EndFunc   ; Counts Deldrimor Steel in your Inventory

Func GetMonClawCount()
	Local $AAMOUNTMonClaw
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 923 Then
				$AAMOUNTMonClaw += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonClaw
EndFunc   ; Counts Monstrous Claws in your Inventory

Func GetMonEyeCount()
	Local $AAMOUNTMonEyes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 931 Then
				$AAMOUNTMonEyes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonEyes
EndFunc   ; Counts Montrous Eyes in your Inventory

Func GetMonFangCount()
	Local $AAMOUNTMonFangs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 932 Then
				$AAMOUNTMonFangs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTMonFangs
EndFunc   ; Counts Montrous Fangs in your Inventory

Func GetRubyCount()
	Local $AAMOUNTRubies
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 937 Then
				$AAMOUNTRubies += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTRubies
EndFunc   ; Counts Rubies in your Inventory

Func GetSapphireCount()
	Local $AAMOUNTSapphires
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 938 Then
				$AAMOUNTSapphires += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSapphires
EndFunc   ; Counts Sapphires in your Inventory

Func GetDiamondCount()
	Local $AAMOUNTDiamonds
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 935 Then
				$AAMOUNTDiamonds += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTDiamonds
EndFunc   ; Counts Diamonds in your Inventory

Func GetOnyxCount()
	Local $AAMOUNTOnyx
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 936 Then
				$AAMOUNTOnyx += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTOnyx
EndFunc   ; Counts Onyx in your Inventory

Func GetCharcoalCount()
	Local $AAMOUNTCharcoal
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 922 Then
				$AAMOUNTCharcoal += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCharcoal
EndFunc   ; Counts Charcoal in your Inventory

Func GetObsidianShardCount()
	Local $AAMOUNTObbyShards
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 945 Then
				$AAMOUNTObbyShards += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTObbyShards
EndFunc   ; Counts Obsidian Shards in your Inventory

Func GetGlassVialCount()
	Local $AAMOUNTGlassVials
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 939 Then
				$AAMOUNTGlassVials += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGlassVials
EndFunc   ; Counts Glass Vials in your Inventory

Func GetLeatherCount()
	Local $AAMOUNTLeather
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 942 Then
				$AAMOUNTLeather += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTLeather
EndFunc   ; Counts Leather Squares in your Inventory

Func GetElonLeatherCount()
	Local $AAMOUNTElonLeather
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 943 Then
				$AAMOUNTElonLeather += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTElonLeather
EndFunc   ; Counts Elonian LEather in your Inventory

Func GetVialInkCount()
	Local $AAMOUNTVialsInk
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 944 Then
				$AAMOUNTVialsInk += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVialsInk
EndFunc   ; Counts Vials of Ink in your Inventory

Func GetParchmentCount()
	Local $AAMOUNTParchment
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 951 Then
				$AAMOUNTParchment += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTParchment
EndFunc   ; Counts Parchment in your Inventory

Func GetVellumCount()
	Local $AAMOUNTVellum
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 952 Then
				$AAMOUNTVellum += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVellum
EndFunc   ; Counts Vellum in your Inventory

Func GetSpiritwoodCount()
	Local $AAMOUNTSpiritWood
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 956 Then
				$AAMOUNTSpiritWood += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSpiritWood
EndFunc   ; Counts Spiritwood Planks in your Inventory

Func GetAmberCount()
	Local $AAMOUNTAmber
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 6532 Then
				$AAMOUNTAmber += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAmber
EndFunc   ; Counts Chunks of Amber in your Inventory

Func GetJadeCount()
	Local $AAMOUNTJade
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 6533 Then
				$AAMOUNTJade += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTJade
EndFunc   ; Counts Jadeite Shards in your Inventory

;	Event Items
Func GetAgedDwarvenAleCount()
	Local $AAMOUNTAgedDwarven
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 24593 Then
				$AAMOUNTAgedDwarven += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAgedDwarven
EndFunc   ; Counts Aged Dwarven Ales in your Inventory

Func GetAgedHuntersAleCount()
	Local $AAMOUNTAgedHunters
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 31145 Then
				$AAMOUNTAgedHunters += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAgedHunters
EndFunc   ; Counts Aged Dwarven Ales in your Inventory

Func GetIcedTeaCount()
	Local $AAMOUNTIcedTea
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 36682 Then
				$AAMOUNTIcedTea += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTIcedTea
EndFunc   ; Counts Battle Isle Iced teas in your Inventory

Func GetBirthdayCupcakeCount()
	Local $AAMOUNTCupcakes
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 22269 Then
				$AAMOUNTCupcakes += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCupcakes
EndFunc   ; Counts Birthday Cupcakes in your Inventory

Func GetCandyCaneShards()
	Local $AAMOUNTCCShards
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 556 Then
				$AAMOUNTCCShards += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCCShards
EndFunc   ; Counts Candy Cane Shards in your Inventory

Func GetGoldenEggCount()
	Local $AAMOUNTEggs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 22752 Then
				$AAMOUNTEggs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTEggs
EndFunc   ; Counts Golden Eggs in your Inventory

Func GetBottleOfGrogCount()
	Local $AAMOUNTGrogs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 30855 Then
				$AAMOUNTGrogs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTGrogs
EndFunc   ; Counts Bottles of Grog in your Inventory

Func GetHoneyCombCount()
	Local $AAMOUNTHoneycombs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 26784 Then
				$AAMOUNTHoneycombs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTHoneycombs
EndFunc   ; Counts Honeycombs in your Inventory

Func GetKrytanBrandyCount()
	Local $AAMOUNTBrandy
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 35124 Then
				$AAMOUNTBrandy += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTBrandy
EndFunc   ; Counts Krytan Brandies in your Inventory

Func GetPartyBeaconCount()
	Local $AAMOUNTJesusBeams
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 36683 Then
				$AAMOUNTJesusBeams += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTJesusBeams
EndFunc   ; Counts Party Beacons in your Inventory

Func GetPumpkinPieCount()
	Local $AAMOUNTPies
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 28436 Then
				$AAMOUNTPies += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTPies
EndFunc   ; Counts Slice of Pumpkin Pie in your Inventory

Func GetSpikedEggnogCount()
	Local $AAMOUNTSpikedEggnog
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 6366 Then
				$AAMOUNTSpikedEggnog += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTSpikedEggnog
EndFunc   ; Counts Spiked Eggnogs in your Inventory

Func GetTrickOrTreatCount()
	Local $AAMOUNTToTs
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 28434 Then
				$AAMOUNTToTs += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTToTs
EndFunc   ; Counts Trick-Or-Treat bags in your Inventory

Func GetVictoryTokenCount()
	Local $AAMOUNTVicTokens
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 18345 Then
				$AAMOUNTVicTokens += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTVicTokens
EndFunc   ; Counts Victory Tokens in your Inventory

Func GetWayfarerMarkCount();
	Local $AAMOUNTWayfarerMark
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 37765 Then
				$AAMOUNTWayfarerMark += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTWayfarerMark
EndFunc   ; Counts Wayfarer Marks in your Inventory

Func GetYuletideTonicCount();
	Local $AAMOUNTYuletideTonics
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == 21490 Then
				$AAMOUNTYuletideTonics += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTYuletideTonics
EndFunc   ; Counts Yuletides in your Inventory

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

Func CountSlotsChest()
	Local $bag
	Local $temp = 0
	$bag = GetBag(8)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(9)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(10)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(11)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(12)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(13)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(14)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(15)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	$bag = GetBag(16)
	$temp += DllStructGetData($bag, 'Slots') - DllStructGetData($bag, 'ItemsCount')
	Return $temp
EndFunc ; Counts open slots in the storage chest
#EndRegion Counting Things

#Region Storing Stuff
; Big function that calls the smaller functions below
Func StoreItems()
	StackableDrops(1, 20)
	StackableDrops(2, 5)
	StackableDrops(3, 10)
	StackableDrops(4, 10)
	Alcohol(1, 20)
	Alcohol(2, 5)
	Alcohol(3, 10)
	Alcohol(4, 10)
	Party(1, 20)
	Party(2, 5)
	Party(3, 10)
	Party(4, 10)
	Sweets(1, 20)
	Sweets(2, 5)
	Sweets(3, 10)
	Sweets(4, 10)
	Scrolls(1, 20)
	Scrolls(2, 5)
	Scrolls(3, 10)
	Scrolls(4, 10)
	EliteTomes(1, 20)
	EliteTomes(2, 5)
	EliteTomes(3, 10)
	EliteTomes(4, 10)
	Tomes(1, 20)
	Tomes(2, 5)
	Tomes(3, 10)
	Tomes(4, 10)
	DPRemoval(1, 20)
	DPRemoval(2, 5)
	DPRemoval(3, 10)
	DPRemoval(4, 10)
	SpecialDrops(1, 20)
	SpecialDrops(2, 5)
	SpecialDrops(3, 10)
	SpecialDrops(4, 10)
EndFunc ;~ Includes event items broken down by type

Func StoreMaterials()
	Materials(1, 20)
	Materials(2, 5)
	Materials(3, 10)
	Materials(4, 10)
EndFunc ;~ Common and Rare Materials

Func StoreUNIDGolds()
	UNIDGolds(1, 20)
	UNIDGolds(2, 5)
	UNIDGolds(3, 10)
	UNIDGolds(4, 10)
EndFunc ;~ UNID Golds

Func StoreMods()
	Mods(1, 20)
	Mods(2, 5)
	Mods(3, 10)
	Mods(4, 10)
EndFunc ;~ Mods I want to keep

Func StoreWeapons()
	Weapons(1, 20)
	Weapons(2, 5)
	Weapons(3, 10)
	Weapons(4, 10)
EndFunc

Func Weapons($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		Local $aitem = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		Local $ModStruct = GetModStruct($aitem)
		Local $Energy = StringInStr($ModStruct, "0500D822", 0, 1) ;~String for +5e mod
		Switch DllStructGetData($aitem, "Type")
			Case 2, 5, 15, 27, 32, 35, 36
				If $Energy > 0 Then
					Do
						For $BAG = 8 To 12
							$SLOT = FindEmptySlot($BAG)
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
						Sleep(Random(450, 550))
					EndIf
				EndIf
		EndSwitch
	Next
EndFunc

Func StackableDrops($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 460 Or $M = 474 Or $M = 476 Or $M = 486 Or $M = 522 Or $M = 525 Or $M = 811 Or $M = 819 Or $M = 822 Or $M = 835 Or $M = 1610 Or $M = 2994 Or $M = 19185 Or $M = 22751 Or $M = 24629 Or $M = 24630 Or $M = 24631 Or $M = 24632 Or $M = 27033 Or $M = 27035 Or $M = 27044 Or $M = 27046 Or $M = 27047 Or $M = 27052 Or $M = 35123) And $Q = 250 Then
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
EndFunc ;~ like Suarian Bones, lockpicks, Glacial Stones, etc

Func EliteTomes($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
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
EndFunc ;~ non-Elite tomes only

Func Tomes($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 21796 Or $M = 21797 Or $M = 21798 Or $M = 21799 Or $M = 21800 Or $M = 21801 Or $M = 21802 Or $M = 21803 Or $M = 21804 Or $M = 21805) And $Q = 250 Then
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
EndFunc ;~ non-Elite tomes only

Func Alcohol($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 910 Or $M = 2513 Or $M = 5585 Or $M = 6049 Or $M = 6366 Or $M = 6367 Or $M = 6375 Or $M = 15477 Or $M = 19171 Or $M = 22190 Or $M = 24593 Or $M = 28435 Or $M = 30855 Or $M = 31145 Or $M = 31146 Or $M = 35124 Or $M = 36682) And $Q = 250 Then
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
EndFunc

Func Party($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6376 Or $M = 6368 Or $M = 6369 Or $M = 21809 Or $M = 21810 Or $M = 21813 Or $M = 29436 Or $M = 29543 Or $M = 36683 Or $M = 4730 Or $M = 15837 Or $M = 21490 Or $M = 22192 Or $M = 30626 Or $M = 30630 Or $M = 30638 Or $M = 30642 Or $M = 30646 Or $M = 30648 Or $M = 31020 Or $M = 31141 Or $M = 31142 Or $M = 31144 Or $M = 31172) And $Q = 250 Then
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
EndFunc

Func Sweets($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 15528 Or $M = 15479 Or $M = 19170 Or $M = 21492 Or $M = 21812 Or $M = 22269 Or $M = 22644 Or $M = 22752 Or $M = 28431 Or $M = 28432 Or $M = 28436 Or $M = 31150 Or $M = 35125 Or $M = 36681) And $Q = 250 Then
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
EndFunc

Func Scrolls($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 3256 Or $M = 3746 Or $M = 5594 Or $M = 5595 Or $M = 5611 Or $M = 5853 Or $M = 5975 Or $M = 5976 Or $M = 21233 Or $M = 22279 Or $M = 22280) And $Q = 250 Then
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
EndFunc

Func DPRemoval($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6370 Or $M = 21488 Or $M = 21489 Or $M = 22191 Or $M = 35127 Or $M = 26784 Or $M = 28433) And $Q = 250 Then
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
EndFunc

Func SpecialDrops($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 18345 Or $M = 21491 Or $M = 21833 Or $M = 28434 Or $M = 35121) And $Q = 250 Then
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
EndFunc

Func Materials($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 921 Or $M = 922 Or $M = 923 Or $M = 925 Or $M = 926 Or $M = 927 Or $M = 928 Or $M = 929 Or $M = 930 Or $M = 931 Or $M = 932 Or $M = 933 Or $M = 934 Or $M = 935 Or $M = 936 Or $M = 937 Or $M = 938 Or $M = 939 Or $M = 940 Or $M = 941 Or $M = 942 Or $M = 943 Or $M = 944 Or $M = 945 Or $M = 946 Or $M = 948 Or $M = 949 Or $M = 950 Or $M = 951 Or $M = 952 Or $M = 953 Or $M = 954 Or $M = 955 Or $M = 956 Or $M = 6532 Or $M = 6533) And $Q = 250 Then
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
EndFunc

; Keeps all Golds
Func UNIDGolds($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $R
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		If $R = 2624 Then
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
EndFunc ;~ UNID golds

; Stores the mods that I am salvaging out to keep for Hero weapons
Func Mods($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 896 Or $M = 908 Or $M = 15554 Or $M = 15551 Or $M = 15552 Or $M = 894 Or $M = 906 Or $M = 897 Or $M = 909 Or $M = 893 Or $M = 905 Or $M = 6323 Or $M = 6331 Or $M = 895 Or $M = 907 Or $M = 15543 Or $M = 15553 Or $M = 15544 Or $M = 15555 Or $M = 15540 Or $M = 15541 Or $M = 15542 Or $M = 17059 Or $M = 19122 Or $M = 19123) Then
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
EndFunc

; This searches for empty slots in your storage
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
EndFunc
#EndRegion Storing Stuff
#EndRegion Inventory

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
Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

;~ Description: guess what?
Func _exit()
	Exit
EndFunc

#Region Pcons
Func UseCupcake()
	If $useCupcake Then
		pconsScanInventory()
		If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
			If $pconsCupcake_slot[0] > 0 And $pconsCupcake_slot[1] > 0 Then
				If DllStructGetData(GetItemBySlot($pconsCupcake_slot[0], $pconsCupcake_slot[1]), "ModelID") == 22269 Then
					UseItemBySlot($pconsCupcake_slot[0], $pconsCupcake_slot[1])
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
	$pconsCupcake_slot[0] = $pconsCupcake_slot[1] = 0
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
				Case 22269
					$pconsCupcake_slot[0] = $bag
					$pconsCupcake_slot[1] = $slot
			EndSwitch
		Next
	Next
EndFunc   ;==>pconsScanInventory
;~ Uses the Item from UseCupcake()
Func UseItemBySlot($aBag, $aSlot)
	Local $item = GetItemBySlot($aBag, $aSlot)
	SENDPACKET(8, 119, DllStructGetData($item, "ID"))
EndFunc   ;==>UseItemBySlot

Func arrayContains($array, $item)
	For $i = 1 To $array[0]
		If $array[$i] == $item Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>arrayContains
#EndRegion Pcons

;=================================================================================================
; Function:			SetDisplayedTitle($aTitle = 0)
; Description:		Set the currently displayed title.
; Parameter(s):		Parameter = $aTitle
;								No Title		= 0x00
;								Spearmarshall 	= 0x11
;								Lightbringer 	= 0x14
;								Asuran 			= 0x26
;								Dwarven 		= 0x27
;								Ebon Vanguard 	= 0x28
;								Norn 			= 0x29
;; Requirement(s):	GW must be running and Memory must have been scanned for pointers (see Initialize())
; Return Value(s):	Returns displayed Title
; Author(s):		Skaldish
;=================================================================================================

;Func SetDisplayedTitle($aTitle = 0)
;	If $aTitle Then
;		Return SendPacket(0x8, 0x50, $aTitle)
;	Else
;		Return SendPacket(0x4, 0x51)
;	EndIf
;EndFunc   ;==>SetDisplayedTitle

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

Func GenericRandomPath($aPosX, $aPosY, $aRandom = 50, $STOPSMIN = 1, $STOPSMAX = 5, $NUMBEROFSTOPS = -1)
	If $NUMBEROFSTOPS = -1 Then $NUMBEROFSTOPS = Random($STOPSMIN, $STOPSMAX, 1)
	Local $lAgent = GetAgentByID(-2)
	Local $MYPOSX = DllStructGetData($lAgent, "X")
	Local $MYPOSY = DllStructGetData($lAgent, "Y")
	Local $DISTANCE = ComputeDistance($MYPOSX, $MYPOSY, $aPosX, $aPosY)
	If $NUMBEROFSTOPS = 0 Or $DISTANCE < 200 Then
		MoveTo($aPosX, $aPosY, $aRandom)
	Else
		Local $M = Random(0, 1)
		Local $N = $NUMBEROFSTOPS - $M
		Local $STEPX = (($M * $aPosX) + ($N * $MYPOSX)) / ($M + $N)
		Local $STEPY = (($M * $aPosY) + ($N * $MYPOSY)) / ($M + $N)
		MoveTo($STEPX, $STEPY, $aRandom)
		GenericRandomPath($aPosX, $aPosY, $aRandom, $STOPSMIN, $STOPSMAX, $NUMBEROFSTOPS - 1)
	EndIf
EndFunc   ;==>GENERICRANDOMPATH