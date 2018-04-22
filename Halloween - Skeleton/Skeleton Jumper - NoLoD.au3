
#NoTrayIcon
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "GWA2.au3"
#include "Constants.au3"

Opt("MustDeclareVars", True) 	; have to declare variables with either Local or Global.
Opt("GUIOnEventMode", True)		; enable gui on event mode

; set the following variable to False if you don't want your bots to use LoD (useful if running a lot of accounts or if the bot doesnt have the skill)
Global Const $Use_Lod = False

Global Const $template = "OwBR8ZaCymUgBLkUMmEAAAA"
Global Const $Dash = 1
Global Const $YMLaD = 2
Global Const $Return = 3
Global Const $SmokePowderDefense = 4
Global Const $LightOfDeldrimor = 5
Global Const $FinishHim = 6

Global Const $MainGui = GUICreate("Skelefarm - Follower", 172, 190)
	GUICtrlCreateLabel("Skelefarm - Follower", 8, 6, 156, 17, $SS_CENTER)
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

Func Main()
	; we are in toa, wait until we are in uw
	Out("Waiting to load into uw")
	WaitMapLoadingNoDeadlock($UW_ID)

	SkeleBoom()

	Out("Waiting to load into City")
	WaitMapLoadingNoDeadlock($USED_CITY)

	UpdateStatistics()
EndFunc   ;==>Main


Func SkeleBoom()
    Local $lMyID = GetMyID()

    ; target myself
    ChangeTarget($lMyID)

	; keep pressing targeting called target until we have a different target.
	Out("Targeting called target")

	Local $lDeadlock = TimerInit()
	Local $lTargetID

	Move(35, 6619 ,5)

	Do
		Sleep(100)
		TargetCalledTarget()
		$lTargetID = GetCurrentTargetID()
	Until ($lTargetID <> $lMyID And $lTargetID > 0) Or TimerDiff($lDeadlock) > 10*1000

	Sleep(250)

	Local $lSkeleID = $lTargetID

	; find the ID of caller - rely on the fact that he's the only A/Mo
	Local $lCallerID = GetCallerID()

	SpikeSkele($lSkeleID, $lCallerID)

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

	Sleep(2000)

	WaitForPartyWipe()

	Sleep(2000)

	Out("Returning to ToA")
	If DllStructGetData(GetAgentByID(-2), "PlayerNumber") == 1 Then ReturnToOutpost()
EndFunc   ;==>SkeleBoom


Func SpikeSkele($SkeleID, $CallerID)
	Local $lDeadlock = TimerInit()
	Out("Spiking Skeleton")

	If $SkeleID <= 0 Or $CallerID <= 0 Then Return

	If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return

	; Use dash (only if our energy is greater than 40, otherwise it wont be able to use FH
	If DllStructGetData(GetAgentByID(-2), 'MaxEnergy') >= 40 Then UseSkill($Dash, -2)
	Sleep(100)

	; Use retreat
	UseSkill($Return, $CallerID)
	Do
	    Sleep(100)
	Until GetSkillbarSkillRecharge($Return) > 0 Or GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID)

	If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return

	; use smoke powder defense
	UseSkill($SmokePowderDefense, -2)
	Sleep(100)
	If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return

	; use ymlad
	UseSkill($YMLaD, $SkeleID)
	Sleep(100)
	If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return

	; use FH is already < 50%
	If DllStructGetData(GetAgentByID($SkeleID), 'HP') < .5 Then
		UseSkill($FinishHim, $SkeleID)
		Sleep(100)
		If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return
	EndIf

	; use LoD
	If $Use_Lod Then
		UseSkill($LightOfDeldrimor, -2)
		Do
			Sleep(100)
		Until DllStructGetData(GetAgentByID($SkeleID), 'HP') < .5 Or GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID)
	EndIf

	If GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID) Then Return

	; use FH (if recharged = if we didnt use it before)
	If GetSkillbarSkillRecharge($FinishHim) == 0 Then UseSkill($FinishHim, $SkeleID)
	Do
		Sleep(100)
	Until GetIsDead($SkeleID) Or GetIsDead(-2) Or GetIsDead($SkeleID) Or GetIsDead($CallerID)
EndFunc
