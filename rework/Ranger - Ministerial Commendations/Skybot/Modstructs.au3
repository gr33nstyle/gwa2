 Func IsPerfectShield($item) ; Need to add -5(20%)
    Local $ModStruct = GetModStruct($item)
	; Universal mods
    Local $Plus30 = StringInStr($ModStruct, "001E4823", 0, 1) ; Mod struct for +30 (shield only?)	
	Local $Plus44Ench = StringInStr($ModStruct, "02C6823", 0, 1) ; For +44ench
	Local $Plus45Ench = StringInStr($ModStruct, "02D6823", 0, 1) ; Mod struct for +45ench	
	Local $Plus44Stance = StringInStr($ModStruct, "02C8823", 0, 1) ; For +44Stance
	Local $Plus45Stance = StringInStr($ModStruct, "02D8823", 0, 1) ; For +45Stance
	Local $Plus60Hex= StringInStr($ModStruct, "03C7823", 0, 1) ; For +60wHex  
	
	Local $Minus2Ench = StringInStr($ModStruct, "2008820", 0, 1) ; Mod struct for -2Ench
	Local $Minus2Stance = StringInStr($ModStruct, "200A820", 0, 1) ; Mod Struct for -2Stance
	Local $Minus3Hex = StringInStr($ModStruct, "3009820", 0, 1) ; Mod struct for -3wHex (shield only?)
	Local $Minus520 = StringInStr($ModStruct, "5147820", 0, 1) ; For -5(20%)
	; +1 20% Mods
	Local $PlusDomination = StringInStr($ModStruct, "0218240", 0, 1) ; +1 Dom 20%
	Local $PlusDivine = StringInStr($ModStruct, "1018240", 0, 1) ; +1 Divine 20%
	Local $PlusSmite = StringInStr($ModStruct, "0E18240", 0, 1) ; +1 Smite 20%
	Local $PlusHealing = StringInStr($ModStruct, "0D18240", 0, 1) ; +1 Heal 20%
	Local $PlusProt = StringInStr($ModStruct, "0F18240", 0, 1) ; +1 Prot 20%
	Local $PlusFire = StringInStr($ModStruct, "0A18240", 0, 1) ; +1 Fire 20%
	Local $PlusWater = StringInStr($ModStruct, "0B18240", 0, 1) ; +1 Water 20%
	Local $PlusAir = StringInStr($ModStruct, "0818240", 0, 1) ; +1 Air 20%
	Local $PlusEarth = StringInStr($ModStruct, "0918240", 0, 1) ; +1 Earth 20%
	Local $PlusDeath = StringInStr($ModStruct, "0518240", 0, 1) ; +1 Death 20%
	Local $PlusBlood = StringInStr($ModStruct, "0418240", 0, 1) ; +1 Blood 20%
	; +10vs Mods
	Local $PlusDemons = StringInStr($ModStruct, "0A084821", 0, 1) ; +10vs Demons
	Local $PlusPiercing = StringInStr($ModStruct, "A0118210", 0, 1) ; +10vs Piercing
    Local $PlusDragons = StringInStr($ModStruct, "A0948210", 0, 1) ; +10vs Dragons
	Local $PlusLightning = StringInStr($ModStruct, "A0418210", 0, 1) ; +10vs Lightning
	Local $PlusVsEarth = StringInStr($ModStruct, "A0B18210", 0, 1) ; +10vs Earth
	Local $PlusPlants = StringInStr($ModStruct, "A0348210", 0, 1) ; +10vs Plants
	Local $PlusCold = StringInStr($ModStruct, "A0318210", 0, 1) ; +10 vs Cold
	Local $PlusUndead = StringInStr($ModStruct, "A0048210", 0, 1) ; +10vs Undead
	Local $PlusSlashing = StringInStr($ModStruct, "A0218210", 0, 1) ; +10vs Slashing
    Local $PlusTengu = StringInStr($ModStruct, "A0748210", 0, 1) ; +10vs Tengu
	Local $PlusVsFire = StringInStr($ModStruct, "A0518210", 0, 1) ; +10vs Fire

    If $Plus30 > 0 Then
	   If $PlusDemons > 0 Or $PlusPiercing > 0 Or $PlusDragons > 0 Or $PlusLightning > 0 Or $PlusVsEarth > 0 Or $PlusPlants > 0 Or $PlusCold > 0 Or $PlusUndead > 0 Or $PlusSlashing > 0 Or $PlusTengu > 0 Or $PlusVsFire > 0 Then
	      Return True
	   ElseIf $PlusDomination > 0 Or $PlusDivine > 0 Or $PlusSmite > 0 Or $PlusHealing > 0 Or $PlusProt > 0 Or $PlusFire > 0 Or $PlusWater > 0 Or $PlusAir > 0 Or $PlusEarth > 0 Or $PlusDeath > 0 Or $PlusBlood > 0 Then
		  Return True
	   ElseIf $Minus2Stance > 0 Or $Minus2Ench > 0 Or $Minus520 > 0 Or $Minus3Hex > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
	EndIf
    If $Plus45Ench > 0 Then
	   If $PlusDemons > 0 Or $PlusPiercing > 0 Or $PlusDragons > 0 Or $PlusLightning > 0 Or $PlusVsEarth > 0 Or $PlusPlants > 0 Or $PlusCold > 0 Or $PlusUndead > 0 Or $PlusSlashing > 0 Or $PlusTengu > 0 Or $PlusVsFire > 0 Then
	      Return True
	   ElseIf $Minus2Ench > 0 Then
		  Return True
	   ElseIf $PlusDomination > 0 Or $PlusDivine > 0 Or $PlusSmite > 0 Or $PlusHealing > 0 Or $PlusProt > 0 Or $PlusFire > 0 Or $PlusWater > 0 Or $PlusAir > 0 Or $PlusEarth > 0 Or $PlusDeath > 0 Or $PlusBlood > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
	EndIf
	If $Minus2Ench > 0 Then
	   If $PlusDemons > 0 Or $PlusPiercing > 0 Or $PlusDragons > 0 Or $PlusLightning > 0 Or $PlusVsEarth > 0 Or $PlusPlants > 0 Or $PlusCold > 0 Or $PlusUndead > 0 Or $PlusSlashing > 0 Or $PlusTengu > 0 Or $PlusVsFire > 0 Then
		  Return True
	   EndIf
	EndIf
    If $Plus44Ench > 0 Then
	   If $PlusDemons > 0 Then
	      Return True
	   EndIf
	EndIf
    If $Plus45Stance > 0 Then
	   If $Minus2Stance > 0 Then
	      Return True
	   EndIf
	EndIf
	Return False
 EndFunc
 Func IsPerfectStaff($item)
	Local $ModStruct = GetModStruct($item)
	Local $A = GetItemAttribute($item)
	; Ele mods
	Local $Fire20Casting = StringInStr($ModStruct, "0A141822", 0, 1) ; Mod struct for 20% fire
	Local $Water20Casting = StringInStr($ModStruct, "0B141822", 0, 1) ; Mod struct for 20% water
	Local $Air20Casting = StringInStr($ModStruct, "08141822", 0, 1) ; Mod struct for 20% air
	Local $Earth20Casting = StringInStr($ModStruct, "09141822", 0, 1)
	Local $Energy20Casting = StringInStr($ModStruct, "0C141822", 0, 1)
	; Monk mods
	Local $Smite20Casting = StringInStr($ModStruct, "0E141822", 0, 1) ; Mod struct for 20% smite
	Local $Divine20Casting = StringInStr($ModStruct, "10141822", 0, 1) ; Mod struct for 20% divine
	Local $Healing20Casting = StringInStr($ModStruct, "0D141822", 0, 1) ; Mod struct for 20% healing
	Local $Protection20Casting = StringInStr($ModStruct, "0F141822", 0, 1) ; Mod struct for 20% protection
	; Rit mods
	Local $Channeling20Casting = StringInStr($ModStruct, "22141822", 0, 1) ; Mod struct for 20% channeling
	Local $Restoration20Casting = StringInStr($ModStruct, "21141822", 0, 1)
	; Mes mods
	Local $Domination20Casting = StringInStr($ModStruct, "02141822", 0, 1) ; Mod struct for 20% domination
	; Necro mods
	Local $Death20Casting = StringInStr($ModStruct, "05141822", 0, 1) ; Mod struct for 20% death
	Local $Blood20Casting = StringInStr($ModStruct, "04141822", 0, 1)

	Switch $A
    Case 2 ; Domination
	   If $Domination20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 4 ; Blood
	   If $Blood20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 5 ; Death
	   If $Death20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 8 ; Air
	   If $Air20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 9 ; Earth
	   If $Earth20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 10 ; Fire
	   If $Fire20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 11 ; Water
	   If $Water20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 12 ; Energy Storage
	   If $Air20Casting > 0 Or $Earth20Casting > 0 Or $Fire20Casting > 0 Or $Water20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 13 ; Healing
	   If $Healing20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 14 ; Smiting
	   If $Smite20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 15 ; Protection
	   If $Protection20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 16 ; Divine
	   If $Healing20Casting > 0 Or $Protection20Casting > 0 Or $Divine20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 33 ; Restoration
	   If $Restoration20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
    Case 34 ; Channeling
	   If $Channeling20Casting > 0 Then
		  Return True
	   Else
		  Return False
	   EndIf
	EndSwitch
	Return False
 EndFunc
 Func IsPerfectCaster($item)
	Local $ModStruct = GetModStruct($item)
	Local $A = GetItemAttribute($item)
    ; Universal mods
    Local $PlusFive = StringInStr($ModStruct, "5320823", 0, 1) ; Mod struct for +5^50
	Local $PlusFiveEnch = StringInStr($ModStruct, "500F822", 0, 1)
	Local $10Cast = StringInStr($ModStruct, "A0822", 0, 1) ; Mod struct for 10% cast
	Local $10Recharge = StringInStr($ModStruct, "AA823", 0, 1) ; Mod struct for 10% recharge
	; Ele mods
	Local $Fire20Casting = StringInStr($ModStruct, "0A141822", 0, 1) ; Mod struct for 20% fire
	Local $Fire20Recharge = StringInStr($ModStruct, "0A149823", 0, 1)
	Local $Water20Casting = StringInStr($ModStruct, "0B141822", 0, 1) ; Mod struct for 20% water
	Local $Water20Recharge = StringInStr($ModStruct, "0B149823", 0, 1)
	Local $Air20Casting = StringInStr($ModStruct, "08141822", 0, 1) ; Mod struct for 20% air
	Local $Air20Recharge = StringInStr($ModStruct, "08149823", 0, 1)
	Local $Earth20Casting = StringInStr($ModStruct, "09141822", 0, 1)
	Local $Earth20Recharge = StringInStr($ModStruct, "09149823", 0, 1)
	Local $Energy20Casting = StringInStr($ModStruct, "0C141822", 0, 1)
	Local $Energy20Recharge = StringInStr($ModStruct, "0C149823", 0, 1)
	; Monk mods
	Local $Smiting20Casting = StringInStr($ModStruct, "0E141822", 0, 1) ; Mod struct for 20% smite
	Local $Smiting20Recharge = StringInStr($ModStruct, "0E149823", 0, 1)
	Local $Divine20Casting = StringInStr($ModStruct, "10141822", 0, 1) ; Mod struct for 20% divine
	Local $Divine20Recharge = StringInStr($ModStruct, "10149823", 0, 1)
	Local $Healing20Casting = StringInStr($ModStruct, "0D141822", 0, 1) ; Mod struct for 20% healing
	Local $Healing20Recharge = StringInStr($ModStruct, "0D149823", 0, 1)
	Local $Protection20Casting = StringInStr($ModStruct, "0F141822", 0, 1) ; Mod struct for 20% protection
	Local $Protection20Recharge = StringInStr($ModStruct, "0F149823", 0, 1)
	; Rit mods
	Local $Channeling20Casting = StringInStr($ModStruct, "22141822", 0, 1) ; Mod struct for 20% channeling
	Local $Channeling20Recharge = StringInStr($ModStruct, "22149823", 0, 1)
	Local $Restoration20Casting = StringInStr($ModStruct, "21141822", 0, 1)
	Local $Restoration20Recharge = StringInStr($ModStruct, "21149823", 0, 1)
	; Mes mods
	Local $Domination20Casting = StringInStr($ModStruct, "02141822", 0, 1) ; Mod struct for 20% domination
    Local $Domination20Recharge = StringInStr($ModStruct, "02149823", 0, 1) ; Mod struct for 20% domination recharge
	Local $Illusion20Casting = StringInStr($ModStruct, "01141822", 0, 1) ; Mod struct for 20% illusion HCT
	Local $Illusion20Recharge = StringInStr($ModStruct, "01149823", 0, 1) ; Mod struct for 20% illusion HSR
	; Necro mods
    Local $Death20Casting = StringInStr($ModStruct, "05141822", 0, 1) ; Mod struct for 20% death
	Local $Death20Recharge = StringInStr($ModStruct, "05149823", 0, 1)
    Local $Blood20Recharge = StringInStr($ModStruct, "04149823", 0, 1)
	Local $Blood20Casting = StringInStr($ModStruct, "04141822", 0, 1)

	Switch $A
    Case 2 ; Domination
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Domination20Casting > 0 Or $Domination20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Domination20Recharge > 0 Or $Domination20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Domination20Recharge > 0 Then
		  If $Domination20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 4 ; Blood
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Blood20Casting > 0 Or $Blood20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Blood20Recharge > 0 Or $Blood20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Blood20Recharge > 0 Then
		  If $Blood20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 5 ; Death
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Death20Casting > 0 Or $Death20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Death20Recharge > 0 Or $Death20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Death20Recharge > 0 Then
		  If $Death20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 8 ; Air
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Air20Casting > 0 Or $Air20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Air20Recharge > 0 Or $Air20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Air20Recharge > 0 Then
		  If $Air20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 9 ; Earth
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Earth20Casting > 0 Or $Earth20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Earth20Recharge > 0 Or $Earth20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Earth20Recharge > 0 Then
		  If $Earth20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
       Return False
    Case 10 ; Fire
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Fire20Casting > 0 Or $Fire20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Fire20Recharge > 0 Or $Fire20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Fire20Recharge > 0 Then
		  If $Fire20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
       Return False
    Case 11 ; Water
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Water20Casting > 0 Or $Water20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Water20Recharge > 0 Or $Water20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Water20Recharge > 0 Then
		  If $Water20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 12 ; Energy Storage
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Energy20Casting > 0 Or $Energy20Recharge > 0 Or $Water20Casting > 0 Or $Water20Recharge > 0 Or $Fire20Casting > 0 Or $Fire20Recharge > 0 Or $Earth20Casting > 0 Or $Earth20Recharge > 0 Or $Air20Casting > 0 Or $Air20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Energy20Recharge > 0 Or $Energy20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Or $Water20Casting > 0 Or $Water20Recharge > 0 Or $Fire20Casting > 0 Or $Fire20Recharge > 0 Or $Earth20Casting > 0 Or $Earth20Recharge > 0 Or $Air20Casting > 0 Or $Air20Recharge > 0 Then
		     Return True
		  EndIf
       EndIf
	   If $Energy20Recharge > 0 Then
		  If $Energy20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $10Cast > 0 Or $10Recharge > 0 Then
		  If $Water20Casting > 0 Or $Water20Recharge > 0 Or $Fire20Casting > 0 Or $Fire20Recharge > 0 Or $Earth20Casting > 0 Or $Earth20Recharge > 0 Or $Air20Casting > 0 Or $Air20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 13 ; Healing
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Healing20Casting > 0 Or $Healing20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Healing20Recharge > 0 Or $Healing20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Healing20Recharge > 0 Then
		  If $Healing20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 14 ; Smiting
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Smiting20Casting > 0 Or $Smiting20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Smiting20Recharge > 0 Or $Smiting20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Smiting20Recharge > 0 Then
		  If $Smiting20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 15 ; Protection
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Protection20Casting > 0 Or $Protection20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Protection20Recharge > 0 Or $Protection20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Protection20Recharge > 0 Then
		  If $Protection20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 16 ; Divine
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Divine20Casting > 0 Or $Divine20Recharge > 0 Or $Healing20Casting > 0 Or $Healing20Recharge > 0 Or $Smiting20Casting > 0 Or $Smiting20Recharge > 0 Or $Protection20Casting > 0 Or $Protection20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Divine20Recharge > 0 Or $Divine20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Or $Healing20Casting > 0 Or $Healing20Recharge > 0 Or $Smiting20Casting > 0 Or $Smiting20Recharge > 0 Or $Protection20Casting > 0 Or $Protection20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Divine20Recharge > 0 Then
		  If $Divine20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $10Cast > 0 Or $10Recharge > 0 Then
		  If $Healing20Casting > 0 Or $Healing20Recharge > 0 Or $Smiting20Casting > 0 Or $Smiting20Recharge > 0 Or $Protection20Casting > 0 Or $Protection20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
	Case 33 ; Restoration
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Restoration20Casting > 0 Or $Restoration20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Restoration20Recharge > 0 Or $Restoration20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Restoration20Recharge > 0 Then
		  If $Restoration20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    Case 34 ; Channeling
	   If $PlusFive > 0 Or $PlusFiveEnch > 0 Then
		  If $Channeling20Casting > 0 Or $Channeling20Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Channeling20Recharge > 0 Or $Channeling20Casting > 0 Then
		  If $10Cast > 0 Or $10Recharge > 0 Then
		     Return True
		  EndIf
	   EndIf
	   If $Channeling20Recharge > 0 Then
		  If $Channeling20Casting > 0 Then
		     Return True
		  EndIf
	   EndIf
	   Return False
    EndSwitch
    Return False
 EndFunc
 
Func IsPerfectMartial($item)
	Local $ModStruct = GetModStruct($item)
	Local $Oldschool5e = StringInStr($ModStruct, "0500D822", 0, 1) ; Oldschool +5e on martial weapons
	Local $15DmgwEnch = StringInStr($ModStruct, "0F006822", 0, 1) ; 15%wEnch
	; if IsReq9Max($item) then
		; if ($Oldschool5e > 0) then
			; return true
		; else
			; return false
		; endif
	; endif
endfunc

 Func IsRareRune($item)
    Local $ModStruct = GetModStruct($item)	
	Local $MinorVigor = StringInStr($ModStruct, "C202E827", 0, 1) 			;Vigors
	Local $MajorVigor = StringInStr($ModStruct, "C202E927", 0, 1)
	Local $SupVigor = StringInStr($ModStruct, "C202EA27", 0, 1)
	
	Local $Vitae = StringInStr($ModStruct, "000A4823", 0, 1);				;Neutral Runes
	Local $Attunement = StringInStr($ModStruct, "0200D822", 0, 1)
	Local $Clarity = StringInStr($ModStruct, "01087827", 0, 1) 
	
	Local $Survivor = StringInStr($ModStruct, "0005D826", 0, 1)				;Neutral Insignias
	Local $Blessed = StringInStr($ModStruct, "E9010824", 0, 1)
	Local $Radiant = StringInStr($ModStruct, "E5010824", 0, 1)
;	Local $Sentinel = StringInStr($ModStruct, "FB010824", 0, 1)

	Local $MinorScythe = StringInStr($ModStruct, "0129E821", 0, 1)			;Dervish
	Local $WindWalker = StringInStr($ModStruct, "02020824", 0, 1)
	Local $MinorMyst = StringInStr($ModStruct, "05033025012CE821", 0, 1)
	Local $SupEarthPrayers = StringInStr($ModStruct, "32BE82109033025", 0, 1) 
	
	Local $MinorDivine = StringInStr($ModStruct, "0110E821", 0, 1)			;Monk
	
	Local $MinorDeath = StringInStr($ModStruct, "0105E821", 0, 1)			;Necromancer
	Local $SupDeath = StringInStr($ModStruct, "0305E8217901", 0, 1)
	Local $MinorSoulReaping = StringInStr($ModStruct, "0106E821", 0, 1)
	
	Local $MinorFastCasting = StringInStr($ModStruct, "0100E821", 0, 1)		;Mesmer
	Local $MinorInspiration = StringInStr($ModStruct, "0103E821", 0, 1)
	Local $MinorIllusion = StringInStr($ModStruct, "0101E821", 0, 1)
	Local $Prodigy = StringInStr($ModStruct, "C60330A5000528A7", 0, 1) 
	Local $SupDom = StringInStr($ModStruct, "30250302E821770", 0, 1) 
	
	Local $MinorEnergyStorage = StringInStr($ModStruct, "010CE821", 0, 1)	;Ele
	
	Local $MinorSpawning = StringInStr($ModStruct, "0124E821", 0, 1)		;Rit	
	Local $Shaman = StringInStr($ModStruct, "04020824", 0, 1)			
	Local $SupCommuning = StringInStr($ModStruct, "0320E8218102", 0, 1)
	
	Local $Centurion = StringInStr($ModStruct, "07020824", 0, 1)			;Paragon


	If ($SupVigor > 0) Or ($MajorVigor > 0) Or ($MinorVigor > 0) Then ; Health Runes
		Return True
	ElseIf($Vitae > 0) or ($Attunement > 0) or ($Clarity > 0) Then ; Neutral Runes
		Return True
	ElseIf ($Survivor > 0) Or ($Blessed > 0) or ($Radiant > 0) Then	; Neutral Insignia
		Return True	
	ElseIf ($MinorScythe > 0) Or ($MinorMyst > 0) or ($SupEarthPrayers > 0) or ($WindWalker > 0) Then ; Dervish
		Return True
	ElseIf ($MinorDivine > 0) Then ; Monk
		Return True
	ElseIf ($SupDeath > 0) Or ($MinorSoulReaping > 0) Then ; Necromancer
		Return True	
	ElseIf ($SupDom > 0) Or ($Prodigy > 0) or ($MinorFastCasting > 0) or ($MinorInspiration > 0) or ($MinorIllusion > 0) Then ; Mesmer
		Return True
	ElseIf ($MinorEnergyStorage > 0) Then ; Elementalist
		Return True
	ElseIf ($Shaman > 0) or ($MinorSpawning > 0) or ($SupCommuning > 0) Then ; Ritualist
		Return True
	ElseIf  ($Centurion > 0) Then ; Paragon
		Return True
	Else
		Return False   
	EndIf
 EndFunc 
 
;Func IsValuableMaterial($item)
	; Local $M = DllStructGetData($item, "ModelID")

	; Switch $M
	; Case 930, 931, 932, 935, 936, 937, 938 ; Ecto, Eye, Fang, Diamond, Onyx, Ruby, Sapphire
		; Return True ; Rare Mats
	; Case 921, 929, 933, 934, 948, 353, 354 ; Bones, Dust, Feather, Fiber, Iron, Scale, Chitin
		; Return True ; Expensive Mats
	; EndSwitch
	; Return False
;EndFunc

 Func IsSpecialItem($item)
	Local $ModelID = DllStructGetData($item, "ModelID")
	local $Type = dllStructGetData(($item), "Type")
	Local $ExtraID = DllStructGetData($item, "ExtraID")

	Switch $ModelID
    Case 5656, 18345, 21491, 37765, 21833, 28433, 28434
	   Return True ; Special - ToT etc
    Case 22751
	   Return True ; Lockpicks
    Case 27047
	   Return True ; Glacial Stones
	Case ($ModelID > 21795 and $ModelID < 21806) 
		Return True ; Tomes 
	Case ($ModelID > 21785 and $ModelID  < 21796)	
		Return True ; Elite Tomes
    ; Case 146
	   ; If $ExtraID = 2 or $ExtraID = 5 or $ExtraID = 10 Or $ExtraID = 12 Then
		  ; Return True ; Blue, Red, Black & White Dye 
	   ; Else
		  ; Return False
	   ; EndIf						;Obsolete
    Case 24353, 24354
	   Return True ; Chalice & Rin Relics
    Case 27052
	   Return True ; Superb Charr Carving
    Case 522
	   Return True ; Dark Remains
    Case 3746, 22280
	   Return True ; Underworld & FOW Scroll
    Case 819
	   Return True ; Dragon Root
    Case 35121
	   Return True ; War supplies
    Case 36985
	   Return True ; Commendations
    EndSwitch
	
	; Switch $Type
	; Case 34
		; Return True ; Minipets
	; EndSwitch	
	Return False
 EndFunc 
 
 Func IsValuableUpgrade($item)
    Local $ModStruct = GetModStruct($item)	
	Local $Type = dllStructGetData(($item), "type")
	
	Local $itemType_wand = 22
	Local $itemType_offHand = 12
	Local $itemType_staff = 26
	
	Local $itemType_axe = 2
	Local $itemType_sword = 27
	Local $itemType_spear = 36
	
	Local $itemType_bow = 5
	Local $itemType_hammer = 15
	Local $itemType_daggers = 32
	Local $itemType_scythe = 35
	
	Local $itemType_shield = 24	
	
	Local $20Ench = StringInStr($ModStruct, "1400B822", 0, 1)
	
	Local $minus1Energy = StringInStr($ModStruct, "0100C820", 0, 1)	
	Local $Zealous = StringInStr($ModStruct, "01001825", 0, 1)
	
	Local $minus1Health = StringInStr($ModStruct, "0100E820", 0, 1)
	Local $Vamp3 = StringInStr($ModStruct, "00032825", 0, 1)
	Local $Vamp5 = StringInStr($ModStruct, "00052825", 0, 1)
	
	Local $19HCT = StringInStr($ModStruct, "00130828", 0, 1)
	Local $20HCT = StringInStr($ModStruct, "00140828", 0, 1)
	
	Local $19HSR = StringInStr($ModStruct, "00132828", 0, 1)
	Local $20HSR = StringInStr($ModStruct, "00142828", 0, 1)	
	
	Local $WandMemory = StringInStr($ModStruct, "BF023025", 0, 1)
	Local $AptitudeNotAttitude = StringInStr($ModStruct, "AE033225", 0, 1)	
	Local $FocusAptitude = StringInStr($ModStruct, "2F043025", 0, 1)
	Local $ForgetMeNot = StringInStr($ModStruct, "84033225", 0, 1) 
	
	
	if $Type = $itemType_wand then
		if $19HCT > 0 or $20HCT > 0 then
			return true
		endif	
	elseif $Type = $itemType_offHand then
		if $20HCT > 0 or $19HSR > 0 or $20HSR > 0 then
			return true
		endif			
	;elseif $Type = $itemType_staff then			
	elseif $Type = $itemType_spear then
		if $20Ench > 0 then
			return true
		endif	
	elseif $Type = $itemType_scythe then
		if $20Ench > 0 or $Zealous > 0 then
			return true
		endif
	;elseif $Type = $itemType_daggers then
	else 
		return False	
	EndIf	
EndFunc	


 Func IsPcon($item)
	Local $ModelID = DllStructGetData($item, "ModelID")

	Switch $ModelID
    Case 910, 2513, 5585, 6049, 6366, 6367, 6375, 15477, 19171, 19172, 19173, 22190, 24593, 28435, 30855, 31145, 31146, 35124, 36682
	   Return True ; Alcohol
    Case 6376, 21809, 21810, 21813, 36683
	   Return True ; Party
    Case 21492, 21812, 22269, 22644, 22752, 28436
	   Return True ; Sweets
    Case 6370, 21488, 21489, 22191, 26784, 28433
	   Return True ; DP Removal
    Case 15837, 21490, 30648, 31020
	   Return True ; Tonic
    EndSwitch
	Return False
 EndFunc
 Func IsReq8Max($item)
	Local $Req = GetItemReq($item)
	Local $Attribute = GetItemAttribute($item)
	Local $Rarity = GetRarity($item)
	Local $Dmg = GetItemMaxDmg($item)

    Switch $Rarity
    Case 2624
	   If $Req = 8 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
    Case 2623
	   If $Req = 8 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
    Case 2626
	   If $Req = 8 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
	EndSwitch
	Return False
 EndFunc
  Func IsReq9Max($item)
	Local $Req = GetItemReq($item)
	Local $Attribute = GetItemAttribute($item)
	Local $Rarity = GetRarity($item)
	Local $Dmg = GetItemMaxDmg($item)

    Switch $Rarity
    Case 2624
	   If $Req = 9 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
    Case 2623
	   If $Req = 9 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
    Case 2626
	   If $Req = 9 Then
		  If $Attribute = 20 Or $Attribute = 21 Or $Attribute = 17 Then
			 If $Dmg = 22 Or $Dmg = 16 Then
				Return True
			 EndIf
		  EndIf
	   EndIf
	EndSwitch
	Return False
 EndFunc
Func GetItemMaxDmg($item)
	If Not IsDllStruct($item) Then $item = GetItemByItemID($item)
	Local $lModString = GetModStruct($item)
	Local $lPos = StringInStr($lModString, "A8A7") ; Weapon Damage
	If $lPos = 0 Then $lPos = StringInStr($lModString, "C867") ; Energy (focus)
	If $lPos = 0 Then $lPos = StringInStr($lModString, "B8A7") ; Armor (shield)
	If $lPos = 0 Then Return 0
	Return Int("0x" & StringMid($lModString, $lPos - 2, 2))
 EndFunc
 
 