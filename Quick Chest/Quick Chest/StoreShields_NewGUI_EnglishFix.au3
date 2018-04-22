#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\icon.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#include <includes\GWA2_new.au3>
#include <includes\userinterface.au3>
#include <includes\misc.au3>

;»»»»»»»»»»»»»»»»»   Variables   ««««««««««««««««««

Global $Running = False

Global $FastWayOut = True
Global $Rendering = True
Global $ShowHide = True
Global $Stats_Runs = 0
Global $GUI_Clear = 1
Global $ChestDropGold = 0
Global $ChestDropPurple = 0
Global $PickedUpGold = 0
Global $PickedUpPurple = 0

Global $oStats_LuckyPoints = GetLuckyTitle()
Global $oStats_UnLuckyPoints = GetUnluckyTitle()

Global $Map_ZosShivros = 273
Global $Map_BoreasSeabed = 247
Global $Mode = 0


Global $Skill_BloodIsPower =  1
Global $Skill_AwakenTheBlood = 2
Global $Skill_NecroticTraversal = 4
Global $Skill_EbonEscape = 5
Global $Skill_DrunkenMaster = 7
Global $Skill_IamUnstoppable = 8


;»»»»»»»»»»»»»»»»»»     Timer     ««««««««««««««««««

Global $Secs, $Mins, $Hour, $Time
$TIMER_GLOBAL = TimerInit()

AdlibRegister("_TimerGlobal", 1000)
AdlibRegister("_TimerCurrentRun", 1000)

$TIMER_RUN = 0


;»»»»»»»»»»»»»»»    EventHandler    ««««««««««««««««

Func EventHandler()
	Switch (@GUI_CtrlId)

		Case $BT_Start

		 StatusUpdate("Initializing")
			Local $CharName = GUICtrlRead($Char)
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


			$Running = True
			GUICtrlSetState($BT_Start, $GUI_DISABLE)
;~ 			GUICtrlSetState($Rendering, $GUI_ENABLE)
			GUICtrlSetState($Char, $GUI_DISABLE)

		Case $BT_Exit
			Exit

		Case $GUI_Event_Close
			Exit

	EndSwitch
 EndFunc   ;==>EventHandler


;»»»»»»»»»»»»»»»»    Bot Start    ««««««««««««««««««



Main()

Func Main()
   If $Stats_Runs < 1 Then
	  PrepareSkills()
   EndIf

	While 1
		Sleep(250)
		If $Running = True Then
			SetMaxMemory()
			EnsureEnglish(1)
			;Map Check
			If GetMapID() <> $Map_ZosShivros Then
				TravelTo($Map_ZosShivros)
				WaitMapLoading()
			EndIf

			;Free Slots Check
			$Bag_FreeSlots = CountSlots()
			If $Bag_FreeSlots < 2 Then
				Return IdentAndSell()
			EndIf

			;FastWayOut Check
			If 	$FastWayOut = True Then
				FastWayOut()
			EndIf

			;Lockpick Check
			If DllStructGetData(GetItemByModelID(22751), 'Quantity') = 0 Then
				$Running = False
				GUICtrlSetData($LBL_Runs, "ran out of lockpicks")
				IdentAndSell()
			EndIf

			;GUI-Console Check
			$GUI_Clear = $GUI_Clear + 1
			If $GUI_Clear = 25 Then
				GUICtrlSetData($ED_Console, "")
				Global $GUI_Clear = 0
				StatusUpdate("Cleared to prevent Crash")
			EndIf

			Global $TIMER_RUN = TimerInit()

			GUICtrlSetData($LBL_Runs, "Chest Run #" & $Stats_Runs + 1)
			DoRun()

			$Stats_Runs = $Stats_Runs + 1
			GUICtrlSetData($LBL_ChestDidNotSpawn, $Stats_Runs - GUICtrlRead($LBL_ChestDidSpawn))
			StatusUpdate("Finished in " & GUICtrlRead($LBL_TimerRun))

			UpdateIniStats()
			If $Rendering = False And Mod($Stats_Runs, 100) = 77 Then _PurgeHook()
		EndIf
	WEnd
EndFunc   ;==>Main

Func FastWayOut()

;~ 	If IniRead("Settings.ini", "Misc", "Mode", "NOTFOUND") = "Hardmode" Then
    If GUICtrlRead($HM) = 1 Then
		StatusUpdate("Switching to Hardmode")
		SwitchMode(1)
		$Mode = 1
    Else
	    StatusUpdate("Switching to Hardmode")
	    SwitchMode(0)
		$Mode = 0
	EndIf

	StatusUpdate("Preparing FastWayOut")
	MoveTo(3281, 5759)

	Do
		StatusUpdate("Zoning Out")
		Move(3508, 7728)
		StatusUpdate("Loading Map")
		sleep(125)
	Until WaitMapLoading($Map_BoreasSeabed)

	Do
		StatusUpdate("Zoning In")
		Move(12696, -12071)
		StatusUpdate("Loading Map")
		sleep(125)
	Until WaitMapLoading($Map_ZosShivros)

	$FastWayOut = False
	Main()
EndFunc   ;==>FastWayOut

Func DoRun()
	Local $ChestName

;~ 	If IniRead("Settings.ini", "Misc", "Mode", "NOTFOUND") = "HardMode" Then $ChestName = "Locked Chest"
;~ 	If IniRead("Settings.ini", "Misc", "Mode", "NOTFOUND") = "NormalMode" Then $ChestName = "Luxon Chest"

    If $Mode = 1 Then $ChestName = "Locked Chest"
    If $Mode = 0 Then $ChestName = "Luxon Chest"

	StatusUpdate("")
	StatusUpdate("Starting Run #" & $Stats_Runs + 1)

	Do
		StatusUpdate("Zoning Out")
		Move(3508, 7728)
		StatusUpdate("Loading Map")
		sleep(125)
	Until WaitMapLoading($Map_BoreasSeabed)

	StatusUpdate("Using BiP till Death")
	UseSkill($Skill_AwakenTheBlood, -2)
	Sleep(1000)

	Do
		UseSkill($Skill_BloodIsPower, GetNearestAgentToAgent(-2))
		Sleep(25)
	Until GetIsDead(-2) = True

	StatusUpdate("Waiting for Respawn")
	Do
		Sleep(150)
	Until GetIsDead(-2) = False

	StatusUpdate("Checking for Chest")
	Local $ChestSpawn = 0

	For $i = 0 To 4
		TargetNextItem()
		Sleep(50)
		$Target = GetCurrentTarget()
		Sleep(50)
		$Name = GetAgentName($Target)
		Sleep(50)

		If $Name = $ChestName Then
			$ChestSpawn = $ChestSpawn + 1
			StatusUpdate("Chest found")

			$ChestX = DllStructGetData($Target, 'X')
			$ChestY = DllStructGetData($Target, 'Y')

			StatusUpdate("Opening Chest")
			Global $oStats_Lockpicks = DllStructGetData(GetItemByModelID(22751), 'Quantity')
			GoSignpost($Target)
			OpenChest()

			GUICtrlSetData($LBL_ChestDidSpawn, GUICtrlRead($LBL_ChestDidSpawn) + 1)
			sleep(350)

			$nStats_Lockpicks = DllStructGetData(GetItemByModelID(22751), 'Quantity')

			If $nStats_Lockpicks = $oStats_Lockpicks Then
				StatusUpdate("Lockpick retained")
				GUICtrlSetData($LBL_LockPickRetained, GUICtrlRead($LBL_LockPickRetained) + 1)
			EndIf

			If $nStats_Lockpicks <> $oStats_Lockpicks Then
				StatusUpdate("Lockpick broke")
				GUICtrlSetData($LBL_LockPickBroken, GUICtrlRead($LBL_LockPickBroken) + 1)
			EndIf

			$nStats_LuckyPoints = GetLuckyTitle() - $oStats_LuckyPoints
			GUICtrlSetData($LBL_LuckyPoints, $nStats_LuckyPoints)
			$nStats_UnLuckyPoints = GetUnLuckyTitle() - $oStats_UnLuckyPoints
			GUICtrlSetData($LBL_UnluckyPoints, $nStats_UnLuckyPoints)
		EndIf
	Next

	If $ChestSpawn > 0 Then
		StatusUpdate("Checking Drops")
		DropHandling()
	Else
		StatusUpdate("No Chest found")
	EndIf

	StatusUpdate("Resigning")
	Resign()

	Do
		Sleep(150)
	Until GetIsDead(-2) = True

	sleep(3000)

	ReturnToOutpost()
	StatusUpdate("Returning back")


	Sleep(150)
	StatusUpdate("Loading Map")
	WaitMapLoading()
EndFunc   ;==>DoRun

Func DropHandling()
	Local $Check_GoldDrop = False
	Local $Check_PurpleDrop = False
	Local $Golddrop = False
	Local $Purpledrop = False

	For $i = 0 To 2

		TargetNextItem()
		sleep(25)
		$itemid = GetCurrentTargetID()
		$Rarity = GetRarity(GetItemByAgentID($itemid))

		If $Rarity = 2624 Then
			$ChestDropGold = $ChestDropGold + 1
			GUICtrlSetData($LBL_GoldItems, $ChestDropGold & " (" & $PickedUpGold & ")")
			$Golddrop = $itemid
			$Check_GoldDrop = True
		EndIf

		If $Rarity = 2626 Then
			$ChestDropPurple = $ChestDropPurple + 1
			GUICtrlSetData($LBL_PurpleItems, $ChestDropPurple & " (" & $PickedUpPurple & ")")
			$Purpledrop = $itemid
			$Check_PurpleDrop = True
		EndIf

	Next


	If $Check_GoldDrop = True Then
		StatusUpdate(GetAgentName($Golddrop) & " (Gold)")
;~ 		If IniRead("Settings.ini", "Misc", "LogItems", "NOTFOUND") = "Active" Then LogItemInfos($Golddrop)

		If GUICtrlRead($logItems) = 1 Then LogItemInfos($Golddrop)

;~ 		If IniRead("Settings.ini", "PickUp", "GoldItem", "NOTFOUND") = "pickup" Then
	    If GUICtrlRead($PickGold) = 1 Then
			StatusUpdate("Trying to pickup item")

			UseSkill($Skill_DrunkenMaster, -2)
			UseSkill($Skill_IamUnstoppable, -2)

			Local $Retry = 0
			Do
				Sleep(100)
				If DllStructGetData(GetAgentByID(-2), 'MoveX') == 0 And DllStructGetData(GetAgentByID(-2), 'MoveY') == 0 Then
					$Retry = $Retry + 1
					PickUpItem($Golddrop)
				EndIf
			Until GetIsDead(-2) = True Or $Retry > 15 Or GetAgentExists($Golddrop) = False

			If GetAgentExists($Golddrop) = True Then
				If GetIsDead(GetHeroID(2)) = True Then UseSkillEx($Skill_NecroticTraversal, GetHeroID(2))
				If GetIsDead(GetHeroID(2)) = False Then UseSkillEx($Skill_EbonEscape, GetHeroID(2))
				Do
					Sleep(100)
					If DllStructGetData(GetAgentByID(-2), 'MoveX') == 0 And DllStructGetData(GetAgentByID(-2), 'MoveY') == 0 Then
						$Retry = $Retry + 1
						PickUpItem($Golddrop)
					EndIf
				Until GetIsDead(-2) = True Or $Retry > 125 Or GetAgentExists($Golddrop) = False
			EndIf
			StatusUpdate($Retry & " times blocked")
			If GetAgentExists($Golddrop) = False Then
				StatusUpdate("Pickup successfull")
				$PickedUpGold = $PickedUpGold + 1
				;Updating GUI for PickUps (Gold)
				GUICtrlSetData($LBL_GoldItems, $ChestDropGold & " (" & $PickedUpGold & ")" )
			EndIf
		EndIf
	EndIf


	If $Check_PurpleDrop = True Then
		StatusUpdate(GetAgentName($Purpledrop) & " (Purple)")
;~ 		If IniRead("Settings.ini", "Misc", "LogItems", "NOTFOUND") = "Active" Then LogItemInfos($Purpledrop)

		If GUICtrlRead($logItems) = 1 Then LogItemInfos($Purpledrop)


;~ 		If IniRead("Settings.ini", "PickUp", "PurpleItem", "NOTFOUND") = "pickup" Then
	    If GUICtrlRead($PickPurple) = 1 Then
		  StatusUpdate("Trying to pickup item")

			UseSkill($Skill_DrunkenMaster, -2)
			UseSkill($Skill_IamUnstoppable, -2)

			Local $Retry = 0
			Do
				Sleep(100)
				If DllStructGetData(GetAgentByID(-2), 'MoveX') == 0 And DllStructGetData(GetAgentByID(-2), 'MoveY') == 0 Then
					$Retry = $Retry + 1
					PickUpItem($Purpledrop)
				EndIf
			Until GetIsDead(-2) = True Or $Retry > 15 Or GetAgentExists($Purpledrop) = False

			If GetAgentExists($Purpledrop) = True Then
				If GetIsDead(GetHeroID(2)) = True Then UseSkillEx($Skill_NecroticTraversal, GetHeroID(2))
				If GetIsDead(GetHeroID(2)) = False Then UseSkillEx($Skill_EbonEscape, GetHeroID(2))
				Do
					Sleep(100)
					If DllStructGetData(GetAgentByID(-2), 'MoveX') == 0 And DllStructGetData(GetAgentByID(-2), 'MoveY') == 0 Then
						$Retry = $Retry + 1
						PickUpItem($Purpledrop)
					EndIf
				Until GetIsDead(-2) = True Or $Retry > 125 Or GetAgentExists($Purpledrop) = False
			EndIf
			StatusUpdate($Retry & " times blocked")
			If GetAgentExists($Purpledrop) = False Then
				StatusUpdate("Pickup successfull")
				$PickedUpPurple = $PickedUpPurple + 1
				;Updating GUI for PickUps (Purple)
				GUICtrlSetData($LBL_PurpleItems, $ChestDropPurple & " (" & $PickedUpPurple & ")" )
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DropHandling

Func PrepareSkills()
Local $lMe = GetAgentByID()
Local $Profession = 0
 $Profession = DllStructGetData($lMe, 'Primary')
Switch $Profession
Case 1
   LoadSkillTemplate("OQQCQcx0dwbAAQYwuIAgqINJ") ;War
Case 2
   LoadSkillTemplate("OgQCQcx0dwbAAQYwuIAgqINJ") ;Ranger
Case 3
   LoadSkillTemplate("OwQCQcx0dwbAAQYwuIAgqINJ") ;Monk
Case 4
   LoadSkillTemplate("OABAQ3BvBAAhB7iAAqi0k") 	 ;Necro
Case 5
   LoadSkillTemplate("OQRCQcx0dwbAAQYwuIAgqINJ") ;Mesmer
Case 6
   LoadSkillTemplate("OgRCQcx0dwbAAQYwuIAgqINJ") ;Ele
Case 7
   LoadSkillTemplate("OwRCQcx0dwbAAQYwuIAgqINJ") ;Assa
Case 8
   LoadSkillTemplate("OASCQcx0dwbAAQYwuIAgqINJ") ;Rit
Case 9
   LoadSkillTemplate("OQSCQcx0dwbAAQYwuIAgqINJ") ;Para
Case 10
   LoadSkillTemplate("OgSCQcx0dwbAAQYwuIAgqINJ") ;Derv
EndSwitch

EndFunc

#Region Inventory

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
;~ 		StatusUpdate("Selling item: " & $BAGINDEX & ", " & $I)
		$AITEM = GETITEMBYSLOT($BAGINDEX, $I)
		If DllStructGetData($AITEM, "ID") = 0 Then ContinueLoop
		If CANSELL($AITEM) Then
			SELLITEM($AITEM)
		EndIf
		Sleep(GetPing()+250)
	Next
EndFunc

Func CanSell($aItem)
	Local $m= DllStructGetData($aitem, "ModelID")

If $m = 22751 Then
   Return False
Else
   Return True
EndIf
EndFunc   ;==>CANSELL

Func IdentAndSell()

	StatusUpdate("")

	StatusUpdate("Inventory full")
	StatusUpdate("Traveling GH")
	TravelGH()

	StatusUpdate("Going to Xunlai Chest")
	$Chest = GetAgentByName("Xunlai Chest")
	GoToNpC($Chest)

	StatusUpdate("Going to Merchant")
	$Merchant = GetAgentByName("Merchant")
	GoToNpC($Merchant)

   StatusUpdate("Storing Shields from Backpack")
	  StoreShields(1)

	StatusUpdate("Storing Shields from  Belt Pouch")
	  StoreShields(2)

	StatusUpdate("Storing Shields from  Bag")
	  StoreShields(3)

	StatusUpdate("Identifying Backpack")
	  Ident(1)

	StatusUpdate("Identifying Belt Pouch")
	  Ident(2)

	StatusUpdate("Identifying Bag")
	  Ident(3)

	StatusUpdate("Selling Backpack")
	  Sell(1)
	StatusUpdate("Selling Belt Pouch")
	  Sell(2)
	StatusUpdate("Selling Bag")
	  Sell(3)

	StatusUpdate("Depoisiting Gold")
	DepositGold(GetGoldCharacter())

	StatusUpdate("Leaving GH")
	LeaveGH()

	StatusUpdate("")
	FastWayOut()

EndFunc   ;==>IdentAndSell

#cs
Func IdentAndSell()

	StatusUpdate("")

	StatusUpdate("Inventory full")
	StatusUpdate("Traveling GH")
	TravelGH()

	StatusUpdate("Going to Xunlai Chest")
	$Chest = GetAgentByName("Xunlai Chest")
	GoToNpC($Chest)

	StatusUpdate("Going to Merchant")
	$Merchant = GetAgentByName("Merchant")
	GoToNpC($Merchant)

	StatusUpdate("Identifying Backpack")
	For $i = 0 To 20
		$Item = GetItemBySlot(1, $i)
		$Value = DllStructGetData($Item, 'value')
		If $Value <> 0 Then
			If FindIDKit() = 0 Then
				WithdrawGold(100)
				BuyItem(5, 1, 100)
			EndIf
			IdentifyItem($Item)
		EndIf
		Sleep(250)
	Next

	StatusUpdate("Identifying Belt Pouch")
	For $i = 0 To 5
		$Item = GetItemBySlot(2, $i)
		$Value = DllStructGetData($Item, 'value')

		If $Value <> 0 Then
			If FindIDKit() = 0 Then
				WithdrawGold(100)
				BuyItem(5, 1, 100)
			EndIf
			IdentifyItem($Item)
		EndIf
		Sleep(250)
	Next

	StatusUpdate("Identifying Bag")
	for $i = 0 to 10
		$Item = GetItemBySlot(3, $i)
		$Value = DllStructGetData($Item, 'value')
		If $Value <> 0 Then
		If FindIDKit() = 0 Then
		WithdrawGold(100)
		BuyItem(5, 1, 100)
		EndIf
		IdentifyItem($Item)
		EndIf
		sleep(250)
	next

	StatusUpdate("Selling Backpack")
	For $i = 0 To 20
		$Item = GetItemBySlot(1, $i)
		$Value = DllStructGetData($Item, 'value')
		If $Value <> 0 Then
			SellItem($Item)
		EndIf
		Sleep(250)
	Next

	StatusUpdate("Selling Belt Pouch")
	For $i = 0 To 5
		$Item = GetItemBySlot(2, $i)
		$Value = DllStructGetData($Item, 'value')
		If $Value <> 0 Then
			SellItem($Item)
		EndIf
		Sleep(250)
	Next

	StatusUpdate("Selling Bag")
	for $i = 0 to 10
		$Item = GetItemBySlot(3, $i)
		$Value = DllStructGetData($Item, 'value')
		If $Value <> 0 Then
		SellItem($Item)
		EndIf
		sleep(250)
	next

	StatusUpdate("Depoisiting Gold")
	DepositGold(GetGoldCharacter())

	StatusUpdate("Leaving GH")
	LeaveGH()

	StatusUpdate("")
	FastWayOut()

EndFunc   ;==>IdentAndSell
#ce

#EndRegion

Func OpenStorageSlot()  ;- stolen from StorageManager ;)
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

Func StoreShields($iBag)
   $aBag = GetBag($iBag)
   For $j = 1 To DllStructGetData($aBag, 'Slots')
	  $item = GetItemBySlot($iBag, $j)
	  $type = DllStructGetData($item, 'Type')
	  If $type = 24 Then ;~ is shield
		 $storageSlot = OpenStorageSlot()
		 If IsArray($storageSlot) Then
			MoveItem($item , $storageSlot[0], $storageSlot[1])
			Sleep(GetPing() + Random(500, 750, 1))
		 EndIf
	  EndIf
   Next
EndFunc

