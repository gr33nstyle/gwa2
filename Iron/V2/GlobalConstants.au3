#include-once
#include <Array.au3>
;~ #include <Gui.au3>

#Region GLOBALS
Global Const $Version = "3"
Global Const $IniPath = @ScriptDir & "\Watte.ini"
Global Const $IconPngPath = @ScriptDir & "\img\Watte.png"

Global $CharName = "Default"
;~~~~ MAPIDS
Global  $HmOrNm = 1 ; 1 = Hm , 0 = Nm
Global $SpawnPointUsingGateX = -1460  ;Spawn at using Gate in City
Global $SpawnPointUsingGateY = -890
Global $TriggerUsingGateX = -2703 ;Trigger Gate City to Area
Global $TriggerUsingGateY = -1075
;~ Global Enum $INSTANCETYPE_OUTPOST, $INSTANCETYPE_EXPLORABLE, $INSTANCETYPE_LOADING
;~ Global $INSTANCETYPE

;~~~~ SKILL SETUP
Global $primary = "assa"
Global $template = "OwVUI2h5lPP8Id2BkAiAvpLBTAA"
Global $PlayerStatus = 1  ; 0 Offline | 1 Online |2 Do not disturb | 3 Away
;~ Global $MerchOpened = False
Global $HWND

;~~~~ GUI
Global $GuiOnTop = True
Global $LootTabOpen = False
Global $RenderingEnabled = True
Global $SuccessfulRunCount = 0
Global $FailedRunCount = 0
;~ Global $FiberDropsCount = 0
;~ Global $DragonRootDropsCount = 0
Global $FinsDropsCount = 0
Global $GoldiesDropsCount = 0
Global $SharktoothShieldDropsCount = 0
Global $SkaleTeethDropsCount = 0
Global $SkaleClawDropsCount = 0
Global $LootReq0ScytheCount = 0
Global $LootIronItemsCount = 0
Global $LootGlacialStoneCount = 0

Global $BoneCount = 0

; === for Savage ===
Global $SalvageQuantity
Global $SalvageTimer = TimerInit()
Global $SalvageFiberCount = 0
Global $SalvageDustCount = 0
Global $SalvageBrambleCount = 0
Global $SalvageDragonRootCount = 0
Global $SalvageSpiritwoodCount = 0

Global $BotRunning = False
Global $BotShouldPause = False
Global $BotInitialized = False
Global $ChatStuckTimer = TimerInit()
Global $MinimizedTabs = False
Global $Show_StartTab = False
Global $Show_SalvageTab = False
Global $Show_GreenLable = False
Global $Show_RedLable = True
Global $SucessfulLastRun = 0
Global $AverageTicks = 0, $AverageTimer = 0, $Secs, $Mins, $Hour, $Time
Global $TotalTime = 0 , $TotalTimer = 0, $TotalHours = 0, $TotalMinutes = 0, $TotalSeconds = 0

Global $SalvageRunning = False

Global $ItemCount = 0
Global $MatsCount = 0  ;hier nur Knochen
Global $SalvageCount = 0
Global $IdentCount = 0

Global $GoldCount = 0

Global $LootEventItemsStruct = DllStructCreate("struct;UINT Checkbox[28]; UINT ItemID[28];UINT ItemCount[28]; UINT CountLable[28]; endstruct")
Global $LootTomesStruct = DllStructCreate("struct;UINT Checkbox[20]; UINT ItemID[20];UINT ItemCount[20]; UINT CountLable[20]; endstruct")
Global $LootDyeStruct = DllStructCreate("struct;UINT Checkbox[12]; UINT ItemID[12];UINT ItemExtraID[12]; UINT ItemCount[12]; UINT CountLable[12]; endstruct")

DllStructSetData($LootEventItemsStruct,"ItemID",22269,1) 	;birthday cupcake = 22269
DllStructSetData($LootEventItemsStruct,"ItemID",22644,2) 	;chocolate bunny
DllStructSetData($LootEventItemsStruct,"ItemID",36681,3) 	;delicious cake
DllStructSetData($LootEventItemsStruct,"ItemID",21492,4) 	;fruitcake
DllStructSetData($LootEventItemsStruct,"ItemID",22752,5) 	;golden egg
DllStructSetData($LootEventItemsStruct,"ItemID",28436,6) 	;slice of pumpkin pie
DllStructSetData($LootEventItemsStruct,"ItemID",21812,7) 	;sugary blue drink
DllStructSetData($LootEventItemsStruct,"ItemID",36682,8) 	;battle of isle iced tea
DllStructSetData($LootEventItemsStruct,"ItemID",30855,9) 	;gottle of grog
DllStructSetData($LootEventItemsStruct,"ItemID",6375,10)	;eggnog-----------not checked
DllStructSetData($LootEventItemsStruct,"ItemID",28435,11) 	;hard apple cider
DllStructSetData($LootEventItemsStruct,"ItemID",910,12)		;hunter's ale
DllStructSetData($LootEventItemsStruct,"ItemID",35124,13) 	;krytan brandy
DllStructSetData($LootEventItemsStruct,"ItemID",22190,14) 	;shamrock ale
DllStructSetData($LootEventItemsStruct,"ItemID",21809,15) 	;bottle rocket
DllStructSetData($LootEventItemsStruct,"ItemID",22269,16) 	;candy cane shard---------wrong
DllStructSetData($LootEventItemsStruct,"ItemID",21810,17) 	;champagne popper
DllStructSetData($LootEventItemsStruct,"ItemID",30648,18) 	;frosty tonic
DllStructSetData($LootEventItemsStruct,"ItemID",31020,19) 	;mischievous tonic
DllStructSetData($LootEventItemsStruct,"ItemID",36683,20) 	;party beacon
DllStructSetData($LootEventItemsStruct,"ItemID",6376,21) 	;snowman summoner------------not checked
DllStructSetData($LootEventItemsStruct,"ItemID",21813,22) 	;sparkler
DllStructSetData($LootEventItemsStruct,"ItemID",22191,23) 	;four-leave clover
DllStructSetData($LootEventItemsStruct,"ItemID",26784,24) 	;honeycomb
DllStructSetData($LootEventItemsStruct,"ItemID",21833,25) 	;lunar token
DllStructSetData($LootEventItemsStruct,"ItemID",28434,26) 	;trick-or-treat bag
DllStructSetData($LootEventItemsStruct,"ItemID",18345,27) 	;victory token
DllStructSetData($LootEventItemsStruct,"ItemID",37765,28) 	;wayfarer's mark

DllStructSetData($LootTomesStruct,"ItemID",21796,1) ;assa
DllStructSetData($LootTomesStruct,"ItemID",21803,2) ;derwish
DllStructSetData($LootTomesStruct,"ItemID",21799,3) ;ele
DllStructSetData($LootTomesStruct,"ItemID",21797,4) ;mes
DllStructSetData($LootTomesStruct,"ItemID",21800,5) ;monk
DllStructSetData($LootTomesStruct,"ItemID",21798,6) ;necro
DllStructSetData($LootTomesStruct,"ItemID",21805,7) ;para
DllStructSetData($LootTomesStruct,"ItemID",21802,8) ;ranger
DllStructSetData($LootTomesStruct,"ItemID",21804,9) ;ritu
DllStructSetData($LootTomesStruct,"ItemID",21801,10) ;warrior
DllStructSetData($LootTomesStruct,"ItemID",21786,11) ;elite assa
DllStructSetData($LootTomesStruct,"ItemID",21793,12) ;elite derwish
DllStructSetData($LootTomesStruct,"ItemID",21789,13) ;elite ele
DllStructSetData($LootTomesStruct,"ItemID",21787,14) ;elite mes
DllStructSetData($LootTomesStruct,"ItemID",21790,15) ;elite monk
DllStructSetData($LootTomesStruct,"ItemID",21788,16) ;elite necro
DllStructSetData($LootTomesStruct,"ItemID",21795,17) ;elite para
DllStructSetData($LootTomesStruct,"ItemID",21792,18) ;elite ranger
DllStructSetData($LootTomesStruct,"ItemID",21794,19) ;elite ritu
DllStructSetData($LootTomesStruct,"ItemID",21791,20) ;elite warrior

DllStructSetData($LootDyeStruct,"ItemExtraID",10,1)	;black
DllStructSetData($LootDyeStruct,"ItemExtraID",2,2) 	;blue
DllStructSetData($LootDyeStruct,"ItemExtraID",3,3) 	;green
DllStructSetData($LootDyeStruct,"ItemExtraID",4,4) 	;purple
DllStructSetData($LootDyeStruct,"ItemExtraID",5,5) 	;red
DllStructSetData($LootDyeStruct,"ItemExtraID",6,6) 	;yellow
DllStructSetData($LootDyeStruct,"ItemExtraID",12,7) ;white
DllStructSetData($LootDyeStruct,"ItemExtraID",7,8) 	;brown
DllStructSetData($LootDyeStruct,"ItemExtraID",8,9) 	;orange
DllStructSetData($LootDyeStruct,"ItemExtraID",9,10) ;silver
DllStructSetData($LootDyeStruct,"ItemExtraID",13,11);pink
DllStructSetData($LootDyeStruct,"ItemExtraID",11,12);grey
#cs
! $iSlot 2 ModelID 146		Type 10		ExtraID 2 	Blau
! $iSlot 3 ModelID 146		Type 10		ExtraID 3 	Grün
! $iSlot 4 ModelID 146		Type 10		ExtraID 4 	Violett
! $iSlot 5 ModelID 146		Type 10		ExtraID 5 	Rot
! $iSlot 6 ModelID 146		Type 10		ExtraID 6 	Gelb
! $iSlot 7 ModelID 146		Type 10		ExtraID 7 	Braun
! $iSlot 8 ModelID 146		Type 10		ExtraID 8 	Orange
! $iSlot 9 ModelID 146		Type 10		ExtraID 9 	Silber
! $iSlot 10 ModelID 918		Type 10		ExtraID 11 	Grau
! $iSlot 11 ModelID 146		Type 10		ExtraID 10 	Schwarz
! $iSlot 12 ModelID 146		Type 10		ExtraID 12	Weiß
! $iSlot 13 ModelID 146		Type 10		ExtraID 13 	Rosa
#ce

Global $StoreEventItemsStruct = DllStructCreate("struct;UINT Checkbox[28]; UINT ItemID[28];UINT ItemCount[28]; UINT CountLable[28]; endstruct")
Global $StoreTomesStruct = DllStructCreate("struct;UINT Checkbox[20]; UINT ItemID[20];UINT ItemCount[20]; UINT CountLable[20]; endstruct")
Global $StoreDyeStruct = DllStructCreate("struct;UINT Checkbox[12]; UINT ItemID[12];UINT ItemExtraID[12]; UINT ItemCount[12]; UINT CountLable[12]; endstruct")
;~ Global $StoreMatsStruct = DllStructCreate("struct;UINT Checkbox[36]; UINT ItemID[36];UINT ItemCount[36]; UINT CountLable[36]; UINT ChestSlot[36]; endstruct")

DllStructSetData($StoreEventItemsStruct,"ItemID",22269,1) 	;birthday cupcake = 22269
DllStructSetData($StoreEventItemsStruct,"ItemID",22644,2) 	;chocolate bunny
DllStructSetData($StoreEventItemsStruct,"ItemID",36681,3) 	;delicious cake
DllStructSetData($StoreEventItemsStruct,"ItemID",21492,4) 	;fruitcake
DllStructSetData($StoreEventItemsStruct,"ItemID",22752,5) 	;golden egg
DllStructSetData($StoreEventItemsStruct,"ItemID",28436,6) 	;slice of pumpkin pie
DllStructSetData($StoreEventItemsStruct,"ItemID",21812,7) 	;sugary blue drink
DllStructSetData($StoreEventItemsStruct,"ItemID",36682,8) 	;battle of isle iced tea
DllStructSetData($StoreEventItemsStruct,"ItemID",30855,9) 	;gottle of grog
DllStructSetData($StoreEventItemsStruct,"ItemID",6375,10)	;eggnog---------------not checked
DllStructSetData($StoreEventItemsStruct,"ItemID",28435,11)	;hard apple cider
DllStructSetData($StoreEventItemsStruct,"ItemID",910,12)	;hunter's ale
DllStructSetData($StoreEventItemsStruct,"ItemID",35124,13) 	;krytan brandy
DllStructSetData($StoreEventItemsStruct,"ItemID",22190,14) 	;shamrock ale
DllStructSetData($StoreEventItemsStruct,"ItemID",21809,15) 	;bottle rocket
DllStructSetData($StoreEventItemsStruct,"ItemID",22269,16) 	;candy cane shard---------wrong
DllStructSetData($StoreEventItemsStruct,"ItemID",21810,17) 	;champagne popper
DllStructSetData($StoreEventItemsStruct,"ItemID",30648,18) 	;frosty tonic
DllStructSetData($StoreEventItemsStruct,"ItemID",31020,19) 	;mischievous tonic
DllStructSetData($StoreEventItemsStruct,"ItemID",36683,20) 	;party beacon
DllStructSetData($StoreEventItemsStruct,"ItemID",6376,21) 	;snowman summoner------------not checked
DllStructSetData($StoreEventItemsStruct,"ItemID",21813,22) 	;sparkler
DllStructSetData($StoreEventItemsStruct,"ItemID",22191,23) 	;four-leave clover
DllStructSetData($StoreEventItemsStruct,"ItemID",26784,24) 	;honeycomb
DllStructSetData($StoreEventItemsStruct,"ItemID",21833,25) 	;lunar token
DllStructSetData($StoreEventItemsStruct,"ItemID",28434,26) 	;trick-or-treat bag
DllStructSetData($StoreEventItemsStruct,"ItemID",18345,27) 	;victory token
DllStructSetData($StoreEventItemsStruct,"ItemID",37765,28) 	;wayfarer's mark

DllStructSetData($StoreTomesStruct,"ItemID",21796,1) ;assa
DllStructSetData($StoreTomesStruct,"ItemID",21803,2) ;derwish
DllStructSetData($StoreTomesStruct,"ItemID",21799,3) ;ele
DllStructSetData($StoreTomesStruct,"ItemID",21797,4) ;mes
DllStructSetData($StoreTomesStruct,"ItemID",21800,5) ;monk
DllStructSetData($StoreTomesStruct,"ItemID",21798,6) ;necro
DllStructSetData($StoreTomesStruct,"ItemID",21805,7) ;para
DllStructSetData($StoreTomesStruct,"ItemID",21802,8) ;ranger
DllStructSetData($StoreTomesStruct,"ItemID",21804,9) ;ritu
DllStructSetData($StoreTomesStruct,"ItemID",21801,10) ;warrior
DllStructSetData($StoreTomesStruct,"ItemID",21786,11) ;elite assa
DllStructSetData($StoreTomesStruct,"ItemID",21793,12) ;elite derwish
DllStructSetData($StoreTomesStruct,"ItemID",21789,13) ;elite ele
DllStructSetData($StoreTomesStruct,"ItemID",21787,14) ;elite mes
DllStructSetData($StoreTomesStruct,"ItemID",21790,15) ;elite monk
DllStructSetData($StoreTomesStruct,"ItemID",21788,16) ;elite necro
DllStructSetData($StoreTomesStruct,"ItemID",21795,17) ;elite para
DllStructSetData($StoreTomesStruct,"ItemID",21792,18) ;elite ranger
DllStructSetData($StoreTomesStruct,"ItemID",21794,19) ;elite ritu
DllStructSetData($StoreTomesStruct,"ItemID",21791,20) ;elite warrior

DllStructSetData($StoreDyeStruct,"ItemExtraID",10,1)	;black
DllStructSetData($StoreDyeStruct,"ItemExtraID",2,2) 	;blue
DllStructSetData($StoreDyeStruct,"ItemExtraID",3,3)		;green
DllStructSetData($StoreDyeStruct,"ItemExtraID",4,4) 	;purple
DllStructSetData($StoreDyeStruct,"ItemExtraID",5,5) 	;red
DllStructSetData($StoreDyeStruct,"ItemExtraID",6,6) 	;yellow
DllStructSetData($StoreDyeStruct,"ItemExtraID",12,7)	;white
DllStructSetData($StoreDyeStruct,"ItemExtraID",7,8) 	;brown
DllStructSetData($StoreDyeStruct,"ItemExtraID",8,9) 	;orange
DllStructSetData($StoreDyeStruct,"ItemExtraID",9,10)	;silver
DllStructSetData($StoreDyeStruct,"ItemExtraID",13,11)	;pink
DllStructSetData($StoreDyeStruct,"ItemExtraID",11,12)	;grey

;~ DllStructSetData($StoreMatsStruct,"ItemID",921,1)	;Bone
;~ DllStructSetData($StoreMatsStruct,"ItemID",953,2)	;Scale
;~ DllStructSetData($StoreMatsStruct,"ItemID",946,3)	;Wood
;~ DllStructSetData($StoreMatsStruct,"ItemID",934,4)	;Fiber
;~ DllStructSetData($StoreMatsStruct,"ItemID",926,5)	;Bolt Of Linen
;~ DllStructSetData($StoreMatsStruct,"ItemID",930,6)	;Ecto
;~ DllStructSetData($StoreMatsStruct,"ItemID",923,7)	;Monstrous Claw
;~ DllStructSetData($StoreMatsStruct,"ItemID",937,8)	;Ruby
;~ DllStructSetData($StoreMatsStruct,"ItemID",936,9)	;Onyx
;~ DllStructSetData($StoreMatsStruct,"ItemID",939,10)	;Tempered Glass Vial
;~ DllStructSetData($StoreMatsStruct,"ItemID",944,11)	;Vial Of Ink
;~ DllStructSetData($StoreMatsStruct,"ItemID",956,12)	;Spiritwood
;~ DllStructSetData($StoreMatsStruct,"ItemID",948,13)	;Iron
;~ DllStructSetData($StoreMatsStruct,"ItemID",954,14)	;Chitin
;~ DllStructSetData($StoreMatsStruct,"ItemID",955,15)	;Granite
;~ DllStructSetData($StoreMatsStruct,"ItemID",933,16)	;Feather
;~ DllStructSetData($StoreMatsStruct,"ItemID",927,17)	;Bolt Of Damask
;~ DllStructSetData($StoreMatsStruct,"ItemID",949,18)	;Steel
;~ DllStructSetData($StoreMatsStruct,"ItemID",931,19)	;Monstrous Eye
;~ DllStructSetData($StoreMatsStruct,"ItemID",938,20)	;Sapphire
;~ DllStructSetData($StoreMatsStruct,"ItemID",922,21)	;Lump Of Charcoal
;~ DllStructSetData($StoreMatsStruct,"ItemID",942,22)	;Leather Square
;~ DllStructSetData($StoreMatsStruct,"ItemID",951,23)	;Roll Of Parchment
;~ DllStructSetData($StoreMatsStruct,"ItemID",6532,24)	;Amber Chunk
;~ DllStructSetData($StoreMatsStruct,"ItemID",940,25)	;Hide
;~ DllStructSetData($StoreMatsStruct,"ItemID",925,26)	;Cloth
;~ DllStructSetData($StoreMatsStruct,"ItemID",929,27)	;Dust
;~ DllStructSetData($StoreMatsStruct,"ItemID",941,28)	;FurS quare
;~ DllStructSetData($StoreMatsStruct,"ItemID",928,29)	;Silk
;~ DllStructSetData($StoreMatsStruct,"ItemID",950,30)	;Deldrimor Steel
;~ DllStructSetData($StoreMatsStruct,"ItemID",932,31)	;Monstrous Fangs
;~ DllStructSetData($StoreMatsStruct,"ItemID",935,32)	;Diamond
;~ DllStructSetData($StoreMatsStruct,"ItemID",945,33)	;Obsi
;~ DllStructSetData($StoreMatsStruct,"ItemID",943,34)	;ElonianLeatherS quare
;~ DllStructSetData($StoreMatsStruct,"ItemID",952,35)	;Roll Of Vellum
;~ DllStructSetData($StoreMatsStruct,"ItemID",6533,36)	;Jadeite


Global $MatsArray[37][3]
$MatsArray[0][0] = 36
Global $MatsStruct = DllStructCreate("struct;UINT ItemID[36];UINT ItemCount[36]; UINT ChestSlot[36]; endstruct")
DllStructSetData($MatsStruct,"ItemID",921,1)	;Bone
DllStructSetData($MatsStruct,"ItemID",953,16)	;Scale
DllStructSetData($MatsStruct,"ItemID",946,10)	;Wood
DllStructSetData($MatsStruct,"ItemID",934,2)	;Fiber
DllStructSetData($MatsStruct,"ItemID",926,33)	;Bolt Of Linen
DllStructSetData($MatsStruct,"ItemID",930,6)	;Ecto
DllStructSetData($MatsStruct,"ItemID",923,13)	;Monstrous Claw
DllStructSetData($MatsStruct,"ItemID",937,11)	;Ruby
DllStructSetData($MatsStruct,"ItemID",936,20)	;Onyx
DllStructSetData($MatsStruct,"ItemID",939,18)	;Tempered Glass Vial
DllStructSetData($MatsStruct,"ItemID",944,19)	;Vial Of Ink
DllStructSetData($MatsStruct,"ItemID",956,9)	;Spiritwood
DllStructSetData($MatsStruct,"ItemID",948,7)	;Iron
DllStructSetData($MatsStruct,"ItemID",954,17)	;Chitin
DllStructSetData($MatsStruct,"ItemID",955,8)	;Granite
DllStructSetData($MatsStruct,"ItemID",933,3)	;Feather
DllStructSetData($MatsStruct,"ItemID",927,31)	;Bolt Of Damask
DllStructSetData($MatsStruct,"ItemID",949,29)	;Steel
DllStructSetData($MatsStruct,"ItemID",931,15)	;Monstrous Eye
DllStructSetData($MatsStruct,"ItemID",938,12)	;Sapphire
DllStructSetData($MatsStruct,"ItemID",922,21)	;Lump Of Charcoal
DllStructSetData($MatsStruct,"ItemID",942,22)	;Leather Square
DllStructSetData($MatsStruct,"ItemID",951,23)	;Roll Of Parchment
DllStructSetData($MatsStruct,"ItemID",6532,35)	;Amber Chunk
DllStructSetData($MatsStruct,"ItemID",940,25)	;Hide
DllStructSetData($MatsStruct,"ItemID",925,26)	;Cloth
DllStructSetData($MatsStruct,"ItemID",929,4)	;Dust
DllStructSetData($MatsStruct,"ItemID",941,28)	;FurS quare
DllStructSetData($MatsStruct,"ItemID",928,27)	;Silk
DllStructSetData($MatsStruct,"ItemID",950,30)	;Deldrimor Steel
DllStructSetData($MatsStruct,"ItemID",932,14)	;Monstrous Fangs
DllStructSetData($MatsStruct,"ItemID",935,32)	;Diamond
DllStructSetData($MatsStruct,"ItemID",945,5)	;Obsi
DllStructSetData($MatsStruct,"ItemID",943,34)	;ElonianLeatherS quare
DllStructSetData($MatsStruct,"ItemID",952,24)	;Roll Of Vellum
DllStructSetData($MatsStruct,"ItemID",6533,36)	;Jadeite
;~ MsgBox(0,0,@error)

$MatsArray[1][0] = 'Bone'
$MatsArray[16][0] = 'Scale'
$MatsArray[10][0] = 'Wood_Plank'
$MatsArray[2][0] = 'Plant_Fiber'
$MatsArray[33][0] = 'Bolt_of_Linen'
$MatsArray[6][0] = 'Glob_of_Ectoplasm'
$MatsArray[13][0] = 'Monstrous_Claw'
$MatsArray[11][0] = 'Ruby'
$MatsArray[20][0] = 'Onyx_Gemstone'
$MatsArray[18][0] = 'Tempered_Glass_Vial'
$MatsArray[19][0] = 'Vial_of_Ink'
$MatsArray[9][0] = 'Spiritwood_Plank'
$MatsArray[7][0] = 'Iron_Ingot'
$MatsArray[17][0] = 'Chitin_Fragment'
$MatsArray[8][0] = 'Granite_Slab'
$MatsArray[3][0] = 'Feather'
$MatsArray[31][0] = 'Bolt_of_Damask'
$MatsArray[29][0] = 'Steel_Ingot'
$MatsArray[15][0] = 'Monstrous_Eye'
$MatsArray[12][0] = 'Sapphire'
$MatsArray[21][0] = 'Lump_of_Charcoal'
$MatsArray[22][0] = 'Leather_Square'
$MatsArray[23][0] = 'Roll_of_Parchment'
$MatsArray[35][0] = 'Amber_Chunk'
$MatsArray[25][0] = 'Tanned_Hide_Square'
$MatsArray[26][0] = 'Bolt_of_Cloth'
$MatsArray[4][0] = 'Pile_of_Glittering_Dust'
$MatsArray[28][0] = 'Fur_Square'
$MatsArray[27][0] = 'Bolt_of_Silk'
$MatsArray[30][0] = 'Deldrimor_Steel_Ingot'
$MatsArray[14][0] = 'Monstrous_Fang'
$MatsArray[32][0] = 'Diamond'
$MatsArray[5][0] = 'Obsidian_Shard'
$MatsArray[34][0] = 'Elonian_Leather_Square'
$MatsArray[24][0] = 'Roll_of_Vellum'
$MatsArray[36][0] = 'Jadeite_Shard'

DllStructSetData($MatsStruct,"ChestSlot",1,1)		;Bone___________________row1
DllStructSetData($MatsStruct,"ChestSlot",4,16)		;Scale
DllStructSetData($MatsStruct,"ChestSlot",7,10)		;Wood
DllStructSetData($MatsStruct,"ChestSlot",11,2)		;Fiber
DllStructSetData($MatsStruct,"ChestSlot",14,33)		;Bolt Of Linen
DllStructSetData($MatsStruct,"ChestSlot",17,6)		;Ecto
DllStructSetData($MatsStruct,"ChestSlot",20,13)		;Monstrous Claw
DllStructSetData($MatsStruct,"ChestSlot",23,11)		;Ruby
DllStructSetData($MatsStruct,"ChestSlot",26,20)		;Onyx
DllStructSetData($MatsStruct,"ChestSlot",30,18)		;Tempered Glass Vial
DllStructSetData($MatsStruct,"ChestSlot",33,19)		;Vial Of Ink
DllStructSetData($MatsStruct,"ChestSlot",36,9)		;Spiritwood
DllStructSetData($MatsStruct,"ChestSlot",2,7)		;Iron_________________row2
DllStructSetData($MatsStruct,"ChestSlot",5,17)		;Chitin
DllStructSetData($MatsStruct,"ChestSlot",9,8)		;Granite
DllStructSetData($MatsStruct,"ChestSlot",12,3)		;Feather
DllStructSetData($MatsStruct,"ChestSlot",15,31)		;Bolt Of Damask
DllStructSetData($MatsStruct,"ChestSlot",18,29)		;Steel
DllStructSetData($MatsStruct,"ChestSlot",21,15)		;Monstrous Eye
DllStructSetData($MatsStruct,"ChestSlot",24,12)		;Sapphire
DllStructSetData($MatsStruct,"ChestSlot",27,21)		;Lump Of Charcoal
DllStructSetData($MatsStruct,"ChestSlot",31,22)		;Leather Square
DllStructSetData($MatsStruct,"ChestSlot",34,23)		;Roll Of Parchment
DllStructSetData($MatsStruct,"ChestSlot",37,35)		;Amber Chunk
DllStructSetData($MatsStruct,"ChestSlot",3,25)		;Hide______________________row3
DllStructSetData($MatsStruct,"ChestSlot",6,26)		;Cloth
DllStructSetData($MatsStruct,"ChestSlot",10,4)		;Dust
DllStructSetData($MatsStruct,"ChestSlot",13,28)		;FurS quare
DllStructSetData($MatsStruct,"ChestSlot",16,27)		;Silk
DllStructSetData($MatsStruct,"ChestSlot",19,30)		;Deldrimor Steel
DllStructSetData($MatsStruct,"ChestSlot",22,14)		;Monstrous Fangs
DllStructSetData($MatsStruct,"ChestSlot",25,32)		;Diamond
DllStructSetData($MatsStruct,"ChestSlot",28,5)		;Obsi
DllStructSetData($MatsStruct,"ChestSlot",32,34)		;ElonianLeatherS quare
DllStructSetData($MatsStruct,"ChestSlot",35,24)		;Roll Of Vellum
DllStructSetData($MatsStruct,"ChestSlot",38,36)		;Jadeite

For $i = 1 To 12
	$MatsArray[$i][1] = @ScriptDir &'\img\'& $MatsArray[$i][0] & ".png"
	$MatsArray[$i][2] = @ScriptDir &'\img\'& $MatsArray[$i][0] & "T.png"
Next
For $i = 13 To 36
	$MatsArray[$i][1] = @ScriptDir &'\img\'& $MatsArray[$i][0] & "x39.png"
	$MatsArray[$i][2] = @ScriptDir &'\img\'& $MatsArray[$i][0] & "x39T.png"
Next

Global $SalvageArray[9][3]
$SalvageArray[0][0] = 8
Global $SalvageStruct = DllStructCreate("struct;UINT ItemID[36];UINT ItemCount[36]; UINT CountLable[36]; endstruct")
DllStructSetData($SalvageStruct,"ItemID","IronItems",1)	;Bramble
DllStructSetData($SalvageStruct,"ItemID",522,2)	;Dark_Remains
DllStructSetData($SalvageStruct,"ItemID",819,3)	;Dragon_Root
DllStructSetData($SalvageStruct,"ItemID",835,4)	;Feathered_Crest
DllStructSetData($SalvageStruct,"ItemID",1603,5)	;Skale_Tooth
DllStructSetData($SalvageStruct,"ItemID",1604,6)	;Skale_Claw
DllStructSetData($SalvageStruct,"ItemID",27047,7)	;Glacial_Stone
DllStructSetData($SalvageStruct,"ItemID",956,8)	;Spiritwood_Plank

$SalvageArray[1][0] = 'IronItems'  ;1543
$SalvageArray[2][0] = 'Dark_Remains' ; 522
$SalvageArray[3][0] = 'Dragon_Root'  ;819
$SalvageArray[4][0] = 'Feathered_Crest' ;835
$SalvageArray[5][0] = 'Skale_Tooth' ;1603
$SalvageArray[6][0] = 'Skale_Claw' ;1604
$SalvageArray[7][0] = 'Glacial_Stone' ;27047
$SalvageArray[8][0] = 'Spiritwood_Plank' ;956

For $i = 1 To $SalvageArray[0][0]
	$SalvageArray[$i][1] = @ScriptDir &'\img\'& $SalvageArray[$i][0] & "x39.png"
	$SalvageArray[$i][2] = @ScriptDir &'\img\'& $SalvageArray[$i][0] & "x39T.png"
Next

Func getPosInMatsStructByItemID($ItemID)
	For $i = 1 To 36
		If DllStructGetData($MatsStruct,"ItemID",$i) = $ItemID Then Return $i
	Next
EndFunc

Func getPosInSalvageStructByItemID($ItemID)
	For $i = 1 To $SalvageArray[0][0]
		If DllStructGetData($SalvageStruct,"ItemID",$i) = $ItemID Then Return $i
	Next
EndFunc

Func getSalvageIDByName($lSalvageName)
	For $i = 1 To $SalvageArray[0][0]
;~ 		ConsoleWrite(@CRLF & "!" & $i & @TAB &DllStructGetData($MatsStruct,"ItemID",$i))
		If $lSalvageName = $SalvageArray[$i][0] Then
			Return DllStructGetData($SalvageStruct,"ItemID",$i)
		EndIf
	Next
	Return -1
EndFunc

Func getMatIDByName($lMatName)
	For $i = 1 To 36
;~ 		ConsoleWrite(@CRLF & "!" & $i & @TAB &DllStructGetData($MatsStruct,"ItemID",$i))
		If $lMatName = $MatsArray[$i][0] Then
			Return DllStructGetData($MatsStruct,"ItemID",$i)
		EndIf
	Next
	Return -1
EndFunc


Global $TabArrayOfStructs[0]
Global $tabHWNDArray[0]
Global $tabNamesArray[0]
Global $tabIsOpen[0]
Global $tabOpenButtonHWND[0]

Global $BagTicked[5]
$BagTicked[0] = 4
$BagTicked[1] = True
$BagTicked[2] = True
$BagTicked[3] = True
$BagTicked[4] = False

Global $BagPic[4]
Global $BagTickedPic[4]
Global $BagMenu[4]

Global $BagPath[5]
$BagPath[0] = 4
$BagPath[1] = @ScriptDir & '\img\Backpackx30.png'
$BagPath[2] = @ScriptDir & '\img\Belt_Pouchx30.png'
$BagPath[3] = @ScriptDir & '\img\Bagx30.png'
$BagPath[4] = @ScriptDir & '\img\Bagx30.png'

Global $ChestBagPath[11]
$ChestBagPath[0] = 10
$ChestBagPath[1] = @ScriptDir & '\img\Chest1.png'
$ChestBagPath[2] = @ScriptDir & '\img\Chest2.png'
$ChestBagPath[3] = @ScriptDir & '\img\Chest3.png'
$ChestBagPath[4] = @ScriptDir & '\img\Chest4.png'
$ChestBagPath[5] = @ScriptDir & '\img\ChestB.png'
$ChestBagPath[6] = @ScriptDir & '\img\Chest5.png'
$ChestBagPath[7] = @ScriptDir & '\img\Chest6.png'
$ChestBagPath[8] = @ScriptDir & '\img\Chest7.png'
$ChestBagPath[9] = @ScriptDir & '\img\Chest8.png'
$ChestBagPath[10] = @ScriptDir & '\img\ChestH.png'

Global $ChestBagTickedPath[11]
$ChestBagTickedPath[0] = 10
$ChestBagTickedPath[1] = @ScriptDir & '\img\Chest1T.png'
$ChestBagTickedPath[2] = @ScriptDir & '\img\Chest2T.png'
$ChestBagTickedPath[3] = @ScriptDir & '\img\Chest3T.png'
$ChestBagTickedPath[4] = @ScriptDir & '\img\Chest4T.png'
$ChestBagTickedPath[5] = @ScriptDir & '\img\ChestBT.png'
$ChestBagTickedPath[6] = @ScriptDir & '\img\Chest5T.png'
$ChestBagTickedPath[7] = @ScriptDir & '\img\Chest6T.png'
$ChestBagTickedPath[8] = @ScriptDir & '\img\Chest7T.png'
$ChestBagTickedPath[9] = @ScriptDir & '\img\Chest8T.png'
$ChestBagTickedPath[10] = @ScriptDir & '\img\ChestHT.png'

Global $BagTickedPath[5]
$BagTickedPath[0] = 4
$BagTickedPath[1] = @ScriptDir & '\img\BackpackTickedx30.png'
$BagTickedPath[2] = @ScriptDir & '\img\Belt_PouchTickedx30.png'
$BagTickedPath[3] = @ScriptDir & '\img\BagTickedx30.png'
$BagTickedPath[4] = @ScriptDir & '\img\BagTickedx30.png'

;~~~~ Enemies
;~ Global $lAgentGroup[3][4]
;~ Global $myDistance1 = 0
;~ Global $myDistance2 = 0
;~ Global $myDistance3 = 0
Global $Frostskal = 4367
Global $Frostskal = 4367
Global $Skalpeitscher = 4374

;~~~~ Items ARRAY - Wiederverwertbar
;~ Global $Goldies_ID = 2624
;~ Global $Purple_ID = 2626
;~ Global $Blue_ID = 2623
Global $Item_ID[1] = [1]
Global $Item_Name[1] = [1]
_ArrayAdd($Item_ID,819)
_ArrayAdd($Item_Name,'Dragonroot')
_ArrayAdd($Item_ID,956)
_ArrayAdd($Item_Name,'Spiritwood')
_ArrayAdd($Item_ID,835)
_ArrayAdd($Item_Name,'Feathered Crests')
_ArrayAdd($Item_ID,522)
_ArrayAdd($Item_Name,'Dark Remain')
_ArrayAdd($Item_ID,1603)
_ArrayAdd($Item_Name,'Skale Teeth')
_ArrayAdd($Item_ID,1604)
_ArrayAdd($Item_Name,'Skale Claws')
_ArrayAdd($Item_ID,19184)
_ArrayAdd($Item_Name,'Skale Fins')
_ArrayAdd($Item_ID,27047)
_ArrayAdd($Item_Name,'Glacial Stones')
$Item_ID[0] = UBound($Item_ID) -1
$Item_Name[0] = UBound($Item_Name) -1

;~ Description: Returns Item_Id[$i] by $Idem_Name[$i]
Func getItemIDByName($lItemName)
	For $i=1 To $Item_Name[0]
		If $lItemName == $Item_Name[$i] Then
			Return $Item_ID[$i]
		EndIf
	Next
	Return -1
EndFunc

Func getItemNameByID($ItemID)
	For $i=1 To $Item_ID[0]
		If $ItemID == $Item_ID[$i] Then
			Return $Item_Name[$i]
		EndIf
	Next
	Return -1
EndFunc

#EndRegion GLOBALS

#Region CONSTANTS


Global Enum $RANGE_ADJACENT=156, $RANGE_NEARBY=240, $RANGE_AREA=312, $RANGE_EARSHOT=1000, $RANGE_SPELLCAST = 1085, $RANGE_SPIRIT = 2500, $RANGE_COMPASS = 5000
Global Enum $RANGE_ADJACENT_2=156^2, $RANGE_NEARBY_2=240^2, $RANGE_AREA_2=312^2, $RANGE_EARSHOT_2=1000^2, $RANGE_SPELLCAST_2=1085^2, $RANGE_SPIRIT_2=2500^2, $RANGE_COMPASS_2=5000^2

;LOCALIZATION
Global Const $MERCHANT_NAME = "Merchant"

;~~~~ MAPIDS - City
Global Const $MAP_ID_ANJEKA = 349
Global Const $MAP_ID_Jokanur = 491 ; Ausgrabungsstätte von Jokanur
Global Const $MAP_ID_LONGEYE = 650
Global Const $MAP_ID_USING_CITY = $MAP_ID_LONGEYE

;~~~~ MAPIDS - Area
Global Const $MAP_ID_DRAZACH = 195
Global Const $MAP_ID_Fahranur = 481 ; Fahranur, die Erste Stadt
Global Const $MAP_ID_BJORA = 482
Global Const $MAP_ID_JAGA = 546
Global Const $MAP_ID_USING_AREA = $MAP_ID_JAGA


;~~~~ SKILL SETUP

;~ Global Const $paradox = 1
;~ Global Const $sf = 2
;~ Global Const $shroud = 3
;~ Global Const $wayofperf = 4
;~ Global Const $hos = 5
;~ Global Const $wastrel = 6
;~ Global Const $echo = 7
;~ Global Const $channeling = 8
;~ ; Store skills energy cost
;~ Global $skillCost[9]
;~ $skillCost[$paradox] = 15
;~ $skillCost[$sf] = 5
;~ $skillCost[$shroud] = 10
;~ $skillCost[$wayofperf] = 5
;~ $skillCost[$hos] = 5
;~ $skillCost[$wastrel] = 5
;~ $skillCost[$echo] = 15
;~ $skillCost[$channeling] = 5
;~ Global Const $SKILL_ID_SHROUD = 1031
;~ Global Const $SKILL_ID_CHANNELING = 38
;~ Global Const $SKILL_ID_ARCHANE_ECHO = 75
;~ Global Const $SKILL_ID_WASTREL_DEMISE = 1335


Global Const $Skill_paradox = 1
Global Const $Skill_Sf = 2
Global Const $Skill_Shroud = 3
Global Const $Skill_WayOfPerf = 4
Global Const $Skill_Hos = 5
Global Const $Skill_Wastrel = 6
Global Const $Skill_Echo = 7
Global Const $Skill_Channeling = 8

Global Const $Skill_ID_paradox = 1
Global Const $Skill_ID_Sf = 2
Global Const $Skill_ID_Shroud = 1031
Global Const $Skill_ID_WayOfPerf = 4
Global Const $Skill_ID_Hos = 5
Global Const $Skill_ID_Wastrel = 1335
Global Const $Skill_ID_Echo = 75
Global Const $Skill_ID_Channeling = 38

Global Const $Skill_Cost_paradox = 15
Global Const $Skill_Cost_Sf = 5
Global Const $Skill_Cost_Shroud = 10
Global Const $Skill_Cost_WayOfPerf = 5
Global Const $Skill_Cost_Hos = 5
Global Const $Skill_Cost_Wastrel = 5
Global Const $Skill_Cost_Echo = 15
Global Const $Skill_Cost_Channeling = 5

;~ Global Const $WEAPON_SLOT_USING = 1
Global Const $WEAPON_SLOT_SCYTHE = 3
Global Const $WEAPON_SLOT_STAFF = 2
Global Const $WEAPON_SLOT_SHIELD = 1

;~~~~ KITS
Global Const $Salvage_Kit_ID = 2992
Global Const $Salvage_Kit_Expert_ID = 2991
Global Const $Salvage_Kit_Superior_ID = 5900
Global Const $Ident_Kit_ID = 2989

;~~~~ RARITY
Global Const $RARITY_GOLD = 2624
Global Const $RARITY_PURPLE = 2626
Global Const $RARITY_BLUE = 2623
Global Const $RARITY_WHITE = 2621

;~~~~ CONSUMABLES
Global Const $ITEM_ID_LOCKPICKS = 22751
Global Const $ITEM_ID_SALVAGE_KIT = 2992
Global Const $ITEM_ID_ID_KIT = 2989

;~~~~ Dye
Global Const $ITEM_ID_Dye = 146
Global Const $ITEM_ID_DYE_GREY = 918
;~ Global Const $ITEM_EXTRAID_BLACKDYE = 10
;~ Global Const $ITEM_EXTRAID_WHITEDYE = 12

; === Usefull Items ===
Global Const $ITEM_ID_DIESSA = 24353
Global Const $ITEM_ID_RIN = 24354
;~ Global Const $ITEM_ID_BRAMBLE = 934
;Longbow = 868 ;Shortbow = 957 ;904 = flatbow ;Recurve = 934 == Plant Fiber

;~~~~ SHIELDS
Global Const $ITEM_ID_ECHOVALD = 945
Global Const $ITEM_ID_Sharktooth = 1543

#EndRegion CONSTANTS


;~ ConsoleWrite(@CRLF & "!Plant_Fiber ID " & getMatIDByName('Plant_Fiber')& @CRLF)
;~ ConsoleWrite("!Spiritwood ID " & getItemIDByName('Spiritwood')& @CRLF)






