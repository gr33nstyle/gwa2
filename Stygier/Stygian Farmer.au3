#RequireAdmin
If @AutoItX64 Then
	MsgBox(16, "Error!", "Please run all bots in 32-bit (x86) mode.")
	Exit
 EndIf

 #include <GWA2.au3>
 #include <Inventory.au3>
 #include <GUIConstantsEx.au3>

Opt("GUIOnEventMode", 1)
Dim $gems = 000
Dim $runs = 000
Dim $rendering = True
Dim $anzeigeonoff = False
Dim $time = "00:00:00"
Global $onoff = False
Global $ensuresafety = True ; will zone  until it finds empty dis , and wont kneel if people in town
Global Const $goa = 474
Global $town = $goa ;start town
Global Const $WEAPON_SLOT_SHIELD = 3
Global Const $WEAPON_SLOT_STAFF = 4

;~ Special Drops
Global $Special_Drops[7] = [5656, 18345, 21491, 37765, 21833, 28433, 28434]

Global $Array_Store_ModelIDs460[147] = [474, 476, 486, 522, 525, 811, 819, 822, 835, 610, 2994, 19185, 22751, 4629, 24630, 4631, 24632, 27033, 27035, 27044, 27046, 27047, 7052, 5123 _
		, 1796, 21797, 21798, 21799, 21800, 21801, 21802, 21803, 21804, 1805, 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682 _
		, 6376 , 6368 , 6369 , 21809 , 21810, 21813, 29436, 29543, 36683, 4730, 15837, 21490, 22192, 30626, 30630, 30638, 30642, 30646, 30648, 31020, 31141, 31142, 31144, 1172, 15528 _
		, 15479, 19170, 21492, 21812, 22269, 22644, 22752, 28431, 28432, 28436, 1150, 35125, 36681, 3256, 3746, 5594, 5595, 5611, 5853, 5975, 5976, 21233, 22279, 22280, 6370, 21488 _
		, 21489, 22191, 35127, 26784, 28433, 18345, 21491, 28434, 35121, 921, 922, 923, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943 _
		, 944, 945, 946, 948, 949, 950, 951, 952, 953, 954, 955, 956, 6532, 6533]

Global $Array_pscon[39]=[910, 5585, 6366, 6375, 22190, 24593, 28435, 30855, 31145, 35124, 36682, 6376, 21809, 21810, 21813, 36683, 21492, 21812, 22269, 22644, 22752, 28436,15837, 21490, 30648, 31020, 6370, 21488, 21489, 22191, 26784, 28433, 5656, 18345, 21491, 37765, 21833, 28433, 28434]


$form1 = GUICreate("Stygian Farmer", 320, 220, 192, 124)
$label4 = GUICtrlCreateLabel("Char Name:", 30, 20, 100, 20)
$input2 = GUICtrlCreateCombo("", 110, 20, 180, 21)
GUICtrlSetData(-1, GetLoggedCharNames())
$label3 = GUICtrlCreateLabel("Gems:" & $gems, 30, 60)
$label2 = GUICtrlCreateLabel("Runs:" & $runs, 30, 90)
$label5 = GUICtrlCreateLabel("Last Run:", 30, 120)
$label5 = GUICtrlCreateLabel($time, 80, 120)
$Checkbox1 = GUICtrlCreateCheckbox("SafeMode", 30,140)
GUICtrlSetState(-1, $gui_checked)
;GUICtrlSetOnEvent(-1, "safety")
$checkbox2 = GUICtrlCreateCheckbox("DisableRendering", 30, 160)
GUICtrlSetOnEvent($checkbox2, "ToggleRendering")
$button1 = GUICtrlCreateButton("Start", 30, 190, 260, 33)
GUICtrlSetOnEvent($button1, "Button1")
GUISetOnEvent($gui_event_close, "Exit_func")
GUISetState(@SW_SHOW)

Func button1()
	$onoff = True
	If $anzeigeonoff = False Then
		GUICtrlSetData($button1, "Start")
		If initialize(GUICtrlRead($input2), True, True) = True Then
			$onoff = True
			$anzeigeonoff = True
			GUICtrlSetData($button1, "Pause")
			Else
			MsgBox(64, "Error", "Wrong Name Fool!")
			Exit
		EndIf
	Else
		GUICtrlSetData($button1, "Last Run")
		$onoff = False
	EndIf
 EndFunc

 Func exit_func()
	Exit
EndFunc

Func togglerendering()
	If $rendering Then
		disablerendering()
		$rendering = False
		WinSetState(GetWindowHandle(), '', 0)
	Else
		enablerendering()
		$rendering = True
		WinSetState(GetWindowHandle(), '', 1)
	EndIf
EndFunc

While 1
	Sleep(100)
	If $onoff Then
		main()
		If $onoff = False Then
			$anzeigeonoff = False
			GUICtrlSetData($button1, "Start")
		EndIf
	EndIf
WEnd

Func main()
   If CountInvSlots() < 5 Then
		idandsell()
	 EndIf
	traveltocity()
	farm()
EndFunc

Func farm()
	begin3()
	Sleep(15000)
	questtaken()
	Sleep(1000)
	begin2()
	Sleep(20000)
	begin()
	Sleep(1000)
	begin6()
	Sleep(7000)
	nuke2()
	Sleep(300)
;	items()

	begin2()
	Sleep(20000)
	begin()
	Sleep(1000)
	begin7()
	Sleep(7000)
	nuke()
	Sleep(300)
	items()
;	begin2()
;	Sleep(20000)
;	useskill(4, -2)
;	moveto(13073, -9791, 1)
;	eventitem()
	wipe()
	$runs += 1
	GUICtrlSetData($label2, "Runs:" & $runs)
EndFunc

Func begin()
	useskill(4, -2)
	moveto(13073, -9791, 1)
	Sleep(1000)
	skilluse(6)
	targetnearestally()
EndFunc

Func begin2()
	useskill(4, -2)
	moveto(9732, -7799, 1)
EndFunc

Func begin3()
	useskill(4, -2)
	moveto(2982, -10306, 1)
EndFunc

Func begin4()
	moveto(10287, -9092, 1)
	Sleep(400)
	useskill(3, -1)
	targetnearestally()
	moveto(11549, -9271, 1)
	Sleep(500)
	useskill(8, -1)
	targetnearestally()
	moveto(12317, -9348, 1)
	targetnearestally()
	Sleep(200)
	useskill(7, -1)
	Sleep(100)
	moveto(13066, -9690, 1)
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
EndFunc

Func begin5()
	moveto(10287, -9092, 1)
	Sleep(700)
	targetnearestally()
	moveto(11549, -9271, 1)
	Sleep(900)
	targetnearestally()
	moveto(12317, -9348, 1)
	targetnearestally()
	Sleep(1000)
	useskill(7, -1)
	Sleep(100)
	moveto(13066, -9690, 1)
	ChangeWeaponSet($WEAPON_SLOT_STAFF)
EndFunc

Func begin6()
	useskill(4, -2)
	moveto(8867, -9381, 1)
	skilluse(5)
	moveto(8675, -9376, 1)
	begin5()
EndFunc

Func begin7()
    ChangeWeaponSet($WEAPON_SLOT_SHIELD)
	useskill(4, -2)
	moveto(8867, -9381, 1)
	skilluse(5)
	moveto(8675, -9376, 1)
	begin4()
EndFunc

Func questtaken()
	useskill(4, -2)
	$agent = getnearestnpctocoords(7190, -9110)
	gotonpc($agent)
	acceptquest(742)
    $test = getnearestnpctocoords(7309, -8902)
	gotonpc($test)
	Dialog(0x00000085)

EndFunc

Func skilluse($skillnumber)
	$skillrechargetime = getskillbarskillrecharge($skillnumber, 0)
	If $skillrechargetime == 0 Then
		$skillslotid = getskillbarskillid($skillnumber)
		$skillidstruct = getskillbyid($skillslotid)
		useskill($skillnumber, -2)
		$activationzeitausgabe = DllStructGetData($skillidstruct, "Activation")
		$aftercastzeitausgabe = DllStructGetData($skillidstruct, "Aftercast")
		Sleep($activationzeitausgabe * 1000 + $aftercastzeitausgabe * 1000)
	EndIf
EndFunc

Func nuke()
	While True
		$agent = getnearestenemytoagent()
		changetarget($agent)
		$distance = getdistance($agent, -2)
		If $distance < 1200 Then
		    skilluserange(1, $agent)
			skilluserange(2, $agent)
			targetnextenemy()
			Sleep(100)
			$agent = getagentbyid(-1)
			skilluserange(1, $agent)
			skilluserange(2, $agent)
			targetnextenemy()
			Sleep(100)
			$agent = getagentbyid(-1)
			skilluserange(1, $agent)
			skilluserange(2, $agent)
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func nuke2()
	While True
		$agent = getnearestenemytoagent()
		changetarget($agent)
		$distance = getdistance($agent, -2)
		If $distance < 1200 Then
			If gethashex($agent) = False Then
			    Sleep(500)
			    skilluserange(1, $agent)
				skilluserange(2, $agent)
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func skilluserange($skillnumber, $agent)
	$distance = getdistance($agent, -2)
	If $distance < 1200 Then
		While True
			$skillrechargetime = getskillbarskillrecharge($skillnumber, 0)
			If $skillrechargetime == 0 Then
				$skillslotid = getskillbarskillid($skillnumber)
				$skillidstruct = getskillbyid($skillslotid)
				useskill($skillnumber, -1)
				$activationzeitausgabe = DllStructGetData($skillidstruct, "Activation")
				$aftercastzeitausgabe = DllStructGetData($skillidstruct, "Aftercast")
				Sleep($activationzeitausgabe * 1000 + $aftercastzeitausgabe * 1000)
				ExitLoop
			EndIf
		WEnd
	EndIf
EndFunc

Func items()
	useskill(4, -2)
	pickupall()
EndFunc

Func pickupall()
	For $i = 1 To getmaxagents()
		$agent = getagentbyid($i)
		If getismovable($agent) Then
			$agentstruct = DllStructGetData($agent, "ID")
			$itemstruct = getitembyagentid($agentstruct)
			If pickup($itemstruct) Then
				movetoitem($agent)
				pickupitem($itemstruct)
				Sleep(1000)
			EndIf
		EndIf
	Next
 EndFunc

 Func eventitem()
	For $i = 1 To getmaxagents()
		$agent = getagentbyid($i)
		If getismovable($agent) Then
			$agentstruct = DllStructGetData($agent, "ID")
			$itemstruct = getitembyagentid($agentstruct)
			If eventitems($itemstruct) Then
				movetoitem($agent)
				pickupitem($itemstruct)
				Sleep(1000)
			EndIf
		EndIf
	Next
 EndFunc

Func eventitems($itemstruct)
   $modelid = DllStructGetData($itemstruct, "ModelID")
   $rarity = getrarity($itemstruct)
   If (($ModelID == 2511) And (GetGoldCharacter() < 99000)) Then
		Return True	; gold coins (only pick if character has less than 99k in inventory)
   ElseIf CheckArrayPscon($ModelID)Then ; ==== Pcons ==== or all event items
	    Return True
   Else
		Return False
   EndIf
EndFunc

Func pickup($itemstruct)
	$modelid = DllStructGetData($itemstruct, "ModelID")
	$rarity = getrarity($itemstruct)
	If $modelid = 21129 Then
		$gems += 1
		GUICtrlSetData($label3, "Gems:" & $gems)
		Return True
	ElseIf $modelid = 2511 OR $modelid = 22751 Then
		Return True
	ElseIf $modelid = 146 Then
		$extraid = DllStructGetData($itemstruct, "ExtraId")
		If $extraid = 10 OR $extraid = 12 Then
			Return True
		EndIf
		Return False
	ElseIf $modelid = 21798 OR $modelid = 21801 Then
		Return True
	ElseIf $rarity = 2624 Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func movetoitem($agent)
	$x = DllStructGetData($agent, "X")
	$y = DllStructGetData($agent, "Y")
	moveto($x, $y, 100)
EndFunc

Func wipe()
	$time2 = getinstanceuptime()
	$timeaus = _mstotimeformat($time2)
	GUICtrlSetData($label5, $timeaus)
	resign()
	Sleep(5000)
	returntooutpost()
	waitmaploading()
EndFunc

Func wipedeath()
	resign()
	Sleep(5000)
	returntooutpost()
	waitmaploading()
	farm()
EndFunc

Func _mstotimeformat($msttf_ms)
	If NOT IsNumber($msttf_ms) Then Return SetError(1, 0, 0)
	Local $msttf_vorzeichen = "", $msttf_endzeit, $msttf_stunden, $msttf_minuten, $msttf_sekunden, $msttf_sret
	If $msttf_ms < 0 Then
		$msttf_ms = Abs($msttf_ms)
		$msttf_vorzeichen = "-"
	EndIf
	$msttf_endzeit = $msttf_ms / 1000
	$msttf_stunden = $msttf_endzeit / 3600
	$msttf_stunden = Int($msttf_stunden)
	$msttf_minuten = (($msttf_endzeit / 60) - ($msttf_stunden * 60))
	$msttf_minuten = Int($msttf_minuten)
	$msttf_sekunden = ($msttf_endzeit - ($msttf_minuten * 60) - ($msttf_stunden * 3600))
	$msttf_sekunden = Int($msttf_sekunden)
	If $msttf_stunden < 10 Then $msttf_stunden = "0" & $msttf_stunden
	If $msttf_minuten < 10 Then $msttf_minuten = "0" & $msttf_minuten
	If $msttf_sekunden < 10 Then $msttf_sekunden = "0" & $msttf_sekunden
	$msttf_sret = $msttf_vorzeichen & $msttf_stunden & ":" & $msttf_minuten & ":" & $msttf_sekunden
	Return $msttf_sret
EndFunc

Func traveltocity()
    safety()
	isdisempty()
EndFunc

Func moveoutcity()
	switchmode(1)
	ChangeWeaponSet($WEAPON_SLOT_SHIELD)
    RndSleep(500)
	moveto(6862, -15880)
	moveto(-800, -18500, 50)
	move(-1100, -20000, 50)
	waitmaploading()
 EndFunc

 Func safety()
	If GUICtrlRead($Checkbox1) = $gui_checked Then
		$ensuresafety = True
	Else
		$ensuresafety = False
	EndIf
 EndFunc   ;==>safety

 Func isdisempty()
	Local $peoplecount = -1
	$lAgentArray = GetAgentArray()
	For $i = 1 To $lAgentArray[0]
		$aAgent = $lAgentArray[$i]
		If isagenthuman($aAgent) Then
			$peoplecount += 1
		EndIf
	Next
	If $peoplecount > 0 Then
			rndtravel($town)
			rndsleep(300)
			isdisempty()
		 Else
			moveoutcity()
    EndIf

EndFunc   ;==>isdisempty

Func RndTravel($aMapID)
	Local $UseDistricts = 11 ; 7=eu-only, 8=eu+int, 11=all(excluding America)
	; Region/Language order: eu-en, eu-fr, eu-ge, eu-it, eu-sp, eu-po, eu-ru, us-en, int, asia-ko, asia-ch, asia-ja
	Local $Region[11] = [2, 2, 2, 2, 2, 2, 2, -2, 1, 3, 4]
	Local $Language[11] = [0, 2, 3, 4, 5, 9, 10, 0, 0, 0, 0]
	Local $Random = Random(0, $UseDistricts - 1, 1)
	MoveMap($aMapID, $Region[$Random], 0, $Language[$Random])
	waitmaploading($aMapID)
 EndFunc   ;==>RndTravel

 Func isagenthuman($aAgent)
	If DllStructGetData($aAgent, 'Allegiance') <> 1 Then Return
	$thename = GetPlayerName($aAgent)
	If $thename = "" Then Return
	Return True
EndFunc   ;==>isagenthuman


