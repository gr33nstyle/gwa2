#include-once

#include <GWA2.au3>

#include <GlobalConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ScrollBarsConstants.au3>
#include <Misc.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <Date.au3>
#include <SliderConstants.au3>
#include <UpDownConstants.au3>

#include <GDIPlus.au3>
#include <GUICtrlOnHover.au3>
#include <Array.au3>
;~ #include <Math.au3>

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("TrayIconHide", 1)

Global $myTransparenty = IniRead($IniPath, "Settings", "Transparenty ",190)

; -> GW API #Region GUI


Local Const $tagSTRUCT1 = "struct;short TabAmount; ptr TabStructsPTR[24];endstruct"
Local Const $tagSTRUCT2 = "struct;char TabName[128]; UINT TabNumber; HWND TabHWND; byte Open; UINT OpenTabCtrlId;UINT GDIPlusCount; HWND GDIPlusHWND[128]; byte GDIPlusTicked[128]; HWND GDIPlusHWND1[128]; HWND GDIPlusHWND2[128];UINT GDIPlusCtrlID[128]; endstruct"
Global $TabArrayOfStructs[1] = [DllStructCreate($tagSTRUCT1)]
;~ 	DllStructSetData($TabArrayOfStructs[0], "TabAmount", 0); 0 by defaut
DllStructSetData($TabArrayOfStructs[0], "TabStructsPTR", DllStructGetPtr($TabArrayOfStructs[0]),1)

;~ Global $BagSlot[2] = [0,0]

;==>ImageGui
Global Const $AC_SRC_ALPHA = 1
Global Const $MY_Color_Background = 0x090909
Global Const $MY_Color_DarkGrey = 0x222222
Global Const $MY_Color_LightGrey = 0x111111
Global Const $MY_Color_Text = 0x409090  ;0xaaaebb
Global Const $MY_Color_Text2 = 0xeaeebb  ;0xaaaebb
_GDIPlus_Startup() ;lade und aktiviere GDI+$MY_Color_Text


;__________Build GUI__________
Global Const $RightGuiWidth = 180
Global Const $LeftGuiWidth = 130
Global Const $MainWidth = $RightGuiWidth
Global Const $MainHeight = 25

#Region MainGui
Global $MainGUI = GUICreate("Fiber " & $Version, $MainWidth, $MainHeight , -1, -1,$WS_POPUP , BitOR($WS_EX_LAYERED , $WS_EX_CONTROLPARENT))
GUICtrlSetFont(-1, 14, 400, 0, "Segoe Print Regular")
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text,$MainGUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
GUISetOnEvent($GUI_EVENT_SECONDARYUP, "_Secondaryup")
_GuiRoundCorners($MainGUI, 3)
Global $ToolBoxLabel = GUICtrlCreatePic(@ScriptDir & '\img\Logo Red.jpg', 0, 0, 130, 24, -1, $GUI_WS_EX_PARENTDRAG)
;~ GUICtrlSetOnEvent(-1, 'saveToIni')
;~ GUICtrlSetCursor ( -1,9)
Global $Minimize_Button_MainBox = GuiCtrlCreateLabel("-", $MainWidth-50, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'MainGUIEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_MainBox = GuiCtrlCreateLabel("X", $MainWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'MainGUIEventHandler')
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($MainWidth-50, 0, 1, 25,$MY_Color_DarkGrey)
GuiCtrlCreateRect($MainWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
;GUISetState(@SW_SHOW, $MainGUI) at the End of BuildGui to avoid flicker
#EndRegion MainGui

#Region CharNameTab
Local $CharNameTabHight = $MainHeight
Local $CharNameTabWidth = $LeftGuiWidth
Local $CharNameTabHWND = _newTab("CharNameTab", $MainGUI, $CharNameTabWidth, $CharNameTabHight, 3 - $LeftGuiWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$CharNameTabHWND)
GUICtrlSetDefColor($MY_Color_Text,$CharNameTabHWND)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($CharNameTabHWND, 3)
;~ GuiCtrlCreateRect($LeftGuiWidth-1, 0, 1, 25,$MY_Color_DarkGrey)
_WinAPI_SetLayeredWindowAttributes($CharNameTabHWND, 0xCC0000, $myTransparenty)
Local $iTab = getTabNrByName("CharNameTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

$y = 0
$x = 0
Global $CharInput = GUICtrlCreateCombo("", 0, 0, 120, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL,0,0))
GUICtrlSetBkColor(-1,$MY_Color_Background)
GUICtrlSetColor(-1,0x55ffcc)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
Local $logged_chars = GetLoggedCharNames()
If ($logged_chars == "") Then
	Local $array_ScanGw = ScanGW()
	ConsoleWrite(@CRLF)
	For $i = 0 To UBound($array_ScanGw) -1
		ConsoleWrite(@CRLF & "! $array_ScanGw " & $array_ScanGw[$i])
	Next
	If $array_ScanGw[0] = 1 Then
		GUICtrlSetData($CharInput,$array_ScanGw[1],$array_ScanGw[1])
	;~ 	GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf
Else
	ConsoleWrite(@CRLF & "! $logged_chars " & $logged_chars)
	GUICtrlSetData($CharInput, $logged_chars, StringSplit($logged_chars, "|", 2)[0])
EndIf

#EndRegion

#Region TableisteTab
Local $TableisteHight = 46 - $MainHeight
Local $TableisteWidth = $LeftGuiWidth + $RightGuiWidth
Local $tableisteHWND = _newTab("Tableiste", $MainGUI, $TableisteWidth, $TableisteHight, 3 - $LeftGuiWidth, 3+$MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$tableisteHWND)
GUICtrlSetDefColor($MY_Color_Text,$tableisteHWND)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($tableisteHWND, 3)
GuiCtrlCreateRect($LeftGuiWidth-1, 0, 1, 25,$MY_Color_DarkGrey)
_WinAPI_SetLayeredWindowAttributes($tableisteHWND, 0xCC0000, $myTransparenty)
Local $iTab = getTabNrByName("Tableiste")
Local $iStruct = $TabArrayOfStructs[$iTab]

;~ GUICtrlCreateLabel("",$LeftGuiWidth,1,1,23)
;~ GUICtrlSetBkColor(-1,0xCC0000) ; make the gui transparent at Lables
;~ GUICtrlCreateLabel("",$LeftGuiWidth + 1,0,$RightGuiWidth,25)
;~ GUICtrlSetBkColor(-1,0xCC0000) ; make the gui transparent at Lables
$y = 0
$x = 0
;~ Global $CharInput = GUICtrlCreateCombo("", 0, 0, 120, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL,0,0))
;~ GUICtrlSetBkColor(-1,0x000000)
;~ GUICtrlSetColor(-1,0x55ffcc)
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ Local $logged_chars = GetLoggedCharNames()
;~ If ($logged_chars == "") Then
;~ 	Local $array_ScanGw = ScanGW()
;~ 	If $array_ScanGw[0] = 1 Then
;~ 		GUICtrlSetData(-1,$array_ScanGw[1],$array_ScanGw[1])
		GUICtrlSetState(-1, $GUI_DISABLE)
;~ 	EndIf
;~ Else
;~ 	GUICtrlSetData(-1, $logged_chars, StringSplit($logged_chars, "|", 2)[0])
;~ EndIf
;~ Global $MinimizeLeftsideButton = GUICtrlCreateLabel(">",120,0,9,25,BitOR($ss_center, $ss_centerimage),0)
;~ GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
;~ GUICtrlSetFont(-1, 9,400,0,"arial")
$x += 35
;~ $y += 25
GuiCtrlCreateRect(0, $y, $TableisteWidth, 1,$MY_Color_DarkGrey)
$y += 1
Global $StartTabLable = GUICtrlCreateLabel("Main", 0, $y, 35, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1
Global $StatsTabLable = GUICtrlCreateLabel("Stats", $x , $y, 35, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
$x += 35
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1
Global $LootTabLable = GUICtrlCreateLabel("Loot", $x , $y, 35, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
$x += 35
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1
Global $SellTabLable = GUICtrlCreateLabel("Sell", $x , $y, 35, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
$x += 35
GuiCtrlCreateRect($x, $y, 1, 25,$MY_Color_DarkGrey)
$x += 1
Global $InventoryTabLable = GUICtrlCreateLabel("Inventory", $x , $y, 70, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
$x += 70
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1
Global $ChestTabLable = GUICtrlCreateLabel("Chest", $x , $y, 35, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverFuncOff")
$x += 35
GuiCtrlCreateRect($x, $y, 1, 25,$MY_Color_DarkGrey)
$x += 1

GuiCtrlCreateRect(0, $TableisteHight-1, $TableisteWidth, 1,$MY_Color_DarkGrey)

;~ Global $SalvageTabLable  = GUICtrlCreateIcon(@ScriptDir & '\img\Perfect_Salvage_Kit.ico',-1,$x ,$y, 19, 19)
;~ GUICtrlSetOnEvent(-1, "MainGUIEventHandler")
;~ $x = $LeftGuiWidth -1

;~ GUICtrlCreateLabel("",$x,$y,21,19)
;~ GUICtrlSetBkColor(-1,0xCC0000) ; make the gui transparent at Lables
Local $SalvagePath = @ScriptDir & '\img\Perfect_Salvage_Kit_black_x19.png'
Global $SalvageTabLable = _GuiCtrlCreatePic($iStruct, $tableisteHWND, $SalvagePath, $x, $y)
GUICtrlSetOnEvent($SalvageTabLable,"MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_Hover_SalvageButtonOn", "_Hover_SalvageButtonOff")
Global $Button_Salvage_black = _GDIPlus_ImageLoadFromFile($SalvagePath)
Global $Button_Salvage_bright = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\img\Perfect_Salvage_Kit_bright_x19.png")
GUISwitch($tableisteHWND)
$x += 32
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1
Local $SettingsPath = @ScriptDir & '\img\Settings_black.png'
Global $SettingsTabLable = _GuiCtrlCreatePic($iStruct, $tableisteHWND, $SettingsPath, $x, $y)
GUICtrlSetOnEvent($SettingsTabLable,"MainGUIEventHandler")
_GUICtrl_OnHoverRegister(-1, "_Hover_SettingsButtonOn", "_Hover_SettingsButtonOff")
Global $Button_Settings_black = _GDIPlus_ImageLoadFromFile($SettingsPath)
Global $Button_Settings_bright = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\img\Settings_bright.png")
GUISwitch($tableisteHWND)
$x += 32
GuiCtrlCreateRect($x, $y, 1, 19,$MY_Color_DarkGrey)
$x += 1

#EndRegion TableisteTab

#Region GlogboxTab
Local Const $GlogboxHight = 150
Local Const $GlogboxWidth = $RightGuiWidth
Local $GlogboxTab = _newTab("GlogBoxTab", $MainGUI, $GlogboxWidth, $GlogboxHight, 3, 3+ $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text)
_WinAPI_SetLayeredWindowAttributes($GlogboxTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $GlogboxWidth, 1,$MY_Color_DarkGrey)
_GuiRoundCorners($GlogboxTab, 3)
Global $GLOGBOX = GUICtrlCreateEdit("", 0, 0, $GlogboxWidth  , $GlogboxHight, BitOR($es_autovscroll, $es_readonly, $es_wantreturn, $ws_vscroll), 0)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetBkColor(-1,$MY_Color_Background)
#EndRegion GlogboxTab

#Region StartTab
Global $StartTabHight = 150
Local $StartTab = _newTab("StartTab", $MainGUI, $LeftGuiWidth, $StartTabHight, 3 - $LeftGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StartTab)
GUICtrlSetDefColor($MY_Color_Text,$StartTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($StartTab, 3)
_WinAPI_SetLayeredWindowAttributes($StartTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $StartTabHight - 25,$MY_Color_DarkGrey)
Local $x = 5
Local $y = 0
$y += 10
$x = 15
;~ Global $DistrictTabLable = MyGuiCtrlCreateButton("Districts",$x,$y,$LeftGuiWidth -2*$x, 18, $MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetOnEvent(-1, "StartTabEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")

Global $BagsTabLable = MyGuiCtrlCreateButton("Bags",$x,$y,$LeftGuiWidth -2*$x, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "StartTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
;~ Global $PlayerStatusTabLable = MyGuiCtrlCreateButton("Status",$x,$y,35, 18, $MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetOnEvent(-1, "StartTabEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
;~ $x += 40
;~ Global $PlayerStatusLable = GUICtrlCreateLabel("don't know",$x,$y,70,18,BitOR($SS_CENTER, $SS_CENTERIMAGE))
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x12345)
$y += 22
$y += 25
$y += 15
$x = 15
Global $useGhCheckbox = GUICtrlCreateCheckbox("", $x, $y+2, 15, 15)
;~ GUICtrlSetState($useGhCheckbox,$GUI_CHECKED)
GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x += 15
Global $useGhCheckboxLable = GUICtrlCreateLabel('use Guildhall',$x,$y+2,$LeftGuiWidth - $x - 10,18,$ss_center)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "StartTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
;~ GUICtrlSetOnEvent($RenderingBoxLable, "ToggleRendering") ; with _Initialize
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x = 10
$y += 18
GuiCtrlCreateRect($x, $y, $LeftGuiWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 2

$x = 15
Global $RenderingBox = GUICtrlCreateCheckbox("", $x, $y+2, 15, 15)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetOnEvent(-1, "StartTabEventHandler")
GUICtrlSetState($RenderingBox, $GUI_DISABLE) ; enable with _Initialize
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x += 15
Global $RenderingBoxLable = GUICtrlCreateLabel('disable render',$x,$y+2,$LeftGuiWidth - $x - 10,18,$ss_center)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister($RenderingBoxLable, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent($RenderingBoxLable, "StartTabEventHandler")
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x = 10
$y += 18
GuiCtrlCreateRect($x, $y, $LeftGuiWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 2
$x = 0
$y = $StartTabHight - 30
GuiCtrlCreateRect(0, $y-1, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
Global $StartButton = GUICtrlCreateLabel("Initialize", $x, $y , $LeftGuiWidth , 30,BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetBkColor(-1,$MY_Color_LightGrey)
;~ GUICtrlSetFont(-1, 12, 400, 0, "Segoe Marker")
GUICtrlSetFont(-1, 12, 800, 0, "Evanescent")
GUICtrlSetOnEvent(-1, "StartTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
;~ $Show_StartTab = True
#EndRegion StartTab

#Region LootTab
Global $LootTabHight = 150
Local $LootTab = _newTab("LootTab", $MainGUI, $LeftGuiWidth, $LootTabHight, 3 - $LeftGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$LootTab)
GUICtrlSetDefColor($MY_Color_Text,$LootTab)
_GuiRoundCorners($LootTab, 3)
GUISetFont(9, 400, 0, "Segoe Marker")
_WinAPI_SetLayeredWindowAttributes($LootTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $LootTabHight,$MY_Color_DarkGrey)
Local $x = 10
Local $y = 5

$x = 15
Global $LootGoldiesCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $LootGoldiesCheckboxLable = GUICtrlCreateLabel("all Goldies", $x, $y, 65, 17)
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +25
Global $GoldiesDropsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27-5, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
Local $x = 15
Global $LootGlacialStoneCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $LootGlacialStoneCheckboxLable = GUICtrlCreateLabel("Glacial Stone", $x, $y, 70, 17)
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +30
Global $LootGlacialStoneDropsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27-10, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1

Global $LootMapPiecesCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $LootMapPiecesCheckboxLable = GUICtrlCreateLabel("Map Pieces ", $x, $y, 65, 17)
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
$x = $LeftGuiWidth/2 +25
Global $MapPiecesDropsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27-5, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
Global $LootIronItemsCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $LootIronItemsCheckboxLable = GUICtrlCreateLabel("Iron Items", $x, $y, 65, 17)
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
$x = $LeftGuiWidth/2 +25
Global $LootIronItemsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27-5, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1

;~ Global $LootReq0ScytheCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
;~ GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
;~ Global $LootReq0ScytheCheckboxLable = GUICtrlCreateLabel("req 0 scythe", $x, $y, 70, 17)
;~ _GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
;~ GUICtrlSetOnEvent(-1, "LootTabEventHandler")
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ $x = $LeftGuiWidth/2 +30
;~ Global $LootReq0ScytheCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27-10, 17, $SS_RIGHT)
;~ GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1



;~ $y += 10
;~ Global $SellTabLable = MyGuiCtrlCreateButton("Sell",$x,$y,$LeftGuiWidth/2 -$x-1, 18, 0x333333, $MY_Color_LightGrey)
;~ GUICtrlSetOnEvent(-1, "LootTabEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
;~ $x = $LeftGuiWidth/2
;~ Global $ChestTabLable = MyGuiCtrlCreateButton("Chest",$x+2,$y,$LeftGuiWidth/2 -15-2, 18, 0x333333, $MY_Color_LightGrey)
;~ GUICtrlSetOnEvent(-1, "LootTabEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 4
$x =  15
Global $LootEventItemsTabLable = MyGuiCtrlCreateButton("Event",$x,$y,$LeftGuiWidth/2 -$x-1, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x = $LeftGuiWidth/2
Global $LootMatsTabLable  = MyGuiCtrlCreateButton("Mats",$x+2,$y,$LeftGuiWidth/2 -15-2, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 21
$x =  15
Global $LootTomesTabLable = MyGuiCtrlCreateButton("Tomes",$x,$y,$LeftGuiWidth/2 -$x-1, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x = $LeftGuiWidth/2
Global $LootDyeTabLable  = MyGuiCtrlCreateButton("Dye",$x+2,$y,$LeftGuiWidth/2 -15-2, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "LootTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
;~ hideLootTab()
#EndRegion LootTab

#Region StatsTab
Global $StatsTabHight = 150
Local $StatsTab = _newTab("StatsTab", $MainGUI, $LeftGuiWidth, $StatsTabHight, 3 - $LeftGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StatsTab)
GUICtrlSetDefColor($MY_Color_Text,$StatsTab)
_GuiRoundCorners($StatsTab, 3)
GUISetFont(9, 400, 0, "Segoe Marker")
_WinAPI_SetLayeredWindowAttributes($StatsTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $StatsTabHight, $MY_Color_DarkGrey)
Local $iTab = getTabNrByName("StatsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]
_GuiCtrlCreatePic($iStruct, $StatsTab, @ScriptDir & '\img\byMattes.png', 0, 0)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile(@ScriptDir & '\img\byMattes.png'),$i)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile(@ScriptDir & '\img\byMattes.png'),$i)
Local $x = 15
Local $y = 12
$y += 5
Global $TotTimeCount = GUICtrlCreateLabel("- h - min", $LeftGuiWidth - 67, $y, 55, 14, $SS_RIGHT)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
;~ GUICtrlSetColor(-1,0x999999)
$y += 17
GuiCtrlCreateRect($LeftGuiWidth/2, $y, $LeftGuiWidth/2 - 10, 1,$MY_Color_DarkGrey)
$y += 2
$x = 15
Global $RunsLabel = GUICtrlCreateLabel("Runs", $x, $y, 31, 17,$SS_LEFT)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +15
Global $SucessfulRunsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
Global $FailsLabel = GUICtrlCreateLabel("Fails", $x, $y, 36, 14)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +15
Global $FailsRunsCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
GUICtrlCreateLabel("Platin", $x, $y, 36, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
$x = $LeftGuiWidth/2 +15
Global $GoldCountLable = GUICtrlCreateLabel($GoldCount, $x, $y, $LeftGuiWidth/2 -27, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
GUICtrlCreateLabel("Bone", $x, $y, 55, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +15
Global $BoneCountLable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
GUICtrlCreateLabel("Skale Fins", $x, $y, 55, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x = $LeftGuiWidth/2 +15
Global $FinsDropsCountlable = GUICtrlCreateLabel("0", $x, $y, $LeftGuiWidth/2 -27, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x = 15
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
$y += 1
Global $AvgTimeLabel = GUICtrlCreateLabel("Ø", $x, $y, 15, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x =+ 30
Global $AvgTimeCount = GUICtrlCreateLabel("- min - sec", $x, $y, $LeftGuiWidth -$x - 12, 17, $SS_RIGHT)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x654321)
$x += 60
$x += 12
;~ Global $TotTimeCount = GUICtrlCreateLabel("- h - min", $x, $y+3, 55, 11, $SS_RIGHT)
;~ GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
;~ GUICtrlSetColor(-1,0x999999)
$y += 17
GuiCtrlCreateRect(10, $y, $LeftGuiWidth - 20, 1,$MY_Color_DarkGrey)
;~ $y += 5
#EndRegion StatsTab

#Region SalvageTab
Global $SalvageTabHight = 150
Local Const $SalvageTabWidth = $LeftGuiWidth + $RightGuiWidth
Local $SalvageTab = _newTab("SalvageTab", $MainGUI, $SalvageTabWidth, $SalvageTabHight, 3 - $LeftGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$SalvageTab)
GUICtrlSetDefColor($MY_Color_Text,$SalvageTab)
_GuiRoundCorners($SalvageTab, 3)
_WinAPI_SetLayeredWindowAttributes($SalvageTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
;~ GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $SalvageTabHight - 25, $MY_Color_DarkGrey)
Local $x = 0
Local $y = 10
Local $iTab = getTabNrByName("SalvageTab")
Local $iStruct = $TabArrayOfStructs[$iTab]
$x = 15

For $i = 1 To 8
	DllStructSetData($SalvageStruct, "CountLable",GUICtrlCreateLabel("0", $x, $y,39, 12, BitOR($SS_RIGHT,$SS_CENTERIMAGE)),$i)
	GUICtrlSetFont(-1,9, 400, 0, "Segoe Marker")
	_GuiCtrlCreatePic($iStruct, $SalvageTab, $SalvageArray[$i][1], $x,$y+5)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($SalvageArray[$i][1]),$i)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($SalvageArray[$i][2]),$i)
	GUICtrlSetOnEvent(-1,"toggleGDIPic")
	$x += 39
	If $i = 7 Then
		$y += 55
		$x = 15
	EndIf
Next

$x = 10
$y = $SalvageTabHight - 23
GUICtrlCreateLabel("Salvage", $x, $y, 43, 18)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x += 43
Global $SalvageCountLable = GUICtrlCreateLabel("0", $x, $y, 28, 18, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,$MY_Color_DarkGrey)
$x += 40
GUICtrlCreateLabel("Idents", $x, $y, 35, 18)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x123456)
$x += 35
Global $IdentCountLable = GUICtrlCreateLabel("0", $x, $y, 28, 18, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,$MY_Color_DarkGrey)
$x = 15
$y += 18
GuiCtrlCreateRect(10, $y, $LeftGuiWidth + 35 -$x, 1,$MY_Color_DarkGrey)
;~ $y += 4
$x = $LeftGuiWidth + 35
$y = $SalvageTabHight - 25
GuiCtrlCreateRect($x-1, $y, 1, 25,$MY_Color_DarkGrey)
GuiCtrlCreateRect($x, $y-1, $RightGuiWidth, 1,$MY_Color_DarkGrey)
Global $StartSalvageButton = GUICtrlCreateLabel("start salvage", $x, $y , $RightGuiWidth - 35, 25,BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetBkColor(-1,$MY_Color_LightGrey)
GUICtrlSetFont(-1, 12, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "SalvageTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
#EndRegion SalvageTab

#Region DistrictTab
Local $DistrictCheckboxes[12]
Local $DistrictCheckboxLables[12]
local Const $DistrictTabHight = 150
Local Const $DistrictTabWidth = $RightGuiWidth
Local $DistrictTab = _newTab("DistrictTab", $MainGUI, $DistrictTabWidth, $DistrictTabHight, 3 + $RightGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$DistrictTab)
GUICtrlSetDefColor($MY_Color_Text,$DistrictTab)
_GuiRoundCorners($DistrictTab, 3)
_WinAPI_SetLayeredWindowAttributes($DistrictTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $DistrictTabWidth, 1,$MY_Color_DarkGrey)
Local $x = 15
Local $y = 10
Local $LableWidth = 70
$DistrictCheckboxes[0] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[0] = GUICtrlCreateLabel("International", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x += $LableWidth
$DistrictCheckboxes[1] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[1]  = GUICtrlCreateLabel("America", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 14
GuiCtrlCreateRect(10, $y, $RightGuiWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 6
Global $DistrictTabEuropAllButton = MyGuiCtrlCreateButton("Europe - all", $x, $y, $LableWidth -15, 16,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
Global $DistrictTabEuropClearButton = MyGuiCtrlCreateButton("Ø", $x+ $LableWidth -10 , $y, 15 , 16,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x += $LableWidth + 15
$y += 2
$DistrictCheckboxes[2] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[2] = GUICtrlCreateLabel("English", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
$DistrictCheckboxes[3] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[3] = GUICtrlCreateLabel("French", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x += $LableWidth
$DistrictCheckboxes[4] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[4] = GUICtrlCreateLabel("German", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
$DistrictCheckboxes[5] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[5] = GUICtrlCreateLabel("Italian", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x += $LableWidth
$DistrictCheckboxes[6] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[6] = GUICtrlCreateLabel("Spanish", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
$DistrictCheckboxes[7] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[7] = GUICtrlCreateLabel("Polish", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x += $LableWidth
$DistrictCheckboxes[8] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[8] = GUICtrlCreateLabel("Russian", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
GuiCtrlCreateRect(10, $y, $RightGuiWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 6
Global $DistrictTabAsiaAllButton = MyGuiCtrlCreateButton("Asia - all", $x, $y, $LableWidth -15, 16,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
Global $DistrictTabAsiaClearButton = MyGuiCtrlCreateButton("Ø", $x+ $LableWidth -10 , $y, 15 , 16,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x += $LableWidth + 15
$y += 2
$DistrictCheckboxes[9] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[9] = GUICtrlCreateLabel("Korean", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
$DistrictCheckboxes[10] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[10] = GUICtrlCreateLabel("Trad Chinese", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x += $LableWidth
$DistrictCheckboxes[11] = GUICtrlCreateCheckbox("", $x, $y, 13, 13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
$DistrictCheckboxLables[11] = GUICtrlCreateLabel("Japanese", $x, $y, $LableWidth, 16, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1, "DistrictTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 16
GuiCtrlCreateRect(10, $y, $RightGuiWidth - 2*$x, 1,$MY_Color_DarkGrey)
#EndRegion DistrictTab

#Region PlayerStatusTab
local Const $PlayerStatusTabHight = 150
Local Const $PlayerStatusTabWidth = $RightGuiWidth
Local $PlayerStatusTab = _newTab("PlayerStatusTab", $MainGUI, $PlayerStatusTabWidth, $PlayerStatusTabHight, 3 + $RightGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$PlayerStatusTab)
GUICtrlSetDefColor($MY_Color_Text,$PlayerStatusTab)
_GuiRoundCorners($PlayerStatusTab, 3)
_WinAPI_SetLayeredWindowAttributes($PlayerStatusTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $PlayerStatusTabWidth, 1,$MY_Color_DarkGrey)
Local $x = 15
Local $y = 10
Global $PlayerStatusOfflineButton = MyGuiCtrlCreateButton("Offline", $x, $y, $PlayerStatusTabWidth -2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1,"PlayerStatusTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 23
Global $PlayerStatusOnlineButton = MyGuiCtrlCreateButton("Online", $x, $y, $PlayerStatusTabWidth -2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1,"PlayerStatusTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 23
Global $PlayerStatusDoNotDisturbButton = MyGuiCtrlCreateButton("Do not disturb", $x, $y, $PlayerStatusTabWidth -2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1,"PlayerStatusTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 23
Global $PlayerStatusAwayButton = MyGuiCtrlCreateButton("Away", $x, $y, $PlayerStatusTabWidth -2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1,"PlayerStatusTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 24
GUICtrlCreateLabel("Node: Status effects directly but will displayes on your client only after a mapchange!",$x,$y,$PlayerStatusTabWidth -2*$x, 45)
GUICtrlSetFont(-1, 8, 400, 0, "Segoe Marker")
#EndRegion PlayerStatusTab

#Region LootTomesTab
local Const $LootTomesTabHight = 225
Local Const $LootTomesTabWidth = 225
Local $LootTomesTab = _newTab("LootTomesTab", $MainGUI, $LootTomesTabWidth, $LootTomesTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$LootTomesTab)
GUICtrlSetDefColor($MY_Color_Text,$LootTomesTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($LootTomesTab, 3)
_WinAPI_SetLayeredWindowAttributes($LootTomesTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LootTomesTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("LootTomesTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
;~ GUICtrlCreateLabel("",$x,$y,23,15)
;~ GUICtrlSetBkColor(-1,0xCC0000)
_GuiCtrlCreatePic($iStruct, $LootTomesTab, $IconPngPath, $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
GUISwitch($LootTomesTab)
GUICtrlCreateLabel('Loot Tomes', 0, 0, $LootTomesTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_LootTomes = GuiCtrlCreateLabel("X", $LootTomesTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'LootTomesTabEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($LootTomesTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $LootTomesTabWidth, 1,$MY_Color_DarkGrey)
$y += 10

$x = 15
Local $LableWidth = 55
Local $ButtonWidth = 75
Local $CountLblWidth = 23
Local $LootTomesAllNormal = MyGuiCtrlCreateButton("All normal", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootTomesTabEventHandler')
Local $LootTomesClearAllNormal = MyGuiCtrlCreateButton("Ø",$x + $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootTomesTabEventHandler')
$x = 15
$y += 18
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Assassin", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Dervish", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Elementalist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mesmer", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Monk", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Necro", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Paragon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ranger", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ritualist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = 15
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Warrior", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

$y = 35
$OffsetX = 120
;~ GuiCtrlCreateRect($OffsetX -5  , $y, 1, $LootTomesTabHight -2*$y ,$MY_Color_DarkGrey)
$x = $OffsetX
Local $LootTomesAllElite = MyGuiCtrlCreateButton("All elite", $x, $y, $ButtonWidth , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootTomesTabEventHandler')
Local $LootTomesClearAllElite = MyGuiCtrlCreateButton("Ø", $x + $ButtonWidth +5, $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootTomesTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Assassin", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Dervish", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),13)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Elementalist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),13)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),14)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mesmer", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),14)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),15)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Monk", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),15)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),16)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Necro", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),16)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),17)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Paragon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),17)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),18)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ranger", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),18)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),19)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ritualist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),19)
$x = $OffsetX
$y += 16
DllStructSetData($LootTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),20)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Warrior", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),20)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)

For $i = 1 To 20
	GUICtrlSetOnEvent(DllStructGetData($LootTomesStruct,"Checkbox",$i),"saveToIni")
Next

#EndRegion LootTomesTab

#Region LootEventItemsTab
local Const $LootEventItemsTabHight = 320
Local Const $LootEventItemsTabWidth = 320
Local $LootEventItemsTab = _newTab("LootEventItemsTab", $MainGUI, $LootEventItemsTabWidth, $LootEventItemsTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$LootEventItemsTab)
GUICtrlSetDefColor($MY_Color_Text,$LootEventItemsTab)
_GuiRoundCorners($LootEventItemsTab, 3)
_WinAPI_SetLayeredWindowAttributes($LootEventItemsTab, 0xCC0000, $myTransparenty)
GUISetFont( 9, 400, 0, "Segoe Marker")
;~ GuiCtrlCreateRect(0, 0, $LootEventItemsTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("LootEventItemsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
;~ GUICtrlCreateLabel("",$x,$y,23,15)
;~ GUICtrlSetBkColor(-1,0xCC0000)
_GuiCtrlCreatePic($iStruct, $LootEventItemsTab, $IconPngPath, $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
;~ $x += 25
GUISwitch($LootEventItemsTab)
GUICtrlCreateLabel('Loot Event Items', 0, 0, $LootEventItemsTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_LootEventItems = GuiCtrlCreateLabel("X", $LootEventItemsTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($LootEventItemsTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $LootEventItemsTabWidth, 1,$MY_Color_DarkGrey)
$y += 10
$x = 15
Local $LableWidth = 95
Local $ButtonWidth = 115
Local $CountLblWidth = 28
Local $LootEventItemsAllSweets = MyGuiCtrlCreateButton("All Sweets", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
Local $LootEventItemsClearAllSweets = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
$x = 15
$y += 18
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Birthday Cupcake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
;~ GUICtrlSetBkColor(-1,0x12357)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Chocolate Bunny", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Delicious Cake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Fruitcake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Golden Egg", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Slice of Pumpkin Pie", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Sugary Blue Drink", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

Global $LootEventItemsAllAlc = MyGuiCtrlCreateButton("All Alcohol", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
Local $LootEventItemsClearAllAlc = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
$x = 15
$y += 18
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Battle Isle Iced Tea", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Bottle of Grog", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Eggnog", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Hard Apple Cider", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Hunter's Ale", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),13)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Krytan Brandy", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),13)
$x = 15
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),14)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Shamrock Ale", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),14)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 6

Local $OffsetX = 170
$x = $OffsetX
$y = 35
Global $LootEventItemsAllParty = MyGuiCtrlCreateButton("All Party", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
Local $LootEventItemsClearAllParty = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),15)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Bottle Rocket", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),15)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),16)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Candy Cane Shard", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),16)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Champagne Popper", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),17)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),18)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Frosty Tonic", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),18)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mischievous Tonic", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),19)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),20)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Party Beacon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),20)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),21)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Snowman Summoner", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),21)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),22)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Sparkler", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),22)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

Global $LootEventItemsAllOtherEvent = MyGuiCtrlCreateButton("All other Eventdrops", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
Local $LootEventItemsClearAllOtherEvent = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootEventItemsTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),23)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Four-Leave Clover", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),23)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),24)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Honeycomb", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),24)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),25)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Lunar Token", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),25)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),26)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Trick-or-Treat Bag", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),26)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),27)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Victory Token", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),27)
$x = $OffsetX
$y += 16
DllStructSetData($LootEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),28)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Wayfarer's Mark", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),28)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 6

For $i = 1 To 28
	GUICtrlSetOnEvent(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),"saveToIni")
Next
#EndRegion LootEventItemsTab

#Region LootDyeTab
local Const $LootDyeTabHight = 160
Local Const $LootDyeTabWidth = $RightGuiWidth + 20
Local $LootDyeTab = _newTab("LootDyeTab", $MainGUI, $LootDyeTabWidth, $LootDyeTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$LootDyeTab)
GUICtrlSetDefColor($MY_Color_Text,$LootDyeTab)
_GuiRoundCorners($LootDyeTab, 3)
GUISetFont(9, 400, 0, "Segoe Marker")
_WinAPI_SetLayeredWindowAttributes($LootDyeTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $LootDyeTabWidth, 1,$MY_Color_DarkGrey)
Local $iTab = getTabNrByName("LootDyeTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
;~ GUICtrlCreateLabel("",$x,$y,23,15)
;~ GUICtrlSetBkColor(-1,0xCC0000)
_GuiCtrlCreatePic($iStruct, $LootDyeTab, $IconPngPath, $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
GUISwitch($LootDyeTab)
GUICtrlCreateLabel('Loot Dye', 0, 0, $LootDyeTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_LootDys = GuiCtrlCreateLabel("X", $LootDyeTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, 'LootDyeTabEventHandler')
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($LootDyeTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $LootDyeTabWidth, 1,$MY_Color_DarkGrey)
$y += 10

$x = 15
Local $LableWidth = 35
Local $ButtonWidth = 130
Local $CountLblWidth = 20
Local $LootAllDye = MyGuiCtrlCreateButton("All Dye", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootDyeTabEventHandler')
Local $LootClearAllDye = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5, $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'LootDyeTabEventHandler')
$x = 15
$y += 18
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Black", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
$x = 15
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Blue", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Green", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Purple", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Red", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Yellow", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth + 30, 1,$MY_Color_DarkGrey)
$y += 10
$x += $LableWidth + 15
$y = 35
$OffsetX = 105
$x = $OffsetX
$y += 18
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("White", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = $OffsetX
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Brown", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = $OffsetX
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Orange", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = $OffsetX
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Silver", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = $OffsetX
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Pink", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = $OffsetX
$y += 16
DllStructSetData($LootDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Grey", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($LootDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)

For $i = 1 To 12
	GUICtrlSetOnEvent(DllStructGetData($LootDyeStruct,"Checkbox",$i),"saveToIni")
Next
#EndRegion LootDyeTab

#Region LootMatstTab
local Const $LootMatsTabHight = 320
Local Const $LootMatsTabWidth = 332
Local $LootMatsTab = _newTab("LootMatsTab", $MainGUI, $LootMatsTabWidth, $LootMatsTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$LootMatsTab)
GUICtrlSetDefColor($MY_Color_Text,$LootMatsTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($LootMatsTab, 3)
_WinAPI_SetLayeredWindowAttributes($LootMatsTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $StoreTomesTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("LootMatsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0

;~ _GuiCtrlCreatePic($iStruct, $LootMatsTab, $IconPngPath, $x,$y)
GUICtrlCreateLabel('Loot Mats', 0, 0, $LootMatsTabWidth -25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_LootMats = GuiCtrlCreateLabel("X", $LootMatsTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'LootMatsTabEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($LootMatsTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $LootMatsTabWidth, 1,$MY_Color_DarkGrey)

$y += 8
$x = 10


_GuiCtrlCreatePic($iStruct, $LootMatsTab, $MatsArray[1][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[1][1]),1)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[1][2]),1)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $LootMatsTab, $MatsArray[4][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[4][1]),4)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[4][2]),4)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $LootMatsTab, $MatsArray[3][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[3][1]),3)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[3][2]),3)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $LootMatsTab,$MatsArray[2][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[2][1]),2)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[2][2]),2)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $LootMatsTab, $MatsArray[5][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[5][1]),5)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[5][2]),5)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $LootMatsTab, $MatsArray[6][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[6][1]),6)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[6][2]),6)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x = 10
$y += 64

For $i = 7 To 12
	_GuiCtrlCreatePic($iStruct, $LootMatsTab,$MatsArray[$i][1], $x,$y)
	GUICtrlSetOnEvent(-1,"toggleGDIPic")
	$x += 52
Next
$x = 10
$y += 64

For $i = 13 To 36
	_GuiCtrlCreatePic($iStruct, $LootMatsTab,$MatsArray[$i][1], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 39
If $i = 20 Or $i = 28 Then
	$y += 48
	$x = 10
EndIf
Next

;~ ConsoleWrite(@CRLF & "GDIPlusCount: " & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") & @CRLF )
For $i = 7 To 36 ;DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount")
	ConsoleWrite(@CRLF & $i & @tab & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") )
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[$i][1]),$i)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[$i][2]),$i)
Next

#EndRegion LootMatsTab

#Region SellTab
Local Const $SellTabHight = 150
Local Const $SellTabWidth = $LeftGuiWidth
Local $SellTab = _newTab("SellTab", $MainGUI, $SellTabWidth, $SellTabHight, 3 - $LeftGuiWidth, 3 + $TableisteHight + $MainHeight, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text)
GUISetFont(9, 400, 0, "Segoe Marker")
_WinAPI_SetLayeredWindowAttributes($SellTab, 0xCC0000, $myTransparenty)
_GuiRoundCorners($SellTab, 3)
GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $SellTabHight,$MY_Color_DarkGrey)
Local $y = 10
Local $x = 15
Global $sellSpiritwoodCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $sellSpiritwoodCheckboxLable = GUICtrlCreateLabel("Spiritwood", $x, $y, 70, 17)
GUICtrlSetOnEvent(-1, "SellTabEventHandler")
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 17
GuiCtrlCreateRect($x, $y, $SellTabWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 1
Global $sellGoldiesCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $sellGoldiesCheckboxLable = GUICtrlCreateLabel("Goldies", $x, $y, 70, 17)
GUICtrlSetOnEvent(-1, "SellTabEventHandler")
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 17
GuiCtrlCreateRect($x, $y, $SellTabWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 1
Global $sellbluereq0scytheCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $sellbluereq0scytheCheckboxLable = GUICtrlCreateLabel("req 0 scythe", $x, $y, 70, 17)
GUICtrlSetOnEvent(-1, "SellTabEventHandler")
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
$x = 15
$y += 17
GuiCtrlCreateRect($x, $y, $SellTabWidth - 2*$x, 1,$MY_Color_DarkGrey)
$y += 1

$y = $SellTabHight - 25
GuiCtrlCreateRect(0, $y-1, $SellTabWidth, 1,$MY_Color_DarkGrey)
Local $SellNowButton = GUICtrlCreateLabel("sell", 0, $y , $SellTabWidth , 25,BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetBkColor(-1,$MY_Color_LightGrey)
GUICtrlSetFont(-1, 13, 800, 0, "Evanescent")
GUICtrlSetOnEvent(-1, "SellTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
#EndRegion SellTab

#Region StoreTomesTab
local Const $StoreTomesTabHight = 225
Local Const $StoreTomesTabWidth = 225
Local $StoreTomesTab = _newTab("StoreTomesTab", $MainGUI, $StoreTomesTabWidth, $StoreTomesTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StoreTomesTab)
GUICtrlSetDefColor($MY_Color_Text,$StoreTomesTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($StoreTomesTab, 3)
_WinAPI_SetLayeredWindowAttributes($StoreTomesTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $StoreTomesTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("StoreTomesTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
_GuiCtrlCreatePic($iStruct, $StoreTomesTab, $IconPngPath, $x,$y)
GUICtrlCreateLabel('Store Tomes', 0, 0, $StoreTomesTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_StoreTomes = GuiCtrlCreateLabel("X", $StoreTomesTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'StoreTomesTabEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($StoreTomesTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $StoreTomesTabWidth, 1,$MY_Color_DarkGrey)
$y += 10

$x = 15
Local $LableWidth = 55
Local $ButtonWidth = 75
Local $CountLblWidth = 23
Local $StoreTomesAllNormal = MyGuiCtrlCreateButton("All normal", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreTomesTabEventHandler')
Local $StoreTomesClearAllNormal = MyGuiCtrlCreateButton("Ø",$x + $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreTomesTabEventHandler')
$x = 15
$y += 18
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Assassin", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Dervish", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Elementalist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mesmer", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Monk", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Necro", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Paragon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ranger", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ritualist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = 15
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Warrior", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

$y = 35
$OffsetX = 120
;~ GuiCtrlCreateRect($OffsetX -5  , $y, 1, $StoreTomesTabHight -2*$y ,$MY_Color_DarkGrey)
$x = $OffsetX
Local $StoreTomesAllElite = MyGuiCtrlCreateButton("All elite", $x, $y, $ButtonWidth , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreTomesTabEventHandler')
Local $StoreTomesClearAllElite = MyGuiCtrlCreateButton("Ø", $x + $ButtonWidth +5, $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreTomesTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Assassin", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Dervish", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),13)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Elementalist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),13)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),14)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mesmer", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),14)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),15)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Monk", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),15)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),16)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Necro", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),16)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),17)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Paragon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),17)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),18)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ranger", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),18)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),19)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Ritualist", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),19)
$x = $OffsetX
$y += 16
DllStructSetData($StoreTomesStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),20)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Warrior", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreTomesStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),20)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)

For $i = 1 To 20
	GUICtrlSetOnEvent(DllStructGetData($StoreTomesStruct,"Checkbox",$i),"saveToIni")
Next

#EndRegion StoreTomesTab

#Region StoreEventItemsTab
local Const $StoreEventItemsTabHight = 320
Local Const $StoreEventItemsTabWidth = 320
Local $StoreEventItemsTab = _newTab("StoreEventItemsTab", $MainGUI, $StoreEventItemsTabWidth, $StoreEventItemsTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StoreEventItemsTab)
GUICtrlSetDefColor($MY_Color_Text,$StoreEventItemsTab)
_GuiRoundCorners($StoreEventItemsTab, 3)
_WinAPI_SetLayeredWindowAttributes($StoreEventItemsTab, 0xCC0000, $myTransparenty)
GUISetFont( 9, 400, 0, "Segoe Marker")
;~ GuiCtrlCreateRect(0, 0, $StoreEventItemsTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("StoreEventItemsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
_GuiCtrlCreatePic($iStruct, $StoreEventItemsTab, $IconPngPath, $x,$y)
GUICtrlCreateLabel('Store Event Items', 0, 0, $StoreEventItemsTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_StoreEventItems = GuiCtrlCreateLabel("X", $StoreEventItemsTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($StoreEventItemsTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $StoreEventItemsTabWidth, 1,$MY_Color_DarkGrey)
$y += 10
$x = 15
Local $LableWidth = 95
Local $ButtonWidth = 115
Local $CountLblWidth = 28
Local $StoreEventItemsAllSweets = MyGuiCtrlCreateButton("All Sweets", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
Local $StoreEventItemsClearAllSweets = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
$x = 15
$y += 18
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Birthday Cupcake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
;~ GUICtrlSetBkColor(-1,0x12357)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Chocolate Bunny", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Delicious Cake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Fruitcake", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Golden Egg", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Slice of Pumpkin Pie", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Sugary Blue Drink", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

Global $StoreEventItemsAllAlc = MyGuiCtrlCreateButton("All Alcohol", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
Local $StoreEventItemsClearAllAlc = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
$x = 15
$y += 18
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Battle Isle Iced Tea", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Bottle of Grog", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Eggnog", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Hard Apple Cider", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Hunter's Ale", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),13)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Krytan Brandy", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),13)
$x = 15
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),14)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Shamrock Ale", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),14)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 6

Local $OffsetX = 170
$x = $OffsetX
$y = 35
Global $StoreEventItemsAllParty = MyGuiCtrlCreateButton("All Party", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
Local $StoreEventItemsClearAllParty = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),15)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Bottle Rocket", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),15)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),16)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Candy Cane Shard", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),16)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Champagne Popper", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),17)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),18)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Frosty Tonic", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),18)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),19)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Mischievous Tonic", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),19)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),20)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Party Beacon", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),20)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),21)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Snowman Summoner", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),21)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),22)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Sparkler", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),22)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 10

Global $StoreEventItemsAllOtherEvent = MyGuiCtrlCreateButton("All other Eventdrops", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
Local $StoreEventItemsClearAllOtherEvent = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5 , $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreEventItemsTabEventHandler')
$x = $OffsetX
$y += 18
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),23)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Four-Leave Clover", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),23)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),24)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Honeycomb", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),24)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),25)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Lunar Token", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),25)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),26)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Trick-or-Treat Bag", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),26)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),27)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Victory Token", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),27)
$x = $OffsetX
$y += 16
DllStructSetData($StoreEventItemsStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),28)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Wayfarer's Mark", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreEventItemsStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),28)
$x = $OffsetX
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth, 1,$MY_Color_DarkGrey)
$y += 6

For $i = 1 To 28
	GUICtrlSetOnEvent(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),"saveToIni")
Next
#EndRegion StoreEventItemsTab

#Region StoreDyeTab
local Const $StoreDyeTabHight = 160
Local Const $StoreDyeTabWidth = $RightGuiWidth + 20
Local $StoreDyeTab = _newTab("StoreDyeTab", $MainGUI, $StoreDyeTabWidth, $StoreDyeTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StoreDyeTab)
GUICtrlSetDefColor($MY_Color_Text,$StoreDyeTab)
_GuiRoundCorners($StoreDyeTab, 3)
GUISetFont(9, 400, 0, "Segoe Marker")
_WinAPI_SetLayeredWindowAttributes($StoreDyeTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $StoreDyeTabWidth, 1,$MY_Color_DarkGrey)
Local $iTab = getTabNrByName("StoreDyeTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
Local $FiberIconPath = @ScriptDir & "\img\FiberIcon.png"
;~ GUICtrlCreateLabel("",$x,$y,23,15)
;~ GUICtrlSetBkColor(-1,0xCC0000)
_GuiCtrlCreatePic($iStruct, $StoreDyeTab, $IconPngPath, $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
GUICtrlCreateLabel('Store Dye', 0, 0, $StoreDyeTabWidth - 25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_StoreDys = GuiCtrlCreateLabel("X", $StoreDyeTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, 'StoreDyeTabEventHandler')
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($StoreDyeTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $StoreDyeTabWidth, 1,$MY_Color_DarkGrey)
$y += 10

$x = 15
Local $LableWidth = 35
Local $ButtonWidth = 130
Local $CountLblWidth = 20
Local $StoreAllDye = MyGuiCtrlCreateButton("All Dye", $x, $y, $ButtonWidth, 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreDyeTabEventHandler')
Local $StoreClearAllDye = MyGuiCtrlCreateButton("Ø", $x+ $ButtonWidth + 5, $y, 15 , 15,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'StoreDyeTabEventHandler')
$x = 15
$y += 18
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),1)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("Black", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),1)
$x = 15
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),2)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Blue", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),2)
$x = 15
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),3)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Green", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),3)
$x = 15
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),4)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Purple", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),4)
$x = 15
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),5)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Red", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),5)
$x = 15
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),6)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Yellow", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),6)
$x = 15
$y += 16
GuiCtrlCreateRect($x, $y, $ButtonWidth + 30, 1,$MY_Color_DarkGrey)
$y += 10
$x += $LableWidth + 15
$y = 35
$OffsetX = 105
$x = $OffsetX
$y += 18
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),7)
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGrogCheckLable = GUICtrlCreateLabel("White", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),7)
$x = $OffsetX
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),8)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemGoldenEggCheckLable = GUICtrlCreateLabel("Brown", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),8)
$x = $OffsetX
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),9)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemChocolateBunnyCheckLable = GUICtrlCreateLabel("Orange", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),9)
$x = $OffsetX
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),10)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Silver", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),10)
$x = $OffsetX
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),11)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Pink", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),11)
$x = $OffsetX
$y += 16
DllStructSetData($StoreDyeStruct,"Checkbox",GUICtrlCreateCheckbox("", $x, $y, 13, 13),12)
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 15
Global $EventItemCheckLable = GUICtrlCreateLabel("Grey", $x, $y, $LableWidth, 15, BitOR($SS_LEFT,0))
$x += $LableWidth
DllStructSetData($StoreDyeStruct,"CountLable",GUICtrlCreateLabel("", $x, $y, $CountLblWidth, 15,$SS_RIGHT),12)

For $i = 1 To 12
	GUICtrlSetOnEvent(DllStructGetData($StoreDyeStruct,"Checkbox",$i),"saveToIni")
Next
#EndRegion StoreDyeTab

#Region StoreMatsTab
local Const $StoreMatsTabHight = 320
Local Const $StoreMatsTabWidth = 332
Local $StoreMatsTab = _newTab("StoreMatsTab", $MainGUI, $StoreMatsTabWidth, $StoreMatsTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$StoreMatsTab)
GUICtrlSetDefColor($MY_Color_Text,$StoreMatsTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($StoreMatsTab, 3)
_WinAPI_SetLayeredWindowAttributes($StoreMatsTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $StoreTomesTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("StoreMatsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
;~ _GuiCtrlCreatePic($iStruct, $StoreMatsTab, $IconPngPath, $x,$y)
GUICtrlCreateLabel('Store Mats', 0, 0, $StoreMatsTabWidth -25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_StoreMats = GuiCtrlCreateLabel("X", $StoreMatsTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'StoreMatsTabEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($StoreMatsTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $StoreMatsTabWidth, 1,$MY_Color_DarkGrey)

$y += 8
$x = 10


_GuiCtrlCreatePic($iStruct, $StoreMatsTab, $MatsArray[1][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[1][1]),1)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[1][2]),1)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $StoreMatsTab, $MatsArray[4][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[4][1]),4)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[4][2]),4)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $StoreMatsTab, $MatsArray[3][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[3][1]),3)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[3][2]),3)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $StoreMatsTab,$MatsArray[2][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[2][1]),2)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[2][2]),2)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $StoreMatsTab, $MatsArray[5][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[5][1]),5)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[5][2]),5)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 52
_GuiCtrlCreatePic($iStruct, $StoreMatsTab, $MatsArray[6][1], $x,$y)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[6][1]),6)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[6][2]),6)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x = 10
$y += 64

For $i = 7 To 12
	_GuiCtrlCreatePic($iStruct, $StoreMatsTab,$MatsArray[$i][1], $x,$y)
	GUICtrlSetOnEvent(-1,"toggleGDIPic")
	$x += 52
Next
$x = 10
$y += 64

For $i = 13 To 36
	_GuiCtrlCreatePic($iStruct, $StoreMatsTab,$MatsArray[$i][1], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 39
If $i = 20 Or $i = 28 Then
	$y += 48
	$x = 10
EndIf
Next

;~ ConsoleWrite(@CRLF & "GDIPlusCount: " & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") & @CRLF )
For $i = 7 To 36 ;DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount")
	ConsoleWrite(@CRLF & $i & @tab & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") )
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($MatsArray[$i][1]),$i)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($MatsArray[$i][2]),$i)
Next

#EndRegion StoreMatsTab

#Region InventoryTab
Local Const $InventorytabHight = 150
Local Const $InventorytabWidth = $LeftGuiWidth
Local $InventorytabHWND = _newTab("InventoryTab", $MainGUI, $InventorytabWidth, $InventorytabHight, 3 - $LeftGuiWidth, $TableisteHight + $MainHeight + 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text)
_WinAPI_SetLayeredWindowAttributes($InventorytabHWND, 0xCC0000, $myTransparenty)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($InventorytabHWND, 3)
GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $InventorytabHight,$MY_Color_DarkGrey)
Local $x = 5
Local $y = 5
;~ Local $iTab = getTabNrByName("InventoryTab")
;~ Local $iStruct = $TabArrayOfStructs[$iTab]
;~ _GuiCtrlCreatePic($iStruct, $InventorytabHWND, $BagPath[1], $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
;~ $x += 30
;~ _GuiCtrlCreatePic($iStruct, $InventorytabHWND,$BagPath[2],$x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
;~ $x += 30
;~ _GuiCtrlCreatePic($iStruct, $InventorytabHWND,$BagPath[3],$x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
;~ $x += 30
;~ _GuiCtrlCreatePic($iStruct, $InventorytabHWND,$BagPath[4],$x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
;~ $x += 30
;~ ConsoleWrite(@CRLF & "GDIPlusCount: " & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") & @CRLF )
;~ For $i = 1 To DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount")
;~ 	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($BagPath[$i]),$i)
;~ 	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($BagTickedPath[$i]),$i)
;~ 	$BagTickedPic[$i] = _GDIPlus_ImageLoadFromFile($BagTickedPath[$i])
;~ Next
$y += 35
GUISwitch($InventorytabHWND)
$x = 10
$InventoryIdentNowButton = MyGuiCtrlCreateButton("ident now", $x, $y, $InventorytabWidth - 2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'InventoryTabEventHandler')
$y += 20
$InventoryDropStuffButton = MyGuiCtrlCreateButton("drop Bags", $x, $y, $InventorytabWidth - 2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'InventoryTabEventHandler')
$y += 20
$InventoryPickupLootButton = MyGuiCtrlCreateButton("pickup stuff", $x, $y, $InventorytabWidth - 2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'InventoryTabEventHandler')
$y += 20
$InventoryGoChestButton = MyGuiCtrlCreateButton("go to Chest", $x, $y, $InventorytabWidth - 2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'InventoryTabEventHandler')
$y += 20
$InventoryGoMerchantButton = MyGuiCtrlCreateButton("go to Merchant", $x, $y, $InventorytabWidth - 2*$x, 19,$MY_Color_DarkGrey, $MY_Color_LightGrey)
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
GUICtrlSetOnEvent(-1, 'InventoryTabEventHandler')

#EndRegion InventoryTab

#Region ChestTab
Local Const $ChestTabHight = 150
Local Const $ChestTabWidth = $LeftGuiWidth + $RightGuiWidth
Local $ChestTab = _newTab("ChestTab", $MainGUI, $ChestTabWidth, $ChestTabHight, 3 - $LeftGuiWidth, $TableisteHight + $MainHeight + 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text)
_WinAPI_SetLayeredWindowAttributes($ChestTab, 0xCC0000, $myTransparenty)
_GuiRoundCorners($ChestTab, 3)
GUISetFont( 9, 400, 0, "Segoe Marker")
;~ GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $SellTabHight,$MY_Color_DarkGrey)

Local $x = 5
Local $y = 4
Local $iTab = getTabNrByName("ChestTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $ChestMoveEnablePath = @ScriptDir & '\img\EnableMove.png'
Local $ChestMoveDisablePath = @ScriptDir & '\img\DisableMove.png'
_GuiCtrlCreatePic($iStruct, $ChestTab, $ChestMoveEnablePath, $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($ChestMoveDisablePath),1)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($ChestMoveEnablePath),1)

$x = $LeftGuiWidth + 20
$y += 7
GUICtrlCreateLabel("max move" , $x,$y,90,20,$SS_RIGHT)
GUICtrlSetFont(-1, 13, 800, 0, "Segoe Marker")
$x += 95
Global $ChestmaxMoveInput = GUICtrlCreateInput("3",$x,$y,50,22,$SS_RIGHT,0)
GUICtrlSetFont(-1,14, 400, 0, "Segoe Marker")
GUICtrlSetBkColor(-1,$MY_Color_DarkGrey)
GUICtrlCreateUpdown (-1 ) ; $UDS_SETBUDDYINT

$y += 25
;~ GuiCtrlCreateRect(0, $y, $ChestTabWidth, 1,$MY_Color_DarkGrey)
$y += 5
;~ GUISwitch($ChestTab)


$x = 15
$y += 4
;~ Global $ChestSkaleFinCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
;~ GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
;~ Global $ChestSkaleFinCheckboxLable = GUICtrlCreateLabel("Skale Fins", $x, $y, 70, 17)
;~ _GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
;~ GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
$x = 15
$y += 17
;~ GuiCtrlCreateRect($x, $y, 80, 1,$MY_Color_DarkGrey)
$y += 1
Global $ChestMapPiecesCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $ChestMapPiecesCheckboxLable = GUICtrlCreateLabel("Map Pieces", $x, $y, 70, 17)
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
$x = 15
$y += 17
GuiCtrlCreateRect($x, $y, 80, 1,$MY_Color_DarkGrey)
$y += 1
;~ Global $ChestSkaleClawCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
;~ GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
;~ Global $ChestSkaleClawCheckboxLable = GUICtrlCreateLabel("Skale Claw", $x, $y, 70, 17)
;~ _GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
;~ GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
$x = 15
$y += 17
;~ GuiCtrlCreateRect($x, $y, 80, 1,$MY_Color_DarkGrey)
$y += 1
Global $ChestLockpicksCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 14
Global $ChestLockpicksCheckboxLable = GUICtrlCreateLabel("Lockpicks", $x, $y, 70, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")

$y += 17
GuiCtrlCreateRect($x, $y, 75, 1,$MY_Color_DarkGrey)

$OffsetX = $LeftGuiWidth
$y = 71
$x = $OffsetX

Local $ChestMoveGoldPath = @ScriptDir & '\img\Large_Bag_of_Gold_x40.png'
Local $ChestMoveGoldTickedPath = @ScriptDir & '\img\Large_Bag_of_Gold_x40T.png'
_GuiCtrlCreatePic($iStruct, $ChestTab, $ChestMoveGoldTickedPath, $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($ChestMoveGoldPath),2)
DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($ChestMoveGoldTickedPath),2)
$y += 26
$x += -15
Global $ChestMovePlatinInput = GUICtrlCreateInput("1.337",$x,$y,55,20,$SS_RIGHT,0)
GUICtrlSetFont(-1,10, 400, 0, "Segoe Marker")
GUICtrlSetBkColor(-1,$MY_Color_DarkGrey)

$OffsetX = $LeftGuiWidth + 55
$x = $OffsetX -15
$y = 10
;~ $y += 20

;~ Local $SalvagePath = @ScriptDir & '\img\Perfect_Salvage_Kit_black_x19.png'
;~ Global $SalvageTabLable = _GuiCtrlCreatePic($iStruct, $tableisteHWND, $SalvagePath, $x, $y)
;~ GUICtrlSetOnEvent($SalvageTabLable,"MainGUIEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_Hover_SalvageButtonOn", "_Hover_SalvageButtonOff")
;~ Global $Button_Salvage_black = _GDIPlus_ImageLoadFromFile($SalvagePath)
;~ Global $Button_Salvage_bright = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\img\Perfect_Salvage_Kit_bright_x19.png")



;~ Local $ChestMoveToChestCheckbox = GUICtrlCreateCheckbox('',$x-14,$y+5,13,13)
;~ GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
;~ $x += 15
;~ Local $ChestMoveToChestCheckboxLable = GUICtrlCreateLabel("ENABLE MOVE", $x+100,$y-2,110,25,$SS_CENTER)
;~ GUICtrlSetBkColor(-1,0x123456)
;~ GUICtrlSetFont(-1, 15, 600, 0, "Evanescent")
;~ GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")


$y += 45
$x =  $OffsetX
Global $ChestEventItemsCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 17
Global $StoreEventItemsTabButton = MyGuiCtrlCreateButton("Event Items",$x,$y,90, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 21
$x =  $OffsetX
Global $ChestTomesCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 17
Global $StoreTomesTabButton = MyGuiCtrlCreateButton("Tomes",$x,$y,90, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 21
$x =  $OffsetX
Global $ChestDysCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetState(-1,$GUI_CHECKED)
$x += 17
Global $StoreDyeTabButton  = MyGuiCtrlCreateButton("Dye",$x,$y,90, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 21
$x =  $OffsetX
Global $ChestMatsCheckbox = GUICtrlCreateCheckbox('',$x,$y+2,13,13)
GUICtrlSetOnEvent(-1, "saveToIni")
GUICtrlSetState(-1,$GUI_CHECKED)
$x += 17
Global $StoreMatsTabButton  = MyGuiCtrlCreateButton("Mats",$x,$y,90, 18, 0x333333, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")

$y += 30

Local $ButtonWidth = 85
Local $buttonHight = 30

;~ $x = $ChestTabWidth -2*$ButtonWidth-2
$x = 0
$y = $ChestTabHight - $buttonHight - 1
GuiCtrlCreateRect($x, $y, 2*$ButtonWidth+3, 1,0x333333)
$y += 1
GuiCtrlCreateRect($x, $y, 1, $ChestTabHight - $y,0x333333)
$x += 1
Local $chestMoveNowToChestButton = GUICtrlCreateLabel("TO CHEST",$x,$y,$ButtonWidth, $buttonHight,BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 12, 600, 0, "Evanescent")
GUICtrlSetBkColor(-1,$MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x += $ButtonWidth
GuiCtrlCreateRect($x, $y, 1, $ChestTabHight - $y,0x333333)
$x += 1
Local $chestMoveNowToInvButton = GUICtrlCreateLabel("TO INV",$x,$y,$ButtonWidth, $buttonHight,BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetFont(-1, 12, 600, 0, "Evanescent")
GUICtrlSetBkColor(-1,$MY_Color_LightGrey)
GUICtrlSetOnEvent(-1,"ChestTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x += $ButtonWidth
GuiCtrlCreateRect($x, $y, 1, $ChestTabHight - $y,0x333333)

#EndRegion ChestTab

#Region SettingsTab
Local Const $SettingsTabHight = 150
Local Const $SettingsTabWidth = $LeftGuiWidth + $RightGuiWidth
Local $SettingsTab = _newTab("SettingsTab", $MainGUI, $SettingsTabWidth, $SettingsTabHight, 3 - $LeftGuiWidth, $TableisteHight + $MainHeight + 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background)
GUICtrlSetDefColor($MY_Color_Text)
_WinAPI_SetLayeredWindowAttributes($SettingsTab, 0xCC0000, $myTransparenty)
_GuiRoundCorners($SettingsTab, 3)
GUISetFont( 9, 400, 0, "Segoe Marker")
;~ GuiCtrlCreateRect($LeftGuiWidth -1 , 0, 1, $SellTabHight,$MY_Color_DarkGrey)

Local $x = 5
Local $y = 4
Local $iTab = getTabNrByName("SettingsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

$x = 15
Global $DistrictTabLable = MyGuiCtrlCreateButton("Districts",$x,$y,$LeftGuiWidth -2*$x, 18, $MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "SettingsTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$y += 22
Global $PlayerStatusTabLable = MyGuiCtrlCreateButton("Status",$x,$y,35, 18, $MY_Color_DarkGrey, $MY_Color_LightGrey)
GUICtrlSetOnEvent(-1, "SettingsTabEventHandler")
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverButtonOff")
$x += 40
Global $PlayerStatusLable = GUICtrlCreateLabel("don't know",$x,$y,70,18,BitOR($SS_CENTER, $SS_CENTERIMAGE))
;~ GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
;~ GUICtrlSetBkColor(-1,0x12345)
$y += 25
$x = 15

Global $GuiOnTopCheckbox = GUICtrlCreateCheckbox("", $x, $y+2, 15, 15)
GUICtrlSetState(-1,$GUI_CHECKED)
GUICtrlSetOnEvent(-1, "_changeGuiOnTop")
;~ GUICtrlSetOnEvent(-1, "ToggleRendering")
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x += 15
Global $GuiOnTopCheckboxLable = GUICtrlCreateLabel('Gui on Top',$x,$y+2,$LeftGuiWidth-20,18,$ss_center)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "_changeGuiOnTop")
$y += 18
$x = 10
GuiCtrlCreateRect($x, $y, $LeftGuiWidth , 1,$MY_Color_DarkGrey)
$y += 2

$x = 15
Global $FullHideGwCheckbox = GUICtrlCreateCheckbox("", $x, $y+2, 15, 15)
GUICtrlSetState(-1,$GUI_CHECKED)
GUICtrlSetOnEvent(-1, "saveToIni")
;~ GUICtrlSetOnEvent(-1, "ToggleRendering")
;~ GUICtrlSetColor(-1,0xff0000)
;~ GUICtrlSetbkColor(-1,0x44ff00)
$x += 15
Global $FullHideGwCheckboxLable = GUICtrlCreateLabel('completely hide Gw',$x,$y+2,$LeftGuiWidth-20 ,18,$ss_center)
GUICtrlSetFont(-1, 9, 400, 0, "Segoe Marker")
_GUICtrl_OnHoverRegister(-1, "_HoverLableOn", "_HoverLableOff")
GUICtrlSetOnEvent(-1, "SettingsTabEventHandler")
$y += 18
$x = 10
GuiCtrlCreateRect($x, $y, $LeftGuiWidth, 1,$MY_Color_DarkGrey)
$y += 2

;~ Local $OffsetX = $LeftGuiWidth
;~ $x = $OffsetX
;~ $y = 10
;~ GUICtrlCreateLabel('Transparency:',$x+50,$y,100,20)
;~ $y += 15
;~ Local $TransparencySlider = GUICtrlCreateSlider($x, $y, 150, 20,bitor($TBS_NOTICKS,$TBS_AUTOTICKS))
;~ GUICtrlSetLimit($TransparencySlider, 255, 50)
;~ GUICtrlSetData(-1, $myTransparenty)
;~ GUICtrlSetBkColor(-1,0x000000)
;~ GUICtrlSetOnEvent(-1,'SettingsTabEventHandler')


#EndRegion SettingsTab

#Region BagstTab
local Const $BagsTabHight = 125
Local Const $BagsTabWidth = 170
Local $BagsTab = _newTab("BagsTab", $MainGUI, $BagsTabWidth, $BagsTabHight, 3 + $MainWidth, 3, BitOR(0, $WS_POPUP), BitOR($WS_EX_MDICHILD, 0, $WS_EX_LAYERED))
GUISetBkColor($MY_Color_Background,$BagsTab)
GUICtrlSetDefColor($MY_Color_Text,$BagsTab)
GUISetFont(9, 400, 0, "Segoe Marker")
_GuiRoundCorners($BagsTab, 3)
_WinAPI_SetLayeredWindowAttributes($BagsTab, 0xCC0000, $myTransparenty)
;~ GuiCtrlCreateRect(0, 0, $StoreTomesTabWidth, 1,$MY_Color_DarkGrey)

Local $iTab = getTabNrByName("BagsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]

Local $x = 0
Local $y = 0
Local $FiberIconPath = @ScriptDir & "\img\FiberIcon.png"
;~ GUICtrlCreateLabel("",$x,$y,23,15)
;~ GUICtrlSetBkColor(-1,0xCC0000)
;~ _GuiCtrlCreatePic($iStruct, $StoreMatsTab, $FiberIconPath, $x,$y)
;~ GUICtrlSetOnEvent(-1,"toggleGDIPic")
GUICtrlCreateLabel('Bags', 0, 0, $BagsTabWidth -25, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
Global $Exit_Button_Bags = GuiCtrlCreateLabel("X", $BagsTabWidth-25, 0, 25, 25,BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 10, 400, 0, "Segoe Print Bold")
GUICtrlSetOnEvent(-1, 'BagsTabEventHandler')
_GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
;~ _GUICtrl_OnHoverRegister(-1, "_HoverButtonOn", "_HoverLableOff")
GuiCtrlCreateRect($BagsTabWidth-25, 0, 1, 25,$MY_Color_DarkGrey)
$y += 25
GuiCtrlCreateRect(0, $y , $BagsTabWidth, 1,$MY_Color_DarkGrey)

$y += 8
$x = 25

;~ Local $iTab = getTabNrByName("InventoryTab")
;~ Local $iStruct = $TabArrayOfStructs[$iTab]
_GuiCtrlCreatePic($iStruct, $BagsTab, $BagPath[1], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab,$BagPath[2],$x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab,$BagPath[3],$x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab,$BagPath[4],$x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
ConsoleWrite(@CRLF & "!GDIPlusCount: " & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") & @CRLF )
For $i = 1 To DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount")
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($BagPath[$i]),$i)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($BagTickedPath[$i]),$i)
;~ 	$BagTickedPic[$i] = _GDIPlus_ImageLoadFromFile($BagTickedPath[$i])
Next
GUISwitch($BagsTab)
$y += 40
$x = 10
Local $iTab = getTabNrByName("BagsTab")
Local $iStruct = $TabArrayOfStructs[$iTab]
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[1], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[2], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[3], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[4], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[5], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x = 10
$y += 17
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[6], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[7], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[8], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[9], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
_GuiCtrlCreatePic($iStruct, $BagsTab, $ChestBagPath[10], $x,$y)
GUICtrlSetOnEvent(-1,"toggleGDIPic")
$x += 30
For $i = 5 To DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount")
	ConsoleWrite(@CRLF & $i & @tab & DllStructGetData($TabArrayOfStructs[$iTab],"GDIPlusCount") )
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND1", _GDIPlus_ImageLoadFromFile($ChestBagPath[($i-4)]),$i)
	DllStructSetData($TabArrayOfStructs[$iTab], "GDIPlusHWND2", _GDIPlus_ImageLoadFromFile($ChestBagTickedPath[($i-4)]),$i)
Next


#EndRegion BagsTab

#Region FinalGuiSetup
_WinAPI_SetLayeredWindowAttributes($MainGUI, 0xCC0000, $myTransparenty - 20)
_setOpenTabCtrlId()
_setInventoryBagsTicked()
_setChestBagsTicked()
If IniRead($IniPath, $CharName, "AutoStart", False) == False Then
	_showOnlyTabs("Tableiste", "StartTab", "GlogBoxTab", "CharNameTab")
Else
	_hideAllTabs()
	Local $GuiPos = WinGetPos($MainGUI)
	WinMove($MainGUI,"",IniRead($IniPath, $CharName, "GuiX",$GuiPos[0]),IniRead($IniPath, $CharName, "GuiY", $GuiPos[1]))
EndIf

For $i = 1 To UBound($TabArrayOfStructs) -1
	ConsoleWrite(@CRLF & DllStructGetData($TabArrayOfStructs[$i],"TabName") & @TAB & @TAB & "show: " & DllStructGetData($TabArrayOfStructs[$i],"Open"))
Next
GUISwitch($MainGUI)
If IniRead($IniPath, $CharName, "GuiOnTop", True) == True Then
	GUICtrlSetState($GuiOnTopCheckbox,$GUI_CHECKED)
	WinSetOnTop($MainGUI,"",1)
Else
	GUICtrlSetState($GuiOnTopCheckbox,$GUI_UNCHECKED)
	WinSetOnTop($MainGUI,"",0)
EndIf
GUISetState(@SW_SHOW, $MainGUI)
#EndRegion FinalGuiSetup

;~ _ArrayDisplay($tabNamesArray)

;__________EVENT HANDLER__________
Func MainGUIEventHandler()
	ConsoleWrite(@CRLF & "@GUI_CtrlId " & @GUI_CtrlId)
	Switch @GUI_CtrlId
		Case $Exit_Button_MainBox
			_exit()
		Case $Minimize_Button_MainBox
			If Not $MinimizedTabs Then
				_hideAllTabs()
			Else
				_showOnlyTabs("Tableiste", "StartTab", "GlogBoxTab", "CharNameTab")
			EndIf
			$MinimizedTabs = Not $MinimizedTabs
;~ 		Case $MinimizeLeftsideButton
;~ 			_hideAllTabs()
;~ 			_showTab("GlogBoxTab")
		Case $StartTabLable
			_showOnlyTabs("StartTab", "Tableiste", "GlogBoxTab", "CharNameTab")
		Case $LootTabLable
			_showOnlyTabs("LootTab","Tableiste", "GlogBoxTab", "CharNameTab")
		Case $StatsTabLable
			_showOnlyTabs("StatsTab", "Tableiste", "GlogBoxTab", "CharNameTab")
		Case $SalvageTabLable
			_showOnlyTabs("SalvageTab", "Tableiste", "CharNameTab")
		Case $SettingsTabLable
			_showOnlyTabs("SettingsTab", "Tableiste", "CharNameTab")
		Case $SellTabLable
			_showOnlyTabs("SellTab", "Tableiste", "GlogBoxTab", "CharNameTab")
		Case $InventoryTabLable
			_showOnlyTabs("InventoryTab", "Tableiste", "GlogBoxTab", "CharNameTab")
		Case $ChestTabLable
			_showOnlyTabs("ChestTab", "Tableiste", "CharNameTab")
	EndSwitch
EndFunc

Func StartTabEventHandler()
	Switch @GUI_CtrlId
		Case $useGhCheckboxLable
			If GUICtrlRead($useGhCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($useGhCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($useGhCheckbox,$GUI_CHECKED)
			EndIf
		Case $RenderingBox
			If $BotInitialized Then
				If Not $RenderingEnabled Then
					ToggleRendering(True)
				Else
					ToggleRendering(False)
				EndIf
			EndIf

		Case $RenderingBoxLable
			If $BotInitialized Then
				If Not $RenderingEnabled Then
					ToggleRendering(True)
				Else
					ToggleRendering(False)
				EndIf
			EndIf

		Case $BagsTabLable
			If _getIsTabOpenByCtrlId($BagsTabLable) Then
				_hideTab("BagsTab")
			Else
				_showTab("BagsTab")
			EndIf



		Case $StartButton
;~ 			MsgBox(0,0,"startbutton")

			If Not $BotInitialized Then
				$AverageTimer = TimerInit()
				_Initialize()
				$BotRunning = False
				GUICtrlSetData($StartButton, "Start")
				updateTotalTime()
				AdlibRegister("updateTotalTime", 60 * 1000)
				SetMaxMemory()
			ElseIf $BotRunning And Not $BotShouldPause Then
				Out("Will pause after run")
				$BotShouldPause = True
				GUICtrlSetData($StartButton, "resign now")
;~ 				GUICtrlSetState($StartButton, $GUI_DISABLE)
				$BotRunning = False
			ElseIf $BotShouldPause Then
				resign()
				GUICtrlSetState($StartButton, $GUI_DISABLE)
				;$BotShouldPause = False ;after run
			ElseIf  Not $BotRunning Then
				$BotRunning = True
				GUICtrlSetData($StartButton, "Pause")
			EndIf
	EndSwitch
	saveToIni()
EndFunc

Func LootTabEventHandler()
;~ 	If Not $BotInitialized Then Return
	Switch @GUI_CtrlId
;~ 		Case $SellTabLable
;~ 			If _getIsTabOpenByCtrlId($SellTabLable) Then
;~ 				_showOnlyTabs("Tableiste", "LootTab", "GlogBoxTab")
;~ 			Else
;~ 				_showOnlyTabs("Tableiste", "LootTab", "SellTab")
;~ 			EndIf
		Case $LootTomesTabLable
			If _getIsTabOpenByCtrlId($LootTomesTabLable) Then
				_hideTab("LootTomesTab")
			Else
				_showTab("LootTomesTab")
			EndIf
		Case $LootDyeTabLable
			If _getIsTabOpenByCtrlId($LootDyeTabLable) Then
				_hideTab("LootDyeTab")
			Else
				_showTab("LootDyeTab")
			EndIf
		Case $LootEventItemsTabLable
			If _getIsTabOpenByCtrlId($LootEventItemsTabLable) Then
				_hideTab("LootEventItemsTab")
			Else
				_showTab("LootEventItemsTab")
			EndIf
		Case $LootMatsTabLable
			If _getIsTabOpenByCtrlId($LootMatsTabLable) Then
				_hideTab("LootMatsTab")
			Else
				_showTab("LootMatsTab")
			EndIf

		Case $LootGoldiesCheckboxLable
			If GUICtrlRead($LootGoldiesCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($LootGoldiesCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($LootGoldiesCheckbox,$GUI_CHECKED)
			EndIf
		Case $LootGlacialStoneCheckboxLable
			If GUICtrlRead($LootGlacialStoneCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($LootGlacialStoneCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($LootGlacialStoneCheckbox,$GUI_CHECKED)
			EndIf
		Case $LootMapPiecesCheckboxLable
			If GUICtrlRead($LootMapPiecesCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($LootMapPiecesCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($LootMapPiecesCheckbox,$GUI_CHECKED)
			EndIf
		Case $LootIronItemsCheckboxLable
			If GUICtrlRead($LootIronItemsCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($LootIronItemsCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($LootIronItemsCheckbox,$GUI_CHECKED)
			EndIf
;~ 		Case $LootReq0ScytheCheckboxLable
;~ 			If GUICtrlRead($LootReq0ScytheCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($LootReq0ScytheCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($LootReq0ScytheCheckbox,$GUI_CHECKED)
;~ 			EndIf

	EndSwitch
	saveToIni()
EndFunc

Func SalvageTabEventHandler()
	Switch @GUI_CtrlId
		Case $StartSalvageButton
;~ 			out("salvage is in work might crash your game or do not work at all!!!")
			If $SalvageRunning Then
				out("salvage stop")
				GUICtrlSetData($StartSalvageButton,'start salvage')
				$SalvageRunning = False

			Else
				GUICtrlSetData($StartSalvageButton,'pause salvage')
				out("salvage start")
				$SalvageRunning = True
			EndIf
;~ 		Case $Salvage_DragonrootCheckboxLable
;~ 			If GUICtrlRead($Salvage_DragonrootCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($Salvage_DragonrootCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($Salvage_DragonrootCheckbox,$GUI_CHECKED)
;~ 			EndIf
;~ 		Case $Salvage_BrambleCheckboxLable
;~ 			If GUICtrlRead($Salvage_BrambleCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($Salvage_BrambleCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($Salvage_BrambleCheckbox,$GUI_CHECKED)
;~ 			EndIf
;~ 		Case $Salvage_SpiritwoodCheckboxLable
;~ 			If GUICtrlRead($Salvage_SpiritwoodCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($Salvage_SpiritwoodCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($Salvage_SpiritwoodCheckbox,$GUI_CHECKED)
;~ 			EndIf
	EndSwitch
	saveToIni()
EndFunc

Func DistrictTabEventHandler()
	For $i = 0 To 11
		Switch @GUI_CtrlId
			Case $DistrictCheckboxLables[$i]
				If GUICtrlRead($DistrictCheckboxes[$i]) == $GUI_CHECKED Then
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_UNCHECKED)
				Else
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_CHECKED)
				EndIf
		EndSwitch
	Next

	Switch @GUI_CtrlId
		Case $DistrictTabEuropAllButton
			For $i = 2 To 8
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_CHECKED)
			Next
		Case $DistrictTabEuropClearButton
			For $i = 2 To 8
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_UNCHECKED)
			Next
		Case $DistrictTabAsiaAllButton
			For $i = 9 To 11
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_CHECKED)
			Next
		Case $DistrictTabAsiaClearButton
			For $i = 9 To 11
					GUICtrlSetState($DistrictCheckboxes[$i],$GUI_UNCHECKED)
			Next
	EndSwitch
	saveToIni()
EndFunc

Func PlayerStatusTabEventHandler()
	Switch @GUI_CtrlId
		Case $PlayerStatusOfflineButton
			If $BotInitialized Then
				$PlayerStatus = 0
				SetPlayerStatus($PlayerStatus)
				out("=== Offline ===")
				If GUICtrlRead($PlayerStatusLable) <> "Offline" Then GUICtrlSetData($PlayerStatusLable,"Offline")
				IniWrite($IniPath, $CharName, "PlayerStatus", 0)
			EndIf
			_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
		Case $PlayerStatusOnlineButton
			If $BotInitialized Then
				$PlayerStatus = 1
				SetPlayerStatus($PlayerStatus)
				out("=== Online ===")
				If GUICtrlRead($PlayerStatusLable) <> "Online" Then GUICtrlSetData($PlayerStatusLable,"Online")
				IniWrite($IniPath, $CharName, "PlayerStatus", 1)
			EndIf
			_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
		Case $PlayerStatusDoNotDisturbButton
			If $BotInitialized Then
				$PlayerStatus = 2
				SetPlayerStatus($PlayerStatus)
				out("=== Do not disturb")
				If GUICtrlRead($PlayerStatusLable) <> "Do not disturb" Then GUICtrlSetData($PlayerStatusLable,"Do not disturb")
				IniWrite($IniPath, $CharName, "PlayerStatus", 2)
			EndIf
			_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
		Case $PlayerStatusAwayButton
			If $BotInitialized Then
				$PlayerStatus = 3
				SetPlayerStatus($PlayerStatus)
				out("=== Away ===")
				If GUICtrlRead($PlayerStatusLable) <> "Away" Then GUICtrlSetData($PlayerStatusLable,"Away")
				IniWrite($IniPath, $CharName, "PlayerStatus", 3)
			EndIf
			_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
	EndSwitch

EndFunc

Func LootTomesTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_LootTomes
			_hideTab("LootTomesTab")
		Case $LootTomesAllNormal
			For $i = 1 To 10
				GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootTomesClearAllNormal
			For $i = 1 To 10
				GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $LootTomesAllElite
			For $i = 11 To 20
				GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootTomesClearAllElite
			For $i = 11 To 20
				GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next

	EndSwitch
	saveToIni()
EndFunc

Func LootEventItemsTabEventHandler()
	Switch @GUI_CtrlId
		case $Exit_Button_LootEventItems
			_hideTab("LootEventItemsTab")
		Case $LootEventItemsAllSweets
			For $i = 1 To 7
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootEventItemsClearAllSweets
			For $i = 1 To 7
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $LootEventItemsAllAlc
			For $i = 8 To 14
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootEventItemsClearAllAlc
			For $i = 8 To 14
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $LootEventItemsAllParty
			For $i = 15 To 22
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootEventItemsClearAllParty
			For $i = 15 To 22
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $LootEventItemsAllOtherEvent
			For $i = 23 To 28
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootEventItemsClearAllOtherEvent
			For $i = 23 To 28
				GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
	EndSwitch
	saveToIni()
EndFunc

Func LootDyeTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_LootDys
			_hideTab("LootDyeTab")
		Case $LootAllDye
			For $i = 1 To 12
				GUICtrlSetState(DllStructGetData($LootDyeStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $LootClearAllDye
			For $i = 1 To 12
				GUICtrlSetState(DllStructGetData($LootDyeStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
	EndSwitch
	saveToIni()
EndFunc

Func LootMatsTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_LootMats
			_hideTab("LootMatsTab")

	EndSwitch
	saveToIni()
EndFunc

Func ChestTabEventHandler()
	Switch @GUI_CtrlId
		Case $chestMoveNowToChestButton
			If Not $BotRunning Then
				moveItemsToChest()
			EndIf
		Case $chestMoveNowToInvButton
			If Not $BotRunning Then
				moveItemsToInv()
			EndIf
;~ 		Case $ChestSkaleFinCheckboxLable
;~ 			If GUICtrlRead($ChestSkaleFinCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($ChestSkaleFinCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($ChestSkaleFinCheckbox,$GUI_CHECKED)
;~ 			EndIf
		Case $ChestMapPiecesCheckboxLable
			If GUICtrlRead($ChestMapPiecesCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($ChestMapPiecesCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($ChestMapPiecesCheckbox,$GUI_CHECKED)
			EndIf
;~ 		Case $ChestSkaleClawCheckboxLable
;~ 			If GUICtrlRead($ChestSkaleClawCheckbox) == $GUI_CHECKED Then
;~ 				GUICtrlSetState($ChestSkaleClawCheckbox,$GUI_UNCHECKED)
;~ 			Else
;~ 				GUICtrlSetState($ChestSkaleClawCheckbox,$GUI_CHECKED)
;~ 			EndIf
		Case $ChestLockpicksCheckboxLable
			If GUICtrlRead($ChestLockpicksCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($ChestLockpicksCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($ChestLockpicksCheckbox,$GUI_CHECKED)
			EndIf
		Case $StoreTomesTabButton
			If _getIsTabOpenByCtrlId($StoreTomesTabButton) Then
				_hideTab("StoreTomesTab")
			Else
				_showTab("StoreTomesTab")
			EndIf
		Case $StoreDyeTabButton
			If _getIsTabOpenByCtrlId($StoreDyeTabButton) Then
				_hideTab("StoreDyeTab")
			Else
				_showTab("StoreDyeTab")
			EndIf
		Case $StoreMatsTabButton
			If _getIsTabOpenByCtrlId($StoreMatsTabButton) Then
				_hideTab("StoreMatsTab")
			Else
				_showTab("StoreMatsTab")
			EndIf
		Case $StoreEventItemsTabButton
			If _getIsTabOpenByCtrlId($StoreEventItemsTabButton) Then
				_hideTab("StoreEventItemsTab")
			Else
				_showTab("StoreEventItemsTab")
			EndIf
	EndSwitch
	saveToIni()
EndFunc

Func SellTabEventHandler()
	Switch @GUI_CtrlId
		Case $SellNowButton
			If Not $BotInitialized Then Return
			If Not $BotRunning And Not $BotShouldPause Then
 				;Merchant()
				Local $MerchantTimer = TimerInit()
				Out("==== sell ====")
				GoToMerchant()
				Out("Identifying Items")
				_Ident()
				Out("Depositing Gold")
				DepositGold()
				Out("Selling Items")
				_Sell()
;~ 				If GetMapID() <> $MAP_ID_ANJEKA Then
;~ 					RndTravel($MAP_ID_ANJEKA, $DistrictCheckboxes)
;~ 					SetUpFastWay()
;~ 				Else
;~ 					_MoveTo(-11336, -22580)
;~ 				EndIf
				out("sell Time: " & Round(TimerDiff($MerchantTimer)/1000) & "sec")
				;_endMerchant
			Else
				out("===stop first===")
			EndIf
		Case $sellSpiritwoodCheckboxLable
			If GUICtrlRead($sellSpiritwoodCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($sellSpiritwoodCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($sellSpiritwoodCheckbox,$GUI_CHECKED)
			EndIf
		Case $sellGoldiesCheckboxLable
			If GUICtrlRead($sellGoldiesCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($sellGoldiesCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($sellGoldiesCheckbox,$GUI_CHECKED)
			EndIf
		Case $sellbluereq0scytheCheckboxLable
			If GUICtrlRead($sellbluereq0scytheCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($sellbluereq0scytheCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($sellbluereq0scytheCheckbox,$GUI_CHECKED)
			EndIf

	EndSwitch
	saveToIni()
EndFunc

Func InventoryTabEventHandler()
	If Not $BotInitialized Then Return
	Switch @GUI_CtrlId
		Case $InventoryIdentNowButton
			If Not $BotRunning And Not $BotShouldPause Then
				_Ident(False)
			Else
				out("===stop first===")
			EndIf
		Case $InventoryDropStuffButton
			If Not $BotRunning And Not $BotShouldPause Then
				DropStruff()
			Else
				out("===stop first===")
			EndIf
		Case $InventoryPickupLootButton
			If Not $BotRunning And Not $BotShouldPause Then
				PickupStuff()
			Else
				out("===stop first===")
			EndIf
		Case $InventoryGoChestButton
			If Not $BotRunning And Not $BotShouldPause Then
				GoToNPC(findXunlai())
			Else
				out("===stop first===")
			EndIf
		Case $InventoryGoMerchantButton
			If Not $BotRunning And Not $BotShouldPause Then
				GoToMerchant()
			Else
				out("===stop first===")
			EndIf
	EndSwitch
EndFunc

Func StoreTomesTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_StoreTomes
			_hideTab("StoreTomesTab")
		Case $StoreTomesAllNormal
			For $i = 1 To 10
				GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreTomesClearAllNormal
			For $i = 1 To 10
				GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $StoreTomesAllElite
			For $i = 11 To 20
				GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreTomesClearAllElite
			For $i = 11 To 20
				GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next

	EndSwitch
	saveToIni()
EndFunc

Func StoreEventItemsTabEventHandler()
	Switch @GUI_CtrlId
		case $Exit_Button_StoreEventItems
			_hideTab("StoreEventItemsTab")
		Case $StoreEventItemsAllSweets
			For $i = 1 To 7
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreEventItemsClearAllSweets
			For $i = 1 To 7
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $StoreEventItemsAllAlc
			For $i = 8 To 14
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreEventItemsClearAllAlc
			For $i = 8 To 14
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $StoreEventItemsAllParty
			For $i = 15 To 22
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreEventItemsClearAllParty
			For $i = 15 To 22
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
		Case $StoreEventItemsAllOtherEvent
			For $i = 23 To 28
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreEventItemsClearAllOtherEvent
			For $i = 23 To 28
				GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
	EndSwitch
	saveToIni()
EndFunc

Func StoreDyeTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_StoreDys
			_hideTab("StoreDyeTab")
		Case $StoreAllDye
			For $i = 1 To 12
				GUICtrlSetState(DllStructGetData($StoreDyeStruct,"Checkbox",$i),$GUI_CHECKED)
			Next
		Case $StoreClearAllDye
			For $i = 1 To 12
				GUICtrlSetState(DllStructGetData($StoreDyeStruct,"Checkbox",$i),$GUI_UNCHECKED)
			Next
	EndSwitch
	saveToIni()
EndFunc

Func StoreMatsTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_StoreMats
			_hideTab("StoreMatsTab")
	EndSwitch
	saveToIni()
EndFunc

Func SettingsTabEventHandler()
	Switch @GUI_CtrlId
		Case $DistrictTabLable
			If _getIsTabOpenByCtrlId($DistrictTabLable) Then
				_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
			Else
				_showOnlyTabs("Tableiste", "SettingsTab", "DistrictTab", "CharNameTab")
			EndIf
		Case $PlayerStatusTabLable
			If _getIsTabOpenByCtrlId($PlayerStatusTabLable) Then
				_showOnlyTabs("Tableiste", "SettingsTab", "CharNameTab")
			Else
				_showOnlyTabs("Tableiste", "SettingsTab", "PlayerStatusTab", "CharNameTab")
			EndIf
		Case $FullHideGwCheckboxLable
			If GUICtrlRead($FullHideGwCheckbox) == $GUI_CHECKED Then
				GUICtrlSetState($FullHideGwCheckbox,$GUI_UNCHECKED)
			Else
				GUICtrlSetState($FullHideGwCheckbox,$GUI_CHECKED)
			EndIf


;~ 		Case $TransparencySlider

	EndSwitch
	saveToIni()
EndFunc

Func BagsTabEventHandler()
	Switch @GUI_CtrlId
		Case $Exit_Button_Bags
			_hideTab("BagsTab")

	EndSwitch
	saveToIni()
EndFunc


;__________GUI FUNCTIONS__________

Func _updatePlayerStatus()
Switch GetPlayerStatus()
	Case 0
		If GUICtrlRead($PlayerStatusLable) <> "Offline" Then GUICtrlSetData($PlayerStatusLable,"Offline")
		IniWrite($IniPath, $CharName, "PlayerStatus", 0)
	Case 1
		If GUICtrlRead($PlayerStatusLable) <> "Online" Then GUICtrlSetData($PlayerStatusLable,"Online")
		IniWrite($IniPath, $CharName, "PlayerStatus", 1)
	Case 2
		If GUICtrlRead($PlayerStatusLable) <> "Do not disturb" Then GUICtrlSetData($PlayerStatusLable,"Do not disturb")
		IniWrite($IniPath, $CharName, "PlayerStatus", 2)
	Case 3
		If GUICtrlRead($PlayerStatusLable) <> "Away" Then GUICtrlSetData($PlayerStatusLable,"Away")
		IniWrite($IniPath, $CharName, "PlayerStatus", 3)
EndSwitch
EndFunc

; -> GW API #Region GUI
;~ Global $tabHWNDArray[0]
;~ Global $tabNamesArray[0]
;~ Description: Create a new Tab.
Func _newTab($title, $parent, $width, $height, $left = -1,$top = -1, $style = $WS_POPUP, $exStyle = $WS_EX_MDICHILD)
;~ _ArrayAdd($tabNamesArray, $title)
;~ _ArrayAdd($tabHWNDArray, GUICreate($title,$width, $height, $left, $top, $style, $exStyle, $parent))
;~ _ArrayAdd($tabIsOpen,False)

Local $newGui = GUICreate($title,$width, $height, $left, $top, $style, $exStyle, $parent)

_ArrayAdd($TabArrayOfStructs, DllStructCreate($tagSTRUCT2))

Local $newTabNumber = DllStructGetData($TabArrayOfStructs[0], 'TabAmount') + 1
DllStructSetData($TabArrayOfStructs[0], "TabAmount", $newTabNumber)
DllStructSetData($TabArrayOfStructs[0], "TabStructsPTR", DllStructGetPtr($TabArrayOfStructs[$newTabNumber]),$newTabNumber)
DllStructSetData($TabArrayOfStructs[$newTabNumber], "TabName", $title)
DllStructSetData($TabArrayOfStructs[$newTabNumber], "TabHWND", $newGui)
DllStructSetData($TabArrayOfStructs[$newTabNumber], "TabNumber", $newTabNumber)
DllStructSetData($TabArrayOfStructs[$newTabNumber], "Open", False)

ConsoleWrite(@CRLF & DllStructgetData($TabArrayOfStructs[0], "TabAmount") & ":")
ConsoleWrite(@TAB  & "Ptr: " & DllStructGetPtr($TabArrayOfStructs[$newTabNumber]))
ConsoleWrite(@TAB & @TAB  & "TabHWND: " & DllStructgetData($TabArrayOfStructs[$newTabNumber], "TabHWND"))
ConsoleWrite(@TAB & @TAB & DllStructgetData($TabArrayOfStructs[$newTabNumber], "TabName"))
;DllStructSetData($TabArrayOfStructs[$newTabNumber], "OpenTabCtrlId", 0x123)  ; after newTab

;~ GUISetState(@SW_SHOW)
Return $newGui ;$tabHWNDArray[UBound($tabHWNDArray)-1]
EndFunc   ;==>_newTab

Func _setOpenTabCtrlId()
	For $i = 1 To UBound($TabArrayOfStructs) -1
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StartTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StartTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "LootTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$LootTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StatsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StatsTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "SalvageTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$SalvageTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "SettingsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$SettingsTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "DistrictTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$DistrictTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "PlayerStatusTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$PlayerStatusTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "LootEventItemsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$LootEventItemsTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "LootDyeTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$LootDyeTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "SellTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$SellTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "ChestTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$ChestTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "LootTomesTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$LootTomesTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "LootMatsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$LootMatsTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "InventoryTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$InventoryTabLable)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StoreEventItemsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StoreEventItemsTabButton)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StoreDyeTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StoreDyeTabButton)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StoreMatsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StoreMatsTabButton)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "StoreTomesTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$StoreTomesTabButton)
		If DllStructGetData($TabArrayOfStructs[$i],"TabName") = "BagsTab" Then DllStructSetData($TabArrayOfStructs[$i],"OpenTabCtrlId",$BagsTabLable)

	Next
;~ 	For $i = 1 To UBound($TabArrayOfStructs) -1
;~ 		ConsoleWrite(@CRLF & $i & ": TabName" &@TAB & DllStructGetData($TabArrayOfStructs[$i],"TabName") & @TAB & @TAB & "CtrlID" & @TAB & DllStructGetData($TabArrayOfStructs[$i],"OpenTabCtrlId"))
;~ 	Next
;~ 	ConsoleWrite(@CRLF & "$StartTabLable" & @TAB & $StartTabLable)
;~ 	ConsoleWrite(@CRLF & "$LootTabLable" & @TAB & $LootTabLable)
;~ 	ConsoleWrite(@CRLF & "$StatsTabLable" & @TAB & $StatsTabLable)
;~ 	ConsoleWrite(@CRLF & "$SalvageTabLable" & @TAB & $SalvageTabLable)
;~ 	ConsoleWrite(@CRLF & "$DistrictTabLable" & @TAB & $DistrictTabLable)
;~ 	ConsoleWrite(@CRLF & "$PlayerStatusTabLable" & @TAB & $PlayerStatusTabLable)
;~ 	ConsoleWrite(@CRLF & "$LootEventItemsTabLable" & @TAB & $LootEventItemsTabLable)
;~ 	ConsoleWrite(@CRLF & "$LootDyeTabLable" & @TAB & $LootDyeTabLable)
;~ 	ConsoleWrite(@CRLF & "$SellTabLable" & @TAB & $SellTabLable)
;~ 	ConsoleWrite(@CRLF & "$ChestTabLable" & @TAB & $ChestTabLable)
;~ 	ConsoleWrite(@CRLF & "$LootTomesTabLable" & @TAB & $LootTomesTabLable)
EndFunc

Func _setInventoryBagsTicked()
	Local $tabNr = getTabNrByName("InventoryTab")
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,1)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,2)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,3)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",False,4)
EndFunc

Func _setChestBagsTicked()
	Local $tabNr = getTabNrByName("ChestTab")
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,1)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,2)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,3)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,4)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,5)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,6)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,7)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,8)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,9)
	DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",True,10)
EndFunc

;~ Description: open/show a Tab by name
Func _showTab($tabname)
	Local $tabNr = getTabNrByName($tabname)
;~ 	GUISetState(@SW_SHOW, $tabHWNDArray[_ArraySearch($tabNamesArray, $tabname)])
	GUISetState(@SW_SHOW, DllStructGetData($TabArrayOfStructs[$tabNr],"TabHWND"))
	DllStructSetData($TabArrayOfStructs[$tabNr], "Open", True)
	If $tabname = "Tableiste" Then
		Local $iTab = getTabNrByName("Tableiste")
		Local $myTabStruct = $TabArrayOfStructs[$iTab]
		GUISetState(@SW_SHOW, DllStructGetData($myTabStruct,"GDIPlusHWND"))
		_Hover_SalvageButtonOff()
		_Hover_SettingsButtonOff()
	Else
		GUICtrlSetBkColor(DllStructGetData($TabArrayOfStructs[$tabNr], "OpenTabCtrlId"),$MY_Color_DarkGrey)
	EndIf
;~ 	ConsoleWrite(@CRLF & "GDIPlusCount: " & DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount"))
	For $i = 1 to DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
		GUISetState(@SW_SHOW, DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i))
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$i) Then
			SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND2",$i),$myTransparenty)
		Else
			SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND1",$i),$myTransparenty)
		EndIf
	Next
EndFunc   ;==>_showTab

;~ Description: hide a Tab by name
Func _hideTab($tabname)
	Local $tabNr = getTabNrByName($tabname)
;~ 	GUISetState(@SW_HIDE, $tabHWNDArray[_ArraySearch($tabNamesArray, $tabname)])
	GUISetState(@SW_HIDE, DllStructGetData($TabArrayOfStructs[$tabNr],"TabHWND"))
	DllStructSetData($TabArrayOfStructs[$tabNr], "Open", False)

	If $tabname = "StartTab" Or $tabname = "LootTab" Or $tabname = "StatsTab" Or $tabname = "SellTab" Or $tabname = "InventoryTab" Or $tabname = "ChestTab" Then
		GUICtrlSetBkColor(DllStructGetData($TabArrayOfStructs[$tabNr], "OpenTabCtrlId"),$MY_Color_Background)
	ElseIf $tabname = "Tableiste" Then
		Local $iTab = getTabNrByName("Tableiste")
		Local $myTabStruct = $TabArrayOfStructs[$iTab]
		GUISetState(@SW_HIDE, DllStructGetData($myTabStruct,"GDIPlusHWND"))
		_Hover_SalvageButtonOff()
		_Hover_SettingsButtonOff()
	Else
		GUICtrlSetBkColor(DllStructGetData($TabArrayOfStructs[$tabNr], "OpenTabCtrlId"),$MY_Color_LightGrey)
	EndIf
	For $i = 1 to DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			GUISetState(@SW_HIDE, DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i))
			SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND2",$i),0)
			SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$i), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND1",$i),0)
	Next
EndFunc   ;==>_hideTab

;~ Description: hide all Tabs
Func _hideAllTabs()

	For $i = 1 To DllStructGetData($TabArrayOfStructs[0],"TabAmount")
		Local $NextTabName = DllStructGetData($TabArrayOfStructs[$i],"TabName")
		_hideTab($NextTabName)
	Next

;~ 	hideLootTab()
;~ 	For $i = 0 To UBound($tabHWNDArray) -1
;~ 		GUISetState(@SW_HIDE, $tabHWNDArray[$i])
;~ 	Next
EndFunc   ;==>_hideAllTabs

;~ Description: show up to 3 Tabs, hide other Tabs
Func _showOnlyTabs($tabName1, $tabName2= 0, $tabName3 = 0, $tabName4 = 0)
	_showTab($tabName1)
	If $tabName2 Then _showTab($tabName2)
	If $tabName3 Then _showTab($tabName3)
	If $tabName4 Then _showTab($tabName4)

;~ 	ConsoleWrite(@CRLF & "TabAmount: " & DllStructGetData($TabArrayOfStructs[0],"TabAmount"))
	For $i = 1 To DllStructGetData($TabArrayOfStructs[0],"TabAmount")
		Local $NextTabName = DllStructGetData($TabArrayOfStructs[$i],"TabName")
		If $NextTabName = $tabName1 Then ContinueLoop
		If $tabName2 And $NextTabName = $tabName2 Then ContinueLoop
		If $tabName3 And $NextTabName = $tabName3 Then ContinueLoop
		If $NextTabName = "LootEventItemsTab" Then ContinueLoop
		If $NextTabName = "LootDyeTab" Then ContinueLoop
		If $NextTabName = "LootTomesTab" Then ContinueLoop
		If $NextTabName = "StoreEventItemsTab" Then ContinueLoop
		If $NextTabName = "StoreDyeTab" Then ContinueLoop
		If $NextTabName = "StoreTomesTab" Then ContinueLoop
		If $NextTabName = "StoreMatsTab" Then ContinueLoop
		If $NextTabName = "CharNameTab" Then ContinueLoop
		If $NextTabName = "LootMatsTab" Then ContinueLoop
		If $NextTabName = "BagsTab" Then ContinueLoop
		_hideTab($NextTabName)
	Next
	If $tabname1 = "Tableiste" Or $tabname2 = "Tableiste" Or $tabname3 = "Tableiste" Or $tabname4 = "Tableiste" Then _showTab("Tableiste")
	If $tabname1 <> "SalvageTab" And $tabname2 <> "SalvageTab" And $tabname3 <> "SalvageTab" And $tabname4 <> "SalvageTab" Then _hideTab("SalvageTab")
;~ 	If $tabname1 <> "SettingsTab" And $tabname2 <> "SettingsTab" And $tabname3 <> "SettingsTab" And $tabname4 <> "SettingsTab" Then _hideTab("SettingsTab")

;~ 	For $i = 0 To UBound($tabHWNDArray) -1
;~ 		If $i = _ArraySearch($tabNamesArray, $tabName1) Then ContinueLoop
;~ 		If $i = _ArraySearch($tabNamesArray, $tabName2) Then ContinueLoop
;~ 		If $i = _ArraySearch($tabNamesArray, $tabName3) Then ContinueLoop
;~ 		GUISetState(@SW_HIDE, $tabHWNDArray[$i])
;~ 	Next
;~ 	If $tabName1 == "LootTab" Or  $tabName2 == "LootTab" Or  $tabName3 == "LootTab" Then
;~ 		showLootTab()
;~ 	Else
;~ 		hideLootTab()
;~ 	EndIf

;	If $tabName1 == "SalvageTab" Or  $tabName2 == "SalvageTab" Or  $tabName3 == "SalvageTab" Then
;		showLootTab()
;	Else
;		hideLootTab()
;	EndIf
EndFunc   ;==>_showOnlyTabs

;~ Description: Gregs pretty GUIs.
Func _GuiRoundCorners($h_win, $iSize)
   Local $XS_pos, $XS_ret
   $XS_pos = WinGetPos($h_win)
   $XS_ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", 0, "long", 0, "long", $XS_pos[2] + 1, "long", $XS_pos[3] + 1, "long", $iSize, "long", $iSize)
   If $XS_ret[0] Then
	  DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $XS_ret[0], "int", 1)
   EndIf
EndFunc   ;==>_GuiRoundCorners

Func ToggleRendering($Enable)
	If $Enable Then
		$RenderingEnabled = True
		If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then GUICtrlSetState($RenderingBox,$GUI_UNCHECKED)
		EnableRendering()
		ConsoleWrite('Enable Rendering' & @CRLF )
		WinSetState($HWND, "", @SW_SHOW)
	ElseIf Not $Enable Then
		$RenderingEnabled = False
		If GUICtrlRead($RenderingBox) == $GUI_UNCHECKED Then GUICtrlSetState($RenderingBox,$GUI_CHECKED)
		DisableRendering()
		ConsoleWrite('Disable Rendering' & @CRLF )
		If GUICtrlRead($FullHideGwCheckbox) == $GUI_CHECKED Then
			WinSetState($HWND, "", @SW_HIDE)
		EndIf

	EndIf
	Return True
EndFunc

Func MyGuiCtrlCreateButton($sText, $iX, $iY, $iW, $iH, $iColor = $MY_Color_DarkGrey, $iBgColor = $MY_Color_LightGrey, $iPenSize = 1, $iStyle = -1, $iStyleEx = 0)
	Return GuiCtrlCreateBorderLabel($sText, $iX, $iY, $iW, $iH, $iColor, $iBgColor, $iPenSize, ($iStyle = -1 ? BitOR($SS_CENTER, $SS_CENTERIMAGE) : $iStyle), $iStyleEx)
EndFunc

Func GuiCtrlCreateBorderLabel($sText, $iX, $iY, $iW, $iH, $iColor, $iBgColor, $iPenSize = 1, $iStyle = -1, $iStyleEx = 0)
    GUICtrlCreateLabel("", $iX - $iPenSize, $iY - $iPenSize, $iW + 2 * $iPenSize, $iH + 2 * $iPenSize, 0)
	GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetBkColor(-1, $iColor)
    Local $nID = GUICtrlCreateLabel($sText, $iX, $iY, $iW, $iH, $iStyle, $iStyleEx)
	GUICtrlSetBkColor(-1, $iBgColor)
    Return $nID
EndFunc   ;==>CreateBorderLabel

Func GuiCtrlCreateRect($x, $y, $width, $height, $color = 0xFFFFFF)
	Local $ret = GUICtrlCreateLabel("", $x, $y, $width, $height)
	GUICtrlSetBkColor(-1, $color)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Return $ret
EndFunc

Func UpdateStats()
	If $SucessfulLastRun = False Then
		$FailedRunCount += 1
		GUICtrlSetData($FailsRunsCountLable, $FailedRunCount)
;~ 		out("===Dist1====" & Round($myDistance1))
;~ 		out("===Dist2====" & Round($myDistance2))
;~ 		out("===Dist3====" & Round($myDistance3))
	Else
		$SuccessfulRunCount += 1
		GUICtrlSetData($SucessfulRunsCountLable, $SuccessfulRunCount)
		$SucessfulLastRun = False
		If IsInt($SuccessfulRunCount/30) And Not $RenderingEnabled Then
			ToggleRendering(True)
			Sleep(2000)
			ToggleRendering(False)
		EndIf
		;only count Successful Runs to the average
		UpdateAverageTimer() ; $AverageTimer=TimerInit() if start the next round
	EndIf
	;all Runs to the average
	;UpdateAverageTimer() ; $AverageTimer=TimerInit() if start the next round
EndFunc

Func updateTotalTime()
;~ 	ConsoleWrite('updateTotalTime' & @TAB)
    _TicksToTime(Int(TimerDiff($TotalTimer)), $TotalHours, $TotalMinutes, $TotalSeconds)
    Local $sTime = $TotalTime ; save current time to be able to test and avoid flicker..
    $TotalTime = StringFormat("%1i %1s %2i %3s", $TotalHours,"h", $TotalMinutes,"min")
    If $sTime <> $TotalTime Then GUICtrlSetData($TotTimeCount, $TotalTime)
;~ 	ConsoleWrite("  --> " & "$TotalTime: "  & $TotalTime & @CRLF)
	If $Show_RedLable And TimerDiff($AverageTimer) > 5*60*1000 Then
		IniWrite($IniPath,$CharName,"Error",1)
	Else
		IniWrite($IniPath,$CharName,"Error",0)
	EndIf

	If $Show_RedLable And $BotRunning And TimerDiff($AverageTimer) < 5*60*1000 Then ;merch time ca 180 sec
		$Show_RedLable = False
		GUICtrlDelete($ToolBoxLabel)
		GUISwitch($MainGUI)
		Global $ToolBoxLabel = GUICtrlCreatePic(@ScriptDir & '\img\Logo Green.jpg', 0, 0, 130, 24, -1, $GUI_WS_EX_PARENTDRAG)
		_WinAPI_SetLayeredWindowAttributes($MainGUI, 0xCC0000, $myTransparenty -20)
	ElseIf Not $Show_RedLable And (TimerDiff($AverageTimer) > 5*60*1000 Or Not $BotRunning) Then
		$Show_RedLable = True
		GUICtrlDelete($ToolBoxLabel)
		GUISwitch($MainGUI)
		Global $ToolBoxLabel = GUICtrlCreatePic(@ScriptDir & '\img\Logo Red.jpg', 0, 0, 130, 24, -1, $GUI_WS_EX_PARENTDRAG)
		_WinAPI_SetLayeredWindowAttributes($MainGUI, 0xCC0000, $myTransparenty - 20)
	EndIf

EndFunc

Func UpdateAverageTimer()
	Local $AverageHour, $AverageMin, $AverageSec
	Local $allRuns = $SuccessfulRunCount ;+ $FailedRunCount
	Local $sTime = $Time
	If Not $AverageTicks Then
		$AverageTicks = TimerDiff($AverageTimer)
	Else
		$AverageTicks +=  TimerDiff($AverageTimer)
	EndIf
	_TicksToTime (Round($AverageTicks/$allRuns,-3), $AverageHour,$AverageMin,$AverageSec)
	ConsoleWrite("!last Run Ticks: "  & Round(TimerDiff($AverageTimer)) & @TAB)
	ConsoleWrite("$AverageTicks: " & Round($AverageTicks/$allRuns))
	ConsoleWrite("  --> " & $AverageMin & " mins " & $AverageSec & " secs" & @CRLF)

	If $AverageHour = 0 And $AverageMin = 0 Then
		$Time = StringFormat("%2i %3s", $AverageSec,"sec")
	ElseIf $AverageHour = 0 Then
		$Time = StringFormat("%2i %3s %02i %3s", $AverageMin,"min", $AverageSec,"sec")
	Else
		$Time = StringFormat("%02i %1s %02i %3s %02i %3s", $AverageHour, "h", $AverageMin,"min", $AverageSec,"sec")
	EndIf
	If $sTime <> $Time Then GUICtrlSetData($AvgTimeCount, $Time)

EndFunc   ;==>Timer

Func addToPlatinCount($GoldAmount)
;~ 	ConsoleWrite(@CRLF & "-------add Gold  " & $GoldAmount & @TAB & @TAB )
	$GoldCount += $GoldAmount
	If $GoldCount/1000 <> GUICtrlRead($GoldCountLable) Then GUICtrlSetData($GoldCountLable, $GoldCount/1000)  ;/1000 to display as 1.337p
EndFunc

Func Out($TEXT)
	Local $TEXTLEN = StringLen($TEXT)
	Local $CONSOLELEN = _GUICtrlEdit_GetTextLen($GLOGBOX)
	If $TEXTLEN + $CONSOLELEN > 30000 Then GUICtrlSetData($GLOGBOX, StringRight(_GUICtrlEdit_GetText($GLOGBOX), 30000 - $TEXTLEN - 1000))
	_GUICtrlEdit_AppendText($GLOGBOX, @CRLF & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "] " & $TEXT)
	_GUICtrlEdit_Scroll($GLOGBOX, 1)
EndFunc   ;==>OUT

Func _exit()
	saveToIni()
	If GUICtrlRead($RenderingBox) == $GUI_CHECKED Then
		EnableRendering()
		WinSetState($HWND, "", @SW_SHOW)
		Sleep(500)
	EndIf
	For $i = 0 To 3
		_GDIPlus_ImageDispose($BagPic[$i])
		_GDIPlus_ImageDispose($BagTickedPic[$i])
	Next
	; Release the resources used by the structure.
	For $i = 0 To UBound($TabArrayOfStructs) -1
		$TabArrayOfStructs[$i] = 0
	Next
	IniWrite($IniPath, $CharName, "GuiHWND", False)
	Exit
EndFunc

Func _Secondaryup()
	GUISetState(@SW_MINIMIZE, $MainGUI)
EndFunc

Func _changeGuiOnTop()
	if Not $GuiOnTop then
		WinSetOnTop($MainGUI,"",1)
		$GuiOnTop=true
		GUICtrlSetState($GuiOnTopCheckbox,$GUI_CHECKED)
;~ 		SetBitmap($Main_6,$ButtonOffTop, $myTransparenty)
	else
		WinSetOnTop($MainGUI,"",0)
		$GuiOnTop=false
		GUICtrlSetState($GuiOnTopCheckbox,$GUI_UNCHECKED)
;~ 		SetBitmap($Main_6,$ButtonOnTop, $myTransparenty)
	endif
	saveToIni()
EndFunc

;~ Func showLootTab()
;~ 	$LootTabOpen = True
;~ 	_showTab("LootTab")
;~ 	For $i = 0 to 3
;~ 		If $BagTicked[$i] Then
;~ 			SetBitmap($BagMenu[$i],$BagTickedPic[$i],$myTransparenty)
;~ 		Else
;~ 			SetBitmap($BagMenu[$i],$BagPic[$i],$myTransparenty)
;~ 		EndIf
;~ 	Next
;~ EndFunc

;~ Func hideLootTab()
;~ 	$LootTabOpen = False
;~ 	_hideTab("LootTab")
;~ 	For $i = 0 To 3
;~ 		SetBitmap($BagMenu[$i],$BagPic[$i],0)
;~ 		SetBitmap($BagMenu[$i],$BagTickedPic[$i],0)
;~ 	Next
;~ 	_showOnlyTabs("Tableiste", "LootTab", "GlogBoxTab")
;~ EndFunc

Func toggleGDIPic()
	Local $lastCtrlID = @GUI_CtrlId
	For $tabNr = 1 To DllStructGetData($TabArrayOfStructs[0],"TabAmount")
		For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			Local $nextHwnd = DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCtrlID",$GDIIndex)
;~ 			ConsoleWrite(@CRLF & $GDIIndex & ": " & @TAB & $lastCtrlID & " = " & $nextHwnd)
			Switch $lastCtrlID
				Case $nextHwnd
					DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",Not DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex),$GDIIndex)
					If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
						SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$GDIIndex), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND2",$GDIIndex),$myTransparenty)
					Else
						SetBitmap(DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND",$GDIIndex), DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusHWND1",$GDIIndex),$myTransparenty)
					EndIf
			EndSwitch
		Next
	Next

;~ 	If $BagTicked[0] Then
;~ 		SetBitmap($BagMenu[0],$BagTickedPic[0],$myTransparenty)
;~ 	Else
;~ 		SetBitmap($BagMenu[0],$BagPic[0],$myTransparenty)
;~ 	EndIf
	saveToIni()
EndFunc

Func _getIsTabOpenByCtrlId($iCtrlID)
	For $tabNr = 1 To DllStructGetData($TabArrayOfStructs[0],"TabAmount")
		Local $TabCtrlID = DllStructGetData($TabArrayOfStructs[$tabNr],"OpenTabCtrlId")
		If $iCtrlID = $TabCtrlID Then
			Return DllStructGetData($TabArrayOfStructs[$tabNr],"Open")
		EndIf
	Next
	Return 0
EndFunc

Func _HoverFuncOn($iCtrlID)
	GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
EndFunc

Func _HoverFuncOff($iCtrlID)
	If _getIsTabOpenByCtrlId($iCtrlID) Then
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
	Else
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
		GUICtrlSetBkColor($iCtrlID,$MY_Color_Background)
	EndIf
EndFunc

Func _Hover_SalvageButtonOn($iCtrlID = $SalvageTabLable)
;~ 	SetBitmap($SalvageTabLable,$Button_Salvage_bright,$myTransparenty)
	Local $iTab = getTabNrByName("Tableiste")
	Local $myTabStruct = $TabArrayOfStructs[$iTab]
;~ 	If _getIsTabOpenByCtrlId($iCtrlID) Then
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND"), $Button_Salvage_bright, $myTransparenty)
;~ 	Else
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
;~ 		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND"), $Button_Salvage_black, $myTransparenty)
;~ 	EndIf
EndFunc

Func _Hover_SalvageButtonOff($iCtrlID = $SalvageTabLable)
	Local $iTab = getTabNrByName("Tableiste")
	Local $myTabStruct = $TabArrayOfStructs[$iTab]
	If _getIsTabOpenByCtrlId($iCtrlID) Then
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND",1), $Button_Salvage_bright, $myTransparenty)
	Else
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND",1), $Button_Salvage_black, $myTransparenty)
	EndIf
EndFunc

Func _Hover_SettingsButtonOn($iCtrlID = $SettingsTabLable)
;~ 	SetBitmap($SalvageTabLable,$Button_Salvage_bright,$myTransparenty)
	Local $iTab = getTabNrByName("Tableiste")
	Local $myTabStruct = $TabArrayOfStructs[$iTab]
;~ 	If _getIsTabOpenByCtrlId($iCtrlID) Then
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND",2), $Button_Settings_bright, $myTransparenty)
;~ 	Else
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
;~ 		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND"), $Button_Salvage_black, $myTransparenty)
;~ 	EndIf
EndFunc

Func _Hover_SettingsButtonOff($iCtrlID = $SettingsTabLable)
	Local $iTab = getTabNrByName("Tableiste")
	Local $myTabStruct = $TabArrayOfStructs[$iTab]
	If _getIsTabOpenByCtrlId($iCtrlID) Then
;~ 		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND",2), $Button_Settings_bright, $myTransparenty)
	Else
		SetBitmap(DllStructGetData($myTabStruct,"GDIPlusHWND",2), $Button_Settings_black, $myTransparenty)
	EndIf
EndFunc


Func _HoverButtonOn($iCtrlID)
	If _getIsTabOpenByCtrlId($iCtrlID) Then
		GUICtrlSetColor($iCtrlID,$MY_Color_Text2)
		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
	Else
		GUICtrlSetColor($iCtrlID,$MY_Color_Text2)
		GUICtrlSetBkColor($iCtrlID,$MY_Color_DarkGrey)
	EndIf
EndFunc

Func _HoverButtonOff($iCtrlID)
;~ 	ConsoleWrite(@CRLF & "$iCtrlID: " & $iCtrlID & @TAB & "TabOpen: " & _getIsTabOpenByCtrlId($iCtrlID))
	If _getIsTabOpenByCtrlId($iCtrlID) Then
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
;~ 		GUICtrlSetBkColor($iCtrlID,0x123456)
	Else
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
		GUICtrlSetBkColor($iCtrlID,$MY_Color_LightGrey)
	EndIf
EndFunc

Func _HoverLableOn($iCtrlID)
	GUICtrlSetColor($iCtrlID,$MY_Color_Text2)
EndFunc

Func _HoverLableOff($iCtrlID)
	If _getIsTabOpenByCtrlId($iCtrlID) Then
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
	Else
		GUICtrlSetColor($iCtrlID,$MY_Color_Text)
		GUICtrlSetBkColor($iCtrlID,$MY_Color_Background)
	EndIf
EndFunc

Func SetBitmap($hGUI, $hImage, $iOpacity)    ; lade hintergrundbild und mache den hintergrund transparent
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc

Func _GuiCtrlCreatePic(ByRef $myTabStruct, $gGui, $iPicture, $iX = 0, $iY = 0 , $show = False)
	$gImage = _GDIPlus_ImageLoadFromFile($iPicture)
	$gWidth = _GDIPlus_ImageGetWidth($gImage)
	$gHeight = _GDIPlus_ImageGetHeight($gImage)
	$iGui = GUICreate("", $gWidth, $gHeight, $iX+3, $iY+3, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $gGui)
	$iLabel = GUICtrlCreateLabel("", 0, 0, $gWidth, $gHeight)  ;gives the CtrlID you will click on
	GUISetBkColor(0, $iGui)
	If $show Then GUISetState(@SW_SHOW, $iGui)
	SetBitmap($iGui, $gImage,$myTransparenty)

	Local $GDIPlusIndex = DllStructGetData($myTabStruct,"GDIPlusCount") + 1
	DllStructSetData($myTabStruct, "GDIPlusCount", $GDIPlusIndex)
	DllStructSetData($myTabStruct, "GDIPlusHWND", $iGui, $GDIPlusIndex)
	DllStructSetData($myTabStruct,"GDIPlusCtrlID",$iLabel, $GDIPlusIndex)
;~ 	ConsoleWrite(@TAB & @TAB & DllStructGetData($myTabStruct,"GDIPlusHWND",$GDIPlusIndex))
	GUISwitch($gGui)
	;Local $iReturn[6] = [0, SetError(0, $iLabel,$iGui), $iX, $iY, $gWidth, $gHeight]
	$iReturn=$iLabel
	Return $iReturn
EndFunc ;==>_GuiCtrlCreatePic

Func getTabNrByName($Tabname)
	For $i = 1 To UBound($TabArrayOfStructs) -1
		If $Tabname == DllStructGetData($TabArrayOfStructs[$i], 'TabName') Then Return $i
	Next
	Return 0
EndFunc

Func saveToIni()
	If Not $BotInitialized Then Return
	ConsoleWrite(@CRLF & "~ ~~saveTo~~" & $IniPath & "@GUI_CtrlId" & @TAB & @GUI_CtrlId & @TAB )
	IniWrite($IniPath, $CharName, "GuiHWND", $MainGUI)
	If IniRead($IniPath, $CharName, "AutoStart", False) == False Then
		Local $GuiPos = WinGetPos($MainGUI)
		IniWrite($IniPath, $CharName, "GuiX", $GuiPos[0])
		IniWrite($IniPath, $CharName, "GuiY", $GuiPos[1])
	EndIf
	Switch @GUI_CtrlId
		Case $useGhCheckboxLable
			If GUICtrlRead($useGhCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "useGh", True)
			Else
				IniWrite($IniPath, $CharName, "useGh", False)
			EndIf
		Case $useGhCheckbox
			If GUICtrlRead($useGhCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "useGh", True)
			Else
				IniWrite($IniPath, $CharName, "useGh", False)
			EndIf

		Case $GuiOnTopCheckboxLable
			If GUICtrlRead($GuiOnTopCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "GuiOnTop", True)
			Else
				IniWrite($IniPath, $CharName, "GuiOnTop", False)
			EndIf
		Case $GuiOnTopCheckbox
			If GUICtrlRead($GuiOnTopCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "GuiOnTop", True)
			Else
				IniWrite($IniPath, $CharName, "GuiOnTop", False)
			EndIf

		Case $RenderingBox
			If GUICtrlRead($RenderingBox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "DisableRendering", True)
			Else
				IniWrite($IniPath, $CharName, "DisableRendering", False)
			EndIf

		Case $LootGoldiesCheckboxLable
			If GUICtrlRead($LootGoldiesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Goldies", True)
			Else
				IniWrite($IniPath, $CharName, "Goldies", False)
			EndIf
		Case $LootGoldiesCheckbox
			If GUICtrlRead($LootGoldiesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Goldies", True)
			Else
				IniWrite($IniPath, $CharName, "Goldies", False)
			EndIf

		Case $LootGlacialStoneCheckboxLable
			If GUICtrlRead($LootGlacialStoneCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot GlacialStone", True)
			Else
				IniWrite($IniPath, $CharName, "Loot GlacialStone", False)
			EndIf
		Case $LootGlacialStoneCheckbox
			If GUICtrlRead($LootGlacialStoneCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot GlacialStone", True)
			Else
				IniWrite($IniPath, $CharName, "Loot GlacialStone", False)
			EndIf

		Case $LootMapPiecesCheckboxLable
			If GUICtrlRead($LootMapPiecesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot MapPieces", True)
			Else
				IniWrite($IniPath, $CharName, "Loot MapPieces", False)
			EndIf
		Case $LootMapPiecesCheckbox
			If GUICtrlRead($LootMapPiecesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot MapPieces", True)
			Else
				IniWrite($IniPath, $CharName, "Loot MapPieces", False)
			EndIf

		Case $LootIronItemsCheckboxLable
			If GUICtrlRead($LootIronItemsCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot IronItems", True)
			Else
				IniWrite($IniPath, $CharName, "Loot IronItems", False)
			EndIf
		Case $LootIronItemsCheckbox
			If GUICtrlRead($LootIronItemsCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "Loot IronItems", True)
			Else
				IniWrite($IniPath, $CharName, "Loot IronItems", False)
			EndIf

;~ 		Case $LootReq0ScytheCheckboxLable
;~ 			If GUICtrlRead($LootReq0ScytheCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "Loot Req0Scythe", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "Loot Req0Scythe", False)
;~ 			EndIf
;~ 		Case $LootReq0ScytheCheckbox
;~ 			If GUICtrlRead($LootReq0ScytheCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "Loot Req0Scythe", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "Loot Req0Scythe", False)
;~ 			EndIf

		Case $sellSpiritwoodCheckboxLable
			If GUICtrlRead($sellSpiritwoodCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellSpiritwood", True)
			Else
				IniWrite($IniPath, $CharName, "sellSpiritwood", False)
			EndIf
		Case $sellSpiritwoodCheckbox
			If GUICtrlRead($sellSpiritwoodCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellSpiritwood", True)
			Else
				IniWrite($IniPath, $CharName, "sellSpiritwood", False)
			EndIf


		Case $sellGoldiesCheckboxLable
			If GUICtrlRead($sellGoldiesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellGoldies", True)
			Else
				IniWrite($IniPath, $CharName, "sellGoldies", False)
			EndIf
		Case $sellGoldiesCheckbox
			If GUICtrlRead($sellGoldiesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellGoldies", True)
			Else
				IniWrite($IniPath, $CharName, "sellGoldies", False)
			EndIf

		Case $sellbluereq0scytheCheckbox
			If GUICtrlRead($sellbluereq0scytheCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellreq0scythe", True)
			Else
				IniWrite($IniPath, $CharName, "sellreq0scythe", False)
			EndIf
		Case $sellbluereq0scytheCheckboxLable
			If GUICtrlRead($sellbluereq0scytheCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "sellreq0scythe", True)
			Else
				IniWrite($IniPath, $CharName, "sellreq0scythe", False)
			EndIf

;~ 		Case $ChestSkaleFinCheckboxLable
;~ 			If GUICtrlRead($ChestSkaleFinCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleFin", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleFin", False)
;~ 			EndIf
;~ 		Case $ChestSkaleFinCheckbox
;~ 			If GUICtrlRead($ChestSkaleFinCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleFin", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleFin", False)
;~ 			EndIf

		Case $ChestMapPiecesCheckboxLable
			If GUICtrlRead($ChestMapPiecesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestMapPieces", True)
			Else
				IniWrite($IniPath, $CharName, "ChestMapPieces", False)
			EndIf
		Case $ChestMapPiecesCheckbox
			If GUICtrlRead($ChestMapPiecesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestMapPieces", True)
			Else
				IniWrite($IniPath, $CharName, "ChestMapPieces", False)
			EndIf

;~ 		Case $ChestSkaleClawCheckboxLable
;~ 			If GUICtrlRead($ChestSkaleClawCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleClaw", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleClaw", False)
;~ 			EndIf
;~ 		Case $ChestSkaleClawCheckbox
;~ 			If GUICtrlRead($ChestSkaleClawCheckbox) = $GUI_CHECKED Then
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleClaw", True)
;~ 			Else
;~ 				IniWrite($IniPath, $CharName, "ChestSkaleClaw", False)
;~ 			EndIf

		Case $ChestLockpicksCheckboxLable
			If GUICtrlRead($ChestLockpicksCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestLockpicks", True)
			Else
				IniWrite($IniPath, $CharName, "ChestLockpicks", False)
			EndIf
		Case $ChestLockpicksCheckbox
			If GUICtrlRead($ChestLockpicksCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestLockpicks", True)
			Else
				IniWrite($IniPath, $CharName, "ChestLockpicks", False)
			EndIf

		Case $ChestEventItemsCheckbox
			If GUICtrlRead($ChestEventItemsCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestEventItems", True)
			Else
				IniWrite($IniPath, $CharName, "ChestEventItems", False)
			EndIf

		Case $ChestTomesCheckbox
			If GUICtrlRead($ChestTomesCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestTomes", True)
			Else
				IniWrite($IniPath, $CharName, "ChestTomes", False)
			EndIf

		Case $ChestDysCheckbox
			If GUICtrlRead($ChestDysCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestDys", True)
			Else
				IniWrite($IniPath, $CharName, "ChestDys", False)
			EndIf
		Case $ChestMatsCheckbox
			If GUICtrlRead($ChestMatsCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, $CharName, "ChestMats", True)
			Else
				IniWrite($IniPath, $CharName, "ChestMats", False)
			EndIf

		Case $FullHideGwCheckbox
			If GUICtrlRead($FullHideGwCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, "Settings", "FullHideGw ", True)
			Else
				IniWrite($IniPath, "Settings", "FullHideGw ", False)
			EndIf
		Case $FullHideGwCheckboxLable
			If GUICtrlRead($FullHideGwCheckbox) = $GUI_CHECKED Then
				IniWrite($IniPath, "Settings", "FullHideGw ", True)
			Else
				IniWrite($IniPath, "Settings", "FullHideGw ", False)
			EndIf

	EndSwitch

	Local $IOLine = ""
	For $i = 0 To 11
				If GUICtrlRead($DistrictCheckboxes[$i]) = $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "District", $IOLine)

	Local $tabNr = getTabNrByName("ChestTab")
	Local $IOLine = ""
	For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				$IOLine &= "1,"
			Else
				$IOLine &= "0,"
			EndIf
	Next
	IniWrite($IniPath, $CharName, "EnableMove", $IOLine)

	Local $tabNr = getTabNrByName("BagsTab")
	Local $IOLine = ""
	For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				$IOLine &= "1,"
			Else
				$IOLine &= "0,"
			EndIf
	Next
	IniWrite($IniPath, $CharName, "Bags", $IOLine)

	Local $IOLine = ""
	For $i = 1 To 28
				If GUICtrlRead(DllStructGetData($LootEventItemsStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "LootEventItems", $IOLine)


	Local $IOLine = ""
	For $i = 1 To 12
				If GUICtrlRead(DllStructGetData($LootDyeStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "LootDye", $IOLine)

	Local $IOLine = ""
	For $i = 1 To 20
				If GUICtrlRead(DllStructGetData($LootTomesStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "LootTome", $IOLine)

	Local $IOLine = ""
	For $i = 1 To 28
				If GUICtrlRead(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "StoreEventItems", $IOLine)


	Local $IOLine = ""
	For $i = 1 To 12
				If GUICtrlRead(DllStructGetData($StoreDyeStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "StoreDye", $IOLine)

	Local $IOLine = ""
	For $i = 1 To 20
				If GUICtrlRead(DllStructGetData($StoreTomesStruct,"Checkbox",$i)) == $GUI_CHECKED Then
					$IOLine &= "1,"
				Else
					$IOLine &= "0,"
				EndIf
	Next
	IniWrite($IniPath, $CharName, "StoreTome", $IOLine)

	Local $tabNr = getTabNrByName("StoreMatsTab")
	Local $IOLine = ""
	For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				$IOLine &= "1,"
			Else
				$IOLine &= "0,"
			EndIf
	Next
	IniWrite($IniPath, $CharName, "StoreMats", $IOLine)

	Local $tabNr = getTabNrByName("LootMatsTab")
	Local $IOLine = ""
	For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				$IOLine &= "1,"
			Else
				$IOLine &= "0,"
			EndIf
	Next
	IniWrite($IniPath, $CharName, "LootMats", $IOLine)

	If $SalvageRunning Then
		IniWrite($IniPath, $CharName, "SalvageRunning", True)
	Else
		IniWrite($IniPath, $CharName, "SalvageRunning", False)
	EndIf

	Local $tabNr = getTabNrByName("SalvageTab")
	Local $IOLine = ""
	For $GDIIndex = 1 To DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusCount")
			If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$GDIIndex) Then
				$IOLine &= "1,"
			Else
				$IOLine &= "0,"
			EndIf
	Next
	IniWrite($IniPath, $CharName, "SalvageItems", $IOLine)

EndFunc

Func loadIni()
	$PlayerStatus = IniRead($IniPath, $CharName, "PlayerStatus", 1) ; 0 Offline | 1 Online |2 Do not disturb | 3 Away

	If IniRead($IniPath, $CharName, "AutoStart", False) == False Then
		WinMove($MainGUI,"",IniRead($IniPath, $CharName, "GuiX",100 + $LeftGuiWidth),IniRead($IniPath, $CharName, "GuiY", 100))
	EndIf

	If IniRead($IniPath, $CharName, "useGh", False) == True Then
		GUICtrlSetState($useGhCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($useGhCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "GuiOnTop", True) == True Then
		GUICtrlSetState($GuiOnTopCheckbox,$GUI_CHECKED)
		WinSetOnTop($MainGUI,"",1)
	Else
		GUICtrlSetState($GuiOnTopCheckbox,$GUI_UNCHECKED)
		WinSetOnTop($MainGUI,"",0)
	EndIf

	If IniRead($IniPath, $CharName, "DisableRendering", False) == True Then
		ToggleRendering(False)
	Else
		GUICtrlSetState($RenderingBox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "Goldies", True) == True Then
		GUICtrlSetState($LootGoldiesCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($LootGoldiesCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "Loot GlacialStone", True) == True Then
		GUICtrlSetState($LootGlacialStoneCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($LootGlacialStoneCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "Loot MapPieces", True) == True Then
		GUICtrlSetState($LootMapPiecesCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($LootMapPiecesCheckbox,$GUI_UNCHECKED)
	EndIf

		If IniRead($IniPath, $CharName, "Loot IronItems", True) == True Then
		GUICtrlSetState($LootIronItemsCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($LootIronItemsCheckbox,$GUI_UNCHECKED)
	EndIf

;~ 	If IniRead($IniPath, $CharName, "Loot Req0Scythe", True) == True Then
;~ 		GUICtrlSetState($LootReq0ScytheCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($LootReq0ScytheCheckbox,$GUI_UNCHECKED)
;~ 	EndIf

	If IniRead($IniPath, $CharName, "sellSpiritwood", True) == True Then
		GUICtrlSetState($sellSpiritwoodCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($sellSpiritwoodCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "sellGoldies", True) == True Then
		GUICtrlSetState($sellGoldiesCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($sellGoldiesCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "sellreq0scythe", True) == True Then
		GUICtrlSetState($sellbluereq0scytheCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($sellbluereq0scytheCheckbox,$GUI_UNCHECKED)
	EndIf


;~ 	If IniRead($IniPath, $CharName, "ChestSkaleFin", True) == True Then
;~ 		GUICtrlSetState($ChestSkaleFinCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($ChestSkaleFinCheckbox,$GUI_UNCHECKED)
;~ 	EndIf

	If IniRead($IniPath, $CharName, "ChestMapPieces", False) == True Then
		GUICtrlSetState($ChestMapPiecesCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestMapPiecesCheckbox,$GUI_UNCHECKED)
	EndIf

;~ 	If IniRead($IniPath, $CharName, "ChestSkaleClaw", False) == True Then
;~ 		GUICtrlSetState($ChestSkaleClawCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($ChestSkaleClawCheckbox,$GUI_UNCHECKED)
;~ 	EndIf

	If IniRead($IniPath, $CharName, "ChestLockpicks", True) == True Then
		GUICtrlSetState($ChestLockpicksCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestLockpicksCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "ChestEventItems", False) == True Then
		GUICtrlSetState($ChestEventItemsCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestEventItemsCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "ChestTomes", False) == True Then
		GUICtrlSetState($ChestTomesCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestTomesCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "ChestDys", True) == True Then
		GUICtrlSetState($ChestDysCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestDysCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, $CharName, "ChestMats", True) == True Then
		GUICtrlSetState($ChestMatsCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($ChestMatsCheckbox,$GUI_UNCHECKED)
	EndIf

	If IniRead($IniPath, "Settings", "FullHideGw ", True) == True Then
		GUICtrlSetState($FullHideGwCheckbox,$GUI_CHECKED)
	Else
		GUICtrlSetState($FullHideGwCheckbox,$GUI_UNCHECKED)
	EndIf

;~ 	If IniRead($IniPath, $CharName, "salvageBramble", True) == True Then
;~ 		GUICtrlSetState($Salvage_BrambleCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($Salvage_BrambleCheckbox,$GUI_UNCHECKED)
;~ 	EndIf
;~ 	If IniRead($IniPath, $CharName, "salvageDragonroot", True) == True Then
;~ 		GUICtrlSetState($Salvage_DragonrootCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($Salvage_DragonrootCheckbox,$GUI_UNCHECKED)
;~ 	EndIf
;~ 	If IniRead($IniPath, $CharName, "salvageSpiritwood", False) == True Then
;~ 		GUICtrlSetState($Salvage_SpiritwoodCheckbox,$GUI_CHECKED)
;~ 	Else
;~ 		GUICtrlSetState($Salvage_SpiritwoodCheckbox,$GUI_UNCHECKED)
;~ 	EndIf

	Local $tabNr = getTabNrByName("ChestTab")
	Local $IOArray[3] = [2,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "EnableMove", "1") ;default setting
	$IOArray = StringSplit($IOLine,",")
	For $GDIIndex = 1 To $IOArray[0]
		If  $IOArray[$GDIIndex] == "1" Then
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", True, $GDIIndex)
		Else
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", False, $GDIIndex)
		EndIf
	Next

	Local $tabNr = getTabNrByName("BagsTab")
	Local $IOArray[15] = [14,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "Bags", "1,1,1,1,1,1,1,1,1,0,0,0,0,1") ;default setting
	$IOArray = StringSplit($IOLine,",")
	For $GDIIndex = 1 To $IOArray[0]
		If  $IOArray[$GDIIndex] == "1" Then
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", True, $GDIIndex)
		Else
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", False, $GDIIndex)
		EndIf
	Next

	Local $IOArray[13] = [12,0,0,1,0,0,0,0,0,1,1,1,1] ;default setting
	Local $IOLine =  IniRead($IniPath, $CharName, "District", "0,0,0,0,1,0,0,0,0,0,0,0,")
	$IOArray = StringSplit($IOLine,",")
;~ 	MsgBox(0,0,$IOLine)
;~ 	_ArrayDisplay($IOArray)
	For $DisIndex = 0 To 11
		If  $IOArray[$DisIndex+1] == "1" Then
			GUICtrlSetState($DistrictCheckboxes[$DisIndex], $GUI_CHECKED)
		Else
			GUICtrlSetState($DistrictCheckboxes[$DisIndex], $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[29] = [28,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "LootEventItems", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") ;default setting
	$IOArray = StringSplit($IOLine,",")
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($LootEventItemsStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[13] = [13,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "LootDye", "1,0,0,0,0,0,1,0,0,0,0,0") ;default setting
	$IOArray = StringSplit($IOLine,",")
;~ 	_ArrayDisplay($IOArray)
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($LootDyeStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($LootDyeStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[21] = [20,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "LootTome", "0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1") ;default setting
	$IOArray = StringSplit($IOLine,",")
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($LootTomesStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[29] = [28,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "StoreEventItems", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1") ;default setting
	$IOArray = StringSplit($IOLine,",")
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($StoreEventItemsStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[13] = [13,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "StoreDye", "1,0,0,0,0,0,1,0,0,0,0,0")
	$IOArray = StringSplit($IOLine,",")
;~ 	_ArrayDisplay($IOArray)
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($StoreDyeStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($StoreDyeStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $IOArray[21] = [20,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	Local $IOLine =  IniRead($IniPath, $CharName, "StoreTome", "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1")
	$IOArray = StringSplit($IOLine,",")
	For $i = 0 To $IOArray[0]
		If  $IOArray[$i] == "1" Then
			GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i), $GUI_CHECKED)
		Else
			GUICtrlSetState(DllStructGetData($StoreTomesStruct,"Checkbox",$i), $GUI_UNCHECKED)
		EndIf
	Next

	Local $tabNr = getTabNrByName("StoreMatsTab")
	Local $IOArray[36] = [0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	Local $IOLine =  IniRead($IniPath, $CharName, "StoreMats", "0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
	$IOArray = StringSplit($IOLine,",")
	For $GDIIndex = 1 To 36
		If  $IOArray[$GDIIndex] == "1" Then
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", True, $GDIIndex)
		Else
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", False, $GDIIndex)
		EndIf
	Next

	Local $tabNr = getTabNrByName("LootMatsTab")
	Local $IOArray[36] = [1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	Local $IOLine =  IniRead($IniPath, $CharName, "LootMats", "1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1")
	$IOArray = StringSplit($IOLine,",")
	For $GDIIndex = 1 To 36
		If  $IOArray[$GDIIndex] == "1" Then
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", True, $GDIIndex)
		Else
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", False, $GDIIndex)
		EndIf
	Next

	Local $tabNr = getTabNrByName("SalvageTab")
	Local $IOArray[9] = [8,0,0,0,0,0,0,1,0]
	Local $IOLine =  IniRead($IniPath, $CharName, "SalvageItems", "0,0,0,0,0,0,1,0")
	$IOArray = StringSplit($IOLine,",")
	For $GDIIndex = 1 To $IOArray[0]
		If  $IOArray[$GDIIndex] == "1" Then
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", True, $GDIIndex)
		Else
			DllStructSetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked", False, $GDIIndex)
		EndIf
	Next

	If IniRead($IniPath, $CharName, "SalvageRunning", False) == True Then
		$SalvageRunning = True
		GUICtrlSetData($StartSalvageButton,'pause salvage')
	Else
		$SalvageRunning = False
		GUICtrlSetData($StartSalvageButton,'start salvage')
	EndIf

EndFunc




;~ Func _MinimizeLeftGuiSide()
;~ 	_showOnlyTabs("GlogboxTab")
;~ EndFunc

#cs
Func test()
	ConsoleWrite('________________________TEST________________________' & @CRLF)
	ConsoleWrite(@CRLF)
	Local $ModelID
	Local $Type
	Local $ExtraID
	Local $tabNr = getTabNrByName("InventoryTab")
	Local $iBag, $iSlot
	For $iBag = 1 To 2
		If DllStructGetData($TabArrayOfStructs[$tabNr],"GDIPlusTicked",$iBag) Then
			For $iSlot = 1 To DllStructGetData(GetBag($iBag), 'slots')
				Local $iItem = GetItemBySlot($iBag, $iSlot)
				If StackableReturnTrue($iItem) Then
					ConsoleWrite(@CRLF & "! $iSlot " & $iSlot & " ModelID "  & DllStructGetData($iItem, "ModelID"))
					ConsoleWrite(@TAB & @TAB & "Type "  & DllStructGetData($iItem, "Type"))
					ConsoleWrite(@TAB & @TAB & "ExtraID "  & DllStructGetData($iItem, "ExtraID"))
					ConsoleWrite(@TAB & @TAB & "canMoveItem "  & canMoveItem($iItem))
					ConsoleWrite(@TAB & @TAB & "checkboxID "  & canMoveItem($iItem))
				EndIf
			Next
		EndIf
	Next
	ConsoleWrite(@CRLF)
	For $i = 1 To 12
		ConsoleWrite(@CRLF & "-checkboxID "  & DllStructGetData($StoreDyeStruct,"Checkbox",$i))
		ConsoleWrite(@TAB & @TAB & "checked "  & (GUICtrlRead(DllStructGetData($StoreDyeStruct,"Checkbox",$i)) == $GUI_CHECKED))
	Next




;~ 	For $i = 0 To UBound($DistrictCheckboxes) -1
;~ 		If GUICtrlRead($DistrictCheckboxes[$i]) == $GUI_CHECKED Then
;~ 			ConsoleWrite(@CRLF & $i & @TAB & True)
;~ 		Else
;~ 			ConsoleWrite(@CRLF & $i & @TAB & False)
;~ 		EndIf
;~ 	Next
;~ 	ConsoleWrite(@CRLF & "Region: " & @TAB & GetRegion() & @TAB & "Language: " & @TAB & GetLanguage());)
;~ 	RndTravel($MAP_ID_Jokanur, $DistrictCheckboxes)

;~ 	Local $me = GetAgentByID(-2)
;~ 	TargetNearestEnemy()
;~ 	Sleep(getping()+50)
;~ 	Local $me = GetAgentByID(-2);-1 = Target ID

;~ 	ConsoleWrite('$me: ' & DllStructGetData($me,'ID') & @CRLF)
;~ 	ConsoleWrite('my HP: ' & DllStructGetData($me,'HP') & @CRLF)

;~ 	For $i = 1 to 8
;~ 			ConsoleWrite('SkillID_'&$i&': ' & GetSkillbarSkillID($i) & @CRLF)
;~  	Next


	;~ 	ConsoleWrite('Dash Recharche: ' & GetSkillbarSkillRecharge($Skill_Dash) &  @CRLF)


	;....byte Team;byte unknown14[6];float EnergyPips;byte unknown[4];float EnergyPercent;long MaxEnergy;byte unknown15[4];float HPPips;byte unknown16[4];float HP;long MaxHP;long Effects;byte unknown17[4];byte Hex;byte unknown18[18];long ModelState;long TypeMap;byte unknown19[16];long InSpiritRange;byte unknown20[16];long LoginNumber;float ModelMode;byte unknown21[4];long ModelAnimation;byte unknown22[32];byte LastStrike;byte Allegiance;word WeaponType;word Skill;byte unknown23[4];word WeaponItemId;word OffhandItemId')

#cs ;DLLgetData
;~ 	ConsoleWrite('vtable: '  & @TAB & DllStructGetData($me,'vtable') & @CRLF)
;~ 	ConsoleWrite('unknown1[24]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown1[24]') & @CRLF)
;~ 	ConsoleWrite('unknown2[4]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown2[4]') & @CRLF)
	ConsoleWrite('NextAgent: '  & @TAB  & DllStructGetData($me,'NextAgent') & @CRLF)
;~ 	ConsoleWrite('unknown3[8]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown3[8]') & @CRLF)
	ConsoleWrite('Id: ' &  @TAB & @TAB  &DllStructGetData($me,'Id') & @CRLF)
;~ 	ConsoleWrite('Z: ' &  @TAB & @TAB  &DllStructGetData($me,'Z') & @CRLF)
;~ 	ConsoleWrite('unknown4[8]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown4[8]') & @CRLF)
;~ 	ConsoleWrite('BoxHoverWidth: ' & @TAB & @TAB  & DllStructGetData($me,'BoxHoverWidth') & @CRLF)
;~ 	ConsoleWrite('BoxHoverHeight: ' & @TAB & @TAB  & DllStructGetData($me,'BoxHoverHeight') & @CRLF)
;~ 	ConsoleWrite('unknown5[8]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown5[8]') & @CRLF)
;~ 	ConsoleWrite('unknown6[8]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown6[8]') & @CRLF)
;~ 	ConsoleWrite('NameProperties: ' & @TAB & @TAB  & DllStructGetData($me,'NameProperties') & @CRLF)
;~ 	ConsoleWrite('unknown7[24]: ' & @TAB & @TAB  & DllStructGetData($me,'unknown7[24]') & @CRLF)
	ConsoleWrite('X: ' & @TAB & @TAB  & Round(DllStructGetData($me,'X')) & @CRLF)
	ConsoleWrite('Y: ' &  @TAB & @TAB  &Round(DllStructGetData($me,'Y')) & @CRLF)
;~ 	ConsoleWrite('unknown8[8]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown8[8]') & @CRLF)
;~ 	ConsoleWrite('NameTagX: '  & @TAB  &DllStructGetData($me,'NameTagX') & @CRLF)
;~ 	ConsoleWrite('NameTagY: '  & @TAB  & DllStructGetData($me,'NameTagY') & @CRLF)
;~ 	ConsoleWrite('NameTagZ: '  & @TAB  &DllStructGetData($me,'NameTagZ') & @CRLF)
;~ 	ConsoleWrite('unknown9[12]: ' &  @TAB &DllStructGetData($me,'unknown9[12]') & @CRLF)
	ConsoleWrite('Type: ' &  @TAB & @TAB  &DllStructGetData($me,'Type') & @CRLF)
	ConsoleWrite('MoveX: ' &  @TAB & @TAB  &DllStructGetData($me,'MoveX') & @CRLF)
	ConsoleWrite('MoveY: ' &  @TAB & @TAB  &DllStructGetData($me,'MoveY') & @CRLF)
;~ 	ConsoleWrite('unknown10[28]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown10[28]') & @CRLF)
;~ 	ConsoleWrite('Owner: ' &  @TAB & @TAB  &DllStructGetData($me,'Owner') & @CRLF)
;~ 	ConsoleWrite('unknown30[8]: '  & @TAB  &DllStructGetData($me,'unknown30[8]') & @CRLF)
;~ 	ConsoleWrite('ExtraType: '  & @TAB  &DllStructGetData($me,'ExtraType') & @CRLF)
;~ 	ConsoleWrite('unknown11[24]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown11[24]') & @CRLF)
;~ 	ConsoleWrite('AttackSpeed: ' &  @TAB & @TAB  &DllStructGetData($me,'AttackSpeed') & @CRLF)
;~ 	ConsoleWrite('AttackSpeedModifier: ' &  @TAB & @TAB  &DllStructGetData($me,'AttackSpeedModifier') & @CRLF)
;~ 	ConsoleWrite('PlayerNumber: ' &  @TAB & @TAB  &DllStructGetData($me,'PlayerNumber') & @CRLF)
;~ 	ConsoleWrite('unknown12[6]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown12[6]') & @CRLF)
;~ 	ConsoleWrite('Equip: ' &  @TAB & @TAB  &DllStructGetData($me,'Equip') & @CRLF)
;~ 	ConsoleWrite('unknown13[10]: ' &  @TAB & @TAB  &DllStructGetData($me,'unknown13[10]') & @CRLF)
	ConsoleWrite('Primary: '  & @TAB  &DllStructGetData($me,'Primary') & @CRLF)
	ConsoleWrite('Secondary: '  & @TAB  &DllStructGetData($me,'Secondary') & @CRLF)
	ConsoleWrite('Level: '  & @TAB & @TAB   &DllStructGetData($me,'Level') & @CRLF)
;~ 	ConsoleWrite('Team: ' &  @TAB & @TAB  &DllStructGetData($me,'Team') & @CRLF)

	ConsoleWrite('MaxHP: '  & @TAB & @TAB   &DllStructGetData($me,'MaxHP') & @CRLF)
	ConsoleWrite('HP: ' &  @TAB & @TAB  & Round(DllStructGetData($me,'HP'),2) & @CRLF)
	ConsoleWrite('Total HP: ' & @TAB  & Round(DllStructGetData($me,'HP')*DllStructGetData($me,'MaxHP')) & @CRLF)
	ConsoleWrite('................' & @CRLF)
#ce
;~ 	ConsoleWrite('SkaleNumber in Range: ' & GetNumberOfFoesInRangeOfAgent() & @CRLF)

#cs ;GetNumberOfLvlXSkalsInRangeOfAgent
ConsoleWrite('Lvl 2 Skales in Range: ' & GetNumberOfLvlXSkalsInRangeOfAgent(-1,2000) & @CRLF)
GetFarthestEnemyToAgent_Number_Agent_Dist_Lvl(12,-2,2200)
Sleep(getping())
CallTarget(-1)
#ce

#cs
	TargetNearestEnemy()
	Sleep(getping())
	ConsoleWrite('jump2 Distance = ' & GetDistance() & @CRLF)
	If 650 < GetDistance() Then UseSkillEx($Skill_DC,-1)
	ConsoleWrite('next = ' & GetDistance() & @CRLF)
#ce

;~ getAngleAtA()

EndFunc

#ce