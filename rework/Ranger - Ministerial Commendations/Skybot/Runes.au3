;v1.0
global $runesArray[182][4] = [ _
	[0, "Lieutenant's Insignia [Warrior]", "08020824", false], _
	[1, "Stonefist Insignia [Warrior]", "09020824", false], _
	[2, "Dreadnought Insignia [Warrior]", "FA010824", false], _
	[3, "Sentinel's Insignia [Warrior]", "FB010824", true], _
	[4, "Warrior Rune of Minor Absorption", "EA02E827", false], _
	[5, "Warrior Rune of Minor Tactics", "0115E821", false], _
	[6, "Warrior Rune of Minor Strength", "0111E821", true], _
	[7, "Warrior Rune of Minor Axe Mastery", "0112E821", false], _
	[8, "Warrior Rune of Minor Hammer Mastery", "0113E821", false], _
	[9, "Warrior Rune of Minor Swordsmanship", "0114E821", false], _
	[10, "Warrior Rune of Major Absorption", "EA02E927", false], _
	[11, "Warrior Rune of Major Tactics", "0215E8217301", false], _
	[12, "Warrior Rune of Major Strength", "0211E8217301", false], _
	[13, "Warrior Rune of Major Axe Mastery", "0212E8217301", false], _
	[14, "Warrior Rune of Major Hammer Mastery", "0213E8217301", false], _
	[15, "Warrior Rune of Major Swordsmanship", "0214E8217301", false], _
	[16, "Warrior Rune of Superior Absorption", "EA02EA27", false], _
	[17, "Warrior Rune of Superior Tactics", "0315E8217F01", false], _
	[18, "Warrior Rune of Superior Strength", "0311E8217F01", false], _
	[19, "Warrior Rune of Superior Axe Mastery", "0312E8217F01", false], _
	[20, "Warrior Rune of Superior Hammer Mastery", "0313E8217F01", false], _
	[21, "Warrior Rune of Superior Swordsmanship", "0314E8217F01", false], _
	[22, "Frostbound Insignia [Ranger]", "FC010824", false], _
	[23, "Pyrebound Insignia [Ranger]", "FE010824", false], _
	[24, "Stormbound Insignia [Ranger]", "FF010824", false], _
	[25, "Scout's Insignia [Ranger]", "01020824", false], _
	[26, "Earthbound Insignia [Ranger]", "FD010824", false], _
	[27, "Beastmaster's Insignia [Ranger]", "00020824", false], _
	[28, "Ranger Rune of Minor Wilderness Survival", "0118E821", false], _
	[29, "Ranger Rune of Minor Expertise", "0117E821", false], _
	[30, "Ranger Rune of Minor Beast Mastery", "0116E821", false], _
	[31, "Ranger Rune of Minor Marksmanship", "0119E821", false], _
	[32, "Ranger Rune of Major Wilderness Survival", "0218E8217501", false], _
	[33, "Ranger Rune of Major Expertise", "0217E8217501", false], _
	[34, "Ranger Rune of Major Beast Mastery", "0216E8217501", false], _
	[35, "Ranger Rune of Major Marksmanship", "0219E8217501", false], _
	[36, "Ranger Rune of Superior Wilderness Survival", "0318E8218101", false], _
	[37, "Ranger Rune of Superior Expertise", "0317E8218101", true], _
	[38, "Ranger Rune of Superior Beast Mastery", "0316E8218101", false], _
	[39, "Ranger Rune of Superior Marksmanship", "0319E8218101", false], _
	[40, "Wanderer's Insignia [Monk]", "F6010824", false], _
	[41, "Disciple's Insignia [Monk]", "F7010824", false], _
	[42, "Anchorite's Insignia [Monk]", "F8010824", false], _
	[43, "Monk Rune of Minor Healing Prayers", "010DE821", false], _
	[44, "Monk Rune of Minor Smiting Prayers", "010EE821", false], _
	[45, "Monk Rune of Minor Protection Prayers", "010FE821", false], _
	[46, "Monk Rune of Minor Divine Favor", "0110E821", true], _
	[47, "Monk Rune of Major Healing Prayers", "020DE8217101", false], _
	[48, "Monk Rune of Major Smiting Prayers", "020EE8217101", false], _
	[49, "Monk Rune of Major Protection Prayers", "020FE8217101", false], _
	[50, "Monk Rune of Major Divine Favor", "0210E8217101", false], _
	[51, "Monk Rune of Superior Healing Prayers", "030DE8217D01", false], _
	[52, "Monk Rune of Superior Smiting Prayers", "030EE8217D01", false], _
	[53, "Monk Rune of Superior Protection Prayers", "030FE8217D01", false], _
	[54, "Monk Rune of Superior Divine Favor", "0310E8217D01", false], _
	[55, "Bloodstained Insignia [Necromancer]", "0A020824", false], _
	[56, "Tormentor's Insignia [Necromancer]", "EC010824", false], _
	[57, "Bonelace Insignia [Necromancer]", "EE010824", false], _
	[58, "Minion Master's Insignia [Necromancer]", "EF010824", false], _
	[59, "Blighter's Insignia [Necromancer]", "F0010824", false], _
	[60, "Undertaker's Insignia [Necromancer]", "ED010824", false], _
	[61, "Necromancer Rune of Minor Blood Magic", "0104E821", false], _
	[62, "Necromancer Rune of Minor Death Magic", "0105E821", false], _
	[63, "Necromancer Rune of Minor Curses", "0107E821", false], _
	[64, "Necromancer Rune of Minor Soul Reaping", "0106E821", true], _
	[65, "Necromancer Rune of Major Blood Magic", "0204E8216D01", false], _
	[66, "Necromancer Rune of Major Death Magic", "0205E8216D01", false], _
	[67, "Necromancer Rune of Major Curses", "0207E8216D01", false], _
	[68, "Necromancer Rune of Major Soul Reaping", "0206E8216D01", false], _
	[69, "Necromancer Rune of Superior Blood Magic", "0304E8217901", false], _
	[70, "Necromancer Rune of Superior Death Magic", "0305E8217901", true], _
	[71, "Necromancer Rune of Superior Curses", "0307E8217901", false], _
	[72, "Necromancer Rune of Superior Soul Reaping", "0306E8217901", false], _
	[73, "Virtuoso's Insignia [Mesmer]", "E4010824", false], _
	[74, "Artificer's Insignia [Mesmer]", "E2010824", false], _
	[75, "Prodigy's Insignia [Mesmer]", "E3010824", true], _
	[76, "Mesmer Rune of Minor Fast Casting", "0100E821", true], _
	[77, "Mesmer Rune of Minor Domination Magic", "0102E821", false], _
	[78, "Mesmer Rune of Minor Illusion Magic", "0101E821", true], _
	[79, "Mesmer Rune of Minor Inspiration Magic", "0103E821", true], _
	[80, "Mesmer Rune of Major Fast Casting", "0200E8216B01", false], _
	[81, "Mesmer Rune of Major Domination Magic", "0202E8216B01", false], _
	[82, "Mesmer Rune of Major Illusion Magic", "0201E8216B01", false], _
	[83, "Mesmer Rune of Major Inspiration Magic", "0203E8216B01", false], _
	[84, "Mesmer Rune of Superior Fast Casting", "0300E8217701", false], _
	[85, "Mesmer Rune of Superior Domination Magic", "0302E8217701", true], _
	[86, "Mesmer Rune of Superior Illusion Magic", "0301E8217701", true], _
	[87, "Mesmer Rune of Superior Inspiration Magic", "0303E8217701", false], _
	[88, "Hydromancer Insignia [Elementalist]", "F2010824", false], _
	[89, "Geomancer Insignia [Elementalist]", "F3010824", false], _
	[90, "Pyromancer Insignia [Elementalist]", "F4010824", false], _
	[91, "Aeromancer Insignia [Elementalist]", "F5010824", false], _
	[92, "Prismatic Insignia [Elementalist]", "F1010824", false], _
	[93, "Elementalist Rune of Minor Energy Storage", "010CE821", true], _
	[94, "Elementalist Rune of Minor Fire Magic", "010AE821", true], _
	[95, "Elementalist Rune of Minor Air Magic", "0108E821", false], _
	[96, "Elementalist Rune of Minor Earth Magic", "0109E821", false], _
	[97, "Elementalist Rune of Minor Water Magic", "010BE821", false], _
	[98, "Elementalist Rune of Major Energy Storage", "020CE8216F01", false], _
	[99, "Elementalist Rune of Major Fire Magic", "020AE8216F01", false], _
	[100, "Elementalist Rune of Major Air Magic", "0208E8216F01", false], _
	[101, "Elementalist Rune of Major Earth Magic", "0209E8216F01", false], _
	[102, "Elementalist Rune of Major Water Magic", "020BE8216F01", false], _
	[103, "Elementalist Rune of Superior Energy Storage", "030CE8217B01", true], _
	[104, "Elementalist Rune of Superior Fire Magic", "030AE8217B01", false], _
	[105, "Elementalist Rune of Superior Air Magic", "0308E8217B01", false], _
	[106, "Elementalist Rune of Superior Earth Magic", "0309E8217B01", false], _
	[107, "Elementalist Rune of Superior Water Magic", "030BE8217B01", false], _
	[108, "Vanguard's Insignia [Assassin]", "DE010824", false], _
	[109, "Infiltrator's Insignia [Assassin]", "DF010824", false], _
	[110, "Saboteur's Insignia [Assassin]", "E0010824", false], _
	[111, "Nightstalker's Insignia [Assassin]", "E1010824", true], _
	[112, "Assassin Rune of Minor Critical Strikes", "0123E821", true], _
	[113, "Assassin Rune of Minor Dagger Mastery", "011DE821", false], _
	[114, "Assassin Rune of Minor Deadly Arts", "011EE821", false], _
	[115, "Assassin Rune of Minor Shadow Arts", "011FE821", false], _
	[116, "Assassin Rune of Major Critical Strikes", "0223E8217902", false], _
	[117, "Assassin Rune of Major Dagger Mastery", "021DE8217902", false], _
	[118, "Assassin Rune of Major Deadly Arts", "021EE8217902", false], _
	[119, "Assassin Rune of Major Shadow Arts", "021FE8217902", false], _
	[120, "Assassin Rune of Superior Critical Strikes", "0323E8217B02", false], _
	[121, "Assassin Rune of Superior Dagger Mastery", "031DE8217B02", false], _
	[122, "Assassin Rune of Superior Deadly Arts", "031EE8217B02", false], _
	[123, "Assassin Rune of Superior Shadow Arts", "031FE8217B02", false], _
	[124, "Shaman's Insignia [Ritualist]", "04020824", true], _
	[125, "Ghost Forge Insignia [Ritualist]", "05020824", false], _
	[126, "Mystic's Insignia [Ritualist]", "06020824", false], _
	[127, "Ritualist Rune of Minor Channeling Magic", "0122E821", false], _
	[128, "Ritualist Rune of Minor Restoration Magic", "0121E821", false], _
	[129, "Ritualist Rune of Minor Communing", "0120E821", false], _
	[130, "Ritualist Rune of Minor Spawning Power", "0124E821", true], _
	[131, "Ritualist Rune of Major Channeling Magic", "0222E8217F02", false], _
	[132, "Ritualist Rune of Major Restoration Magic", "0221E8217F02", false], _
	[133, "Ritualist Rune of Major Communing", "0220E8217F02", false], _
	[134, "Ritualist Rune of Major Spawning Power", "0224E8217F02", false], _
	[135, "Ritualist Rune of Superior Channeling Magic", "0322E8218102", false], _
	[136, "Ritualist Rune of Superior Restoration Magic", "0321E8218102", false], _
	[137, "Ritualist Rune of Superior Communing", "0320E8218102", true], _
	[138, "Ritualist Rune of Superior Spawning Power", "0324E8218102", false], _
	[139, "Windwalker Insignia [Dervish]", "02020824", true], _
	[140, "Forsaken Insignia [Dervish]", "03020824", false], _
	[141, "Dervish Rune of Minor Mysticism", "012CE821", true], _
	[142, "Dervish Rune of Minor Earth Prayers", "012BE821", false], _
	[143, "Dervish Rune of Minor Scythe Mastery", "0129E821", true], _
	[144, "Dervish Rune of Minor Wind Prayers", "012AE821", false], _
	[145, "Dervish Rune of Major Mysticism", "022CE8210703", true], _
	[146, "Dervish Rune of Major Earth Prayers", "022BE8210703", false], _
	[147, "Dervish Rune of Major Scythe Mastery", "0229E8210703", false], _
	[148, "Dervish Rune of Major Wind Prayers", "022AE8210703", false], _
	[149, "Dervish Rune of Superior Mysticism", "032CE8210903", false], _
	[150, "Dervish Rune of Superior Earth Prayers", "032BE8210903", true], _
	[151, "Dervish Rune of Superior Scythe Mastery", "0329E8210903", false], _
	[152, "Dervish Rune of Superior Wind Prayers", "032AE8210903", false], _
	[153, "Centurion's Insignia [Paragon]", "07020824", true], _
	[154, "Paragon Rune of Minor Leadership", "0128E821", false], _
	[155, "Paragon Rune of Minor Motivation", "0127E821", false], _
	[156, "Paragon Rune of Minor Command", "0126E821", false], _
	[157, "Paragon Rune of Minor Spear Mastery", "0125E821", false], _
	[158, "Paragon Rune of Major Leadership", "0228E8210D03", false], _
	[159, "Paragon Rune of Major Motivation", "0227E8210D03", false], _
	[160, "Paragon Rune of Major Command", "0226E8210D03", false], _
	[161, "Paragon Rune of Major Spear Mastery", "0225E8210D03", false], _
	[162, "Paragon Rune of Superior Leadership", "0328E8210F03", false], _
	[163, "Paragon Rune of Superior Motivation", "0327E8210F03", false], _
	[164, "Paragon Rune of Superior Command", "0326E8210F03", false], _
	[165, "Paragon Rune of Superior Spear Mastery", "0325E8210F03", false], _
	[166, "Survivor Insignia", "E6010824", true], _
	[167, "Radiant Insignia", "E5010824", true], _
	[168, "Stalwart Insignia", "E7010824", false], _
	[169, "Brawler's Insignia", "E8010824", false], _
	[170, "Blessed Insignia", "E9010824", true], _
	[171, "Herald's Insignia", "EA010824", false], _
	[172, "Sentry's Insignia", "EB010824", false], _
	[173, "Rune of Minor Vigor", "C202E827", true], _
	[174, "Rune of Vitae", "000A4823", true], _
	[175, "Rune of Attunement", "0200D822", true], _
	[176, "Rune of Major Vigor", "C202E927", true], _
	[177, "Rune of Recovery", "07047827", false], _
	[178, "Rune of Restoration", "00037827", false], _
	[179, "Rune of Clarity", "01087827", true], _
	[180, "Rune of Purity", "05067827", false], _
	[181, "Rune of Superior Vigor", "C202EA27", true]]