-- Supporter Roles
local specialPlayers = {
	mldevs = {"s@rn", "Uziskull"},
	--ssdevs = {"Neik"}, I don't want to stand out
	supporters = {"Riskka", "Daimera", "Vahnkiljoy", "Scoot", "4cqker", "FrictionlessPortals", "bang", "Assa", "cluicide", "sivelos", "xyz", "zarah", "isla", "4chan", "Wilscwil"}
}
callback.register("onPlayerInit", function(player)
	if net.online then
		local username = player:get("user_name")
		for category, names in pairs(specialPlayers) do
			for _, name in ipairs(names) do
				if string.lower(name) == string.lower(username) then
					player:getData().nameTier = category
					break
				end
			end
		end
	end
end)
callback.register("onPlayerInit", function(player)
	if net.online then
		local username = player:get("user_name")
		if string.lower(username) == "swuff" then
			player:set("armor", 200)
			player:set("user_name", table.irandom({"swarf", "dude person: the guy", "this is not my name", "lemurian", "sWuFf"}))
		end
	end
end)
table.insert(call.preHUDDraw, function()
	if net.online then
		for _, player in ipairs(misc.players) do
			local nameTier = player:getData().nameTier
			if nameTier then
				local camx, camy = misc.camera.x, misc.camera.y
				
				if player:get("dead") == 0 then
					if net.online then
						graphics.alpha(0.3)
						
						local str = player:get("user_name")
						
						local midwidth = graphics.textWidth(str, 1) / 2
						
						graphics.printColor(rainbowStr(str, 255), math.round(player.x - midwidth - camx + 1), math.round(player.y - camy + 9))
					end
				end
			end
		end
	end
end)

-- The dumbest easter eggs
local function drawInverted(handler)
	if handler:getData().player and handler:getData().player:isValid() then
		local player = handler:getData().player
		graphics.drawImage{
			image = player.sprite,
			angle = player.angle,
			alpha = player.alpha,
			color = player.blendColor,
			x = player.x,
			y = player.y,
			xscale = player.xscale,
			yscale = player.yscale * -1,
			subimage = player.subimage
		}
	else
		handler:destroy()
	end
end

table.insert(call.onPlayerDraw, function(player)
	if net.online then
		local pName = player:get("user_name"):lower()
		if pName == "dinnerbone" then
			local handler = graphics.bindDepth(player.depth, drawInverted)
			handler:getData().player = player
			player.visible = false
		elseif pName:find("gay") then
			graphics.printColor(rainbowStr("GAY", 100), math.ceil(player.x - 8), player.y - 20)
		end
	end
end)