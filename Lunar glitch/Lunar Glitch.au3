#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>

#include <GWA2.au3>

Opt('GUIOnEventMode', 1)
Opt('TrayOnEventMode', 1)
Opt('TrayAutoPause', 0)
OnAutoItExitRegister('_Exit')

Global $bRunning = False

Const $Rock = 13
Const $Paper = 64
Const $Scissors = 198
Const $DialogID = 0x84
Global Const $BlueSoda = 21812

Global $TrayRendering, $TrayMemory, $TrayHideWindow, $hGW, $GWPID
Global $Rendering = True, $MemAdLibReg = False

#Region Character Selector
Global $CharacterName, $CharacterNames = GetLoggedCharNames()
Global $StandardCharacterName = ''

Global $gCharacterSelector, $gCharacterName, $gCharacterStart, $gCharacterEnd

;~ Description: Create the character selector GUI
Func CharacterSelector()
   $gCharacterSelector = GUICreate('Select Character', 300, 70)

   GUICtrlCreateGroup ('Enter Character Name', 10, 10, 280, 50)

   $gCharacterName = GUICtrlCreateCombo('', 20, 30, 130, 20)
   GUICtrlSetData($gCharacterName, $CharacterNames, $StandardCharacterName)
   $gCharacterStart = GUICtrlCreateButton('Initialize Client', 155, 29, 80, 21)
   $gCharacterEnd = GUICtrlCreateButton('Cancel', 237, 29, 45, 21)

   GUICtrlSetState($gCharacterStart, $GUI_DEFBUTTON)

   GUICtrlSetOnEvent($gCharacterStart, 'CharacterEventHandler')
   GUICtrlSetOnEvent($gCharacterEnd, 'CharacterEventHandler')
   GUICtrlSetOnEvent($GUI_EVENT_CLOSE, 'CharacterEventHandler')
   GUISetOnEvent($GUI_EVENT_CLOSE, 'CharacterEventHandler')

   GUISetState()
EndFunc ;==>CharacterSelector

;~ Description: EventHandler for character selector GUI
Func CharacterEventHandler()
   Switch (@GUI_CtrlId)
	  Case $gCharacterStart
		 GUICtrlSetState($gCharacterName, $GUI_DISABLE)
		 GUICtrlSetState($gCharacterStart, $GUI_DISABLE)
		 GUICtrlSetData($gCharacterStart, 'Initializing ...')

		 $CharacterName = GUICtrlRead($gCharacterName)
		 If Not Initialize($CharacterName) Then
			MsgBox(0, 'Error', 'Guild Wars Window/Charactername not found.')
			Exit
		 EndIf

		 $hGW = GetWindowHandle()
		 $GWPID = WinGetProcess($hGW)

		 TraySetToolTip('Rock Paper Scissors Bot - ' & $CharacterName)
		 $TrayRendering = TrayCreateItem('Disable Rendering')
		 $TrayMemory = TrayCreateItem('Limit Memory')
		 TrayItemSetState($TrayMemory, $TRAY_DISABLE)
		 TrayCreateItem('')
		 $TrayHideWindow = TrayCreateItem('Hide Client')

		 TrayItemSetOnEvent($TrayRendering, 'TrayEvents')
		 TrayItemSetOnEvent($TrayMemory, 'TrayEvents')
		 TrayItemSetOnEvent($TrayHideWindow, 'TrayEvents')

		 $bRunning = True

		 GUIDelete($gCharacterSelector)
	  Case $GUI_EVENT_CLOSE
		 Exit
	  Case $gCharacterEnd
		 Exit
   EndSwitch
EndFunc ;==>CharacterEventHandler()
#EndRegion Character Selector

CharacterSelector()

While 1
	If Not $bRunning Then ContinueLoop
	If Not CountTokens() Then
		Exit MsgBox(0x40030, 'Error!', 'You have run out of Lunar Tokens.')
	EndIf
	use_soda()
	Local $Target = GetAgentByID(-1)

	GoNPC($Target)
	Sleep(Random(400, 500, 1))
	Dialog($DialogID)
	Local $NpcAnimation

	Local $StuckTimer = TimerInit()

	Do
		Sleep(50)
		$Target = GetAgentByID(-1)
		$NpcAnimation = DllStructGetData($Target, 'ModelAnimation')
		If TimerDiff($StuckTimer) > 320000 Then ExitLoop
	Until $NpcAnimation == $Rock

	If TimerDiff($StuckTimer) > 320000 Then ContinueLoop

	Local $LastAnimation, $PlayTimer = TimerInit()
	Do
		Sleep(50)
		$Target = GetAgentByID(-1)
		Local $bLastAnimation = DllStructGetData($Target, 'ModelAnimation')
		If $bLastAnimation == $Rock Or $bLastAnimation == $Paper Or $bLastAnimation == $Scissors Then
			$LastAnimation = $bLastAnimation
		EndIf
	Until TimerDiff($PlayTimer) > Random(8400, 8600, 1)

	Switch $LastAnimation
		Case $Rock
			SendChat('paper', '/')
		Case $Paper
			SendChat('scissors', '/')
		Case $Scissors
			SendChat('rock', '/')
	EndSwitch

	Do
		$Target = GetAgentByID(-1)
		$NpcAnimation = DllStructGetData($Target, 'ModelAnimation')
		If TimerDiff($StuckTimer) > 320000 Then ExitLoop
		Sleep(50)
	Until $NpcAnimation <> $Rock And $NpcAnimation <> $Paper And $NpcAnimation <> $Scissors

	If TimerDiff($StuckTimer) > 320000 Then ContinueLoop

	$Playtimer = TimerInit()

	Do
		Sleep(50)
	Until TimerDiff($PlayTimer) > Random(4900, 5100, 1)
WEnd

Func use_soda()
   Local $item
   For $bag=1 To 4
	  For $slot=1 To DllStructGetData(GetBag($bag), 'Slots')
		 $item = GetItemBySlot($bag, $slot)
		 If DllStructGetData($item, 'ModelID') == $BlueSoda Then
			For $i=1 To DllStructGetData($item, 'Quantity')
				UseItem($item)
			Next
		 EndIf
	  Next
   Next
   Return
EndFunc

Func TrayEvents()
	Switch @TRAY_ID
		Case $TrayRendering
			If $Rendering Then
				TrayItemSetState($TrayMemory, $TRAY_ENABLE)
				DisableRendering()
			Else
				TrayItemSetState($TrayMemory, $TRAY_DISABLE)
				If $MemAdLibReg Then
					$MemAdLibReg = False
					TrayItemSetState($TrayMemory, $TRAY_UNCHECKED)
					AdlibUnRegister('LimitMemory')
				EndIf
				EnableRendering()
			EndIf
			$Rendering = Not $Rendering

		Case $TrayMemory
			If Not $MemAdLibReg Then
				ClearMemory()
				AdlibRegister('LimitMemory', 150000)
			Else
				AdlibUnRegister('LimitMemory')
			EndIf
			$MemAdLibReg = Not $MemAdLibReg

		Case $TrayHideWindow
			If BitAND(WinGetState($hGW), 2) Then
				WinSetState($hGW, '', @SW_HIDE)
			Else
				WinSetState($hGW, '', @SW_SHOW)
			EndIf
	EndSwitch
EndFunc

Func CountTokens()
	Local $aBag, $aItem, $nTokens
	Const $LunarTokens = 21833

	For $b = 1 To 4
		$aBag = GetBag($b)
		For $s = 1 To DllStructGetData($aBag, 'Slots')
			$aItem = GetItemBySlot($b, $s)
			If DllStructGetData($aItem, 'ModelID') == $LunarTokens Then
				$nTokens += DllStructGetData($aItem, 'Quantity')
			EndIf
		Next
	Next

	Return $nTokens
EndFunc

Func LimitMemory()
	Local $ProcessStats = ProcessGetStats($GWPID, 0)
	Local $ProcessSizeMB = $ProcessStats[0] / 1048576

	If $ProcessSizeMB > 200 Then
		ClearMemory()
		Sleep(500)
	EndIf
EndFunc

Func _Exit()
	If BitAND(WinGetState($hGW), 2) <> 2 Then WinSetState($hGW, '', @SW_SHOW)
	If Not $Rendering Then EnableRendering()
EndFunc