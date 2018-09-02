global $skillCasting[9] = ["placeholder", false, false, false, false, false, false, false, false]
global $skillUsed[9] = ["placeholder", false, false, false, false, false, false, false, false]
global $skillbar[9] = ["placeholder", 0, 0, 0, 0, 0, 0, 0, 0]

func useSkillSmart($skillNumber, $target = -2)
	setEvent("skillActivate", "skillCancel", "skillComplete")
	while not $skillUsed[$skillNumber] and canUseSkill($skillNumber, $target) 
		useSkill($skillNumber, $target)
	wEnd
	if $amCasting[$skillNumber] then
		while $amCasting[$skillNumber]
			sleep(50)
		wEnd
	endIf
	
	$skillUsed[$skillNumber] = false
	setEvent()
endFunc

func skillActivate($caster, $target, $skill, $activation)
	if agentIsMe($caster) then
		if $arraySearch then
			$skillNumber = getSlotBySkillId(dllStructGetData($skill, "id"))
			if $activation > 0 then $amCasting[$skillNumber] = true
			$skillUsed[$skillNumber] = true
		endIf
	endIf
endFunc

func skillCancel($caster, $target, $skill)
	if agentIsMe($caster) then
		$skillNumber = getSlotBySkillId(dllStructGetData($skill, "id"))
		$amCasting[$skillNumber] = false
	endIf
endFunc

func skillComplete($caster, $target, $skill)
	if agentIsMe($caster) then
		$skillNumber = getSlotBySkillId(dllStructGetData($skill, "id"))
		$amCasting[$skillNumber] = false
endFunc

func setupSkillbar()
	$tempbar = getSkillbar()
	for $i = 1 to 8
		$skillbar[$i] = dllStructGetData($tempbar, "id" & $i)
	next
endFunc

func getSlotBySkillId($skillId)
	return _arraySearch($skillbar, dllStructGetData($skill, "id"))
endFunc

func agentIsMe($agent)
	return dllStructGetData(getAgentById(-2), "id") == dllStructGetData($agent, "id")
endFunc