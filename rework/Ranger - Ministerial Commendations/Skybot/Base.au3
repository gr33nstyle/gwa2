;v1.1
#include-once
#include <Date.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBox.au3>
#include <GUIEdit.au3>
#include <WindowsConstants.au3>
#include "GWA2.au3"
#include "Constants.au3"
#include "Options.au3"
#include "Runes.au3"
#include "Modstructs.au3"


#Region Setting up GUI
;Setting up GUI
global $window = GUICreate($botName, 350, 270)
GUICtrlCreateTab(-1, -1, 355, 280)

;Bot tab
GUICtrlCreateTabItem("Bot")
global $input_characterName = GUICtrlCreateCombo("", 10, 30, 110, 20)
GUICtrlSetData(-1, getLoggedCharnames())
_GUICtrlComboBox_SetCurSel($input_characterName, 0)

global $checkbox_disableRendering = GUICtrlCreateCheckbox("Disable Rendering", 10, 55)
GUICtrlSetOnEvent($checkbox_disableRendering, "toggleRendering")

global $checkbox_randomTravel = GUICtrlCreateCheckbox("Random Travel", 10, 75)
GUICtrlSetOnEvent($checkbox_randomTravel, "toggleRandomTravel")

global $checkbox_onTop = GUICtrlCreateCheckbox("On Top", 10, 95)
GUICtrlSetOnEvent($checkbox_onTop, "toggleOnTop")

global $button_start = GUICtrlCreateButton("Start", 10, 120, 110)
GUICtrlSetOnEvent($button_start, "StartButtonClickedHandler")

GUICtrlCreateLabel("Runs:", 10, 155)
global $label_runsCounter = GUICtrlCreateLabel("0", 50, 155, 60, 20)

GUICtrlCreateLabel("Fails:", 10, 175)
global $label_failsCounter = GUICtrlCreateLabel("0", 50, 175, 60, 20)

GUICtrlCreateLabel("Time:", 10, 195)
global $label_time = GUICtrlCreateLabel("00:00:00", 50, 195, 60, 20)

global $button_saveSettings = GUICtrlCreateButton("Save settings", 10, 235, 110)
GUICtrlSetOnEvent($button_saveSettings, "saveSettings")

global $edit_log = GUICtrlCreateEdit("Waiting...", 130, 30, 210, 230, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_NOHIDESEL))
GUICtrlSetColor($edit_log, 65280)
GUICtrlSetBkColor($edit_log, 0)
addDropRate()

;Options tab
GUICtrlCreateTabItem("Options")
createOptionsTab()
addCustomOptions()

;Materials tab
GUICtrlCreateTabItem("Materials")
createMaterialSTab()

;Dyes tab
GUICtrlCreateTabItem("Dyes")
createDyesTab()

;Finish setting up GUI
loadSettings()
Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseWindowHandler")
GUICtrlSetState($button_start, $GUI_FOCUS)
GUICtrlSetState($checkbox_disableRendering, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion Setting up GUI

global $botRunning = false
global $botInitialized = false
global $pauseHandled = false
global $amDead = false
global $renderingEnabled = True
global $randomTravelEnabled = false
global $timer_run
global $timer_runStuck
global $runs = 0
global $fails = 0
global $accumulatedTime = 0
global $prepared = false

while 1
	if $botRunning then
		doRun()
		if GUICtrlRead($checkbox_disableRendering) == $GUI_CHECKED then
			clearMemory()
			_PurgeHook()
		endIf
		if not $botRunning and not $pauseHandled then
			writeLog("Ready to begin")
			GUICtrlSetState($button_start, $GUI_ENABLE)
			GUICtrlSetData($button_start, "Start")
			$accumulatedTime = timerDiff($timer_run) + $accumulatedTime
			adlibUnRegister("updateTime")
			$pauseHandled = true
			$prepared = false
		endif
	else
		sleep(100)
	endif
wend

func checkDead()
	if (getHealth() == 0 or getIsDead()) or (timerDiff($timer_runStuck) > $runStuckTreshold and $runStuckTreshold <> 0) then
		$fails = $fails + 1
		GUICtrlSetData($label_failsCounter, $fails)
		$amDead = true
		adlibUnRegister("checkDead")
		if getHealth() == 0 or getIsDead() then writeLog("Died")
		if timerDiff($timer_runStuck) > $runStuckTreshold then writeLog("Stuck")
	endIf
endFunc

; func getNumberOfFoesInRange($maxDistance = 1050)
	; local $enemyCount = 0
	; local $me = getAgentById()
	; for $i = 1 to getMaxAgents()
		; local $potentialEnemy = getAgentById($i)
		; if getIsDead($potentialEnemy) <> 0 then continueLoop
		; if dllStructGetData($potentialEnemy, "allegiance") == $allegiance_enemy then
			; if getDistance($potentialEnemy, $me) < $maxDistance and $potentialEnemy <> DllStructGetData(GetAgentByName("Spirit of Life"), 'ID') then
				; $enemyCount += 1
			; endIf
		; endIf
	; next
	; return $enemyCount
; endFunc

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

#Region Skill Use

func useSkillSmart($skillNumber, $target = -2)
	if not isDllStruct($target) then $target == getAgentByID($target)
	while canUseSkill($skillNumber, $target)
		useSkill($skillNumber, $target)
		if dllStructGetData(getAgentById(), "skill") then
			local $castingTimer = timerInit()
			while dllStructGetData(getAgentById(), "skill") and timerDiff($castingTimer) < 5000
				sleep(150)
			wEnd
		else
			sleep(150)
		endIf
	wEnd
endFunc

func canUseSkill($skillNumber, $target = -2)
	if $amDead then return false
	if not isDllStruct($target) then
		$target = getAgentByID($target)
	else
		$target = getAgentByID(dllStructGetData($target, "id"))
	endIf
	local $skillbar = getSkillbar()
	local $skill = getSkillById(dllStructGetData($skillbar, "id" & $skillNumber))
	local $energyCost = getEnergyCost($skill)
	local $adrenalineCost = dllStructGetData($skill, "adrenaline")
	if getMapLoading() <> 1 then return false
	if getIsDead() then return false
	if dllStructGetData($skill, "target") <> 6 and getIsDead($target) then return false
	if dllStructGetData($skillbar, "recharge" & $skillNumber) <> 0 then return false
	if not checkEnergy($energyCost) then return false
	if dllStructGetData($skillbar, "adrenalineA" & $skillNumber) < $adrenalineCost then return false
	if not getIsValidSkillTarget($skill, $target) then return false
	if not skillWeaponRequirementMet($skill) then return false
	if not canUseCombo($skill, $target) then return false
	return true
endFunc

func canUseCombo($skill, $target)
	if not isDllStruct($target) then $target = getAgentByID($target)
	if not isDllStruct($skill) then $skill = getSkillById($skill)
	switch dllStructGetData($skill, "comboReq")
		case 1
			return dllStructGetData($target, "laststrike") == 3
		case 2
			return dllStructGetData($target, "laststrike") == 1
		case 4
			return dllStructGetData($target, "laststrike") == 2
	endSwitch
	return true
endFunc

func checkEnergy($energyCost)
	return $energyCost <= getEnergy()
endFunc

func getIsValidSkillTarget($skill, $agent)
	if not isDllStruct($agent) then $agent = getAgentByID($agent)
	if not isDllStruct($skill) then $skill = getSkillById($skill)
	local $targetAllegiance = dllStructGetData($agent, "allegiance")
	local $skillTarget = dllStructGetData($skill, "target")
	switch $skillTarget
		case 0, 1
			return true
		case 3
			return $targetAllegiance == 1
		case 4
			return ($targetAllegiance == 1 and not getIsPlayer($agent)
		case 5, 16
			return $targetAllegiance == 3
		case 6
			return getIsDead($agent) and getIsPartyMember($agent)
		case 14
			return true ;$targetAllegiance == 5
	endSwitch
	return true
endFunc

func getIsPartyMember($agent)
	if isDllStruct($agent) == 0 then $agent = getAgentByID($agent)
	local $agentTypeMap = dllStructGetData($agent, "typeMap")
	local $agentAllegiance = dllStructGetData($agent, "allegiance")
	return $agentAllegiance == 1 and bitAND($targetTypeMap, 131072))
endFunc

func getIsPlayer($agent)
	if isDllStruct($agent) == 0 then $agent = getAgentByID($agent)
	return bitAND(dllStructGetData($agent, "typeMap"), 4194304)
endFunc

func skillWeaponRequirementMet($skill)
	if not isDllStruct($skill) then $skill = getSkillById($skill)
	local $weaponRequirement = dllStructGetData($skill, "weaponReq")
	local $equipedWeaponType = dllStructGetData(getItemBySlot(17, 1), "type")
	if $weaponRequirement == 0 then return true
	if bitAND($weaponRequirement, 1) and $equipedWeaponType == 2 then return true
	if bitAND($weaponRequirement, 2) and $equipedWeaponType == 5 then return true
	if bitAND($weaponRequirement, 8) and $equipedWeaponType == 32 then return true
	if bitAND($weaponRequirement, 16) and $equipedWeaponType == 15 then return true
	if bitAND($weaponRequirement, 32) and $equipedWeaponType == 35 then return true
	if bitAND($weaponRequirement, 64) and $equipedWeaponType == 36 then return true
	if bitAND($weaponRequirement, 128) and $equipedWeaponType == 27 then return true
	return false
endFunc

#EndRegion Skill Use

#Region Inventory Management
func sellIfNeeded($slotsNeeded = 7)
	if countEmptySlots() <= $slotsNeeded then
		writeLog("Selling drops")
		randomTravel(642)
		local $chest = getAgentByName("Xunlai Chest")
		local $merchant = getAgentByName("Maryann [Merchant]")
		local $rareMaterialTrader = getAgentByName("Roland [Rare Material Trader]")
		local $materialTrader = getAgentByName("Ida [Material Trader]")
		local $dyeTrader = getAgentByName("Amy [Dye Trader]")
		local $runeTrader = getAgentByName("Staci Magicalsen [Rune Trader]")
		;goToNPC($chest)
		GoNearestNPCToCoords(-222, 4388) ;Chest
		;goToNPC($merchant)
		GoNearestNPCToCoords(-2784, 1019) ;Merchant
		writeLog("Identifying")
		doForEachItem("identify", true)
		writeLog("Salvaging")
		doForEachItem("salvage", true)
		writeLog("Storing")
		doForEachItem("store")
		writeLog("Selling")
		doForEachItem("sell")
		writeLog("Selling rare materials")
		;goToNPC($rareMaterialTrader)
		GoNearestNPCToCoords(-2079, 1046) ;Rare Mat Trader
		doForEachItem("sellRareMaterial")
		writeLog("Selling materials")
		;goToNPC($materialTrader)
		GoNearestNPCToCoords(-1867, 803) ;Mat Trader
		doForEachItem("sellMaterial")
		writeLog("Selling dyes")
		;goToNPC($dyeTrader)
		GoNearestNPCToCoords(-1862, 1245) ;Dye Trader
		doForEachItem("sellDye")
		writeLog("Selling runes")
		;goToNPC($runeTrader)
		; GoNearestNPCToCoords(-3368, 2092) ;Rune Trader
		; doForEachItem("sellRune")
		sleep(500 + getPing())
		depositGold(getGoldCharacter())
		$prepared = false
		return true
	endIf
	return false
endFunc

func ensureExpertSalvageKit()
	local $kit = findExpertSalvageKitInBag()
	if not $kit then
		if withdrawGoldIfNeeded(400) then
			local $merchant = getAgentByName("Maryann [Merchant]")
			goToNPC($merchant)
			buyExpertSalvageKitt()
			do
				sleep(100)
				$kit = findExpertSalvageKitInBag()
			until $kit
		endIf
	endIf
	return $kit
endFunc

func salvageItemForModWithKit(byref $item, $modIndex, byref $kit)
	startSalvageWithKit($item, $kit)
	sleep(1000 + getPing())
	salvageMod($modIndex)
	sleep(1000 + getPing())
	$kit = ensureExpertSalvageKit()
	$item = getItemByItemId(dllStructGetData($item, "id"))
	if countEmptySlots() < 2 then
		local $runeTrader = getAgentByName("Staci Magicalsen [Rune Trader]")
		goToNPC($runeTrader)
		doForEachItem("sellRune")
		doForEachItem("store")
	endIf
endFunc

func doForEachItem($function, $extra = false)
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		local $bag = getBag($bagNumber)
		for $slotNumber = 1 to dllStructGetData($bag, "slots")
			local $item = getItemBySlot($bagNumber, $slotNumber)
			if dllStructGetData($item, "id") == 0 then continueLoop
			switch $function
				case "identify"
					if $extra then
						identify($item, $extra)
					else
						identify($item)
					endIf
				case "salvage"
					if $extra then
						salvage($item, $extra)
					else
						salvage($item)
					endIf
				case "store"
					store($item)
				case "sell"
					sell($item)
				case "sellRareMaterial"
					sellRareMaterial($item)
				case "sellMaterial"
					sellMaterial($item)
				case "sellDye"
					sellDye($item)
				case "sellRune"
					sellRune($item)
			endSwitch
		next
	next
endFunc

func skipBag($bagNumber)
	if $bagNumber == 1 and GUICtrlRead($checkbox_useBag1) == $GUI_UNCHECKED then return true
	if $bagNumber == 2 and GUICtrlRead($checkbox_useBag2) == $GUI_UNCHECKED then return true
	if $bagNumber == 3 and GUICtrlRead($checkbox_useBag3) == $GUI_UNCHECKED then return true
	if $bagNumber == 4 and GUICtrlRead($checkbox_useBag4) == $GUI_UNCHECKED then return true
	return false
endFunc



func salvage($item, $amSelling = false)
	for $i = 1 to dllStructGetData($item, "quantity")
		if canSalvage($item) then
			local $quantity = dllStructGetData($item, "quantity")
			local $kit = findSalvageKitInBag()
			if not $kit and $amSelling then
				if withdrawGoldIfNeeded(100) then
					buySalvageKitt()
					do
						sleep(100)
						$kit = findSalvageKitInBag()
					until $kit
				endIf
			endIf	
			if not $kit then return false		
			startSalvageWithKit($item, $kit)			
			do
				sleep(100)
				$item = getItemByItemId(dllStructGetData($item, "id"))
			until dllStructGetData($item, "quantity") < $quantity or dllStructGetData($item, "bag") == "0x00000000"
			sleep(250 + getPing())
		endIf
	next
	return true
endFunc

func canSalvage($item)
	Local $r = GetRarity($item)
	Local $m = DllStructGetData($item, "ModelID")
	local $t = dllStructGetData(($item), "Type")
	 
	if (IsPerfectShield($Item) or IsPerfectStaff($Item) or IsPerfectCaster($Item) or IsReq8Max($Item) or IsRareRune($Item) or IsPerfectMartial($item)) then
		return false
	elseif (IsSpecialItem($Item) or IsPcon($Item))	then 
		return false	
	elseif $t = 146 then ; Dyes
		return False
	elseif $m > 920 And $m < 957 Then ;Materials
		Return False
	elseIf $m = 6532 Or $m = 6533 Then ;Amber & Jadeite
		Return False	
	ElseIf $m = 2991 Or $m = 2992 Or $m = 2989 Or $m = 5899 Then ; Kits
		Return False
	ElseIf $m = 5594 Or $m = 5595 Or $m = 5611 Or $m = 21233 Then ; Gold Scrolls
		Return False	
	elseIf keepValuable($item) then
		return False
	ElseIf $r = $Rarity_White or $r = $Rarity_Blue Then ; Whites & Blues	
		Return True
	EndIf
endFunc	

func findSalvageKitInBag()
	local $kit = false
	local $uses = 101
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		for $slotNumber = 1 to dllStructGetData(getBag($bagNumber), "slots")
			local $item = getItemBySlot($bagNumber, $slotNumber)
			switch dllStructGetData($item, "modelId")
				case $kit_salvage
					if dllStructGetData($item, "value") / 2 < $uses then
						$kit = dllStructGetData($item, "id")
						$uses = dllStructGetData($item, "value") / 2
					endIf
				case else
					continueLoop
			endSwitch
		next
	next
	return $kit
endFunc

func findExpertSalvageKitInBag()
	local $kit = false
	local $uses = 101
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		for $slotNumber = 1 to dllStructGetData(getBag($bagNumber), "slots")
			local $item = getItemBySlot($bagNumber, $slotNumber)
			switch dllStructGetData($item, "modelId")
				case $kit_expertSalvage
					if dllStructGetData($item, "value") / 8 < $uses then
						$kit = dllStructGetData($item, "id")
						$uses = dllStructGetData($item, "value") / 8
					endIf
				case $kit_superiorSalvage
					if dllStructGetData($item, "value") / 10 < $uses then
						$kit = dllStructGetData($item, "id")
						$uses = dllStructGetData($item, "value") / 10
					endIf
				case else
					continueLoop
			endSwitch
		next
	next
	return $kit
endFunc

func buySalvageKitt($quantity = 1)
	buyItem(2, $quantity, 100)
endFunc

func buyExpertSalvageKitt($quantity = 1)
	buyItem(3, $quantity, 400)
endFunc

func startSalvageWithKit($item, $kit)
	local $offset[4] = [0, 0x18, 0x2C, 0x690]
	local $salvageSessionId = memoryReadPtr($mBasePointer, $offset)
	if isDllStruct($item) == 0 then
		local $itemId = $item
	else
		local $itemId = dllStructGetData($item, "id")
	endIf
	dllStructSetData($mSalvage, 2, $itemId)
	dllStructSetData($mSalvage, 3, $kit)
	dllStructSetData($mSalvage, 4, $salvageSessionId[1])
	enqueue($mSalvagePtr, 16)
endFunc

func store($item)
	local $storageNumber
	local $slotNumber
	if (keepStorage($item)) and findEmptyStorageSlot($storageNumber, $slotNumber) then
		moveItem($item, $storageNumber, $slotNumber)
		do
			sleep(25)
		until dllStructGetData(getItemBySlot($storageNumber, $slotNumber), "id") <> 0
	endIf
endFunc

func findEmptyStorageSlot(byref $storageNumber, byref $slotNumber)
	for $storageNumber = 8 to 16
		local $bag = getBag($storageNumber)
		if $bag == 0 then return false
		for $slotNumber = 1 to 20
			local $item = getItemBySlot($storageNumber, $slotNumber)
			if dllStructGetData($item, "id") == 0 then return true
		next
	next
	return false
endFunc

func countEmptySlots()
	local $bag
	local $emptySlots = 0
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		$bag = getBag($bagNumber)
		$emptySlots += dllStructGetData($bag, "slots") - dllStructGetData($bag, "itemsCount")
	next
	return $emptySlots
endFunc

func depositGoldIfNeeded($gold)
	if $gold + getGoldCharacter() > 100000 then
		if getGoldStorage() + getGoldCharacter() < 1000000 then
			depositGold(getGoldCharacter())
			sleep(250 + getPing())
		else
			return false
		endIf
	endIf
	return true
endFunc

func withdrawGoldIfNeeded($neededGold)
	local $netNeededGold = $neededGold - getGoldCharacter()
	if $netNeededGold > 0 then
		if getGoldStorage() >= $netNeededGold then
			withdrawGold($netNeededGold)
			sleep(250 + getPing())
		else
			return false
		endIf
	endIf
	return true
endFunc

func buyKits($idKitsToBuy, $salvageKitsToBuy)
	local $idKits = 0
	local $salvageKits = 0
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		local $bag = getBag($bagNumber)
		for $slotNumber = 1 to dllStructGetData($bag, "slots")
			local $item = getItemBySlot($bagNumber, $slotNumber)
			if dllStructGetData($item, "id") == 0 or dllStructGetData($item, "type") <> $itemType_kit then continueLoop
			switch dllStructGetData($item, "modelId")
				case $kit_identification
					$idKits += 1
				case $kit_salvage
					$salvageKits += 1
			endSwitch
		next
	next
	withdrawGoldIfNeeded(($idKitsToBuy - $idKits + $salvageKitsToBuy - $salvageKits) * 100)
	if $idKitsToBuy - $idKits > 0 then
		buyIdKit($idKitsToBuy - $idKits)
		sleep(250)
	endIf
	if $salvageKitsToBuy - $salvageKits > 0 then
		buySalvageKitt($salvageKitsToBuy - $salvageKits)
		sleep(250)
	endIf
endFunc
#EndRegion Inventory Management

#Region Identifying
func identify($item, $amSelling = false)
	if getRarity($item) == $rarity_white then return
	if (GUICtrlRead($checkbox_storeUnids) == $GUI_CHECKED and getRarity($item) == $rarity_gold) then return
	local $kit = findIdKitInBag()
	if not $kit and $amSelling then
		if withdrawGoldIfNeeded(100) then
			do
				buyIdKit()
				sleep(500)
				$kit = findIdKitInBag()
			until $kit
			sleep(500)
		endIf
	endIf
	if not $kit then return false
	identifyItemWithKit($item, $kit)
	sleep(500 + getPing())
	return true
endFunc

func identifyItemWithKit($item, $kit)
	if getIsIDed($item) then return

	local $itemId
	if IsDllStruct($item) == 0 then
		$itemId = $item
	else
		$itemId = dllStructGetData($item, "id")
	endIf

	sendPacket(0xC, $IdentifyItemHeader, $kit, $itemId)

	local $deadLock = timerInit()
	do
		sleep(20)
	until getIsIDed($itemId) or timerDiff($deadLock) > 5000
	if not getIsIDed($itemId) then identifyItemWithKit($item, $kit)
endFunc

func findIdKitInBag()
	local $kit = false
	local $uses = 101
	for $bagNumber = 1 to 4
		if skipBag($bagNumber) then continueLoop
		for $slotNumber = 1 to dllStructGetData(getBag($bagNumber), "slots")
			local $item = getItemBySlot($bagNumber, $slotNumber)
			switch dllStructGetData($item, "modelId")
				case $kit_identification
					if dllStructGetData($item, "value") / 2 < $uses then
						$kit = dllStructGetData($item, "id")
						$uses = dllStructGetData($item, "value") / 2
					endIf
				case $kit_superiorIdentification
					if dllStructGetData($item, "value") / 2.5 < $uses then
						$kit = dllStructGetData($item, "id")
						$uses = dllStructGetData($item, "value") / 2.5
					endIf
				case else
					continueLoop
			endSwitch
		next
	next
	return $kit
endFunc
#endRegion Identifying

#Region Selling
func sell($item)
	if keepValuable($item) then return
	local $sellPrice = dllStructGetData($item, "value") * dllStructGetData($item, "quantity")
	if $sellPrice > 100000 then return
	if depositGoldIfNeeded($sellPrice) then
		sellItem($item)
		sleep(250 + getPing())
	endIf
endFunc

func sellDye($item)
	if dllStructGetData($item, "type") <> $itemType_dye then return
	if keepDye(dllStructGetData($item, "extraId")) then return
	for $i = 1 to dllStructGetData($item, "quantity")
		if traderRequestSell($item) then
			depositGoldIfNeeded(getTraderCostValue())
			traderSell()
		endIf
	next
endFunc

; func sellRune($item)
	; if dllStructGetData($item, "type") <> $itemType_upgrade then return
	; if traderRequestSell($item) then
		; depositGoldIfNeeded(getTraderCostValue())
		; traderSell()
	; endIf
;endFunc

func sellMaterial($item)
	if dllStructGetData($item, "type") <> $itemType_material then return
	if keepMaterial(dllStructGetData($item, "modelId"), 1) then return
	for $i = 1 to floor(dllStructGetData($item, "quantity") / 10)
		depositGoldIfNeeded(dllStructGetData($item, "value") * 10)
		if traderRequestSell($item) then
			traderSell()
		endIf
	next
endFunc

func sellRareMaterial($item)
	if dllStructGetData($item, "type") <> $itemType_material then return
	if keepMaterial(dllStructGetData($item, "modelId"), 2) then return
	for $i = 1 to dllStructGetData($item, "quantity")
		if traderRequestSell($item) then
			depositGoldIfNeeded(getTraderCostValue())
			traderSell()
		endIf
	next
endFunc
#endRegion Selling

#Region Looting
func loot($distance = 1500)
	if $amDead then return
	if not $amDead then writeLog("Looting")
	if not $amDead then local $item, $itemAgentId, $blockedTimer, $blockedCount
	while not $amDead
		if not $amDead then $item = getNearestItemWithFilter()
		if not $amDead then $itemId = dllStructGetData($item, "id")
		if $amDead or $itemId == 0 or @extended > $distance then exitLoop
		if dllStructGetData(getItemByAgentID(dllStructGetData($item, "id")), "modelId") == 36985 then $commendations += 1
		do
			if not $amDead and $blockedCount <> 0 then onLootBlock()
			if not $amDead then local $blockedTimer = timerInit()
			do
				if not $amDead then pickUpItem($item)
				if not $amDead then sleep(500)
			until $amDead or dllStructGetData(getAgentById($itemId), "id") == 0 or timerDiff($blockedTimer) > 5000
			if not $amDead and dllStructGetData(getAgentById($itemId), "id") <> 0 then $blockedCount += 1
		until $amDead or dllStructGetData(getAgentById($itemId), "id") == 0 or $blockedCount > 5
	wEnd
endFunc

func getNearestItemWithFilter()
	local $nearestItem
	local $nearestDistance = 100000000
	local $distance
	local $agentArray = getAgentArray(0x400)
	
	for $i = 1 to $agentArray[0]
		if not getCanPickUp($agentArray[$i]) then continueLoop
		if skipPickup(getItemByAgentId(dllStructGetData($agentArray[$i], "id"))) then continueLoop
		if dllStructGetData($agentArray[$i], "id") == dllStructGetData(getAgentById(), "") then continueLoop
		$distance = getDistance($agentArray[$i])
		if $distance < $nearestDistance then
			$nearestItem = $agentArray[$i]
			$nearestDistance = $distance
		endIf
	next
	
	setExtended($nearestDistance)
	return $nearestItem
endFunc
#EndRegion Looting

#Region Item Keep

func keepValuable($item)
	local $modelId = dllStructGetData(($item), "modelId")
	local $type = dllStructGetData(($item), "type")
	local $extraId = dllStructGetData(($item), "extraId")
	local $rarity = getRarity($item)
	If $type == $itemType_usable or $type == $itemType_material or $type == $itemType_dye or $type == $itemType_candyCaneShard or $type == $itemType_key or $type == $itemType_trophy or $type == $itemType_scroll or $type == $itemType_kit then
		return true
	elseIf keepStorage($item) or IsSpecialItem($item) then
		return true
	endIf
	return false
endFunc

func keepStorage($item)
	local $modelId = dllStructGetData(($item), "modelId")
	local $type = dllStructGetData(($item), "type")
	local $extraId = dllStructGetData(($item), "extraId")
	local $quantity = dllStructGetData(($item), "quantity")
	local $rarity = getRarity($item)
	if (IsPerfectShield($item) or IsPerfectStaff($item) or IsPerfectCaster($item) or IsPerfectMartial($item) or IsReq8Max($item) or IsRareRune($item) or IsValuableUpgrade($item)) then
		return true
	elseIf IsSpecialItem($item) and $quantity == 250 then
		return true
	elseIf $type == $itemType_minipet then
		return true
	elseIf $type == $itemType_upgrade then
		return true
	elseIf ($type == $itemType_usable or $type == $itemType_candyCaneShard or $type == $itemType_key or $type == $itemType_trophy or $type == $itemType_scroll) and $quantity == 250 then
		return true
	elseIf keepMaterial($modelId) and $quantity == 250 then
		return true
	elseIf keepDye($extraId) and $quantity == 250 then
		return true
	elseif (GUICtrlRead($checkbox_storeUnids) == $GUI_CHECKED and getRarity($item) == $rarity_gold) then
		return true
	endIf
	return false
endFunc

;sellingMaterial: 0 = check both, 1 = check common, 2 = check rare
func keepMaterial($modelId, $sellingMaterial = 0)
	if $sellingMaterial <> 1 then
		switch $modelId
			case $material_amber
				return GUICtrlRead($checkbox_keepAmber) == $GUI_CHECKED
			case $material_charcoal
				return GUICtrlRead($checkbox_keepCharcoal) == $GUI_CHECKED
			case $material_claw
				return GUICtrlRead($checkbox_keepClaw) == $GUI_CHECKED
			case $material_damask
				return GUICtrlRead($checkbox_keepDamask) == $GUI_CHECKED
			case $material_deldrimorSteel
				return GUICtrlRead($checkbox_keepDeldrimorSteel) == $GUI_CHECKED
			case $material_diamond
				return GUICtrlRead($checkbox_keepDiamond) == $GUI_CHECKED
			case $material_ectoplasm
				return GUICtrlRead($checkbox_keepEctoplasm) == $GUI_CHECKED
			case $material_elonianLeather
				return GUICtrlRead($checkbox_keepElonianLeather) = $GUI_CHECKED
			case $material_eye
				return GUICtrlRead($checkbox_keepEye) == $GUI_CHECKED
			case $material_fang
				return GUICtrlRead($checkbox_keepFang) == $GUI_CHECKED
			case $material_fur
				return GUICtrlRead($checkbox_keepFur) == $GUI_CHECKED
			case $material_glassVial
				return GUICtrlRead($checkbox_keepGlassVial) == $GUI_CHECKED
			case $material_jadeite
				return GUICtrlRead($checkbox_keepJadeite) == $GUI_CHECKED
			case $material_leather
				return GUICtrlRead($checkbox_keepLeather) == $GUI_CHECKED
			case $material_linen
				return GUICtrlRead($checkbox_keepLinen) == $GUI_CHECKED
			case $material_obsidianShard
				return GUICtrlRead($checkbox_keepObsidianShard) == $GUI_CHECKED
			case $material_onyx
				return GUICtrlRead($checkbox_keepOnyx) == $GUI_CHECKED
			case $material_parchment
				return GUICtrlRead($checkbox_keepParchment) == $GUI_CHECKED
			case $material_ruby
				return GUICtrlRead($checkbox_keepRuby) == $GUI_CHECKED
			case $material_sapphire
				return GUICtrlRead($checkbox_keepSapphire) == $GUI_CHECKED
			case $material_silk
				return GUICtrlRead($checkbox_keepSilk) == $GUI_CHECKED
			case $material_spiritwood
				return GUICtrlRead($checkbox_keepSpiritwood) == $GUI_CHECKED
			case $material_steel
				return GUICtrlRead($checkbox_keepSteel) == $GUI_CHECKED
			case $material_vellum
				return GUICtrlRead($checkbox_keepVellum) == $GUI_CHECKED
			case $material_vialOfInk
				return GUICtrlRead($checkbox_keepVialOfInk) == $GUI_CHECKED
			case else
				if $sellingMaterial == 2 then return true
		endSwitch
	endIf
	if $sellingMaterial <> 2 then
		switch $modelId
			case $material_bone
				return GUICtrlRead($checkbox_keepBone) == $GUI_CHECKED
			case $material_chitin
				return GUICtrlRead($checkbox_keepChitin) == $GUI_CHECKED
			case $material_cloth
				return GUICtrlRead($checkbox_keepCloth) == $GUI_CHECKED
			case $material_dust
				return GUICtrlRead($checkbox_keepDust) == $GUI_CHECKED
			case $material_feather
				return GUICtrlRead($checkbox_keepFeather) = $GUI_CHECKED
			case $material_fiber
				return GUICtrlRead($checkbox_keepFiber) == $GUI_CHECKED
			case $material_granite
				return GUICtrlRead($checkbox_keepGranite) == $GUI_CHECKED
			case $material_iron
				return GUICtrlRead($checkbox_keepIron) == $GUI_CHECKED
			case $material_scale
				return GUICtrlRead($checkbox_keepScale) == $GUI_CHECKED
			case $material_tannedHide
				return GUICtrlRead($checkbox_keepTannedHide) == $GUI_CHECKED
			case $material_wood
				return GUICtrlRead($checkbox_keepWood) == $GUI_CHECKED
			case else
				if $sellingMaterial == 1 then return true
		endSwitch
	endIf
	return false
endFunc

func keepDye($extraId)
	switch $extraId
		case $dye_green
			return GUICtrlRead($checkbox_keepGreen) == $GUI_CHECKED
		case $dye_purple
			return GUICtrlRead($checkbox_keepPurple) == $GUI_CHECKED
		case $dye_yellow
			return GUICtrlRead($checkbox_keepYellow) == $GUI_CHECKED
		case $dye_brown
			return GUICtrlRead($checkbox_keepBrown) == $GUI_CHECKED
		case $dye_orange
			return GUICtrlRead($checkbox_keepOrange) == $GUI_CHECKED
		case $dye_gray
			return GUICtrlRead($checkbox_keepGray) == $GUI_CHECKED
		case $dye_silver
			return GUICtrlRead($checkbox_keepSilver) == $GUI_CHECKED
		case $dye_blue
			return GUICtrlRead($checkbox_keepBlue) == $GUI_CHECKED
		case $dye_red
			return GUICtrlRead($checkbox_keepRed) == $GUI_CHECKED
		case $dye_pink
			return GUICtrlRead($checkbox_keepPink) == $GUI_CHECKED
		case $dye_white
			return GUICtrlRead($checkbox_keepWhite) == $GUI_CHECKED
		case $dye_black
			return GUICtrlRead($checkbox_keepBlack) == $GUI_CHECKED
	endSwitch
	return False
EndFunc	
#EndRegion Item Keep

func randomTravel($mapId)
	if getMapId() == $mapId and getMapLoading() == 0 then return true
	local $region = getRegion()
	local $district = 0
	local $language = getLanguage()
	if $randomTravelEnabled then 
		$region = random(1, 4, 1)
		if $region == 2 then
			$language = random(0, 7, 1)
			if $language == 6 or $language == 7 then
				$language = random(9, 10, 1)
			endIf
		else
			$language = 0
		endIf
	endIf
	moveMap($mapId, $region, $district, $language)
	return waitMapLoadingFast($mapId)
EndFunc

func waitMapLoadingFast($mapId = 0, $deadlock = 15000)
	local $mapLoading
	local $deadLockTimer = timerInit()
	initMapLoad()
	do
		sleep(100)
		$mapLoading = getMapLoading()
		if $mapLoading == 2 then $deadLockTimer = timerInit()
		if timerDiff($deadLockTimer) > $deadlock then return false
	until $mapLoading <> 2 and getMapIsLoaded() and (getMapId() = $mapId Or $mapId = 0)
	sleep(500)
	return true
endFunc

func getMaxPartySize($aMapID)
	switch $aMapID
	case 293, 294, 295, 296, 721, 368, 188, 467, 497
		return 1
	case 163, 164, 165, 166
		return 2
	case 28, 29, 30, 32, 36, 39, 40, 81, 131, 135, 148, 189, 214, 242, 249, 251, 281, 282, 431, 449, 479, 491, 502, 544, 555, 795, 796, 811, 815, 816, 818, 819, 820, 855, 856
		return 4
	case 10, 11, 12, 14, 15, 16, 19, 21, 25, 38, 49, 55, 57, 73, 109, 116, 117, 118, 119, 132, 133, 134, 136, 137, 139, 140, 141, 142, 152, 153, 154, 213, 250, 385, 808, 809, 810
		return 6
	Case 266, 307
		return 12
	case else
		return 8
	endSwitch
endFunc

func getPlayersInParty()
	local $offset[5] = [0, 0x18, 0x4C, 0x54, 0xC]
	local $playersInParty = MemoryReadPtr($mBasePointer, $offset)
	return memoryRead($playersInParty[0], "long")
endFunc

Func GoNearestNPCToCoords($x, $y)
	Do
		RndSleep(250)
		$guy = GetNearestNPCToCoords($x, $y)
	Until DllStructGetData($guy, 'Id') <> 0
	ChangeTarget($guy)
	RndSleep(250)
	move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 0)
	RndSleep(500)
	GoNPC($guy)
	RndSleep(250)
	Do
		RndSleep(500)
		move(DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y'), 0)
		RndSleep(500)
		GoNPC($guy)
		RndSleep(250)
		$Me = GetAgentByID(-2)
	Until ComputeDistance(DllStructGetData($Me, 'X'), DllStructGetData($Me, 'Y'), DllStructGetData($guy, 'X'), DllStructGetData($guy, 'Y')) < 250
	RndSleep(1000)
EndFunc

#Region Consolestuff
func startButtonClickedHandler()
	if $botRunning then
		GUICtrlSetData($button_start, "Pausing after run")
		GUICtrlSetState($button_start, $GUI_DISABLE)
		$botRunning = false
		$pauseHandled = false
	elseIf $BotInitialized then
		GUICtrlSetData($button_start, "Pause")
		$botRunning = true
		$timer_run = TimerInit()
		adlibRegister("updateTime", 1000)
	else
		writeLog("Initializing")
		local $characterName = GUICtrlRead($input_characterName)
		if $characterName == "" then
			if not initialize(processExists("gw.exe"), false) then
				writeLog("Guild Wars is not running.")
				return
			endIf
		else
			if not initialize($characterName, false) then
				writeLog("Guild Wars is not running or character was not found.")
				return
			endIf
		endIf

		$timer_run = TimerInit()
		adlibRegister("updateTime", 1000)
		GUICtrlSetData($button_start, "Pause")
		GUICtrlSetState($checkbox_disableRendering, $GUI_ENABLE)
		GUICtrlSetState($input_characterName, $GUI_DISABLE)
		$botRunning = true
		$botInitialized = true
		writeLog("Starting")
	endIf
endFunc

func toggleRendering()
	; if GUICtrlRead($checkbox_disableRendering) == $GUI_CHECKED then
	if $renderingEnabled then
		disableRendering()
		winSetState(getWindowHandle(), "", @SW_HIDE)
		$renderingEnabled = False
	else
		enableRendering()
		winSetState(getWindowHandle(), "", @SW_SHOW)
		$renderingEnabled = True
	endIf
endFunc

Func _PurgeHook()
	toggleRendering()
	Sleep(Random(2000,2500))
	toggleRendering()
EndFunc

func toggleRandomTravel()
	$randomTravelEnabled = not $randomTravelEnabled
endFunc

func toggleOnTop()
	if GUICtrlRead($checkbox_onTop) == $GUI_CHECKED then
		winSetOnTop($window, "", 1)
	else
		winSetOnTop($window, "", 0)
	endIf
endFunc

func writeLog($text, $logToConsole = true, $logToFile = false)
	if $logToConsole then
		local $textLength = stringLen($text)
		local $consoleLength = _GUICtrlEdit_GetTextLen($edit_log)
		if $textLength + $consoleLength > 30000 then GUICtrlSetData($edit_log, StringRight(_GUICtrlEdit_GetText($edit_log), 30000 - $textLength - 1000))
		_GUICtrlEdit_AppendText($edit_log, @CRLF & "[" & @HOUR & ":" & @MIN & "]" & " " & $text)
	endIf
	if $logToFile then
		local $logFile = fileOpen(@ScriptDir & "\" & $botName & ".log", 1)
		_fileWriteLog($logFile, $text)
		fileClose($logFile)
	endIf
endFunc

func updateTime()
	local $hours
	local $minutes
	local $seconds
	_TicksToTime(timerDiff($timer_run) + $accumulatedTime, $hours, $minutes, $seconds)
	if $hours < 10 then $hours = "0" & $hours
	if $minutes < 10 then $minutes = "0" & $minutes
	if $seconds < 10 then $seconds = "0" & $seconds
	GUICtrlSetData($label_time, $hours & ":" & $minutes & ":" & $seconds)
endFunc

func closeWindowHandler()
	exit
endFunc

func gui_eventHandler()
	switch (@GUI_CtrlId)
		case $GUI_EVENT_CLOSE
			If $RenderingEnabled = False Then
				EnableRendering()
				WinSetState(GetWindowHandle(), "", @SW_SHOW)
			EndIf
			exit
	endSwitch
endFunc
#EndRegion ConsoleStuff
