local path = "Items/Resources/"

it.X4Stimulant = Item.new("X-4 Stimulant")
it.X4Stimulant.pickupText = "Reduced secondary skill cooldown." 
it.X4Stimulant.sprite = Sprite.load("X-4 Stimulant", path.."X-4 Stimulant.png", 1, 15, 15)
it.X4Stimulant:setTier("common")
it.X4Stimulant:setLog{
	group = "common",
	description = "&y&Reduces your secondary skill's cooldown by 10%.",
	story = "Encased, including manual. Does the machine show symptoms of a 540? If so you may want to avoid using above 100ml of stimulant.\n\nCheers.",
	priority = "&g&Priority&!&",
	destination = "Romeo 33,\nBatang Ai National Park,\nEarth",
	date = "4/12/2057"
}
it.X4Stimulant:addCallback("pickup", function(player)
	player:set("stimulant", (player:get("stimulant") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.X4Stimulant then
		player:set("stimulant", player:get("stimulant") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local stimulant = actor:get("stimulant")
	if stimulant and stimulant > 0 then
		local data = actor:getData()
		
		--if not isa(actor, "PlayerInstance") then
			if data.stimulantCd then
				local currentCooldown = actor:getAlarm(3)
				if currentCooldown > 0 and data.stimulantCd == -1 then
					local mult = 1 - 1 * (stimulant / (10 + stimulant))
					actor:setAlarm(3, actor:getAlarm(3) * mult)
				end
				data.stimulantCd = currentCooldown
			else
				data.stimulantCd = actor:getAlarm(3)
			end
		--[[elseif actor:get("activity") == 0 then
			data.stimulantCd = false
		end]]
	end
end)