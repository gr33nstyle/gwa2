#include "GWA2p.au3"
#include "GWA2Addons.au3"
#include "GUIHandler.au3"
#include "Misc.au3"
#include "GlobalConstants.au3"
#include "MainGUI.isf"

#include <Date.au3>
#include <GUIConstantsEx.au3> ;for GUI stuff
#include <WindowsConstants.au3> ;for $SS_CENTER
#include <StaticConstants.au3> ;for $WS_GROUP
#include <ComboConstants.au3> ;for Combo Constant
#include <GuiEdit.au3>
#include <WinAPI.au3>
#include <WinAPIProc.au3>
#include <EditConstants.au3>
#Include <GUIEdit.au3>
#include <File.au3>
#Include <ScrollBarConstants.au3>

#RequireAdmin
#NoTrayIcon

Opt("MustDeclareVars", True)
Opt("GUIOnEventMode", True)

GUISetState(@SW_SHOW)

If $CmdLine[0] > 0 And $CmdLine[1] <> "" Then
	InitFromCmdLine()
EndIf

While True	
	If $Running Then
		Local $RunSuccess = FarmSkalefins()
		If $RunSuccess Then
			$RunsSuccess = $RunsSuccess + 1
		Else
			$RunsFail = $RunsFail + 1
		EndIf
		$RunsTotal = $RunsTotal + 1
		WinSetTitle($MainGui, "", $characterName & " | " & $RunsTotal & "[" & $RunsSuccess & "/" & $RunsFail & "]")
		If Mod($RunsTotal, 10) = 7 Then _PurgeHook()
	EndIf
		
Wend

Func FarmSkalefins()
	If Not $Initialized Then Setup()
	
	If GetMapID() <> $MAP_ID_JOKANUR Then
		TravelTo($MAP_ID_JOKANUR)
		WaitMapLoading($MAP_ID_JOKANUR)
	EndIf
		
	Out("Starting run #" & $RunsTotal+1)
	Out("Exiting town")
	MoveTo(602, 35)
	MoveTo(-1231, -840)
	Do
		Move(-2673, -1121)
	Until WaitMapLoading($MAP_ID_FAHRANUR) ;farm area MAP ID
	
	Local $Continue = True
	
	Out("Moving to first spot")
	ChangeWeaponSet($WEAPON_SET_STAFF)
	$Continue = MoveAggroing(17621, 12247)
	If Not $Continue Then Return False

	Out("Killing")
	$Continue = KillSkales()
	If Not $Continue Then Return False
	_PickupLoot()

	Out("Moving to second spot")
	ChangeWeaponSet($WEAPON_SET_STAFF)
	$Continue = MoveAggroing(14613, 13509)
	If Not $Continue Then Return False
	$Continue = MoveAggroing(11422, 14537)
	If Not $Continue Then Return False

	Out("Killing")
	$Continue = KillSkales()
	If Not $Continue Then Return False
	_PickupLoot()

	Out("Moving to third spot")
	ChangeWeaponSet($WEAPON_SET_STAFF)
	$Continue = MoveAggroing(9843, 19001)
	If Not $Continue Then Return False

	Out("Killing")
	$Continue = KillSkales()
	If Not $Continue Then Return False
	_PickupLoot()

	Out("Moving to fourth spot")
	ChangeWeaponSet($WEAPON_SET_STAFF)
	$Continue = MoveAggroing(5668, 16847)
	If Not $Continue Then Return False
	$Continue = MoveAggroing(908, 15963)
	If Not $Continue Then Return False

	Out("Killing")
	$Continue = KillSkales()
	If Not $Continue Then Return False
	_PickupLoot()

	Out("Moving to last spot")
	ChangeWeaponSet($WEAPON_SET_STAFF)
	$Continue = MoveAggroing(1332, 14021)
	If Not $Continue Then Return False
	$Continue = MoveAggroing(2178, 14202)
	If Not $Continue Then Return False

	Out("Killing")
	$Continue = KillSkales(True, 45000)
	If Not $Continue Then Return False
	_PickupLoot()

	ChangeWeaponSet($WEAPON_SET_STAFF)
	Out("Starting next round")
	TravelTo($MAP_ID_JOKANUR)
	WaitMapLoading($MAP_ID_JOKANUR)
	
	Return True
EndFunc

Func Setup()
	If GetMapID() <> $MAP_ID_JOKANUR Then
		TravelTo($MAP_ID_JOKANUR)
		WaitMapLoading($MAP_ID_JOKANUR)
	EndIf
	LoadSkillTemplate($SKILL_TEMPLATE)
	$Initialized = True
EndFunc

Func KillSkales($pRecastVos = False, $pTimeout = 90000)
	Local $TimeoutTimer = TimerInit()
	
	UseSkillEx($SAND_SHARDS)
	UseSkillEx($MYSTIC_REGENERATION)
	UseSkillEx($VOW_OF_STRENGTH)
	
	ChangeWeaponSet($WEAPON_SET_SCYTHE)
	Sleep(2000)
	
	UseSkillEx($STAGGERING_FORCE)
	UseSkillEx($EREMITES_ATTACK, GetNearestEnemyToAgent(-2))
	
	Do
		If IsRecharged($SAND_SHARDS) Then UseSkillEx($SAND_SHARDS)
		If IsRecharged($VOW_OF_STRENGTH) And $pRecastVos Then UseSkillEx($VOW_OF_STRENGTH)
		Attack(GetNearestEnemyToAgent(-2))
		Sleep(2500)
	Until GetNumberOfFoesInRangeOfAgent(-2, 1300) = 0 Or GetIsDead(-2) Or TimerDiff($TimeoutTimer) > $pTimeout
	
	Local $Fail = GetIsDead(-2) Or TimerDiff($TimeoutTimer) > $pTimeout
	Return Not $Fail
EndFunc

Func MaintainDash()
	If IsRecharged($DWARVEN_STABILITY) Then 
		If GetEffect(2423) = 0 Or GetEffectTimeRemaining(2423) < 3000 Then
			UseSkillEx($DWARVEN_STABILITY)
		EndIf
	EndIf
	If IsRecharged($DASH) Then UseSkill($DASH, -2)
EndFunc

;~ Func PickupSkalefins()
;~ 	Local $lMeX, $lMeY, $lAgentX, $lAgentY
;~ 	Local $lSlots = CountSlots()
;~ 	Local $lAgentArray = GetAgentPtrArray(1, 0x400)
;~ 	Local $aMe = GetAgentById(-2)
;~ 	For $i = 1 To $lAgentArray[0]
;~ 		If GetIsDead($aMe) Then Return False ; died, cant pick up items dead
;~ 		If GetMapLoading() <> 1 Then Return True ; not in explorable -> no items to pick up
;~ 		Local $lAgentID = MemoryRead($lAgentArray[$i] + 44, 'long')
;~ 		Local $lItemPtr = GetItemPtrByAgentID($lAgentID)
;~ 		If $lItemPtr = 0 Then ContinueLoop
;~ 		Local $lOwner = MemoryRead($lAgentArray[$i] + 196, 'long')
;~ 		If $lOwner <> 0 And $lOwner <> GetMyID() Then ContinueLoop ; assigned to someone else
;~ 		UpdateAgentPosByPtr($aMe, $lMeX, $lMeY)
;~ 		UpdateAgentPosByPtr($lAgentArray[$i], $lAgentX, $lAgentY)
;~ 		Local $lDistance = Sqrt(($lMeX - $lAgentX) ^ 2 + ($lMeY - $lAgentY) ^ 2)
;~ 		If $lDistance > 2000 Then ContinueLoop ; item is too far away
;~ 		Local $lItemMID = MemoryRead($lItemPtr + 44, 'long')
;~ 		MsgBox("", "", $lItemMID)
;~ 		If $lItemMID = $ITEM_ID_SKALEFINS Then
;~ 		 PickUpItems($lAgentArray[$i], $lAgentID, $lAgentX, $lAgentY, $lDistance, $aMe)
;~ 		EndIf
;~ 	Next
;~ EndFunc

Func _InitializeVVC($pCharacterName)
	If Initialize($pCharacterName, true, true) Then
		$characterName = $pCharacterName
		GUICtrlSetState($characterCombo, $GUI_DISABLE)
		GUICtrlSetState($renderingBtn, $GUI_ENABLE)
		GUICtrlSetData($startBtn, "Exit")
		Out("Initialized")
		WinSetTitle($MainGui, "", $characterName & " - Skalefin")
		AfterInitializationSetup()
		$Running = True
	Else
		MsgBox(0, "Error Initializing", "Error while initializing with character name " & $pCharacterName)
	EndIf
EndFunc

Func _Exit()
	Exit
EndFunc

