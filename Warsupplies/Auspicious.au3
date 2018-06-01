#include "GUIConstantsEx.au3"
#include "WindowsConstants.au3"
#include "StaticConstants.au3"
#include "GuiEdit.au3"
#include "../GWA2.au3"

#NoTrayIcon

#cs	~~~howto~~~
needed:	 random char that has access to eotn/hom
		 keirans's bow on weapon slot 4 (you can get that bow using this bot)
		 your preferred fighting bow on weapon slot 3
		 some inventory space
#ce		 some capability for storing platin

Opt("GUIOnEventMode", True)
Opt("GUICloseOnESC", False)
Opt("MustDeclareVars", True)

#Region Declaration
	Global Const $MAP_ID_EOTN = 642
   	Global Const $MAP_ID_HOM = 646
	Global Const $MAP_ID_WATCHTOWER_COAST = 849
	Global Const $MODEL_ID_WAR_SUPPLIES = 35121
	Global Const $MODEL_ID_CONFESSORS_ORDERS = 35123
	Global $rendering = True
	Global $boolrun = False
	Global $startcash, $startvanguard, $startwarsupplies, $startconfessorsorders
	Global $runs = 0, $failrunscount = 0
	Global $charname, $mskilltimer, $ndeadlock
	Global $mblockeddirection = 0, $mcasttime = -1, $mlasttarget = 0, $mexitcycle = False
	Global $mteam, $mteamothers, $mteamdead, $menemies, $menemiesrange, $menemiesspellrange, $mspirits
	Global $mpets, $mminions, $mmiku, $mself, $mselfid, $mlowestally, $mlowestallyhp, $mlowestotherally
	Global $mlowestotherallyhp, $mlowestenemy, $mlowestenemyhp, $mclosestenemy, $mclosestenemydist
	Global $move = False, $mx, $my, $meffects, $mskillbar, $menergy, $mcycle
	Global $mdazed = False, $mblind = False, $mblocking = False
	Global $mskillhardcounter = False, $mskillsoftcounter = 0
	Global $mattackhardcounter = False, $mattacksoftcounter = 0
	Global $mallyspellhardcounter = False, $menemyspellhardcounter = False, $mspellsoftcounter = 0
	Global $lastwptx, $lastwpty, $wptcount
#EndRegion Declaration

build_gui()

While True
	If $boolrun Then
		main()
		GUICtrlSetData($lblvanguard, getvanguardtitle() - $startvanguard)
		GUICtrlSetData($lblgold, getgoldcharacter() - $startcash)
		GUICtrlSetData($lblws, CountInventoryItem($MODEL_ID_WAR_SUPPLIES) - $startwarsupplies & " ( +" & Int( ( CountInventoryItem($MODEL_ID_CONFESSORS_ORDERS) - $startconfessorsorders ) / 3) & " )")
		GUICtrlSetData($lblruns, $runs)
		GUICtrlSetData($lblfailrunscount, $failrunscount)
		Sleep(500)
	 EndIf
	 Sleep(500)
WEnd

Func build_gui()
   Local $logged_chars = GetLoggedCharNames()
   Global $cgui = GUICreate("Auspicious Beginnings", 270, 435, 200, 180)
#cs   Global $cbxidsell = GUICtrlCreateCheckbox("ID/Sell Items", 8, 8, 110, 17)
	  GUICtrlSetState(-1, $gui_disable)
	  Global $goldz = GUICtrlCreateCheckbox("Store Golds", 135, 30, 75, 17)
	  GUICtrlSetState(-1, $gui_disable)
   Global $cbxpickall = GUICtrlCreateCheckbox("Pick all items", 8, 30, 110, 17)
#ce	  GUICtrlSetState(-1, $gui_disable)
   Global $btngetbow = GUICtrlCreateButton("Get Keiran's Bow", 8, 8, 110, 39)
	  GUICtrlSetState(-1, $gui_disable)
	  GUICtrlSetOnEvent(-1, "EventHandler")
   Global $cbxontop = GUICtrlCreateCheckbox("Allways on top", 135, 30, 110, 17)
	  GUICtrlSetState(-1, $gui_disable)
	  GUICtrlSetOnEvent(-1, "EventHandler")
   Global $cbxhidegw = GUICtrlCreateCheckbox("Disable Graphics", 135, 8, 110, 17)
	  GUICtrlSetState(-1, $gui_disable)
	  GUICtrlSetOnEvent(-1, "EventHandler")
   GUICtrlCreateLabel("Character Name:", 8, 65, 80, 17, BitOR($ss_center, $ss_centerimage))
   Global $inputcharname = GUICtrlCreateCombo("", 8, 65, 255, 17)
	  If ($logged_chars == "") Then
		 GUICtrlSetState(-1, $GUI_DISABLE)
	  Else
		 GUICtrlSetData(-1, $logged_chars, StringSplit($logged_chars, "|", 2)[0])
	  EndIf
   GUICtrlCreateLabel("Fail Runs: ", 8, 89, 113, 17)
   Global $lblfailrunscount = GUICtrlCreateLabel("-", 140, 89, 100, 17, BitOR($ss_center, $ss_centerimage))
   GUICtrlCreateLabel("Succes Runs: ", 8, 112, 130, 17)
   Global $lblruns = GUICtrlCreateLabel("-", 140, 112, 100, 17, $ss_center)
   GUICtrlCreateLabel("Total Gold Earned:", 8, 136, 130, 17)
   Global $lblgold = GUICtrlCreateLabel("-", 140, 136, 100, 17, $ss_center)
   GUICtrlCreateLabel("Total Faction Earned:", 8, 160, 130, 17)
   Global $lblvanguard = GUICtrlCreateLabel("-", 140, 160, 100, 17, $ss_center)
   GUICtrlCreateLabel("War Supplies:", 8, 184, 130, 17)
   Global $lblws = GUICtrlCreateLabel("-", 140, 184, 100, 17, $ss_center)
   Global $lblstatus = GUICtrlCreateLabel("Ready to begin", 8, 208, 256, 17, $ss_center)
   Global $btnstart = GUICtrlCreateButton("load character", 7, 234, 256, 25, $ws_group)
	  GUICtrlSetOnEvent(-1, "initialize_char")
   Global $glogbox = GUICtrlCreateEdit("", 8, 262, 260, 170, 2097220)
	  GUICtrlSetLimit(-1, 0xF423F)	; 0xF423F = 999999 chars
   Global $flog = FileOpen("AusBeg.log", 1)
   GUISetOnEvent($gui_event_close, "EventHandler")
   GUISetState(@SW_SHOW, $cgui)
   Return True
EndFunc

Func main()
	Local $lgold = getgoldcharacter()
	If $lgold > 98000 Then
		travelto($MAP_ID_EOTN)
		rndsleep(1000)
		Local $cgold = GetGoldStorage()
		If $cgold + $lgold > 1000000 Then $lgold = 1000000 - $cgold
		depositgold($lgold)
		Sleep(1000)
		If getgoldcharacter() > 98000 Then
		   pause_bot("too much gold")
		EndIf
		$startcash = $startcash - $lgold
   EndIf
   If CountFreeSlots() < 1 Then
	  Local $current_war_supplies = CountInventoryItem($MODEL_ID_WAR_SUPPLIES)
	  If $current_war_supplies >= 1 And Mod($current_war_supplies, 250) > 245 Then pause_bot("no inventory space")
	  If $current_war_supplies == 0 Then pause_bot("no inventory space")
   EndIf
	If Not $rendering Then clearmemory()
    If Not $boolrun Then Return False
	If getmapid() == $MAP_ID_WATCHTOWER_COAST Then
		If runningquest() Then
			$runs = $runs + 1
			Sleep(5000)
		Else
			$failrunscount = $failrunscount + 1
			Sleep(5000)
			returntooutpost()
			Sleep(5000)
			waitmaploading($MAP_ID_HOM)
		 EndIf
		 If Not $boolrun Then pause_bot()
	ElseIf getmapid() == $MAP_ID_HOM Then
		enterquest()
	ElseIf getmapid() == $MAP_ID_EOTN OR getmapid() == 821 Then
		enterhom()
	 Else
		travelto($MAP_ID_EOTN)
	EndIf
EndFunc

Func eventhandler()
	Switch (@GUI_CtrlId)
		Case $btnstart
			$boolrun = Not $boolrun
			If $boolrun Then
			   If GetMapID() == $MAP_ID_WATCHTOWER_COAST Then
				  out("cancel pause command")
			   Else
				  out("start botting")
			   EndIf
			   GUICtrlSetData($btnstart, "pause bot")
			   GUICtrlSetData($lblstatus, "bot running")
			   GUICtrlSetState($btngetbow, $GUI_DISABLE)
			Else
			   out("bot will pause after this run")
			   GUICtrlSetData($btnstart, "pause pending - restart bot")
			   GUICtrlSetData($lblstatus, "bot running - will pause soon")
			EndIf
		Case $cbxhidegw
			clearmemory()
			togglerendering()
		 Case $btngetbow
			If $boolrun Then Return False
			GUICtrlSetState($btngetbow, $GUI_DISABLE)
			GUICtrlSetState($btnstart, $GUI_DISABLE)
			get_bow()
			GUICtrlSetState($btngetbow, $GUI_ENABLE)
			GUICtrlSetState($btnstart, $GUI_ENABLE)
		 Case $cbxontop
			If GUICtrlRead($cbxontop) == $GUI_CHECKED Then
			   WinSetOnTop($cgui, "", 1)
			Elseif GUICtrlRead($cbxontop) == $GUI_UNCHECKED Then
			   WinSetOnTop($cgui, "", 0)
			EndIf
		 Case $gui_event_close
			If Not $rendering Then
			   enablerendering()
			   $rendering = True
			   WinSetState(GetWindowHandle(), "", @SW_SHOW)
			EndIf
			Exit
	EndSwitch
EndFunc

Func initialize_char()
   If initialize(GUICtrlRead($inputcharname), True, True, True) Then
	  $charname = GetCharname()
	  GUICtrlSetState($inputcharname, $gui_disable)
	  If GUICtrlRead($inputcharname) == "" Then GUICtrlSetData($inputcharname, $charname, $charname)
	  $startvanguard = getvanguardtitle()
	  $startcash = getgoldcharacter()
	  $startwarsupplies = CountInventoryItem($MODEL_ID_WAR_SUPPLIES)
	  $startconfessorsorders = CountInventoryItem($MODEL_ID_CONFESSORS_ORDERS)
	  WinSetTitle($cgui, "", "GW: War Sup - " & $charname)
	  GUICtrlSetState($cbxhidegw, $gui_enable)
	  GUICtrlSetState($cbxontop, $gui_enable)
	  GUICtrlSetState($btngetbow, $gui_enable)
	  GUICtrlSetData($btnstart, "start bot")
	  GUICtrlSetOnEvent($btnstart, eventhandler)
	  Return True
   Else
   	  MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
	  Return False
   EndIf
EndFunc

Func enterhom()
	out("Going HoM ")
	moveto(-3477, 4245)
	moveto(-4060, 4675)
	moveto(-4448, 4952)
	move(-4779, 5209)
	waitmaploading($MAP_ID_HOM)
	rndsleep(3000)
EndFunc

Func enterquest()
	out("Entering Quest")
	Local $npc = GetNearestNPCToCoords(-6662, 6584)
	GoToNPC($npc)
	rndsleep(1000)
	changeweaponset(4)
	rndsleep(1000)
	dialog(0x632)
	waitmaploading($MAP_ID_WATCHTOWER_COAST)
	rndsleep(3000)
EndFunc

Func runningquest()
	Local $ltime
	$ltime = TimerInit()
	If getmapid() <> $MAP_ID_WATCHTOWER_COAST Then
		Return False
	EndIf
	out("Running Quest")
	If NOT aggromovetoex(11828, -4815, "wait here") Then Return False
	waitforenemies(1550, 60000)
	Global $mwaypoints[21][4] = [[11125, -5226, "Main Path 1", 1250], [10338, -5966, "Main Path 2", 1250], [9871, -6464, "Main Path 3", 1250], [8933, -8213, "Main Path 4", 1250], [7498, -8517, "Main Path 6", 1250], [5193, -8514, "Trying to skip this group", 1600], [3082, -11112, "Trying to Skip Forest", 1300], [1743, -12859, "Killing Forest Mob", 1300], [-181, -12791, "Leaving Forest", 1250], [-2728, -11695, "Main Path 16", 1250], [-2858, -11942, "Detour 17", 1250], [-4212, -12641, "Detour 18", 1250], [-4276, -12771, "Detour 19", 1250], [-6884, -11357, "Detour 20", 1250], [-9085, -8631, "Detour 22", 1250], [-13156, -7883, "Detour 23", 1250], [-13768, -8158, "Final Area 30", 1250], [-14205, -8373, "Final Area 31", 1250], [-15876, -8903, "Final Area 32", 1250], [-17109, -8978, "Final Area 33", 1250], ["WaitForEnemies", 1500, 25000, False]]
	If NOT runwaypoints() Then Return False
	out("Finished a cycle in " & Round(TimerDiff($ltime) / 60000) & " minutes.")
	Do
		Sleep(100)
	Until getmapid() = $MAP_ID_HOM OR getisdead(-2)
	rndsleep(5000)
   If getisdead(-2) Then Return False
	Return True
EndFunc

Func _purgehook()
	;togglerendering()
	;Sleep(Random(2000, 2500))
	;togglerendering()
	ClearMemory()
EndFunc

Func runwaypoints()
	Local $lx, $ly, $lmsg, $lrange
	$wptcount = 0
	For $i = 0 To 20
		$lx = $mwaypoints[$i][0]
		$ly = $mwaypoints[$i][1]
		$lmsg = $mwaypoints[$i][2]
		$lrange = $mwaypoints[$i][3]
		If IsString($lx) Then
			Call($lx, $ly, $lmsg, $lrange)
		Else
			If NOT aggromovetoex($lx, $ly, $lmsg, $lrange) Then Return False
		EndIf
		$wptcount = $wptcount + 1
	Next
	Return True
EndFunc

Func countspirits()
	Local $lshadowsong
	Local $lspiritsinrange
	If $mspirits[0] = 0 Then Return False
	For $i = 1 To $mspirits[0]
		If getdistance($mspirits[$i]) > 1500 Then ContinueLoop
		$lspiritsinrange = $lspiritsinrange + 1
		If DllStructGetData($mspirits[$i], "PlayerNumber") = 4181 Then
			$lshadowsong = True
		EndIf
	Next
	If $lspiritsinrange > 2 OR $lshadowsong Then Return True
EndFunc

Func checkforspirits($movebackx, $movebacky)
	Local $lenemy
	Local $j
	If NOT countspirits() Then Return True
	$j = 1
	Do
		If getisdead(-2) Then Return False
		If $wptcount < 4 OR $wptcount = (UBound($mwaypoints) - 1) Then Return True
		If $wptcount - $j < 0 Then Return True
		If IsString($mwaypoints[$wptcount - $j][0]) Then Return True
		out("Spirit found, running to waypoint " & $wptcount - $j)
		moveto($mwaypoints[$wptcount - $j][0], $mwaypoints[$wptcount - $j][1])
		$j = $j + 1
		$ndeadlock = TimerInit()
		Sleep(2000)
	Until NOT countspirits()
	out("Back to normal route")
	If NOT aggromovetoex($movebackx, $movebacky) Then Return False
	Return True
EndFunc

#Region CastEngine

	Func castengine($askill = False, $atarget = 0)
		If NOT $askill Then
			If TimerDiff($mskilltimer) < $mcasttime Then Return False
			$mcasttime = -1
			Local $ldeadlock = TimerInit()
			If cast() Then
				Do
					Sleep(3)
				Until $mcasttime > -1 OR TimerDiff($ldeadlock) > getping() + 175
				Return True
			EndIf
		Else
			If TimerDiff($mskilltimer) < $mcasttime Then Sleep($mcasttime - TimerDiff($mskilltimer))
			$mcasttime = -1
			Local $ldeadlock = TimerInit()
			useskill($askill, $atarget)
			Do
				Sleep(3)
			Until $mcasttime > -1 OR TimerDiff($ldeadlock) > getping() + 750
			If $mcasttime > -1 Then Sleep($mcasttime)
		EndIf
		Return False
	EndFunc

	Func canuseskill($askillslot, $aenergy = 0, $asoftcounter = 10)
		If $mskillhardcounter Then Return False
		If $mskillsoftcounter > $asoftcounter Then Return False
		If $menergy < $aenergy Then Return False
		If DllStructGetData($mskillbar, "Recharge" & $askillslot) == 0 Then
			Local $lskill = getskillbyid(DllStructGetData($mskillbar, "Id" & $askillslot))
			If DllStructGetData($mskillbar, "AdrenalineA" & $askillslot) < DllStructGetData($lskill, "Adrenaline") Then Return False
			Switch DllStructGetData($lskill, "Type")
				Case 7, 10, 3, 12, 15, 16, 19, 20, 21, 22, 26, 27, 28
				Case 14
					If $mattackhardcounter Then Return False
					If $mattacksoftcounter > $asoftcounter Then Return False
				Case 4, 5, 6, 9, 11, 24, 25
					If $mspellsoftcounter > $asoftcounter Then Return False
					If $mdazed Then
						If DllStructGetData($lskill, "Activation") > 0.25 Then Return False
					EndIf
					Switch DllStructGetData($lskill, "Target")
						Case 3, 4
							If $mallyspellhardcounter Then Return False
						Case 5, 16
							If $menemyspellhardcounter Then Return False
						Case Else
					EndSwitch
			EndSwitch
			Return True
		EndIf
		Return False
	EndFunc

#EndRegion CastEngine
#Region Events

	Func skillactivate($acaster, $atarget, $askill, $aactivation)
		If DllStructGetData($acaster, "ID") == $mselfid Then
			If DllStructGetData($atarget, "Allegiance") == 3 Then $mlasttarget = DllStructGetData($atarget, "ID")
			$mskilltimer = TimerInit()
			$mcasttime = $aactivation * 1000 + DllStructGetData($askill, "Aftercast") * 1000 + 25 - getping() / 1.75
		EndIf
	EndFunc

	Func skillcancel($acaster, $atarget, $askill)
		If DllStructGetData($acaster, "ID") == $mselfid Then
			$mskilltimer = TimerInit()
			$mcasttime = 775
		EndIf
	EndFunc

#EndRegion Events

Func waitforenemies($adist, $iideadlock, $param = False)
	Local $ltarget, $ldistance
	Local $ssdeadlock = TimerInit()
	out("Waiting For Enemies")
	Do
		$ltarget = getnearestenemytoagent(-2)
		If NOT IsDllStruct($ltarget) Then ContinueLoop
		$ldistance = getdistance($ltarget, -2)
		If $ldistance < $adist Then fight(1500)
	Until TimerDiff($ssdeadlock) > $iideadlock
	Return False
EndFunc

Func cast()
	If getisknocked($mself) Then Return False
	$mmiku = getagentbyname("Miku")
	If DllStructGetData($mself, "HP") < 0.7 OR DllStructGetData($mmiku, "HP") < 0.5 Then
		If canuseskill(6, 2) Then
			useskill(6, $mselfid)
			Return True
		EndIf
	EndIf
	If canuseskill(1, 2) Then
		For $i = 1 To $menemiesrange[0]
			If gethashex($menemiesrange[$i]) Then
				useskill(1, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	If gethascondition($mself) Then
		If canuseskill(5, 3) Then
			useskill(5, $mlowestenemy)
			Return True
		EndIf
	EndIf
	If canuseskill(3, 1) Then
		For $i = 1 To $menemiesrange[0]
			If getisbleeding($menemiesrange[$i]) OR DllStructGetData($menemiesrange[$i], "Skill") <> 0 OR gettarget($menemiesrange[$i]) == $mselfid Then
				useskill(3, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	If canuseskill(4, 1) Then
		useskill(4, $mlowestenemy)
		Return True
	EndIf
	If canuseskill(2, 2) Then
		For $i = 1 To $menemiesrange[0]
			If gethascondition($menemiesrange[$i]) OR gettarget($menemiesrange[$i]) == $mselfid Then
				useskill(2, $menemiesrange[$i])
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc

Func buildmaintenance()
	$mmiku = getagentbyname("Miku")
	If DllStructGetData($mself, "HP") < 0.7 OR DllStructGetData($mmiku, "HP") < 0.5 Then
		If canuseskill(6, 2) Then
			useskill(6, $mselfid)
			Return True
		EndIf
	EndIf
	Return False
EndFunc

Func fight($arange)
	Local $nx, $ny, $rnd, $rndrange, $mlasttarget, $ndeadlock, $magent
	update($arange)
	If $move Then move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y"), 250)
	$mlasttarget = DllStructGetData(-1, "ID")
	$ndeadlock = TimerInit()
	Do
		If getisdead($mself) Then ExitLoop
		If TimerDiff($ndeadlock) > 30000 Then
			out("Obstructed")
			$magent = getagentbyname("Miku")
			moveto(DllStructGetData($magent, "X"), DllStructGetData($magent, "Y"), 200)
			$ndeadlock = TimerInit() + 20000
		EndIf
		update($arange)
		If $move Then
			out("Incoming AoE-DMG Detected, Moving.")
			$rnd = Random(1, 4, 1)
			Switch $rnd
				Case 1
					move(DllStructGetData(-2, "X") + 250, DllStructGetData(-2, "Y"))
				Case 2
					move(DllStructGetData(-2, "X") - 250, DllStructGetData(-2, "Y"))
				Case 3
					move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y") + 250)
				Case 4
					move(DllStructGetData(-2, "X"), DllStructGetData(-2, "Y") - 250)
			   EndSwitch
			   Sleep(750)
		EndIf
		$nx = DllStructGetData($mself, "X")
		$ny = DllStructGetData($mself, "Y")
		If NOT checkforspirits($nx, $ny) Then Return False
		castengine()
	Until $menemiesrange[0] = 0
	If TimerDiff($mskilltimer) < $mcasttime Then Sleep($mcasttime - TimerDiff($mskilltimer))
	Sleep(Random(500, 1000, 1))
	If getisdead($mself) Then
		Return False
	EndIf
	pickuploot()
	Return True
EndFunc

Func update($arange)
	$mselfid = getmyid()
	$mself = getagentbyid($mselfid)
	$menergy = getenergy($mself)
	$mskillbar = getskillbar()
	$meffects = geteffect()
	If NOT IsArray($meffects) Then Dim $meffects[1] = [0]
	$mdazed = False
	$mblind = False
	$mskillhardcounter = False
	$mskillsoftcounter = 0
	$mattackhardcounter = False
	$mattacksoftcounter = 0
	$mallyspellhardcounter = False
	$menemyspellhardcounter = False
	$mspellsoftcounter = 0
	$mblocking = False
	$move = False
	For $i = 1 To $meffects[0]
		Switch DllStructGetData($meffects[$i], "SkillID")
			Case 485
				$mdazed = True
			Case 479
				$mblind = True
			Case 30, 764
				$mskillhardcounter = True
			Case 51, 127
				$mallyspellhardcounter = True
			Case 46, 979, 3191
				$menemyspellhardcounter = True
			Case 878, 3234
				$mskillsoftcounter += 1
				$mspellsoftcounter += 1
				$mattacksoftcounter += 1
			Case 28, 128
				$mspellsoftcounter += 1
			Case 47, 43, 2056, 3195
				$mattackhardcounter = True
			Case 123, 26, 3151, 121, 103, 66
				$mattacksoftcounter += 1
			Case 380, 810
				$mblocking = True
		EndSwitch
	Next
	Local $lagent
	Local $lteam = DllStructGetData($mself, "Team")
	Local $lhp
	Local $ldistance
	Local $lmodel
	Dim $mteam[1] = [0]
	Dim $mteamothers[1] = [0]
	Dim $mteamdead[1] = [0]
	Dim $menemies[1] = [0]
	Dim $menemiesrange[1] = [0]
	Dim $menemiesspellrange[1] = [0]
	Dim $mspirits[1] = [0]
	Dim $mpets[1] = [0]
	Dim $mminions[1] = [0]
	$mlowestally = $mself
	$mlowestallyhp = 1
	$mlowestotherally = 0
	$mlowestotherallyhp = 2
	$mlowestenemy = 0
	$mlowestenemyhp = 2
	$mclosestenemy = 0
	$mclosestenemydist = 5000
	For $i = 1 To getmaxagents()
		$lagent = getagentbyid($i)
		If DllStructGetData($lagent, "Type") <> 219 Then ContinueLoop
		$lhp = DllStructGetData($lagent, "HP")
		$ldistance = getdistance($lagent, $mself)
		Switch DllStructGetData($lagent, "Allegiance")
			Case 1
				If NOT BitAND(DllStructGetData($lagent, "Typemap"), 131072) Then ContinueLoop
				If NOT getisdead($lagent) AND $lhp > 0 Then
					$mteam[0] += 1
					ReDim $mteam[$mteam[0] + 1]
					$mteam[$mteam[0]] = $lagent
					If $lhp < $mlowestallyhp Then
						$mlowestally = $lagent
						$mlowestallyhp = $lhp
					ElseIf $lhp = $mlowestallyhp Then
						If $ldistance < getdistance($mlowestally, $mself) Then
							$mlowestally = $lagent
							$mlowestallyhp = $lhp
						EndIf
					EndIf
					If $i <> $mselfid Then
						$mteamothers[0] += 1
						ReDim $mteamothers[$mteamothers[0] + 1]
						$mteamothers[$mteamothers[0]] = $lagent
						If $lhp < $mlowestotherallyhp Then
							$mlowestotherally = $lagent
							$mlowestotherallyhp = $lhp
						ElseIf $lhp = $mlowestotherallyhp Then
							If $ldistance < getdistance($mlowestotherally, $mself) Then
								$mlowestotherally = $lagent
								$mlowestotherallyhp = $lhp
							EndIf
						EndIf
					EndIf
				Else
					$mteamdead[0] += 1
					ReDim $mteamdead[$mteamdead[0] + 1]
					$mteamdead[$mteamdead[0]] = $lagent
				EndIf
			Case 3
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				If BitAND(DllStructGetData($lagent, "Typemap"), 262144) Then
					$mspirits[0] += 1
					ReDim $mspirits[$mspirits[0] + 1]
					$mspirits[$mspirits[0]] = $lagent
				EndIf
				$lmodel = DllStructGetData($lagent, "PlayerNumber")
				$menemies[0] += 1
				ReDim $menemies[$menemies[0] + 1]
				$menemies[$menemies[0]] = $lagent
				If $ldistance <= $arange Then
					$menemiesrange[0] += 1
					ReDim $menemiesrange[$menemiesrange[0] + 1]
					$menemiesrange[$menemiesrange[0]] = $lagent
					If $lhp < $mlowestenemyhp Then
						$mlowestenemy = $lagent
						$mlowestenemyhp = $lhp
					ElseIf $lhp = $mlowestenemyhp Then
						If $ldistance < getdistance($mlowestenemy, $mself) Then
							$mlowestenemy = $lagent
							$mlowestenemyhp = $lhp
						EndIf
					EndIf
					If $ldistance < $mclosestenemydist Then
						$mclosestenemydist = $ldistance
						$mclosestenemy = $lagent
					EndIf
				EndIf
				If $ldistance <= 1240 Then
					$menemiesspellrange[0] += 1
					ReDim $menemiesspellrange[$menemiesspellrange[0] + 1]
					$menemiesspellrange[$menemiesspellrange[0]] = $lagent
					If getiscasting($lagent) Then
						Switch DllStructGetData($lagent, "Skill")
							Case 830, 192, 1083, 1372, 1380
								$move = True
						EndSwitch
					EndIf
				EndIf
			Case 4
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				If BitAND(DllStructGetData($lagent, "Typemap"), 262144) Then
					$mspirits[0] += 1
					ReDim $mspirits[$mspirits[0] + 1]
					$mspirits[$mspirits[0]] = $lagent
					out("spirits: " & $mspirits[0])
				Else
					$mpets[0] += 1
					ReDim $mpets[$mpets[0] + 1]
					$mpets[$mpets[0]] = $lagent
				EndIf
			Case 5
				If NOT BitAND(DllStructGetData($lagent, "Typemap"), 131072) Then ContinueLoop
				If getisdead($lagent) OR $lhp <= 0 Then ContinueLoop
				$mminions[0] += 1
				ReDim $mminions[$mminions[0] + 1]
				$mminions[$mminions[0]] = $lagent
			Case Else
		EndSwitch
	Next
EndFunc

Func aggromovetoex($x, $y, $s = "", $z = 1250)
	Local $random = 50,	$iblocked = 0
	Local $lme, $coordsx, $coordsy, $oldcoordsx, $oldcoordsy, $nearestenemy, $ldistance
	If $s <> "" Then out($s)
	buildmaintenance()
	move($x, $y, $random)
	$lme = getagentbyid(-2)
	$coordsx = DllStructGetData($lme, "X")
	$coordsy = DllStructGetData($lme, "Y")
	Do
		rndsleep(250)
		$oldcoordsx = $coordsx
		$oldcoordsy = $coordsy
		$nearestenemy = getnearestenemytoagent(-2)
		$ldistance = getdistance($nearestenemy, -2)
		If $ldistance < $z AND DllStructGetData($nearestenemy, "ID") <> 0 Then
			changeweaponset(3)
			If fight($z) = False Then
				out("Im Dead")
				Return False
			EndIf
			changeweaponset(4)
		EndIf
		rndsleep(250)
		$lme = getagentbyid(-2)
		$coordsx = DllStructGetData($lme, "X")
		$coordsy = DllStructGetData($lme, "Y")
		If $oldcoordsx = $coordsx AND $oldcoordsy = $coordsy Then
			$iblocked += 1
			move($coordsx, $coordsy, 500)
			rndsleep(350)
			move($x, $y, $random)
			If getmaploading() == 2 Then disconnected()
		EndIf
		If getisdead(-2) Then
			Return False
		EndIf
	Until computedistance($coordsx, $coordsy, $x, $y) < 250 OR $iblocked > 20
	If getisdead(-2) Then
		Return False
	EndIf
	Return True
EndFunc

Func pickuploot()
	Local $lme, $lagent, $litem, $litemexists
	Local $lblockedtimer
	Local $lblockedcount = 0
	Local $litemexists = True
	For $i = 1 To getmaxagents()
		$lme = getagentbyid(-2)
		If DllStructGetData($lme, "HP") <= 0 Then Return -1
		$lagent = getagentbyid($i)
		If NOT getismovable($lagent) Then ContinueLoop
		If NOT getcanpickup($lagent) Then ContinueLoop
		$litem = getitembyagentid($i)
		If canpickup($litem) Then
			Do
				pickupitem($litem)
				Sleep(getping())
				Do
					Sleep(100)
					$lme = getagentbyid(-2)
				Until DllStructGetData($lme, "MoveX") == 0 AND DllStructGetData($lme, "MoveY") == 0
				$lblockedtimer = TimerInit()
				Do
					Sleep(3)
					$litemexists = IsDllStruct(getagentbyid($i))
				Until NOT $litemexists OR TimerDiff($lblockedtimer) > Random(5000, 7500, 1)
				If $litemexists Then $lblockedcount += 1
			Until NOT $litemexists OR $lblockedcount > 5
		EndIf
	Next
EndFunc

Func canpickup($aitem)
	Local $m, $r, $c, $q
	Local $choc = 22644
	Local $eggs = 22752
	Local $rarity_white = 2621, $rarity_blue = 2623, $rarity_purple = 2626, $rarity_gold = 2624, $rarity_green = 2627
	$m = DllStructGetData($aitem, "ModelID")
	$r = getrarity($aitem)
	$c = DllStructGetData($aitem, "ExtraID")
	$q = DllStructGetData($aitem, "Quantity")
	If $m = 835 OR $m = 28434 OR $m = 30855 OR $m = 2511 OR $m = 22191 OR $m = 37765 Then
		Return True
	ElseIf $r = $rarity_green Then
	ElseIf ($m = 146 AND ($c = 10 OR $c = 12 OR $c = 13)) OR $m = 22751 Then
		Return True
	ElseIf $r = $rarity_green Then
		Return True
	ElseIf $m > 21785 AND $m < 21806 Then
		Return True
	ElseIf $m = $eggs OR $m = $choc OR $m = 22190 OR $m = $MODEL_ID_CONFESSORS_ORDERS Then
		Return True
	ElseIf $q > 50 Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func idofmodel($bagid, $slotid)
	Return DllStructGetData(getitembyslot($bagid, $slotid), "ModelID")
EndFunc

Func getnumberoffoesinrangeofagent($aagent = -2, $arange = 1250)
	Local $lagent, $ldistance
	Local $lcount = 0, $lagentarray = getagentarray(219)
	If NOT IsDllStruct($aagent) Then $aagent = getagentbyid($aagent)
	For $i = 1 To $lagentarray[0]
		$lagent = $lagentarray[$i]
		If DllStructGetData($lagent, "Allegiance") <> 3 Then ContinueLoop
		If DllStructGetData($lagent, "HP") <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lagent, "Effects"), 16) > 0 Then ContinueLoop
		$ldistance = getdistance($lagent)
		If $ldistance > $arange Then ContinueLoop
		$lcount += 1
	Next
	Return $lcount
EndFunc

Func get_bow()
   Local $lrunning = True
   out("going to grab keiran's bow")
   While $lrunning
	  Switch GetMapID()
		 Case $MAP_ID_HOM
			GoToNPC(GetAgentByName("Gwen"))
			rndsleep(250)
			Dialog(0x8A)
			$lrunning = False
		 Case $MAP_ID_EOTN
			enterhom()
		 Case Else
			TravelTo($MAP_ID_EOTN)
	  EndSwitch
	  rndsleep(1000)
   WEnd
   out("finished grabbing keiran's bow")
   Return True
EndFunc

Func togglerendering()
	If $rendering Then
		disablerendering()
		$rendering = False
		WinSetState(GetWindowHandle(), "", @SW_HIDE)
	Else
		enablerendering()
		$rendering = True
		WinSetState(GetWindowHandle(), "", @SW_SHOW)
	EndIf
EndFunc

Func out($astring)
	FileWriteLine($flog, "[" & $charname & "] " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & $astring)
	ConsoleWrite(@HOUR & ":" & @MIN & ":" & @SEC & " - " & $astring & @CRLF)
	GUICtrlSetData($glogbox, GUICtrlRead($glogbox) & @HOUR & ":" & @MIN & ":" & @SEC & " - " & $astring & @CRLF)
	_guictrledit_scroll($glogbox, 4)
EndFunc

Func pause_bot($message = "")
   Local $final_message
   If $message == "" Then
	  $final_message = "stopped"
   Else
	  $final_message = "stopped - " & $message
   EndIf
   $boolrun = False
   GUICtrlSetData($btnstart, "start bot")
   GUICtrlSetData($lblstatus, $final_message)
   GUICtrlSetState($btngetbow, $GUI_ENABLE)
   out("bot is paused ...")
   Return True
EndFunc



;Fixes for new gwa2

Func CountInventoryItem($ItemID)
   Local $count = 0
   Local $lItemInfo
   For $i = 1 To 4
	  For $j = 0 To DllStructGetData(GetBag($i), 'Slots') - 1
		 $lItemInfo = GetItemBySlot($i, $j)
		 If DllStructGetData($lItemInfo, 'ModelID') = $ItemID Then $count += DllStructGetData($lItemInfo, 'quantity')
	  Next
   Next
   Return $count
EndFunc   ;==>CountInventoryItem

Func CountFreeSlots($NumOfBags = 4)
   Local $FreeSlots, $Slots

   For $Bag = 1 to $NumOfBags
	  $Slots += DllStructGetData(GetBag($Bag), 'Slots')
	  $Slots -= DllStructGetData(GetBag($Bag), 'ItemsCount')
   Next

   Return $Slots
EndFunc