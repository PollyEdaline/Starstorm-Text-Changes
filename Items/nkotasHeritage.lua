local path = "Items/Resources/"

it.NkotaH = Item.new("Nkota's Heritage")
local sNkotaH = Sound.load("NkotasHeritage", path.."nkotasHeritage")
local sprNkotaHdis = Sprite.load("NkotaHDisplay", path.."nkotaHdis", 11, 15, 10)
local objNkotaHdis = Object.new("NkotasHeritage")
objNkotaHdis.sprite = sprNkotaHdis
objNkotaHdis.depth = 1
local smallChest = obj.Chest1
local mediumChest = obj.Chest2
local goldChest = obj.Chest5
it.NkotaH.pickupText = "Receive a chest upon level up." 
it.NkotaH.sprite = Sprite.load("NkotaH", path.."Nkota's Heritage.png", 1, 11, 13)
it.NkotaH:setTier("rare")
it.NkotaH:setLog{
	group = "rare",
	description = "Receive a &b&free chest&!& upon &b&level up.",
	story = "After Nkota's siblings started the dispute attempting to get the heritage for themselves, an unidentified individual stole the article in what seemed to be vengeance.\nIt only fell in my hands after a young man sold it for an adequate amount of money. I am sending it to you as you might be able to help me analyze it.\n\nI am willing to sell it to a museum and give you a cut if it IS the authentic one.",
	destination = "Naaga 23,\nH4D3S,\nEarth",
	date = "05/05/2056"
}
objNkotaHdis:addCallback("step", function(self)
	if self.subimage > 10 then
		self:destroy()
	end
end)

local chestFunc = setFunc(function(chest)
	misc.shakeScreen(5)
	sNkotaH:play(0.9 + math.random() * 0.2)
	local display = objNkotaHdis:create(chest.x, chest.y + 30)
	display.spriteSpeed = 0.16
	chest:set("cost", 0)
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	local nkotaH = player:countItem(it.NkotaH)
	if global.quality > 1 and nkotaH > 0 and math.chance(9) then
		par.NkotaH:burst("below", player.x + math.random(-5, 5), player.y + math.random(-5, 3), 1)
	end
	
	if net.host then
		local finishingStage = false
		for _, tele in ipairs(obj.Teleporter:findMatchingOp("active", ">", "3")) do
			finishingStage = true
			break
		end
		if playerData.nkotaH and playerData.nkotaH > 0 and not finishingStage then
			local nkotaH = player:countItem(it.NkotaH)
			local chest = nil
			local lvlcalculation = nkotaH * (math.sqrt(playerAc.level * 13) - 4)
			local location = math.random(- 50, 50)
			local n = 0
			local xx = player.x + location
			local yy = player.y
			
			if obj.B:find(1) then
				local ground
				for _, g in ipairs (obj.B:findAll()) do
					if g:collidesWith(player, g.x, g.y - 1) then
						ground = g
						break
					end
				end
				if not ground then
					for _, g in ipairs (obj.BNoSpawn:findAll()) do
						if g:collidesWith(player, g.x, g.y - 1) then
							ground = g
							break
						end
					end
				end
				if not ground then
					ground = obj.B:findNearest(player.x, player.y)
				end
				local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
				local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
				xx = math.clamp(player.x, groundL, groundR)
				yy = ground.y
			else
				while n < 50 and Stage.collidesPoint(xx, player.y) do
					xx = math.approach(xx, player.x, 1)
					n = n + 1
				end
			end
			if math.chance((0.2 * lvlcalculation) - 1) then
				chest = goldChest
			elseif math.chance(4 * lvlcalculation) then
				chest = mediumChest
			else
				chest = smallChest
			end
			
			local chests = chest:findAll()
			
			local id
			if chests then
				id = #chests + 1
			else
				id = 1
			end
			
			createSynced(chest, xx, yy, chestFunc)
			playerData.nkotaH = playerData.nkotaH - 1
		end
	end
end

it.NkotaH:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)

callback.register ("onPlayerLevelUp", function(player)
	local nkotaH = player:countItem(it.NkotaH)
	if nkotaH > 0 then
		player:getData().nkotaH = (player:getData().nkotaH or 0) + 1
	end
end)