;v1.0
global const $settingsFile = @ScriptDir & "\Skybot\Settings\" & $botName & ".ini"

func createOptionsTab()
	local $rowIncrement = 20
	local $column = 10
	local $row = 24
	global $checkbox_useBag1 = GUICtrlCreateCheckbox("Bag 1", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_useBag2 = GUICtrlCreateCheckbox("Bag 2", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_useBag3 = GUICtrlCreateCheckbox("Bag 3", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_useBag4 = GUICtrlCreateCheckbox("Bag 4", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_storeUnids = GUICtrlCreateCheckbox("Store unids", $column, $row)
	
endFunc

;Materials options
func createMaterialsTab()
	local $rowIncrement = 20
	local $column = 10
	local $row = 24
	global $checkbox_keepBone = GUICtrlCreateCheckbox("Bone", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepScale = GUICtrlCreateCheckbox("Scale", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepWood = GUICtrlCreateCheckbox("Wood", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepFiber = GUICtrlCreateCheckbox("Fiber", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepLinen = GUICtrlCreateCheckbox("Linen", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepEctoplasm = GUICtrlCreateCheckbox("Ectoplasm", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepClaw = GUICtrlCreateCheckbox("Claw", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepRuby = GUICtrlCreateCheckbox("Ruby", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepOnyx = GUICtrlCreateCheckbox("Onyx", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepGlassVial = GUICtrlCreateCheckbox("Glass Vial", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepVialOfInk = GUICtrlCreateCheckbox("Vial of Ink", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepSpiritwood = GUICtrlCreateCheckbox("Spiritwood", $column, $row)
	$row = $row + $rowIncrement
	
	$column = 110
	$row = 26
	global $checkbox_keepIron = GUICtrlCreateCheckbox("Iron", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepChitin = GUICtrlCreateCheckbox("Chitin", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepGranite = GUICtrlCreateCheckbox("Granite", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepFeather = GUICtrlCreateCheckbox("Feather", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepDamask = GUICtrlCreateCheckbox("Damask", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepSteel = GUICtrlCreateCheckbox("Steel", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepEye = GUICtrlCreateCheckbox("Eye", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepSapphire = GUICtrlCreateCheckbox("Sapphire", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepCharcoal = GUICtrlCreateCheckbox("Charcoal", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepLeather = GUICtrlCreateCheckbox("Leather", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepParchment = GUICtrlCreateCheckbox("Parchment", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepAmber = GUICtrlCreateCheckbox("Amber", $column, $row)
	$row = $row + $rowIncrement
	
	$column = 220
	$row = 26
	global $checkbox_keepTannedHide = GUICtrlCreateCheckbox("Tanned Hide", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepCloth = GUICtrlCreateCheckbox("Cloth", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepDust = GUICtrlCreateCheckbox("Dust", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepFur = GUICtrlCreateCheckbox("Fur", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepSilk = GUICtrlCreateCheckbox("Silk", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepDeldrimorSteel = GUICtrlCreateCheckbox("Deldrimor Steel", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepFang = GUICtrlCreateCheckbox("Fang", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepDiamond = GUICtrlCreateCheckbox("Diamond", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepObsidianShard = GUICtrlCreateCheckbox("Obsidian Shard", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepElonianLeather = GUICtrlCreateCheckbox("Elonian Leather", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepVellum = GUICtrlCreateCheckbox("Vellum", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepJadeite = GUICtrlCreateCheckbox("Jadeite", $column, $row)
endFunc

func createDyesTab()
local $rowIncrement = 20
	local $column = 10
	local $row = 24
	
	global $checkbox_keepGreen = GUICtrlCreateCheckbox("Green", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepPurple = GUICtrlCreateCheckbox("Purple", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepYellow = GUICtrlCreateCheckbox("Yellow", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepBrown = GUICtrlCreateCheckbox("Brown", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepOrange = GUICtrlCreateCheckbox("Orange", $column, $row)
	$row = $row + $rowIncrement	
	global $checkbox_keepGray = GUICtrlCreateCheckbox("Gray", $column, $row)
	$row = $row + $rowIncrement
	
	$column = 110
	$row = 26
	global $checkbox_keepSilver = GUICtrlCreateCheckbox("Silver", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepBlue = GUICtrlCreateCheckbox("Blue", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepRed = GUICtrlCreateCheckbox("Red", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepPink = GUICtrlCreateCheckbox("Pink", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepWhite = GUICtrlCreateCheckbox("White", $column, $row)
	$row = $row + $rowIncrement
	global $checkbox_keepBlack = GUICtrlCreateCheckbox("Black", $column, $row)
	$row = $row + $rowIncrement
endFunc

func loadSettings()
	GUICtrlSetState($checkbox_keepBone, iniRead($settingsFile, "materials", "Bone", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepScale, iniRead($settingsFile, "materials", "Scale", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepWood, iniRead($settingsFile, "materials", "Wood", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepFiber, iniRead($settingsFile, "materials", "Fiber", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepLinen, iniRead($settingsFile, "materials", "Linen", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepEctoplasm, iniRead($settingsFile, "materials", "Ectoplasm", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepClaw, iniRead($settingsFile, "materials", "Claw", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepRuby, iniRead($settingsFile, "materials", "Ruby", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepOnyx, iniRead($settingsFile, "materials", "Onyx", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepGlassVial, iniRead($settingsFile, "materials", "GlassVial", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepVialOfInk, iniRead($settingsFile, "materials", "VialOfInk", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepSpiritwood, iniRead($settingsFile, "materials", "Spiritwood", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepIron, iniRead($settingsFile, "materials", "Iron", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepChitin, iniRead($settingsFile, "materials", "Chitin", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepGranite, iniRead($settingsFile, "materials", "Granite", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepFeather, iniRead($settingsFile, "materials", "Feather", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepDamask, iniRead($settingsFile, "materials", "Damask", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepSteel, iniRead($settingsFile, "materials", "Steel", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepEye, iniRead($settingsFile, "materials", "Eye", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepSapphire, iniRead($settingsFile, "materials", "Sapphire", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepCharcoal, iniRead($settingsFile, "materials", "Charcoal", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepLeather, iniRead($settingsFile, "materials", "Leather", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepParchment, iniRead($settingsFile, "materials", "Parchment", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepAmber, iniRead($settingsFile, "materials", "Amber", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepTannedHide, iniRead($settingsFile, "materials", "TannedHide", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepCloth, iniRead($settingsFile, "materials", "Cloth", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepDust, iniRead($settingsFile, "materials", "Dust", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepFur, iniRead($settingsFile, "materials", "Fur", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepSilk, iniRead($settingsFile, "materials", "Silk", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepDeldrimorSteel, iniRead($settingsFile, "materials", "DeldrimorSteel", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepFang, iniRead($settingsFile, "materials", "Fang", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepDiamond, iniRead($settingsFile, "materials", "Diamond", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepObsidianShard, iniRead($settingsFile, "materials", "ObsidianShard", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepElonianLeather, iniRead($settingsFile, "materials", "ElonianLeather", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepVellum, iniRead($settingsFile, "materials", "Vellum", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_keepJadeite, iniRead($settingsFile, "materials", "Jadeite", $GUI_CHECKED))
	GUICtrlSetState($checkbox_useBag1, iniRead($settingsFile, "bags", "useBag1", $GUI_CHECKED))
	GUICtrlSetState($checkbox_useBag2, iniRead($settingsFile, "bags", "useBag2", $GUI_CHECKED))
	GUICtrlSetState($checkbox_useBag3, iniRead($settingsFile, "bags", "useBag3", $GUI_CHECKED))
	GUICtrlSetState($checkbox_useBag4, iniRead($settingsFile, "bags", "useBag4", $GUI_UNCHECKED))
	GUICtrlSetState($checkbox_storeUnids, iniRead($settingsFile, "other", "storeUnids", $GUI_CHECKED))
	
	GUICtrlSetState($checkbox_keepGreen, iniRead($settingsFile, "dyes", "Green", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepPurple, iniRead($settingsFile, "dyes", "Purple", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepYellow, iniRead($settingsFile, "dyes", "Yellow", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepBrown, iniRead($settingsFile, "dyes", "Brown", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepOrange, iniRead($settingsFile, "dyes", "Orange", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepGray, iniRead($settingsFile, "dyes", "Gray", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepSilver, iniRead($settingsFile, "dyes", "Silver", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepBlue, iniRead($settingsFile, "dyes", "Blue", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepRed, iniRead($settingsFile, "dyes", "Red", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepPink, iniRead($settingsFile, "dyes", "Pink", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepWhite, iniRead($settingsFile, "dyes", "White", $GUI_CHECKED))
	GUICtrlSetState($checkbox_keepBlack, iniRead($settingsFile, "dyes", "Black", $GUI_CHECKED))
	loadCustomOptions()
endFunc

func saveSettings()
	iniWrite($settingsFile, "materials", "Bone", GUICtrlRead($checkbox_keepBone))
	iniWrite($settingsFile, "materials", "Scale", GUICtrlRead($checkbox_keepScale))
	iniWrite($settingsFile, "materials", "Wood", GUICtrlRead($checkbox_keepWood))
	iniWrite($settingsFile, "materials", "Fiber", GUICtrlRead($checkbox_keepFiber))
	iniWrite($settingsFile, "materials", "Linen", GUICtrlRead($checkbox_keepLinen))
	iniWrite($settingsFile, "materials", "Ectoplasm", GUICtrlRead($checkbox_keepEctoplasm))
	iniWrite($settingsFile, "materials", "Claw", GUICtrlRead($checkbox_keepClaw))
	iniWrite($settingsFile, "materials", "Ruby", GUICtrlRead($checkbox_keepRuby))
	iniWrite($settingsFile, "materials", "Onyx", GUICtrlRead($checkbox_keepOnyx))
	iniWrite($settingsFile, "materials", "GlassVial", GUICtrlRead($checkbox_keepGlassVial))
	iniWrite($settingsFile, "materials", "VialOfInk", GUICtrlRead($checkbox_keepVialOfInk))
	iniWrite($settingsFile, "materials", "Spiritwood", GUICtrlRead($checkbox_keepSpiritwood))
	iniWrite($settingsFile, "materials", "Iron", GUICtrlRead($checkbox_keepIron))
	iniWrite($settingsFile, "materials", "Chitin", GUICtrlRead($checkbox_keepChitin))
	iniWrite($settingsFile, "materials", "Granite", GUICtrlRead($checkbox_keepGranite))
	iniWrite($settingsFile, "materials", "Feather", GUICtrlRead($checkbox_keepFeather))
	iniWrite($settingsFile, "materials", "Damask", GUICtrlRead($checkbox_keepDamask))
	iniWrite($settingsFile, "materials", "Steel", GUICtrlRead($checkbox_keepSteel))
	iniWrite($settingsFile, "materials", "Eye", GUICtrlRead($checkbox_keepEye))
	iniWrite($settingsFile, "materials", "Sapphire", GUICtrlRead($checkbox_keepSapphire))
	iniWrite($settingsFile, "materials", "Charcoal", GUICtrlRead($checkbox_keepCharcoal))
	iniWrite($settingsFile, "materials", "Leather", GUICtrlRead($checkbox_keepLeather))
	iniWrite($settingsFile, "materials", "Parchment", GUICtrlRead($checkbox_keepParchment))
	iniWrite($settingsFile, "materials", "Amber", GUICtrlRead($checkbox_keepAmber))
	iniWrite($settingsFile, "materials", "TannedHide", GUICtrlRead($checkbox_keepTannedHide))
	iniWrite($settingsFile, "materials", "Cloth", GUICtrlRead($checkbox_keepCloth))
	iniWrite($settingsFile, "materials", "Dust", GUICtrlRead($checkbox_keepDust))
	iniWrite($settingsFile, "materials", "Fur", GUICtrlRead($checkbox_keepFur))
	iniWrite($settingsFile, "materials", "Silk", GUICtrlRead($checkbox_keepSilk))
	iniWrite($settingsFile, "materials", "DeldrimorSteel", GUICtrlRead($checkbox_keepDeldrimorSteel))
	iniWrite($settingsFile, "materials", "Fang", GUICtrlRead($checkbox_keepFang))
	iniWrite($settingsFile, "materials", "Diamond", GUICtrlRead($checkbox_keepDiamond))
	iniWrite($settingsFile, "materials", "ObsidianShard", GUICtrlRead($checkbox_keepObsidianShard))
	iniWrite($settingsFile, "materials", "ElonianLeather", GUICtrlRead($checkbox_keepElonianLeather))
	iniWrite($settingsFile, "materials", "Vellum", GUICtrlRead($checkbox_keepVellum))
	iniWrite($settingsFile, "materials", "Jadeite", GUICtrlRead($checkbox_keepJadeite))
	
	iniWrite($settingsFile, "bags", "useBag1", GUICtrlRead($checkbox_useBag1))
	iniWrite($settingsFile, "bags", "useBag2", GUICtrlRead($checkbox_useBag2))
	iniWrite($settingsFile, "bags", "useBag3", GUICtrlRead($checkbox_useBag3))
	iniWrite($settingsFile, "bags", "useBag4", GUICtrlRead($checkbox_useBag4))
	iniWrite($settingsFile, "other", "storeUnids", GUICtrlRead($checkbox_storeUnids))
	
	iniWrite($settingsFile, "dyes", "Green", GUICtrlRead($checkbox_keepGreen))
	iniWrite($settingsFile, "dyes", "Purple", GUICtrlRead($checkbox_keepPurple))
	iniWrite($settingsFile, "dyes", "Yellow", GUICtrlRead($checkbox_keepYellow))
	iniWrite($settingsFile, "dyes", "Brown", GUICtrlRead($checkbox_keepBrown))
	iniWrite($settingsFile, "dyes", "Orange", GUICtrlRead($checkbox_keepOrange))
	iniWrite($settingsFile, "dyes", "Gray", GUICtrlRead($checkbox_keepGray))
	iniWrite($settingsFile, "dyes", "Silver", GUICtrlRead($checkbox_keepSilver))
	iniWrite($settingsFile, "dyes", "Blue", GUICtrlRead($checkbox_keepBlue))
	iniWrite($settingsFile, "dyes", "Red", GUICtrlRead($checkbox_keepRed))
	iniWrite($settingsFile, "dyes", "Pink", GUICtrlRead($checkbox_keepPink))
	iniWrite($settingsFile, "dyes", "White", GUICtrlRead($checkbox_keepWhite))
	iniWrite($settingsFile, "dyes", "Black", GUICtrlRead($checkbox_keepBlack))
	saveCustomOptions()
	writeLog("Saved settings")
endFunc


