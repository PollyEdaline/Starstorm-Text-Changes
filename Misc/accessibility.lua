for _, flag in ipairs(modloader.getFlags()) do
	if flag:find("ss_filter_") == 1 then
		local c = flag:gsub("ss_filter_", "")
		local r = c:find("r") and true or false
		local g = c:find("g") and true or false
		local b = c:find("b") and true or false
		graphics.setChannels(r, g, b, true)
	end
end

if global.rormlflag.ss_accessibility_mode then
	global.accessibility = true
	
	local eliteTypes = {}
	
	local eliteSubimages
	callback.register("postLoad", function()
		eliteTypes = EliteType.findAll()
		eliteSubimages = {
			[elt.Blazing] = 1,
			[elt.Frenzied] = 2,
			[elt.Volatile] = 3,
			[elt.Leeching] = 4,
			[elt.Overloading] = 5,
			[elt.Poisoning] = 6,
			[elt.Dazing] = 7,
			[elt.Weakening] = 8,
			[elt.Corrosive] = 9,
			[elt.Void] = 10,
			[elt.Gilded] = 11,
			[elt.Ethereal] = 12,
			[elt.Negative] = 13
		}
	end)
	
	local sprEliteAccessibilityIcon = Sprite.load("EliteAccessibilityIcon", "Gameplay/Elites/accessibilityDisplay", 14, 3, 3)
	
	callback.register("onEliteInit", function(actor)
		local ptype = actor:get("prefix_type")
		if ptype > 0 then
			if ptype == 1 then
				local t = actor:get("elite_type")
				for _, elt in ipairs(eliteTypes) do
					if elt.id == t then
						actor:getData().eltAcIcon = eliteSubimages[elt]
						break
					end
				end
			else
				actor:getData().eltAcIcon = 14
			end
		end
	end)
	
	table.insert(call.onDraw, function()
		for _, npc in ipairs(pobj.enemies:findAll()) do
			if npc:getData().eltAcIcon and onScreen(npc) then
				local img = npc.mask or npc.sprite or spr.Nothing
				graphics.drawImage{
					image = sprEliteAccessibilityIcon,
					subimage = npc:getData().eltAcIcon,
					x = npc.x + img.width - img.xorigin + 4,
					y = npc.y - 3
				}
			--[[else
				local ptype = npc:get("prefix_type")
				if ptype > 0 then
					if ptype == 1 then
						local t = npc:get("elite_type")
						for _, elt in ipairs(eliteTypes) do
							if elt.id == t then
								npc:getData().eltAcIcon = eliteSubimages[elt]
								break
							end
						end
					else
						npc:getData().eltAcIcon = 14
					end
				end]]
			end
		end
		graphics.color(Color.WHITE)
		graphics.alpha(0.8)
		for _, funball in ipairs(obj.EfGrenadeEnemy:findAll()) do
			graphics.circle(funball.x, funball.y, funball.sprite.width, true)
		end
	end)
end



-- I like bread.