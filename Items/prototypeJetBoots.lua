local path = "Items/Resources/"

it.PrototypeJetBoots = Item.new("Prototype Jet Boots")
local sPrototypeJetBoots = Sound.load("PrototypeJetBoots", path.."prototypeJetBoots")
local sprProtoBootsSparks1 = Sprite.load("PrototypeJetBoots_Sparks", path.."protobootssparks", 4, 10, 8)
local parPrototypeJetBoot1 = par.Fire3
local parPrototypeJetBoot2 = ParticleType.find("Fire5", "Starstorm")
local parPrototypeJetBoot3 = ParticleType.find("Debris", "Starstorm")
it.PrototypeJetBoots.pickupText = "Detonate on jump!" 
it.PrototypeJetBoots.sprite = Sprite.load("PrototypeJetBoots", path.."Prototype Jet Boots.png", 1, 13, 10)
it.PrototypeJetBoots:setTier("uncommon")
it.PrototypeJetBoots:setLog{
	group = "uncommon",
	description = "&y&Explode on jump for 150% damage.",
	story = "Hey [REDACTED], these are the prototype Jet Boots we're working on. Same as last time: take them out for a ride, test the output, blah blah. Please just tell us if anything goes wrong.\nAlso please remember not to press the blue component that sticks out on the back; we don't want any more accidents... Hopefully we can get that fixed and reinforced on the next revision, I don't know yet, [REDACTED] is still busy solving the battery problem.\nWe are already running out of time so please send us your log ASAP.",
	priority = "&y&Volatile&!&",
	destination = "Pget #45,\nNooret,\nMars",
	date = "03/11/2056"
}

local onPlayerStepCall = function(player)
	local protoBoots = player:countItem(it.PrototypeJetBoots)
	if protoBoots > 0 then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if playerAc.moveUp == 1 and playerAc.free == 0 and playerAc.activity ~= 30 and playerAc.bunker == 0 and not playerData.protoBootsActivated and playerAc.bunker == 0 and not playerData.protoBootsActivated and not playerData.usingMinigun and not playerData.vehicle then
			if global.quality > 1 then
				parPrototypeJetBoot2:burst("middle", player.x, player.y + 6, 4)
			end
			if global.quality == 3 then
				parPrototypeJetBoot3:burst("middle", player.x, player.y + 6, 8)
			end
			sPrototypeJetBoots:play(1 + math.random() * 0.2, 0.9)
			player:fireExplosion(player.x, player.y, 1.8, 2, 0.5 + (1 * protoBoots), nil, sprProtoBootsSparks1, DAMAGER_NO_PROC)
			playerData.protoBootsActivated = true
		elseif playerAc.free == 0 or playerAc.activity == 30 or playerAc.pVspeed > -0.8 then
			playerData.protoBootsActivated = nil
		end
		if playerAc.free == 1 and playerAc.activity < 30 and playerAc.pVspeed < -0.8 and playerData.protoBootsActivated then
			if global.quality == 3 then
				parPrototypeJetBoot1:burst("middle", player.x, player.y + 6, 1)
			end
		end
	end
end

it.PrototypeJetBoots:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)