;~~~~ CONSTANTS
Global Const $MAP_ID_JOKANUR = 491
Global CONST $MAP_ID_FAHRANUR = 481
Global Const $ITEM_ID_SKALEFINS = 19184
Global Const $SKILL_TEMPLATE = "OgejkirKLTmXfbsXaXNXAA3lTQA"

Global Const $SAND_SHARDS = 1
Global Const $VOW_OF_STRENGTH = 2
Global Const $MYSTIC_REGENERATION = 3
Global Const $STAGGERING_FORCE = 4
Global Const $EREMITES_ATTACK = 5
Global Const $DWARVEN_STABILITY = 7
Global Const $DASH = 8

Global Const $WEAPON_SET_SCYTHE = 1
Global Const $WEAPON_SET_STAFF = 2

Global Const $PROCESS_INI = "D:\botties\_________autorun\process.ini"

; Store skills energy cost
Global $skillCost[9]
$skillCost[$SAND_SHARDS] = 10
$skillCost[$VOW_OF_STRENGTH] = 5
$skillCost[$MYSTIC_REGENERATION] = 10
$skillCost[$STAGGERING_FORCE] = 10
$skillCost[$EREMITES_ATTACK] = 5
$skillCost[6] = 0
$skillCost[$DWARVEN_STABILITY] = 5
$skillCost[$DASH] = 5
;~~~~ END CONSTANTS

;~~~~ GLOBALS
Global $Rendering = True
Global $characterName
Global $Running = False
Global $Initialized = False
Global $RunsTotal = 0
Global $RunsSuccess = 0
Global $RunsFail = 0
;~~~~ END GLOBALS

