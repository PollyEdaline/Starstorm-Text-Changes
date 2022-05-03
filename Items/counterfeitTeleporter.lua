local path = "Items/Resources/"

it.CounterfeitTeleporter = Item.new("Counterfeit Teleporter")
local sCounterfeitTeleporter = Sound.load("CounterfeitTeleporter", path.."counterfeitTeleporter")
sprCounterfeitTeleporter = Sprite.load("CounterfeitTeleporter", path.."counterfeitTeleporterdis.png", 2, 22, 34)
it.CounterfeitTeleporter.pickupText = "Place a teleporter (single use)." 
it.CounterfeitTeleporter.sprite = Sprite.load("CounterfeitTeleporterItem", path.."Counterfeit Teleporter.png", 2, 19, 11)
it.CounterfeitTeleporter.isUseItem = true
it.CounterfeitTeleporter.useCooldown = 20
it.CounterfeitTeleporter:setTier("use")
it.CounterfeitTeleporter:setLog{
	group = "use",
	description = "&y&Place a teleporter anywhere&!&, once.",
	story = "[DATA ERROR!] No indexed information was found for this package in the UES database. Please contact a supervisor.",
	destination = "[INVALID VALUE]",
	date = "[INVALID VALUE]"
}
it.CounterfeitTeleporter:addCallback("use", function(player)
	local playerAc = player:getAccessor()
	local tele = obj.Teleporter:create(player.x, player.y)
	if Stage.getCurrentStage() == stg.RedPlane then
		tele:set("locked", 1)
	end
	setID(tele)
	tele:getData().counterfeit = true
	tele.sprite = sprCounterfeitTeleporter
	sCounterfeitTeleporter:play()
	if player.useItem == it.CounterfeitTeleporter then
		player.useItem = nil
	elseif contains(player:getData().mergedItems, it.CounterfeitTeleporter) then
		local index
		for i, item in ipairs(player:getData().mergedItems) do
			if item == it.CounterfeitTeleporter then
				index = i
				break
			end
		end
		if index then
			table.remove(player:getData().mergedItems, index)
		end
	end
end)

table.insert(call.onStep, function()
	for _, teleporter in pairs(obj.Teleporter:findAll()) do
	-- Counterfeit Teleporter
		if teleporter:getData().counterfeit then
			if not teleporter:getData().tweaked then
				teleporter:set("value", 0)
				teleporter:set("m_id", 2)
				teleporter:getData().tweaked = true
			elseif teleporter:get("active") > 1 then
				teleporter.subimage = 2
			end
		end
	end
end)


callback.register("postLoad", function()
	if Achievement.find("CounterfeitTeleporter") and Achievement.find("CounterfeitTeleporter"):isComplete() then
		callback.register("onItemRoll", function(pool, item)
			if pool == itp.use then
				local preCount = runData.useItemRolls or 0
				runData.useItemRolls = preCount + 1
				
				if runData.useItemRolls == 30 then
					return it.CounterfeitTeleporter
				end
			end
		end)
	end
end)