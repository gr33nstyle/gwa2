Global Const $doLoadLoggedChars = True
Global $RenderingEnabled = True


Opt("GUIOnEventMode", 1)

;~ $GUI = GUICreate("quickChest", 192, 287, 372, 203)
$GUI = GUICreate("quickChest", 192, 400, 372, 203)

$TAB_CREATE = GUICtrlCreateTab(0, -1, 196, 274, $TCS_FIXEDWIDTH)

$TAB_Main = GUICtrlCreateTabItem("Main")

$LBL_Runs = GUICtrlCreateLabel("-", 9, 29, 173, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xF9F9F9)

$Group1 = GUICtrlCreateGroup("Chest                   No Chest", 8, 53, 177, 45)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$LBL_ChestDidSpawn = GUICtrlCreateLabel("0", 14, 73, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x008000)
GUICtrlSetBkColor(-1, 0xF9F9F9)
$LBL_ChestDidNotSpawn = GUICtrlCreateLabel("0", 98, 73, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("LP retained          LP broken", 8, 101, 177, 45)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$LBL_LockPickRetained = GUICtrlCreateLabel("0", 14, 121, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x008000)
GUICtrlSetBkColor(-1, 0xF9F9F9)
$LBL_LockPickBroken = GUICtrlCreateLabel("0", 98, 121, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group3 = GUICtrlCreateGroup("Lucky Points       Unlucky Points", 8, 149, 177, 45)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$LBL_LuckyPoints = GUICtrlCreateLabel("0", 14, 169, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetBkColor(-1, 0xF9F9F9)
$LBL_UnluckyPoints = GUICtrlCreateLabel("0", 98, 169, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetBkColor(-1, 0xF9F9F9)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Gold Items           Purple Items", 8, 194, 177, 45)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$LBL_GoldItems = GUICtrlCreateLabel("0", 14, 214, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x808000)
GUICtrlSetBkColor(-1, 0xF9F9F9)
$LBL_PurpleItems = GUICtrlCreateLabel("0", 98, 214, 80, 17, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetColor(-1, 0x800080)
GUICtrlSetBkColor(-1, 0xF9F9F9)

$BT_Start = GUICtrlCreateButton("Start", 8, 244, 86, 23)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

$BT_Exit = GUICtrlCreateButton("Exit", 99, 244, 86, 23)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

If $doLoadLoggedChars Then
   $Char = GUICtrlCreateCombo("Char Name", 24, 321, 145, 25)
	  	  GUICtrlSetData(-1, GetLoggedCharNames())
Else
	$Char = GUICtrlCreateInput("Character Name", 24, 321, 145, 25)
 EndIf

$Rendering = GUICtrlCreateCheckbox("Rendering", 24, 272, 70, 17)
;~ 	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "_ToggleRendering")
$HM = GUICtrlCreateCheckbox("HM", 100, 272, 50, 17)
$PickPurple = GUICtrlCreateCheckbox("Purple", 100, 296, 80, 17)
$PickGold = GUICtrlCreateCheckbox("Gold", 24, 296, 50, 17)
$logItems = GUICtrlCreateCheckbox("Log Items", 24, 350, 100, 17)


$TAB_Console = GUICtrlCreateTabItem("Console")
$ED_Console = GUICtrlCreateEdit("", 8, 26, 177, 208, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL), $WS_EX_STATICEDGE)
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

$ED_ConsoleInput = GUICtrlCreateInput("", 8, 240, 177, 22)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlCreateTabItem("")

$LBL_Version = GUICtrlCreateLabel("Version 2.0", 19, 380, 60, 12)
GUICtrlSetFont(-1, 8, 400, 0, "Century Gothic")

$LBL_TimerRun = GUICtrlCreateLabel("00:00:00", 93, 380, 50, 12, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400, 0, "Century Gothic")

$LBL_TimerGlobal = GUICtrlCreateLabel("00:00:00", 141, 380, 50, 12, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400, 0, "Century Gothic")
GUISetState(@SW_SHOW)



;»»»»»»»»»»»»»»» EventHandler ««««««««««««««««

;Main
GUICtrlSetOnEvent($BT_Start, "EventHandler")
GUICtrlSetOnEvent($BT_Exit, "EventHandler")

;Console
GUICtrlSetOnEvent($ED_Console, "EventHandler")

;Others
GUISetOnEvent($GUI_Event_Close, "EventHandler")


Func ToggleRendering()
	$RenderingEnabled = Not $RenderingEnabled
	If $RenderingEnabled Then
		EnableRendering()
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	Else
		DisableRendering()
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
		ClearMemory()
	EndIf
 EndFunc







