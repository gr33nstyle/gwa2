;Misc.au3
Func _ToggleRendering()
	If $Rendering Then
		_DisableRendering()
	Else
		_EnableRendering()
	EndIf
EndFunc   ;==>_ToggleRendering

Func ToggleRendering()
	$Rendering = Not $Rendering
	If $Rendering Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
EndFunc   ;==>ToggleRendering

Func _DisableRendering()
   DisableRendering()
   ClearMemory()
   WinSetState($mGWHwnd, "", @SW_HIDE)
   $Rendering = False
EndFunc

Func _EnableRendering()
   WinSetState($mGWHwnd, "", @SW_SHOW)
   EnableRendering()
   $Rendering = True
EndFunc

Func _PurgeHook()
	_ToggleRendering()
	Sleep(Random(2000, 3000))
	_ToggleRendering()
EndFunc

Func _CheckForQ0Scythe($lItem)
	Local $lType = DllStructGetData($lItem, "Type")
	If $lType <> 35 Then Return False

	Local $lReq = GetItemReq($lItem)

	If $lReq <> 0 Then Return False

	Local $lMinDmg = GetItemMinDmg($lItem)
	Local $lMaxDmg = GetItemMaxDmg($lItem)

	Return $lMinDmg = 8 And $lMaxDmg = 17
EndFunc

Func _PickupLoot()
	Local $me, $agent, $distance, $lItem
	For $i = 1 To GetMaxAgents()
		If GetIsDead(-2) Then Return False
		Local $agent = GetAgentByID($i)
		If Not GetIsMovable($agent) Then ContinueLoop
		$distance = GetDistance($agent)
	    If $distance > 2000 Then ContinueLoop
		$lItem = GetItemByAgentID($i)
		Local $lModelId = DllStructGetData($lItem, "ModelID")

		If $lModelId = 19184 Or _CheckForQ0Scythe($lItem) Then
			If $distance > 150 Then MoveTo(DllStructGetData($agent, 'X'), DllStructGetData($agent, 'Y'), 100)
			PickUpItem($lItem)
			sleep(GetPing() + 250)
		EndIf
	Next
	Return True
EndFunc

Func InitFromCmdLine()
	Local $lCharacter = $CmdLine[1]
	_InitializeVVC($lCharacter)
EndFunc

Func AfterInitializationSetup()
;~ 	If Not FileExists($PROCESS_INI) Then
;~ 		_FileCreate($PROCESS_INI)
;~ 	EndIf
;~ 	Local $gwExePath = _WinAPI_GetProcessFileName(WinGetProcess($mGWHwnd))
;~ 	IniWrite($PROCESS_INI, "gwPIDs", $gwExePath, WinGetProcess($mGWHwnd))
;~ 	IniWrite($PROCESS_INI, "botPIDs", $gwExePath, @AutoItPID)
;~ 	IniWrite($PROCESS_INI, "scriptNames", $gwExePath, @ScriptFullPath)
;~ 	IniWrite($PROCESS_INI, "character", $gwExePath, GetCharname())
;~ 	If $CmdLine[0] > 0 Then
;~ 		ToggleRendering()
;~ 	EndIf
EndFunc
