local path = "Items/Resources/"

it.AnimatedMechanism = Item.new("Animated Mechanism")
it.AnimatedMechanism.pickupText = "Passively shoot at nearby enemies. Shoot faster at low health." 
it.AnimatedMechanism.sprite = Sprite.load("Animated Mechanisme", path.."Animated Mechanism.png", 1, 15, 15)
itp.legendary:add(it.AnimatedMechanism)
it.AnimatedMechanism.color = "y"
it.AnimatedMechanism:setLog{
	group = "boss",
	description = "Shoot a projectile at the nearest enemy every 3 seconds for &y&200% damage&!&. Shoots faster at low health.",
	story = "What I find interesting is how adaptable this entire planet is. Everything manages to evolve at an alarming rate. To me, this is a great reminder of how incredibly supernatural it has all been.\nAaaand here I am talking to a piece of metal, again...",
	priority = "&b&Field-Found&!&",
	destination = "Old Reliquary,\n4C Plaza,\nEarth",
	date = "Unknown"
}

if obj.TotemController then
	NPC.registerBossDrops(obj.TotemController, 15)
	NPC.addBossItem(obj.TotemController, it.AnimatedMechanism)
end

local bulletFunc = setFunc(function(bullet, parent)
	bullet:getData().parent = parent
	bullet:getData().controller = parent
	bullet:getData().team = parent:get("team")
	bullet:getData().damage = parent:get("damage") * (1 + 1 * parent:countItem(it.AnimatedMechanism))
	bullet:getData().properties = DAMAGER_NO_PROC
	bullet:getData().size = 0.5
	if onScreen(bullet) then
		sfx.SpiderShoot1:play(0.6 + math.random() * 0.2, 0.1)
	end
end)

local onPlayerStepCall = function(player)
	local count = player:countItem(it.AnimatedMechanism)
	if count > 0 then
		if net.host then
			local playerData = player:getData()
			
			if playerData.anMechanismTimer then
				if playerData.anMechanismTimer > 0 then
					playerData.anMechanismTimer = playerData.anMechanismTimer - 1
				else
					local r = 250
					for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
						if actor:get("team") ~= player:get("team") then
							createSynced(obj.TotemBullet, player.x, player.y, bulletFunc, player)
							local hpx = 0
							if player:get("hp") > 0 then
								local hpx = player:get("hp") / player:get("maxhp")
								playerData.anMechanismTimer = math.max(200 * hpx, 25)
							end
							break
						end
					end
				end
			else
				playerData.anMechanismTimer = 0
			end
		end
	end
end

it.AnimatedMechanism:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)