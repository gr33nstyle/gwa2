Tengu Bot base by Xun, improvements by Stepmother

- Farms "A Chance Encounter" for Ministerial Commendations
- Gets a nice amount of iron (other useful materials not so much)
- Gets a lot of lockpicks 
- A chance for nice OS items (including demon shields)
______________________________________________________________________________
Setup

If the character has never entered the "mission" before, enter it and listen to the dialog, then resign (or just entering and resign probably also works)
Hard mode succes is not tested 

Equipment:	(Sundering) Sword of Defense with "I Have The Power"
		Q9 Tactics Shield of Fortitude with +10vsFire
		Wilderness Survival +1 +2		
		Survivor Insignias
		Runes of Vitae

Hero Equipment: -check https://gwpvx.gamepedia.com/Build:Team_-_7_Hero_BiP_Melee_Support
		-if cheap and lazy, just add +4 Communing +3 Spawning and a 60HP staff to the ST and +1 +2 Blood Magic to the BiP

Player: OgEUQrqeVsSXF9F8E7g5i+GMHBAA
Hero 1: OAmjAykpZOYTr3jLcCNdmI3bMA (Disable skill 8)
Hero 2: OAhjQoGYIP3BBQVtZLNncDzxJA
Hero 3: OAhjYgHaIPPV7QVtZLNncDzqHA
Hero 4: OQhkAgBqAHK0Jw0TOACYempzQwFA
Hero 5: OQhkAgBqAHK0Jw0TOACYempzQwFA
Hero 6: OQhkAgBqAHK0Jw0TOACYempzQgAA
Hero 7: OgljwomICTXVfDKNLgjC1YhDCA

This is close to the best team you can have here, don't swap heroes around. It's 99% certain that your own setup is worse, 
	if not contact Stepmother and ask him to explain why your heroes are trash.
______________________________________________________________________________
When pressing Start:
1)Does inventory management (see below)
2)Travels to Kaneing Center
3)Loads player build
4)Kicks all Heroes
5)Adds Xandra, Livia, Master of Whispers, Gwen, Razah, Norgu, and Zhed Shadowhoof in that order (if using different Heroes -not builds- then change it in file, search for "AddHero($hero_xandra)" and replace the names of the heroes.)
6)Swap to HM if box is checked (HM succes is not tested)
7)Enters Mission
______________________________________________________________________________
When in mission:
-Loots everything but trash dyes and greens (if you want it to pick up those items then open Tengu Stable.au3 and ctrl+f for skipPickup)
______________________________________________________________________________
Inventory management 
-Select which bags you want to use and which materials/dyes you want to keep
-Tick the box if you want to keep unid goldies. This will fill up storage quite fast.
-When you have less than 7 free slot it manages it's inventory:
	-IDs all blues, purples, goldies
	-Salvages everything white/blue (except rare items, materials, certain dyes, kits,...)
	-Sells everything purple/gold (except rare items, materials, certain dyes, kits,...)
	-Stores everything you want it to store
	-Sells all mats, rare mats and useless dyes (altho it doesn't pick up every dye)
______________________________________________________________________________
Issues & fails:
-Some items break the salvage/identify function. Don't have storybooks in inventory. 	
	if any other items cause issues, contact Stepmother
-Team somehow fails the first fight (very rarely happens)
-It somehow was too slow with running to safespot (very rarely happens)
-There are too many Ministery Rangers with trapper build (causes 99% of the fails)
- Sometimes runs around like a clown after spike, possibly dieing in the process (very rarely happens)

-Very rarely stucks in outpost (requires restart)
-very rarely fails to ID everything (requires restart)