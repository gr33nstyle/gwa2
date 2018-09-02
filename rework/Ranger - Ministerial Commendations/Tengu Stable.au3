#cs----------------------------------------------------------------------------
	v1.1
	Base provided by:		Xun
	Improvements and fixes:	Stepmother


	Changelog
	1.1		Fixed rendering disable
			Fixed and improvedstorage manager
			Fixed stucking in outpost (haven't seen any more problems)
			Fixed issue that caused fails after spike
			Fixed issue with counting enemy agents that caused a big increase in failrate

			Improved hero team
			Improved player build
			Improved skill usage
			Added checkboxes for keeping dyes and unid golds
			Added timer, droprate
			Hero team gets automatically added

			More small fixes
#ce----------------------------------------------------------------------------

global const $botName = "Tengu"
global $commendations = 0
global $totalKilledEnemies = 0

global const $runStuckTreshold = 300000

global const $MinisterialCommendation = 36985

#include "Skybot\Base.au3"

#Region Heroes
global const $hero_norgu = 1
global const $hero_goren = 2
global const $hero_tahlkora = 3
global const $hero_masterOfWhispers = 4
global const $hero_acolyteJin = 5
global const $hero_koss = 6
global const $hero_dunkoro = 7
global const $hero_acolyteSousuke = 8
global const $hero_melonni = 9
global const $hero_zhedShadowhoof = 10
global const $hero_generalMorgahn = 11
global const $hero_margridTheSly = 12
global const $hero_zenmai = 13
global const $hero_olias = 14
global const $hero_razah = 15
global const $hero_mox = 16
global const $hero_jora = 17
global const $hero_keiranThackeray = 18
global const $hero_pyreFierceshot = 19
global const $hero_anton = 20
global const $hero_livia = 21
global const $hero_hayda = 22
global const $hero_kahmu = 23
global const $hero_gwen = 24
global const $hero_xandra = 25
global const $hero_vekk = 26
global const $hero_ogden = 27
global const $hero_merc1 = 28
global const $hero_merc2 = 29
global const $hero_merc3 = 30
global const $hero_merc4 = 31
global const $hero_merc5 = 32
global const $hero_merc6 = 34
global const $hero_merc7 = 35
global const $hero_merc8 = 36
global const $hero_miku = 37
global const $hero_zeiRi = 38
#EndRegion Heroes

#Region Preparations
func doRun()
	local $me = getAgentById(-2)
	if sellIfNeeded() then return
	if not $prepared then prepare()
	writeLog("Starting run")
	enter()
	doFirstFight()
	runToSpot()
	waitForBall()
	kill()
	loot()
	endRun()
endFunc

func prepare()
	writeLog("Preparing")
	randomTravel(194)
	loadSkillTemplate("OgEUQrqeVsSXF9F8E7g5i+GMHBAA") ; Healing Spring
	KickAllHeroes()
	Do
		AddHero($hero_dunkoro)
		RndSleep(100)
		AddHero($Hero_olias)
		RndSleep(100)
		AddHero($Hero_livia)
		RndSleep(100)
		AddHero($Hero_vekk)
		RndSleep(100)
		AddHero($Hero_xandra)
		RndSleep(100)
		AddHero($Hero_gwen)
		RndSleep(100)
		AddHero($hero_ogden)
		RndSleep(100)
	Until GetHeroCount() = 7

	if GUICtrlRead($checkbox_hardMode) == $GUI_CHECKED then
		switchMode(1)
	else
		switchMode(0)
	endIf
	$prepared = true
endFunc

func enter()
	local $me = getAgentById(-2)
	local $mapID = GetMapID()
	writeLog("Entering area")
	Local $DistancetoEasternSpawnpoint = ComputeDistance(DllStructGetData($me, 'X'), DllStructGetData($me, 'Y'), 3045, -1515)
    Local $DistancetoNorthernSpawnpoint = ComputeDistance(DllStructGetData($me, 'X'), DllStructGetData($me, 'Y'), 2726, 579)
    Local $DistancetoWesternSpawnpoint = ComputeDistance(DllStructGetData($me, 'X'), DllStructGetData($me, 'Y'), -1004, -1538)
	Local $DistancetoSouthernSpawnpoint = ComputeDistance(DllStructGetData($me, 'X'), DllStructGetData($me, 'Y'), 2794, -3884)
	If ($DistancetoWesternSpawnpoint < $DistancetoEasternSpawnpoint) and ($DistancetoWesternSpawnpoint < $DistancetoNorthernSpawnpoint) Then
	   MoveTo(1470, -1100)
    EndIf ; Makes sure there is no stucking in outpost
	moveTo(2225, -1236)
	changeTarget(getAgentByName("Herald of Purity"))
	sleep(500)
	actionInteract()
	sleep(500)
	dialog(0x00000084)
	waitMapLoadingFast()
endFunc
#EndRegion Preparations

#Region Mission
func doFirstFight()
	$mikuID = DllStructGetData(GetAgentByName("Miku"), 'ID')
	$timer_runStuck = timerInit()
	adlibRegister("checkDead", 100)
	if not $amDead then writeLog("Setting up for fight")
	if not $amDead then commandHero(1, -5977, -5356)
	if not $amDead then commandHero(2, -6094, -5146)
	if not $amDead then commandHero(3, -6308, -4938)
	if not $amDead then commandHero(4, -5937, -5680)
	if not $amDead then commandHero(5, -6113, -5944)
	if not $amDead then commandHero(6, -6400, -6206)
	if not $amDead then commandHero(7, -6793, -6406)
	if not $amDead then moveTo(-6296.25, -5233.2)

	if not $amDead then sleep(20000)
	if not $amDead then useHeroSkill(1, 2, -2) ;Shelter
	if not $amDead then sleep(2000)
	if not $amDead then useHeroSkill(1, 3, -2) ;Union
	if not $amDead then sleep(2000)
	if not $amDead then useHeroSkill(1, 4, -2) ;Displacement
	if not $amDead then sleep(2000)
	if not $amDead then useHeroSkill(1, 5, -2) ;Armor of Unfeeling
	if not $amDead then useHeroSkill(3, 8, -2) ;Recuperation
	if not $amDead then useHeroSkill(4, 1, -2) ;Main Spike Skill
	if not $amDead then useHeroSkill(5, 1, -2) ;Main Spike Skill
	if not $amDead then useHeroSkill(6, 1, -2) ;Main Spike Skill
	if not $amDead then useHeroSkill(7, 1, -2) ;Main Spike Skill
	if not $amDead then sleep(5000)

	if not $amDead then useSkillSmart(5)
	while not $amDead and getNumberOfFoesInRangeOfAgent(-2) = 0
		if not $amDead then sleep(100)
	wEnd
	if not $amDead then writeLog("Fighting")
	if not $amDead then cancelHero(1)
	if not $amDead then cancelHero(2)
	if not $amDead then cancelHero(3)
	if not $amDead then cancelHero(4)
	if not $amDead then cancelHero(5)
	if not $amDead then cancelHero(6)
	if not $amDead then cancelHero(7)
	if not $amDead then adlibRegister("useSkillFight", 1000)
	if not $amDead then local $enemy = getNearestEnemyToAgent(-2)
	do
		if not $amDead then $enemy = getNearestEnemyToAgent(-2)
		if not $amDead then attack($enemy)
		if not $amDead then sleep(250)
	until $amDead or getNumberOfFoesInRangeOfAgent(-2, 3000) >= 5
	do
		if not $amDead then $enemy = getNearestEnemyToAgent(-2)
		if not $amDead then attack($enemy)
		if not $amDead then sleep(250)
	until $amDead or getNumberOfFoesInRangeOfAgent(-2, 3000) <= 2
	do
		if not $amDead then $enemy = getNearestEnemyToAgent(-2)
		if not $amDead then attack($enemy)
		if not $amDead then sleep(250)
		if not $amDead then local $foesInRange = getNumberOfFoesInRangeOfAgent(-2, 3000)
	until $amDead or $foesInRange = 0 or $foesInRange > 2
	if not $amDead then adlibUnRegister("useSkillFight")
	if not $amDead then useHeroSkill(1, 8, -2) ; ST casts "Make Haste" on player to make sure he arrives at the spike spot safe
	if not $amDead then useHeroSkill(2, 5, $mikuID) ; BiP casts Mend Body and Soul to clear conditions
	if not $amDead then useHeroSkill(3, 5, -2) ; PoD casts Mend Body and Soul to clear conditions
endFunc

func runToSpot()
	if $amDead then return
	if not $amDead then writeLog("Running to spike spot")
	if not $amDead then commandAll(-7079.25, -2571.93)
	if not $amDead then moveTo(-4714.88, -3594.38, 20)
	if not $amDead then moveTo(-3595.15, 325.98, 20)
	if not $amDead then moveTo(-1286.79, -1461.08, 20)
	if not $amDead then moveTo(-1070, -4192, 0)
endFunc

func waitForBall()
	if $amDead then return
	if not $amDead then writeLog("Waiting for enemies to arrive")
	if not $amDead then adlibRegister("useSkillWaitForBall", 500)
	if not $amDead then local $timer = timerInit()
	while not $amDead and getNumberOfFoesInRangeOfAgent(-2, 200) = 0 and timerDiff($timer) < 40000
		if not $amDead then sleep(100)
	wEnd
	if not $amDead then writeLog("Waiting for ball")
	if not $amDead then adlibRegister("useHeroSkillWaitForBall", 500)
	if not $amDead then local $timer = timerInit()
	while not $amDead and timerDiff($timer) < 43000 and getNumberOfFoesInRangeOfAgent(-2, 200) < 45
		if not $amDead then sleep(100)
	wEnd
	if not $amDead then adlibUnRegister("useSkillWaitForBall")
	if not $amDead then adlibRegister("useSkillWaitForBall2", 500)
	while not $amDead and getSkillbarSkillRecharge(6) <> 0
		sleep(100)
	wEnd
	if not $amDead then useSkillSmart(6)
	if not $amDead then adlibUnRegister("useSkillWaitForBall2")
	if not $amDead then adlibUnRegister("useHeroSkillWaitForBall")
endFunc

func kill()
	local $EnemiesThisRun = 0
	if $amDead then return
	if not $amDead then writeLog("Prepping spike")
	$EnemiesThisRun += getNumberOfFoesInRangeOfAgent(-2, 200)
	$TotalKilledEnemies += $EnemiesThisRun
	if not $amDead then useSkillSmart(5)
	if not $amDead then useSkillSmart(1)
	if not $amDead then useSkillSmart(3)
	if not $amDead then useSkillSmart(2)
	if not $amDead then writeLog("Spiking!")
	if not $amDead then local $enemy = getNearestEnemyToAgent(-2)
	if not $amDead then useSkillSmart(4, $enemy)
	if not $amDead then sleep(2000)
	if not $amDead then adlibRegister("useSkillWaitForLoot", 500)
endFunc

func endRun()
	if not $amDead then writeLog("Ending run")
	if not $amDead then writeLog("Commendations: " & $commendations)
	if not $amDead then adlibUnRegister("checkDead")
	adlibUnRegister("useSkillFight")
	adlibUnRegister("useSkillWaitForBall")
	adlibUnRegister("useSkillWaitForLoot")
	sleep(1000)
	randomTravel(194)
	GUICtrlSetData($label_dropRate,DropRate())
	$runs = $runs + 1
	GUICtrlSetData($label_runsCounter, $runs)
	$amDead = false
endFunc
#EndRegion Mission

#Region Skill Use
func useSkillFight()
	if canUseSkill(2) then
		useSkill(2)
		return
	endIf
endFunc

func useSkillWaitForBall()
	if canUseSkill(6) then
		useSkillSmart(6)
		return
	endIf
	if canUseSkill(7) then
		useSkillSmart(7)
		return
	endIf
	if canUseSkill(8) and dllStructGetData(getAgentByID(), "hp") < 0.9 then
		useSkillSmart(8)
		return
	endIf
endFunc

func useSkillWaitForBall2()
	if canUseSkill(7) then
		useSkillSmart(7)
		return
	endIf
	if canUseSkill(8) and dllStructGetData(getAgentByID(), "hp") < 0.9 then
		useSkillSmart(8)
		return
	endIf
endFunc

func useSkillWaitForLoot()
	if canUseSkill(6) then
		useSkillSmart(6)
		return
	endIf
	if canUseSkill(8) and dllStructGetData(getAgentByID(), "hp") < 0.3 then
		useSkillSmart(8)
		return
	endIf
endFunc
#EndRegion Skill Use

#Region Special
func skipPickup($item) ;Filter items you don't want to pick up
	local $modelId = dllStructGetData(($item), "modelId")
	local $type = dllStructGetData(($item), "type")
	local $extraId = dllStructGetData(($item), "extraId")
	local $rarity = getRarity($item)
	if $rarity == $rarity_green then return true
	If $type == $itemType_dye and $extraId <> $dye_black and $extraId <> $dye_white and $extraId <> $dye_blue and $extraId <> $dye_red then return true
	return false
endFunc

func onLootBlock()
	moveTo(-1248.16, -4092.95)
	sleep(1000)
endFunc

func addCustomOptions()
	global $checkbox_hardMode = GUICtrlCreateCheckbox("Hard Mode", 10, 125)
endFunc
func loadCustomOptions()
	GUICtrlSetState($checkbox_hardMode, iniRead($settingsFile, "custom", "hardMode", $GUI_CHECKED))
endFunc

func saveCustomOptions()
	iniWrite($settingsFile, "custom", "hardMode", GUICtrlRead($checkbox_hardMode))
endFunc

func addDropRate()
	GUICtrlCreateLabel("Droprate:", 10, 215)
	global $label_dropRate = GUICtrlCreateLabel("-", 70, 215, 60, 20)
endFunc

Func DropRate()
   If $commendations > 0 Then
	  $aRate = Round($commendations / $TotalKilledEnemies, 3)*100
	  Return $aRate & "%"
   Else
	  Return "-"
   EndIf
EndFunc
#EndRegion Special