local relicColor = Color.fromHex(0xC649AD)

local itRelicExtinction = Item.new("Relic of Extinction")
itRelicExtinction.pickupText = "A black hole follows you, annihilating enemies, BUT it can also annihilate you." 
itRelicExtinction.sprite = Sprite.load("RelicExtinction", "Items/Resources/Relic of Extinction.png", 1, 15, 15)
itp.relic:add(itRelicExtinction)
itRelicExtinction.color = relicColor
itRelicExtinction:setLog{
	group = "boss_locked",
	description = "&y&A black hole follows you, annihilating enemies, &p&BUT &r&it can also annihilate you.",
	story = "As all the books say: 'with creation came destruction.' But only destruction has the ability to reduce our egos into the nothingness they are, for we are ephemeral.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}

local objExtinctionBall = Object.new("ExtinctionBall")
objExtinctionBall.depth = -11

objExtinctionBall:addCallback("create", function(self)
	local data = self:getData()
	local ac = self:getAccessor()
	
	ac.speed = 1
	ac.direction = 270
	data.range = 30
end)
objExtinctionBall:addCallback("step", function(self)
	local data = self:getData()
	local ac = self:getAccessor()
	
	if global.quality > 2 then
		local color = table.irandom({0x647F6B, 0x5B354A})
		par.Gravitational:burst("middle", self.x, self.y, 1, Color.fromHex(color))
	end
	
	local parent = data.parent
	
	if parent and parent:isValid() and parent:get("dead") == 0 and not obj.CommandFinal:find(1) then
		local angle = posToAngle(self.x, self.y, parent.x, parent.y)
		local odir = ac.direction
		local dif = odir - angle
		
		if parent.x < self.x then angle = angle - 360 end
		
		ac.direction = odir + (angleDif(odir, angle) * -0.0135)
		
		if misc.getTimeStop() == 0 then
			if distance(parent.x, parent.y, self.x, self.y) > 500 then
				ac.speed = 2
			else
				ac.speed = 0.8
			end
		else
			ac.speed = 0
		end
		
		local extinctionFriendlyFire = getRule(5, 28)
		
		if global.timer % 2 == 0 then
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - data.range, self.y - data.range, self.x + data.range, self.y + data.range)) do
				if not actor:get("invincible") or actor:get("invincible") <= 0 then
					if extinctionFriendlyFire or not isa(actor, "PlayerInstance") and actor:get("team") ~= parent:get("team") or actor == parent then
						local damage = (((1 + actor:get("maxhp")) / distance(actor.x, actor.y, self.x, self.y)) * 0.55) * (100 / (100 + actor:get("armor")))
						if not isa(actor, "PlayerInstance") or not procShell(actor, damage) then
							actor:set("hp", actor:get("hp") - damage)
							if actor ~= parent and actor:getAlarm(6) then actor:setAlarm(6, 120) end
						end
					end
				end
			end
		end
	else
		self:destroy()
	end
end)
objExtinctionBall:addCallback("draw", function(self)
	local data = self:getData()
	
	graphics.color(Color.WHITE)
	graphics.alpha(0.5)
	graphics.circle(self.x, self.y, (data.range / 3.5) + math.random(20) * 0.2, false)
	
	graphics.color(Color.BLACK)
	if global.quality > 1 then
		graphics.alpha(0.1)
		graphics.circle(self.x, self.y, data.range + math.random(20) * 0.2, false)
	end
	graphics.alpha(0.4)
	graphics.circle(self.x, self.y, (data.range / 1.9) + math.random(20) * 0.2, false)
	graphics.alpha(1)
	graphics.circle(self.x, self.y, (data.range / 4.8) + math.random(20) * 0.2, false)
end)

itRelicExtinction:addCallback("pickup", function(player)
	local data = player:getData()
	local count = player:countItem(itRelicExtinction)
	if not data.relicExtinction or not data.relicExtinction:isValid() then
		data.relicExtinction = objExtinctionBall:create(player.x, -10)
		data.relicExtinction:getData().parent = player
		data.relicExtinction:getData().range = 10 + 20 * math.min(count, 10)
	elseif data.relicExtinction and data.relicExtinction:isValid() then
		data.relicExtinction:getData().range = 10 + 20 * math.min(count, 10)
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	local data = player:getData()
	if item == itRelicExtinction then
		local count = player:countItem(itRelicExtinction)
		if count == 0 then
			local data = player:getData()
			if data.relicExtinction:isValid() then
				data.relicExtinction:destroy()
			end
			data.relicExtinction = nil
		elseif data.relicExtinction and data.relicExtinction:isValid() then
			data.relicExtinction:getData().range = 10 + 20 * math.min(count, 10)
		end
	end
end)
local onPlayerStepCall = function(player)
	local data = player:getData()
	if data.relicExtinction and not data.relicExtinction:isValid() and Stage.getCurrentStage() ~= stg.VoidShop then
		local count = player:countItem(itRelicExtinction)
		data.relicExtinction = objExtinctionBall:create(player.x, -10)
		data.relicExtinction:getData().parent = player
		data.relicExtinction:getData().range = 10 + 20 * math.min(count, 10)
	end
end

itRelicExtinction:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)