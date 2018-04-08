#include-once
#include <Math.au3>
#include <Gui.au3>
#include <GlobalConstants.au3>

If @AutoItX64 Then
	MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
	Exit
EndIf

Func CanPickUp($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	Local $rarity = GetRarity($aItem)
	Local $lType = DllStructGetData(($aItem), 'Type')
	Local $req = GetItemReq($aItem)
;~ 	If IsBrambleBow($aItem) Then Return True
;~ 	If $LMODELID == 868 Or $LMODELID == 957 Or $LMODELID == 904 Then Return True
	If $lModelID == 2511 And GetGoldCharacter() < 99000 And DllStructGetData($aItem, 'Quantity') > 32 Then
;~ 		ConsoleWrite(@CRLF & "---------add Gold quantity " & DllStructGetData($aItem,'Quantity') & @TAB &  "Value  " & DllStructGetData($aItem,'Value') &@TAB & @TAB )
		addToPlatinCount(DllStructGetData($aItem,'Value'))
		Return True	; gold coins (only pick if character has less than 99k in inventory)
	EndIf

	If isMaterial($aItem) Then
		Local $tabNr = getTabNrByName("LootMatsTab")
;~ 		ConsoleWrite(@CRLF)
		For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
;~ 			ConsoleWrite(@CRLF & "!" & $GDIIndex & ": " & "$lModelID " & $lModelID & @TAB & "StuctID " & DllStructGetData($MatsStruct,"ItemID",$GDIIndex))
;~ 			ConsoleWrite(@TAB & "Ticked " & DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex))
;~ 			If $lModelID = DllStructGetData($TabArrayOfStructs[$tabNr],"ItemID",$GDIIndex) And DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
			If $lModelID = DllStructGetData($MatsStruct,"ItemID",$GDIIndex) And DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				Return True
			EndIf
		Next
	EndIf

	If IsIronItem($aItem)  Then
		$SkaleTeethDropsCount += 1
		GUICtrlSetData($LootIronItemsCountLable, $LootIronItemsCheckbox)
		If GUICtrlRead($LootIronItemsCheckbox) == $GUI_CHECKED Then Return True
	EndIf
	If $lModelID == getItemIDByName('Glacial Stones') Then
		$LootGlacialStoneCount += DllStructGetData($aItem, 'Quantity')
		GUICtrlSetData($LootGlacialStoneDropsCountLable, $LootGlacialStoneCount)
		If GUICtrlRead($LootGlacialStoneCheckbox) == $GUI_CHECKED Then Return True
	EndIf

;~ 	If $lModelID = getItemIDByName('Skale Fins') Then
;~ 		$FinsDropsCount += DllStructGetData($aItem, 'Quantity')
;~ 		GUICtrlSetData($FinsDropsCountlable,$FinsDropsCount)
;~ 		Return True
;~ 	EndIf

;~ 	If IsUsefulScythe($aItem) Then  ;pickup blue q0 scythe
;~ 		$LootReq0ScytheCount += 1
;~ 		GUICtrlSetData($LootReq0ScytheCountLable,$LootReq0ScytheCount)
;~ 		If GUICtrlRead($LootReq0ScytheCheckbox) == $GUI_CHECKED Then Return True
;~ 	EndIf

	If $rarity == $RARITY_GOLD Then
		$GoldiesDropsCount += 1
		GUICtrlSetData($GoldiesDropsCountLable,$GoldiesDropsCount)
		If IsUsefulSharktooth_Shield($aItem) Then
			$SharktoothShieldDropsCount += 1
;~ 			GUICtrlSetData($SharktoothShieldDropsCountLable,$SharktoothShieldDropsCount)
;~ 			If GUICtrlRead($SharktoothShieldCheckbox) == $GUI_CHECKED Then Return True	;Shields
		EndIf
		If GUICtrlRead($LootGoldiesCheckbox) == $GUI_CHECKED Then Return True
		Return False
	EndIf
;~ 	If IsUsefulSharktooth_Shield($aItem) Then ;get all other good shields
;~ 		$SharktoothShieldDropsCount += 1
;~ 		GUICtrlSetData($SharktoothShieldDropsCountLable, $SharktoothShieldDropsCount)
;~ 		Return True
;~ 	EndIf

	If ceckEventItemIDChecked($lModelID) Then Return True
	If ceckTomesIDChecked($lModelID) Then Return True
	If $lModelID = $ITEM_ID_Dye Or $lModelID = $ITEM_ID_DYE_GREY Then
		If ceckDyeExtraIDChecked(DllStructGetData($aItem, "ExtraID")) Then Return True
	EndIf
    If $lModelID == $ITEM_ID_LOCKPICKS 		Then Return True
	If $lModelID == 854						Then Return True
	Return False
EndFunc

Func ceckEventItemIDChecked($lModelID)
	For $i = 1 To 28
		If $lModelID = DllStructGetData($LootEventItemsStruct,"ItemID",$i) Then
			DllStructSetData($LootEventItemsStruct,"ItemCount",DllStructGetData($LootEventItemsStruct,"ItemCount",$i)+1,$i)
			GUICtrlSetData(DllStructGetData($LootEventItemsStruct,"CountLable",$i), DllStructGetData($LootEventItemsStruct,"ItemCount",$i))
			If GUICtrlRead(DllStructGetData($LootEventItemsStruct,"Checkbox",$i)) ==  $GUI_CHECKED Then
				Return True
			EndIf
		EndIf
	Next
	Return 0
EndFunc

Func ceckTomesIDChecked($lModelID)
	For $i = 1 To 20
		If $lModelID = DllStructGetData($LootTomesStruct,"ItemID",$i) Then
			DllStructSetData($LootTomesStruct,"ItemCount",DllStructGetData($LootTomesStruct,"ItemCount",$i)+1,$i)
			GUICtrlSetData(DllStructGetData($LootTomesStruct,"CountLable",$i), DllStructGetData($LootEventItemsStruct,"ItemCount",$i))
			If GUICtrlRead(DllStructGetData($LootTomesStruct,"Checkbox",$i)) ==  $GUI_CHECKED Then
				Return True
			EndIf
		EndIf
	Next
	Return 0
EndFunc

Func ceckDyeExtraIDChecked($lModelExtraID)
	For $i = 1 To 12
		If $lModelExtraID = DllStructGetData($LootDyeStruct,"ItemExtraID",$i) Then
			DllStructSetData($LootDyeStruct,"ItemCount",DllStructGetData($LootDyeStruct,"ItemCount",$i)+1,$i)
			GUICtrlSetData(DllStructGetData($LootDyeStruct,"CountLable",$i), DllStructGetData($LootDyeStruct,"ItemCount",$i))
			If GUICtrlRead(DllStructGetData($LootDyeStruct,"Checkbox",$i)) ==  $GUI_CHECKED Then
				Return True
			EndIf
		EndIf
	Next
	Return 0
EndFunc

Func IsBrambleBow($aItem)
	Local $ModelID = DllStructGetData($aItem,"ModelID")
	Local $Type = DllStructGetData($aItem,"Type")  ;Type 11 = Material
	;Longbow = 868 ;Shortbow = 957 ;904 = flatbow ;Recurve = 934 == Plant Fiber
	If $ModelID = 868 Or $ModelID = 957 Or $ModelID = 904 Then Return True
	If $ModelID = 934 Then
		Local $Requirement = GetItemReq($aItem)
;~ 		ConsoleWrite(@CRLF & "IsBrambleBow" & @TAB  & "$Requirement  " & $Requirement)
;~ 		ConsoleWrite(@CRLF & "IsBrambleBow" & @TAB  & "$Requirement  " & ($Requirement > 0))
		If $Requirement  > 0 Then Return True
	EndIf
	Return False
EndFunc

Func IsUsefulSharktooth_Shield($aItem)
	Local $ModelID = DllStructGetData($aItem,"ModelID")
	Local $Type = DllStructGetData($aItem,"Type")  ;Type 11 = Material ; 24 = Shield ; 35 = scythe
	Local $req = GetItemReq($aItem)
	If $Type <> 24 Then Return False
	If $ModelID <> getSalvageIDByName("Sharktooth_Shield") Then Return False
	If $req > 0 Then Return True
	Return False
EndFunc

Func IsUsefulScythe($aItem)
;~ 	Local $ModelID = DllStructGetData($aItem,"ModelID")
	Local $Type = DllStructGetData($aItem,"Type")  ;Type 11 = Material ; 24 = Shield ; 35 = scythe
	Local $req = GetItemReq($aItem)
	Local $rarity = GetRarity($aItem)
	If $Type <> 35 Then Return False
	If $rarity <> $RARITY_BLUE Then Return False

	Local $AgentID = DllStructGetData($aItem,'agentId')
	Local $Agent = GetAgentByID($AgentID)
	ConsoleWrite(@CRLF & "! req 0 scythe -> $AgentID: " & $AgentID & @TAB & "GetCanPickUp($AgentID): " & GetCanPickUp($AgentID))
;~ 	If GetCanPickUp($Agent) Then ;try to check if Item is in inventory - do not work - GetCanPickUp(ItemInInventar) = True
		Local $Agent_X = DllStructGetData($Agent, 'X')
		Local $Agent_Y = DllStructGetData($Agent, 'Y')
		Local $KillareaX1 = 500
		Local $KillareaY1 = 13886
		Local $KillareaX2 = 3500
		Local $KillareaY2 = 15000
		ConsoleWrite(@CRLF & "!$Agent_X " & $Agent_X & @TAB & "$Agent_Y: " & $Agent_Y)
		If $KillareaX1 < $Agent_X And $Agent_X < $KillareaX2 And $KillareaY1 < $Agent_Y And $Agent_Y < $KillareaY2 And $req = 0 Then
			ConsoleWrite(@TAB & "-> not useful")
			Return False
		EndIf
;~ 	EndIf

	If $req = 0 Then Return True
	Return False
EndFunc

Func IsIronItem($aItem)
	Local $Type = DllStructGetData($aItem, "Type")
	Local $ModelID = DllStructGetData($aItem, "ModelID")
;~ 	If $Type = 35 Then Return False ;scythe
	If $Type = 2 Or $Type = 15 Or $Type = 22 Or $Type = 24 Or $Type = 26  Or $Type = 27 Or $Type = 32 Or $Type = 35 Or $Type = 36 Or $Type = 12 Then Return True
	Return False

;~ 2 	Axe

;~ 5 	Bow
;~ 12 	OffHand
;~ 15 	Hammer
;~ 22 	Wand
;~ 24 	Shield
;~ 26 	Staff
;~ 27 	Sword
;~ 32 	Daggers
;~ 35 	Scythe
;~ 36 	Spear

EndFunc

Func StackableReturnTrue($aItem)
	Local $lModelID = DllStructGetData(($aItem), 'ModelID')
	;==== Usefull Staff ====
	If $lModelID == $ITEM_ID_DIESSA					Then Return True
	If $lModelID == $ITEM_ID_RIN 					Then Return True
	If $lModelID == getItemIDByName('Spiritwood') 	Then Return True
	If $lModelID == getItemIDByName('Dragonroot') 	Then Return True
	If $lModelID == getItemIDByName('Skale Teeth') 	Then Return True
	If $lModelID == getItemIDByName('Skale Claws') 	Then Return True
	If $lModelID == getItemIDByName('Skale Fins')	Then Return True
    If $lModelID == $ITEM_ID_LOCKPICKS 				Then Return True

	; ==== Mats ====
	If isMaterial($aItem)  Then Return True

	If $lModelID == 854						Then Return True

	; ==== Dye ====
	If $lModelID = $ITEM_ID_Dye Or $lModelID = $ITEM_ID_DYE_GREY Then Return True

	; ==== Event ====
	For $i = 1 To 28
		If $lModelID == DllStructGetData($StoreEventItemsStruct,"ItemID",$i) Then Return True
	Next
EndFunc

Func isShield($aItem)
	Local $Type = DllStructGetData(($aItem), 'Type')
	If $Type = 24 Then Return True
	Return False
EndFunc

Func findItemByModelId($ItemID, $firstBag = 1, $lastBag = 4, $firstSlot = 1)
	If IsDllStruct($ItemID) Then $ItemID = DllStructGetData($ItemID, 'ModelID')
	Local $lItemInfo
	For $i = $firstBag To $lastBag
		For $j = $firstSlot To DllStructGetData(GetBag($i), 'slots')
			$firstSlot = 1
			$lItemInfo = GetItemBySlot($i, $j)
			If DllStructGetData($lItemInfo, 'ModelID') = $ItemID Then
				Return $lItemInfo
			EndIf
		Next
	Next
	Return False
EndFunc

;already in Gwa2
;~ Func countFreeSlot($lastBag = 4)
;~ 	Local $count = 0
;~ 	For $i = 1 To $lastBag
;~ 		For $j = 1 To DllStructGetData(GetBag($i), 'slots')
;~ 			Local $item = GetItemBySlot($i, $j)
;~ 			If DllStructGetData($item, 'ModelID') = 0 Then $count += 1
;~ 		Next
;~ 	Next
;~ 	Return $count
;~ EndFunc

;~ Description: count all value in inventory - ModelId form ItemInput
Func countItems()

	Local $tabNrSalvage = getTabNrByName("SalvageTab")

	Local $GDIIndex = 1
	Local $Lable = DllStructGetData($SalvageStruct,"CountLable",$GDIIndex)
	Local $Count = CountInventoryChestIronItems()
;~ 		ConsoleWrite(@CRLF & ">" & $GDIIndex & " $nextID " & $nextID &  "     $Count " & $Count & "     $Lable " & $Lable)
	DllStructSetData($SalvageStruct,"ItemCount",$Count,$GDIIndex)
	If GUICtrlRead($Lable) <> $Count Then GUICtrlSetData($Lable, $Count)


	For $GDIIndex = 2 To DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusCount")
		Local $nextID = DllStructGetData($SalvageStruct,"ItemID",$GDIIndex)
		Local $Lable = DllStructGetData($SalvageStruct,"CountLable",$GDIIndex)
		Local $Count = CountInventoryChestItemByID($nextID)
;~ 		ConsoleWrite(@CRLF & ">" & $GDIIndex & " $nextID " & $nextID &  "     $Count " & $Count & "     $Lable " & $Lable)
		DllStructSetData($SalvageStruct,"ItemCount",$Count,$GDIIndex)
		If GUICtrlRead($Lable) <> $Count Then GUICtrlSetData($Lable, $Count)
	Next

	$SalvageCount = countSalvageKit()
	If (GUICtrlRead($SalvageCountLable) <> $SalvageCount) Then GUICtrlSetData($SalvageCountLable,$SalvageCount)
	$IdentCount = CountIDKit()
	If GUICtrlRead($IdentCountLable) <> $IdentCount Then GUICtrlSetData($IdentCountLable,$IdentCount)

	Sleep(getping()*2)
EndFunc

Func autoSalvage()
	countItems()
	If $SalvageRunning Then
		If GetMapLoading() == 2 Then Disconnected()
		Local $aItem = findSalvageItem()
		Local $rarity = GetRarity($aItem)
		If IsDllStruct($aItem) = 0 Then
			ConsoleWrite(@TAB &  " IsDllStruct($aItem) = 0 - return")
			Return
		EndIf

		If $BotRunning Or $BotShouldPause Then
			$SalvageCount = countSalvageKit()
			If (GUICtrlRead($SalvageCountLable) <> $SalvageCount) Then GUICtrlSetData($SalvageCountLable,$SalvageCount)
			If $SalvageCount = 0 Then
				GUICtrlSetData($StartSalvageButton,'start salvage')
;~ 				$SalvageRunning = False
;~ 				out('=== no KIT ===')
				Return False
			EndIf

			Local $TimeFromLastSalvage = TimerDiff($SalvageTimer)
			ConsoleWrite(@TAB &  "Time_from_last_salvage " & Round($TimeFromLastSalvage))
			If $TimeFromLastSalvage < (1300+getPing()*5) Then Return False ; --> max speed for salvage
			$SalvageTimer = TimerInit()
			If GetIsIDed($aItem) Or $rarity = $RARITY_WHITE Then
				salvageMats($aItem)
				Return True
			ElseIf $rarity <> $RARITY_WHITE Then

					$IdentCount = CountIDKit()
					If GUICtrlRead($IdentCountLable) <> $IdentCount Then GUICtrlSetData($IdentCountLable,$IdentCount)
					If $IdentCount = 0 Then Return
					IdentifyItem($aItem)
					Sleep(getping())
					Return True

			EndIf

		ElseIf Not $BotRunning And GetMapLoading() = 1 Then
			$SalvageCount = countSalvageKit()
			If (GUICtrlRead($SalvageCountLable) <> $SalvageCount) Then GUICtrlSetData($SalvageCountLable,$SalvageCount)
			If $SalvageCount = 0 Then
				GUICtrlSetData($StartSalvageButton,'start salvage')
;~ 				$SalvageRunning = False
;~ 				out('=== no KIT ===')
				Return False
			EndIf

			Local $TimeFromLastSalvage = TimerDiff($SalvageTimer)
			ConsoleWrite(@TAB &  "Time_from_last_salvage " & Round($TimeFromLastSalvage))
			If $TimeFromLastSalvage < (1300+getPing()*5) Then Return False ; --> max speed for salvage
			$SalvageTimer = TimerInit()
			If GetIsIDed($aItem) Then
				salvageMats($aItem)
				Return True
			Else

					$IdentCount = CountIDKit()
					If GUICtrlRead($IdentCountLable) <> $IdentCount Then GUICtrlSetData($IdentCountLable,$IdentCount)
					If $IdentCount = 0 Then Return
					IdentifyItem($aItem)
					Sleep(getping())
					Return True

			EndIf

		ElseIf GetMapLoading() = 0 Then ;--> be in City
			GoToMerchant()
			While $SalvageRunning And Not $BotRunning
				Local $Quantity = DllStructGetData($aItem,"quantity")
				countItems()
				Local $iItem = findSalvageItem()
				If $IItem = -1 Then
					$SalvageRunning = False
					GUICtrlSetData($StartSalvageButton,"start salvage")
					out('=== salave done ===')
					Return False
				EndIf

;~ 				Local $ItemID = DllStructGetData($iItem,"ModelID") ;need ModelID of the salvaged Material - here only Bone
				Local $myMatModelID = getMatIDByName('Iron')
				Local $curentMatAmount = CountInventory_ChestMaterial($myMatModelID)

				Local $TimeFromLastSalvage = TimerDiff($SalvageTimer)
				ConsoleWrite(@TAB &  "Time_from_last_salvage " & Round($TimeFromLastSalvage))
				If $TimeFromLastSalvage < 500 Then Sleep(500 - $TimeFromLastSalvage) ; --> max speed for salvage = 500
				$SalvageTimer = TimerInit()
				salvageMats($iItem)
				Do
					If GetMapLoading() == 2 Then
						Disconnected()
						GoToMerchant()
					EndIf
					Sleep(getping()+100)
				Until $Quantity > DllStructGetData($aItem,"quantity") Or DllStructGetData($aItem,"ID") = 0 Or TimerDiff($SalvageTimer) > 1500

				ConsoleWrite(@TAB & ">> add " & (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount) & " Iron")
				$BoneCount += (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount)
				GUICtrlSetData($BoneCountLable,$BoneCount)
;~ 				Sleep(100)
			WEnd
		EndIf
	EndIf
	Return True
EndFunc

Func findSalvageItem()

	Local $tabNr = getTabNrByName("BagsTab")
	Local $tabNrSalvage = getTabNrByName("SalvageTab")
	Local $iBag, $iSlot
	For $iBag = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$iBag) Then
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				Local $ItemID = DllStructGetData($iItem,"ModelID")
				Local $Type = DllStructGetData($iItem,"Type")
				If IsIronItem($iItem) Then
					If DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusTicked",1) Then
						ConsoleWrite(@CRLF & "> slavage IronItem - Inv")
						Return $iItem
					EndIf
				EndIf

				For $GDIIndex = 2 To DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusCount")
					If DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusTicked",$GDIIndex) Then
						If $ItemID = DllStructGetData($SalvageStruct,"ItemID",$GDIIndex) Then
							ConsoleWrite(@CRLF & "> slavage " & $SalvageArray[$GDIIndex][0] & " - Inv")
							Return $iItem
						EndIf
					EndIf
				Next
			Next
		EndIf
	Next

	If GetMapLoading() = 0 Then ;--> City
		For $iBag = 8 To 16
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$iBag-7+4) Then
				For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
					Local $iItem = GetItemBySlot($iBag, $iSlot)
					Local $ItemID = DllStructGetData($iItem,"ModelID")

;~ 					If IsIronItem($iItem) Then ;you dontwant to salvage your weapons from chest!
;~ 						If DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusTicked",1) Then
;~ 							ConsoleWrite(@CRLF & "> slavage IronItem - Inv")
;~ 							Return $iItem
;~ 						EndIf
;~ 					EndIf
					For $GDIIndex = 2 To DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusCount")
						If DllStructGetData($TabArrayOfStructs[$tabNrSalvage],"GDIPlusTicked",$GDIIndex) Then
							If $ItemID = DllStructGetData($SalvageStruct,"ItemID",$GDIIndex) Then
								ConsoleWrite(@CRLF & "> slavage " & $SalvageArray[$GDIIndex][0] & " - Chest")
								Return $iItem
							EndIf
						EndIf
					Next
				Next
			EndIf
		Next
	EndIf
	ConsoleWrite(@CRLF & ">no slavage Item")
	Return -1

EndFunc

Func salvageMats($aItem, $IdentAndSalvage = False)
;~ 	Local $MatsCountLable = $SalvageFiberCountLable
;~ 	Local $myItemModelId = DllStructGetData($aItem,"ModelID")
;~ 	$ItemCount = CountInventoryItem($myItemModelId)
	Local $rarity = GetRarity($aItem)

	If $rarity <> $RARITY_WHITE And Not GetIsIDed($aItem) Then
		$IdentCount = CountIDKit()
		If GUICtrlRead($IdentCountLable) <> $IdentCount Then GUICtrlSetData($IdentCountLable,$IdentCount)
		If $IdentCount = 0 Then Return
		IdentifyItem($aItem)
		Sleep(getping()*2+250)
		If Not $IdentAndSalvage Then Return
		If Not GetIsIDed($aItem) Then Return
	EndIf

	$SalvageCount = countSalvageKit()
	If (GUICtrlRead($SalvageCountLable) <> $SalvageCount) Then GUICtrlSetData($SalvageCountLable,$SalvageCount)
	If $SalvageCount = 0 Then
		BuySalvageKit()
		addToPlatinCount(-100)
		Local $clock = TimerInit()
		Do
			If GetMapLoading() == 2 Then Disconnected()
			RndSleep(100)
		Until countSalvageKit() <> 0 Or TimerDiff($clock) > 3000
		Sleep(getping()+500)
	EndIf


	Local $lOffset[4] = [0, 0x18, 0x2C, 0x690] ;0x62C before apr20	;;420: maybe Offset[3] = 1580?
	Local $lSalvageSessionID = MemoryReadPtr($mBasePointer, $lOffset)
	Local $lItemID = DllStructGetData($aItem, 'ID')
	Local $lSalvageKit = FindNextSalvageKit()
	If $lSalvageKit = 0 Then Return
	Local $UsingKIT_ModelID = DllStructGetData(GetItemByItemID($lSalvageKit),"ModelID")
	ConsoleWrite(@TAB &  "start salvage session")
	;start salvage session
	DllStructSetData($mSalvage, 2, $lItemID)
	DllStructSetData($mSalvage, 3, FindNextSalvageKit())
	DllStructSetData($mSalvage, 4, $lSalvageSessionID[1])
	Enqueue($mSalvagePtr, 16)
	; salvage to mats
	If $rarity == $RARITY_PURPLE Or $rarity == $RARITY_GOLD Then
		Sleep(getping()+250)
		SalvageMaterials()
	ElseIf ($rarity = $RARITY_BLUE And $UsingKIT_ModelID <> $Salvage_Kit_ID) Then
		out("====== Blue Item SKit: " & $UsingKIT_ModelID & "  ======")
		Sleep(getping()+250)
		SalvageMaterials()
	EndIf
;~ 	Sleep(getping()+150)



	$SalvageCount = countSalvageKit()
	If GUICtrlRead($SalvageCountLable) <> $SalvageCount Then GUICtrlSetData($SalvageCountLable,$SalvageCount)



#cs
salvage bramble bow OK:
;~ white Longbow
gold Hornbow
gold Longbow
gold Flatbow
purple Longbow

salvage bramble bow crashing gw:
white RECOURVE bow
blue RECOURVE bow
blue Longbow

#ce

EndFunc

Func _Ident($buyKit = True)
;~ 	Local $tabNr = getTabNrByName("LootTab")
	Local $tabNr = getTabNrByName("InventoryTab")
	For $bagIndex = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$bagIndex) Then
			Local $bag = GetBag($bagIndex)
			For $i = 1 To DllStructGetData($bag, 'slots')
				Local $aitem = GetItemBySlot($bagIndex, $i)
				Local $rarity = GetRarity($aItem)
				If GetMapLoading() == 2 Then Disconnected()


				If DllStructGetData($aItem, 'ID') = 0 Then ContinueLoop

				If $rarity <> $RARITY_WHITE And Not GetIsIDed($aItem) Then
					$IdentCount = CountIDKit()
					If GUICtrlRead($IdentCountLable) <> $IdentCount Then GUICtrlSetData($IdentCountLable,$IdentCount)
					If $IdentCount = 0 Then
						If Not $buyKit Then Return
						If GetGoldCharacter() < 500 AND GetGoldStorage() > 499 Then
							WithdrawGold(500)
							Sleep(Random(200,300))
						EndIf
						BuyIdentKit()
						addToPlatinCount(-100)
						Local $clock = TimerInit()
						Do
							If GetMapLoading() == 2 Then Disconnected()
							RndSleep(100)
						Until FindIDKit() <> 0 Or TimerDiff($clock) > 3000
						RndSleep(getping()*2)
					EndIf

					IdentifyItem($aItem)
					Sleep(getping()*2+70)
					If Not GetIsIDed($aItem) Then Sleep(500)
				EndIf
			Next
		EndIf
	Next
EndFunc

Func _Sell()
;~ 	Local $tabNr = getTabNrByName("LootTab")
	Local $tabNr = getTabNrByName("BagsTab")
	Local $myMatModelID = getMatIDByName('Bone')
	Local $curentMatAmount = CountInventory_ChestMaterial($myMatModelID)
;~ 	ConsoleWrite(@CRLF & "- $curentFiberAmount " & $curentFiberAmount & " from ID " & $myMatModelID)
	For $BAGINDEX = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$BAGINDEX) Then
			Local $AITEM
			Local $BAG = GETBAG($BAGINDEX)
			Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
			For $I = 1 To $NUMOFSLOTS
				If GetMapLoading() == 2 Then
					Disconnected()
					GoToMerchant()
				EndIf
				$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
				If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
				Local $Requirement = GetItemReq($AITEM)
				Local $LMODELID = DllStructGetData($AITEM, "ModelID")
				;bramble
				If IsBrambleBow($AITEM) Then ; 934 = recurve bow, 868 = longbow, 957 = shortbow, 904 = flatbow
					salvageMats($AITEM, True) ; Ident and salvage
					Sleep(GetPing()+250)
				EndIf
				If IsIronItem($AITEM) Then
					salvageMats($AITEM, True) ; Ident and salvage
					Sleep(GetPing()+250)
				EndIf

				;sharktooth
				If IsUsefulSharktooth_Shield($AITEM) Then
					salvageMats($AITEM, True) ; Ident and salvage
					Sleep(GetPing()+250)
				EndIf

				If CanSell($AITEM) Then
;~ 					ConsoleWrite(@CRLF & "---------This Item quantity " & DllStructGetData($AITEM,'Quantity') & @TAB &  "Value  " & DllStructGetData($AITEM,'Value') &@TAB & @TAB )
;~ 					Local $Money = GetGoldCharacter()
					addToPlatinCount(DllStructGetData($AITEM,'Quantity')*DllStructGetData($AITEM,'Value'))
					SellItem($AITEM)
					Sleep(GetPing()*2+200)
				EndIf

			Next
		EndIf
	Next
	out("add " & (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount) & " Bone")
	$BoneCount += (CountInventory_ChestMaterial($myMatModelID) - $curentMatAmount)
	GUICtrlSetData($BoneCountLable,$BoneCount)
EndFunc

Func SalvageBrableBow($aBramble)
;~ 	Local $myMatModelID = getMatIDByName('Plant_Fiber')
;~ 	Local $curentAmountMat = CountInventory_ChestMaterial($myMatModelID)
	salvageMats($aBramble)
	Sleep(GetPing()+150)
EndFunc

Func CanSell($aItem)

	Local $LMODELID = DllStructGetData($aitem, "ModelID")
	Local $Type = DllStructGetData($aitem, "Type")
	Local $Requirement = GetItemReq($aItem)
	Local $rarity = GetRarity($aItem)
	Local $req = GetItemReq($aItem)
	#cs
	If isMaterial($aItem)  							Then Return False
	If $Requirement == 8 							Then Return False
	If $lModelID == $Salvage_Kit_ID 				Then Return False
	If $lModelID == $Salvage_Kit_Expert_ID 			Then Return False
	If $lModelID == $Salvage_Kit_Superior_ID 		Then Return False
	If $lModelID == $Ident_Kit_ID 					Then Return False
	If $lModelID == getItemIDByName('Dragonroot')	Then Return False
    If $lModelID == $ITEM_ID_LOCKPICKS 				Then Return False
	If $lModelID == 854								Then Return False
	If StackableReturnTrue($LMODELID) 				Then Return False

	If ValEquipReturnTrue($aItem) 					Then Return False
	If $LMODELID == $ITEM_ID_Dye 					Then Return False
	If $LMODELID == $ITEM_ID_DYE_GREY 				Then Return False
	If IsBrambleBow($aItem) Then Return False
;~ 	Return True
	#ce
	If IsBrambleBow($aItem) Then Return False

	;blue req 0 scythe
;~ 	If $rarity = $RARITY_BLUE And $req = 0 And $Type = 35 And (GUICtrlRead($sellbluereq0scytheCheckbox) == $GUI_CHECKED) Then Return True
	If IsUsefulScythe($aItem) And (GUICtrlRead($sellbluereq0scytheCheckbox) == $GUI_CHECKED) Then Return True

	If ($lModelID == getItemIDByName("Spiritwood")) And (GUICtrlRead($sellSpiritwoodCheckbox) == $GUI_CHECKED) Then Return True
	If $rarity = $RARITY_GOLD And (GUICtrlRead($sellGoldiesCheckbox) == $GUI_CHECKED)  And Not isShield($aItem) Then Return True
;~ 	If $rarity = $RARITY_GOLD And (GUICtrlRead($sellGoldShieldCheckbox) == $GUI_CHECKED)  And isShield($aItem) Then Return True
	Return False


EndFunc   ;==>CanSell

Func BuySalvageKit($Quantity = 1)
	If GetGoldCharacter() < 100 AND GetGoldStorage() >= 100 Then
		WithdrawGold(100)
		Sleep(getping()+200)
	EndIf
	If GetGoldCharacter() >= 100 Then
		If GetMapID() = 857 Then ;embark trader
			ConsoleWrite(@CRLF & "- BuyItem(3, " & $Quantity & " , 100)")
			BuyItem(3, $Quantity, 100)
		Else
			ConsoleWrite(@CRLF & "- BuyItem(2, " & $Quantity & " , 100)")
			BuyItem(2, $Quantity, 100)
		EndIf
		Sleep(getping())
		Return True
	EndIf
	Return False
EndFunc

Func BuyIdentKit($Quantity = 1 , $cheapKIT = False)
	If $cheapKIT Then

		If GetGoldCharacter() < 100 AND GetGoldStorage() >= 100 Then
			WithdrawGold(100)
			Sleep(getping()+200)
		EndIf
		If GetGoldCharacter() >= 100 Then
			If GetMapID() = 857 Then ;embark trader
				ConsoleWrite(@CRLF & "- BuyItem(6, " & $Quantity & " , 100)")
				BuyItem(6, $Quantity, 100)
			ElseIf GetMapID() = $MAP_ID_Jokanur Then
				ConsoleWrite(@CRLF & "- BuyItem(4, " & $Quantity & " , 100)")
				BuyItem(4, $Quantity, 100)
			Else
				ConsoleWrite(@CRLF & "- BuyItem(5, " & $Quantity & " , 100)")
				BuyItem(5, $Quantity, 100)
			EndIf
			Sleep(getping())
			Return True
		EndIf
	Else
		If GetGoldCharacter() < 500 AND GetGoldStorage() >= 500 Then
			WithdrawGold(500)
			Sleep(getping()+200)
		EndIf
		If GetGoldCharacter() >= 500 Then
			If GetMapID() = 857 Then ;embark trader
				ConsoleWrite(@CRLF & "- BuyItem(7, " & $Quantity & " , 500)")
				BuyItem(7, $Quantity, 500)
			ElseIf GetMapID() = $MAP_ID_Jokanur Then
				ConsoleWrite(@CRLF & "- BuyItem(5, " & $Quantity & " , 500)")
				BuyItem(5, $Quantity, 500)
			Else
				ConsoleWrite(@CRLF & "- BuyItem(6, " & $Quantity & " , 500)")
				BuyItem(6, $Quantity, 500)
			EndIf
			Sleep(getping())
			Return True
		EndIf
	EndIf

	Return False
EndFunc

Func findNextFreeChestSlot($aItem, ByRef $arrayBagSlot)
	Local $iBag, $iSlot
	Local $tabNr = getTabNrByName("BagsTab")

	Local $MatsBag = 6
	If isMaterial($aItem) And DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",(14)) Then
			Local $ModelID = DllStructGetData(($aItem), 'ModelID')
;~ 			MsgBox(0,0,"blub")
			Local $Index = getPosInMatsStructByItemID($ModelID)
			Local $ChestSlot = DllStructGetData($MatsStruct,"ChestSlot",$Index)
			Local $iItem = GetItemBySlot($MatsBag, $ChestSlot)
			If DllStructGetData($iItem, 'ID') = 0 Then
					$arrayBagSlot[0] = $MatsBag
					$arrayBagSlot[1] = $ChestSlot
					Return 1
			EndIf
	EndIf

	For $iBag = 8 To 16
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",($iBag-7+4)) Then
;~ 			ConsoleWrite(@CRLF & "------Free--Slot $iBag:  " & $iBag & @TAB & "Ticked")
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If DllStructGetData($iItem, 'ID') = 0 Then
					$arrayBagSlot[0] = $iBag
					$arrayBagSlot[1] = $iSlot
					Return 1
				EndIf
			Next
		EndIf
	Next
	Return 0
EndFunc

Func findItemToStackInChest($aItem, ByRef $arrayBagSlot)
	Local $ModelID = DllStructGetData($aItem, "ModelID")
	Local $Type = DllStructGetData(($aItem), 'Type')
	Local $ExtraID = DllStructGetData(($aItem), 'ExtraID')
	Local $Quantity = DllStructGetData(($aItem), 'quantity')
	Local $tabNr = getTabNrByName("BagsTab")
	Local $iBag, $iSlot

	Local $MatsBag = 6
;~ 	ConsoleWrite(@CRLF)
	If isMaterial($aItem) And DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",(14)) Then ; 14 = Mats
		For $iSlot = 1 to 38
			Local $iItem = GetItemBySlot($MatsBag, $iSlot)
;~ 			ConsoleWrite(@CRLF & @TAB & "LookForID: " & $ModelID & @TAB &"ModelID Slot: " & $i & ": " & DllStructGetData($iItem , 'ModelID') & @TAB & "quantity: " & DllStructGetData($iItem , 'quantity'))
			If DllStructGetData(($iItem), 'ModelID') = $ModelID Then
				If DllStructGetData(($iItem), 'quantity') = 250 Then ContinueLoop
				$arrayBagSlot[0] = $MatsBag
				$arrayBagSlot[1] = $iSlot
				Return 1
			EndIf
		Next
	EndIf

	For $iBag = 8 To 16
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",($iBag-7+4)) Then
;~ 			ConsoleWrite(@CRLF & "findItemToStackInChest $iBag:  " & $iBag & @TAB & "Ticked")
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If StackableReturnTrue($iItem) Then
					If DllStructGetData($iItem, "ModelID") = $ModelID And DllStructGetData($iItem, 'Type') = $Type And $ExtraID = DllStructGetData(($iItem), 'ExtraID') Then
						If DllStructGetData(($iItem), 'quantity') = 250 Then ContinueLoop
						$arrayBagSlot[0] = $iBag
						$arrayBagSlot[1] = $iSlot
						Return 1
					EndIf
				EndIf
			Next
		EndIf
	Next
	Return 0
EndFunc

Func moveItemsToChest()
	Local $ChestBagSlot[2]
	Local $MoveCount = 0

	Local $tabNr = getTabNrByName("ChestTab")
	If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",2) Then ;Platin
		DepositGold(Round(GUICtrlRead($ChestMovePlatinInput)*1000,3))
	EndIf

	Local $tabNr = getTabNrByName("BagsTab")
	For $BAGINDEX = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$BAGINDEX) Then
			Local $aItem
			Local $BAG = GETBAG($BAGINDEX)
			Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
			For $I = 1 To $NUMOFSLOTS
				If GetMapLoading() == 2 Then Disconnected()
				$aItem = GETITEMBYSLOT($BAGINDEX, $I)
				Local $ItemID = DllStructGetData($aItem, "ModelID")
				Local $Type = DllStructGetData(($aItem), 'Type')
;~ 				ConsoleWrite(@CRLF & "moveItemsToChest  Bag: " & $BAGINDEX & @TAB & $I & @TAB & "Type: " & $Type)
				If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
				If canMoveItem($aItem) Then

						If findItemToStackInChest($aItem, $ChestBagSlot) Then
							MoveItem($aItem, $ChestBagSlot[0], $ChestBagSlot[1])
							Sleep(GetPing()+180)
							If DllStructGetData(GETITEMBYSLOT($BAGINDEX, $I), "ID") <> 0 Then $BAGINDEX += -1
							$MoveCount += 1
						ElseIf findNextFreeChestSlot($aItem, $ChestBagSlot) Then
							MoveItem($aItem, $ChestBagSlot[0], $ChestBagSlot[1])
							Sleep(GetPing()+180)
							$MoveCount += 1
						EndIf

						If $MoveCount >= GUICtrlRead($ChestmaxMoveInput) Then Return

				EndIf
			Next
			If $MoveCount >= GUICtrlRead($ChestmaxMoveInput) Then Return
		EndIf
	Next
EndFunc

Func findNextFreeInventorySlot($aItem, ByRef $arrayBagSlot)
	Local $iBag, $iSlot
	Local $tabNr = getTabNrByName("BagsTab")
	For $iBag = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",($iBag)) Then
;~ 			ConsoleWrite(@CRLF & "------Free--Slot $iBag:  " & $iBag & @TAB & "Ticked")
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If DllStructGetData($iItem, 'ID') = 0 Then
					$arrayBagSlot[0] = $iBag
					$arrayBagSlot[1] = $iSlot
					Return 1
				EndIf
			Next
		EndIf
	Next
	Return 0
EndFunc

Func findItemToStackInInventory($aItem, ByRef $arrayBagSlot)
	Local $ModelID = DllStructGetData($aItem, "ModelID")
	Local $Type = DllStructGetData(($aItem), 'Type')
	Local $ExtraID = DllStructGetData(($aItem), 'ExtraID')
	Local $tabNr = getTabNrByName("BagsTab")
	Local $iBag, $iSlot
	For $iBag = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$iBag) Then
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If StackableReturnTrue($iItem) Then
					If DllStructGetData($iItem, "ModelID") = $ModelID And DllStructGetData($iItem, 'Type') = $Type And $ExtraID = DllStructGetData(($iItem), 'ExtraID') Then
						If DllStructGetData(($iItem), 'quantity') = 250 Then ContinueLoop
						$arrayBagSlot[0] = $iBag
						$arrayBagSlot[1] = $iSlot
						Return 1
					EndIf
				EndIf
			Next
		EndIf
	Next
	Return 0
EndFunc

Func moveItemsToInv()
;~ 	Local $ChestBagSlot[2]
	Local $MoveCount = 0
	Local $InvBagSlot[2]

	Local $tabNr = getTabNrByName("ChestTab")
	If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",2) Then ;Platin
		WithdrawGold(Round(GUICtrlRead($ChestMovePlatinInput)*1000,3))
	EndIf

	Local $tabNr = getTabNrByName("BagsTab")
	If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",(14)) Then ;14 = Mats
	Local $BAGINDEX = 6
		Local $aItem
		Local $BAG = GETBAG($BAGINDEX)
		Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
		For $I = 1 To $NUMOFSLOTS
			If GetMapLoading() == 2 Then Disconnected()
			$aItem = GETITEMBYSLOT($BAGINDEX, $I)
			Local $ItemID = DllStructGetData($aItem, "ModelID")
			Local $Type = DllStructGetData(($aItem), 'Type')
			If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
			If canMoveItem($aItem) Then
					If findItemToStackInInventory($aItem, $InvBagSlot) Then
						MoveItem($aItem, $InvBagSlot[0], $InvBagSlot[1])
						Sleep(GetPing()+180)
						If DllStructGetData(GETITEMBYSLOT($BAGINDEX, $I), "ID") <> 0 Then $BAGINDEX += -1
						$MoveCount += 1
					ElseIf findNextFreeInventorySlot($aItem, $InvBagSlot) Then
							MoveItem($aItem, $InvBagSlot[0], $InvBagSlot[1])
						Sleep(GetPing()+180)
						$MoveCount += 1
					EndIf
					If $MoveCount >= GUICtrlRead($ChestmaxMoveInput) Then Return
			EndIf
		Next
	EndIf


	For $BAGINDEX = 8 To 16
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",($BAGINDEX-7+4)) Then
			Local $aItem
			Local $BAG = GETBAG($BAGINDEX)
			Local $NUMOFSLOTS = DllStructGetData($BAG, "slots")
			For $I = 1 To $NUMOFSLOTS
				If GetMapLoading() == 2 Then Disconnected()
				$aItem = GETITEMBYSLOT($BAGINDEX, $I)
				Local $ItemID = DllStructGetData($aItem, "ModelID")
				Local $Type = DllStructGetData(($aItem), 'Type')
;~ 				ConsoleWrite(@CRLF & "moveItemsToChest  Bag: " & $BAGINDEX & @TAB & $I & @TAB & "Type: " & $Type)
				If DllStructGetData($aItem, "ID") = 0 Then ContinueLoop
				If canMoveItem($aItem) Then
						If findItemToStackInInventory($aItem, $InvBagSlot) Then
							MoveItem($aItem, $InvBagSlot[0], $InvBagSlot[1])
							Sleep(GetPing()+180)
							If DllStructGetData(GETITEMBYSLOT($BAGINDEX, $I), "ID") <> 0 Then $BAGINDEX += -1
						ElseIf findNextFreeInventorySlot($aItem, $InvBagSlot) Then
								MoveItem($aItem, $InvBagSlot[0], $InvBagSlot[1])
							Sleep(GetPing()+180)
						EndIf
						$MoveCount += 1
						If $MoveCount >= GUICtrlRead($ChestmaxMoveInput) Then Return
				EndIf
			Next
			If $MoveCount >= GUICtrlRead($ChestmaxMoveInput) Then Return
		EndIf
	Next

EndFunc

Func canMoveItem($aItem)
	If DllStructGetData($aItem, "ID") = 0 Then Return False
	Local $ModelID = DllStructGetData($aItem, "ModelID")
	Local $lType = DllStructGetData(($aItem), 'Type')
	Local $rarity = GetRarity($aItem)


	Local $tabNr = getTabNrByName("ChestTab")
	Local $GDIIndex = "1" ;enable move
	If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
;~ 		If GUICtrlRead($ChestSkaleFinCheckbox) == $GUI_CHECKED And $ModelID = getItemIDByName('Skale Fins') Then Return True
;~ 		If GUICtrlRead($ChestSkaleTeethCheckbox) == $GUI_CHECKED And $ModelID = getItemIDByName('Skale Teeth') Then Return True
;~ 		If GUICtrlRead($ChestSkaleClawCheckbox) == $GUI_CHECKED And $ModelID = getItemIDByName('Skale Claws') Then Return True
		If GUICtrlRead($ChestLockpicksCheckbox) == $GUI_CHECKED And $ModelID = $ITEM_ID_LOCKPICKS Then Return True
		If GUICtrlRead($ChestTomesCheckbox) == $GUI_CHECKED Then
		For $i = 1 To 20
			If $ModelID = DllStructGetData($StoreTomesStruct,"ItemID",$i) And (GUICtrlRead(DllStructGetData($StoreTomesStruct,"Checkbox",$i)) == $GUI_CHECKED) Then Return True
		Next
		EndIf
		;=== Dye ===
		If GUICtrlRead($ChestDysCheckbox) == $GUI_CHECKED Then
			If $ModelID = $ITEM_ID_Dye Or $ModelID = $ITEM_ID_DYE_GREY Then
				Local $ModelExtraID = DllStructGetData($aItem, "extraId")
				For $i = 1 To 12
					If $ModelExtraID = DllStructGetData($StoreDyeStruct,"ItemExtraID",$i) And (GUICtrlRead(DllStructGetData($StoreDyeStruct,"Checkbox",$i)) == $GUI_CHECKED) Then Return True
				Next
			EndIf
		EndIf
		; === Event ===
		If GUICtrlRead($ChestEventItemsCheckbox) == $GUI_CHECKED Then
			For $i = 1 To 28
				If $ModelID = DllStructGetData($StoreEventItemsStruct,"ItemID",$i) And (GUICtrlRead(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i)) == $GUI_CHECKED) Then Return True
			Next
		EndIf
		; ==== Mats ===
		Local $tabNr = getTabNrByName("StoreMatsTab")
		If GUICtrlRead($ChestMatsCheckbox) == $GUI_CHECKED And isMaterial($aItem) Then
			For $i = 1 To 36
				If $ModelID = DllStructGetData($MatsStruct,"ItemID",$i) And DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then Return True
			Next
		EndIf
	EndIf
	Return False
EndFunc

Func DropStruff()
	Local $tabNr = getTabNrByName("BagsTab")
	Local $iBag, $iSlot
	For $iBag = 1 To 4
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$iBag) Then
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If DllStructGetData($iItem, 'Quantity') = 0 Then ContinueLoop
				DropItem($iItem)
				Sleep(getping()+350)
			Next
		EndIf
	Next
EndFunc

Func PickupStuff()
	Local $lAgent
	Local $lItem
	Local $lDeadlock
	Local $InvBagSlot[2]
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return
		$lAgent = GetAgentByID($i)
		$lItem = GetItemByAgentID($i)
		If findNextFreeInventorySlot($lItem, $InvBagSlot) Then
;~ 			$lAgent = GetAgentByID($i)
			If DllStructGetData($lAgent, 'Type') <> 0x400 Then ContinueLoop
			If GetDistance($lAgent) > 350 Then ContinueLoop
;~ 			$lItem = GetItemByAgentID($i)
			PickUpItem($lItem)
			$lDeadlock = TimerInit()
			While GetAgentExists($i)
				If TimerDiff($lDeadlock) > 2000 Then ExitLoop
			WEnd
		EndIf
	Next
EndFunc

Func findXunlai()
	EnsureEnglish(True)
	Return GetAgentByName("Xunlai Chest")
EndFunc

Func findMerchant()
	EnsureEnglish(True)
	Return GetAgentByName("Merchant")
EndFunc

;~ Description: Sleep a and salvage
Func SalvageSleep($aAmount, $maxSalvagespeed = 1500)
	Local $SleepTimer = TimerInit()
	Local $lAgentArray
	Do
		Sleep(10)
		If GetIsDead(-2) Then Return
		If GetMapLoading() = 1 Then
			$lAgentArray = GetAgentArray(0xDB)
			StayAlive($lAgentArray)
		EndIf

		autoSalvage()
	Until TimerDiff($SleepTimer) >= $aAmount
EndFunc   ;==>RndSleep
