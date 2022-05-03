local path = "Items/Resources/"

it.EntangledEnergy = Item.new("Entangled Energy")
it.EntangledEnergy.pickupText = "It grows on me..." 
it.EntangledEnergy.sprite = Sprite.load("EntangledEnergy", path.."Entangled Energy.png", 1, 15, 15)
itp.sibylline:add(it.EntangledEnergy)
it.EntangledEnergy.color = Color.fromHex(0xFFCCED)
it.EntangledEnergy:setLog{
	group = "end",
	description = "Release a &y&lethal energy shock&!& to enemies when they group in front of you.",
	story = "Surrounded by this spark of power, I could only feel my mind blending with the elements that gave birth to my existence. I would not be stopped.",
	priority = "&"..it.EntangledEnergy.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
local lightningColor = Color.fromHex(0x4DF9DD)
local range = 400
local height = 3
if obj.NemesisHuntress then
	NPC.registerBossDrops(obj.NemesisHuntress, 100)
	NPC.addBossItem(obj.NemesisHuntress, it.EntangledEnergy)
end

local onPlayerStepCall = function(player)
	if player:countItem(it.EntangledEnergy) > 0 then
		local playerData = player:getData()
		if playerData.entangledEnergycd then
			if playerData.entangledEnergycd == 0 then
				if math.chance(10) and global.quality > 1 then
					par.Electric:burst("middle", player.x, player.y, 1, lightningColor)
				end
				local count = 0
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x, player.y - height, player.x + range * player.xscale, player.y + height)) do
					if actor:get("team") ~= player:get("team") then
						count = count + 1
					end
				end
				if count > 3 then
					playerData.entangledEnergycd = 60 * 9
					sfx.Teleporter:play(1.5 + math.random() * 0.2)
					sfx.ChainLightning:play(0.4 + math.random() * 0.2)
					sfx.ChainLightning:play(0.2 + math.random() * 0.2)
					for i = 1, 10 do
						local xx = player.x + i * 25 * player.xscale
						local cl = obj.ChainLightning:create(xx, player.y)
						cl:set("blend", lightningColor.gml)
						cl:set("team", player:get("team"))
						cl:set("damage", player:get("damage") * 10)
						cl:set("parent", player.id)
					end
				end
			else
				playerData.entangledEnergycd = playerData.entangledEnergycd - 1
			end
		else
			playerData.entangledEnergycd = 0
		end
	end
end

it.EntangledEnergy:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)