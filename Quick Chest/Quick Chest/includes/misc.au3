
Func CountSlots()
	Local $FreeSlots = 0, $BagSlots = 0
	For $i = 1 To 3
		$BagSlots = CountBagSlots($i)
		$FreeSlots = $FreeSlots + $BagSlots
		For $slot = 1 To $BagSlots
			If IDofModel($i, $slot) <> 0 Then
				$FreeSlots = $FreeSlots - 1
			EndIf
		Next
	Next
	Return $FreeSlots
EndFunc   ;==>CountSlots


Func CountBagSlots($aBag)
	Return DllStructGetData(GetBag($aBag), 'slots')
EndFunc   ;==>CountBagSlots


Func IDofModel($bagid, $slotid)
	Return DllStructGetData(getitembyslot($bagid, $slotid), 'ModelID')
EndFunc   ;==>IDofModel


Func WriteInfos($aString)
	FileWriteLine("logfiles\Items.log", $aString)
EndFunc   ;==>WriteInfos


Func getAttribute($attr)
	$ret = $attr
	Switch $attr
		Case 0
			$ret = "Fast Casting"
		Case 1
			$ret = "Illusion Magic"
		Case 2
			$ret = "Domination Magic"
		Case 3
			$ret = "Inspiration Magic"
		Case 4
			$ret = "Blood Magic"
		Case 5
			$ret = "Death Magic"
		Case 6
			$ret = "Soul Reaping"
		Case 7
			$ret = "Curses"
		Case 8
			$ret = "Air Magic"
		Case 9
			$ret = "Earth Magic"
		Case 10
			$ret = "Fire Magic"
		Case 11
			$ret = "Water Magic"
		Case 12
			$ret = "Energy Storage"
		Case 13
			$ret = "Healing Prayers"
		Case 14
			$ret = "Smiting Prayers"
		Case 15
			$ret = "Protection Prayers"
		Case 16
			$ret = "Divine Favor"
		Case 17
			$ret = "Strength"
		Case 18
			$ret = "Axe Mastery"
		Case 19
			$ret = "Hammer Mastery"
		Case 20
			$ret = "Swordsmanship"
		Case 21
			$ret = "Tactics"
		Case 22
			$ret = "Beast Mastery"
		Case 23
			$ret = "Expertise"
		Case 24
			$ret = "Wilderness Survival"
		Case 25
			$ret = "Marksmanship"
		Case 29
			$ret = "Dagger Mastery"
		Case 30
			$ret = "Deadly Arts"
		Case 31
			$ret = "Shadow Arts"
		Case 32
			$ret = "Communing"
		Case 33
			$ret = "Restoration Magic"
		Case 34
			$ret = "Channeling Magic"
		Case 35
			$ret = "Critical Strikes"
		Case 36
			$ret = "Spawning Power"
		Case 37
			$ret = "Spear Mastery"
		Case 38
			$ret = "Command"
		Case 39
			$ret = "Motivation"
		Case 40
			$ret = "Leadership"
		Case 41
			$ret = "Scythe Mastery"
		Case 42
			$ret = "Wind Prayers"
		Case 43
			$ret = "Earth Prayers"
		Case 44
			$ret = "Mysticism"
	EndSwitch
	Return $ret
EndFunc   ;==>getAttribute


Func UseSkillEx($aSkillSlot, $aTarget)
	Local $lSkillID = GetSkillBarSkillID($aSkillSlot, 0)
	Local $lSkillStruct = GetSkillByID($lSkillID)
	Local $lActivation = DllStructGetData($lSkillStruct, 'Activation')
	Local $lAftercast = DllStructGetData($lSkillStruct, 'Aftercast')

	$lMe = GetAgentByID(-2)
	If DllStructGetData($lMe, 'HP') <= 0 Then Return -1

	UseSkill($aSkillSlot, $aTarget)
	Sleep(($lAftercast + $lActivation) * 1000 + 25 - GetPing() / 1.75)
EndFunc   ;==>UseSkillEx


Func _TimerGlobal()
	_TicksToTime(Int(TimerDiff($TIMER_GLOBAL)), $Hour, $Mins, $Secs)
	$FORMAT_TIMER_GLOBAL = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	GUICtrlSetData($LBL_TimerGlobal, $FORMAT_TIMER_GLOBAL)
EndFunc   ;==>_TimerGlobal


Func _TimerCurrentRun()
	If $Running = True Then
		_TicksToTime(Int(TimerDiff($TIMER_RUN)), $Hour, $Mins, $Secs)
		Global $FORMAT_TIMER_RUN = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
		GUICtrlSetData($LBL_TimerRun, $FORMAT_TIMER_RUN)
	EndIf
EndFunc   ;==>_TimerCurrentRun


Func _PurgeHook()
	StatusUpdate("Purging engine hook")
	_ToggleRendering()
	TolSleep(2000)
	_ToggleRendering()

EndFunc   ;==>_PurgeHook


Func UpdateIniStats()
	IniWrite("Statistics.ini", "General", "Runs", " " & $Stats_Runs)

	IniWrite("Statistics.ini", "ChestSpawns", "Positiv", " " & GUICtrlRead($LBL_ChestDidSpawn))
	IniWrite("Statistics.ini", "ChestSpawns", "Negativ", " " & GUICtrlRead($LBL_ChestDidNotSpawn))

	IniWrite("Statistics.ini", "Lockpicks", "Retained", " " & GUICtrlRead($LBL_LockPickRetained))
	IniWrite("Statistics.ini", "Lockpicks", "Broken", " " & GUICtrlRead($LBL_LockPickBroken))

	IniWrite("Statistics.ini", "Titles", "LuckyPoints", " " & GUICtrlRead($LBL_LuckyPoints))
	IniWrite("Statistics.ini", "Titles", "UnluckyPoints", " " & GUICtrlRead($LBL_UnluckyPoints))

	IniWrite("Statistics.ini", "Items", "GoldItems", " " & GUICtrlRead($LBL_GoldItems))
	IniWrite("Statistics.ini", "Items", "PurpleItems", " " & GUICtrlRead($LBL_PurpleItems))

	IniWrite("Statistics.ini", "Times", "Total", " " & GUICtrlRead($LBL_TimerGlobal))
	IniWrite("Statistics.ini", "Times", "LastRun", " " & GUICtrlRead($LBL_TimerRun))
EndFunc   ;==>UpdateIniStats


Func LogItemInfos($aItemID)
	Local $color

	$Item = GetItemByAgentID($aItemID)
	WriteInfos("")
	WriteInfos("Name: " & GetAgentName($aItemID))
	If GetRarity($Item) = 2624 Then $color = "Gold"
	If GetRarity($Item) = 2626 Then $color = "Purple"
	WriteInfos("Rarity: " & $color)
	$item_attribute = getAttribute(GetItemAttribute($Item))
	WriteInfos("Requires: " & GetItemReq($Item) & " (" & $item_attribute & ")")
	WriteInfos("Model ID: " & DllStructGetData($Item, 'ModelID'))
	WriteInfos("")
EndFunc   ;==>LogItemInfos


Func _ToggleRendering()
	If $Rendering Then
		_DisableRendering()
	Else
		_EnableRendering()
	EndIf
EndFunc   ;==>_ToggleRendering

Func _DisableRendering()
   DisableRendering()
   ClearMemory()
   WinSetState(GetWindowHandle(), "", @SW_HIDE)
   $Rendering = False
EndFunc

Func _EnableRendering()
   WinSetState(GetWindowHandle(), "", @SW_SHOW)
   EnableRendering()
   $Rendering = True
EndFunc

Func _ToggleShowHide()
	If $ShowHide Then
		WinSetState("Guild Wars - ", "", @SW_HIDE)
		$ShowHide = False
	Else
		WinSetState("Guild Wars - ", "", @SW_SHOW)
		$ShowHide = True
	EndIf
EndFunc   ;==>_ToggleShowHide


Func StatusUpdate($aString)
	FileWriteLine("logfiles\History.log", @HOUR & ":" & @MIN & " - " & $aString)
	ConsoleWrite(@HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	GUICtrlSetData($ED_Console, GUICtrlRead($ED_Console) & @HOUR & ":" & @MIN & " - " & $aString & @CRLF)
	_GUICtrlEdit_Scroll($ED_Console, 4)
EndFunc   ;==>StatusUpdate
