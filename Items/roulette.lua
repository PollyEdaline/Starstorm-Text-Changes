local path = "Items/Resources/"

it.Roulette = Item.new("Roulette")
local rouletteVars = {
	maxhp_base = {value = 60, subimage = 2},
	hp_regen = {value = 0.06, subimage = 3},
	damage = {value = 16, subimage = 4},
	attack_speed = {value = 0.38, subimage = 5},
	critical_chance = {value = 23, subimage = 6},
	pHmax = {value = 0.26, subimage = 7},
	armor = {value = 34, subimage = 8}
}
local sRoulette = Sound.load("Roulette", path.."roulette")
it.Roulette.pickupText = "Gain a random buff that changes every minute." 
it.Roulette.sprite = Sprite.load("Roulette", path.."Roulette.png", 1, 14, 9)
local roulettedis = Sprite.load("RouletteDisplay", path.."roulettedis.png", 8, 20, 20)
objRoulette = Object.new("Roulette")
objRoulette.sprite = roulettedis
it.Roulette:setTier("uncommon")
it.Roulette:setLog{
	group = "uncommon_locked",
	description = "Get a &y&random buff&!& that changes every minute.",
	story = "Replacement Roulette model 144Bella-1 in follow-up to the recent events that unfolded in the casino. For further inquiries, please contact us at the E-direction given by our representatives.",
	destination = "PRoom 3.1,\nSecva Casino,\nEarth",
	date = "7/17/2057"
}
callback.register("onItemRemoval", function(player, item, count)
	if item == it.Roulette then
		if player:countItem(item) == 0 then
			local playerData = player:getData()
			if playerData.rouletteBuff then
				player:set(playerData.rouletteBuff[1], player:get(playerData.rouletteBuff[1]) - playerData.rouletteBuff[2])
				playerData.rouletteBuff = nil
			end
		end
	end
end)
objRoulette:addCallback("create", function(self)
	local selfData = self:getData()
	self.subimage = 1
	self.spriteSpeed = 0
	selfData.rspeed = 1
	selfData.timer = 0
	selfData.life = 120
	selfData.blend = 1 
	if onScreen(self) then
		sRoulette:play(0.9 + math.random() * 0.2)
	end
end)
objRoulette:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 80 then
		selfData.rspeed = selfData.rspeed * 1.1
		self.angle = self.angle + selfData.rspeed
		if selfData.life == 118 and selfData.parent and selfData.parent:isValid() then
			local parentPrevious = selfData.parent:getData().rouletteBuff
			if parentPrevious then
				selfData.parent:set(parentPrevious[1], selfData.parent:get(parentPrevious[1]) - parentPrevious[2])
			end
		end		
	else
		selfData.blend = selfData.blend - 0.01
		self.y = self.y - 0.05
		self.blendColor = Color.mix(Color.BLACK, Color.WHITE, selfData.blend)
		self.alpha = selfData.blend
		if not selfData.trigger then
			selfData.trigger = true
			if selfData.variable then
				local rouletteVar = rouletteVars[selfData.variable]
				self.subimage = rouletteVar.subimage
				if selfData.parent and selfData.parent:isValid() then
					local value = rouletteVar.value * (0.6 + 0.4) * selfData.parent:get("roulette")
					selfData.parent:set(selfData.variable, (selfData.parent:get(selfData.variable) or 0) + value)
					selfData.parent:getData().rouletteBuff = {selfData.variable, value}
				end
			end
			self.angle = 0
		end
	end
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
	else
		self:destroy()
	end
end)

local rouletteFunc = setFunc(function(roulette, parent, variable)
	roulette:getData().parent = parent
	roulette:getData().variable = variable
end)

callback.register("onMinute", function()
	if net.host then
		for _, actor in ipairs(pobj.actors:findAll()) do
			local count = actor:get("roulette")
			if count and count > 0 then
				local variable = table.irandom{"maxhp_base", "hp_regen", "damage", "attack_speed", "critical_chance", "pHmax", "armor"}
				createSynced(objRoulette, actor.x, actor.y - 50, rouletteFunc, actor, variable)
			end
		end
	end
end)

it.Roulette:addCallback("pickup", function(player)
	player:set("roulette", (player:get("roulette") or 0) + 1)
	if not player:getData().rouletteBuff then
		if net.host then
			local variable = table.irandom{"maxhp_base", "hp_regen", "damage", "attack_speed", "critical_chance", "pHmax", "armor"}
			createSynced(objRoulette, player.x, player.y - 50, rouletteFunc, player, variable)
		end
	end
end)