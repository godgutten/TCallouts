RegisterNetEvent('pis:knifeCallout')
AddEventHandler('pis:knifeCallout', function()
	location = "~o~24/7, Sandy Shores~w~"
	callout = "~r~Armed Man~w~"
	response = "~r~Code 3~w~"
	
	AddRelationshipGroup("suspect")
	
	SetRelationshipBetweenGroups(5, GetHashKey("suspect"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("suspect"))
	
    model = "S_M_Y_MARINE_01" --Marine Army Guard
    modelHash = GetHashKey(model)
    RequestModel(modelHash)

	
    while not HasModelLoaded(modelHash) and not HasModelLoaded(modelHash2) do
        Wait(1)
    end
    
	weapon = "WEAPON_MACHETE"
		
    suspect = CreatePed(26, model, 1966.8389892578, 3737.8703613281, 32.188823699951 , 180.0, true, true)
	GiveWeaponToPed(suspect, weapon, 1000, 1, 1)
	
	
	SetPedRelationshipGroupHash(suspect, GetHashKey("suspect"))
	
	TaskCombatHatedTargetsAroundPed(suspect, 10.0, 0)
	
	TaskWanderStandard(suspect, 1.0, 10)
	
	SetPedCombatMovement(suspect, 2)
	
	SetPedCombatAttributes(suspect, 5)
	
	SetPedCombatAbility(suspect, 100)
	
	SetPedArmour(suspect, math.random(100))
end)

RegisterNetEvent('pis:abandonedVeh')
AddEventHandler('pis:abandonedVeh', function()
	location = "~o~Sandy Shores~w~"
	callout = "~r~Suspicious Vehicle~w~"
	response = "~r~Code 2~w~"
	
    model = "u_m_y_abner" --Marine Army Guard
    modelHash = GetHashKey(model)
    RequestModel(modelHash)
	
	vehModel = "BURRITO3"
	vehHash = GetHashKey(vehModel)
	RequestModel(vehHash)
	
    while not HasModelLoaded(vehHash) and not HasModelLoaded(modelHash) do
        Wait(1)
    end
		
	SetEntityAsMissionEntity(susVeh)
	DeleteEntity(susVeh)
	SetEntityAsMissionEntity(body)
	DeleteEntity(body)
	
	rSpawn = math.random(10)
	
	local bodyChance = 100--math.random(100)
	if bodyChance >= 75 then
		body = CreatePed(26, model, 2158.0009765625 - rSpawn, 3909.4057617188 - rSpawn, 31.012893676758 + 3, -50.0, true, true)
		SetPedToRagdoll(body, -1, -1, 0, true, true, false)
	end	
	
	Wait(1000)
	
    susVeh = CreateVehicle(vehModel, 2141.2116699219, 3892.1740722656, 33.184062957764 + 3.5, -50.0, true, true)
	
	SetVehicleDoorOpen(susVeh, 3, true, true)
	SetVehicleDoorOpen(susVeh, 2, true, true)
	SetVehicleDoorOpen(susVeh, 0, true, true)
	SetVehicleEngineOn(susVeh, true, true, false)
	SetVehicleLights(susVeh, 2)
	SetVehicleWindowTint(susVeh, "WINDOWTINT_PURE_BLACK")
	
	SetEntityAsNoLongerNeeded(susVeh)
	SetEntityAsNoLongerNeeded(body)
end)

RegisterNetEvent('pis:shoplifting:spawn')
AddEventHandler('pis:shoplifting:spawn', function()
	SetEntityAsMissionEntity(clerk)
	DeleteEntity(clerk)
	SetEntityAsMissionEntity(suspect)
	DeleteEntity(suspect)

	susModel = "a_m_y_methhead_01"
    susModelHash = GetHashKey(susModel)
    RequestModel(susModelHash)
	
	clerkModel = "u_m_y_burgerdrug_01"
    clerkModelHash = GetHashKey(clerkModel)
    RequestModel(clerkModelHash)

    while not HasModelLoaded(susModelHash) and not HasModelLoaded(clerkModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    suspect = CreatePed(26, susModel, 1963.9727783203, 3742.4975585938, 32.343753814697 , 180.0, true, true)
	clerk = CreatePed(26, clerkModel, 1959.1219482422, 3741.5502929688, 32.343746185303 , 0.0, true, true)
end)

RegisterNetEvent('pis:shoplifting')
AddEventHandler('pis:shoplifting', function()
	location = "~o~24/7, Sandy Shores~w~"
	callout = "~r~Shoplifting~w~"
	response = "~r~Code 2~w~"

	local ClerkPeaceQuotes = {"Get back here!", "Officer! Thats the guy", "He took something!"}
	local ClerkAgressiveQuotes = {"Get back here, you fucker!!", "Officer! Thats the fucker", "That fucker took my shit!", "Motherfucker, get the fuck back!", "Shoot that bitch!", "I'm going to fucking kill him!"}
	local AttitudeLvl = math.random(100)
	local HasSaidQuote = false
	local HasSaidDeathQuote = false
	local IsClerkOnKnees = false
	local weaponChance = math.random(100)
	local suspectWeaponChance = math.random(100)
	local weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
	local susWeapon = GetHashKey("WEAPON_KNIFE")
	
	if weaponChance >= 90 and AttitudeLvl > 50 then
		weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	elseif weaponChance > 70 and weaponChance < 90 and AttitudeLvl > 25 then
		weapon = GetHashKey("WEAPON_BAT")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	end
	
	if suspectWeaponChance >= 90 then
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("clerk"))
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("PLAYER"))
		GiveWeaponToPed(suspect, susWeapon, 1000, 1, 1)
		TaskCombatHatedTargetsAroundPed(suspect, 10.0, 0)
		SetPedCombatAttributes(suspect, 5)
		SetPedCombatAttributes(suspect, 46)
		SetPedCombatAbility(suspect, 100)
	else
		TaskReactAndFleePed(suspect, clerk)
		SetPedCombatAbility(suspect, 0)
	end
	
	ShowNotification("Wep Chance: " .. weaponChance .. " | AttitudeLvl: " .. AttitudeLvl)
	
	AddRelationshipGroup("clerk")
	AddRelationshipGroup("shoplifter")
	
	SetRelationshipBetweenGroups(5, GetHashKey("clerk"), GetHashKey("shoplifter"))
	SetRelationshipBetweenGroups(1, GetHashKey("clerk"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("shoplifter"), GetHashKey("clerk"))
	
	SetPedRelationshipGroupHash(suspect, GetHashKey("shoplifter"))
	SetPedRelationshipGroupHash(clerk, GetHashKey("clerk"))
	
	TaskCombatHatedTargetsAroundPed(clerk, 10.0, 0)
	
	while true do
	Citizen.Wait(1000)
		local distanceToClerk = GetDistanceBetweenCoords(GetEntityCoords(clerk), GetEntityCoords(GetPlayerPed(-1)))
		if distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl <= 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkPeaceQuotes[math.random(#ClerkPeaceQuotes)])
		elseif distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl > 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkAgressiveQuotes[math.random(#ClerkAgressiveQuotes)])
		elseif distanceToClerk <= 10 and HasPedGotWeapon(clerk, weapon, false) and IsEntityOnScreen(clerk) and IsClerkOnKnees == false and not IsEntityDead(clerk) then
			--[[loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			ClearPedTasks(clerk)
			ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			ShowNotification("~o~Clerk: ~w~" .. "Officer! Dont shoot! Get that guy!")
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)]]
		elseif distanceToClerk <= 5 and IsEntityDead(suspect) and HasSaidDeathQuote == false then
			local ClerkSympathy = math.random(2)
			local ClerkSympathyQuotes = {"Is he dead? Shit..", "I didn't want to kill him!", "It didn't have to end like this..."}
			local ClerkHeartlessQuotes = {"He got what he deserved!", "Burn in hell motherfucker!", "He messed with the wrong guy!"}
			HasSaidDeathQuote = true
			if ClerkSympathy == 1 then
				ShowNotification("~o~Clerk: ~w~" .. ClerkHeartlessQuotes[math.random(#ClerkHeartlessQuotes)])
			else
				ShowNotification("~o~Clerk: ~w~" ..  ClerkSympathyQuotes[math.random(#ClerkSympathyQuotes)])
			end
		elseif IsEntityDead(suspect) and not IsEntityDead(clerk) and distanceToClerk < 25 and not IsClerkOnKnees then
			loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			--ClearPedTasks(clerk)
			--ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('pis:robbery:spawn')
AddEventHandler('pis:robbery:spawn', function()
	SetEntityAsMissionEntity(clerk)
	DeleteEntity(clerk)
	SetEntityAsMissionEntity(suspect)
	DeleteEntity(suspect)

	susModel = "a_m_y_methhead_01"
    susModelHash = GetHashKey(susModel)
    RequestModel(susModelHash)
	
	clerkModel = "s_f_y_shop_low"
    clerkModelHash = GetHashKey(clerkModel)
    RequestModel(clerkModelHash)

    while not HasModelLoaded(susModelHash) and not HasModelLoaded(clerkModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    suspect = CreatePed(26, susModel, 24.937, -1341.812, 29.497 , 198.0, true, true)
	clerk = CreatePed(26, clerkModel, 24.39, -1346.810, 29.497 , 0.0, true, true)
end)
RegisterNetEvent('pis:robbery')
AddEventHandler('pis:robbery', function()
	location = "~o~24/7, Innocence Blvd~w~"
	callout = "~r~Armed Possible Robbery~w~"
	response = "~r~Code 2~w~"

	local ClerkPeaceQuotes = {"Get back here!", "Officer! Thats the guy", "He took something!"}
	local ClerkAgressiveQuotes = {"Get back here, you fucker!!", "Officer! Thats the fucker", "That fucker took my shit!", "Motherfucker, get the fuck back!", "Shoot that bitch!", "I'm going to fucking kill him!"}
	local AttitudeLvl = math.random(100)
	local HasSaidQuote = false
	local HasSaidDeathQuote = false
	local IsClerkOnKnees = false
	local weaponChance = math.random(100)
	local suspectWeaponChance = math.random(100)
	local weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
	local susWeapon = GetHashKey("WEAPON_COMBATPISTOL")
	
	if weaponChance >= 50 then
		weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	elseif weaponChance < 1 and weaponChance < 90 and AttitudeLvl > 25 then
		weapon = GetHashKey("WEAPON_BAT")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	end
	
	if suspectWeaponChance ~= 80 then
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("clerk"))
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("PLAYER"))
		GiveWeaponToPed(suspect, susWeapon, 1000, 1, 1)
		TaskCombatHatedTargetsAroundPed(suspect, 10.0, 0)
		SetPedCombatAttributes(suspect, 5)
		SetPedCombatAttributes(suspect, 46)
		SetPedCombatAbility(suspect, 100)
	else
		TaskReactAndFleePed(suspect, clerk)
		SetPedCombatAbility(suspect, 0)
	end
	
	ShowNotification("Wep Chance: " .. weaponChance .. " | AttitudeLvl: " .. AttitudeLvl)
	
	AddRelationshipGroup("clerk")
	AddRelationshipGroup("shoplifter")
	
	SetRelationshipBetweenGroups(5, GetHashKey("clerk"), GetHashKey("shoplifter"))
	SetRelationshipBetweenGroups(1, GetHashKey("clerk"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("shoplifter"), GetHashKey("clerk"))
	
	SetPedRelationshipGroupHash(suspect, GetHashKey("shoplifter"))
	SetPedRelationshipGroupHash(clerk, GetHashKey("clerk"))
	
	TaskCombatHatedTargetsAroundPed(clerk, 10.0, 0)
	
	while true do
	Citizen.Wait(1000)
		local distanceToClerk = GetDistanceBetweenCoords(GetEntityCoords(clerk), GetEntityCoords(GetPlayerPed(-1)))
		if distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl <= 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkPeaceQuotes[math.random(#ClerkPeaceQuotes)])
		elseif distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl > 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkAgressiveQuotes[math.random(#ClerkAgressiveQuotes)])
		elseif distanceToClerk <= 10 and HasPedGotWeapon(clerk, weapon, false) and IsEntityOnScreen(clerk) and IsClerkOnKnees == false and not IsEntityDead(clerk) then
			--[[loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			ClearPedTasks(clerk)
			ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			ShowNotification("~o~Clerk: ~w~" .. "Officer! Dont shoot! Get that guy!")
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)]]
		elseif distanceToClerk <= 5 and IsEntityDead(suspect) and HasSaidDeathQuote == false then
			local ClerkSympathy = math.random(2)
			local ClerkSympathyQuotes = {"Is he dead? Shit..", "I didn't want to kill him!", "It didn't have to end like this..."}
			local ClerkHeartlessQuotes = {"He got what he deserved!", "Burn in hell motherfucker!", "He messed with the wrong guy!"}
			HasSaidDeathQuote = true
			if ClerkSympathy == 1 then
				ShowNotification("~o~Clerk: ~w~" .. ClerkHeartlessQuotes[math.random(#ClerkHeartlessQuotes)])
			else
				ShowNotification("~o~Clerk: ~w~" ..  ClerkSympathyQuotes[math.random(#ClerkSympathyQuotes)])
			end
		elseif IsEntityDead(suspect) and not IsEntityDead(clerk) and distanceToClerk < 25 and not IsClerkOnKnees then
			loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			--ClearPedTasks(clerk)
			--ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('pis:bank:spawn')
AddEventHandler('pis:bank:spawn', function()
	SetEntityAsMissionEntity(clerk)
	DeleteEntity(clerk)
	SetEntityAsMissionEntity(suspect)
	DeleteEntity(suspect)

	susModel = "s_m_y_marine_03"
    susModelHash = GetHashKey(susModel)
    RequestModel(susModelHash)
	
	clerkModel = "s_m_y_valet_01"
    clerkModelHash = GetHashKey(clerkModel)
    RequestModel(clerkModelHash)

    while not HasModelLoaded(susModelHash) and not HasModelLoaded(clerkModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    suspect = CreatePed(26, susModel, 150.124, -1040.546, 29.374 , 344, true, true)
	clerk = CreatePed(26, clerkModel, 149.561, -1042.203, 29.368 , 342.139, true, true)
end)

RegisterNetEvent('pis:bank')
AddEventHandler('pis:bank', function()

	location = "~o~Fleeca Bank. Downtown LS~w~"
	callout = "~r~Bank panic button pressed~w~"
	response = "~r~Code 2~w~"

	local ClerkPeaceQuotes = {"Get back here!", "Officer! Thats the guy", "He got the money!"}
	local ClerkAgressiveQuotes = {"Get back here, you fucker!!", "Officer! Thats the fucker", "That fucker took my shit!", "Motherfucker, get the fuck back!", "Shoot that bitch!", "I'm going to fucking kill him!"}
	local AttitudeLvl = math.random(100)
	local HasSaidQuote = false
	local HasSaidDeathQuote = false
	local IsClerkOnKnees = false
	local weaponChance = math.random(100)
	local suspectWeaponChance = math.random(100)
	local weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
	local susWeapon = GetHashKey("WEAPON_CARBINERIFLE")
	
	Wait(2000)
	
	if weaponChance <= 60 then
		weapon = GetHashKey("WEAPON_KNIFE")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	elseif weaponChance < 1 and weaponChance < 90 and AttitudeLvl > 25 then
		weapon = GetHashKey("WEAPON_KNIFE")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
	end
	
	if suspectWeaponChance <= 50 then
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("clerk"))
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("PLAYER"))
		GiveWeaponToPed(suspect, susWeapon, 1000, 1, 1)
		TaskCombatHatedTargetsAroundPed(suspect, 10.0, 0)
		SetPedCombatAttributes(suspect, 5)
		SetPedCombatAttributes(suspect, 46)
		SetPedCombatAbility(suspect, 100)
	else
		TaskReactAndFleePed(suspect, clerk)
		SetPedCombatAbility(suspect, 0)
	end
	
	ShowNotification("Wep Chance: " .. weaponChance .. " | AttitudeLvl: " .. AttitudeLvl)
	
	AddRelationshipGroup("clerk")
	AddRelationshipGroup("shoplifter")
	
	SetRelationshipBetweenGroups(5, GetHashKey("clerk"), GetHashKey("shoplifter"))
	SetRelationshipBetweenGroups(1, GetHashKey("clerk"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("shoplifter"), GetHashKey("clerk"))
	
	SetPedRelationshipGroupHash(suspect, GetHashKey("shoplifter"))
	SetPedRelationshipGroupHash(clerk, GetHashKey("clerk"))
	
	TaskCombatHatedTargetsAroundPed(clerk, 10.0, 0)
	
	while true do
	Citizen.Wait(1000)
		local distanceToClerk = GetDistanceBetweenCoords(GetEntityCoords(clerk), GetEntityCoords(GetPlayerPed(-1)))
		if distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl <= 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkPeaceQuotes[math.random(#ClerkPeaceQuotes)])
		elseif distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl > 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkAgressiveQuotes[math.random(#ClerkAgressiveQuotes)])
		elseif distanceToClerk <= 10 and HasPedGotWeapon(clerk, weapon, false) and IsEntityOnScreen(clerk) and IsClerkOnKnees == false and not IsEntityDead(clerk) then
			--[[loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			ClearPedTasks(clerk)
			ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			ShowNotification("~o~Clerk: ~w~" .. "Officer! Dont shoot! Get that guy!")
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)]]
		elseif distanceToClerk <= 5 and IsEntityDead(suspect) and HasSaidDeathQuote == false then
			local ClerkSympathy = math.random(2)
			local ClerkSympathyQuotes = {"Is he dead? Shit..", "I didn't want to kill him!", "It didn't have to end like this..."}
			local ClerkHeartlessQuotes = {"He got what he deserved!", "Burn in hell motherfucker!", "He messed with the wrong guy!"}
			HasSaidDeathQuote = true
			if ClerkSympathy == 1 then
				ShowNotification("~o~Clerk: ~w~" .. ClerkHeartlessQuotes[math.random(#ClerkHeartlessQuotes)])
			else
				ShowNotification("~o~Clerk: ~w~" ..  ClerkSympathyQuotes[math.random(#ClerkSympathyQuotes)])
			end
		elseif IsEntityDead(suspect) and not IsEntityDead(clerk) and distanceToClerk < 25 and not IsClerkOnKnees then
			loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			--ClearPedTasks(clerk)
			--ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('pis:bank2:spawn')
AddEventHandler('pis:bank2:spawn', function()
	SetEntityAsMissionEntity(clerk)
	DeleteEntity(clerk)
	SetEntityAsMissionEntity(suspect)
	DeleteEntity(suspect)
	SetEntityAsMissionEntity(suspect2)
	DeleteEntity(suspect2)
    local pmodels = {"mp_m_weed_01", "G_M_Y_Lost_02", "G_F_Y_Lost_01", "G_M_Y_SalvaGoon_02", "a_m_y_methhead_01", "A_M_Y_MexThug_01", "G_F_Y_Vagos_01", "S_F_Y_Hooker_01", "A_F_M_TrampBeac_01", "G_M_Y_KorLieut_01","hc_gunman", "s_m_y_dealer_01", "s_f_y_hooker_03", "s_m_y_robber_01", "mp_m_counterfeit_01"}
	susModel = pmodels[math.random(#pmodels)]
	susModel2 = pmodels[math.random(#pmodels)]
    susModelHash = GetHashKey(susModel)
    RequestModel(susModelHash)
	
	clerkModel = "s_m_y_valet_01"
    clerkModelHash = GetHashKey(clerkModel)
    RequestModel(clerkModelHash)

    while not HasModelLoaded(susModelHash) and not HasModelLoaded(clerkModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    suspect = CreatePed(26, susModel, 248.176, 221.615, 106.287, 349, true, true)
	suspect2 = CreatePed(26, susModel2, 235.286, 222.837, 106.287, 161.554, true, true)
	clerk = CreatePed(26, clerkModel, 248.845, 224.447, 106.870, 158.977, true, true)
end)

RegisterNetEvent('pis:bank2')
AddEventHandler('pis:bank2', function()

	location = "~o~Alta street, Downtown VINEWOOD~w~"
	callout = "~r~Bank panic button pressed~w~"
	response = "~r~Code 3~w~"

	local ClerkPeaceQuotes = {"Get back here!", "Officer! Thats the guy", "He got the money!"}
	local ClerkAgressiveQuotes = {"Get back here, you fucker!", "Officer! Thats the fucker", "That fucker took my shit!", "Motherfucker, get the fuck back!", "Shoot that bitch!", "I'm going to fucking kill him!"}
	local AttitudeLvl = math.random(100)
	local HasSaidQuote = false
	local HasSaidDeathQuote = false
	local IsClerkOnKnees = true
	local weaponChance = math.random(100)
	local suspectWeaponChance = math.random(100)
	local weapon = GetHashKey("WEAPON_PUMPSHOTGUN")
	local susWeapon = GetHashKey("WEAPON_CARBINERIFLE")
	
	Wait(2000)
		weapon = GetHashKey("WEAPON_NIGHTSTICK")
		GiveWeaponToPed(clerk, weapon, 1000, 1, 1)
		ShowNotification("I have nothing to defend myself!")
	
	if suspectWeaponChance ~= 20 then
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("clerk"))
		SetRelationshipBetweenGroups(5, GetHashKey("shoplifter"), GetHashKey("PLAYER"))
		GiveWeaponToPed(suspect, susWeapon, 1000, 1, 1)
		TaskCombatHatedTargetsAroundPed(suspect, 50.0, 0)
		GiveWeaponToPed(suspect2, susWeapon, 1000, 1, 1)
		TaskCombatHatedTargetsAroundPed(suspect2, 5.0, 0)
		SetPedCombatAttributes(suspect, 5)
		SetPedCombatAttributes(suspect, 46)
		SetPedCombatAbility(suspect, 100)
		SetPedCombatAttributes(suspect2, 5)
		SetPedCombatAttributes(suspect2, 46)
		SetPedCombatAbility(suspect2, 100)
	else
		TaskReactAndFleePed(suspect, clerk)
		SetPedCombatAbility(suspect, 100)
		TaskReactAndFleePed(suspect2, clerk)
		SetPedCombatAbility(suspect2, 100)
	end
	
	ShowNotification("Wep Chance: " .. weaponChance .. " | AttitudeLvl: " .. AttitudeLvl)
	
	AddRelationshipGroup("clerk")
	AddRelationshipGroup("shoplifter")
	
	SetRelationshipBetweenGroups(5, GetHashKey("clerk"), GetHashKey("shoplifter"))
	SetRelationshipBetweenGroups(1, GetHashKey("clerk"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("shoplifter"), GetHashKey("clerk"))
	
	SetPedRelationshipGroupHash(suspect, GetHashKey("shoplifter"))
	SetPedRelationshipGroupHash(clerk, GetHashKey("clerk"))
	
	TaskCombatHatedTargetsAroundPed(clerk, 10.0, 0)
	
	while true do
	Citizen.Wait(1000)
		local distanceToClerk = GetDistanceBetweenCoords(GetEntityCoords(clerk), GetEntityCoords(GetPlayerPed(-1)))
		if distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl <= 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkPeaceQuotes[math.random(#ClerkPeaceQuotes)])
		elseif distanceToClerk <= 5 and HasSaidQuote == false and AttitudeLvl > 50 and not HasPedGotWeapon(clerk, weapon, false) and not IsEntityDead(clerk) and not IsEntityDead(suspect) then
			HasSaidQuote = true
			ShowNotification("~o~Clerk: ~w~" .. ClerkAgressiveQuotes[math.random(#ClerkAgressiveQuotes)])
		elseif distanceToClerk <= 10 and HasPedGotWeapon(clerk, weapon, false) and IsEntityOnScreen(clerk) and IsClerkOnKnees == false and not IsEntityDead(clerk) then
			--[[loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			ClearPedTasks(clerk)
			ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			ShowNotification("~o~Clerk: ~w~" .. "Officer! Dont shoot! Get that guy!")
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)]]
		elseif distanceToClerk <= 5 and IsEntityDead(suspect) and HasSaidDeathQuote == false then
			local ClerkSympathy = math.random(2)
			local ClerkSympathyQuotes = {"Is he dead? Shit..", "I didn't want to kill him!", "It didn't have to end like this..."}
			local ClerkHeartlessQuotes = {"He got what he deserved!", "Burn in hell motherfucker!", "He messed with the wrong guy!"}
			HasSaidDeathQuote = true
			if ClerkSympathy == 1 then
				ShowNotification("~o~Clerk: ~w~" .. ClerkHeartlessQuotes[math.random(#ClerkHeartlessQuotes)])
			else
				ShowNotification("~o~Clerk: ~w~" ..  ClerkSympathyQuotes[math.random(#ClerkSympathyQuotes)])
			end
		elseif IsEntityDead(suspect) and not IsEntityDead(clerk) and distanceToClerk < 25 and not IsClerkOnKnees then
			loadAnimDict("random@arrests")
			loadAnimDict("random@arrests@busted")
			--ClearPedTasks(clerk)
			--ClearPedSecondaryTask(clerk)
			IsClerkOnKnees = true
			
			SetPedDropsInventoryWeapon(clerk, GetSelectedPedWeapon(clerk), GetEntityCoords(clerk), 0)
			TaskPlayAnim(clerk, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (4000)
			TaskPlayAnim(clerk, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (500)
			TaskPlayAnim(clerk, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
			Wait (1000)
			TaskPlayAnim(clerk, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('pis:fight:spawn')
AddEventHandler('pis:fight:spawn', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	SetEntityAsMissionEntity(sus2)
	DeleteEntity(sus2)
	
	sus1Model = "a_m_m_hillbilly_01"
    sus1ModelHash = GetHashKey(sus1Model)
    RequestModel(sus1ModelHash)
	
	sus2Model = "a_m_m_hillbilly_02"
    sus2ModelHash = GetHashKey(sus2Mode1)
    RequestModel(sus2ModelHash)

    while not HasModelLoaded(sus2ModelHash) and not HasModelLoaded(sus1ModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    sus1 = CreatePed(26, sus1Model, 1502.9809570313, 3750.7368164063, 34.013957977295 , 45.0, true, true)
    sus2 = CreatePed(26, sus2Model, 1502.9809570313 - 1, 3750.7368164063 + 1, 34.013957977295 , -45.0, true, true)
end)

RegisterNetEvent('pis:fight')
AddEventHandler('pis:fight', function()
	callID = "fight"
	location = "~o~Boat House, Sandy Shores~w~"
	callout = "~r~Fight~w~"
	response = "~r~Code 3~w~"
	
	AddRelationshipGroup("fighter1")
	AddRelationshipGroup("fighter2")
	
	SetPedCombatAttributes(sus1, 5, true)
	SetPedCombatAttributes(sus2, 5, true)
	
	SetPedCombatAbility(sus1, 100)
	SetPedCombatAbility(sus2, 100)
	
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("fighter2"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("fighter1"))
	
	SetPedRelationshipGroupHash(sus1, GetHashKey("fighter1"))
	SetPedRelationshipGroupHash(sus2, GetHashKey("fighter2"))
	
	SetEntityCanBeDamagedByRelationshipGroup(sus1, false, GetHashKey("fighter2"))
	SetEntityCanBeDamagedByRelationshipGroup(sus2, false, GetHashKey("fighter1"))
	
	TaskCombatHatedTargetsAroundPed(sus1, 10.0, 0)
	TaskCombatHatedTargetsAroundPed(sus2, 10.0, 0)
end)

RegisterNetEvent('pis:shots:spawn')
AddEventHandler('pis:shots:spawn', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	SetEntityAsMissionEntity(sus2)
	DeleteEntity(sus2)
	
	sus1Model = "a_m_m_hillbilly_01"
    sus1ModelHash = GetHashKey(sus1Model)
    RequestModel(sus1ModelHash)
	
	sus2Model = "a_m_m_hillbilly_02"
    sus2ModelHash = GetHashKey(sus2Mode1)
    RequestModel(sus2ModelHash)

    while not HasModelLoaded(sus2ModelHash) and not HasModelLoaded(sus1ModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    sus1 = CreatePed(26, sus1Model, 1660.359375, 3752.216796875, 34.578285217285 , 45.0, true, true)
    sus2 = CreatePed(26, sus2Model, 1634.0037841797, 3736.2243652344, 34.521759033203 , -45.0, true, true)
end)

RegisterNetEvent('pis:shots')
AddEventHandler('pis:shots', function()
	location = "~o~Cholla Springs Ave, Sandy Shores~w~"
	callout = "~r~Shots Fired~w~"
	response = "~r~Code 3~w~"
	
	local randWeapon1 = math.random(100)
	local randWeapon2 = math.random(100)
	if randWeapon1 < 50 then
		weapon1 = GetHashKey("WEAPON_COMBATPISTOL")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 50 and randWeapon1 < 80 then
		weapon1 = GetHashKey("WEAPON_PISTOL50")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 80 and randWeapon1 < 90 then
		weapon1 = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	else
		weapon1 = GetHashKey("WEAPON_CARBINERIFLE")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	end
	
	if randWeapon2 < 50 then
		weapon2 = GetHashKey("WEAPON_COMBATPISTOL")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	elseif randWeapon2 > 50 and randWeapon2 < 80 then
		weapon2 = GetHashKey("WEAPON_PISTOL50")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	elseif randWeapon2 > 80 and randWeapon2 < 90 then
		weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	else
		weapon2 = GetHashKey("WEAPON_CARBINERIFLE")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	end
	
	SetPedArmour(sus1, math.random(50, 100))
	SetPedArmour(sus2, math.random(50, 100))
	
	AddRelationshipGroup("fighter1")
	AddRelationshipGroup("fighter2")
	
	SetPedCombatAttributes(sus1, 5, true)
	SetPedCombatAttributes(sus2, 5, true)
	
	SetPedCombatAbility(sus1, 100)
	SetPedCombatAbility(sus2, 100)
	
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("fighter2"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("fighter1"))
	
	SetPedRelationshipGroupHash(sus1, GetHashKey("fighter1"))
	SetPedRelationshipGroupHash(sus2, GetHashKey("fighter2"))
	
	SetEntityCanBeDamagedByRelationshipGroup(sus1, false, GetHashKey("fighter2"))
	SetEntityCanBeDamagedByRelationshipGroup(sus2, false, GetHashKey("fighter1"))
	
	TaskCombatHatedTargetsAroundPed(sus1, 20.0, 0)
	TaskCombatHatedTargetsAroundPed(sus2, 20.0, 0)
end)

RegisterNetEvent('pis:shotscity:spawn')
AddEventHandler('pis:shotscity:spawn', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	SetEntityAsMissionEntity(sus2)
	DeleteEntity(sus2)
	
	sus1Model = "a_m_m_hillbilly_01"
    sus1ModelHash = GetHashKey(sus1Model)
    RequestModel(sus1ModelHash)
	
	sus2Model = "a_m_m_hillbilly_02"
    sus2ModelHash = GetHashKey(sus2Mode1)
    RequestModel(sus2ModelHash)

    while not HasModelLoaded(sus2ModelHash) and not HasModelLoaded(sus1ModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    sus1 = CreatePed(26, sus1Model, 63.851, -433.878, 37.552 , 45.0, true, true)
    sus2 = CreatePed(26, sus2Model, 60.893, -441.823, 37.552 , -45.0, true, true)
end)
RegisterNetEvent('pis:shotscity')
AddEventHandler('pis:shotscity', function()
	location = "~o~Power Street, Construction Site~w~"
	callout = "~r~Shots Fired~w~"
	response = "~r~Code 3~w~"
	
	local randWeapon1 = math.random(100)
	local randWeapon2 = math.random(100)
	if randWeapon1 < 50 then
		weapon1 = GetHashKey("WEAPON_COMBATPISTOL")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 50 and randWeapon1 < 80 then
		weapon1 = GetHashKey("WEAPON_PISTOL50")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 80 and randWeapon1 < 90 then
		weapon1 = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	else
		weapon1 = GetHashKey("WEAPON_CARBINERIFLE")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	end
	
	if randWeapon2 < 50 then
		weapon2 = GetHashKey("WEAPON_COMBATPISTOL")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	elseif randWeapon2 > 50 and randWeapon2 < 80 then
		weapon2 = GetHashKey("WEAPON_PISTOL50")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	elseif randWeapon2 > 80 and randWeapon2 < 90 then
		weapon2 = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	else
		weapon2 = GetHashKey("WEAPON_CARBINERIFLE")
		GiveWeaponToPed(sus2, weapon2, 1000, 1, 1)
	end
	
	SetPedArmour(sus1, math.random(50, 100))
	SetPedArmour(sus2, math.random(50, 100))
	
	AddRelationshipGroup("fighter1")
	AddRelationshipGroup("fighter2")
	
	SetPedCombatAttributes(sus1, 5, true)
	SetPedCombatAttributes(sus2, 5, true)
	
	SetPedCombatAbility(sus1, 100)
	SetPedCombatAbility(sus2, 100)
	
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("fighter2"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter1"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(5, GetHashKey("fighter2"), GetHashKey("fighter1"))
	
	SetPedRelationshipGroupHash(sus1, GetHashKey("fighter1"))
	SetPedRelationshipGroupHash(sus2, GetHashKey("fighter2"))
	
	SetEntityCanBeDamagedByRelationshipGroup(sus1, false, GetHashKey("fighter2"))
	SetEntityCanBeDamagedByRelationshipGroup(sus2, false, GetHashKey("fighter1"))
	
	TaskCombatHatedTargetsAroundPed(sus1, 20.0, 0)
	TaskCombatHatedTargetsAroundPed(sus2, 20.0, 0)
end)

RegisterNetEvent('pis:crazy:spawn')
AddEventHandler('pis:crazy:spawn', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	
	sus1Model = "a_m_m_hillbilly_01"
    sus1ModelHash = GetHashKey(sus1Model)
    RequestModel(sus1ModelHash)

    while not HasModelLoaded(sus2ModelHash) and not HasModelLoaded(sus1ModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    sus1 = CreatePed(26, sus1Model, 1990.9509277344, 3047.7770996094, 47.215118408203 , 45.0, true, true)
end)

RegisterNetEvent('pis:crazy')
AddEventHandler('pis:crazy', function()
	location = "~o~Yellowjack, Sandy Shores~w~"
	callout = "~r~Shots Fired~w~"
	response = "~r~Code 3~w~"
	
	local randWeapon1 = math.random(100)
	if randWeapon1 < 50 then
		weapon1 = GetHashKey("WEAPON_COMBATPISTOL")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 50 and randWeapon1 < 80 then
		weapon1 = GetHashKey("WEAPON_PISTOL50")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	elseif randWeapon1 > 80 and randWeapon1 < 90 then
		weapon1 = GetHashKey("WEAPON_PUMPSHOTGUN")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	else
		weapon1 = GetHashKey("WEAPON_CARBINERIFLE")
		GiveWeaponToPed(sus1, weapon1, 1000, 1, 1)
	end
	
	SetPedArmour(sus1, math.random(50, 100))
	SetPedArmour(sus2, math.random(50, 100))
	
	AddRelationshipGroup("suspect")
	AddRelationshipGroup("targets")
	
	SetPedCombatAttributes(sus1, 5, true)
	
	SetPedCombatAbility(sus1, 100)
	
	SetPedRelationshipGroupHash(sus1, GetHashKey("COUGAR"))
	
	SetPedCombatMovement(sus1, 3)
	
	TaskCombatHatedTargetsAroundPed(sus1, 20.0, 0)
end)

RegisterNetEvent('pis:weapon:spawn')
AddEventHandler('pis:weapon:spawn', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	
	sus1Model = "S_M_Y_MARINE_01"
    sus1ModelHash = GetHashKey(sus1Model)
    RequestModel(sus1ModelHash)

    while not HasModelLoaded(sus2ModelHash) and not HasModelLoaded(sus1ModelHash) do
        Wait(1)
    end
	
	Wait(1000)
	
    sus1ab = CreatePed(26, sus1Model, 1947.19921875, 3749.01953125, 32.211513519287 , 45.0, true, true)
end)

RegisterNetEvent('pis:weapon')
AddEventHandler('pis:weapon', function()
	callID = "weapon"
	location = "~o~24/7, Sandy Shores~w~"
	callout = "~r~Armed Man~w~"
	response = "~r~Code 3~w~"
	hasAimedWeapon = false
	hasMadeContact = false
	
	suspectAttitude = math.random(100)
	retaliationChance = math.random(50)
	
	AddRelationshipGroup("suspect")
	
	SetRelationshipBetweenGroups(1, GetHashKey("suspect"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("PLAYER"), GetHashKey("suspect"))
    
	weapon = "WEAPON_CARBINERIFLE"
	GiveWeaponToPed(sus1ab, weapon, 1000, 1, 1)
	
	SetPedRelationshipGroupHash(sus1ab, GetHashKey("suspect"))
	
	SetPedArmour(sus1ab, math.random(100))
	
	TaskWanderStandard(sus1ab, 1.0, 10)
	while true do
	Citizen.Wait(1000)
		player = GetPlayerPed(-1)
		_ , target = GetEntityPlayerIsFreeAimingAt(PlayerId())
		if GetDistanceBetweenCoords(GetEntityCoords(sus1ab), GetEntityCoords(player)) < 10 and not IsPedInAnyVehicle(player) and not hasAimedWeapon and not hasMadeContact then
			ShowNotification("~o~Suspect: ~w~" .. "Hello there officer.")
			ClearPedTasks(sus1ab)
			TaskTurnPedToFaceEntity(sus1ab, player, -1)
			hasMadeContact = true
		elseif DoesEntityExist(target) and target == sus1ab and not hasAimedWeapon then
			local suspectGunQuotes = {"Hey! Dont point that shit at me!", "Yo! Get that gun away from me!", "There is no need for this!"}
			ShowNotification("~o~Suspect: ~w~" .. suspectGunQuotes[math.random(#suspectGunQuotes)])
			ClearPedTasks(sus1ab)
			TaskTurnPedToFaceEntity(sus1ab, player, -1)
			hasMadeContact = true
			hasAimedWeapon = true
		end
	end
end)

RegisterNetEvent('pis:weapon:drop:q')
AddEventHandler('pis:weapon:drop:q', function()
	hasDroppedWeapon = false
	isAimingAtOfficer = false
	
	if speech == "Normal" then
		local officerDropQuotes = {"Drop it!", "Put the gun down!", "Come on, put it down.", "Work with me! Drop the gun!", "Drop the weapon!"}
		ShowNotification("~o~Officer: ~w~" .. officerDropQuotes[math.random(#officerDropQuotes)])
		suspectAttitude = suspectAttitude - math.random(5)
		retaliationChance = retaliationChance + math.random(6)
	else
		local officerDropQuotes = {"Fucking drop it!", "Put the fucking gun down!", "Put it the fuck down down.", "Work with me! Drop the gun!", "Drop the fucking weapon!"}
		ShowNotification("~o~Officer: ~w~" .. officerDropQuotes[math.random(#officerDropQuotes)])
		suspectAttitude = suspectAttitude - math.random(10)
		retaliationChance = retaliationChance + math.random(12)
	end
	
	Wait(2000)
	
	if suspectAttitude < 10 and not hasDroppedWeapon then
		local suspectDropQuotes = {"Alright! Dont shoot.", "Okay, im doing it!", "Dont shoot me! I'll do it!", "Okay, okay!"}
		ShowNotification("~o~Suspect: ~w~" .. suspectDropQuotes[math.random(#suspectDropQuotes)])
		hasDroppedWeapon = true
		GetWeaponObjectFromPed(sus1ab, false)
		RemoveAllPedWeapons(sus1ab)
	elseif suspectAttitude > 10 and suspectAttitude < 95 and not hasDroppedWeapon then
		local suspectDropQuotes = {"I know my rights!", "I'm exercising my rights, fuck you!", "I'm allowed to do this! Get back!", "No!"}
		ShowNotification("~o~Suspect: ~w~" .. suspectDropQuotes[math.random(#suspectDropQuotes)])
	elseif suspectAttitude > 95 and suspectAttitude < 99 and not hasDroppedWeapon and hasAimedWeapon then
		local suspectDropQuotes = {"You aim your gun at me?! I'll aim mine at you!", "Get the fuck back!", "I'll fucking kill you all!", "Back up!"}
		ShowNotification("~o~Suspect: ~w~" .. suspectDropQuotes[math.random(#suspectDropQuotes)])
		isAimingAtOfficer = true
		while true do
		Citizen.Wait(0)
			if isAimingAtOfficer then
				TaskAimGunAtEntity(sus1ab, player, -1, false)
			end
		end
	elseif suspectAttitude >= 99 and not hasDroppedWeapon then
		SetRelationshipBetweenGroups(5, GetHashKey("suspect"), GetHashKey("PLAYER"))
		TaskCombatHatedTargetsAroundPed(sus1ab, 20.0, 0)
	elseif hasDroppedWeapon then
		ShowNotification("~o~Suspect: ~w~" .. "I've already dropped it!")
	end
end)

RegisterNetEvent('pis:weapon:face:q')
AddEventHandler('pis:weapon:face:q', function()
	isFacingAway = false
	
	if speech == "Normal" then
		local officerFaceQuotes = {"Turn around!", "Face away from me!"}
		ShowNotification("~o~Officer: ~w~" .. officerFaceQuotes[math.random(#officerFaceQuotes)])
	else
		local officerFaceQuotes = {"Turn the fuck around!", "Face the fuck away from me!"}
		ShowNotification("~o~Officer: ~w~" .. officerFaceQuotes[math.random(#officerFaceQuotes)])
	end
	
	Wait(2000)
	
	if suspectAttitude < 10 and hasDroppedWeapon and not isFacingAway then
		local suspectFaceQuotes = {"Alright! Dont shoot.", "Okay, im doing it!", "Dont shoot me! I'll do it!", "Okay, okay!"}
		ShowNotification("~o~Suspect: ~w~" .. suspectFaceQuotes[math.random(#suspectFaceQuotes)])
		TaskAchieveHeading(sus1ab, GetEntityHeading(player), 5000)
	elseif suspectAttitude > 10 and suspectAttitude < 95 and hasDroppedWeapon and not isFacingAway then
		local suspectFaceQuotes = {"This is unconstitutional!", "I want your badge number!", "You're getting fired!", "You're breaching my rights!"}
		ShowNotification("~o~Suspect: ~w~" .. suspectFaceQuotes[math.random(#suspectFaceQuotes)])
		TaskAchieveHeading(sus1ab, GetEntityHeading(player), 5000)
	else
		SetRelationshipBetweenGroups(5, GetHashKey("suspect"), GetHashKey("PLAYER"))
		TaskCombatHatedTargetsAroundPed(sus1ab, 20.0, 0)
	end
end)

RegisterNetEvent('pis:weapon:threat:q')
AddEventHandler('pis:weapon:threat:q', function()	
	local isShooting = false
	if speech == "Normal" then
		officerThreatQuotes = {"Dont make me shoot you!", "I dont want to kill you!", "You're going to get shot", "Come on! We dont want to shoot you!"}
		ShowNotification("~o~Officer: ~w~" .. officerThreatQuotes[math.random(#officerThreatQuotes)])
		if suspectAttitude < 95 then
			suspectAttitude = suspectAttitude - math.random(15)
			retaliationChance = retaliationChance + math.random(20)
		else
			suspectAttitude = suspectAttitude - math.random(3)
			retaliationChance = retaliationChance + math.random(50, 100)
		end
	else
		local officerThreatQuotes = {"Do what i say, or you're gonna get shot!", "Are you fucking deaf?! You're gonna get shot!", "I'll shoot you right between the eyes!", "I'll turn you into Swiss cheese motherfucker!"}
		ShowNotification("~o~Officer: ~w~" .. officerThreatQuotes[math.random(#officerThreatQuotes)])
		if suspectAttitude < 95 then
			suspectAttitude = suspectAttitude - math.random(20)
			retaliationChance = retaliationChance + math.random(30)
		else
			suspectAttitude = suspectAttitude - math.random(5)
			retaliationChance = retaliationChance + math.random(50, 100)
		end
	end
	while true do
	Citizen.Wait(0)
		if retaliationChance >= 90 and not isShooting then
			SetRelationshipBetweenGroups(5, GetHashKey("suspect"), GetHashKey("PLAYER"))
			TaskCombatHatedTargetsAroundPed(sus1ab, 20.0, 0)
			isShooting = true
		end
	end
end)

RegisterNetEvent('pis:weapon:knees:q')
AddEventHandler('pis:weapon:knees:q', function()
	if speech == "Normal" then
		ShowNotification("~o~Officer: ~w~" .. "Down on your knees!")
	else
		ShowNotification("~o~Officer: ~w~" .. "Get the fuck down!")
	end
	
	if retaliationChance >= 85 then
		fleeChance = math.random(10)
		if fleeChance > 5 then
			TaskReactAndFleePed(sus1ab, player)
			sus1ab = sus1
		else
			TaskPlayAnim(sus1ab, "random@arrests", "idle_2_hands_up", 8.0, 2.0, -1, 2, 0, 0, 0, 0 )
			Citizen.Wait (4000)
			TaskPlayAnim(sus1ab, "random@arrests@busted", "enter", 8.0, 3.0, -1, 2, 0, 0, 0, 0 )
			Citizen.Wait (500)
			TaskPlayAnim(sus1ab, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		end
	elseif hasDroppedWeapon and isFacingAway then
		TaskPlayAnim(sus1ab, "random@arrests", "idle_2_hands_up", 8.0, 2.0, -1, 2, 0, 0, 0, 0 )
		Citizen.Wait (4000)
		TaskPlayAnim(sus1ab, "random@arrests@busted", "enter", 8.0, 3.0, -1, 2, 0, 0, 0, 0 )
		Citizen.Wait (500)
		TaskPlayAnim(sus1ab, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
	end
end)

RegisterNetEvent('pis:code4')
AddEventHandler('pis:code4', function()
	SetEntityAsMissionEntity(sus1)
	DeleteEntity(sus1)
	SetEntityAsMissionEntity(sus1ab)
	DeleteEntity(sus1ab)
	SetEntityAsMissionEntity(sus2)
	DeleteEntity(sus2)
end)


enableRandomEvents = true
enableRandomEventBlips = false
randomEventMinTime = 60 --seconds
randomEventMaxTime = 400 --seconds
----------------------------------
Citizen.CreateThread(function()
  while enableRandomEvents do
    randomEventWaitTime = math.random(randomEventMinTime,randomEventMaxTime) * 1000
    --ShowNotification('~g~Waiting '.. randomEventWaitTime / 1000 ..' seconds...')
    Citizen.Wait(randomEventWaitTime)
    --ShowNotification('~g~Wait is over! Triggering...')
    TriggerEvent('pis:randveh')
  end
end)

maxBlipDist = 1000
--
Citizen.CreateThread(function()
  while true do
  Citizen.Wait(1000)
    if DoesEntityExist(randVeh) then
        --_randDist = GetDistanceBetweenCoords(GetEntityCoords(randVeh), GetEntityCoords(player))
		_randDist = DistanceBetweenCoords(randVeh,player).distance
        if _randDist < maxBlipDist then
            if DoesBlipExist(vehBlip) then
                RemoveBlip(vehBlip)
            end
        else
            if DoesBlipExist(vehBlip) == false and enableRandomEventBlips == true then
                vehBlip = AddBlipForEntity(randVeh)
                SetBlipColour(vehBlip, white)
            end
        end
    end
  end
end)

RegisterCommand("randveh", function()
    TriggerEvent('pis:randveh')
end)

RegisterNetEvent('pis:randveh')
AddEventHandler('pis:randveh', function()
    
    
    --ShowNotification("Getting Random Vehicle")
    
    --randVeh = GetRandomVehicleInSphere(vehPos.x + randX, vehPos.y + randY, vehPos.z, 5000.0, 0, 70)
    --randVehDriver = GetPedInVehicleSeat(randVeh, -1)
    
    foundRand = false
    
	offenceType = math.random(5)
	
    while foundRand == false do
        Citizen.Wait(0)
        --ShowNotification("~b~Finding Vehicle...")
        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehPos = GetEntityCoords(vehicle)
        randX = math.random(-50, 50)
        randY = math.random(-50, 50)
        randVeh = GetRandomVehicleInSphere(vehPos.x + randX, vehPos.y + randY, vehPos.z, 5000.0, 0, 70)
		randVehDriver = GetPedInVehicleSeat(randVeh, -1)
        if DoesEntityExist(randVeh) and DoesEntityExist(randVehDriver) and randVeh ~= stoppedVeh and IsPedAPlayer(randVehDriver) == false then
          --  ShowNotification("Vehicle found! it's id is... ~g~".. randVeh)
			if offenceType == 5 then
				--ShowNotification("Unroadworthy Vehicle")
				
				local randVehPos = GetEntityCoords(randVeh)
				
				SetVehicleTyreBurst(randVeh, 0, true, math.random(1000))
				tireBurst = math.random(3)
					if tireBurst == 1 then
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
					elseif tireBurst == 2 then
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
					elseif tireBurst == 3 then
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
						SetVehicleTyreBurst(randVeh, math.random(4), false, math.random(1000))
					end
					
				SetVehicleDirtLevel(randVeh,15.0)
				SmashVehicleWindow(randVeh, math.random(4))
				SmashVehicleWindow(randVeh, math.random(4))
				SmashVehicleWindow(randVeh, math.random(4))
				SetVehicleDoorBroken(randVeh, math.random(5), true)
				SetVehicleEngineHealth(randVeh, 300.0)
				SetVehicleEngineCanDegrade(randVeh, false)
				TaskVehicleDriveWander(randVehDriver, randVeh, 7.0, 2883621)
				unrdwrthyVeh = randVeh
			elseif offenceType == 4 then
				--ShowNotification("Speeder")
				TaskVehicleDriveWander(randVehDriver, randVeh, 30.0, 5)
				speedVeh = randVeh
			elseif offenceType == 3 then
				--ShowNotification("Reckless Driver")
				TaskVehicleDriveWander(randVehDriver, randVeh, 15.0, 2883621)
				rcklsVeh = randVeh
			elseif offenceType == 2 then
				--ShowNotification("Reckless Driver lvl 2")
				TaskVehicleDriveWander(randVehDriver, randVeh, 30.0, 1074528293)
				rcklsVeh = randVeh
			elseif offenceType == 1 then
				--ShowNotification("No lights")
				SetVehicleLights(randVeh, 1)
				SetVehicleBrakeLights(randVeh, false)
				nolghtVeh = randVeh
			else
				--ShowNotification("Other")
			end
            foundRand = true
            SetEntityAsMissionEntity(randVeh, true)
            RemoveBlip(vehBlip)
			RemoveBlip(vehBlip2)
            if enableRandomEventBlips then
              vehBlip = AddBlipForEntity(randVeh)
              SetBlipColour(vehBlip, white)
            end
        end
    end
end)

RegisterCommand('re', function()
  if enableRandomEvents then
    ShowNotification("Random Events: ~r~Disabled.")
    enableRandomEvents = false
  else
    ShowNotification("Random Events: ~g~Enabled.")
    enableRandomEvents = true
  end
end)

RegisterNetEvent('pis:notification')
AddEventHandler('pis:notification', function()
	ShowNotification("~w~All units, respond " .. response .. " to " .. location .. " for " .. callout)
end)

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function DistanceBetweenCoords(ent1, ent2)
    local x1,y1,z1 = table.unpack(GetEntityCoords(ent1, true))
    local x2,y2,z2 = table.unpack(GetEntityCoords(ent2, true))
    local deltax = x1 - x2
    local deltay = y1 - y2
    local deltaz = y1 - y2
    
    dist = math.sqrt((deltax * deltax) + (deltay * deltay) + (deltaz * deltaz))
    xout = math.abs(deltax)
    yout = math.abs(deltay)
    zout = math.abs(deltaz)
    result = {distance = dist, x = xout, y = yout, z = zout}
    
    return result
end