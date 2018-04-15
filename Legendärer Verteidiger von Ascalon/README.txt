 AutoIt Version: 3.3.6.0
 Stitched together by:         none1234
		 massive credits to maverick, 4d1 (http://www.gamerevision.com/showthread.php?2120-GWA%B2-LDoA-Bot)
		 lots of credit to jcaulton, tormiasz, cocophobia, starsoverstars, and the gwa2 crew

____Directions____________________________________________________________________________________

		1. make a pretty character in prophecies campaign
		2. skip cutscene
		3. run bot

____Notes_________________________________________________________________________________________

		-if farmer hamnet quest NOT available bot will hang.
			-> restart bot on farmer hamnet quest day and it will run as normal

		-to save time bot will NOT complete secondary prof quests, choose secondary profession, or
		 unlock all primary skills.

				-> if you want specific functionality, use JCAULTON's vanq autobot creator & insert a
				   new func into profpaths.au3.

					-> place a call for that func anywhere appopriate (suggested places are after
					   "Profession0" in Bot1 or in the "VirginVanguard" check

		-preferred skillbar setup for lvl 10-20:
			1 - regen
			2 - spam damage
			3 - aoe damage
			4 - damage
			5 - heal
			6 - heal
			7 - degen/damage

		-bot has capability to autoload templates, see template code function @ bottom of script

____Issues________________________________________________________________________________________

		-Lag during lvls 1-2
			-> if a quest is skipped to due to lag, recreate char & rerun script.
		-Render on main GUI