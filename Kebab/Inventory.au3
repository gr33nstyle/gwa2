#include-once
#include "../GWA2.au3"

#region Configuration
	;========> OPTION
	Global $identifyKit = 6 ;Identification kit = 5 || Superior identification kit = 6
	Global $salvageKit = 2 ;Salvage kit = 2 || Expert salvage kit = 3 || Superior Salvage Kit = 4
#endregion

#region identification
Func identifyAllBag($lastBag = 4)
	Local $tmp = identifyRemaining($lastBag)
	If $tmp < numberOfSlot(1, $lastBag) Then
		If Not buyIdentifyKit(1) Then Return False
	EndIf
	For $i = 0 To $lastBag
		IdentifyBag($i)
	Next
EndFunc

Func nextIdentifyKitUseRemaining($lastBag = 4)
	Local $kitArr = kitInfo($identifyKit)
	If Not isArray($kitArr) Then Return False
	For $i = 0 To $lastBag
		For $j = 0 To DllStructGetData(GetBag($i), 'slots')
			$item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelID') = $kitArr[0] Then Return Round(DllStructGetData($item, 'Value')/$kitArr[3])
		Next
	Next
	Return 0
EndFunc

Func identifyRemaining($lastBag = 4)
	Local $kitArr = kitInfo($identifyKit)
	If Not isArray($kitArr) Then Return False
	Local $count = 0
	For $i = 0 To $lastBag
		For $j = 0 To DllStructGetData(GetBag($i), 'slots')
			$item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelID') = $kitArr[0] Then $count += Round(DllStructGetData($item, 'Value')/$kitArr[3])
		Next
	Next
	Return $count
EndFunc

Func buyIdentifyKit($quantity)
	If $quantity = 0 Then Return False
	If Not findMerchant() Then Return False
	Local $kitArr = kitInfo($identifyKit)
	If Not isArray($kitArr) Then Return False
	GoToNPC(findMerchant())
	WithdrawGold($kitArr[2]*$quantity)
	sleep(GetPing() + 100)
	BuyItem($kitArr[1], $quantity, $kitArr[2])
	sleep(GetPing() + 250)
	Return True
EndFunc
#endregion

#region salvage
Func salvageBag($bag)
	For $i = 0 To DllStructGetData(GetBag($bag), 'slots')
		If nextSalvageKitUseRemaining() = 0 Then
			If Not buySalvageKit(1) Then Return False
		EndIf
		$item = GetItemBySlot($bag, $i)
		If canSalvage($item) Then
			$quant = DllStructGetData($item, 'Quantity')
			While $quant > 0
				If $salvageKit = 2 Then
					startNormSalvage($item)
				Else
					startSalvage($item)
				EndIf
				sleep(GetPing() + 250)
				If GetRarity($item) <> 2621 Then SalvageMaterials()
				sleep(GetPing() + 500)
				$quant -= 1
			WEnd
		EndIf
	Next
EndFunc

Func nextSalvageKitUseRemaining($lastBag = 4)
	Local $kitArr = kitInfo($salvageKit)
	If Not isArray($kitArr) Then Return False
	For $i = 0 To $lastBag
		For $j = 0 To DllStructGetData(GetBag($i), 'slots')
			$item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelID') = $kitArr[0] Then Return Round(DllStructGetData($item, 'Value')/$kitArr[3])
		Next
	Next
	Return 0
EndFunc

Func salvageRemaining($lastBag = 4)
	Local $kitArr = kitInfo($salvageKit)
	If Not isArray($kitArr) Then Return False
	Local $count = 0
	For $i = 1 To $lastBag
		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
			$item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelID') = $kitArr[0] Then $count += Round(DllStructGetData($item, 'Value')/$kitArr[3])
		Next
	Next
	Return $count
EndFunc

;~ ;Func buySalvageKit($quantity)
;~ 	If $quantity = 0 Then Return False
;~ 	If Not findMerchant() Then Return False
;~ 	Local $kitArr = kitInfo($salvageKit)
;~ 	If Not isArray($kitArr) Then Return False
;~ 	GoToNPC(findMerchant())
;~ 	WithdrawGold($kitArr[2]*$quantity)
;~ 	sleep(GetPing() + 100)
;~ 	BuyItem($kitArr[1], $quantity, $kitArr[2])
;~ 	sleep(GetPing() + 250)
;~ EndFunc

Func canSalvage($item)
	Local $r = GetRarity($item)
	Local $m = DllStructGetData($item, 'ModelID')
	Local $t = DllStructGetData($item, 'Type')
	Local $e = DllStructGetData($item, 'ExtraId')
	Local $typeIndex = convertType($t)
	If $typeIndex = 0 Then Return False

	If isWeapon($typeIndex) Then
		If goodType($typeIndex, $typeStruct) And goodRarity($r, $rarityStruct) Then Return True
	Else
		If goodType($typeIndex, $typeStruct) Then Return True
	EndIf

	Return False
EndFunc
#endregion

#region sell
Func sellInventory($lastBag = 4)
	If Not findMerchant() Then Return False
	GoToNPC(findMerchant())
	For $i = 1 To $lastBag
		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
			$item = GetItemBySlot($i, $j)
			If canSell($item) Then SellItem($item)
		Next
	Next
EndFunc

Func canSell($item)
	Local $r = GetRarity($item)
	Local $m = DllStructGetData($item, 'ModelID')
	Local $t = DllStructGetData($item, 'Type')
	Local $e = DllStructGetData($item, 'ExtraId')
	Local $typeIndex = convertType($t)
	If $typeIndex = 0 Then Return False

	If $m = 146 And DllStructGetData($typeStruct, 'dye') Then
		If goodDye($e, $dyeStruct) Then Return True
	EndIf
	If isWeapon($typeIndex) Then
		If goodType($typeIndex, $typeStruct) And goodRarity($r, $rarityStruct) Then Return True
	Else
		If goodType($typeIndex, $typeStruct) Then Return True
	EndIf

	Return False
EndFunc
#endregion

#region storage
Func storage($bag)
	If Not findXunlai() Then Return False
	GoToNPC(findXunlai())
	For $i = 1 To DllStructGetData(GetBag($bag), 'slots')
		$item = GetItemBySlot($bag, $i)
		If canStorage($item) Then
			Local $slot = findSlot($item)
			MoveItem($item, $slot[0], $slot[1])
		EndIf
	Next
EndFunc

Func canStorage($item)
	Local $r = GetRarity($item)
	Local $m = DllStructGetData($item, 'ModelID')
	Local $t = DllStructGetData($item, 'Type')
	Local $e = DllStructGetData($item, 'ExtraId')
	Local $typeIndex = convertType($t)
	If $typeIndex = 0 Then Return False

	If $m = 146 And DllStructGetData($typeStruct, 'dye') Then
		If goodDye($e, $dyeStruct) Then Return True
	EndIf
	If isWeapon($typeIndex) Then
		If goodType($typeIndex, $typeStruct) And goodRarity($r, $rarityStruct) Then Return True
	Else
		If goodType($typeIndex, $typeStruct) Then Return True
	EndIf

	Return False
EndFunc

Func findSlot($item, $lastBag = 4)
	Local $slot
	If isStackable($item) Then
		$slot = findSameItemSlot($item, 1, $lastBag, 1)
		If Not isArray($slot) Then $slot = findNextCleanSlot(1, $lastBag)
		Return $slot
	Else
		$slot = findNextCleanSlot(1, $lastBag)
		Return $slot
	EndIf
	Return False
EndFunc

Func findNextCleanSlot($firstBag = 1, $lastBag = 4, $firstSlot = 1)
	For $i = $firstBag To $lastBag
		For $j = $firstSlot To DllStructGetData(GetBag($i), 'slots')
			$firstSlot = 1
			If GetItemBySlot($i, $j) = 0 Then
				$array[2] = [$i, $j]
				Return $array
			EndIf
		Next
	Next
EndFunc

Func findSameItemSlot($item, $firstBag = 1, $lastBag = 4, $firstSlot = 1)
	If IsDllStruct($item) Then $item = DllStructGetData($item, 'ModelID')
	For $i = $firstBag To $lastBag
		For $j = $firstSlot To DllStructGetData(GetBag($i), 'slots')
			$firstSlot = 1
			Local $itemSlot = GetItemBySlot($i, $j)
			If DllStructGetData($itemSlot, 'ModelID') = $item And DllStructGetData($itemSlot, 'Quantity') < 250 Then
				$array[2] = [$i, $j]
				Return $array
			EndIf
		Next
	Next
	Return False
EndFunc
#endregion

#region pickUp
Func pickUpLoot($rarityStruct, $typeStruct, $dyeStruct)
	Local $me, $agent, $distance, $item
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		Local $agent = GetAgentByID($i)
		If Not GetIsMovable($agent) Then ContinueLoop
		$distance = GetDistance($agent)
	    If $distance > 2000 Then ContinueLoop
		$item = GetItemByAgentID($i)
		If canPickup($item, $rarityStruct, $typeStruct, $dyeStruct) Then
			If $distance > 150 Then MoveTo(DllStructGetData($agent, 'X'), DllStructGetData($agent, 'Y'), 100)
			PickUpItem($item)
			sleep(GetPing() + 250)
		EndIf
	Next
	Return True
EndFunc

Func canPickUp($item, $rarityStruct, $typeStruct, $dyeStruct)
	Local $r = GetRarity($item)
	Local $m = DllStructGetData($item, 'ModelID')
	Local $t = DllStructGetData($item, 'Type')
	Local $e = DllStructGetData($item, 'ExtraId')
	Local $typeIndex = convertType($t)
	If $typeIndex = 0 Then Return False

	If $m = 146 And DllStructGetData($typeStruct, 'dye') Then
		If goodDye($e, $dyeStruct) Then Return True
	EndIf
	If isWeapon($typeIndex) Then
		If goodType($typeIndex, $typeStruct) And goodRarity($r, $rarityStruct) Then Return True
	Else
		If goodType($typeIndex, $typeStruct) Then Return True
	EndIf

	Return False
EndFunc
#endregion

#region autre fonction en rapport avec gw
Func freeSlot($lastBag = 4)
	Local $count = 0
	For $i = 1 To $lastBag
		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
			Local $item = GetItemBySlot($i, $j)
			If DllStructGetData($item, 'ModelID') = 0 Then $count += 1
		Next
	Next
	Return $count
EndFunc

Func numberOfSlot($firstBag = 1, $lastBag = 4)
	Local $count = 0
	For $i = 0 To $lastBag
		$count += DllStructGetData(GetBag($i), 'slots')
	Next
	Return $count
EndFunc

Func findXunlai()
	Local $language = scanLanguageMod()
	;English | Korean | French | German | Italian | Spanish | Chinese | Japanese | Polish | Russian | Bork
	Local $chestName[11] = [ _
							"Xunlai Chest", "", "Coffre Xunlai", "Xunlai-Truhe", "Forziere Xunlai", _
							"", "", "", "", "", ""]
	Return GetAgentByName($chestName[$language])
EndFunc

Func findMerchant()
	Local $language = scanLanguageMod()
	;English | Korean | French | German | Italian | Spanish | Chinese | Japanese | Polish | Russian | Bork
	Local $merchantName[11] = [ _
							"Merchant", "", "Marchand", "Kaufmann", "Mercante", "", "", "", "", "", ""]
	Return GetAgentByName($merchantName[$language])
EndFunc

Func scanLanguageMod()
	Local $lang = GetDisplayLanguage()
	If $lang <= 7 Then Return $lang
	If $lang <= 10 Then Return ($lang - 1)
	If $lang = 17 Then Return 10
EndFunc

Func goodRarity($r, $struct)
	If $r = 2627 And DllStructGetData($struct, 'green') Then Return True ; Green
	If $r = 2624 And DllStructGetData($struct, 'gold') Then Return True ; Gold
	If $r = 2626 And DllStructGetData($struct, 'purple') Then Return True ; Purple
	If $r = 2623 And DllStructGetData($struct, 'blue') Then Return True ; Blue
	If $r = 2621 And DllStructGetData($struct, 'white') Then Return True ; White
	Return False
EndFunc

Func goodType($typeIndex, $struct)
	If DllStructGetData($struct, $typeIndex) Then Return True
	Return False
EndFunc

Func goodDye($e, $struct)
	If DllStructGetData($struct, ($e - 1)) Then Return True
	Return False
EndFunc

Func convertType($t)
	Local $arr[19] = [18, 2, 5, 12, 15, 22, 24, 26, 27, 32, 35, 36, 10, 34, 18, 20, 31, 11, 30]
	For $i = 1 To $arr[0]
		If $t = $arr[$i] Then Return $i
	Next
	Return False
EndFunc

Func isWeapon($typeIndex)
	If $typeIndex > 0 And $typeIndex <= 11 Then Return True
	Return False
EndFunc

Func kitInfo($pos)
	Local $arr[4] = [0, $pos, 0, 0]
	If $pos = 2 Then
		$arr[0] = 2992
		$arr[2] = 100
		$arr[3] = 2
		Return $arr
	EndIf
	If $pos = 3 Then
		$arr[0] = 2991
		$arr[2] = 400
		$arr[3] = 8
		Return $arr
	EndIf
	If $pos = 4 Then
		$arr[0] = 5900
		$arr[2] = 2000
		$arr[3] = 10
		Return $arr
	EndIf
	If $pos = 5 Then
		$arr[0] = 2989
		$arr[2] = 100
		$arr[3] = 2
		Return $arr
	EndIf
	If $pos = 6 Then
		$arr[0] = 5899
		$arr[2] = 500
		$arr[3] = 2.5
		Return $arr
	EndIf
	Return False
EndFunc

Func isStackable($item)
	Local $t = DllStructGetData($item, 'Type')
	If $t = 9 Or $t = 11 Or $t = 18 Or $t = 30 Or $t = 31 Then Return True ; Usable | Material | Key | Trophy(Feathered Crest, Glacial Stone, etc) | Scroll
	If isConsumable($item) Then Return True
	Return False
EndFunc

Func isConsumable($item)
	Local $m = DllStructGetData($item, 'ModelID')
	Local $consumable[39] = [38, _
		22752, 22269, 28436, 31152, 31151, 31153, 35121, 28433, 26784, _
		6370, 21488, 21489, 22191, 24862, 21492, 22644, 30855, 5585, _
		24593, 6375, 22190, 6049, 910, 28435, 6369, 21809, 21810, 21813, _
		6376, 6368, 29436, 21491, 28434, 21812, 35124, 37765, 22191, 22190]
	For $i = 0 To $consumable[0]
		If $m = $consumable[$i] Then Return True
	Next
	Return False
EndFunc
#endregion

#region fonction sans rapport avec gw
Func createBoolStruct($string)
	Local $arr = StringSplit($string, "|")
	Local $arrV[$arr[0]]
	Local $stringConca = "struct;"
	For $i = 1 To $arr[0]
		Local $tmp = StringSplit($arr[$i], "=")
		$arrV[$i-1] = strToBool($tmp[2])
		$stringConca &= "BOOL " & $tmp[1] & ";"
	Next
	$stringConca &= "endstruct"
	Local $struct = DllStructCreate($stringConca)
	For $i = 1 To $arr[0]
		DllStructSetData($struct, $i, strToBool($arrV[$i-1]))
	Next
	Return $struct
EndFunc

Func modifyStruct($struct, $string)
	Local $arr = StringSplit($string, "|")
	For $i = 1 To $arr[0]
		Local $tmp = StringSplit($arr[$i], "=")
		If $arr[0] > 0 Then DllStructSetData($struct, $tmp[1], strToBool($tmp[2]))
	Next
EndFunc

Func strToBool($str)
	If StringUpper($str) = "TRUE" Then Return True
	Return False
EndFunc

Func readConfig($path = "config.ini", $firstLine = 1, $lastLine = 0) ; if $lastLine = 0 then we readLine through all file
	Local $size = $lastLine
	If $size = 0 Then $size = 11
	Local $arr[$size + 1]
	$arr[0] = $size
	Local $file = FileOpen($path)
	For $i = $firstLine To $arr[0]
		$arr[$i] = FileReadLine($path, $i)
	Next
	FileClose($file)
EndFunc

Func editConfig($strArr, $path = "config.ini")
	If Not FileExists($path) Then FileWrite($path)
	Local $file = FileOpen($path, 2)
	For $i = 1 To $strArr[0]
		FileWriteLine($file, $strArr[$i])
	Next
	FileClose($file)
	Return True
EndFunc

Func getDefaultConfig()
	Local $rarityS = "green=False|gold=False|purple=False|blue=False|white=False"
	Local $typeS = "axe=False|bow=False|offHand=False|hammer=False|wand=False|shield=False|staff=False|sword=False|dagger=False|scythe=False|spear=False|dye=False|minipet=False|key=False|goldCoin=False|scroll=False|material=False|trophy=False"
	Local $raritySe = "green=False|gold=False|purple=False|blue=False|white=False"
	Local $typeSe = "axe=False|bow=False|offHand=False|hammer=False|wand=False|shield=False|staff=False|sword=False|dagger=False|scythe=False|spear=False|dye=False|minipet=False|key=False|goldCoin=False|scroll=False|material=False|trophy=False"
	Local $dyeSe = "blue=False|green=False|purple=False|red=False|yellow=False|brown=False|orange=False|silver=False|black=False|gray=False|white=False|pink=False"
	Local $raritySt = "green=False|gold=False|purple=False|blue=False|white=False"
	Local $typeSt = "axe=False|bow=False|offHand=False|hammer=False|wand=False|shield=False|staff=False|sword=False|dagger=False|scythe=False|spear=False|dye=False|minipet=False|key=False|goldCoin=False|scroll=False|material=False|trophy=False"
	Local $dyeSt = "blue=False|green=False|purple=False|red=False|yellow=False|brown=False|orange=False|silver=False|black=False|gray=False|white=False|pink=False"
	Local $rarityP = "green=False|gold=False|purple=False|blue=False|white=False"
	Local $typeP = "axe=False|bow=False|offHand=False|hammer=False|wand=False|shield=False|staff=False|sword=False|dagger=False|scythe=False|spear=False|dye=True|minipet=False|key=False|goldCoin=True|scroll=False|material=True|trophy=True"
	Local $dyeP = "blue=False|green=False|purple=False|red=False|yellow=False|brown=False|orange=False|silver=False|black=True|gray=False|white=True|pink=False"
	Local $arr[12] = [11, $rarityS, $typeS, $raritySe, $typeSe, $dyeSe, $raritySt, $typeSt, $dyeSt, $rarityP, $typeP, $dyeP]
	Return $arr
EndFunc

Func getDefaultStructConfig()
	Local $defaultConf = getDefaultConfig()
	Local $arr[$defaultConf[0] + 1]
	$arr[0] = $defaultConf[0]
	For $i = 1 To $arr[0]
		$arr[$i] = createBoolStruct($defaultConf[$i])
	Next
	Return $arr
EndFunc
#endregion

#region fonction GWA2 modifie
Func startNormSalvage($aItem)
	Local $lOffset[4] = [0, 0x18, 0x2C, 0x62C]
	Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)

	If IsDllStruct($aItem) = 0 Then
		Local $lItemID = $aItem
	Else
		Local $lItemID = DllStructGetData($aItem, 'ID')
	EndIf

	Local $lSalvageKit = findNormSalvageKit()
	If $lSalvageKit = 0 Then Return

	DllStructSetData($mSalvage, 2, $lItemID)
	DllStructSetData($mSalvage, 3, findNormSalvageKit())
	DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])

	Enqueue($mSalvagePtr, 16)
EndFunc

Func findNormSalvageKit()
	Local $lItem
	Local $lKit = 0
	Local $lUses = 101
	For $i = 1 To 16
		For $j = 1 To DllStructGetData(GetBag($i), 'Slots')
			$lItem = GetItemBySlot($i, $j)
			Switch DllStructGetData($lItem, 'ModelID')
				Case 2991
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
			    Case 2992
					If DllStructGetData($lItem, 'Value') / 8 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 8
					EndIf
				Case 5900
					If DllStructGetData($lItem, 'Value') / 10 < $lUses Then
						$lKit = DllStructGetData($lItem, 'ID')
						$lUses = DllStructGetData($lItem, 'Value') / 10
					EndIf
				Case Else
					ContinueLoop
			EndSwitch
		Next
	Next
	Return $lKit
EndFunc
#endregion