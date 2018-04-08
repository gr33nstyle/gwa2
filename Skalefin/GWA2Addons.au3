;GWA2Addons.au3

;~ Func idea by 4D1
Func MoveAggroing__($aX, $aY, $aRandom = 50, $aMe = GetAgentByID(-2), $aMaintenanceFunc = Null, $aTimeout = 20000)	
	Local $lBlocked = 0
	Local $lTimer = TimerInit()
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY)

	Do
		If $aMaintenanceFunc <> Null Then $aMaintenanceFunc()
		Sleep(100)
		If DllStructGetData($aMe, 'HP') <= 0 Then Return False

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then Return False
		
		Move($lDestX, $lDestY)
	Until ComputeDistance(DllStructGetData($aMe, 'X'), DllStructGetData($aMe, 'Y'), $lDestX, $lDestY) < 150 Or TimerDiff($lTimer) > $aTimeout
	
	MsgBox("", "", ComputeDistance(DllStructGetData($aMe, 'X'), DllStructGetData($aMe, 'Y'), $lDestX, $lDestY) & " - " & DllStructGetData($aMe, 'X') & " - " & DllStructGetData($aMe, 'Y') & " - " & $lDestX & " - " & $lDestY)
	If TimerDiff($lTimer) > $aTimeout Then
		Return False
	EndIf
	Return True
EndFunc

Func MoveAggroing($lDestX, $lDestY, $lRandom = 150)
	If GetIsDead(-2) Then Return

	Local $lMe, $lAgentArray
	Local $lBlocked
	Local $ChatStuckTimer
	Local $lAngle
	Local $stuckTimer = TimerInit()

	Move($lDestX, $lDestY, $lRandom)
	Do
		RndSleep(50)

		$lMe = GetAgentByID(-2)

		$lAgentArray = GetAgentArray(0xDB)

		If GetIsDead($lMe) Then Return False
	    If TimerDiff($stuckTimer) > 90000 Then Return False

		MaintainDash()
		
		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then

			$lBlocked += 1
			If $lBlocked < 4 Then
				Move($lDestX, $lDestY, $lRandom)
			Elseif $lBlocked < 8 then
				$lAngle += 40
				Move(DllStructGetData($lMe, 'X')+300*sin($lAngle), DllStructGetData($lMe, 'Y')+300*cos($lAngle))
			EndIf


		elseIf $lBlocked > 0 Then

			If TimerDiff($ChatStuckTimer) > 3000 Then	; use a timer to avoid spamming /stuck
				SendChat("stuck", "/")
				$ChatStuckTimer = TimerInit()
			EndIf
			$lBlocked = 0
			TargetNearestEnemy()
			sleep(1000)
			If GetDistance() > 1100 Then ; target is far, we probably got stuck.
				If TimerDiff($ChatStuckTimer) > 3000 Then ; dont spam
					SendChat("stuck", "/")
					$ChatStuckTimer = TimerInit()
					RndSleep(GetPing())
				EndIf
			EndIf
		EndIf

	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < $lRandom*1.5
	Return True
EndFunc

Func MoveToEx($aX, $aY, $aRandom = 50)
	Local $lBlocked = 0
	Local $lMe
	Local $lTimer = TimerInit()
	Local $lMapLoading = GetMapLoading(), $lMapLoadingOld
	Local $lDestX = $aX + Random(-$aRandom, $aRandom)
	Local $lDestY = $aY + Random(-$aRandom, $aRandom)

	Move($lDestX, $lDestY, 0)

	Do
		MaintainDash()
		Sleep(100)
		$lMe = GetAgentByID(-2)

		If DllStructGetData($lMe, 'HP') <= 0 Then Return False

		$lMapLoadingOld = $lMapLoading
		$lMapLoading = GetMapLoading()
		If $lMapLoading <> $lMapLoadingOld Then Return False

		If DllStructGetData($lMe, 'MoveX') == 0 And DllStructGetData($lMe, 'MoveY') == 0 Then
			$lBlocked += 1
			$lDestX = $aX + Random(-$aRandom, $aRandom)
			$lDestY = $aY + Random(-$aRandom, $aRandom)
			Move($lDestX, $lDestY, 0)
		EndIf
	Until ComputeDistance(DllStructGetData($lMe, 'X'), DllStructGetData($lMe, 'Y'), $lDestX, $lDestY) < 100 Or TimerDiff($lTimer) > 45000
	
	Return TimerDiff($lTimer) > 45000
EndFunc   ;==>MoveTo

Func GetItemMinDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Return Int("0x" & StringMid($lModString, StringInStr($lModString, "A8A7") - 4, 2))
EndFunc   ;==>GetItemMinDmg

Func GetItemMaxDmg($aItem)
	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
	Local $lModString = GetModStruct($aItem)
	Return Int("0x" & StringMid($lModString, StringInStr($lModString, "A8A7") - 2, 2))
EndFunc   ;==>GetItemMaxDmg

; Uses a skill
; It will not use if I am dead, if the skill is not recharged, or if I don't have enough energy for it
; It will sleep until the skill is cast, then it will wait for aftercast.
Func UseSkillEx($lSkill, $lTgt=-2, $aTimeout = 3000)
	If GetIsDead(-2) Then Return
	If Not IsRecharged($lSkill) Then Return
	If GetEnergy(-2) < $skillCost[$lSkill] Then Return

	Local $lDeadlock = TimerInit()
	UseSkill($lSkill, $lTgt)
	Do
		Sleep(50)
		If GetIsDead(-2) = 1 Then Return
	Until (Not IsRecharged($lSkill)) Or (TimerDiff($lDeadlock) > $aTimeout)

	If $lSkill > 1 Then RndSleep(750)
EndFunc

; Checks if skill given (by number in bar) is recharged. Returns True if recharged, otherwise False.
Func IsRecharged($lSkill)
	Return GetSkillBarSkillRecharge($lSkill)==0
EndFunc

Func GetNumberOfFoesInRangeOfAgent($aAgent, $aRange)
	Local $lAgent, $lDistance
	Local $lCount = 0

	If Not IsDllStruct($aAgent) Then $aAgent = GetAgentByID($aAgent)

	For $i = 1 To GetMaxAgents()
		$lAgent = GetAgentByID($i)
		If BitAND(DllStructGetData($lAgent, 'typemap'), 262144) Then ContinueLoop
		If DllStructGetData($lAgent, 'Type') <> 0xDB Then ContinueLoop
		If DllStructGetData($lAgent, 'Allegiance') <> 3 Then ContinueLoop
		If DllStructGetData($lAgent, 'HP') <= 0 Then ContinueLoop
		If BitAND(DllStructGetData($lAgent, 'Effects'), 0x0010) > 0 Then ContinueLoop
		$lDistance = GetDistance($lAgent)
		If $lDistance > $aRange Then ContinueLoop
		$lCount += 1
	Next

	Return $lCount
EndFunc	;=> GetNumberOfFoesInRangeOfAgent
;~ Func GetItemReq($aItem)
;~ 	If Not IsDllStruct($aItem) Then $aItem = GetItemByItemID($aItem)
;~ 	Local $lModString = GetModStruct($aItem)
;~ 	Return Int("0x" & StringMid($lModString, StringInStr($lModString, "9827") - 4, 2))
;~ EndFunc   ;==>GetItemReq
