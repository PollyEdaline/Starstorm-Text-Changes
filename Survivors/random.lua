

-- The following doesn't work 10/10 so I'd rather leave it out for now.


local randomSurvivor = Survivor.new("Random")

-- Selection sprite
randomSurvivor.loadoutSprite = Sprite.load("Random_Select", "Misc/Menus/selectRandom", 4, 2, 0)

-- Selection description
randomSurvivor:setLoadoutInfo(
[[Roll a &y&random survivor&!& on start!]], spr.Nothing)

-- Color of highlights during selection
randomSurvivor.loadoutColor = Color.fromHex(0x0A0505)

-- Misc. menus sprite
randomSurvivor.idleSprite = spr.Random

-- Main menu sprite
randomSurvivor.titleSprite = spr.Random

-- Endquote
randomSurvivor.endingQuote = "..and so they left, wondering how this could have happened."

-- Stats & Skills
randomSurvivor:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	
	player:survivorSetInitialStats(1, 9999, 0) -- lol
end)

-- Logic
callback.register("globalStep", function(room)
	if room == rm.Select then
		local oSelect = obj.Select:find(1)
		
		if oSelect and oSelect:isValid() then
			
			local ac = oSelect:getAccessor()
			
			--for _, e in ipairs({"trans","hover_element_v","temp_choice","char_number","pressed_mouse","inputseed","choice","choice2","chosen_sprite"}) do
			--print(e.." = "..oSelect:get(e))
			--end
			
			--print(ac.temp_choice, ac.chosen_index)
			local pressedOk
			if input.checkMouse("left") == input.PRESSED or
			input.checkKeyboard("a") == input.PRESSED or
			input.checkGamepad("face1", 1) == input.PRESSED
			then
				pressedOk = true
				--print("ok")
			end
			
			if ac.temp_choice == -5 and pressedOk and ac.chosen_sprite == randomSurvivor.loadoutSprite.id then
				local v = 2
				if sur.Spectator and not sur.Spectator.disabled then
					v = 3
				end
				ac.choice = math.random(ac.char_total - v)
			end
		end
	elseif room == rm.SelectCoop then
		local oSelect = obj.SelectCoop:find(1)
		
		if oSelect and oSelect:isValid() then
			
			local ac = oSelect:getAccessor()
			
			--for _, e in ipairs({"trans","hover_element_v","temp_choice","char_number","pressed_mouse","inputseed","choice","choice2","chosen_sprite"}) do
			--print(e.." = "..oSelect:get(e))
			--end
			
			--print(ac.temp_choice, ac.player_choosing)
			
			if ac.temp_choice == -5 and input.checkMouse("left") == input.PRESSED  and ac.chosen_sprite == randomSurvivor.loadoutSprite.id then
				local v = 2
				if sur.Spectator and not sur.Spectator.disabled then
					v = 3
				end
				ac.choice = math.random(ac.char_total - v)
			end
		end
	end
end)