;~ pathing by none12345
#include-once
#include "../GWA2.au3"
#include "fix.au3"
#include "proph_creation.au3"

Global $WaypointCounter = 0


Func LevelZero()
	Local $qDeadlock
	Local $qWarPrep
	MoveTo(9961, -456, 20)
	PingSleep(500)
	Update("Quest Check...")
	PingSleep(200)
	If GetQuestById(80) = False Then
		Update("Quest: Message From A Friend")
		GoToNPCNearestCoords(10008, -467) ; 0 quest added message froma friend
		Update("Quest: Message From A Friend - waiting...")
		Local $qDeadlock = TimerInit()
		Do
			PingSleep(200)
		AcceptQuest(80)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(1, 80) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Message From A Friend - accepted")
	EndIf
	MoveTo(10202, 3, 20)
	MoveTo(10435, 455, 20)
	MoveTo(10666, 902, 20)
	MoveTo(10896, 1347, 20)
	MoveTo(11129, 1800, 20)
	MoveTo(11363, 2252, 20)
	MoveTo(11527, 2728, 20)
	MoveTo(11620, 3220, 20)
	MoveTo(11670, 3432, 20)
	PingSleep(500)
	GoToNPCNearestCoords(11715, 3517)
	PingSleep(500)
	If GetQuestState(1, 80) = True Then
		Update("Quest Reward: Message From A Friend")
		GoToNPCNearestCoords(11715, 3517) ; 0 msg from friend reward
		Update("Quest Reward: Message From A Friend - waiting...")
		$qDeadlock = TimerInit()
		Do
			Dialog(0x00805007)
				PingSleep(200)
			QuestReward(80)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(1, 80) <> True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Message From A Friend - rewarded!")
	EndIf
	PingSleep(500)
	Refresh()
	Switch GetHeroProfession(0)
		Case 1 ; warrior
			$qWarPrep = 221
		Case 2 ; ranger
			$qWarPrep = 222
		Case 3 ; monk
			$qWarPrep = 220
		Case 4 ; necromancer
			$qWarPrep = 218
		Case 5 ; mesmer
			$qWarPrep = 217
		Case 6 ; elementalist
			$qWarPrep = 219
	EndSwitch
	If GetQuestById($qWarPrep) = False Then
		Update("Quest: War Preparations")
		GoToNPCNearestCoords(11715, 3517) ; 0 war prep added -- ranger=222
		Update("Quest: War Preparations - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
		AcceptQuest($qWarPrep)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById($qWarPrep) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: War Preparations - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
	RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
	PingSleep(200)
	WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestState(33, $qWarPrep) = True Then
		Update("Quest Reward: War Preparations")
		GoToNPCNearestCoords(6086, 4161) ; war prep accepted
		Update("Quest Reward: War Preparations - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
		QuestReward($qWarPrep)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, $qWarPrep) = False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: War Preparations - rewarded!")
			Pingsleep(200)
	EndIf
	Refresh()
EndFunc   ;==>LevelZero

#region Warrior
Func Warrior0();  Warrior
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(85) = False Then
		Update("Quest: Warrior Test")
		GoToNPCNearestCoords(6086, 4161) ; warrior test accept
		PingSleep(200)
		Update("Quest: Warrior Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(85)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(85) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Warrior Test - accepted")
	EndIf
	MoveTo(5884, 3015)
	MoveTo(5638, 2042)
	MoveTo(5350, 1075)
	MoveTo(5069, 107)
	MoveTo(4028, -972)
	Update("Warrior Test: Looking for Mobs")
	Do
		TargetNearestEnemy()
		PingSleep()
		Attack(-1)
		PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	If GetQuestState(35, 85) <> True Then
		MoveTo(3038, -2165)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		MoveTo(3027, -2177)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		MoveTo(3930, -3443)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		MoveTo(5837, -2601)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		MoveTo(5821, -3946)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		MoveTo(4173, -3734)
		Update("Warrior Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	EndIf
	If GetQuestState(35, 85) <> True Then
		Do
			MoveTo(4761, -3072)
			Update("Warrior Test: Last Resort")
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(5000)
		Until GetQuestState(35, 85) = True
	EndIf
	Update("Warrior Test: Returning to NPC")
	MoveTo(5174, -1596)
	MoveTo(5268, -318)
	MoveTo(5391, 1320)
	MoveTo(5755, 2914)
	MoveTo(6068, 3831)
	If GetQuestState(35, 85) = True Then
		Update("Quest Reward: Warrior Test")
		GoToNPCNearestCoords(6086, 4161) ; warrior test accepted
			Pingsleep(400)
		Update("Quest Reward: Warrior Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
				PingSleep(200)
			QuestReward(85)
				PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 85) = False Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Warrior Test - rewarded!")
	EndIf
	Refresh()
		Update("Waiting for Haversdan to show up")
		PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		PingSleep(200)
		WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(67) = False Then
		Update("Quest: A New Warrior Trainer")
		GoToNPCNearestCoords(6086, 4161) ; warrior trainer accepted
		Update("Quest: A New Warrior Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(67)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(67) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Warrior Trainer - accepted!")
	EndIf
	MoveTo(5412, 4611)
		Update("Running to Warmaster Grast")
	MoveTo(4691, 5317)
	MoveTo(3928, 5973)
	MoveTo(2980, 6305)
	MoveTo(1995, 6487)
	MoveTo(1003, 6670)
	MoveTo(14, 6869)
	MoveTo(-812, 7436)
	MoveTo(-1607, 8056)
	MoveTo(-2343, 8744)
	MoveTo(-3058, 9455)
	MoveTo(-3578, 10316)
	MoveTo(-4008.42, 11133.61)
	MoveTo(-4122, 11163)
	MoveTo(-5091, 11442)
	MoveTo(-6091, 11554)
	MoveTo(-7096, 11537)
	MoveTo(-8101, 11461)
	MoveTo(-8438, 10509)
	MoveTo(-8728, 9543)
	MoveTo(-8833.52, 9152.33)
	MoveTo(-9182, 8649)
	MoveTo(-9922, 7974)
	MoveTo(-10901, 7733)
	MoveTo(-11829, 8107)
	MoveTo(-12742.12, 8940.58)
	MoveTo(-12557, 8799)
	MoveTo(-13211, 9566)
	MoveTo(-13840.51, 10044.55)
	MoveTo(-14105, 10032)
	MoveTo(-14480, 10074)
		RandomPath(-14650, 10100, -14520, 10080, 50, 1, 4, -1)
		;  New Map green Hills County, ID 160
		WaitMapLoading(160) ;  New Map green Hills County
	MoveTo(21289, 13053)
	MoveTo(-12188, -8554)
	GoToNPCNearestCoords(21195, 13076) ; quest a new warrior trainer rewarded
		If GetQuestById(67) <> False Then
		Update("Quest Reward: A New Warrior Trainer")
			GoToNPCNearestCoords(21195, 13076) ; warrior trainer reward
		Update("Quest Reward: A New Warrior Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			QuestReward(67)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(67) = False Or TimerDiff($qDeadlock) > 50000
		Update("Quest Reward: A New Warrior Trainer - rewarded!")
	EndIf
		Pingsleep(500)
	If GetQuestById(75) = False Then
		Update("Quest: Grawl Invasion")
			GoToNPCNearestCoords(21195, 13076) ; grawl invasion accepted
		Update("Quest: Grawl Invasion - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(75)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(75) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Grawl Invasion - accepted!")
	EndIf
	Update("Equipping Shield")
	EquipItem(GetItemBySlot(1, 1))
		Pingsleep(700)
	Update("Equipping Sword")
	EquipItem(GetItemBySlot(1, 2))
		Pingsleep(700)
;~ 	LoadSkillTemplate("OQAAEaNAA2vAAAAAAA",0) ; frenzy | healsig
;~ 	LoadSkillTemplate("OQAAE+NAAWrAAAAAAA",0) ; sever artery | healsig  --- skels immune to bleed and we dont have hamstring or firestorm!!!!!
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Warrior0
#endregion Warrior

#region Ranger
Func Ranger0();    RANGER
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(86) = False Then
		Update("Quest: Ranger Test")
		GoToNPCNearestCoords(6086, 4161) ; ranger test accept
		Update("Quest: Ranger Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(86)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(86) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Ranger Test - accepted")
	EndIf
	MoveTo(6030, 3029)
	MoveTo(6011, 2023)
	MoveTo(6114, 1021)
	MoveTo(5928, 30)
	MoveTo(5708, -946)
	MoveTo(5390, -1902)
	MoveTo(5154, -2881)
	MoveTo(5433, -3847) ; river skale queen
	ChangeTarget(GetAgentByName("River Skale Queen"))
	Sleep(500)
	$aAgent = GetAgentByID(-1)
	$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
	$agent_distance = Round(GetDistance($aAgent))
	If $agent_model_id = $ModelSQ And $agent_distance < 1000 Then
		PingSleep(100)
		ActionInteract()
		PingSleep(50)
	EndIf
;~ 			TargetNearestEnemy()
;~ 				PingSleep(50)
	Do
		Attack(-1)
		PingSleep(10)
;~ 		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	Until GetQuestState(35, 86) = True
	MoveTo(5438, -2710)
	MoveTo(5236, -1724)
	MoveTo(5436, -742)
	MoveTo(5844, 181)
	MoveTo(6005, 1176)
	MoveTo(6091, 2180)
	MoveTo(6082, 3183)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestState(35, 86) = True Then
		Update("Quest Reward: Ranger Test")
		GoToNPCNearestCoords(6086, 4161) ; ranger test accepted
			Pingsleep(400)
		Update("Quest Reward: Ranger Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
			PingSleep(200)
			QuestReward(86)
			PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 86) = False Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Ranger Test - rewarded!")
	EndIf
	Refresh()
		Update("Waiting for Haversdan to show up")
	PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Ranger0
#endregion Ranger


#region Monk
Func Monk0();  Monk
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(84) = False Then
		Update("Quest: Monk Test")
		GoToNPCNearestCoords(6086, 4161) ; monk test accept
		PingSleep(200)
		Update("Quest: Monk Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(84)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(84) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Monk Test - accepted")
	EndIf
	MoveTo(5771, 3174)
	MoveTo(5523, 2204)
	MoveTo(5224, 1245)
	MoveTo(5033, 256)
	MoveTo(4837, -734)
	MoveTo(4641, -1723)
	MoveTo(4468, -2715)
	MoveTo(4123, -3662)
	MoveTo(3840.19, -4423)
	If GetQuestById(84) <> False Then
		Update("Quest: Monk Test - updating")
		GoToNPCNearestCoords(3880, -4550) 	; gwen
			PingSleep(200)
		Update("Quest: Monk Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(84)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33,84) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Monk Test - updated!")
	EndIf
		Update("Monk Test: Clearing path for Gwen")
	MoveTo(4416, -3863)
	Do
		TargetNearestEnemy()
		PingSleep()
		Attack(-1)
		PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(5507, -3907)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(6542, -3589)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(5779, -2485)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(5336, -1510)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(4121, -1906)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(4051, -3184)
	Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	MoveTo(3840, -4423)
		Pingsleep(50)
	GoToNPCNearestCoords(3880, -4550) 	; gwen
		Pingsleep(50)
	If GetQuestState(35,84) <> True Then
		Do
			MoveTo(4761, -3072)
			Update("Monk Test: Last Resort")
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(8000)
		Until GetQuestState(35, 84) = True
		MoveTo(3840, -4423)
			Pingsleep(50)
		GoToNPCNearestCoords(3880, -4550) 	; gwen
			Pingsleep(50)
		Update("Quest: Monk Test - updated!")
	EndIf
	Update("Monk Test: Returning to NPC")
	MoveTo(5174, -1596)
	MoveTo(5268, -318)
	MoveTo(5391, 1320)
	MoveTo(5755, 2914)
	MoveTo(6068, 3831)
	MoveTo(6357, 4518)
	Update("Monk Test: Letting Gwen catch up")
		PingSleep(10000)
	Update("Ditching Gwen")
		RndTravel($MapAscalon)
			Pingsleep(100)
		MoveTo(8200, 6281)
		MoveTo(7783, 5756, 20)
			RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
				PingSleep(200)
			WaitMapLoading()
				PingSleep(500)
	If GetQuestState(33, 84) <> True Then
		Update("Quest Reward: Monk Test")
			GoToNPCNearestCoords(6086, 4161)
				Pingsleep(400)
		Update("Quest Reward: Monk Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
				PingSleep(200)
			QuestReward(84)
				PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 84) = True Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Monk Test - rewarded!")
	EndIf
	Refresh()
		Update("Waiting for Haversdan to show up")
		PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		PingSleep(200)
		WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(66) = False Then
		Update("Quest: A New Monk Trainer")
		GoToNPCNearestCoords(6086, 4161) ; monk trainer accepted
		Update("Quest: A New Monk Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(66)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(66) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Monk Trainer - accepted!")
	EndIf
		Pingsleep(200)
	Update("Zoning to Abbey")
		RndTravel(164) ;  New Map Pre-Searing: Ashford Abbey.
			Pingsleep(500)
		Update("Equipping Shield")
			EquipItem(GetItemBySlot(1, 1))
				Pingsleep(700)
	MoveTo(-12072, -6222)
	MoveTo(-12956, -6715)
	MoveTo(-12288, -7846)
		PingSleep(200)
	GoToNPCNearestCoords(-12160, -8091)
	PingSleep(200)
	If GetQuestState(1,66) = True Then
		Update("Quest Reward: A New Monk Trainer")
			GoToNPCNearestCoords(-12160, -8091) ; monk trainer reward
		Update("Quest Reward: A New Monk Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
				QuestReward(66)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(1,66) <> True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Monk Trainer - accepted!")
	EndIf
	PingSleep(200)
		GoToNPCNearestCoords(-12160, -8091)
	PingSleep(200)
	If GetQuestByID(74) = False Then
		Update("Quest: A Monk's Mission")
			GoToNPCNearestCoords(-12160, -8091) ; monks mission accept
		Update("Quest: A Monk's Mission - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
				AcceptQuest(74)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(74) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Monk's Mission - accepted!")
	EndIf
		Pingsleep(200)
			GoToNPCNearestCoords(-12160, -8091)
		PingSleep(200)
	If GetQuestByID(87) = False Then
		Update("Quest: The Blessings of Balthazar")
			GoToNPCNearestCoords(-12160, -8091) ; monks mission accept
		Update("Quest: The Blessings of Balthazar - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
				AcceptQuest(87)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(87) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: The Blessings of Balthazar - accepted!")
	EndIf
		Pingsleep(200)
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Monk0
#endregion Monk


#region Necromancer
Func Necromancer0();  Necromancer
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(82) = False Then
		Update("Quest: Necromancer Test")
		GoToNPCNearestCoords(6086, 4161) ; necro test accept
		PingSleep(200)
		Update("Quest: Necromancer Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(82)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(82) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Necromancer Test - accepted")
	EndIf
		MoveTo(5579, 2455)
		MoveTo(5081, 1587)
		MoveTo(4555, 731); c space attack  * sleep
			Update("Necromancer Test: Locating Target")
		ChangeTarget(GetAgentByName("River Skale Tad"))
		Sleep(500)
		$aAgent = GetAgentByID(-1)
		$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
		$agent_distance = Round(GetDistance($aAgent))
		If $agent_model_id = $ModelSQ And $agent_distance < 1000 Then
			PingSleep(100)
			ActionInteract()
			PingSleep(50)
		EndIf
	;~ 			TargetNearestEnemy()
	;~ 				PingSleep(50)
		Do
			Attack(-1)
			PingSleep(10)
	;~ 		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		Until GetQuestState(35, 82) = True
	Update("Ditching Bone Horror")
		RndTravel($MapAscalon)
			Pingsleep(100)
		MoveTo(8200, 6281)
		MoveTo(7783, 5756, 20)
			RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
				PingSleep(200)
			WaitMapLoading()
				PingSleep(500)
	If GetQuestState(33, 82) <> True Then
		Update("Quest Reward: Necromancer Test")
			GoToNPCNearestCoords(6086, 4161)
				Pingsleep(400)
		Update("Quest Reward: Necromancer Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
				PingSleep(200)
			QuestReward(82)
				PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 82) = True Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Necromancer Test - rewarded!")
	EndIf
		Refresh()
			Update("Waiting for Haversdan to show up")
		PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		PingSleep(200)
		WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(64) = False Then
		Update("Quest: A New Necromancer Trainer")
		GoToNPCNearestCoords(6086, 4161) ; necro trainer accepted
		Update("Quest: A New Necromancer Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(64)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(64) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Necromancer Trainer - accepted!")
	EndIf
	MoveTo(5412, 4611)
		Update("Running to Kasha Blackblood")
	MoveTo(4691, 5317)
	MoveTo(3928, 5973)
	MoveTo(2980, 6305)
	MoveTo(1995, 6487)
	MoveTo(1003, 6670)
	MoveTo(14, 6869)
	MoveTo(-812, 7436)
	MoveTo(-1607, 8056)
	MoveTo(-2343, 8744)
	MoveTo(-3058, 9455)
	MoveTo(-3578, 10316)
	MoveTo(-4008.42, 11133.61)
	MoveTo(-4122, 11163)
	MoveTo(-5091, 11442)
	MoveTo(-6091, 11554)
	MoveTo(-7096, 11537)
	MoveTo(-8101, 11461)
	MoveTo(-8438, 10509)
	MoveTo(-8728, 9543)
	MoveTo(-8833.52, 9152.33)
	MoveTo(-9182, 8649)
	MoveTo(-9922, 7974)
	MoveTo(-10901, 7733)
	MoveTo(-11829, 8107)
	MoveTo(-12742.12, 8940.58)
	MoveTo(-12557, 8799)
	MoveTo(-13211, 9566)
	MoveTo(-13840.51, 10044.55)
	MoveTo(-14105, 10032)
	MoveTo(-14480, 10074)
		RandomPath(-14650, 10100, -14520, 10080, 50, 1, 4, -1)
		;  New Map green Hills County, ID 160
		WaitMapLoading(160) ;  New Map green Hills County
	MoveTo(21449.25, 12851.41)
	MoveTo(21154, 12379)
	MoveTo(20699.60, 11852.40)
	MoveTo(20263, 11911)
	MoveTo(19419.49, 12239.95)
	MoveTo(19333, 12287)
	MoveTo(18339, 12461)
	MoveTo(18176.40, 12378.97)
	If GetQuestById(43) = False Then
		Update("Quest: The Power of Blood")
			GoToNPCNearestCoords(17419, 12186)  ; quest the power of blood
		Update("Quest: The Power of Blood - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(43)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(43) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: The Power of Blood - accepted!")
	EndIf
		Pingsleep(50)
		;  New Map Pre-Searing: Ashford Abbey, ID 164
	Update("Zoning to Abbey")
		RndTravel(164) ;  New Map Pre-Searing: Ashford Abbey.
		Pingsleep(50)
	MoveTo(-12960, -7790)
	MoveTo(-13288, -7401)
	MoveTo(-13724, -7150)
		Pingsleep(100)
	Update("Entering Catacombs")
	;  New Map The Catacombs, ID 145
		RandomPath(-13959, -7136, -139500, -7100, 50, 1, 4, -1)
			Pingsleep(100)
				WaitMapLoading(145) ;  New Map The Catacombs
			Pingsleep(100)
		MoveTo(13802, 2549)
	If GetQuestById(64) <> False Then
		Update("Quest Reward: A New Necromancer Trainer")
			GoToNPCNearestCoords(13775, 3584)  ; reward necro trainer
		Update("Quest Reward: A New Necromancer Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			QuestReward(64)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(64) = False Or TimerDiff($qDeadlock) > 50000
		Update("Quest Reward: A New Necromancer Trainer - rewarded!")
	EndIf
	If GetQuestById(72) = False Then
		Update("Quest: The Necromancer's Novice")
			GoToNPCNearestCoords(13775, 3584)  ; quest the necromancer's novice
		Update("Quest: The Necromancer's Novice - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(72)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(43) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: The Necromancer's Novice - accepted!")
	EndIf
		Pingsleep(500)
	Update("Equipping Shield")
	EquipItem(GetItemBySlot(1, 1))
		Pingsleep(700)
;~ 	LoadSkillTemplate("OQAAEaNAA2vAAAAAAA",0) ; frenzy | healsig
;~ 	LoadSkillTemplate("OQAAE+NAAWrAAAAAAA",0) ; sever artery | healsig  --- skels immune to bleed and we dont have hamstring or firestorm!!!!!
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Necromancer0
#endregion Necromancer

#region Mesmer
Func Mesmer0();  Mesmer
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(81) = False Then
		Update("Quest: Mesmer Test")
		GoToNPCNearestCoords(6086, 4161) ; mesmer test accept
		PingSleep(200)
		Update("Quest: Mesmer Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(81)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(81) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Mesmer Test - accepted")
	EndIf
		MoveTo(5808, 3098)
		MoveTo(5138.41, 1954.84)
		MoveTo(5298, 2230)
		MoveTo(4732, 1194)
		MoveTo(4466.00, 503.83) ; c space til quest update
			Update("Mesmer Test: Exterminating Skale")
		ChangeTarget(GetAgentByName("River Skale Tad"))
		Sleep(500)
		$aAgent = GetAgentByID(-1)
		$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
		$agent_distance = Round(GetDistance($aAgent))
		If $agent_model_id = $ModelSQ And $agent_distance < 1000 Then
			PingSleep(100)
			ActionInteract()
			PingSleep(50)
		EndIf
	;~ 			TargetNearestEnemy()
	;~ 				PingSleep(50)
		Do
			Attack(-1)
			PingSleep(10)
	;~ 		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		Until GetQuestState(35, 81) = True or GetNumberOfFoesInRangeOfAgent(-2) = 0
	Update("Mesmer Test: Returning to NPC")
		RndTravel($MapAscalon)
			Pingsleep(100)
		MoveTo(8200, 6281)
		MoveTo(7783, 5756, 20)
			RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
				PingSleep(200)
			WaitMapLoading()
				PingSleep(500)
	If GetQuestState(35, 81) = True Then
		Update("Quest Reward: Mesmer Test")
		GoToNPCNearestCoords(6086, 4161) ; mesmer test accepted
			Pingsleep(400)
		Update("Quest Reward:Mesmer Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
				PingSleep(200)
			QuestReward(81)
				PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 81) = False Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Mesmer Test - rewarded!")
	EndIf
	Refresh()
		Update("Waiting for Haversdan to show up")
		PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
		Update("Equipping Shield")
		EquipItem(GetItemBySlot(1, 1))
		Pingsleep(700)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		PingSleep(200)
		WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(63) = False Then
		Update("Quest: A New Mesmer Trainer")
		GoToNPCNearestCoords(6086, 4161) ; mesmer trainer accepted
		Update("Quest: A New Mesmer Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(63)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(63) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Mesmer Trainer - accepted!")
	EndIf
	MoveTo(5443, 4573)
		Update("Running to Lady Althea")
	MoveTo(4725, 5279)
	MoveTo(4073, 6047)
	MoveTo(3461, 6848)
	MoveTo(2856, 7647)
		GoToNPCNearestCoords(2743, 7786)  ;
		If GetQuestById(63) <> False Then
		Update("Quest Reward: A New Mesmer Trainer")
		GoToNPCNearestCoords(2743, 7786)  ; reward a new mesmer trainer + quest a mesmer's burden
		Update("Quest Reward: A New Mesmer Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			QuestReward(63)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(63) = False Or TimerDiff($qDeadlock) > 50000
		Update("Quest Reward: A New Mesmer Trainer - rewarded!")
	EndIf
		Pingsleep(500)
	If GetQuestById(71) = False Then
		Update("Quest: A Mesmer's Burden")
			GoToNPCNearestCoords(2743, 7786)  ;
		Update("Quest: A Mesmer's Burden - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(71)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(71) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Mesmer's Burden - accepted!")
	EndIf
		MoveTo(2662, 6682)
		MoveTo(1812, 6143)
		MoveTo(844, 5864)
		MoveTo(-133, 5612)
		MoveTo(-1109, 5359)
		MoveTo(-2086, 5107)
		MoveTo(-3062, 4854)
		MoveTo(-4039, 4620)
		MoveTo(-4012.51, 4660.96) ; MapID: 146
			Update("A Mesmer's Burden: Targetting Bull")
			ChangeTarget(GetAgentByName("Rogue Bull"));rogue bull. skill 1 , skill 1, skill 2, skill 1 until dead
			Sleep(500)
			$aAgent = GetAgentByID(-1)
			$agent_model_id = DllStructGetData($aAgent, 'PlayerNumber')
			$agent_distance = Round(GetDistance($aAgent))
			If $agent_model_id = $ModelRB And $agent_distance < 1000 Then
				PingSleep(100)
				ActionInteract()
				PingSleep(50)
			EndIf
;~ 			TargetNearestEnemy()
;~ 				PingSleep(50)
				Do
					Attack(-1)
					PingSleep(10)
					MiniCombat()
			;~ 		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
				Until GetQuestState(3, 71) = True
			Update("A Mesmer's Burden: Returning to NPC")
		MoveTo(-3084, 4940)
		MoveTo(-2136, 5259)
		MoveTo(-1178, 5568)
		MoveTo(-233, 5906)
		MoveTo(667, 6353)
		MoveTo(1592, 6744)
		MoveTo(2281, 7476)
		MoveTo(3231.39, 8073.38) ; MapID: 146
			GoToNPCNearestCoords(2743, 7786)  ; reward a mesmer's burden
		If GetQuestState(3, 71) = True Then
			Update("Quest Reward: A Mesmer's Burden")
				GoToNPCNearestCoords(2743, 7786)  ;
			Update("Quest Reward: A Mesmer's Burden - waiting...")
			$qDeadlock = TimerInit()
			Do
					PingSleep(200)
				QuestReward(71)
					PingSleep(400)
				If TimerDiff($qDeadlock) > 50000 Then
					Update("Time limit reached!")
				EndIf
			Until GetQuestByID(71) = False Or TimerDiff($qDeadlock) > 50000
				Update("Quest Reward: A Mesmer's Burden - rewarded!")
		EndIf
			Refresh()
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Mesmer0
#endregion Mesmer

#region Elementalist
Func Elementalist0();  Elementalist
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(83) = False Then
		Update("Quest: Elementalist Test")
		GoToNPCNearestCoords(6086, 4161) ; elementalist test accept
		PingSleep(200)
		Update("Quest: Elementalist Test - waiting...")
		$qDeadlock = TimerInit()
		Do
			AcceptQuest(83)
			PingSleep(300)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(83) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Elementalist Test - accepted")
	EndIf
	MoveTo(5884, 3015)
	MoveTo(5638, 2042)
	MoveTo(5350, 1075)
	MoveTo(5069, 107)
	MoveTo(4028, -972)
	Update("Elementalist Test: Looking for Mobs")
	Do
		TargetNearestEnemy()
		PingSleep()
		Attack(-1)
		PingSleep(50)
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		PickupLoot()
	MoveTo(3038, -2165)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		PickupLoot()
	MoveTo(3027, -2177)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
			PickupLoot()
	MoveTo(3930, -3443)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
			PickupLoot()
	MoveTo(5837, -2601)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		PickupLoot()
	MoveTo(5821, -3946)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		PickupLoot()
	MoveTo(4173, -3734)
		Update("Elementalist Test: Looking for Mobs")
		Do
			TargetNearestEnemy()
			PingSleep()
			Attack(-1)
			PingSleep(50)
		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		PickupLoot()
		Update("Elementalist Test: Returning to NPC")
	MoveTo(5174, -1596)
	MoveTo(5268, -318)
	MoveTo(5391, 1320)
	MoveTo(5755, 2914)
	MoveTo(6068, 3831)
	If GetQuestByID(83) <> False Then
		Update("Quest Reward: Elementalist Test")
		GoToNPCNearestCoords(6086, 4161) ; elementalist test accepted
			Pingsleep(400)
		Update("Quest Reward: Elementalist Test - waiting...")
		$qDeadlock = TimerInit()
		$test_exp = GetExperience()
		Do
				PingSleep(200)
			QuestReward(83)
				PingSleep(400)
			$exp_diff = GetExperience()
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 83) = True Or $exp_diff > $test_exp Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Elementalist Test - rewarded!")
	EndIf
	Refresh()
		Pingsleep(200)
			Update("Checking for Slot 1")
				$DropMe = DllStructGetData(GetItemBySlot(1,1), 'ID')
			If $DropMe <> False Then
				Update("Slot 1 Occupied, clearing...")
					Pingsleep(200)
						Dropitem($DropMe)
					Pingsleep(200)
			EndIf
		Pingsleep(200)
			Update("Waiting for Haversdan to show up")
		PingSleep(20000)
	If GetQuestById(54) = False Then
		Update("Quest: Further Adventures")
		GoToNPCNearestCoords(6114, 3703) ; further adventures accept
		Update("Quest: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(54) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - accepted")
	EndIf
	MoveTo(5752, 2878)
	MoveTo(5233, 2014)
	MoveTo(4595, 1240)
	MoveTo(4069, 387)
	MoveTo(3653, -529)
	MoveTo(3174, -1413)
	MoveTo(2618, -2254)
	MoveTo(2034, -3073)
	MoveTo(1403, -3850)
	MoveTo(713, -4582)
	MoveTo(-31, -5263)
	MoveTo(-817, -5881)
	MoveTo(-1747, -6270)
	MoveTo(-2679, -6649)
	MoveTo(-3663, -6874)
	MoveTo(-4661, -6995)
	MoveTo(-5657, -7082)
	MoveTo(-6070, -7994)
	MoveTo(-6139, -8997)
	MoveTo(-5871, -9969)
	MoveTo(-5627, -10946)
	MoveTo(-5475, -11939)
	MoveTo(-6012, -12793)
	MoveTo(-6617, -13594)
	MoveTo(-7249, -14373)
	If GetQuestState(33, 54) = True Then
		Update("Quest Reward: Further Adventures")
		GoToNPCNearestCoords(-7832, -15081) ; further adventures reward
		Update("Quest Reward: Further Adventures - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			QuestReward(54)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35, 54) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Further Adventures - rewarded!")
	EndIf
	Refresh()
	PingSleep(1000)
	If GetQuestById(62) = False Then
		Update("Quest: Unsettling Rumors")
		GoToNPCNearestCoords(-7832, -15081) ; quest added unsettling rumors
		Update("Quest: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(62)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestById(62) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - accepted")
	EndIf
	MoveTo(-9200, -15828)
	MoveTo(-10105, -16272)
	MoveTo(-10998, -16740)
	MoveTo(-11937, -17108)
	MoveTo(-12612, -16364)
	MoveTo(-12768, -15372)
	MoveTo(-12690, -14372)
	MoveTo(-12410, -13403)
	MoveTo(-12166, -12426)
	MoveTo(-12008, -11430)
	MoveTo(-11689, -10474)
	MoveTo(-11426, -9506)
	MoveTo(-11286, -8509)
	MoveTo(-11174, -7509)
	MoveTo(-10977, -6520)
	RandomPath(-11223, -6353, -11200, -6350, 50, 1, 4, -1)
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	WaitMapLoading(164) ;  New Map Pre-Searing: Ashford Abbey
	MoveTo(-11528, -6239)
	MoveTo(-12007, -6411)
	If GetQuestById(62) <> False Then
		Update("Quest Updated: Unsettling Rumors")
		GoToNPCNearestCoords(-12342, -6538) ; unsettling rumours update
		Update("Quest Updated: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			Dialog(0x00803E04)
			PingSleep(400)
			$message = GetItemBySlot(1, 1)
			$m = DllStructGetData($message, 'ModelID')
			Sleep(100)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until $m = 2565 Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - updated")
	EndIf
	PingSleep(1000)
	;  New Map Ascalon City outpost, ID 148
	RndTravel($MapAscalon) ;  New Map Ascalon City outpost
	MoveTo(8200, 6281)
	MoveTo(8764, 5466)
	MoveTo(9759, 4587)
	MoveTo(10718, 3808)
	MoveTo(11520, 3131)
	MoveTo(11917, 3076)
	If GetQuestByID(62) <> False Then  ; turn in item to ascalon
		Update("Quest Reward: Unsettling Rumors")
		GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
			Pingsleep(50)
		Update("Quest Reward: Unsettling Rumors - waiting...")
		$qDeadlock = TimerInit()
		Do
			GoToNPCNearestCoords(12012, 3041) ; quest reward unsettling rumors
				Pingsleep(400)
			QuestReward(62)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(35,62) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: Unsettling Rumors - rewarded!")
	EndIf
	Refresh()
	PingSleep(200)
	If GetQuestById(79) = False Then
		Update("Quest: A Second Profession")
		GoToNPCNearestCoords(12012, 3041) ; 2nd prof accept
		Update("Quest: A Second Profession - waiting...")
		$qDeadlock = TimerInit()
		Local $leveltwo
		Do
			PingSleep(200)
			AcceptQuest(79)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestState(33, 79) = True Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A Second Profession - accepted")
	EndIf
	MoveTo(11237, 3706, 20)
	MoveTo(10810, 3982, 20)
	MoveTo(10375, 4265, 20)
		Update("Equipping Shield")
		EquipItem(GetItemBySlot(1, 1))
		Pingsleep(700)
	MoveTo(9947, 4542, 20)
	MoveTo(9520, 4819, 20)
	MoveTo(9097, 5102, 20)
	MoveTo(8689, 5399, 20)
	MoveTo(8283, 5694, 20)
	MoveTo(7783, 5756, 20)
		RandomPath(7428, 5870, 7000, 5350, 50, 1, 4, -1)
		PingSleep(200)
		WaitMapLoading()
	PingSleep(500)
	MoveTo(6454, 4390, 20)
	PingSleep(200)
	GoToNPCNearestCoords(6086, 4161)
	PingSleep(200)
	If GetQuestById(65) = False Then
		Update("Quest: A New Elementalist Trainer")
		GoToNPCNearestCoords(6086, 4161) ; elementalist trainer accepted
		Update("Quest: A New Elementalist Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
			PingSleep(200)
			AcceptQuest(65)
			PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(65) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: A New Elementalist Trainer - accepted!")
	EndIf
			Pingsleep(100)
		Update("Running to Foibles")
			RndTravel($MapAshford)
			Pingsleep(200)
		MoveTo(-11350, -6244, 10)
			RandomPath(-11340, -6290, -11400, -6200, 50, 1, 4, -1)
		Update("Running to Foibles: Lakeside")
			WaitMapLoading(146) ;  New Map Lakeside County
		MoveTo(-11014, -6928)
		MoveTo(-11033, -7937)
		MoveTo(-11152, -8935)
		MoveTo(-11322, -9929)
		MoveTo(-11493, -10923)
		MoveTo(-11723, -11905)
		MoveTo(-12016, -12869)
		MoveTo(-12332, -13821)
		MoveTo(-12595, -14794)
		MoveTo(-12749, -15786)
		MoveTo(-12499, -16763)
		MoveTo(-12139, -17705)
		MoveTo(-11698, -18612)
		MoveTo(-10767, -18992)
		MoveTo(-11525, -19648)
		MoveTo(-12499, -19887)
		MoveTo(-13639, -20036)
		;  New Map Wizard's Folly, ID 161
		RandomPath(-13960, -20000, -14000, -20050, 50, 1, 4, -1)
		Update("Running to Foibles: Wizard's")
			WaitMapLoading(161) ;  New Map Wizard's Folly
		MoveTo(9175, 19160)
		MoveTo(8770, 18238)
		MoveTo(8528.43, 17698.46) ; MapID: 161
		MoveTo(8475, 17281)
		MoveTo(8153, 16324)
		MoveTo(7518.14, 15761.04) ; MapID: 161
		MoveTo(7333, 15742)
		MoveTo(6331, 15630)
		MoveTo(5771, 14791)
		MoveTo(5209, 13954)
		MoveTo(4642, 13119)
		MoveTo(4192, 12218)
		MoveTo(3742, 11315)
		MoveTo(3041, 10591)
		MoveTo(2628, 9672)
		MoveTo(2172, 8777)
		MoveTo(1823, 7840)
		MoveTo(1510, 6884)
		MoveTo(1047.65, 6720.34) ; MapID: 161
		MoveTo(580, 7263)
		;  New Map Pre-Searing: Foibles Fair, ID 165
			RandomPath(358, 7632, 380, 7500, 50, 1, 4, -1)
		Update("Running to Foibles: Arrived")
			WaitMapLoading(165) ;  New Map Pre-Searing: Foibles Fair
			PingSleep(200)
		Update("Running to Elementalist Azuire")
			RandomPath(260, 8120, 630, 7270, 30, 1, 4, -1)
			WaitMapLoading()
			PingSleep(200)
		MoveTo(799, 7095)
		MoveTo(1602, 6497)
		MoveTo(2288, 5760)
		MoveTo(2495, 4781)
		MoveTo(2653, 3785)
		MoveTo(2589, 2783)
		MoveTo(1718, 2286)
		MoveTo(879.44, 2079.23)
		MoveTo(717, 2263)
		MoveTo(20, 2991)
		MoveTo(-715, 3682)
		MoveTo(-1552, 4244)
		MoveTo(-2442, 4703)
		MoveTo(-3087.27, 4838.45)
		MoveTo(-3415, 4462)
		MoveTo(-4050.51, 3035.67)
		MoveTo(-3836, 3444)
		MoveTo(-3974, 2353)
		MoveTo(-4814, 1801)
		MoveTo(-5690, 1303)
		MoveTo(-6691, 1210)
		MoveTo(-7697, 1281)
		MoveTo(-7915.41, 1282.72)
			GoToNPCNearestCoords(-7774, 1246)
	If GetQuestById(65) <> False Then
		Update("Quest Reward: A New Elementalist Trainer")
			GoToNPCNearestCoords(-7774, 1246)  ; reward new ele trainer
		Update("Quest Reward: A New Elementalist Trainer - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			QuestReward(65)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(65) = False Or TimerDiff($qDeadlock) > 50000
		Update("Quest Reward: A New Elementalist Trainer - rewarded!")
	EndIf
		Pingsleep(500)
	If GetQuestById(73) = False Then
		Update("Quest: The Elementalist Experiment")
			GoToNPCNearestCoords(-7774, 1246)   ; elementalist experiment accepted
		Update("Quest: The Elementalist Experiment - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(73)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(73) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: The Elementalist Experiment - accepted!")
	EndIf
		Pingsleep(5000)
		Do
			Attack(-1)
			PingSleep(10)
			MiniCombat()
	;~ 		Until GetNumberOfFoesInRangeOfAgent(-2) = 0
		Until GetQuestState(3, 73) = True
			Update("The Elementalist Experiment: Returning to NPC")
		MoveTo(-7915.41, 1282.72)
			GoToNPCNearestCoords(-7774, 1246)
	If GetQuestState(3, 73) = True Then
		Update("Quest Reward: The Elementalist Experiment")
			GoToNPCNearestCoords(-7774, 1246)   ; elementalist experiment accepted
		Update("Quest Reward: The Elementalist Experiment - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			QuestReward(73)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(73) = False Or TimerDiff($qDeadlock) > 50000
			Update("Quest Reward: The Elementalist Experiment - rewarded!")
	EndIf
		Refresh()
			Pingsleep(200)
			RndTravel($MapFoiblesFair);  New Map Pre-Searing: Foibles Fair
				WaitMapLoading()
			Pingsleep(200)
		MoveTo(-787, 9926)
		MoveTo(-734, 10442)
		MoveTo(-683, 10945)
			GoToNPCNearestCoords(-659, 11180)
	If GetQuestById(37) = False Then
		Update("Quest: The Supremacy of Air")
			GoToNPCNearestCoords(-659, 11180)  ; accept the supremacy of air
		Update("Quest: The Supremacy of Air - waiting...")
		$qDeadlock = TimerInit()
		Do
				PingSleep(200)
			AcceptQuest(37)
				PingSleep(400)
			If TimerDiff($qDeadlock) > 50000 Then
				Update("Time limit reached!")
			EndIf
		Until GetQuestByID(37) <> False Or TimerDiff($qDeadlock) > 50000
		Update("Quest: The Supremacy of Air - accepted!")
	EndIf
	Do
		ToLevelTwo()
		$leveltwo = GetLevel()
	Until $leveltwo > 1
EndFunc   ;==>Elementalist0
#endregion Elementalist


#region Extra_Paths
Func ToLevelTwo()
	;  New Map Pre-Searing: Ashford Abbey, ID 164
	Update("Zoning to Abbey")
		RndTravel(164) ;  New Map Pre-Searing: Ashford Abbey.
		Pingsleep(500)
		Switch GetHeroProfession(0)
			Case 1 ; warrior
				Update("Loading Skillbar")
				LoadSkillTemplate("OQAAE+NAAWrAAAAAAA",0) ; sever artery | healsig  --- skels immune to bleed and we dont have hamstring or firestorm!!!!!
			Case 2 ; ranger
				Update("Loading Skillbar")
				LoadSkillTemplate("OgAAEK23AAAAAAAAAA",0) ; powershot | troll ung
			Case 3 ; monk
				Update("Loading Skillbar")
				LoadSkillTemplate("OwAAE8DkoMj47eAAAA",0) ; banish | breeze
			Case 4 ; necromancer
				LoadSkillTemplate("OABAAcOXaZ22UAAA",0); vamp touch | blood renewal
			Case 5 ; mesmer
				LoadSkillTemplate("OQBAAfgiGMBAAAAA",0); conjure | ether feast
			Case 6 ; elementalist
				LoadSkillTemplate("OgBAACTbxIbO3AAA",0); flare | aura
		EndSwitch
		Pingsleep(200)
	MoveTo(-12960, -7790)
	MoveTo(-13288, -7401)
	MoveTo(-13724, -7150)
		Pingsleep(100)
	Update("Entering Catacombs for quick EXP")
	;  New Map The Catacombs, ID 145
		RandomPath(-13959, -7136, -139500, -7100, 50, 1, 4, -1)
			WaitMapLoading()
			Pingsleep(1000)
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(13984, 1974)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(13853, 974)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(13791, -32)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(12853, -398)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(11847, -430)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(10885, -153)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(10122, 496)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(9266, 1023)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(8361, 1451)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(7642, 838)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(6899.10, 219.93)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(6863, 206)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(5933, -187)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(5026, -616)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	MoveAggroing(4100, -1008)
	MiniCombat()
	Switch GetLevel()
		Case 2
			Return
		Case Else
			If GetIsDead(-2) = True Then
				Update("Died, waiting to res")
				PingSleep(5000)
				$WaypointCounter = 0
				Return
			EndIf
	EndSwitch
	Update("You aren't lvl 2 by now, something is wrong.")
EndFunc   ;==>ToLevelTwo

Func LevelTenPrep()
	Update("Vangaurd Virgin: Checking for Quest")
	Pingsleep(100)
	Switch GetQuestByID($qFarmer)
		Case False
			Update("Grabbing Vanguard Quest")
			RndTravel(148)
			MoveTo(7911, 6127, 20)
			MoveTo(9326, 7459, 10)
			MoveTo(10554, 77869)
			GoNearestNPCToCoords(10613, 7907)
			PingSleep(200)
			AcceptQuest($qFarmer)
			PingSleep(200)
			Update("Waiting for quest acceptance...")
			Do
				Sleep(100)
			Until GetQuestById($qFarmer) <> 0
			Update("Vanguard quest taken, continuing")
			Pingsleep(50)
			ToggleQuestWindow()
			If GetMapID() <> $MapFoiblesFair Then RndTravel($MapFoiblesFair)
		Case Else
			If GetMapID() <> $MapFoiblesFair Then RndTravel($MapFoiblesFair)
	EndSwitch
	Update("Vanguard Virgin: Checking for Outpost")
	PingSleep(1000)
	If GetMapID() <> $MapFoiblesFair Then
		Update("Running to Foibles")
		RndTravel($MapAshford)
		Pingsleep(200)
		MoveTo(-11350, -6244, 10)
		RandomPath(-11340, -6290, -11400, -6200, 50, 1, 4, -1)
		Update("Running to Foibles: Lakeside")
		WaitMapLoading(146) ;  New Map Lakeside County
		MoveTo(-11014, -6928)
		MoveTo(-11033, -7937)
		MoveTo(-11152, -8935)
		MoveTo(-11322, -9929)
		MoveTo(-11493, -10923)
		MoveTo(-11723, -11905)
		MoveTo(-12016, -12869)
		MoveTo(-12332, -13821)
		MoveTo(-12595, -14794)
		MoveTo(-12749, -15786)
		MoveTo(-12499, -16763)
		MoveTo(-12139, -17705)
		MoveTo(-11698, -18612)
		MoveTo(-10767, -18992)
		MoveTo(-11525, -19648)
		MoveTo(-12499, -19887)
		MoveTo(-13494, -20052)
		;  New Map Wizard's Folly, ID 161
		RandomPath(-13860, -20000, -13800, -20050, 50, 1, 4, -1)
		Update("Running to Foibles: Wizard's")
		WaitMapLoading(161) ;  New Map Wizard's Folly
		MoveTo(9175, 19160)
		MoveTo(8770, 18238)
		MoveTo(8528.43, 17698.46) ; MapID: 161
		MoveTo(8475, 17281)
		MoveTo(8153, 16324)
		MoveTo(7518.14, 15761.04) ; MapID: 161
		MoveTo(7333, 15742)
		MoveTo(6331, 15630)
		MoveTo(5771, 14791)
		MoveTo(5209, 13954)
		MoveTo(4642, 13119)
		MoveTo(4192, 12218)
		MoveTo(3742, 11315)
		MoveTo(3041, 10591)
		MoveTo(2628, 9672)
		MoveTo(2172, 8777)
		MoveTo(1823, 7840)
		MoveTo(1510, 6884)
		MoveTo(1047.65, 6720.34) ; MapID: 161
		MoveTo(580, 7263)
		;  New Map Pre-Searing: Foibles Fair, ID 165
		RandomPath(358, 7632, 380, 7500, 50, 1, 4, -1)
		Update("Running to Foibles: Arrived")
		WaitMapLoading(165) ;  New Map Pre-Searing: Foibles Fair
		PingSleep(200)
	EndIf
EndFunc   ;==>LevelTenPrep

Func RunToFoibles()
	Update("Running to Foibles")
	RndTravel($MapAshford)
	Pingsleep(200)
	MoveTo(-11350, -6244, 10)
	RandomPath(-11340, -6290, -11400, -6200, 50, 1, 4, -1)
	Update("Running to Foibles: Lakeside")
	WaitMapLoading(146) ;  New Map Lakeside County
	MoveTo(-11014, -6928)
	MoveTo(-11033, -7937)
	MoveTo(-11152, -8935)
	MoveTo(-11322, -9929)
	MoveTo(-11493, -10923)
	MoveTo(-11723, -11905)
	MoveTo(-12016, -12869)
	MoveTo(-12332, -13821)
	MoveTo(-12595, -14794)
	MoveTo(-12749, -15786)
	MoveTo(-12499, -16763)
	MoveTo(-12139, -17705)
	MoveTo(-11698, -18612)
	MoveTo(-10767, -18992)
	MoveTo(-11525, -19648)
	MoveTo(-12499, -19887)
	MoveTo(-13639, -20036)
	;  New Map Wizard's Folly, ID 161
	RandomPath(-13960, -20000, -14000, -20050, 50, 1, 4, -1)
	Update("Running to Foibles: Wizard's")
	WaitMapLoading(161) ;  New Map Wizard's Folly
	MoveTo(9175, 19160)
	MoveTo(8770, 18238)
	MoveTo(8528.43, 17698.46) ; MapID: 161
	MoveTo(8475, 17281)
	MoveTo(8153, 16324)
	MoveTo(7518.14, 15761.04) ; MapID: 161
	MoveTo(7333, 15742)
	MoveTo(6331, 15630)
	MoveTo(5771, 14791)
	MoveTo(5209, 13954)
	MoveTo(4642, 13119)
	MoveTo(4192, 12218)
	MoveTo(3742, 11315)
	MoveTo(3041, 10591)
	MoveTo(2628, 9672)
	MoveTo(2172, 8777)
	MoveTo(1823, 7840)
	MoveTo(1510, 6884)
	MoveTo(1047.65, 6720.34) ; MapID: 161
	MoveTo(580, 7263)
	;  New Map Pre-Searing: Foibles Fair, ID 165
	RandomPath(358, 7632, 380, 7500, 50, 1, 4, -1)
	Update("Running to Foibles: Arrived")
	WaitMapLoading(165) ;  New Map Pre-Searing: Foibles Fair
	PingSleep(200)
EndFunc   ;==>RunToFoibles
#endregion Extra_Paths


#region Extra_Funcs
;~ Description: Agents X and Y Location
Func XandYLocation($aAgent = -2)
	If IsDllStruct($aAgent) = 0 Then $aAgent = GetAgentByID($aAgent)
	Local $Location[2]
	$Location[0] = DllStructGetData($aAgent, 'X')
	$Location[1] = DllStructGetData($aAgent, 'Y')
	Return $Location
EndFunc   ;==>XandYLocation

; Params: MoveX, MoveY, Sleep after moving.
Func MoveAggroing($MoveToX, $MoveToY, $SleepTime = 0)
	;Local $WaypointCounter = 0
	$Blocked = 0
	$lBlocked = 0
	$lAngle = 0
	Update("Move to waypoint #" & $WaypointCounter)
	$WaypointCounter += 1
	MoveTo($MoveToX, $MoveToY)
	$SleepTimer = TimerInit()
	Do ;;;;;;;;;; Leader LOOP
		PingSleep(700)
		$Blocked += 1
		If $Blocked > 200 Then Return
		If Not $boolRun Then ExitLoop
		$MyLocation = XandYLocation() ; returns array
		If Not GetIsMoving(-2) Then
			$lBlocked += 1
			Move($MoveToX, $MoveToY)
			Sleep(200)
			If Mod($lBlocked, 2) == 0 And GetIsMoving(-2) == False Then
				$lAngle += 40
				Move($MyLocation[0] + 200 * Sin($lAngle), $MyLocation[1] + 200 * Cos($lAngle))
				PingSleep(500)
			EndIf
		EndIf
	Until ComputeDistance($MoveToX, $MoveToY, $MyLocation[0], $MyLocation[1]) < 200 And TimerDiff($SleepTimer) > $SleepTime
EndFunc   ;==>MoveAggroing

Func MiniCombat()
	TargetNearestEnemy()
	PingSleep(10)
	Do
		TargetNearestEnemy()
			PingSleep(10)
		Attack(-1)
		If GetHealth(-2) < 65 Then
			Update("Healing")
			UseSkillEx(2, -1) ; begin heal --
			PingSleep(100)
		EndIf
		If GetSkillBarSkillRecharge(1, 0) = 0 Then
			Update("Killing Enemy with damage")
			UseSkill(1, -1) ; baby damage
			PingSleep(30)
		EndIf
		If GetIsDead(-2) = True Then
			Update("Died, waiting to res")
			PingSleep(5000)
			$WaypointCounter = 0
			Return
		EndIf
	Until GetNumberOfFoesInRangeOfAgent(-2) = 0
	Refresh()
EndFunc   ;==>MiniCombat
#endregion Extra_Funcs