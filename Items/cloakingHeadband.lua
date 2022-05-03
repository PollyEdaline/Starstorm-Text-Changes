local path = "Items/Resources/"

it.CloakingHeadband = Item.new("Cloaking Headband")
local sCloakingHeadband = Sound.load("CloakingHeadband", path.."cloakingHeadband")
it.CloakingHeadband.pickupText = "Become temporarily undetectable." 
it.CloakingHeadband.sprite = Sprite.load("CloakingHeadband", path.."Cloaking Headband.png", 2, 12, 9)
it.CloakingHeadband.isUseItem = true
it.CloakingHeadband.useCooldown = 45
it.CloakingHeadband:setTier("use")
itp.enigma:add(it.CloakingHeadband)
it.CloakingHeadband:setLog{
	group = "use",
	description = "&b&Become undetectable for 16 seconds.",
	story = "Of all things, why is this a silly headband? A belt would have made much more sense, you know? Not to throw a tantrum, but this just feels off and unnecessary. 'Specially knowing what's out on the market.\nI really can't let you get away with this as it is, reconsider before the end of this season.",
	destination = "Olmos Developments,\nNew Satt,\nEarth",
	date = "11/10/2056"
}
local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if playerData.generatePOITimer then
		if playerData.generatePOITimer > 0 then
			playerData.generatePOITimer = playerData.generatePOITimer - 1
			
			local poi = Object.findInstance(player:get("child_poi")) or obj.POI:findMatchingOp("parent", "==", player.id)
			if type(poi) == "table" and poi[1] then poi = poi[1] elseif type(poi) == "table" then poi = nil end -- aaaaaaaaaaaa i hate this
			if poi and poi:isValid() then
				player.alpha = 0.1
				poi:destroy()
			end
		else
			player.alpha = 1
			
			local poi = Object.findInstance(player:get("child_poi"))
			
			if not poi or not poi:isValid() then
				local newpoi = obj.POI:create(player.x, player.y)
				newpoi:set("parent", player.id)
				player:set("child_poi ", newpoi.id)
			end
			
			playerData.generatePOITimer = nil
		end
	end
end

local onPlayerDrawAboveCall = function(player)
	if player:getData().generatePOITimer then
		local alpha = 0.1 + (math.random(1, 20) * 0.01)
		graphics.setBlendMode("additive")
		graphics.drawImage{
			image = player.sprite,
			angle = player.angle,
			alpha = alpha,
			solidColor = Color.AQUA,
			x = player.x,
			y = player.y,
			xscale = player.xscale,
			yscale = player.yscale,
			subimage = player.subimage
		}
		graphics.setBlendMode("normal")
	end
end

it.CloakingHeadband:addCallback("use", function(player, embryo)
	sCloakingHeadband:play()
	
	local poi = Object.findInstance(player:get("child_poi"))
	
	if poi and poi:isValid() then
		poi:destroy()
	end
	
	player.alpha = 0.1
	if embryo then
		player:getData().generatePOITimer = 1920
	else
		player:getData().generatePOITimer = 960
	end
	
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDrawAbove", onPlayerDrawAboveCall)
end)