
#NoTrayIcon
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "../GWA2.au3"
#include "Constants.au3"

Opt("MustDeclareVars", True) 	; have to declare variables with either Local or Global.
Opt("GUIOnEventMode", True)		; enable gui on event mode

Global Const $template = "OwNS44PTTQIQrg2k4OYhxkoE"
Global Const $Dash = 1
Global Const $HoS = 2
Global Const $ShadowSanctuary = 3
Global Const $YMLaD = 4
Global Const $DeathsCharge = 5
Global Const $smokepowderdefense = 6
Global Const $FinishHim = 7
Global Const $BaneSignet = 8

Global Const $MainGui = GUICreate("Skelefarm - Leader", 172, 190)
	GUICtrlCreateLabel("Skelefarm - Leader", 8, 6, 156, 17, $SS_CENTER)
	Global Const $inputCharName = GUICtrlCreateCombo("", 8, 24, 150, 22)
 		GUICtrlSetData(-1, GetLoggedCharNames())
	Global Const $cbxHideGW = GUICtrlCreateCheckbox("Disable Graphics", 8, 48)
	Global Const $cbxOnTop = GUICtrlCreateCheckbox("Always On Top", 8, 68)
	GUICtrlCreateLabel("Runs:", 8, 92)
	Global Const $lblRunsCount = GUICtrlCreateLabel(0, 80, 92, 30)
	GUICtrlCreateLabel("Fails:", 8, 112)
	Global Const $lblFailsCount = GUICtrlCreateLabel(0, 80, 112, 30)
	Global Const $lblLog = GUICtrlCreateLabel("", 8, 130, 154, 30)
	Global Const $btnStart = GUICtrlCreateButton("Start", 8, 162, 154, 25)

GUICtrlSetOnEvent($cbxOnTop, "EventHandler")
GUICtrlSetOnEvent($cbxHideGW, "EventHandler")
GUICtrlSetOnEvent($btnStart, "EventHandler")
GUISetOnEvent($GUI_EVENT_CLOSE, "EventHandler")
GUISetState(@SW_SHOW)

#include "Shared.au3"

Out("Ready")

Do
	Sleep(100)
Until $boolInitialized

MapCheck()
Out("Loading bar")
LoadSkillTemplate($template)

While 1
	If $boolRunning Then
		Main()
	Else
		Out("Bot Paused")
		GUICtrlSetState($btnStart, $GUI_ENABLE)
		GUICtrlSetData($btnStart, "Start")
		While Not $boolRunning
			Sleep(100)
		WEnd
	EndIf
WEnd

Func usespeedBoost()
    Local $lItemInfo
    For $i = 1 To 4
        For $j = 0 To DllStructGetData(GetBag($i), 'Slots') - 1
            $lItemInfo = GetItemBySlot($i, $j)
            Local $ModelId = DllStructGetData($lItemInfo, 'ModelID')
            If  $ModelId = 22644 Or $ModelId = 21492 Or $ModelId = 21812 Then
                UseItem($lItemInfo)
                Return
            EndIf
        Next
    Next
EndFunc

Func Main()
	If Not GoldCheck() Then Return

   usespeedBoost()

	Out("Moving to grenth's statue")
	MoveTo($POSITION_NEAR_AVATAR[0], $POSITION_NEAR_AVATAR[1])

	; TODO: check for being stuck

	Local $Avatar
	$Avatar = GetNearestNPCToCoords($POSITION_AVATAR[0], $POSITION_AVATAR[1])	; try to get the avatar, might be there already.
	If DllStructGetData($Avatar, "PlayerNumber") <> $MODELID_AVATAR_OF_GRENTH Then		; nope avatar is not there, spawn him.
		Out("Spawning grenth")
		SendChat("kneel", "/")
		Local $lDeadlock = TimerInit()
		Local $lFailPops = 0
		Do
			Sleep(1500)	; wait until grenths is up.
			$Avatar = GetNearestNPCToCoords($POSITION_AVATAR[0], $POSITION_AVATAR[1])

			If TimerDiff($lDeadlock) > 5000 Then
				MoveTo($POSITION_NEAR_AVATAR[0], $POSITION_NEAR_AVATAR[1])
				SendChat("kneel", "/")
				$lDeadlock = TimerInit()
				$lFailPops += 1
			EndIf

			If $lFailPops >= 3 And $USED_CITY == $TOA_ID Then
				; probably I am stuck by an NPC somewhere in ToA.
				; As far as i know there is only 1 spot where i can get stuck (behind the tree, stuck on the patrolling NPC), so move away from there.

				MoveTo(-3470, 18550)
				MoveTo($POSITION_NEAR_AVATAR[0], $POSITION_NEAR_AVATAR[1])
				$lFailPops = 0
			EndIf

		Until DllStructGetData($Avatar, "PlayerNumber") == $MODELID_AVATAR_OF_GRENTH ; TODO: make a deadlock check
	EndIf

	Out("Talking to the avatar of grenth")
	GoNpc($Avatar)
    Sleep(500);wait till he spawns
	Dialog(0x85) ; "yes, to the service of grenth"
	Sleep(300)
	DIALOG(0x86) ; "accept"

	Out("Waiting for uw to load")
	WaitMapLoading($UW_ID, 15000)

	If GetMapID() == $USED_CITY Then Return ; dialogs to enter uw failed. restart.

	SkeleBoom()

	WaitMapLoading($USED_CITY, 15000)

	UpdateStatistics()
EndFunc   ;==>Main

Func GoldCheck()
	Local $lGold = GetGoldCharacter()
	If $lGold < 1000 Then
		If GetGoldStorage() < 20000 Then
			Out("Ran out of gold")
			$boolRunning = False
			Return False
		EndIf
		Out("Withdrawing gold from chest")
		WithdrawGold(20000)
	EndIf
	Return True
EndFunc

Func SkeleBoom()
	Local $lSkeleID = GetSkeleID()

	; spike it.
	ChangeTarget($lSkeleID)
	Out("Pulling Skeleton...")
	UseSkill($Dash, -2)
	UseSkill($HoS, $lSkeleID)
	Do
		Sleep(300)
	Until GetSkillbarSkillRecharge($HoS) > 0 Or GetIsDead(-2)
	UseSkill($ShadowSanctuary, -2)
	Sleep(750)
	Out("Spiking...")
	UseSkill($smokepowderdefense, -2)
	Sleep(300)
	UseSkill($DeathsCharge, $lSkeleID, True)
	Do
		Sleep(150)
	Until GetSkillbarSkillRecharge($DeathsCharge) > 0 Or GetIsDead(-2)
	UseSkill($YMLaD, $lSkeleID)
	Sleep(100)
 	UseSkill($BaneSignet, $lSkeleID)
	Do
		Sleep(200)
	Until DllStructGetData(GetAgentByID($lSkeleID), 'HP') < .5 Or GetIsDead(-2) Or GetIsDead($lSkeleID)
	UseSkill($FinishHim, $lSkeleID)
	Do
		Sleep(200)
	Until GetIsDead($lSkeleID) Or GetIsDead(-2)

	If Not GetIsDead(-2) Then
		Out("Harvesting Skeleton Soul")
		UseItem(GetItemByModelID($MODEL_ID_MOBSTOPPER))
		Out("Checking for Ectos and shinies.")
		PickUpLoot()
	Else
		$fails += 1
	EndIf

	Out("Run over, resigning")
	Resign()

	WaitForPartyWipe()

    Sleep(2000)

	Out("Returning to City")
	If DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 Then ReturnToOutpost()
EndFunc   ;==>SkeleBoom

