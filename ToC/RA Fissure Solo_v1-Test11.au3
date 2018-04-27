#RequireAdmin
#NoTrayIcon

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

#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.8.0
GWA2 Version: 3.6.9 Modified
Compiler:		Savsuds

Author:			Savsuds

Bot Functions:
	-Selectable Starting town
	-Enters Fissure of Woe using Fissure scroll or talking to the Ghostlie (***)
	-Casts buffs and skills and conducts a run. Kills all Shadow Rangers and Abyssals
		near the opening tower area
	-Uses alcohol, corn, apple, war supplies if in your inventory bag

Inventory Features:
	-Picks up and Stores Black/White Dyes
	-Picks up and Stores Obsidian Keys
	-Picks up and Stores Dark Remains
	-Picks Up and Stores Rubies, Sapphires, Obsidian Shards
	-Picks Up and Stores Unid Golds

Requirements:
	-Plenty of gold in the storage/character unless you only run this during
		Pantheon week events
	-Ranger Primary with Assasin secondary and has access to Fissure of Woe
	-Rank 5 Norn Title
	-Rank 5 Asuran Title
	-Rank 5 Deldrimor Title
	-Temple of the Ages town
	-Chantry of Secrets town
	-Zin Ku Corridor town

	-3-point alcohol to ensure that Dwarven Stability prevents knockdown for when IAU is recharging

	-Skillbar: OgcSc5PTHQ6M0kxlCH3lNQ4O

Notes:

	Thanks: Ralle, 4D1, gigi, TAP, Miracle, Tormiasz, dDarek, skaldish
	I borrowed inspiration and code/API from you all

	Special thanks to Andy for the video sharing his farm and answering questions about the run

	*** May not implement this feature
#ce ----------------------------------------------------------------------------

Global $MAP_ID_TEMPLE_OF_AGES = 138
Global $MAP_ID_CHANTRY_OF_SECRETS = 393
Global $MAP_ID_ZIN_KU_CORRIDOR = 284
Global $MAP_ID_FISSURE_OF_WOE = 34

Global Const $MODELID_CHAMPION_OF_BALTHAZAR = 1937

Global $TempleoftheAges = False
Global $ChantryofSecrets = False
Global $ZinKuCorridor = False

Global Const $RangerSkillBarTemplate = "OgcSc5PTHQ6M0kxlCH3lNQ4O"
Global Const $SkillBar[8] = [1031, 826, 2356, 2417, 450, 2423, 1037, 952]

#Region Global Skill Number
Global Const $Shroud_of_Distress_Skill = 1
Global Const $Shadow_Form_Skill = 2
Global Const $I_Am_Unstoppable_Skill = 3
Global Const $Mental_Block_Skill = 4
Global Const $Whirling_Defense_Skill = 5
Global Const $DwarvenStability_Skill = 6
Global Const $Dark_Escape_Skill = 7
Global Const $Deaths_Charge_Skill = 8
#EndRegion Global Skill Number

#Region Global Engergy Skill Cost
Global $skillCost[9]
$skillCost[$Shroud_of_Distress_Skill] = 10
$skillCost[$Shadow_Form_Skill] = 5
$skillCost[$I_Am_Unstoppable_Skill] = 5
$skillCost[$Mental_Block_Skill] = 10
$skillCost[$Whirling_Defense_Skill] = 10
$skillCost[$DwarvenStability_Skill] = 5
$skillCost[$Dark_Escape_Skill] = 5
$skillCost[$Deaths_Charge_Skill] = 5
#CS
Global Const $Shroud_of_Distress_Energie = 10
Global Const $Shadow_Form_Energie = 5
Global Const $I_Am_Unstoppable_Energie = 5
Global Const $Mental_Block_Energie = 10
Global Const $Whirling_Defense_Energie = 10
Global Const $DwarvenStability_Energie = 5
Global Const $Dark_Escape_Energie = 5
Global Const $Deaths_Charge_Energie = 5
#CE
#EndRegion Global Engergy Skill Cost

#Region Global Const Items
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621
;~ Weapon Mods
Global $Weapon_Mod_Array[25] = [893, 894, 895, 896, 897, 905, 906, 907, 908, 909, 6323, 6331, 15540, 15541, 15542, 15543, 15544, 15551, 15552, 15553, 15554, 15555, 17059, 19122, 19123]
Global Const $ITEM_ID_STAFF_HEAD = 896
Global Const $ITEM_ID_STAFF_WRAPPING = 908
Global Const $ITEM_ID_SHIELD_HANDLE = 15554
Global Const $ITEM_ID_FOCUS_CORE = 15551
Global Const $ITEM_ID_WAND = 15552
Global Const $ITEM_ID_BOW_STRING = 894
Global Const $ITEM_ID_BOW_GRIP = 906
Global Const $ITEM_ID_SWORD_HILT = 897
Global Const $ITEM_ID_SWORD_POMMEL = 909
Global Const $ITEM_ID_AXE_HAFT = 893
Global Const $ITEM_ID_AXE_GRIP = 905
Global Const $ITEM_ID_DAGGER_TANG = 6323
Global Const $ITEM_ID_DAGGER_HANDLE = 6331
Global Const $ITEM_ID_HAMMER_HAFT = 895
Global Const $ITEM_ID_HAMMER_GRIP = 907
Global Const $ITEM_ID_SCYTHE_SNATHE = 15543
Global Const $ITEM_ID_SCYTHE_GRIP = 15553
Global Const $ITEM_ID_SPEARHEAD = 15544
Global Const $ITEM_ID_SPEAR_GRIP = 15555
Global Const $ITEM_ID_INSCRIPTIONS_MARTIAL = 15540
Global Const $ITEM_ID_INSCRIPTIONS_FOCUS_SHIELD = 15541
Global Const $ITEM_ID_INSCRIPTIONS_ALL = 15542
Global Const $ITEM_ID_INSCRIPTIONS_GENERAL = 17059
Global Const $ITEM_ID_INSCRIPTIONS_SPELLCASTING = 19122
Global Const $ITEM_ID_INSCRIPTIONS_FOCUS_ITEMS = 19123
;~ General items
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_ID_KIT = 2989
Global Const $ITEM_ID_SUP_ID_KIT = 5899
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_EXP_SALVAGE_KIT = 2991
Global Const $ITEM_ID_SUP_SALVAGE_KIT = 5900
;~ Dyes I included colors not normally grabbed
Global Const $ITEM_ID_DYES = 146
Global Const $ITEM_EXTRAID_BLUEDYE = 2
Global Const $ITEM_EXTRAID_GREENDYE = 3
Global Const $ITEM_EXTRAID_PURPLEDYE = 4
Global Const $ITEM_EXTRAID_REDDYE = 5
Global Const $ITEM_EXTRAID_YELLOWDYE = 6
Global Const $ITEM_EXTRAID_BROWNDYE = 7
Global Const $ITEM_EXTRAID_ORANGEDYE = 8
Global Const $ITEM_EXTRAID_SILVERDYE = 9
Global Const $ITEM_EXTRAID_BLACKDYE = 10
Global Const $ITEM_EXTRAID_GRAYDYE = 11
Global Const $ITEM_EXTRAID_WHITEDYE = 12
Global Const $ITEM_EXTRAID_PINKDYE = 13
;~ Alcohol
Global $Alcohol_Array[11] = [910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682]
Global Const $ITEM_ID_HUNTERS_ALE = 910
Global Const $ITEM_ID_DWARVEN_ALE = 5585
Global Const $ITEM_ID_SPIKED_EGGNOG = 6366
Global Const $ITEM_ID_EGGNOG = 6375
Global Const $ITEM_ID_SHAMROCK_ALE = 22190
Global Const $ITEM_ID_AGED_DWARVEN_ALE = 24593
Global Const $ITEM_ID_CIDER = 28435
Global Const $ITEM_ID_GROG = 30855
Global Const $ITEM_ID_AGED_HUNTERS_ALE = 31145
Global Const $ITEM_ID_KRYTAN_BRANDY = 35124
Global Const $ITEM_ID_BATTLE_ISLE_ICED_TEA = 36682
;~ Party
Global $Spam_Party_Array[5] = [6376, 21809, 21810, 21813, 36683]
Global Const $ITEM_ID_SNOWMAN_SUMMONER = 6376
Global Const $ITEM_ID_ROCKETS = 21809
Global Const $ITEM_ID_POPPERS = 21810
Global Const $ITEM_ID_SPARKLER = 21813
Global Const $ITEM_ID_PARTY_BEACON = 36683
;~ Sweets
Global $Spam_Sweet_Array[6] = [21492, 21812, 22269, 22644, 22752, 28436]
Global Const $ITEM_ID_FRUITCAKE = 21492
Global Const $ITEM_ID_BLUE_DRINK = 21812
Global Const $ITEM_ID_CUPCAKES = 22269
Global Const $ITEM_ID_BUNNIES = 22644
Global Const $ITEM_ID_GOLDEN_EGGS = 22752
Global Const $ITEM_ID_PIE = 28436
;~ Tonics
Global $Tonic_Party_Array[21] = [15837, 21490, 22192, 30624, 30626, 30630, 30632, 30634, 30636, 30638, 30640, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 31172, 37771, 37772]
;Global Const $ITEM_ID_ = 4730
Global Const $ITEM_ID_TRANSMOGRIFIER = 15837
Global Const $ITEM_ID_YULETIDE = 21490
Global Const $ITEM_ID_BEETLE_JUICE = 22192 ; Not really a drop from PvE foes
Global Const $ITEM_ID_ABYSSAL = 30624 ; Not really a drop from PvE foes
Global Const $ITEM_ID_CEREBRAL = 30626 ; Not really a drop from PvE foes
Global Const $ITEM_ID_TRAPDOOR = 30630 ; Not really a drop from PvE foes
Global Const $ITEM_ID_SEARING = 30632 ; Not really a drop from PvE foes
Global Const $ITEM_ID_AUTOMATONIC = 30634 ; Not really a drop from PvE foes
Global Const $ITEM_ID_SKELETONIC = 30636 ; Not really a drop from PvE foes
Global Const $ITEM_ID_BOREAL = 30638 ; Not really a drop from PvE foes
Global Const $ITEM_ID_GELATINOUS = 30640 ; Not really a drop from PvE foes
Global Const $ITEM_ID_PHANTASMAL = 30642 ; Not really a drop from PvE foes
;Global Const $ITEM_ID_ = 30646 ; Not really a drop from PvE foes
Global Const $ITEM_ID_FROSTY = 30648
Global Const $ITEM_ID_MISCHIEVIOUS = 31020
Global Const $ITEM_ID_MYSTERIOUS = 31141 ; Not really a drop from PvE foes
Global Const $ITEM_ID_COTTONTAIL = 31142 ; Not really a drop from PvE foes
Global Const $ITEM_ID_ZAISHEN = 31144 ; Not really a drop from PvE foes
Global Const $ITEM_ID_UNSEEN = 31172 ; Not really a drop from PvE foes
Global Const $ITEM_ID_SPOOKY = 37771 ; Not really a drop from PvE foes
Global Const $ITEM_ID_MINUTELY_MAD_KING = 37772 ; Not really a drop from PvE foes
;~ DR Removal
Global $DPRemoval_Sweets[6] = [6370, 21488, 21489, 22191, 26784, 28433]
Global Const $ITEM_ID_PEPPERMINT_CC = 6370
Global Const $ITEM_ID_WINTERGREEN_CC = 21488
Global Const $ITEM_ID_RAINBOW_CC = 21489
Global Const $ITEM_ID_CLOVER = 22191
Global Const $ITEM_ID_HONEYCOMB = 26784
Global Const $ITEM_ID_PUMPKIN_COOKIE = 28433
;~ Special Drops
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]
Global Const $ITEM_ID_CC_SHARDS = 556
Global Const $ITEM_ID_VICTORY_TOKEN = 18345
Global Const $ITEM_ID_WINTERSDAY_GIFT = 21491 ; Not really a drop
Global Const $ITEM_ID_WAYFARER_MARK = 37765
Global Const $ITEM_ID_LUNAR_TOKEN = 21833
Global Const $ITEM_ID_LUNAR_TOKENS = 28433
Global Const $ITEM_ID_TOTS = 28434
Global Const $ITEM_ID_WAR_SUPPLY = 35121
Global Const $ITEM_ID_CANDY_APPLE = 28431
Global Const $ITEM_ID_CANDY_CORN = 28432
;~ Stackable Trophies
Global $Stackable_Trophies_Array[1] = [522]
Global Const $ITEM_ID_DARK_REMAINS = 522
;~Material Array
Global $Material_Array[3] = [937, 938, 945]
;~ Common Materials
Global Const $ITEM_ID_DUST = 929
;~ Rare Materials
Global Const $ITEM_ID_RUBY = 937
Global Const $ITEM_ID_SAPPHIRE = 938
Global Const $ITEM_ID_OBSIDIAN_SHARD = 945

;~ Arrays for the title spamming (Not inside this version of the bot, but at least the arrays are made for you)
Global $ModelsAlcohol[17] = [910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682]
Global $ModelSweetOutpost[100] = [15528, 15479, 19170, 21492, 21812, 22644, 31150, 35125, 36681]
Global $ModelsSweetPve[100] = [22269, 22644, 28431, 28432, 28436]
Global $ModelsParty[100] = [6368, 6369, 6376, 21809, 21810, 21813]
Global $BAG_SLOTS[18] = [0, 20, 5, 10, 10, 20, 41, 12, 20, 20, 20, 20, 20, 20, 20, 20, 20, 9]

Global $Array_pscon[38]=[$ITEM_ID_HUNTERS_ALE, $ITEM_ID_DWARVEN_ALE, $ITEM_ID_SPIKED_EGGNOG, $ITEM_ID_EGGNOG, $ITEM_ID_SHAMROCK_ALE, $ITEM_ID_AGED_DWARVEN_ALE, $ITEM_ID_CIDER, $ITEM_ID_GROG, $ITEM_ID_AGED_HUNTERS_ALE, $ITEM_ID_KRYTAN_BRANDY, $ITEM_ID_BATTLE_ISLE_ICED_TEA, $ITEM_ID_SNOWMAN_SUMMONER, $ITEM_ID_ROCKETS, $ITEM_ID_POPPERS, $ITEM_ID_SPARKLER, $ITEM_ID_PARTY_BEACON, $ITEM_ID_FRUITCAKE, $ITEM_ID_BLUE_DRINK, $ITEM_ID_CUPCAKES, $ITEM_ID_BUNNIES, $ITEM_ID_GOLDEN_EGGS, $ITEM_ID_PIE, $ITEM_ID_TRANSMOGRIFIER, $ITEM_ID_YULETIDE, $ITEM_ID_FROSTY, $ITEM_ID_MISCHIEVIOUS, $ITEM_ID_PEPPERMINT_CC, $ITEM_ID_WINTERGREEN_CC, $ITEM_ID_RAINBOW_CC, $ITEM_ID_CLOVER, $ITEM_ID_HONEYCOMB, $ITEM_ID_PUMPKIN_COOKIE, $ITEM_ID_CC_SHARDS, $ITEM_ID_VICTORY_TOKEN, $ITEM_ID_WINTERSDAY_GIFT, $ITEM_ID_LUNAR_TOKEN, $ITEM_ID_LUNAR_TOKENS, $ITEM_ID_TOTS]

#EndRegion Global Const Items

#Region Global Const GH Map IDs
Global $ISLEOFWURMS = False, $ISLEOFDEAD = False, $ISLEOFMEDITATION = False, $ISLEOFSOLITUDE = False, $DRUIDISLE = False, $IMPERIALISLE = False, $HUNTERISLE = False, $UNCHARTEDISLE = False, $CORRUPTEDISLE = False, $ISLEOFJADE = False, $NOMADISLE = False _
, $FROZENISLE = False, $ISLEOFWEEPING = False, $WARRIORISLE = False, $BURNINGISLE = False, $WIZARDISLE = False
;~ Prophecies
Global $BurningIsle_GH_ID = 52 ;Key=Burning Isle
Global $Druid_GH_ID = 70 ;Key=Druid큦 Isle
Global $FrozenIsle_GH_ID = 68 ;Key=Frozen Isle
Global $Hunter_GH_ID = 8 ;Key=Hunter큦 Isle
Global $IsleOFDead_GH_ID = 179 ;Key=Isle Of Dead
Global $NomadIsle_GH_ID = 69 ;Key=Nomand큦 Isle
Global $WarriorsIsle_GH_ID = 7 ;Key=Warrior큦 Isle
Global $WizardsIsle_GH_ID = 9 ;Key=Wizard큦 Isle
;~ Factions
Global $Imperial_GH_ID = 363 ;Key=Imperial Isle
Global $IsleOfJade_GH_ID = 362 ;Key=Isle Of Jade
Global $Meditation_GH_ID = 360 ;Key=Isle Of Meditation
Global $IsleOfWeepingStone_GH_ID = 361 ;Key=Isle Of Weeping Stone
;~ Nightfall
Global $Corrupted_GH_ID = 539 ;Key=Corrupted Isle
Global $Solitude_GH_ID = 538 ;Key=Isle of Solitude
Global $IsleOfWurm_GH_ID = 532 ;Key=Isle Of Wurm
Global $Ucharted_GH_ID = 531 ;Key=Ucharted Isle
#EndRegion Global Const GH Map IDs

#Region Things
Global $mSelf
Global $mSelfID
Global $mLowestAlly
Global $mLowestAllyHP
Global $mLowestOtherAlly
Global $mLowestOtherAllyHP
Global $mLowestEnemy
Global $mLowestEnemyHP
Global $mClosestEnemy
Global $mClosestEnemyDist
Global $mAverageTeamHP
Global $mAverageTeamEnergy

Global $mTeam[1] ;Array of living members
Global $mTeamOthers[1] ;Array of living members other than self
Global $mTeamDead[1] ;Array of dead teammates
Global $mEnemies[1] ;Array of living enemy team
Global $mEnemiesRange[1] ;Array of living enemy team in range of waypoint
Global $mEnemiesSpellRange[1] ;Array of living enemy team in spell range
Global $mSpirits[1] ;Array of your spirits
Global $mPets[1] ;Array of your/your hero's pets
Global $mMinions[1] ;Array of your minions
Global Const $BoneHorrorID = 2198
#EndRegion Things

Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2
Global Enum $PROF_NONE, $PROF_WARRIOR, $PROF_RANGER, $PROF_MONK, $PROF_NECROMANCER, $PROF_MESMER, $PROF_ELEMENTALIST, $PROF_ASSASSIN, $PROF_RITUALIST, $PROF_PARAGON, $PROF_DERVISH

Global $mFoundChest = False, $mFoundMerch = False, $Bags = 4, $PICKUP_GOLDS = False
Global $TempleoftheAges = False, $ChantryofSecrets = False, $ZinKuCorridor = False
Global $Select_Town = "Temple of the Ages|Chantry of Secrets|Zin Ku Corridor"

Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

Global $pconsWar_Supply_slot[2]
Global $pconsCandy_Apple_slot[2]
Global $pconsCandy_Corn_slot[2]
Global $pconsSpiked_Eggnog_slot[2]
Global $pconsAged_Dwarven_Ale_slot[2]
Global $pconsGrog_slot[2]
Global $pconsAged_Hunters_Ale_slot[2]
Global $pconsKrytan_Brandy_slot[2]
Global $pconsHard_Apple_Cider_slot[2]

; ================== CONFIGURATION ==================
; True or false to load the list of logged in characters or not
Global Const $doLoadLoggedChars = True
; ================ END CONFIGURATION ================

; ==== Bot global variables ====
Global $RenderingEnabled = True
Global $PickUpAll = True
Global $RunCount = 0
Global $FailCount = 0
Global $ShardCount = 0
Global $BotRunning = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()

#Region GUI
Global Const $mainGui = GUICreate("Fissure Bot", 350, 275)
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
GUICtrlCreateLabel("Ob Shards:", 8, 95, 70, 17)
Global Const $ObbyShardCount = GUICtrlCreateLabel($ShardCount, 80, 95, 50, 17)
Global Const $Button = GUICtrlCreateButton("Start", 8, 120, 131, 25)
	GUICtrlSetOnEvent(-1, "GuiButtonHandler")
Global Const $StatusLabel = GUICtrlCreateLabel("", 8, 148, 125, 17)
Global Const $Checkbox = GUICtrlCreateCheckbox("Disable Rendering", 8, 198, 129, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "ToggleRendering")
Global $GLOGBOX = GUICtrlCreateEdit("", 140, 8, 200, 240, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetColor($GLOGBOX, 65280)
GUICtrlSetBkColor($GLOGBOX, 0)
GUISetState(@SW_SHOW)

GUICtrlSetData($LOCATION, $Select_Town)

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
			If Initialize(ProcessExists("gw.exe"), True, True, False) = False Then
				MsgBox(0, "Error", "Guild Wars is not running.")
				Exit
			EndIf
		Else
			If Initialize($CharName, True, True, False) = False Then
				MsgBox(0, "Error", "Could not find a Guild Wars client with a character named '"&$CharName&"'")
				Exit
			EndIf
		EndIf
		EnsureEnglish(True)
		GUICtrlSetState($Checkbox, $GUI_ENABLE)
		GUICtrlSetState($Input, $GUI_DISABLE)
		GUICtrlSetData($Button, "Pause")
		WinSetTitle($mainGui, "", "Fissure Bot-" & GetCharname())
		$BotRunning = True
		$BotInitialized = True
	EndIf
EndFunc
#EndRegion GUI

Out("Waiting for input")

While Not $BotRunning
	Sleep(100)
WEnd

; load template if we're in town
If GetMapLoading() == $INSTANCETYPE_OUTPOST Then LoadSkillTemplate($RangerSkillBarTemplate)

While True
	If GUICtrlRead($LOCATION, "") == "Temple of the Ages" Then
		$TempleoftheAges = True
	ElseIf GUICtrlRead($LOCATION, "") == "Chantry of Secrets" Then
		$ChantryofSecrets = True
	ElseIf GUICtrlRead($LOCATION, "") == "Zin Ku Corridor" Then
		$ZinKuCorridor = True
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

		If $TempleoftheAges Then MapTemple()
		If $ChantryofSecrets Then MapChantry()
		If $ZinKuCorridor Then MapZinKu()

		RunningShit()
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

Func RunningShit()
; Here is where you use 1 alcohol so the extra bonus from Dwarven Stability is used
; Along with various other pcons if you have them in your bags
	Out("Drinking some Drink")
	UseAlcohol()
	Sleep(GetPing()+200)
	Out("Popping Pills")
	UseCandyApple()
	Sleep(GetPing()+200)
	UseCandyCorn()
	Sleep(GetPing()+200)
	UseWarSupply()
	Sleep(GetPing()+200)

	UseSkillEx(6, -2)
	UseSkillEx(2, -2)
	Out("Let's Run Already")
	UseSkillEx(7, -2)
	MoveTo(-20615, -3072)
	MoveTo(-20008, -2889)
	MoveTo(-19541, -2934)
	MoveTo(-19145, -3139)
	MoveTo(-18458, -2721)
	MoveTo(-17625, -2190)

	Out("Anti-KD time")
	UseSkillEx(1, -2)
	UseSkillEx(4, -2)
	UseSkillEx(3, -2)

	MoveTo(-16999, -2822)
	MoveTo(-16273, -3186)
	UseDS()
	MoveTo(-15464, -3462)
	UseDS()
	MoveTo(-14684, -3287)
	Local $EnemyID1 = GetNearestAgentToCoords(-13780, -2627) ; Tele to whatever is there
	UseSkillex(8, $EnemyID1)

	MoveTo(-13694, -1459)
	MoveTo(-14048, -721)
	MoveTo(-15354, -428)
	MoveTo(-15681, -370)
	UseIAU()
	MoveTo(-15977, -345)
	UseIAU()
	MoveTo(-16255, -428)
	Sleep(GetPing()+1500)
	; Casting Shadow Form just in case it is extra aggro
	UseSkillEx(2, -2)
	UseSkillEx(3, -2)
	If IsRecharged($Mental_Block_Skill) And HasEffect($Mental_Block_Skill) Then
		UseSkillEx($Mental_Block_Skill)
	EndIf

	MoveTo(-16469, -416)
	Sleep(GetPing()+500)
	MoveTo(-16283, 202)
	Out("Hold!")
	UseSkillEx(6, -2)
	Out("Hold!")
	UseSkillEx(5, -2)
	Sleep(GetPing()+4000)
	MoveTo(-16141, 293) ; move to clear tele path
	Out("Hold the Line!")
	Sleep(GetPing()+1250)
	Out("Die Bitches!")
	Local $enemyID2 = GetNearestAgentToCoords(-15154, -477) ; Tele to Shadow Rangers, (-15154, -477)
	UseSkillex(8, $enemyID2)
	Do
		Sleep(500)
		StayAlive()
	Until GetNumberOfFoesInRangeOfAgent(-2, 200) < 5 Or GetIsDead(-2)
	Sleep(Random(250, 1000) + GetPing())
	PickUpLoot()

	If GetIsDead(-2) Then
		Out("I was pawn'd")
		$FailCount += 1
		GUICtrlSetData($FailsLabel, $FailCount)
	Else
		$RunCount += 1
		GUICtrlSetData($RunsLabel, $RunCount)
	EndIf

	GUICtrlSetData($ObbyShardCount, GetObsidianShardCount())

	Out("Returning to Town")
	If $TempleoftheAges = True Then
		Out("Temple of the Ages")
		RndTravel($MAP_ID_TEMPLE_OF_AGES)
		WaitMapLoading($MAP_ID_TEMPLE_OF_AGES, 5000)
	EndIf
	If $ChantryofSecrets = True Then
		Out("Chantry of Secrets")
		RndTravel($MAP_ID_CHANTRY_OF_SECRETS)
		WaitMapLoading($MAP_ID_CHANTRY_OF_SECRETS, 5000)
	EndIf
	If $ZinKuCorridor = True Then
		Out("Zin Ku Corridor")
		RndTravel($MAP_ID_ZIN_KU_CORRIDOR)
		WaitMapLoading($MAP_ID_ZIN_KU_CORRIDOR, 5000)
	EndIf

EndFunc   ;==>RangerRun

Func StayAlive()
	If IsRecharged($DwarvenStability_Skill) Then
		UseSkillEx($DwarvenStability_Skill)
	EndIf

	If IsRecharged($I_Am_Unstoppable_Skill) Then
		UseSkillEx($I_Am_Unstoppable_Skill)
	EndIf

	If IsRecharged($Shroud_of_Distress_Skill) Then
		UseSkillEx($Shroud_of_Distress_Skill)
	EndIf

	If IsRecharged($Mental_Block_Skill) And HasEffect($Mental_Block_Skill) Then
		UseSkillEx($Mental_Block_Skill)
	EndIf

	If IsRecharged($Whirling_Defense_Skill) Then
		UseSkillEx($Whirling_Defense_Skill)
	EndIf

	If IsRecharged($Shadow_Form_Skill) Then
		UseSkillEx($Shadow_Form_Skill)
	EndIf

	Local $enemyID3 = GetNearestAgentToCoords(-15040, -505)
	If IsRecharged($Deaths_Charge_Skill) Then
		UseSkillex(8, $enemyID3)
	EndIf
EndFunc

Func UseIAU()
	If IsRecharged($I_Am_Unstoppable_Skill) Then
		UseSkillEx($I_Am_Unstoppable_Skill)
	EndIf
EndFunc

Func UseDS()
	If IsRecharged($DwarvenStability_Skill) Then
		UseSkillEx($DwarvenStability_Skill)
	EndIf
EndFunc

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

Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func HasEffect($Effect)
	If DllStructGetData(GetEffect($Effect), 'SkillID') < 1 Then ; If you're not under effect
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>HasEffect

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

Func GoldCheck()
	Local $lGold = GetGoldCharacter()
	If $lGold < 1000 Then
		If GetGoldStorage() < 20000 Then
			Out("Ran out of gold")
			$BotRunning = False
			Return False
		EndIf
		Out("Withdrawing gold")
		WithdrawGold(20000)
	EndIf
	Return True
EndFunc

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

Func CheckRealPlayerIsInOutPost()
	Local $Player_Name
	$Player_Name = Check_Is_Other_Player_Here()
	If ($Player_Name == False) Then
		DistrictChange()
		If (GetMapLoading() == 2) Then DISCONNECTED()
		_PurgeHook()
	EndIf
EndFunc   ;==>CheckRealPlayerIsInOutPost

Func DistrictChange($AZONEID = 0, $AUSEDISTRICTS = 7)
	Local $REGION[12] = [2, 2, 2, 2, 2, 2, 2, 0, -2, 1, 3, 4]
	Local $LANGUAGE[12] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0, 0]
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

Func Check_Is_Other_Player_Here()
	Local $how_many_Agents, $lAgentArray, $n = 0, $Myname, $AgentPlayerNummber, $aAgent, $LAGENT, $modelID_Me, $lAgentArray, $lMe_ = -2
	$lAgentArray = GetAgentArray(0xDB)
	For $i = 0 To (UBound($lAgentArray) -1)
		If (DllStructGetData($lAgentArray[$i], 'Allegiance') == 1) Then
			$LAGENT = GetAgentByID($lMe_)
			$modelID_Me = DllStructGetData($LAGENT, 'PlayerNumber')
			$AgentPlayerNummber = DllStructGetData($lAgentArray[$i], "PlayerNumber")
			If ($AgentPlayerNummber == $modelID_Me) Then ContinueLoop
			If (($AgentPlayerNummber> 0) And ($AgentPlayerNummber < 100)And($AgentPlayerNummber<> $modelID_Me))Then
				$aAgent = GetPlayerName($lAgentArray[$i])
				$n =+1
				Out1($aAgent)
			EndIf
		EndIf
	Next
	If ($n > 0) Then
		Out("Players are here!")
		Out("Change District!")
		Return False
	EndIf
	Return True
EndFunc   ;==>Check_Is_Other_Player_Here

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

Func Out($TEXT)
	;If $BOTRUNNING Then FileWriteLine($FLOG, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

Func _exit()
	Exit
EndFunc

Func TimeUpdater()
	Local $WeakCounter, $Sec, $Min, $Hour, $L_Sec, $L_Min, $L_Hour
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
EndFunc   ;==>TimeUpdater

#Region Running in Towns
Func MapTemple()
;~ Checks if you are already in Temple of the Ages, if not then you travel to Temple of the Ages
	If GetMapID() <> $MAP_ID_TEMPLE_OF_AGES Then
		Out("Off to Temple of the Ages")
		RndTravel($MAP_ID_TEMPLE_OF_AGES)
		WaitMapLoading($MAP_ID_TEMPLE_OF_AGES, 5000)
	EndIf

	pconsScanInventory()
	Sleep(GetPing()+500)

	EnterFissureTemple()

EndFunc

Func MapChantry()
;~ Checks if you are already in Chantry of Secrets, if not then you travel to Chantry of Secrets
	If GetMapID() <> $MAP_ID_CHANTRY_OF_SECRETS Then
		Out("Off to Chantry of Secrets")
		RndTravel($MAP_ID_CHANTRY_OF_SECRETS)
		WaitMapLoading($MAP_ID_CHANTRY_OF_SECRETS, 5000)
	EndIf

	pconsScanInventory()
	Sleep(GetPing()+500)

	EnterFissureChantry()

EndFunc

Func MapZinKu()
;~ Checks if you are already in Zin Ku Corridor, if not then you travel to Zin Ku Corridor
	If GetMapID() <> $MAP_ID_ZIN_KU_CORRIDOR Then
		Out("Off to Zin Ku Corridor")
		RndTravel($MAP_ID_ZIN_KU_CORRIDOR)
		WaitMapLoading($MAP_ID_ZIN_KU_CORRIDOR, 5000)
	EndIf

	pconsScanInventory()
	Sleep(GetPing()+500)

	EnterFissureZinKuCorridor()

EndFunc

Func EnterFissureTemple()
;~ Checks to see if I can pay the toll, if not it withdraws 20k
	If Not GoldCheck() Then Return

;~Running to the Shrine
	Out("Running to Shrine")
	TravelToPortalToA()
	Sleep(GetPing()+500)

;~ popping the Ghost and Entering Fissure
	Local $Avatar
	$Avatar = GetNearestNPCToCoords(-2429, 18753)	; try to get the avatar, might be there already.
	If DllStructGetData($Avatar, "PlayerNumber") <> $MODELID_CHAMPION_OF_BALTHAZAR Then		; nope avatar is not there, spawn him.
		Out("Spawning Balthazar")
		SendChat("kneel", "/")
		Local $lDeadlock = TimerInit()
		Do
			Sleep(1500)	; wait until Balthazar is up.
			$Avatar = GetNearestNPCToCoords(-2429, 18753)

			If TimerDiff($lDeadlock) > 5000 Then
				MoveTo(-2537, 18786)
				SendChat("kneel", "/")
				$lDeadlock = TimerInit()
			EndIf

		Until DllStructGetData($Avatar, "PlayerNumber") == $MODELID_CHAMPION_OF_BALTHAZAR ; TODO: make a deadlock check
	EndIf

	Out("Paying the Toll")
	GoNpc($Avatar)
    Sleep(GetPing()+500)
	Dialog(0x85) ; "yes, to the service of balthazar"
	Sleep(GetPing()+500)
	DIALOG(0x86) ; "accept"

	Out("Waiting for Fissure to load")
	WaitMapLoading($MAP_ID_FISSURE_OF_WOE, 1000)

	If GetMapID() == $MAP_ID_TEMPLE_OF_AGES Then Return ; dialogs to enter Fissure failed. restart.

	WaitMapLoading($MAP_ID_TEMPLE_OF_AGES, 2000)
EndFunc   ;==>Enter Fissure from Temple of the Ages

Func EnterFissureChantry()
;~ Checks to see if I can pay the toll, if not it withdraws 20k
	If Not GoldCheck() Then Return

;~Running to the Shrine
	Out("Running to Shrine")
	TravelToPortalChantry()
	Sleep(GetPing()+500)

;~ popping the Ghost and Entering Fissure
	Local $Avatar
	$Avatar = GetNearestNPCToCoords(-9865, 992)	; try to get the avatar, might be there already.
	If DllStructGetData($Avatar, "PlayerNumber") <> $MODELID_CHAMPION_OF_BALTHAZAR Then		; nope avatar is not there, spawn him.
		Out("Spawning Balthazar")
		SendChat("kneel", "/")
		Local $lDeadlock = TimerInit()
		Do
			Sleep(1500)	; wait until Balthazar is up.
			$Avatar = GetNearestNPCToCoords(-9865, 992)

			If TimerDiff($lDeadlock) > 5000 Then
				MoveTo(-9985, 1096)
				SendChat("kneel", "/")
				$lDeadlock = TimerInit()
			EndIf

		Until DllStructGetData($Avatar, "PlayerNumber") == $MODELID_CHAMPION_OF_BALTHAZAR ; TODO: make a deadlock check
	EndIf

	Out("Paying the Toll")
	GoNpc($Avatar)
    Sleep(GetPing()+500)
	Dialog(0x85) ; "yes, to the service of balthazar"
	Sleep(GetPing()+500)
	DIALOG(0x86) ; "accept"

	Out("Waiting for Fissure to load")
	WaitMapLoading($MAP_ID_FISSURE_OF_WOE, 1000)

	If GetMapID() == $MAP_ID_CHANTRY_OF_SECRETS Then Return ; dialogs to enter Fissure failed. restart.

	WaitMapLoading($MAP_ID_CHANTRY_OF_SECRETS, 2000)
EndFunc   ;==>Enter Fissure from Chantry of Secrets

Func EnterFissureZinKuCorridor()
;~ Checks to see if I can pay the toll, if not it withdraws 20k
	If Not GoldCheck() Then Return

;~Running to the Shrine
	Out("Running to Shrine")
	TravelToPortalZinKu()
	Sleep(GetPing()+500)

;~ popping the Ghost and Entering Fissure
	Local $Avatar
	$Avatar = GetNearestNPCToCoords(-1199, -16655)	; try to get the avatar, might be there already.
	If DllStructGetData($Avatar, "PlayerNumber") <> $MODELID_CHAMPION_OF_BALTHAZAR Then		; nope avatar is not there, spawn him.
		Out("Spawning Balthazar")
		SendChat("kneel", "/")
		Local $lDeadlock = TimerInit()
		Do
			Sleep(1500)	; wait until Balthazar is up.
			$Avatar = GetNearestNPCToCoords(-1199, -16655)

			If TimerDiff($lDeadlock) > 5000 Then
				MoveTo(-1188, -16527)
				SendChat("kneel", "/")
				$lDeadlock = TimerInit()
			EndIf

		Until DllStructGetData($Avatar, "PlayerNumber") == $MODELID_CHAMPION_OF_BALTHAZAR ; TODO: make a deadlock check
	EndIf

	Out("Paying the Toll")
	GoNpc($Avatar)
    Sleep(GetPing()+500)
	Dialog(0x85) ; "yes, to the service of balthazar"
	Sleep(GetPing()+500)
	DIALOG(0x86) ; "accept"

	Out("Waiting for Fissure to load")
	WaitMapLoading($MAP_ID_FISSURE_OF_WOE, 1000)

	If GetMapID() == $MAP_ID_CHANTRY_OF_SECRETS Then Return ; dialogs to enter Fissure failed. restart.

	WaitMapLoading($MAP_ID_CHANTRY_OF_SECRETS, 2000)
EndFunc   ;==>Enter Fissure from Chantry of Secrets

Func Waypoint1()
	MoveTo(-4147, 18067)
	MoveTo(-3660, 17761)
	MoveTo(-2912, 18381)
	MoveTo(-2537, 18786) ; Kneel spot
EndFunc

Func Waypoint2()
	MoveTo(-3660, 17761)
	MoveTo(-2912, 18381)
	MoveTo(-2537, 18786) ; Kneel spot
EndFunc

Func Waypoint3()
	MoveTo(-3581, 17573)
	MoveTo(-2912, 18381)
	MoveTo(-2537, 18786) ; Kneel spot
EndFunc

Func Waypoint1Chantry()
	MoveTo(-9985, 1096) ; Kneel spot
EndFunc

Func Waypoint2Chantry()
	MoveTo(-9985, 1096) ; Kneel spot
EndFunc

Func Waypoint3Chantry()
	MoveTo(-9985, 1096) ; Kneel spot
EndFunc

Func Waypoint1ZinKu()
	MoveTo(7451, -17545)
	MoveTo(6907, -17479)
	MoveTo(4870, -17425)
	MoveTo(2336, -17533)
	MoveTo(-1848, -17493)
	MoveTo(-2639, -15983)
	MoveTo(-1225, -16116)
	MoveTo(-1188, -16527) ; Kneel spot
EndFunc

Func Waypoint2ZinKu()
	MoveTo(7451, -17545)
	MoveTo(6907, -17479)
	MoveTo(4870, -17425)
	MoveTo(2336, -17533)
	MoveTo(-1848, -17493)
	MoveTo(-2639, -15983)
	MoveTo(-1225, -16116)
	MoveTo(-1188, -16527) ; Kneel spot
EndFunc

Func Waypoint3ZinKu()
	MoveTo(6907, -17479)
	MoveTo(4870, -17425)
	MoveTo(2336, -17533)
	MoveTo(-1848, -17493)
	MoveTo(-2639, -15983)
	MoveTo(-1225, -16116)
	MoveTo(-1188, -16527) ; Kneel spot
EndFunc

Func TravelToPortalToA()
	Local $Skip = False
	If CHECKAREA(-4922, 18965) Then
		OUT("Start Point 1")
		If Waypoint1() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(-5059, 17370) Then
		OUT("Start Point 2")
		If Waypoint2() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(-3581, 17573) Then
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
EndFunc   ;==>TravelToPortal Temple of the Ages

Func TravelToPortalChantry()
	Local $Skip = False
	If CHECKAREA(-10042, 126) Then
		OUT("Start Point 1")
		If Waypoint1Chantry() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(-12203, 382) Then
		OUT("Start Point 2")
		If Waypoint2Chantry() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(-11549, 2158) Then ; -11589, 2224
		OUT("Start Point 3")
		If Waypoint3Chantry() Then
			Return True
		Else
			Return False
		EndIf
	Else
		OUT("Where the fuck am I?")
		Return False
	EndIf
EndFunc   ;==>TravelToPortal Chantry of Secrets

Func TravelToPortalZinKu()
	Local $Skip = False
	If CHECKAREA(9047, -17228) Then
		OUT("Start Point 1")
		If Waypoint1ZinKu() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(8473, -18234) Then
		OUT("Start Point 2")
		If Waypoint2ZinKu() Then
			Return True
		Else
			Return False
		EndIf
	ElseIf CHECKAREA(7451, -17545) Then
		OUT("Start Point 3")
		If Waypoint3ZinKu() Then
			Return True
		Else
			Return False
		EndIf
	Else
		OUT("Where the fuck am I?")
		Return False
	EndIf
EndFunc   ;==>TravelToPortal Zin Ku Corridor

Func CheckArea($AX, $AY)
	Local $RET = False
	Local $PX = DllStructGetData(GetAgentByID(-2), "X")
	Local $PY = DllStructGetData(GetAgentByID(-2), "Y")
	If ($PX < $AX + 500) And ($PX > $AX - 500) And ($PY < $AY + 500) And ($PY > $AY - 500) Then
		$RET = True
	EndIf
	Return $RET
EndFunc   ;==>CHECKAREA
#EndRegion Running in Towns

#EndRegion Bot Functions

#Region PickUp
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

Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $aExtraID = DllStructGetData($aItem, "ExtraID")
	Local $lRarity = GetRarity($aItem)
	Local $Requirement = GetItemReq($aItem)
	If (($lModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	ElseIf ($lModelID == $ITEM_ID_DYES) Then	; if dye
		If (($aExtraID == $ITEM_EXTRAID_BLACKDYE) Or ($aExtraID == $ITEM_EXTRAID_WHITEDYE))Then ; only pick white and black ones
			Return True
		EndIf
	ElseIf ($lRarity == $RARITY_GOLD) Then ; gold items
		Return True
	ElseIf($lModelID == $ITEM_ID_LOCKPICKS)Then
		Return True ; Lockpicks
	Elseif($lModelID == 5971)Then
		Return True ; Obsidian Keys
	ElseIf($lModelID == $ITEM_ID_DARK_REMAINS)Then
		Return True ; Dark Remains
	ElseIf CheckArrayPscon($lModelID)Then ; ==== Pcons ==== or all event items
		Return True
	ElseIf CheckArrayMaterials($lModelID)Then ; ==== Materials ====
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CanPickUp

Func CheckArrayPscon($lModelID)
For $p = 0 To (UBound($Array_pscon) -1)
	If ($lModelID == $Array_pscon[$p]) Then Return True
Next
EndFunc

Func CheckArrayMaterials($lModelID)
For $p = 0 To (UBound($Material_Array) -1)
	If ($lModelID == $Material_Array[$p]) Then Return True
Next
EndFunc
#EndRegion Pickup

#Region Inventory
Func Inventory()
;~ Opening the Chest
	Out("Going to Xunlai Chest.")
	Chest()

	If GetGoldCharacter() > 90000 Then
		Out("Depositing Gold")
		DepositGold()
	EndIf

;~ Storing things I want to keep
	Out("Storing Stuff")
	StoreItems()
	StoreMaterials()
	StoreUNIDGolds()

;~ Opening the Merchant
	Out("Going to Merchant.")
	Merchant()

	Out("Identifying")
;~ Identifies each bag
	Local $i
	For $i = 1 To $Bags
		Out("Identifying bag " & $i & ".")
		If (FindIDKit() == 0) Then
			If GetGoldCharacter() < 500 And GetGoldStorage() > 499 Then
				WithdrawGold(500)
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
		IdentifyBag($i, False, True)
		Sleep(GetPing()+100)
	Next

	Out("Selling")
;~ Sells each bag
	Sell(1)
	Sell(2)
	Sell(3)
	Sell(4)

EndFunc

Func Sell($BAGINDEX)
	Local $AITEM
	Local $BAG = GetBag($BAGINDEX)
	Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
	For $I = 1 To $NUMOFSLOTS
		Out("Selling item: " & $BAGINDEX & ", " & $I)
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CanSell($AITEM) Then
			SellItem($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func CanSell($aItem)
	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $LRARITY = GetRarity($aitem)
	Local $Requirement = GetItemReq($aItem)
	If $LRARITY == $RARITY_GOLD Then
		Return True
	EndIf
	If $LRARITY == $RARITY_PURPLE Then
		Return True
	EndIf
;~ Leaving Blues and Whites as false for now. Going to make it salvage them at some point in the future. It does not currently pick up whites or blues
	If $LRARITY == $RARITY_BLUE Then
		Return False
	EndIf
	If $LRARITY == $RARITY_WHITE Then
		Return False
	EndIf
	If $LMODELID == $ITEM_ID_DYES Then
		Switch DllStructGetData($aitem, "ExtraID")
			Case $ITEM_EXTRAID_BLACKDYE, $ITEM_EXTRAID_WHITEDYE
				Return False
			Case Else
				Return True
		EndSwitch
	EndIf
	If $lModelID > 21785 And $lModelID < 21806 			Then Return False ; Elite/Normal Tomes
	If $lModelID > 920 And $lModelID < 957				Then Return False ; Materials
	If $lModelID > 6531 And $lModelID < 6534			Then Return False ; Amber and Jade
	; ==== Inscriptions ====
	If $lModelID == $ITEM_ID_INSCRIPTIONS_MARTIAL		Then Return False ; Martial Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_FOCUS_SHIELD	Then Return False ; Focus Items or Shields
	If $lModelID == $ITEM_ID_INSCRIPTIONS_ALL			Then Return False ; All Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_GENERAL		Then Return False ; General
	If $lModelID == $ITEM_ID_INSCRIPTIONS_SPELLCASTING	Then Return False ; Spellcasting Weapons
	If $lModelID == $ITEM_ID_INSCRIPTIONS_FOCUS_ITEMS	Then Return False ; Focus Items
	; ==== Weapon Mods ====
	If $lModelID == $ITEM_ID_STAFF_HEAD					Then Return False ; All Staff heads
	If $lModelID == $ITEM_ID_STAFF_WRAPPING				Then Return False ; All Staff wrappings
	If $lModelID == $ITEM_ID_SHIELD_HANDLE				Then Return False ; All Shield Handles
	If $lModelID == $ITEM_ID_FOCUS_CORE					Then Return False ; All Focus Cores
	If $lModelID == $ITEM_ID_WAND						Then Return False ; All Wands
	If $lModelID == $ITEM_ID_BOW_STRING					Then Return False ; All Bow strings
	If $lModelID == $ITEM_ID_BOW_GRIP					Then Return False ; All Bow grips
	If $lModelID == $ITEM_ID_SWORD_HILT					Then Return False ; All Sword hilts
	If $lModelID == $ITEM_ID_SWORD_POMMEL				Then Return False ; All Sword pommels
	If $lModelID == $ITEM_ID_AXE_HAFT					Then Return False ; All Axe hafts
	If $lModelID == $ITEM_ID_AXE_GRIP					Then Return False ; All Axe grips
	If $lModelID == $ITEM_ID_DAGGER_TANG				Then Return False ; All Dagger tangs
	If $lModelID == $ITEM_ID_DAGGER_HANDLE				Then Return False ; All Dagger handles
	If $lModelID == $ITEM_ID_HAMMER_HAFT				Then Return False ; All Hammer hafts
	If $lModelID == $ITEM_ID_HAMMER_GRIP				Then Return False ; All Hammer grips
	If $lModelID == $ITEM_ID_SCYTHE_SNATHE				Then Return False ; All Scythe snathes
	If $lModelID ==	$ITEM_ID_SCYTHE_GRIP				Then Return False ; All Scythe grips
	If $lModelID == $ITEM_ID_SPEARHEAD					Then Return False ; All Spearheads
	If $lModelID == $ITEM_ID_SPEAR_GRIP					Then Return False ; All Spear grips
	; ==== General ====
	If $lModelID == $ITEM_ID_ID_KIT						Then Return False
	If $lModelID == $ITEM_ID_SUP_ID_KIT					Then Return False
	If $lModelID == $ITEM_ID_SALVAGE_KIT				Then Return False
	If $lModelID == $ITEM_ID_EXP_SALVAGE_KIT			Then Return False
	If $lModelID == $ITEM_ID_SUP_SALVAGE_KIT			Then Return False
	If $lModelID == $ITEM_ID_LOCKPICKS 					Then Return False
	If $lModelID == $ITEM_ID_DARK_REMAINS				Then Return False
	; ==== Alcohol ====
	If $lModelID == $ITEM_ID_HUNTERS_ALE				Then Return False
	If $lModelID == $ITEM_ID_DWARVEN_ALE				Then Return False
	If $lModelID == $ITEM_ID_SPIKED_EGGNOG				Then Return False
	If $lModelID == $ITEM_ID_EGGNOG						Then Return False
	If $lModelID == $ITEM_ID_SHAMROCK_ALE				Then Return False
	If $lModelID == $ITEM_ID_AGED_DWARVEN_ALE			Then Return False
	If $lModelID == $ITEM_ID_CIDER						Then Return False
	If $lModelID == $ITEM_ID_GROG 						Then Return False
	If $lModelID == $ITEM_ID_AGED_HUNTERS_ALE			Then Return False
	If $lModelID == $ITEM_ID_KRYTAN_BRANDY				Then Return False
	If $lModelID == $ITEM_ID_BATTLE_ISLE_ICED_TEA		Then Return False
	; ==== Party ====
	If $lModelID == $ITEM_ID_SNOWMAN_SUMMONER			Then Return False
	If $lModelID == $ITEM_ID_ROCKETS					Then Return False
	If $lModelID == $ITEM_ID_POPPERS					Then Return False
	If $lModelID == $ITEM_ID_SPARKLER					Then Return False
	If $lModelID == $ITEM_ID_PARTY_BEACON				Then Return False
	; ==== Sweets ====
	If $lModelID == $ITEM_ID_FRUITCAKE					Then Return False
	If $lModelID == $ITEM_ID_BLUE_DRINK					Then Return False
	If $lModelID == $ITEM_ID_CUPCAKES					Then Return False
	If $lModelID == $ITEM_ID_BUNNIES 					Then Return False
	If $lModelID == $ITEM_ID_GOLDEN_EGGS 				Then Return False
	If $lModelID == $ITEM_ID_PIE						Then Return False
	; ==== Tonics ====
	If $lModelID == $ITEM_ID_TRANSMOGRIFIER				Then Return False
	If $lModelID == $ITEM_ID_YULETIDE					Then Return False
	If $lModelID == $ITEM_ID_FROSTY						Then Return False
	If $lModelID == $ITEM_ID_MISCHIEVIOUS				Then Return False
	; ==== DP Removal ====
	If $lModelID == $ITEM_ID_PEPPERMINT_CC				Then Return False
	If $lModelID == $ITEM_ID_WINTERGREEN_CC				Then Return False
	If $lModelID == $ITEM_ID_RAINBOW_CC					Then Return False
	If $lModelID == $ITEM_ID_CLOVER 					Then Return False
	If $lModelID == $ITEM_ID_HONEYCOMB					Then Return False
	If $lModelID == $ITEM_ID_PUMPKIN_COOKIE				Then Return False
	; ==== Special Drops ====
	If $lModelID == $ITEM_ID_CC_SHARDS					Then Return False
	If $lModelID == $ITEM_ID_VICTORY_TOKEN				Then Return False
	If $lModelID == $ITEM_ID_WINTERSDAY_GIFT			Then Return False
	If $lModelID == $ITEM_ID_TOTS 						Then Return False
	If $lModelID == $ITEM_ID_LUNAR_TOKEN				Then Return False
	If $lModelID == $ITEM_ID_LUNAR_TOKENS				Then Return False
	If $lModelID == $ITEM_ID_WAYFARER_MARK				Then Return False
	; ==== Stackable Drops ====
	If $lModelID == $ITEM_ID_DARK_REMAINS				Then Return False
	Return True
EndFunc   ;==>CANSELL

Func Chest()
	Dim $Waypoints_by_XunlaiChest[3][3] = [ _
			[$MAP_ID_TEMPLE_OF_AGES, -6764, 18679], _
			[$MAP_ID_CHANTRY_OF_SECRETS, -11835, 2757], _
			[$MAP_ID_ZIN_KU_CORRIDOR, 8027, -18227]]
	For $i = 0 To (UBound($Waypoints_by_XunlaiChest) - 1)
		If ($Waypoints_by_XunlaiChest[$i][0] == True) Then
			Do
				GenericRandomPath($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2], Random(60, 80, 2))
			Until CheckArea($Waypoints_by_XunlaiChest[$i][1], $Waypoints_by_XunlaiChest[$i][2])
			Local $aChestName = "Xunlai Chest"
			Local $lChest = GetAgentByName($aChestName)
			If IsDllStruct($lChest)Then
				OUT("Going to " & $aChestName)
				GoToNPC($lChest)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Xunlai Chest

Func Merchant()
	Dim $Waypoints_by_Merchant[3][3] = [ _
			[$MAP_ID_TEMPLE_OF_AGES, -5048, 19468], _
			[$MAP_ID_CHANTRY_OF_SECRETS, -11081, 2143], _
			[$MAP_ID_ZIN_KU_CORRIDOR, 11040, -18944]]
	For $i = 0 To (UBound($Waypoints_by_Merchant) - 1)
		If ($Waypoints_by_Merchant[$i][0] == True) Then
			Do
				GenericRandomPath($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2], Random(60, 80, 2))
			Until CheckArea($Waypoints_by_Merchant[$i][1], $Waypoints_by_Merchant[$i][2])
			Local $aMerchName = "Merchant"
			Local $lMerch = GetAgentByName($aMerchName)
			If IsDllStruct($lMerch)Then
				OUT("Going to " & $aMerchName)
				GoToNPC($lMerch)
				RndSleep(Random(3000, 4200))
			EndIf
		EndIf
	Next
EndFunc   ;~ Merchant

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

Func StackableDrops($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 522) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ like Suarian Bones, lockpicks, Glacial Stones, etc

Func Alcohol($BAGINDEX, $NUMOFSLOTS)
	Local $AITEM
	Local $M
	Local $Q
	Local $bag
	Local $SLOT
	Local $FULL
	Local $NSLOT
	For $I = 1 To $NUMOFSLOTS
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 910 Or $M = 2513 Or $M = 5585 Or $M = 6049 Or $M = 6367 Or $M = 6375 Or $M = 15477 Or $M = 19171 Or $M = 22190 Or $M = 36682) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6376 Or $M = 6368 Or $M = 6369 Or $M = 21809 Or $M = 21810 Or $M = 21813 Or $M = 29436 Or $M = 29543 Or $M = 36683 Or $M = 4730 Or $M = 15837 Or $M = 21490 Or $M = 22192 Or $M = 30626 Or $M = 30630 Or $M = 30638 Or $M = 30642 Or $M = 30646 Or $M = 30648 Or $M = 31020 Or $M = 31141 Or $M = 31142 Or $M = 31144 Or $M = 31172) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 15528 Or $M = 15479 Or $M = 19170 Or $M = 21492 Or $M = 21812 Or $M = 22269 Or $M = 22644 Or $M = 22752 Or $M = 28436 Or $M = 31150 Or $M = 35125 Or $M = 36681) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 22280) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 6370 Or $M = 21488 Or $M = 21489 Or $M = 22191 Or $M = 35127 Or $M = 26784 Or $M = 28433) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = 18345 Or $M = 28434) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$M = DllStructGetData($AITEM, "ModelID")
		$Q = DllStructGetData($AITEM, "quantity")
		If ($M = $ITEM_ID_OBSIDIAN_SHARD Or $M = $ITEM_ID_RUBY Or $M = $ITEM_ID_SAPPHIRE) And $Q = 250 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
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
		$AITEM = GetItemBySlot($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		$R = GetRarity($AITEM)
		$M = DllStructGetData($AITEM, "ModelID")
		If $M = 22280 Then
			Return False
		ElseIf $R = 2624 Then
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
				MoveItem($AITEM, $BAG, $NSLOT)
				Sleep(GetPing()+500)
			EndIf
		EndIf
	Next
EndFunc ;~ UNID golds
#CS
Func UnStore()
     For $i = 8 to 16
          StoreChest($i)
     Next
EndFunc

Func StoreChest($aBag)
	Out("UnStoring chest " & $aBag & ".")
	If Not IsDllStruct($aBag) Then $aBag = GetBag($aBag)
	Local $lItem = GetItemBySlot($aBag, $i)
	Local $lSlot
	Local $Stockable = False
	Local $q = DllStructGetDada($lItem, 'Quantity')
	Local $m = DllStructGetData($lItem, 'ModelID')
	Local $r = GetRarity($lItem)
	Local $i
	If IsInvFull() Then
		$BotRunning = False
	EndIf

	For $i = 1 To DllStructGetData($aBag, 'Slots')
		If $BotRunning = False Then
			ExitLoop
		EndIf

		If DllStructGetData($lItem, 'id') == 0 Then ContinueLoop
			If _ArraySearch($ArrayModelIDInv, $m) <> -1 Then
				$stockable = True
			If $stockable == True and $q == 250 Then
				$lSlot = OpenInventorySlot()
			If IsArray($lSlot) Then
				MoveItem($lItem, $lSlot[0], $lSlot[1])
				Sleep(GetPing() + Random(500, 750, 1))
				$BotRunning = false
			EndIf
		EndIf
	Next
EndFunc
#CE
Func FindEmptySlot($BAGINDEX)
	Local $LITEMINFO, $ASLOT
	For $ASLOT = 1 To DllStructGetData(GetBag($BAGINDEX), "Slots")
		Sleep(40)
		$LITEMINFO = GetItemBySlot($BAGINDEX, $ASLOT)
		If DllStructGetData($LITEMINFO, "ID") = 0 Then
			SetExtended($ASLOT)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc

Func OpenStorageSlot()
	Local $lBag
	Local $lReturnArray[2]

	For $i = 8 To 16
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
				$lReturnArray[0] = $i
				$lReturnArray[1] = $j
				Return $lReturnArray
			EndIf
		Next
	Next
EndFunc   ;==>OpenStorageSlot

Func OpenInventorySlot()
	Local $lBag
	Local $lReturnArray[2]
	Local $j
	For $i = 1 To 4
	$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			If DllStructGetData(GetItemBySlot($lBag, $j), 'ID') == 0 Then
				$lReturnArray[0] = $i
				$lReturnArray[1] = $j
				Return $lReturnArray
			EndIf
		Next
	Next
EndFunc

Func FindStorageStack($aModelID, $aExtraID)
	Local $lBag
	Local $lReturnArray[2]
	Local $lItem

	For $i = 6 To 16
		If $i == 7 Then ContinueLoop
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			If DllStructGetData($lItem, 'ModelID') == $aModelID And DllStructGetData($lItem, 'ExtraID') == $aExtraID And DllStructGetData($lItem, 'Quantity') < 250 Then
				$lReturnArray[0] = $i
				$lReturnArray[1] = $j
				Return $lReturnArray
			EndIf
		Next
	Next
EndFunc

Func FindInventoryStack($aModelID, $aExtraID)
	Local $lBag
	Local $lReturnArray[2]
	Local $lItem

	For $i = 1 To 4
		$lBag = GetBag($i)
		For $j = 1 To DllStructGetData($lBag, 'Slots')
			$lItem = GetItemBySlot($lBag, $j)
			If DllStructGetData($lItem, 'ModelID') == $aModelID And DllStructGetData($lItem, 'ExtraID') == $aExtraID And DllStructGetData($lItem, 'Quantity') < 250 Then
				$lReturnArray[0] = $i
				$lReturnArray[1] = $j
				Return $lReturnArray
			EndIf
		Next
	Next
 EndFunc

Func IsInvFull()
   If CountInvSlots() = 0 Then
	  Out("Inventory Full")
	  Return True
   EndIf
   Return False
EndFunc

; Counts open slot in your Imventory
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

; Counts open slots in the storage chest
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
EndFunc   ;==>CountSlots
#EndRegion Storing Stuff
#EndRegion Inventory

#Region Pcons
Func UseAlcohol()
	If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
		If $pconsSpiked_Eggnog_slot[0] > 0 And $pconsSpiked_Eggnog_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsSpiked_Eggnog_slot[0], $pconsSpiked_Eggnog_slot[1]), "ModelID") == $ITEM_ID_SPIKED_EGGNOG Then
				UseItemBySlot($pconsSpiked_Eggnog_slot[0], $pconsSpiked_Eggnog_slot[1])
			EndIf
		ElseIf $pconsAged_Dwarven_Ale_slot[0] > 0 And $pconsAged_Dwarven_Ale_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsAged_Dwarven_Ale_slot[0], $pconsAged_Dwarven_Ale_slot[1]), "ModelID") == $ITEM_ID_AGED_DWARVEN_ALE Then
				UseItemBySlot($pconsAged_Dwarven_Ale_slot[0], $pconsAged_Dwarven_Ale_slot[1])
			EndIf
		ElseIf $pconsGrog_slot[0] > 0 And $pconsGrog_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsGrog_slot[0], $pconsGrog_slot[1]), "ModelID") == $ITEM_ID_GROG Then
				UseItemBySlot($pconsGrog_slot[0], $pconsGrog_slot[1])
			EndIf
		ElseIf $pconsHard_Apple_Cider_slot[0] > 0 And $pconsHard_Apple_Cider_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsHard_Apple_Cider_slot[0], $pconsHard_Apple_Cider_slot[1]), "ModelID") == $ITEM_ID_CIDER Then
				UseItemBySlot($pconsHard_Apple_Cider_slot[0], $pconsHard_Apple_Cider_slot[1])
			EndIf
		ElseIf $pconsAged_Hunters_Ale_slot[0] > 0 And $pconsAged_Hunters_Ale_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsAged_Hunters_Ale_slot[0], $pconsAged_Hunters_Ale_slot[1]), "ModelID") == $ITEM_ID_AGED_HUNTERS_ALE Then
				UseItemBySlot($pconsAged_Hunters_Ale_slot[0], $pconsAged_Hunters_Ale_slot[1])
			EndIf
		ElseIf $pconsKrytan_Brandy_slot[0] > 0 And $pconsKrytan_Brandy_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsKrytan_Brandy_slot[0], $pconsKrytan_Brandy_slot[1]), "ModelID") == $ITEM_ID_KRYTAN_BRANDY Then
				UseItemBySlot($pconsKrytan_Brandy_slot[0], $pconsKrytan_Brandy_slot[1])
			EndIf
		EndIf
	EndIf
EndFunc

Func UseWarSupply()
	If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
		If $pconsWar_Supply_slot[0] > 0 And $pconsWar_Supply_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsWar_Supply_slot[0], $pconsWar_Supply_slot[1]), "ModelID") == $ITEM_ID_WAR_SUPPLY Then
				UseItemBySlot($pconsWar_Supply_slot[0], $pconsWar_Supply_slot[1])
			EndIf
		EndIf
	EndIf
EndFunc

Func UseCandyApple()
	If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
		If $pconsCandy_Apple_slot[0] > 0 And $pconsCandy_Apple_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsCandy_Apple_slot[0], $pconsCandy_Apple_slot[1]), "ModelID") == $ITEM_ID_CANDY_APPLE Then
				UseItemBySlot($pconsCandy_Apple_slot[0], $pconsCandy_Apple_slot[1])
			EndIf
		EndIf
	EndIf
EndFunc

Func UseCandyCorn()
	If (GetMapLoading() == 1) And (GetIsDead(-2) == False) Then
		If $pconsCandy_Corn_slot[0] > 0 And $pconsCandy_Corn_slot[1] > 0 Then
			If DllStructGetData(GetItemBySlot($pconsCandy_Corn_slot[0], $pconsCandy_Corn_slot[1]), "ModelID") == $ITEM_ID_CANDY_CORN Then
				UseItemBySlot($pconsCandy_Corn_slot[0], $pconsCandy_Corn_slot[1])
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
	$pconsCandy_Apple_slot[0] = $pconsCandy_Apple_slot[1] = 0
	$pconsCandy_Corn_slot[0] = $pconsCandy_Corn_slot[1] = 0
	$pconsSpiked_Eggnog_slot[0] = $pconsSpiked_Eggnog_slot[1] = 0
	$pconsAged_Dwarven_Ale_slot[0] = $pconsAged_Dwarven_Ale_slot[1] = 0
	$pconsGrog_slot[0] = $pconsGrog_slot[1] = 0
	$pconsAged_Hunters_Ale_slot[0] = $pconsAged_Hunters_Ale_slot[1] = 0
	$pconsKrytan_Brandy_slot[0] = $pconsKrytan_Brandy_slot[1] = 0
	$pconsHard_Apple_Cider_slot[0] = $pconsHard_Apple_Cider_slot[1] = 0
	$pconsWar_Supply_slot[0] = $pconsWar_Supply_slot[1] = 0
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
				Case $ITEM_ID_SPIKED_EGGNOG
					$pconsSpiked_Eggnog_slot[0] = $bag
					$pconsSpiked_Eggnog_slot[1] = $slot
				Case $ITEM_ID_AGED_DWARVEN_ALE
					$pconsAged_Dwarven_Ale_slot[0] = $bag
					$pconsAged_Dwarven_Ale_slot[1] = $slot
				Case $ITEM_ID_GROG
					$pconsGrog_slot[0] = $bag
					$pconsGrog_slot[1] = $slot
				Case $ITEM_ID_CIDER
					$pconsHard_Apple_Cider_slot[0] = $bag
					$pconsHard_Apple_Cider_slot[1] = $slot
				Case $ITEM_ID_AGED_HUNTERS_ALE
					$pconsAged_Hunters_Ale_slot[0] = $bag
					$pconsAged_Hunters_Ale_slot[1] = $slot
				Case $ITEM_ID_KRYTAN_BRANDY
					$pconsKrytan_Brandy_slot[0] = $bag
					$pconsKrytan_Brandy_slot[1] = $slot
				Case $ITEM_ID_WAR_SUPPLY
					$pconsWar_Supply_slot[0] = $bag
					$pconsWar_Supply_slot[1] = $slot
				Case $ITEM_ID_CANDY_APPLE
					$pconsCandy_Apple_slot[0] = $bag
					$pconsCandy_Apple_slot[1] = $slot
				Case $ITEM_ID_CANDY_CORN
					$pconsCandy_Corn_slot[0] = $bag
					$pconsCandy_Corn_slot[1] = $slot
			EndSwitch
		Next
	Next
EndFunc   ;==>pconsScanInventory

;~ Uses the Item from Use????()
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

#Region Counting
Func GetObsidianShardCount()
	Local $AAMOUNTObsidianShard
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_OBSIDIAN_SHARD Then
				$AAMOUNTObsidianShard += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTObsidianShard
EndFunc   ; Counts Obsidian Shards in your Inventory

Func GetAlcoholCountInventory()
	Local $AAMOUNTAlcohol
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == ($ITEM_ID_SPIKED_EGGNOG Or $ITEM_ID_AGED_DWARVEN_ALE or $ITEM_ID_AGED_HUNTERS_ALE Or $ITEM_ID_KRYTAN_BRANDY Or $ITEM_ID_GROG) Then
				$AAMOUNTAlcohol += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAlcohol
EndFunc   ; Counts Amount of Alcohol Shards in your Inventory

Func GetAlcoholCountChest()
	Local $AAMOUNTAlcoholChest
	Local $aBag
	Local $aItem
	Local $i
	For $i = 8 To 16
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == ($ITEM_ID_SPIKED_EGGNOG Or $ITEM_ID_AGED_DWARVEN_ALE or $ITEM_ID_AGED_HUNTERS_ALE Or $ITEM_ID_KRYTAN_BRANDY Or $ITEM_ID_GROG) Then
				$AAMOUNTAlcoholChest += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTAlcoholChest
EndFunc   ; Counts Amount of Alcohol Shards in your Storage

Func GetCandyCornCountInventory()
	Local $AAMOUNTCandyCorn
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CANDY_CORN Then
				$AAMOUNTCandyCorn += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCandyCorn
EndFunc   ; Counts Candy Corn in your Inventory

Func GetCandyCornCountChest()
	Local $AAMOUNTCandyCornChest
	Local $aBag
	Local $aItem
	Local $i
	For $i = 8 To 16
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CANDY_CORN Then
				$AAMOUNTCandyCornChest += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCandyCornChest
EndFunc   ; Counts Candy Corn in your Storage

Func GetCandyAppleCountInventory()
	Local $AAMOUNTCandyApples
	Local $aBag
	Local $aItem
	Local $i
	For $i = 1 To 4
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CANDY_APPLE Then
				$AAMOUNTCandyApples += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCandyApples
EndFunc   ; Counts Cand Apples in your Inventory

Func GetCandyAppleCountChest()
	Local $AAMOUNTCandyApplesChest
	Local $aBag
	Local $aItem
	Local $i
	For $i = 8 To 16
		$aBag = GetBag($i)
		For $j = 1 To DllStructGetData($aBag, "Slots")
			$aItem = GetItemBySlot($aBag, $j)
			If DllStructGetData($aItem, "ModelID") == $ITEM_ID_CANDY_APPLE Then
				$AAMOUNTCandyApplesChest += DllStructGetData($aItem, "Quantity")
			Else
				ContinueLoop
			EndIf
		Next
	Next
	Return $AAMOUNTCandyApplesChest
EndFunc   ; Counts Cand Apples in your Storage
#EndRegion Counting