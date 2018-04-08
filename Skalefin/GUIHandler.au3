;GUIHandler.au3


Func _StartBtnHandler()
	Local $lCharacter = GuiCtrlRead($characterCombo)
	_InitializeVVC($lCharacter)
EndFunc

Func _RenderingBtnHandler()
	ToggleRendering()
EndFunc

Func Out($message)
	Local $Time = _NowTime(5)
	Local $LogOutput = "[" & $Time & "] " & $message & @CRLF
	Local $iEnd = StringLen(GUICtrlRead($logEdit))
;~ 	_GUICtrlEdit_SetSel($logEdit, $iEnd, $iEnd)
;~ 	_GUICtrlEdit_Scroll($logEdit, $SB_SCROLLCARET)
	GUICtrlSetData($logEdit, $LogOutput, 1)
EndFunc
